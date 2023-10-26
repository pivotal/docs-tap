
# Configure an ImageVulnerabilityScan for Snyk

This topic gives you an example of how to configure a secret and ImageVulnerabilityScan (IVS) for Snyk.

## <a id="secret-example"></a> Example Secret

This section contains a sample secret containing the Snyk API token, which is used to authenticate
your Snyk account. You must apply this once to your developer namespace.

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

- `SNYK-API-TOKEN` is your Snyk API token obtained by following the instructions in the
  [Snyk documentation](https://docs.snyk.io/snyk-cli/authenticate-the-cli-with-your-account).
  Do not base64 encode this value.

## <a id="example"></a> Example ImageVulnerabilityScan

This section contains a sample IVS that uses Snyk to scan a targeted image and push the results to
the specified registry location.
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
    command: ["snyk","container","test",$(params.image),"--json-file-output=scan-results/scan.json"]
    onError: continue
  - name: snyk2spdx # You will need to create your own image. See explanation below.
    image: SNYK2SPDX-IMAGE
    command:
    ....
```

Where:

- `TARGET-IMAGE` is the image to be scanned. You must specify the digest.
- `SNYK-SCANNER-IMAGE` is the image containing the Snyk CLI. For example, `snyk/snyk:golang`.
  For information about publicly available Snyk images, see [DockerHub](https://hub.docker.com/r/snyk/snyk).
  For more information about using the Snyk CLI, see the [Snyk documentation](https://docs.snyk.io/snyk-cli).
- `XDG_CONFIG_HOME` is the directory that contains your Snyk CLI config file, `configstore/snyk.json`,
  which is populated using the snyk-token `Secret` you created.
  For more information, see the [Snyk Config documentation](https://docs.snyk.io/snyk-cli/commands/config).
- `SNYK2SPDX-IMAGE` is the image used to convert the Snyk CLI output `scan.json` in the `snyk` step
  to SPDX format and have its missing `DOCUMENT DESCRIBES` relation inserted.
  See the Snyk [snyk2spdx repository](https://github.com/snyk-tech-services/snyk2spdx) in GitHub.

> **Note** After detecting vulnerabilities, the Snyk image exits with Exit Code 1 and causes a failed
> scan task. You can ignore the step error by setting `onError` and handling the error in a subsequent
> step. For instructions, see the [Tekton documentation](https://tekton.dev/docs/pipelines/tasks/#specifying-onerror-for-a-step)

For information about setting up scanner credentials, see the [Snyk CLI documentation](https://docs.snyk.io/snyk-cli/commands/config).

### <a id="disclaimer"></a> Disclaimer

For the publicly available Snyk scanner CLI image, CLI commands and parameters used are accurate at
the time of documentation.
