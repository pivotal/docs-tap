# Complete blue-green deployment with Contour and PackageInstall

Blue green deployment is an application delivery model that gradually transfers user traffic from one version of an app
to a newer version while both are running in production. This guide will outline how to complete a blue-green
deployment with Packages and PackageInstalls.

## Prerequisites

Complete the guide for [Deploy Package and PackageInstall using FluxCD Kustomization](./delivery-with-flux.hbs.md)

## Changes to original PackageInstall

There are some changes to make to the PackageInstall to enable blue-green deployment for an application, for example if you want to deploy an application called `hello-app` to production, the following steps can be used:

- Create a secret.yml file with a Secret that contains your ytt overlay. For example:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: overlay-secret
  namespace: prod
stringData:
  custom-package-overlay.yml: |
    #@ load("@ytt:overlay", "overlay")

    ---
    apiVersion: projectcontour.io/v1
    kind: HTTPProxy
    metadata:
      name: www
      namespace: prod
    spec:
      virtualhost:
        fqdn: www.hello-app.mycompany.com
      routes:
      - conditions:
        - prefix: /
        services:
        - name: hello-app
          port: 8080
```
- Apply the Secret to your cluster by running:
```sh
kubectl apply -f secret.yml
```
- Update your PackageInstall to include the ext.packaging.carvel.dev/ytt-paths-from-secret-name.x annotation to reference your new overlay Secret. For example:
```yaml
---
apiVersion: packaging.carvel.dev/v1alpha1
kind: PackageInstall
metadata:
  name: hello-app.dev.tap
  namespace: prod
  annotations:
    # secret that contains the overlay to be applied on the package install
    ext.packaging.carvel.dev/ytt-paths-from-secret-name.0: overlay-secret
spec:
  serviceAccountName: default
  packageRef:
    refName: hello-app.dev.tap
    versionSelection:
      constraints: "1.0.0"
  values:
  - secretRef:
      name: hello-app-values
```

Note there is an overlay in this PackageInstall to add a [Contour HTTPProxy](https://projectcontour.io/docs/main/config/fundamentals/) resource to route traffic to the hello-app service from the url www.hello-app.mycompany.com

## Changes to new (green) PackageInstall

Once a new version of the Package is added to the GitOps repo, create a new PackageInstall for version 1.0.1 to enable the blue-green deployment

 - Create a green-secret.yml file with a Secret that contains your ytt overlay, for example:
 ```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: green-overlay-secret
  namespace: prod
stringData:
  custom-package-overlay.yml: |
    #@ load("@ytt:overlay", "overlay")

    #@ kd = overlay.subset({"apiVersion":"apps/v1", "kind": "Deployment"})
    #@ ks = overlay.subset({"apiVersion":"v1", "kind": "Service"})
    #@ ki = overlay.subset({"apiVersion":"networking.k8s.io/v1", "kind": "Ingress"})
    #@ na = overlay.subset({"metadata":{"name":"hello-app"}})

    #@overlay/match by=overlay.and_op(kd, na)
    ---
    metadata:
      #@overlay/replace
      name: hello-app-green

    #@overlay/match by=overlay.and_op(ks, na)
    ---
    metadata:
      #@overlay/replace
      name: hello-app-green

    #@overlay/match by=overlay.and_op(ki, na)
    ---
    metadata:
      #@overlay/replace
      name: hello-app-green

    ---
    apiVersion: projectcontour.io/v1
    kind: HTTPProxy
    metadata:
      name: www
      namespace: prod
    spec:
      virtualhost:
        fqdn: www.hello-app.mycompany.com
      routes:
      - conditions:
        - prefix: /
        services:
        - name: hello-app-green
          port: 8080
          weight: 20
        - name: hello-app
          port: 8080
          weight: 80
 ```
Note this secret does two new things:
  1. Changes the names of the service and deployment that are included in the carvel package to allow for another version of the app to installed in the same namespace
  1. Updates the HTTPProxy to add weighted traffic to each version of the app.

- Apply the secret to your cluster by running:
 ```sh
 kubectl apply -f green-secret.yml
 ```
- Create the params secret for the new PackageInstall
  ```yaml
  ---
  apiVersion: v1
  kind: Secret
  metadata:
    name: green-dev-values
    namespace: prod
  stringData:
    values.yml: |
      ---
      replicas: 2
      hostname: hello-app-green.mycompany.com
  ```
- Apply the param secret to your cluster by running:

 ```sh
 kubectl apply -f green-dev-values.yml
 ```
  - Update your PackageInstall to include the ext.packaging.carvel.dev/ytt-paths-from-secret-name.x annotation to reference your new overlay Secret. For example:
```yaml
---
apiVersion: packaging.carvel.dev/v1alpha1
kind: PackageInstall
metadata:
  name: green.hello-app.dev.tap
  namespace: prod
  annotations:
    ext.packaging.carvel.dev/ytt-paths-from-secret-name.0: green-overlay-secret
