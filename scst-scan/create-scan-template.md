# Create a ScanTemplate

The `ScanTemplate` custom resource (CR) is the component that defines how the scan Pod fulfills the task of vulnerability scanning. There are  default `ScanTemplates` provided out-of-the-box using the Tanzu Application Platform default scanner `Anchore's Grype`. The scan is done by using stages sequentially run on the scanning Pod. At the end a single container on the scan Pod called `summary` combines the result of the initContainers and the controller to discover and update `Scan CR` status.

## <a id="structure"></a>Structure

```console
apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
kind: ScanTemplate
spec:
    template:
      # Here are list volumes mounted for writing to or 
      # reading from during different stages of the scan
      volumes:
        # required the results of different scan stages 
        # should be saved in files digestible by the scan 
        # controller in this volume
        - name: workspace
        emptyDir: { }
      # different steps required for a scanning can be staged 
      # in sequential stages through initContainers. 
      initContainers:
      # Summary container will take results of initContainers 
      # and will let Controller to update Scan CR status.
      containers:
        - name: summary
```

## <a id="summary-container"></a>Summary Container

Scanning stages are required to write structured output to a specified file location in the workspace in the form of `/${WORKSPACE_PATH}/${STAGE_NAME}/out.yaml` (in the earlier example of a typical `ScanTemplates` the `${WORKSPACE_PATH}` is `workspace`). Individual stages can only populate a subset of the model depending on the nature of the stage. `Summary container` consumes and aggregates the outputs of the previous stages. And finally the controller consumes this aggregated information to populate and update the status of the `Scan CRs`.

Below the general format of final aggregated `Output Model` and some examples of typical subsets provided by individual stages of scan are shown:

1. General form of scan Output Model:
```yaml
fetch:
  git: 
    url:
    revision:
    path:
  blob:
    url:
    revision:
    path:
  image:
    url:
    revision:
    path:
sbom:
    packageCount:
    reports: []
scan:
  cveCount:
    critical:
    high:
    medium:
    low:
    unknown:
  scanner:
    name:
    vendor:
    version:
    db:
      version:
  reports: []
eval:
  violations: []
store:
  locations: []
```

The `scan` portion of the earlier output is required and if missing the scan controller fails to properly update final status of the `Scan CR`. Other portions of the output including those of `store` and `policy evaluation` are optional and can be omitted, if not applicable in a custom supply chain setup.

2. Examples of sample subset outputs:

```yaml
# example for a typical git clone (source scan fetch stage)
# saved at: /workspace/git-clone/out.yaml
fetch:
  git:
    url: github.com/my/repo
    revision: aee9f8
    path: /workspace/git-clone/cloned-repository
```
```yaml
# an example of typical scan stage
# saved at: /workspace/grype-scan/out.yaml
scan:
  cveCount:
    critical: 0
    high: 1
    medium: 3
    low: 25
    unknown: 0
  scanner:
    name: grype
    vendor: Anchore
    version: 0.33.0
    db:
      version: 2022-04-13
  reports:
  - /workspace/grype-scan/repo.cyclonedx.xml
  - /workspace/grype-scan/app.cyclonedx.xml
  - /workspace/grype-scan/base.cyclonedx.xml
```
```yaml
# example of a typical evaluation stage
# saved at: /workspace/policy-eval/out.yaml
eval:
  violations:
    - banned package log4j
    - critical CVE 2022-01-01-3333
    - number of critical CVEs over threshold
```
```yaml
# example of a typical upload to store stage
# saved at: /workspace/upload-to-store/out.yaml
store:
  locations:
    - http://metadata-store.cluster.local:8080/reports/3
```