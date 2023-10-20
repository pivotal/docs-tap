
# Configure an ImageVulnerabilityScan for Snyk

This topic tells you how to configure a Secret and ImageVulnerabilityScan for Snyk.

## <a id="secret-example"></a> Example Secret
This section gives you an example Secret containing the Snyk API Token used to authenticate your Snyk Account. You will only need to apply this once to your developer namespace.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: snyk-token
stringData:
  snyk: |
    {"api": "SNYK-API-TOKEN"}
```

Where:

- `SNYK-API-TOKEN` is your Snyk API Token obtained from the [Snyk documentation](https://docs.snyk.io/snyk-cli/authenticate-the-cli-with-your-account).

## <a id="example"></a> Example ImageVulnerabilityScan
This section gives you an example IVS that uses Snyk to scan a targeted image and push the results to the specified registry location.
For information about the IVS specification, see [Configuration Options](ivs-create-your-own.hbs.md#img-vuln-config-options).
```yaml
apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
kind: ImageVulnerabilityScan
metadata:
  name: snyk-ivs
  annotations:
    app-scanning.apps.tanzu.vmware.com/scanner-name: Snyk
spec:
  image: TARGET-IMAGE
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

- `TARGET-IMAGE` is the image to be scanned.  Digest must be specified.
- `SNYK-SCANNER-IMAGE` is the Snyk Scanner image used to run Snyk scans. See [Snyk documentation](https://github.com/snyk/snyk-images) for Snyk images.
- `XDG_CONFIG_HOME` is the directory that contains your Snyk CLI config file (configstore/snyk.json) which is populated using the snyk-token `Secret` you created. See [Snyk Config documentation](https://docs.snyk.io/snyk-cli/commands/config) for more detail.
- `SNYK2SPDX-IMAGE` is the image used to convert the Snyk CLI output `scan.json` in the `snyk` step to SPDX format and have its missing `DOCUMENT DESCRIBES` relation inserted. See the Snyk [snyk2spdx repository](https://github.com/snyk-tech-services/snyk2spdx).

> **Note** After detecting vulnerabilities, the Snyk image exits with Exit Code 1 and causes a failed scan task. You can ignore the step error by setting [onError](https://tekton.dev/docs/pipelines/tasks/#specifying-onerror-for-a-step) and handling the error in a subsequent step.

For information about setting up scanner credentials, see the [Snyk CLI documentation](https://docs.snyk.io/snyk-cli/commands/config).

### <a id="disclaimer"></a> Disclaimer
For the publicly available Snyk scanner CLI image, CLI commands and parameters used are accurate at the time of documentation.