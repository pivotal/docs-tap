# Configure custom ImageVulnerabilityScan samples

This topic lists out sample ImageVulnerabilityScans utilizing various scanners and associated secrets. The following samples provide a scaffold for you to use with the below scanners:
- Carbon Black
- Snyk

For more information on integrating your own scanner see [Integrate your own scanner](./app-scanning-alpha.hbs.md#integrate-your-own-scanner)

### <a id="general-usage-instructions"></a>General usage instructions
To use one of the provided samples, you will need to:
1. Copy the sample yaml into a file named `custom-ivs.yaml`.
1. Obtain the necessary image(s) (e.g. an image containing the scanner).
1. Modify these common fields of your ImageVulnerabilityScan:
   - `spec.image` is the image that you are scanning.
   - `scanResults.location` is the registry URL where results are uploaded (e.g. `my.registry/scan-results`).
   - `serviceAccountNames` includes:
     - `scanner` is the service account that runs the scan. It must have read access to `image`.
     - `publisher` is the service account that uploads results. It must have write access to `scanResults.location`.
1. Complete any scanner specific changes as specified in the sample.
1. You can now either incorporate your custom ImageVulnerabilityScan into a [ClusterImageTemplate](./clusterimagetemplates.hbs.md) or run a standalone scan using:
  ```console
  kubectl apply -f custom-ivs.yaml -n DEV-NAMESPACE
  ```
  Where `DEV-NAMESPACE` is the name of the developer namespace where scanning occurs.


### <a id="ivs-cbc"></a>Configure a ImageVulnerabilityScan for Carbon Black

The Carbon Black CLI uses the `cbctl.yaml` config file. The `cbctl.yaml` config file must include your Carbon Black `cbctl-creds` secret and credentials.

See the [Carbon Black](https://developer.carbonblack.com/reference/carbon-black-cloud/container/latest/image-scanning-cli#configuration) documentation.

To mount the `cbctl-creds` as a workspace binding, use the following ImageVulnerabilityScan configuration:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: cbctl-creds
stringData:
  cbctl: |
    cb_api_id: CB-API-ID
    cb_api_key: CB-API-KEY
    org_key: ORG-KEY
    saas_url: SAAS-URL
---
apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
kind: ImageVulnerabilityScan
metadata:
  name: carbon-black-ivs
spec:
  image: harbor-repo.vmware.com/dockerhub-proxy-cache/library/nginx@sha256:6650513efd1d27c1f8a5351cbd33edf85cc7e0d9d0fcb4ffb23d8fa89b601ba8
  scanResults:
    location: registry/project/scan-results
  serviceAccountNames:
    publisher: publisher
    scanner: scanner
  workspace:
    bindings:
    - name: cbctl
      secret:
        secretName: cbctl-creds
        items:
          - key: cbctl
            path: .cbctl.yaml
  steps:
  - name: carbon-black
    image: CARBON-BLACK-SCANNER-IMAGE
    imagePullPolicy: IfNotPresent
    command:
    - bash
    args:
    - -c
    - cbctl --config /cbctl/.cbctl.yaml image scan --force=true $(params.image) -o
      cyclonedx > scan.cdx.xml
```

Where:

- `CB-API-ID` is the API ID obtained from VMware Carbon Black Cloud (CBC).
- `CB-API-KEY` is the API Key obtained from CBC.
- `ORG-KEY` is the Org Key for your CBC organization.
- `SAAS-URL` is the CBC Backend URL.

**Note:**
- The Carbon Black `cbctl-creds` secret is mounted as a workspace binding and the credentials get inserted into a `cbctl.yaml` config file that the Carbon Black CLI utilizes. See [here](https://developer.carbonblack.com/reference/carbon-black-cloud/container/latest/image-scanning-cli#configuration)

### <a id="ivs-snyk"></a>Configure a ImageVulnerabilityScan for Snyk
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: snyk-token
stringData:
  snyk: |
    {"api": "SNYK-API-TOKEN"}
---
apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
kind: ImageVulnerabilityScan
metadata:
  name: snyk-ivs
spec:
  image: harbor-repo.vmware.com/dockerhub-proxy-cache/library/nginx@sha256:6650513efd1d27c1f8a5351cbd33edf85cc7e0d9d0fcb4ffb23d8fa89b601ba8
  scanResults:
    location: registry/project/scan-results
  serviceAccountNames:
    publisher: publisher
    scanner: scanner
  workspace:
    bindings:
    - name: snyk
      secret:
        secretName: snyk-token
        items:
          - key: snyk
            path: configstore/snyk.json
  steps:
  - name: snyk
    image: SNYK-SCANNER-IMAGE
    env:
    - name: XDG_CONFIG_HOME
      value: /snyk
    command: ["snyk","container","test",$(params.image),"--json-file-output=scan.json"]
    onError: continue
  - name: snyk2spdx # You will need to create your own image. See explanation below.
    image: SNYK2SPDX-IMAGE
    command:
    ....
```

Where:

- `SNYK-API-TOKEN` is your Snyk API Token obtained from the [Snyk documentation](https://docs.snyk.io/snyk-cli/authenticate-the-cli-with-your-account).
- `SNYK-SCANNER-IMAGE` is the Snyk Scanner image used to run Snyk scans. See [Snyk documentation](https://github.com/snyk/snyk-images) for Snyk Docker images.
- `SNYK2SPDX-IMAGE` is the image used to convert the Snyk CLI output `scan.json` in the `snyk` step to SPDX format and have its missing `DOCUMENT DESCRIBES` relation inserted. View the Snyk [snyk2spdx repository](https://github.com/snyk-tech-services/snyk2spdx) for more details.

> **Note:** After detecting vulnerabilities the Snyk docker images will terminate with Exit Code 1 resulting in a failed scan task. A possible solution could be to ignore the step error by setting [onError](https://tekton.dev/docs/pipelines/tasks/#specifying-onerror-for-a-step) and handling the error in a subsequent step.

See the [Snyk CLI documentation](https://docs.snyk.io/snyk-cli/commands/config) for more information on setting up scanner credentials.