spec:
  serviceAccountName: default
  packageRef:
    refName: hello-app.dev.tap
    versionSelection:
      constraints: "1.0.1"
  values:
  - secretRef:
      name: green-dev-values
```

The weights in the HTTPProxy can be updated, by editing the HTTPProxy, as traffic is tested in the new version of the app.

## Delete original app version

Once the new app is ready to handle the complete load and the `-green` version is not required anymore, use the following steps to remove the old version and rename the new version.

- Ensure all the traffic is using the correct version of the app, for example the HTTPProxy
should look similar to the following:
```yaml
apiVersion: projectcontour.io/v1
kind: HTTPProxy
metadata:
  name: www
  namespace: prod
spec:
  virtualhost:
    fqdn: www.hello-app.mycompany.com
  routes:
    - conditions:
      - prefix: /
      services:
        - name: hello-app-green
          port: 8080
          weight: 100 # all traffic routed to the green app
```
- Identify the name of the deployment and service that are part of the PackageInstall you no longer need. Check by running the following command:

```bash
kubectl get PackageInstall --namespace=prod
```

This will display a list of all the deployments and services in the current Kubernetes namespace, along with their current names, for example:
```bash
NAME                     PACKAGE NAME       PACKAGE VERSION      DESCRIPTION
green.hello-app.dev.tap   hello-app.dev.tap   1.0.1            Reconcile succeeded
hello-app.dev.tap         hello-app.dev.tap   1.0.0            Reconcile succeeded

```

- Delete the PackageInstall by running the following command

```bash
kubectl delete PackageInstall hello-app.dev.tap --namespace=prod
```

- Rename the service and deployments back to the name without the green prefix. For example update the overlay secret similar to the following example:
 ```yaml
 ---
apiVersion: v1
kind: Secret
metadata:
  name: overlay-secret
  namespace: prod
stringData:
  custom-package-overlay.yml: |
    #@ load("@ytt:overlay", "overlay")
    #@ load("@ytt:data", "data")

    #@ kd = overlay.subset({"apiVersion":"apps/v1", "kind": "Deployment"})
    #@ ks = overlay.subset({"apiVersion":"v1", "kind": "Service"})
    #@ ki = overlay.subset({"apiVersion":"networking.k8s.io/v1", "kind": "Ingress"})
    #@ na = overlay.subset({"metadata":{"name":"hello-app-green"}})

    #@overlay/match by=overlay.and_op(kd, na)
    ---
    metadata:
      #@overlay/replace
      name: hello-app

    #@overlay/match by=overlay.and_op(ks, na)
    ---
    metadata:
      #@overlay/replace
      name: hello-app

    #@overlay/match by=overlay.and_op(ki, na)
    ---
    metadata:
      #@overlay/replace
      name: hello-app

    ---
    apiVersion: projectcontour.io/v1
    kind: HTTPProxy
    metadata:
      name: www
      namespace: prod
    spec:
      virtualhost:
        fqdn: www.hello-app.mycompany.com
      routes:
      - conditions:
        - prefix: /
        services:
        - name: hello-app
          port: 8080
          weight: 100
 ```
- Update your PackageInstall to include the ext.packaging.carvel.dev/ytt-paths-from-secret-name.x annotation to reference your new overlay Secret. For example:
```yaml
---
apiVersion: packaging.carvel.dev/v1alpha1
kind: PackageInstall
metadata:
  name: green.hello-app.dev.tap
  namespace: prod
  annotations:
    ext.packaging.carvel.dev/ytt-paths-from-secret-name.0: overlay-secret
spec:
  serviceAccountName: default
  packageRef:
    refName: hello-app.dev.tap
    versionSelection:
      constraints: "1.0.1"
  values:
  - secretRef:
      name: hello-app-values
```

## Verify application

- Check name of the deployment and service that are part of the PackageInstall by running the following command:

```bash
kubectl get PackageInstall --namespace=prod
```

This will display a list of all the deployments and services in the current Kubernetes namespace, along with their current names, for example:
```bash
NAME                     PACKAGE NAME       PACKAGE VERSION      DESCRIPTION
hello-app.dev.tap       hello-app.dev.tap     1.0.1            Reconcile succeeded
```

Note the name is back to the original name and the version is `1.0.1`
