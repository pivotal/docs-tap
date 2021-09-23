# Vulnerability Scanning Enablement

* [Overview](#overview)
* [Installation](#installing-the-scan-controller-and-scanner)
* [Running Source and Image Scans](#running-source-and-image-scans)
* [Enforcing Policy around Vulnerabilities Found](#enforcing-policy-around-vulnerabilities-found)
* [Viewing Vulnerability Reports](#viewing-vulnerability-reports)
* [Incorporating into CI/CD Pipelines](#incorporating-into-cicd-pipelines)
* [Next Steps and Further Information](#next-steps-and-further-information)
* [Uninstall](#uninstalling)
* [Contact Us](#contact-us)
* [Useful Definitions](definitions.md)

## Overview
The Tanzu Vulnerability Scanning Enablement (VSE) Team’s mission is to help Tanzu customers build and deploy secure, trusted software that complies with their corporate security requirements. To that end, we are providing scanning and gatekeeping capabilities that Application and DevSecOps teams can easily incorporate earlier in their path to production as it is a known industry best practice for reducing security risk and ensuring more efficient remediation.

### Use Cases
* Scan source code repositories and images for known CVEs prior to deploying to a cluster using your scanner as a plugin.
* Identify CVEs by scanning continuously on each new code commit and/or each new image built.
* Analyze scan results against user-defined policies using Open Policy Agent.
* Produce vulnerability scan results and post them to the Metadata Store from where they can be queried.

### What We Built
To deliver on the use cases, we have:
* Built Kubernetes controllers to run scan jobs.
* Built Custom Resource Definitions (CRDs) for Image and Source Scan.
* Created a CRD for a scanner plugin. Provided example using: Anchore's Syft and Grype.
* Created a CRD for policy enforcement.

### Scanner Support
| Out-Of-The-Box Scanner | Image |
| --- | --- |
| Anchore Grype | [1.0.0-alpha.1](#scanner-anchore-grype) |

More to come in FY23! Let us know if there’s a scanner you’d like us to support.

## Installing the Scan Controller and Scanner

### Prerequisites
* Access to the [VMware Corporate Harbor Registry](https://harbor-repo.vmware.com)
* [Kubectl](https://kubernetes.io/docs/tasks/tools/) installed and targeting a Kubernetes Cluster
* [Carvel CLIs](https://carvel.dev/#whole-suite) (These packages `ytt kbld kapp imgpkg` need to be installed.)
* [Metadata Store](https://gitlab.eng.vmware.com/source-insight-tooling/insight-metadata-store/-/tree/alpha) (technically not a prerequisite, as scanning will occur without it, however to be able to query scan results later, the Metadata Store is required)
* [Metadata Store CLI](https://gitlab.eng.vmware.com/source-insight-tooling/insight-metadata-cli/-/tree/alpha)

### Step 1: Download the Bundles
[Carvel imgpkg](https://carvel.dev/imgpkg/docs/latest/) will be used to download the image bundles from the [VMware Corporate Harbor Registry](https://harbor-repo.vmware.com).

**NOTE:** If the cluster does not have access to the VMware Corporate Network, refer to [Relocating Images to Another Registry](image-relocation.md) and then skip to [Step 3: Deploy the Scan Controller](#step-3-deploy-the-scan-controller).

Pull the scan controller bundle:
```bash
imgpkg pull \
  -b harbor-repo.vmware.com/supply_chain_security_tools/scan-controller:v1.0.0-alpha.1 \
  -o /tmp/scan-controller
```

Pull the Grype scanner bundle:
```bash
imgpkg pull \
  -b harbor-repo.vmware.com/supply_chain_security_tools/grype-templates:v1.0.0-alpha.1 \
  -o /tmp/grype-templates
```

### Step 2: Authenticate with the Registry
The following credentials will be used to create a Kubernetes Secret in the cluster enabling images to be pulled successfully.

For the [VMware Corporate Harbor Registry](https://harbor-repo.vmware.com), these will be your SSO credentials.
```bash
REGISTRY_SERVER=harbor-repo.vmware.com
read -p "Username: " REGISTRY_USERNAME
read -p "Password: " -s REGISTRY_PASSWORD
```
<details><summary>If <code>read: -p: no coprocess</code></summary>

In the above block, the `read` tool is used to assign a value to a Bash environment variable. This makes it convenient to perform this step without exposing your registry password if you are sharing your screen with others, but is not required.

Instead, assign the variables yourself in your bash environment:

```bash
REGISTRY_USERNAME=your-username-here
REGISTRY_PASSWORD=your-password-here
```

</details>

### Step 3: Deploy the Scan Controller
**NOTE:** If the [Metadata Store](https://gitlab.eng.vmware.com/source-insight-tooling/insight-metadata-store/-/tree/alpha) was not installed to the cluster beforehand, then do not set the `metadataStoreUrl` value.
```bash
# DNS within the cluster uses the form: http://<service>.<namespace>.svc.cluster.local:<port>
METADATA_STORE_NAMESPACE=
ytt -f /tmp/scan-controller/config \
    -v docker.server="${REGISTRY_SERVER}" \
    -v docker.username="${REGISTRY_USERNAME}" \
    -v docker.password="${REGISTRY_PASSWORD}" \
    -v metadataStoreUrl="http://metadata-app-postgres.${METADATA_STORE_NAMESPACE}.svc.cluster.local:8080" \
  | kbld -f /tmp/scan-controller/.imgpkg/images.yml -f- \
  | kapp deploy -a canal -f- -y
```

**NOTE:** The scan controller will be deployed into the `canal-system` namespace. Run `kubectl get all -n canal-system` to view the resources.

#### Configure the Scan Controller
The above command provided `docker` properties to the deployment using the `ytt` templating command. The following properties are available for configuration:

| Property | Description | Default Value |
| --- | --- | --- |
| `namespace` | Deployment namespace for the Scan Controller | `canal-system` |
| `controllerImage` | the image provided in (.imgpkg/images.yaml) lock file coming with the bundle | |
| `controllerImagePullSecret` | Name of a secret inside `namespace` to pull the `controllerImage` to use, or create from `docker` credentials | `controller-secret-ref` |
| `kubeRbacProxyImage` | Override the location of the kube-rbac-proxy image used in the canal deployment | `gcr.io/kubebuilder/kube-rbac-proxy:v0.8.0` |
| `docker` | Credentials to create a new image pull secret in `namespace` (`username`, `password` and `server`) | |
| `metadataStoreUrl` | (Optional) Url of the Metadata Store deployed in the cluster | |

**NOTE:** These properties are available in `/tmp/scan-controller/config/data.yaml` and could be provided there instead of templating using `ytt`, but the recommended approach is to use `ytt`.

### Step 4: Deploy the Scanner
This is the scanner provided for you to start using the Scan Controller. This bundle has an image with the Anchore Grype scanner and four `ScanTemplate` Custom Resources (CRs) that we will mention more about below.
```bash
ytt -f /tmp/grype-templates/config \
    -v docker.server="${REGISTRY_SERVER}" \
    -v docker.username="${REGISTRY_USERNAME}" \
    -v docker.password="${REGISTRY_PASSWORD}" \
  | kbld -f /tmp/grype-templates/.imgpkg/images.yml -f- \
  | kapp deploy -a grype-templates -f- -y
```

## Running Source and Image Scans
With the Scan Controller and Scanner installed, the following Custom Resource Definitions (CRDs) are now available.
```console
$ kubectl get crds | grep scanning.apps.tanzu.vmware.com
imagescans.scanning.apps.tanzu.vmware.com                2021-09-09T15:22:07Z
scanpolicies.scanning.apps.tanzu.vmware.com              2021-09-09T15:22:07Z
scantemplates.scanning.apps.tanzu.vmware.com             2021-09-09T15:22:07Z
sourcescans.scanning.apps.tanzu.vmware.com               2021-09-09T15:22:07Z
```

`ScanTemplate` will define how to run a scan, and as mentioned above, four have been pre-installed for use, either for use as is, or as samples to create your own. They cover the use cases of both source and image scans from either a public or private repository/registry. In particular, they have been installed referencing secrets created using the docker server and credentials you provided, so they are ready to use out of the box. We will make use of them when running the samples. For more information, refer to [How to Create a ScanTemplate](create-scan-template.md).

You can view the Scan Template CRs that were pre-installed:
```console
$ kubectl get scantemplates
NAME                           AGE
private-image-scan-template    86m
private-source-scan-template   86m
public-image-scan-template     86m
public-source-scan-template    86m
```

Both `SourceScan` and `ImageScan` define what will be scanned and `ScanPolicy` is used to enable policy enforcement based on vulnerabilities found, which we will cover after running a couple sample scans.

For more information on the `SourceScan` and `ImageScan` CRDs, refer to [Configuring Code Repositories and Image Artifacts to be Scanned](scan-crs.md).

### Running a Sample Public Source Scan
This example will perform a source scan on a public repository.

#### Define the Resource
Create `public-source-example.yaml`
```yaml
---
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
kind: SourceScan
metadata:
  name: public-source-example
spec:
  git:
    url: "https://github.com/houndci/hound.git"
    revision: "5805c650"
  scanTemplate: public-source-scan-template
```

**NOTE:** This scan references one of the pre-installed Scan Templates (`public-source-scan-template`).

#### (Optional) Setup a Watch
Before deploying, set up a watch in another terminal to see things process... it will be quick!
```bash
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

For more information, refer to [Observing and Troubleshooting](observing.md).

#### Deploy the Resource
```bash
kubectl apply -f public-source-example.yaml
```

#### See the Results
Once the scan has completed, perform:
```bash
kubectl describe sourcescan public-source-example
```
and notice the `Status.Conditions` includes a `Reason: JobFinished` and `Message: The scan job finished`.

For more information, refer to [Viewing and Understanding Scan Status Conditions](results.md).

#### Clean Up
```bash
kubectl delete -f public-source-example.yaml
```

## Enforcing Policy around Vulnerabilities Found
In the Sample Public Source Scan above, we scanned a public repository with a revision that actually contained 61 vulnerabilities (at the time of writing).

The Scan Controller supports policy enforcement by using an Open Policy Agent (OPA) engine. This allows scan results to be validated for company policy compliance and can prevent source code from being built or images from being deployed. For more information, refer to [Configuring Policy Enforcement using Open Policy Agent (OPA)](policies.md).

### Running a Sample Public Source Scan including Policy Enforcement
This example will perform a source scan on a public repository. As mentioned, the source revision in question has 61 known vulnerabilities (CVEs), spanning a number of severities. The Source Scan will use the Scan Policy to run a compliance check against the CVEs.

The policy has been set to only consider `Critical` severity CVEs as violations, which returns 2 Critical Vulnerabilities. Additionally, one of the `Critical` CVEs has been set to be ignored, whereas the other has not.

The scan will:
* find all 61 of the CVEs,
* trim out the CVEs that have severities that are not included within the `violatingSeverities` array,
* further trim out any CVEs included in the `ignoreCVEs` array
* and indicate in the `Status.Conditions` that only one CVE violated policy compliance.

#### Define the Resources
Create `policy-enforcement-example.yaml`:
```yaml
---
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
kind: ScanPolicy
metadata:
  name: sample-scan-policy
spec:
  regoFile: |
    package policies

    default isCompliant = false

    # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "UnknownSeverity"
    violatingSeverities := ["Critical"]
    ignoreCVEs := ["GHSA-f2jv-r9rf-7988"]

    contains(array, elem) = true {
      array[_] = elem
    } else = false { true }

    isSafe(match) {
      fails := contains(violatingSeverities, match.Ratings.Rating[_].Severity)
      not fails
    }

    isSafe(match) {
      ignore := contains(ignoreCVEs, match.Id)
      ignore
    }

    isCompliant = isSafe(input.currentVulnerability)

---
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
kind: SourceScan
metadata:
  name: policy-enforcement-example
spec:
  git:
    url: "https://github.com/houndci/hound.git"
    revision: "5805c650"
  scanTemplate: public-source-scan-template
  scanPolicy: sample-scan-policy
```

#### (Optional) Setup a Watch
Before deploying, set up a watch in another terminal to see things process... it will be quick!
```bash
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

For more information, refer to [Observing and Troubleshooting](observing.md).

#### Deploy the Resources
```bash
kubectl apply -f policy-enforcement-example.yaml
```

#### See the Results
Once the scan has completed, perform:
```bash
kubectl describe sourcescan policy-enforcement-example
```
and notice the `Status.Conditions` includes a `Reason: EvaluationFailed` and `Message: Vulnerabilities that failed OPA policy: GHSA-w457-6q6x-cgp9`.

For more information, refer to [Viewing and Understanding Scan Status Conditions](results.md).

#### Modifying the Scan Policy
Let us say that this failing CVE is actually acceptable or the build just needs to be deployed... and the app will be patched tomorrow to remove the vulnerability... so... (It should be said, we are not advocating for ignoring Critical Severity Vulnerabilities, but for example sake...)

Update the `ignoreCVEs` array in the `ScanPolicy` to include the failing CVE `GHSA-w457-6q6x-cgp9`.

**NOTE:** Currently, the ScanPolicy CRD will not re-trigger a scan if it is updated, so one way to re-trigger the scan is to delete and reapply the SourceScan CR.

So, go ahead and delete just the SourceScan CR:
```bash
kubectl delete sourcescan policy-enforcement-example
```

Reapply the resources (`kubectl apply -f policy-enforcement-example.yaml`), re-describe the Scan CR (`kubectl describe sourcescan policy-enforcement-example`) and voila!

... `Status.Conditions` now includes a `Reason: EvaluationPassed` and `No noncompliant vulnerabilities found`.

Go ahead and update the `violatingSeverities` array as well to see the effect. For reference, the Grype scan returns the following Severity spread of vulnerabilities:
* Critical: 2
* High: 31
* Medium: 26
* Low: 2
* Negligible: 0
* UnknownSeverity: 0

## Clean Up
```bash
kubectl delete -f policy-enforcement-example.yaml
```

## Viewing Vulnerability Reports
The Scan Controller supports integration with the Metadata Store to save information about vulnerabilities and dependencies. You can query this vulnerability data using the Metadata Store `insight` CLI by providing the digest of the source or image scanned.

For example, to query Vulnerability data relating to an Image Scan:
```bash
# In another terminal (ensure the namespace is correct):
kubectl port-forward service/metadata-app-postgres 8080:8080 -n metadata-store
# Then back in the main terminal, check you are targeting the port-forwarded port:
insight config set-target http://localhost:8080
# Query for image scans:
kubectl get imagescans
# and grab the sha256 digest and replace in the following example query:
insight image get \
  --digest sha256:06ba459dc32475871646f22c980d5db4335021d76e1693c8a87bf02aed8c1a3e \
  --format json
```

For more information, refer to [Using the Metadata Store](https://gitlab.eng.vmware.com/source-insight-tooling/insight-metadata-store/-/blob/alpha/README.md#using-the-metadata-store).

## Incorporating into CI/CD Pipelines
The Scan Controller is developed to be included within with your CI/CD pipelines, providing you information and reliability about the security of your Image or Source Code before promoting it further in your supply chain. You can use any tool for CI/CD pipelines, just ensure the following are included inside the template to trigger a new scan:
* Source Scans: the repository url and commit digest, or the path to the compressed file with the latest source code
* Image Scans: the image name and digest

After you update and apply the scan CR to your cluster, then the next step should be looking at the CR description to get feedback from the Status field (see [Viewing and Understanding Scan Status Conditions](results.md)) and from there, make the decision if promoting your Image or Source Code further or just fail the pipeline.

### Example Cartographer Supply Chain including Source and Image Scans
For an example CI/CD pipeline that demonstrates:
* Code commit triggers a source scan
* Which triggers kpack to build an image
* Which triggers an image scan...

Refer to [Example Cartographer Supply Chain including Source and Image Scans](cartographer.md).

## Next Steps and Further Information
* [Running More Samples](samples/README.md)
* [Configuring Code Repositories and Image Artifacts to be Scanned](scan-crs.md)
* [Configuring Policy Enforcement using Open Policy Agent (OPA)](policies.md)
* [Viewing and Understanding Scan Status Conditions](results.md)
* [Observing and Troubleshooting](observing.md)

## Uninstalling

### Remove the Scan Controller and CRDs
```bash
kapp delete -a canal
```

### Remove the Grype Scanner and ScanTemplates
```bash
kapp delete -a grype-templates
```

## Contact Us
Need help or want to cover something that is not mentioned?
Find us on [#tap-assist](https://app.slack.com/client/T024JFTN4/C02D60T1ZDJ) as `@sct-vse` or email us at [sct-vse@groups.vmware.com](mailto:sct-vse@groups.vmware.com).
