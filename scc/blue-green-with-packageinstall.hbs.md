# Use blue-green deployment with Contour and PackageInstall (alpha)

Blue-green deployment is an application delivery model that gradually transfers
user traffic from one version of an app to a later version while both are
running in production. This guide outlines how to use blue-green
deployment with Packages and PackageInstalls.

## Prerequisites

To use blue-green deployment, you must complete the following prerequisites:

- Complete the prerequesites listed in [Configure and deploy to multiple environments with custom parameters](./config-deploy-multi-env.hbs.md).
- Configure Carvel for your supply chain. See [Carvel Package Supply Chains (alpha)](./carvel-package-supply-chain.hbs.md).
- Configure FluxCD for your supply chains. See [Deploy Package and PackageInstall using FluxCD Kustomization](./delivery-with-flux.hbs.md).

## Add HTTPProxy to the Blue Deployment

With the assumption that there is an application called `hello-app` deployed to production using Carvel Package and PackageInstall,

1. Create a [Contour HTTPProxy](https://projectcontour.io/docs/main/config/fundamentals/) resource to route traffic to the `hello-app` service from the URL www.hello-app.mycompany.com.
for example:

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
      - name: hello-app
        port: 8080
```
 >**Note** The services names used in HTTPProxy has to match the names of exisitng serviecs. In this case, the name
 `hello-app` matches the service installed by the PackageInstall

2. Apply the HTTPProxy to your cluster:

```console
  kubectl apply -f httpproxy.yaml
```

3. Verify the HTTPProxy is created and the rotue is serving traffic to your app

```console
  kubectl get HTTPProxy --namespace=prod
```
  This displays a list of all the HTTPproxy in the current namespace with their current names. For example:

```console
NAMESPACE        NAME                     FQDN                                  TLS SECRET            STATUS    STATUS DESCRIPTION
prod             www                      www.hello-app.mycompany.com          hello-app-cert        valid     Valid HTTPProxy
```

## Create the Green Deployment

After a new version of the package is added to the GitOps repository, create a new PackageInstall for v1.0.1 to enable the blue-green deployment:

1. Create a green-secret.yaml file with a secret that contains your ytt overlay. For example:

```yaml
  ---
  apiVersion: v1
  kind: Secret
  metadata:
    name: green-overlay-secret
    namespace: prod
  stringData:
    custom-package-overlay.yaml: |
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
```

  This secret changes the names of the service and deployment in the carvel package to
    allow you to install another version of the app in the same namespace.

2. Apply the secret to your cluster by running:

```console
  kubectl apply -f green-secret.yaml
```

3. Create a parameter secret for the new PackageInstall:

```yaml
  ---
  apiVersion: v1
  kind: Secret
  metadata:
    name: green-dev-values
    namespace: prod
  stringData:
    values.yaml: |
      ---
      replicas: 2
      hostname: hello-app-green.mycompany.com
```

4. Apply the parameter secret to your cluster by running:

```console
  kubectl apply -f green-dev-values.yaml
```

5. Create a PackageInstall to include the `ext.packaging.carvel.dev/ytt-paths-from-secret-name.x` annotation to reference your new overlay secret. For example:

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

## Practicing Blue-Green Deployment

1. Update the HTTPproxy created with the blue deployment to route traffic to both the blue and green deployments.
The names of the services must match the names of the already created services.

```yaml
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

2. You can update the weights of traffic for each service by editing the HTTPProxy

3. Access the service several times and confirm both versions are serving traffic in the same percentage as expected.

```console
  curl -k https://www.hello-app.mycompany.com
```

4. After the new (green) app is ready to handle the complete load and the `-green` version is not required, use the following steps to remove the old version and rename the new version.

5. Ensure that all the traffic is using the correct version of the app. For example, the HTTPProxy looks similar to the following:

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

6. Identify the name of the deployment and service that are part of the PackageInstall you no longer need:

```console
  kubectl get PackageInstall --namespace=prod
```

  This displays a list of all the deployments and services in the current
  Kubernetes namespace, with their current names. For example:

```console
  NAME                     PACKAGE NAME       PACKAGE VERSION      DESCRIPTION
  green.hello-app.dev.tap   hello-app.dev.tap   1.0.1            Reconcile succeeded
  hello-app.dev.tap         hello-app.dev.tap   1.0.0            Reconcile succeeded

```

7. Delete the PackageInstall:

```console
  kubectl delete PackageInstall hello-app.dev.tap --namespace=prod
```

8. Rename the service and deployments without the green prefix. For example, update the overlay secret:

```yaml
  ---
  apiVersion: v1
  kind: Secret
  metadata:
    name: overlay-secret
    namespace: prod
  stringData:
    custom-package-overlay.yaml: |
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
```

9. Update your PackageInstall to include the
   `ext.packaging.carvel.dev/ytt-paths-from-secret-name.x` annotation to
   reference your new overlay secret. For example:

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

To verify the name of the deployment and service that are part of the PackageInstall:

1. Verify your application by running:

```console
  kubectl get PackageInstall --namespace=prod
```

  This displays a list of all the deployments and services in the current
  Kubernetes namespace with their current names. For example:

```console
  NAME                     PACKAGE NAME       PACKAGE VERSION      DESCRIPTION
  hello-app.dev.tap       hello-app.dev.tap     1.0.1            Reconcile succeeded
```

  The name is back to the original name and the version is `1.0.1`.
