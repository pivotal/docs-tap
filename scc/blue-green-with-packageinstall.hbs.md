# Using blue-green deployment with Contour and PackageInstall

There are some changes to make to the PackageInstall to enable blue-green deployment for an application, for example if you want to
deploy an application called `hello-app` to production, the following steps can be used:

Assuming the a carvel package is already generted by running a workload for `hello-app` with `carvel-package-workflow-enabled`.

Install the app by creating a PackageInstall similar to the following example:

```yaml
---
apiVersion: packaging.carvel.dev/v1alpha1
kind: PackageInstall
metadata:
  name: hello-app.dev.tap
  namespace: prod
  annotations:
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
---
apiVersion: v1
kind: Secret
metadata:
  name: hello-app-values
  namespace: prod
stringData:
  values.yml: |
    ---
    replicas: 2
    hostname: hello-app.mycompany.com

---
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

Note there is an overlay in this PackageInstall to add a [Contour HTTPProxy](https://projectcontour.io/docs/main/config/fundamentals/) resource to route traffic to the hello-app service from the url www.hello-app.mycompany.com

Now we need to install new version of the app using blue-green deployment strategy to make sure the new version is working as expected before rolling it out.

Create a workload to get the new package and deploy it the cluster
Now the PackageInstall for version 1.0.1 will be a little different to enable the blue-green deployment

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

This new PackageInstall does two new things:
 - Changes the names of the service and deployment that are included in the carvel package to allow for another version of the app to installed in the same namespace
 - Updates the HTTPProxy to add weighted traffic to each version of the app.

The weights in the HTTPProxy can be manually updated as traffic is tested in the new version of the app.

Once the new app is ready to handle the complete load and the -green version is not required anymore, we can use the following steps to remove the old version and rename the new version

First, we need to identify the name of the deployment and service that are part of the PackageInstall we no longer need. We can do this by running the following command:

```bash
kubectl get PackageInstall --namespace=prod
```

This will display a list of all the deployments and services in the current Kubernetes namespace, along with their current names, for example:
```bash
NAME                     PACKAGE NAME       PACKAGE VERSION      DESCRIPTION
green.hello-app.dev.tap   helloapp.dev.tap   1.0.1            Reconcile succeeded
hello-app.dev.tap         helloapp.dev.tap   1.0.0            Reconcile succeeded

```


Now, we need to rename the delete the hello-app PackageInstall, but first we need to make sure the HTTPProxy is not routing traffic to the service that is about to be removed, for example:

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
          weight: 100

```


We can delete the PackageInstall by running the following command

```bash
kubectl delete PackageInstall hello-app.dev.tap --namespace=prod
```

Finally, apply the following overlay to the green.hello-app.dev.tap` to rename the service and deployments back to the name without the green prefix. We can do this by changing the packageinstll.yaml and applying it again

```yaml
---
apiVersion: packaging.carvel.dev/v1alpha1
kind: PackageInstall
metadata:
  name: green.helloapp.dev.tap
  namespace: prod
  annotations:
    ext.packaging.carvel.dev/ytt-paths-from-secret-name.0: overlay-secret
spec:
  serviceAccountName: default
  packageRef:
    refName: helloapp.dev.tap
    versionSelection:
      constraints: "1.0.1"
  values:
  - secretRef:
      name: hello-app-values
---
apiVersion: v1
kind: Secret
metadata:
  name: hello-app-values
  namespace: prod
stringData:
  values.yml: |
    ---
    replicas: 2
    hostname: hello-app.mycompany.com

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
    #@ na = overlay.subset({"metadata":{"name":"helloapp-green"}})

    #@overlay/match by=overlay.and_op(kd, na)
    ---
    metadata:
      #@overlay/replace
      name: helloapp

    #@overlay/match by=overlay.and_op(ks, na)
    ---
    metadata:
      #@overlay/replace
      name: helloapp

    #@overlay/match by=overlay.and_op(ki, na)
    ---
    metadata:
      #@overlay/replace
      name: helloapp

    ---
    apiVersion: projectcontour.io/v1
    kind: HTTPProxy
    metadata:
      name: www
      namespace: prod
    spec:
      virtualhost:
        fqdn: www.hello-app.mycountry.com
      routes:
      - conditions:
        - prefix: /
        services:
        - name: helloapp
          port: 8080
          weight: 100

```
