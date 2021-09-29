---
title: Install
subtitle: How to install Cartographer in a Kubernetes cluster
weight: 2
---

# Default Supply Chains

Default supply chains are provided out of the box with Tanzu Application
Platform. The two default supply chains that are included are:

- Source to URL
- Source & Test to URL

Regardless of the supply chain chosen, we need to first set credentials for a
registry where Tanzu Build Service should push the images that it builds.


### Credentials for pushing app images to a registry

As the supply chain builds a container image based of the source code and
pushes it to a registry, we need to provide to the systems the credentials for
doing so.

Using the `imagepullsecret` command from the [tanzu cli] we're able to
provision a base secret that contains such credentials and then export the
contents of that secret to the namespaces where it should be consumed.


```bash
# define details about the registry that we want to create a secret
# with the credentials to be exposed to cluster components and the
# supplychain.
#
#
REGISTRY=10.188.0.3:5000
REGISTRY_USERNAME=admin
REGISTRY_PASSWORD=admin


# create a Secret object using the `dockerconfigjson` format using the
# credentials provided, then a SecretExport (`secretgen-controller`
# resource) so that it gets exported to all namespaces where a
# placeholder secret can be found.
#
#
tanzu imagepullsecret add registry-credentials \
  --export-to-all-namespaces \
  --registry $REGISTRY \
  --username $REGISTRY_USERNAME \
  --password $REGISTRY_PASSWORD
```
```console
- Adding image pull secret 'registry-credentials'...
 Added image pull secret 'registry-credentials' into namespace 'default'
```

_ps.: note that the REGISTRY here _must_ be the same as the one set in the
values file above._


## Source to URL

Source to URL is the most basic supply chain allowing you to:

- Watch a git repository
- Build the code into an image
- Apply some conventions to the K8s YAML
- Deploy the application to the same cluster

![Source to URL Supply Chain](images/source-to-url.png)


### Example usage

1. ensure that the supply chain has been installed

```bash
tanzu apps cluster-supply-chain list
```
```console
NAME              READY   AGE     LABEL SELECTOR
source-to-url     Ready   2m20s   apps.tanzu.vmware.com/workload-type=web
```


2. setup a service account and placeholder secret for registry credentials

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: registry-credentials
  annotations:
    secretgen.carvel.dev/image-pull-secret: ""
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: e30K

---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: default   # must match the name configured in the supply chain
                  # installation (defaults to `default`)
secrets:
  - name: registry-credentials
imagePullSecrets:
  - name: registry-credentials
```

3. create the workload

```bash
tanzu workload create ... ?
```
```console
?
```


## Source & Test to URL

The source & test to URL supply chain builds on the ability of the source to
url supply chain and adds the ability to perform testing using Tekton.

![Source Test to URL](images/source-test-to-url.png)


### Example usage

#### Developer Workload

1. ensure that the supply chain has been installed

```bash
tanzu apps cluster-supply-chain list
```
```console
NAME                 READY   AGE     LABEL SELECTOR
source-test-to-url   Ready   2m20s   apps.tanzu.vmware.com/workload-type=web
```

2. setup a service account and placeholder secret for registry credentials

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: registry-credentials
  annotations:
    secretgen.carvel.dev/image-pull-secret: ""
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: e30K

---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: default   # must match the name configured in the supply chain
                  # installation (defaults to `default`)
secrets:
  - name: registry-credentials
imagePullSecrets:
  - name: registry-credentials
```

2. configure a Tekton pipeline for running the tests

```yaml
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: developer-defined-tekton-pipeline
spec:
  params:
    - name: source-url
    - name: source-revision
  tasks:
    - name: test
      params:
        - name: source-url
          value: $(params.source-url)
        - name: source-revision
          value: $(params.source-revision)
      taskSpec:
        params:
          - name: source-url
          - name: source-revision
        steps:
          - name: test
            image: golang
            script: |-
              cd `mktemp -d`

              wget -qO- $(params.source-url) | tar xvz
              go test -v ./...
```


3. submit a workload

```bash
tanzu apps workload create hello-world \
	--label apps.tanzu.vmware.com/workload-type=web \
  --git-branch main \
  --git-repo https://github.com/kontinue/hello-world \
  --param tekton-pipeline-name=developer-defined-tekton-pipeline
```
```console
Create workload:
      1 + |apiVersion: carto.run/v1alpha1
      2 + |kind: Workload
      3 + |metadata:
      4 + |  name: my-workload
      5 + |  namespace: default
      6 + |spec:
      7 + |  params:
      8 + |  - name: tekton-pipeline-name
      9 + |    value: developer-defined-tekton-pipeline
     10 + |  source:
     11 + |    git:
     12 + |      ref:
     13 + |        branch: main
     14 + |      url: https://github.com/kontinue/hello-world

? Do you want to create this workload? Yes
Created workload "my-workload"
```

4. observe that we went from source code to a deployed application

```bash
kubectl get workload,gitrepository,pipelinerun,images.kpack,podintent,app,services.serving
```
```console
NAME                             AGE
workload.carto.run/hello-world   3m11s

NAME                                                 URL                                       READY   STATUS                                                            AGE
gitrepository.source.toolkit.fluxcd.io/hello-world   https://github.com/kontinue/hello-world   True    Fetched revision: main/3d42c19a618bb8fc13f72178b8b5e214a2f989c4   3m9s

NAME                                       SUCCEEDED   REASON      STARTTIME   COMPLETIONTIME
pipelinerun.tekton.dev/hello-world-pvmjx   True        Succeeded   3m4s        2m36s

NAME                         LATESTIMAGE                                                                                               READY
image.kpack.io/hello-world   10.188.0.3:5000/foo/hello-world@sha256:efe687cee98b47e8def40361017b8823fcf669298b1b95f2a3806858b65545b5   True

NAME                                                      READY   REASON   AGE
podintent.conventions.apps.tanzu.vmware.com/hello-world   True             85s

NAME                                                    DESCRIPTION           SINCE-DEPLOY   AGE
app.kappctrl.k14s.io/cartographer.carto.run.0.0.0-dev   Reconcile succeeded   31s            16m
app.kappctrl.k14s.io/convention-controller              Reconcile succeeded   17s            119s
app.kappctrl.k14s.io/hello-world                        Reconcile succeeded   2s             79s

NAME                                      URL                                      LATESTCREATED       LATESTREADY         READY     REASON
service.serving.knative.dev/hello-world   http://hello-world.default.example.com   hello-world-00001   hello-world-00001   Unknown   IngressNotConfigured
```
