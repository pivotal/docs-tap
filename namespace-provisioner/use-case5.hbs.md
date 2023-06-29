# Install multiple scanners in the developer namespace

This topic tells you how to automate multiple scanner installations in the developer namespace. 

Grype scanner is installed by default in all namespaces managed by Namespace Provisioner.

The following step describe how to install Snyk scanner and Grype in the developer namespace and use both together in the supply chain. Grype is used for Source scans and Snyk is used for Image scans.

For information about, how to create a developer namespace, see [Provision Developer Namespaces](provision-developer-ns.hbs.md).

1. Create a secret in the `tap-install` namespace or any namespace of your preference that contains the Snyk token in the YAML format **(must have .yaml or .yml in the key)** as shown below:

    ```yaml
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

2. Add the following configuration to your `tap-values.yaml` file to create the supply-chain and scanners:

Using Namespace Provisioner Controller
: Add the following configuration to your `tap-values.yaml` file:

    ```yaml
    namespace_provisioner:
      controller: true
      additional_sources:
      - git:
          ref: origin/main
          subPath: ns-provisioner-samples/testing-scanning-supplychain-multiple-scanners
          url: https://github.com/vmware-tanzu/application-accelerator-samples.git
      import_data_values_secrets:
      - name: scanner-auth
        namespace: tap-install
        create_export: true
    ```

Using GitOps
: Add the following configuration to your `tap-values.yaml` file:

    ```yaml
    namespace_provisioner:
      controller: false
      additional_sources:
      - git:
          ref: origin/main
          subPath: ns-provisioner-samples/testing-scanning-supplychain-multiple-scanners
          url: https://github.com/vmware-tanzu/application-accelerator-samples.git
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

- `tekton-pipeline-java.yaml` - For creating a Tekton pipeline for running tests on our Java workload
- `scanpolicy-grype.yaml and scanpolicy-snyk.yaml `- For creating a Scan policies to be used by Grype and Snyk scanners
- `snyk-token-secret.yaml` -is a Snyk token secret that needs to be created in our developer namespace. Instead of putting the actual snyk token in the secret in our Git repository, we will put the reference to the values in the scanner-auth secret created in Step 1 by using the `data.values.imported` keys.
- `snyk-scanner-install.yaml` - contains the PackageInstall for installing the Snyk package for our developer namespace. One particular thing to note on this file is that we have mentioned the namespace: tap-install in the PackageInstall resource. This signals the Namespace Provisioner to create a PackageInstall resource for all provisioned namespaces in the same namespace (in our case tap-install) and add` -{namespace}` as the suffix in the name to avoid name collisions.

Our setup is complete. Run the following Tanzu CLI command to apply a workload in your developer namespace that uses Grype for source scan and Snyk for Image scan:

Using Tanzu CLI
: Create workload using tanzu apps CLI command
  ```shell
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

Using workload yaml
: Create a workload.yaml file with the details as below.
  ```yaml
  ---
  apiVersion: carto.run/v1alpha1
  kind: Workload
  metadata:
    labels:
      app.kubernetes.io/part-of: tanzu-java-web-app
      apps.tanzu.vmware.com/has-tests: "true"
      apps.tanzu.vmware.com/workload-type: web
    name: tanzu-java-web-app
    namespace: YOUR-NEW-DEVELOPER-NAMESPACE
  spec:
    params:
    - name: scanning_image_policy
      value: snyk-scan-policy
    - name: scanning_image_template
      value: snyk-private-image-scan-template
    source:
      git:
        ref:
          branch: main
        url: https://github.com/sample-accelerators/tanzu-java-web-app
  ```
