# Configure a ImageVulnerabilityScan for Carbon Black

To configure an ImageVulnerabilityScan for Carbon Black, use the following ImageVulnerabilityScan and secret configuration:

This topic gives you an example of how to configure an ImageVulnerabilityScan (IVS) for Carbon Black.

## <a id="example"></a> Example ImageVulnerabilityScan

This section contains a sample IVS that uses Carbon Black to scan a targeted image and push the results to the specified registry location.
For information about the IVS specification, see [Configuration Options](ivs-create-your-own.hbs.md#img-vuln-config-options).

### <a id="cbc-config"></a> Prepare the Carbon Black Scanner configuration

1. Obtain a Carbon Black API Token from Carbon Black Cloud.

2. Create a Carbon Black secret YAML file and insert the Carbon Black API configuration key. Obtain all values from your CBC console.

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

- `CB-API-ID` is the API ID obtained from VMware Carbon Black Cloud (CBC).
- `CB-API-KEY` is the API Key obtained from CBC.
- `ORG-KEY` is the Org Key for your CBC organization.
- `SAAS-URL` is the CBC Backend URL.


3. Apply the Carbon Black secret YAML file by running:

    ```console
    kubectl apply -f YAML-FILE
    ```

    Where `YAML-FILE` is the name of the Carbon Black secret YAML file you created.

### <a id="configure-carbon-black-ivs"></a> Configure IVS for Carbon Blac

- Set the tekton-pipelines feature-flags configmap `enable-api-fields` to `alpha`. This enables the user to use the `stdoutConfig` which is needed to output the scan report as a file.

```yaml
apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
kind: ImageVulnerabilityScan
metadata:
  name: carbon-black-ivs
  annotations:
    app-scanning.apps.tanzu.vmware.com/scanner-name: Carbon-Black
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

- `CARBON-BLACK-SCANNER-IMAGE` is the Carbon Black scanner image. For example, `cbartifactory/cbctl:latest`. or information about publicly available Grype images, see DockerHub. For information about publicly available Carbon Black images, see [DockerHub](https://hub.docker.com/r/cbartifactory/cbctl). For more information about using the Carbon Black Scanner CLI, see the [Carbon Black documentation](https://developer.carbonblack.com/reference/carbon-black-cloud/container/latest/image-scanning-cli/).
- Configure Carbon Black CLI with CarbonBlack `cbctl-creds` secret and credentials by using the `~/.cbctl/cbctl.yaml` config file. See the [Carbon Black](https://developer.carbonblack.com/reference/carbon-black-cloud/container/latest/image-scanning-cli#configuration) documentation.

**Note** The Carbon Black `cbctl-creds` secret is mounted as a workspace binding and the credentials are inserted into a `cbctl.yaml` config file that the Carbon Black CLI uses.

**Note** `stdoutConfig.path` is specified to take the output stream of the step to a given file where it can be published to the registry. See [tekton docs](https://github.com/tektoncd/community/blob/main/teps/0011-redirecting-step-output-streams.md) for more details.

### <a id="disclaimer"></a> Disclaimer
For the publicly available Carbon Black scanner CLI image, CLI commands and parameters used are accurate at the time of documentation.