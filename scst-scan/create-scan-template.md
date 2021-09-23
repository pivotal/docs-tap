# How to Create a ScanTemplate
The `ScanTemplate` CR is where you define the pod with the scanner image that you will be using for your vulnerability scanning. There's a default scanner image you can use out-of-the-box. See [Scanner (Anchore Grype)](README.md#step-3-deploy-the-scanner)

## Structure
```yaml
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
kind: ScanTemplate
spec:
    # Required. This field must specify a valid pod.spec. 
    # This will have the instructions for the scan to be successfully executed.
    # See Pod Requirements section below for more details
    template: 
```

## Pod Requirements
You can define any valid [Kubernetes Pod](https://kubernetes.io/docs/concepts/workloads/pods/) into the `ScanTemplate` CR as long as you follow these requirements:

1. **Scanner Container**  
    The pod scan needs to define a container named `scanner` which will have the result of the scanning.  
   * **`stdout` Logs**  
    The scan result must be printed in the `stdout` of the `scanner` container having a valid [CycloneDX](https://cyclonedx.org/docs/1.3/) XML format.

2. **XML Extra Fields**  
    **Component Name**  
        For the Scan Controller to keep track of your report, please provide the name of the scanned artifact (`url` for source repository, `image` name for image scans) into the `bom>metadata>component>name` field of the XML generated as an output.  
    **Component Digest**  
        For the Scan Controller to keep track of your report, please provide the digest or most unique identifier of your artifact into the `bom>metadata>component>version` field of the XML generated as an output.  
    **Scanner Name**  
        Please provide the name of the scanner you're using. This must be present in `bom>metadata>tools>tool>name` field of the XML generated as an output.  
    **Scanner Vendor**  
        Please provide the name of the vendor from the scanner that you're using. This must be present in `bom>metadata>tools>tool>vendor` field of the XML generated as an output.  
    **Scanner Version**  
        Please provide the version of the scanner you're using. This must be present in `bom>metadata>tools>tool>version` field of the XML generated as an output.

If the `scanner` pod is not defined or the logs retrieved from the `stdout` does not have a valid format, then the scanning condition will fail. See [How to read the Scan Status](README.md#how-to-read-the-scan-status)

## Best Practices
1. **SourceScan**  
   1. **Init Container**  
        If you're doing a `SourceScan`, it is encourage that you define the cloning of the repository in an init container named `repo`. Any output in `stdout` in this init container will be prompted out in case an error happens, so you can have more context about what failed inside the job.

## Examples
This is an example using the out-of-the-box [Anchore Grype Image](README.md#step-3-deploy-the-scanner). You can also see the [Samples Section](samples/README.md).
```yaml
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
kind: ScanTemplate
metadata:
  name: sourcescantemplate-sample-public
spec:
  template:
    restartPolicy: Never
    imagePullSecrets:
      - name: scanner-secret-ref
    volumes:
      - name: workspace
        emptyDir: {}
    initContainers:
      - name: repo
        image: harbor-repo.vmware.com/supply_chain_security_tools/grype-templates@sha256:6d69a83d24e0ffbe2e527d8d414da7393137f00dd180437930a36251376a7912
        imagePullPolicy: IfNotPresent
        volumeMounts:
          - name: workspace
            mountPath: /workspace
            readOnly: false
        command: ["/bin/bash"]
        args:
          - "-c"
          - "./source/clone-repo.sh /workspace/source $REPOSITORY"
    containers:
      - name: scanner
        image: harbor-repo.vmware.com/supply_chain_security_tools/grype-templates@sha256:6d69a83d24e0ffbe2e527d8d414da7393137f00dd180437930a36251376a7912
        imagePullPolicy: IfNotPresent
        volumeMounts:
          - name: workspace
            mountPath: /workspace
            readOnly: false
        command: ["/bin/bash"]
        args:
          - "-c"
          - "./source/scan-source.sh /workspace/source scan.xml"
```

This would be a valid CycloneDX XML example for a nginx:1.16 image.
```xml
<bom xmlns="http://cyclonedx.org/schema/bom/1.2" xmlns:v="http://cyclonedx.org/schema/ext/vulnerability/1.0" version="1" serialNumber="urn:uuid:124122ab-131d-49a4-87cd-25e7fba52f2c">
  <metadata>
    <timestamp>2021-06-24T17:52:49Z</timestamp>
    <tools>
      <tool>
        <vendor>anchore</vendor>
        <name>grype</name>
        <version>0.13.0</version>
      </tool>
    </tools>
    <component type="container">
      <name>nginx:1.16</name>
      <version>sha256:2963fc49cc50883ba9af25f977a9997ff9af06b45c12d968b7985dc1e9254e4b</version>
    </component>
  </metadata>
  <components>
    <component type="library">
      <name>apt</name>
      <version>1.8.2</version>
      <licenses>
        <license>
          <name>GPLv2+</name>
        </license>
      </licenses>
      <v:vulnerabilities>
        <v:vulnerability ref="urn:uuid:ba0edc9f-e218-46f0-b4d2-010300cec886">
          <v:id>CVE-2011-3374</v:id>
          <v:source name="debian:10">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-3374</v:url>
          </v:source>
          <v:ratings></v:ratings>
          <v:advisories>
            <v:advisory>https://security-tracker.debian.org/tracker/CVE-2011-3374</v:advisory>
          </v:advisories>
        </v:vulnerability>
        <v:vulnerability ref="urn:uuid:dde2c719-e3d8-4fc1-919d-2949bf9a08a3">
          <v:id>CVE-2020-3810</v:id>
          <v:source name="debian:10">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2020-3810</v:url>
          </v:source>
          <v:ratings></v:ratings>
          <v:advisories>
            <v:advisory>https://security-tracker.debian.org/tracker/CVE-2020-3810</v:advisory>
          </v:advisories>
        </v:vulnerability>
        <v:vulnerability ref="urn:uuid:0f63395e-e0c2-4820-aa51-26dc58dfed89">
          <v:id>CVE-2020-27350</v:id>
          <v:source name="debian:10">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2020-27350</v:url>
          </v:source>
          <v:ratings></v:ratings>
          <v:advisories>
            <v:advisory>https://security-tracker.debian.org/tracker/CVE-2020-27350</v:advisory>
          </v:advisories>
        </v:vulnerability>
      </v:vulnerabilities>
    </component>
  </components>
</bom>
```
