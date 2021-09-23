# Configure Code Repositories and Image Artifacts to be Scanned

## Prerequisite
Both the Source and Image Scans require a `ScanTemplate` to be defined. Run `kubectl get scantemplates` for the ScanTemplates provided with the scanner installation. These can be referenced, or see [How to Create a ScanTemplate](create-scan-template.md).

## Deploy Scan CRs
The Scan Controller defines two custom resources to create scanning jobs:
* SourceScan
* ImageScan

### SourceScan
The SourceScan custom resource helps you define and trigger a scan for a given repository. This can be done with a source code existing in a public repository or in a private one.

#### Step 1: Create the SourceScan Custom Resource
Example:
```yaml
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
kind: SourceScan
metadata:
  # set the name of the source scan CR
  name: sample-source-scan
spec:
  # At least one of these fields (blob or git) must be defined.
  blob:
    # location to a file with the source code compressed (supported files: .tar.gz)
    url:
  git:
    # A multiline string defining the known hosts that are going to be used for the SSH client on the container
    knownHosts:
    # Branch, tag, or commit digest
    revision:
    # The name of the kubernetes secret containing the private SSH key information.
    sshKeySecret:
    # A string containing the repository url.
    url:
    # The username needed to SSH connection. Default value is “git”
    username:

  # A string defining the name of an existing ScanTemplate custom resource. See "How To Create a ScanTemplate" section.
  scanTemplate: my-scan-template
 
   # A string defining the name of an existing ScanPolicy custom resource. See "Enforcement Policies (OPA)" section.
  scanPolicy: my-scan-policy
```

#### Step 2: Deploy the SourceScan CR to the Desired Namespace on Cluster

`kubectl apply -f <path_to_the_cr>/<custom_resource_filename>.yml -n <desired_namespace>`

After the scanning is done, the following fields will appear in the custom resource and filled by the scanner.
```yaml
# These fields will be populated from the source scan results
status:
  # The source code information as provided in the CycloneDX `bom>metadata>component>*` fields
  artifact:
    blob:
      url:
    git:
      url:
      revision:

  # An array that will be populated with information about the scanning status 
  # and the policy validation. These conditions might change in the lifecycle 
  # of the scan, refer to the "View Scan Status and Understanding Conditions" section to learn more.
  conditions: []

  # The url of the vulnerability scan results in the Metadata Store integration.
  # Only available when the integration is configured.
  metadataUrl:
            
  # When the CRD is updated to point at new revisions, this lets you know 
  # if the status reflects the latest one or not
  observedGeneration: 1
  observedPolicyGeneration: 1
  observedTemplateGeneration: 1

  # The latest datetime when the scanning was successfully finished.
  scannedAt:
  # Information about the scanner that was used for the latest image scan.
  # This information reflects what's in the CycloneDX `bom>metadata>tools>tool>*` fields.
  scannedBy:
    scanner:
      # The name of the scanner that was used. 
      name: my-image-scanner

      # The name of the scanner's development company or team
      vendor: my-image-scanner-provider

      # The version of the scanner used.
      version: 1.0.0
```

### ImageScan
The ImageScan custom resource helps you define and trigger a scan for a given image. This can be done with an image existing in a public registry or in a private one.

#### Step 1: Create the ImageScan Custom Resource

Example:
```yaml
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
kind: ImageScan
metadata:
  # set the name of the image scan CR
  name: sample-image-scan
spec:
  registry:
    # Required. A string containing the image name, additionally can add its tag or its digest
    image: nginx:1.16

    # A string containing the secret needed to pull the image from a private registry.
    # The secret needs to be deployed in the same namespace as the ImageScan
    imagePullSecret: my-image-pull-secret

  # A string defining the name of an existing ScanTemplate custom resource. See "How To Create a ScanTemplate" section.
  scanTemplate: my-scan-template

  # A string defining the name of an existing ScanPolicy custom resource. See "Enforcement Policies (OPA)" section.
  scanPolicy: my-scan-policy
 ```

#### Step 2: Deploy the ImageScan CR to the Desired Namespace on Cluster

`kubectl apply -f <path_to_the_cr>/<custom_resource_filename>.yml -n <desired_namespace>`

After the scanning is done, the following fields will appear in the custom resource and filled by the scanner.
```yaml
 # These fields will be populated from the image scan results
status:
  artifact:
    registry:
      # The image name with its digest as provided in the CycloneDX `bom>metadata>component>*` fields
      image:
      imagePullSecret:

  # An array that will be populated with information about the scanning status 
  # and the policy validation. These conditions might change in the lifecycle 
  # of the scan, refer to the "View Scan Status and Understanding Conditions" section to learn more.
  conditions: []

  # The url of the vulnerability scan results in the Metadata Store integration.
  # Only available when the integration is configured.
  metadataUrl:
            
  # When the CRD is updated to point at new revisions, this lets you know 
  # if the status reflects the latest one or not
  observedGeneration: 1
  observedPolicyGeneration: 1
  observedTemplateGeneration: 1

  # The latest datetime when the scanning was successfully finished.
  scannedAt:
  # Information about the scanner that was used for the latest image scan.
  # This information reflects what's in the CycloneDX `bom>metadata>tools>tool>*` fields.
  scannedBy:
    scanner:
      # The name of the scanner that was used. 
      name: my-image-scanner

      # The name of the scanner's development company or team
      vendor: my-image-scanner-provider

      # The version of the scanner used.
      version: 1.0.0
```
