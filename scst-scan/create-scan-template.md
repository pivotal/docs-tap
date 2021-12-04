# Create a ScanTemplate
The `ScanTemplate` CR is where you define the pod with the scanner image that you will be using for your vulnerability scanning. There's a default scanner image you can use out-of-the-box.

## Structure
```
apiVersion: scst-scan.apps.tanzu.vmware.com/v1alpha1
kind: ScanTemplate
spec:
    # Required. This field must specify a valid pod.spec. 
    # This will have the instructions for the scan to be successfully executed.
    # See Pod Requirements section below for more details
    template: 
```

## Pod requirements
You can define any valid [Kubernetes Pod](https://kubernetes.io/docs/concepts/workloads/pods/) into the `ScanTemplate` CR as long as you follow these requirements:

1. **Scanner Container**  
    The pod scan needs to define a container named `scanner` which will have the result of the scanning.  
   * **`stdout` Logs**  
    The scan result must be printed in the `stdout` of the `scanner` container having a valid [CycloneDX](https://cyclonedx.org/docs/1.3/) XML format.

2. **XML Extra Fields**  
    **Component Name**  
        For the Scan Controller to keep track of your report, provide the name of the scanned artifact in the `bom>metadata>component>name` field of the XML generated as an output. Use the `url` for a source repository. Use the `image` name for an image scan.
    **Component Digest**  
        For the Scan Controller to keep track of your report, provide the digest or most unique identifier of your artifact into the `bom>metadata>component>version` field of the XML generated as an output.  
    **Scanner Name**  
        Provide the name of the scanner you are using in the `bom>metadata>tools>tool>name` field of the XML generated as an output.  
    **Scanner Vendor**  
        Provide the name of the vendor from the scanner that you are using in the `bom>metadata>tools>tool>vendor` field of the XML generated as an output.  
    **Scanner Version**  
        Provide the version of the scanner you are using in `bom>metadata>tools>tool>version` field of the XML generated as an output.  

If the `scanner` pod is not defined or the logs retrieved from the `stdout` does not have a valid format, then the scanning condition will fail.

## Best practices
1. **SourceScan**  
   1. **Init Container**  
        If you're doing a `SourceScan`, it is encourage that you define the cloning of the repository in an init container named `repo`. Any output in `stdout` in this init container will be prompted out in case an error happens, so you can have more context about what failed inside the job.
