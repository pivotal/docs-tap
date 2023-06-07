# Custom ImageVulnerabilityScan Samples

This topic lists out ImageVulnerabilityScan Sample for running CarbonBlack scan.

## ImageVulnerabilityScan Carbon Black Sample

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
  name: carbon-black
  namespace: DEV-NAMESPACE
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

- `CB-API-ID` is the API ID obtained from CBC.
- `CB-API-KEY` is the API Key obtained from CBC.
- `ORG-KEY` is the Org Key of your CBC organization.
- `SAAS-URL` is the CBC Backend URL.
- `DEV-NAMESPACE` is the name of the developer namespace where scanning occurs.
- scanResults.location is the registry URL where results are uploaded. For example, my.registry/scan-results.
- `serviceAccountNames` includes:
  - `scanner` is the service account that runs the scan. It must have read access to `image`.
  - `publisher` is the service account that uploads results. It must have write access to `scanResults.location`.
- `CARBON-BLACK-SCANNER-IMAGE` is the Carbon Black Scanner image used to run Carbon Black scans.

**Note:**
- The Carbon Black `cbctl-creds` secret is mounted as a workspace binding and the credentials get inserted into a `cbctl.yaml` config file that the Carbon Black CLI utilizes. See [here](https://developer.carbonblack.com/reference/carbon-black-cloud/container/latest/image-scanning-cli#configuration)
