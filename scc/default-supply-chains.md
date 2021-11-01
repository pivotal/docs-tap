---
title: Install
subtitle: How to install Cartographer in a Kubernetes cluster
weight: 2
---

# Out of the Box Supply Chains

Out of the Box Supply Chains are provided with Tanzu Application Platform.
The following three supply chains that are included:
- Out of the Box Supply Chain Basic (source-to-url)
- Out of the Box Supply Chain with Testing (source-test-to-url)
- Out of the Box Supply Chain with Testing and Scanning (source-test-scan-to-url)

Tanzu Application Platform also includes:
- Out of the Box Templates

Each of the supply chains use Out of the Box Templates.

Regardless of the supply chain you choose, you need to set credentials for a
registry where Tanzu Build Service should push the images that it builds.

### Credentials for pushing app images to a registry
The supply chain builds a container image based off of the source code and
pushes it to a registry. We need to provide to the systems the credentials for
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
tanzu imagepullsecret add scc-registry-credentials \
  --export-to-all-namespaces \
  --registry $REGISTRY \
  --username $REGISTRY_USERNAME \
  --password $REGISTRY_PASSWORD
```
```console
- Adding image pull secret 'scc-registry-credentials'...
 Added image pull secret 'scc-registry-credentials' into namespace 'default'
```

_ps.: note that the REGISTRY here _must_ be the same as the one set in the
values file during [Install default Supply Chain](./../install-components.md#install-ootb-supply-chain-basic)._


## Out of the Box Supply Chain Basic (source-to-url)

Out of the Box Supply Chain Basic (source-to-url) is the most basic supply chain. This supply chain allows you to:

- Watch a git repository
- Build the code into an image
- Apply some conventions to the K8s YAML
- Deploy the application to the same cluster

![Out of the Box Supply Chain Basic](images/source-to-url.png)


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
  name: scc-registry-credentials
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
                          # for source-to-url, must be "service-account"
secrets:
  - name: scc-registry-credentials
imagePullSecrets:
  - name: scc-registry-credentials
```

3. create the workload

```bash
tanzu apps workload create hello-world \
  --git-branch main \
  --git-repo https://github.com/kontinue/hello-world \
  --type web
```
```console
Create workload:
      1 + |apiVersion: carto.run/v1alpha1
      2 + |kind: Workload
      3 + |metadata:
      4 + |  name: my-workload
      5 + |  namespace: default
      6 + |spec:
      7 + |  source:
      8 + |    git:
      9 + |      ref:
     10 + |        branch: main
     11 + |      url: https://github.com/kontinue/hello-world

? Do you want to create this workload? Yes
Created workload "my-workload"
```

## Out of the Box Supply Chain with Testing (source-test-to-url)

The Out of the Box Supply Chain with Testing (source-test-to-url) includes all abilities of the Out of the Box 
Supply Chain Basic (source-to-url), and the ability to perform testing using Tekton.

![Out of the Box Supply Chain with Testing](images/source-test-to-url.png)


### Example usage

#### Developer Workload

1. Ensure that the supply chain has been installed by running:

```bash
tanzu apps cluster-supply-chain list
```
```console
NAME                 READY   AGE     LABEL SELECTOR
source-test-to-url   Ready   2m20s   apps.tanzu.vmware.com/workload-type=web
```

2. Setup a service account and placeholder secret for registry credentials

```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: scc-registry-credentials
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
                  # installation (defaults to `service-account`)
secrets:
  - name: scc-registry-credentials
imagePullSecrets:
  - name: scc-registry-credentials
```

3. Configure a Tekton pipeline for testing. Run:

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

4. Create a workload that matches the supply chain's selector by running:

