# Configure a ImageVulnerabilityScan for Carbon Black

This topic gives you an example of how to configure a secret and ImageVulnerabilityScan (IVS) for Carbon Black.

## <a id="secret-example"></a> Example secret

This section contains a sample secret containing the Carbon Black credentials inside the `~/.cbctl/cbctl.yaml` config file which are used to authenticate your Carbon Black Account and you can find it in the Carbon Black console. See the [Carbon Black documentation](https://developer.carbonblack.com/reference/carbon-black-cloud/container/latest/image-scanning-cli#configuration). You must apply this once to your developer namespace.

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
```

Where:

- `CB-API-ID` is the API ID obtained from Carbon Black Cloud.
- `CB-API-KEY` is the API Key obtained from Carbon Black.
- `ORG-KEY` is the Org Key for your Carbon Black organization.
- `SAAS-URL` is the Carbon Black Backend URL.

## <a id="example"></a> Example ImageVulnerabilityScan

This section contains a sample IVS that uses Carbon Black to scan a targeted image and push the
results to the specified registry location.
For information about the IVS specification, see [Configuration Options](ivs-create-your-own.hbs.md#img-vuln-config-options).

- Set the tekton-pipelines feature-flags configmap `enable-api-fields` to `alpha`. This lets you use
the `stdoutConfig` which is needed to output the scan report as a file.

```yaml
apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
kind: ImageVulnerabilityScan
metadata:
  name: carbon-black-ivs
spec:
  image: nginx@sha256:... # The image to be scanned. Digest must be specified.
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
    - cbctl
    - image
    - scan
    - --force=true
    - $(params.image)
    - --config
    - /cbctl/.cbctl.yaml
    - -ocyclonedx
    stdoutConfig:
      path: /workspace/scan-results/scan-results.cdx.xml
```

Where:

- `CB-API-ID` is the API ID obtained from VMware Carbon Black Cloud (CBC).
- `CB-API-KEY` is the API Key obtained from CBC.
- `ORG-KEY` is the Org Key for your CBC organization.
- `SAAS-URL` is the CBC Backend URL.
- `CARBON-BLACK-SCANNER-IMAGE` is the Carbon Black scanner image.

The Carbon Black `cbctl-creds` secret is mounted as a workspace binding and the credentials are inserted into a `cbctl.yaml` config file that the Carbon Black CLI uses.

`stdoutConfig.path` is specified to take the output stream of the step to a file where you can publish it to the registry. For more information, see the [Tekton documentation](https://github.com/tektoncd/community/blob/main/teps/0011-redirecting-step-output-streams.md).

### <a id="disclaimer"></a> Disclaimer

For the publicly available Carbon Black scanner CLI image, CLI commands and parameters used are accurate at the time of documentation.
