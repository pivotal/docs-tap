# Install multiple scanners in the developer namespace

Refer to the [Provision Developer Namespaces](#heading=h.y3di0ufxnjb4) section to create a developer namespace.

This guide shows how you can automate multiple scanner installations in the developer namespace. By default, Grype scanner is installed Out-of-the-box in all namespaces managed by Namespace Provisioner. Following are the steps to install Snyk scanner in the developer namespace along with Grype and use both together in the supply chain (Grype for Source scans and Snyk for Image scans).

Create a secret in the `tap-install` namespace (or any namespace of your preference) that contains the Snyk token in the YAML format **(must have .yaml or .yml in the key)** as shown below:

```console
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: scanner-auth
  namespace: tap-install
type: Opaque
stringData:
  content.yaml: |
    scanners:
      snyk_api_token: "" # Paste your snyk API token here
EOF
```

Add the following configuration to your TAP values to to create the supply-chain and scanners:

Using Namespace Provisioner Controller
: Add the following configuration to your TAP values

    ```console
    namespace_provisioner:
    controller: true
    additional_sources:
    - git:
        ref: origin/main
        subPath: ns-provisioner-samples/testing-scanning-supplychain-multiple-scanners
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
        path: _ytt_lib/testing-scanning-supplychain-multiple-scanners-setup
    import_data_values_secrets:
    - name: scanner-auth
        namespace: tap-install
        create_export: true
    ```

Using GitOps
: Add the following configuration to your TAP values

    ```console
    namespace_provisioner:
    controller: false
    additional_sources:
    - git:
        ref: origin/main
        subPath: ns-provisioner-samples/testing-scanning-supplychain-multiple-scanners
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
        path: _ytt_lib/testing-scanning-supplychain-multiple-scanners-setup
    import_data_values_secrets:
    - name: scanner-auth
        namespace: tap-install
        create_export: true
    gitops_install:
        ref: origin/main
        subPath: ns-provisioner-samples/gitops-install
        url: https://github.com/vmware-tanzu/application-accelerator-samples.git
    ```

    Additional source points to the location of the [sample GitOps repo](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/ns-provisioner-samples/testing-scanning-supplychain-multiple-scanners) where we have the following custom resources:

        * `tekton-pipeline-java.yaml` - For creating a Tekton pipeline for running tests on our Java workload
        * `scanpolicy-grype.yaml and scanpolicy-snyk.yaml `- For creating a Scan policies to be used by Grype and Snyk scanners
        * `snyk-token-secret.yaml`
            1. is a Snyk token secret that needs to be created in our developer namespace. Instead of putting the actual snyk token in the secret in our Git repository, we will put the reference to the values in the scanner-auth secret created in Step 1 by using the `data.values.imported` keys.
        * `snyk-scanner-install.yaml`
            2. which contains the PackageInstall for installing the Snyk package for our developer namespace. One particular thing to note on this file is that we have mentioned the namespace: tap-install in the PackageInstall resource. This signals the Namespace Provisioner to create a PackageInstall resource for all provisioned namespaces in the same namespace (in our case tap-install) and add` -{namespace}` as the suffix in the name to avoid name collisions.

    Our setup is complete. Run the following Tanzu CLI command to apply a workload in your developer namespace that uses Grype for source scan and Snyk for Image scan:

    ```console
    tanzu apps workload apply tanzu-java-web-app \
    --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
    --git-branch main \
    --type web \
    --app tanzu-java-web-app \
    --label apps.tanzu.vmware.com/has-tests="true" \
    --param scanning_image_policy=snyk-scan-policy \
    --param scanning_image_template=snyk-private-image-scan-template \
    --namespace YOUR-NEW-DEVELOPER-NAMESPACE \
    --tail \
    --yes
    ```