```bash
tanzu apps workload create hello-world \
  --git-branch main \
  --git-repo https://github.com/kontinue/hello-world \
  --param tekton-pipeline-name=developer-defined-tekton-pipeline \
  --type web-test
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

5. Observe that you progressed from source code to a deployed application by running:

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

## Out of the Box Supply Chain with Testing and Scanning (source-test-scan-to-url)

The Out of the Box Supply Chain with Testing and Scanning (source-test-scan-to-url) includes the abilities of the Out of the Box 
Supply Chain with Testing (source-test-to-url), and adds source and image scanning using Grype.

Supply Chain with Testing and Scanning (source-test-scan-to-url) includes the following abilities:
- Watch a git repository
- Run tests using Tekton
- Scan the code for known vulnerabilities
- Build the code into an image
- Scan the image for known vulnerabilities
- Apply some conventions to the K8s YAML
- Deploy the application to the same cluster

![Out of the Box Supply Chain with Testing and Scanning](images/source-test-scan-to-url.png)


### Example usage

This example builds on the previous supply chain examples, so refer to them for details about those parts (Test, TBS etc). 
In particular, this example adds Source and Image Scanning capabilities.

#### Tanzu Supply Chain Security Tools - Scan cluster objects

The notable addition is a Scan Policy, which enables policy enforcement on vulnerabilities found. 

1. Add a scan policy

```yaml
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
kind: ScanPolicy
metadata:
  name: scan-policy
spec:
  regoFile: |
    package policies

    default isCompliant = false

    # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "UnknownSeverity"
    violatingSeverities := ["Critical","High","UnknownSeverity"]
    ignoreCVEs := []

    contains(array, elem) = true {
      array[_] = elem
    } else = false { true }

    isSafe(match) {
      fails := contains(violatingSeverities, match.Ratings.Rating[_].Severity)
      not fails
    }

    isSafe(match) {
      ignore := contains(ignoreCVEs, match.Id)
      ignore
    }

    isCompliant = isSafe(input.currentVulnerability)
```

2. Add a source scan template
```yaml
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
kind: ScanTemplate
metadata:
  name: blob-source-scan-template
spec:
  template:
    containers:
    - args:
      - -c
      - ./source/scan-source.sh /workspace/source scan.xml
      command:
      - /bin/bash
      image: registry.tanzu.vmware.com/supply-chain-security-tools/grype-templates-image@sha256:36d947257ffd5d962d09e61dc9083f5d0db57dbbde5f5d7c7cd91caa323a2c43
      imagePullPolicy: IfNotPresent
      name: scanner
      resources:
        limits:
          cpu: 1000m
        requests:
          cpu: 250m
          memory: 128Mi
      volumeMounts:
      - mountPath: /workspace
        name: workspace
        readOnly: false
    imagePullSecrets:
    - name: image-secret
    initContainers:
    - args:
      - -c
      - ./source/untar-gitrepository.sh $REPOSITORY /workspace
      command:
      - /bin/bash
      image: registry.tanzu.vmware.com/supply-chain-security-tools/grype-templates-image@sha256:36d947257ffd5d962d09e61dc9083f5d0db57dbbde5f5d7c7cd91caa323a2c43
      imagePullPolicy: IfNotPresent
      name: repo
      volumeMounts:
      - mountPath: /workspace
        name: workspace
        readOnly: false
    restartPolicy: Never
    volumes:
    - emptyDir: {}
      name: workspace
```
3. Add an image scan template
```yaml
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
kind: ScanTemplate
metadata:
  name: private-image-scan-template
spec:
  template:
    containers:
    - args:
      - -c
      - ./image/copy-docker-config.sh /secret-data && ./image/scan-image.sh /workspace
        scan.xml true
      command:
      - /bin/bash
      image: registry.tanzu.vmware.com/supply-chain-security-tools/grype-templates-image@sha256:36d947257ffd5d962d09e61dc9083f5d0db57dbbde5f5d7c7cd91caa323a2c43
      imagePullPolicy: IfNotPresent
      name: scanner
      resources:
        limits:
          cpu: 1000m
        requests:
          cpu: 250m
          memory: 128Mi
      volumeMounts:
      - mountPath: /.docker
        name: docker
        readOnly: false
      - mountPath: /workspace
        name: workspace
        readOnly: false
      - mountPath: /secret-data
        name: registry-cred
        readOnly: true
    imagePullSecrets:
    - name: image-secret
    restartPolicy: Never
    volumes:
    - emptyDir: {}
      name: docker
    - emptyDir: {}
      name: workspace
    - name: registry-cred
      secret:
        secretName: image-secret

```

#### Developer Workload
1. The next step would be to then submit a workload like in the other examples:
```bash
tanzu apps workload create hello-world \
--git-branch main \
--git-repo https://github.com/kontinue/hello-world \
--param tekton-pipeline-name=developer-defined-tekton-pipeline \
--type web-scan
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
