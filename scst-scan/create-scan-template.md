# Create a ScanTemplate

The `ScanTemplate` custom resource (CR) defines the Pod with the scanner image that you use for vulnerability scanning. There's a default scanner image you can use out-of-the-box.

## <a id="structure"></a>Structure

```yaml
apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
kind: ScanTemplate
spec:
    # Required. This field must specify a valid pod.spec.
    # This has the instructions for the scan to be successfully executed.
    # See Pod Requirements section below for more details
    template:
```

## <a id="pod-requirements"></a>Pod requirements

You can define any valid [Kubernetes Pod](https://kubernetes.io/docs/concepts/workloads/pods/) into the `ScanTemplate` CR if you follow these requirements:

1. **Scanner Container**  
    The Pod scan must define a container named `scanner` to hold the scanning result.  
   * **`stdout` Logs**  
    The scan result must be printed in the `stdout` of the `scanner` container having a valid [CycloneDX](https://cyclonedx.org/docs/1.3/) XML format.

2. **XML Extra Fields**  
    **Component Name**  
        For the scan controller to keep track of your report, provide the name of the scanned artifact in the `bom>metadata>component>name` field of the XML generated as an output. Use the `url` for a source repository. Use the `image` name for an image scan.
    **Component Digest**  
        For the Scan Controller to keep track of your report, provide your artifact's digest or most unique identifier of your artifact into the `bom>metadata>component>version` field of the XML generated as an output.  
    **Scanner Name**  
        Provide the name of the scanner you are using in the `bom>metadata>tools>tool>name` field of the XML generated as an output.  
    **Scanner Vendor**  
        Provide the name of the vendor from the scanner that you are using in the `bom>metadata>tools>tool>vendor` field of the XML generated as an output.  
    **Scanner Version**  
        Provide the version of the scanner you are using in `bom>metadata>tools>tool>version` field of the XML generated as an output.  

If the `scanner` Pod is not defined or the logs retrieved from the `stdout` do not have a valid format, the scanning condition fails.

## <a id="best-practices"></a>Best practices

1. **SourceScan**  
   - **Init Container**  
        If you're doing a `SourceScan`, we recommend defining the cloning of the repository in an init container named `repo`. Any output in `stdout` in this init container is prompted if an error occurs, so you can have more context about what failed inside the job.
