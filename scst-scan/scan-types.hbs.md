# Scan Types for Supply Chain Security Tools - Scan

This topic tells you what scan types you can use with Scan Types for Supply
Chain Security Tools (SCST) - Scan. The out-of-box test and scan supply
chain supports the source and container image scan types.

## <a id="source-scan"></a> Source scan

The source scan step in the test and scan supply chain performs a Software
Composition Analysis (SCA) scan to inspect the open source dependencies of an
application for vulnerabilities. You perform this by inspecting the file that
the language uses for dependency declaration. For example:

| Language | Dependency File |
| ---- | ---- |
| Spring | `pom.xml` |
| .Net | `deps.json` |
| Node.JS | `packages.json` |
| Python | `requirements.txt`|

Rather than declare specific dependency versions, some languages such as Spring,
Java, and .Net resolve dependency versions at build time. For these languages,
performing a SCA scan on the declaration file stored in the source code does not
produce meaningful results, often creating false positives or false negatives.

Due to this, in Tanzu Application Platform v1.6, the source scan step is moved to an opt-in step
in the supply chain.

### <a id="add-source-scan"></a>Adding Source Scan to the Test and Scan Supply Chain

To add source scanning to the [out-of-the-box test and scan supply chain](../getting-started/about-supply-chains.hbs.md#3-ootb-testingscanning), you can apply an overlay in the install
`tap-values.yaml` file. This overlay adds the required resources to the supply chain in the correct
location to opt-in to source scanning.

For information about how overlays work with Tanzu Application Platform, see [Customize your package installation](../customize-package-installation.hbs.md).

To add source scanning to the default out-of-the-box test and scan supply chain:

1. Create a `secret.yml` file with a `Secret` that contains your ytt overlay. For example:

   ```yaml
  apiVersion: v1
  kind: Secret
  metadata:
    name: ootb-supply-chain-testing-scanning-add-source-scanner
    namespace: tap-install
    annotations:
      kapp.k14s.io/change-group: "tap-overlays"
  type: Opaque
  stringData:
    ootb-supply-chain-testing-scanning-add-source-scanner.yaml: |
      #@ load("@ytt:overlay", "overlay")
      #@overlay/match by=overlay.subset({"metadata":{"name":"source-test-scan-to-url"}, "kind": "ClusterSupplyChain"})
      ---
      spec:
        resources:
          #@overlay/match by=overlay.index(2)
          #@overlay/insert before=True
              - name: source-scanner
                params:
                - default: scan-policy
                  name: scanning_source_policy
                - default: blob-source-scan-template
                  name: scanning_source_template
                sources:
                - name: source
                  resource: source-tester
                templateRef:
                  kind: ClusterSourceTemplate
                  name: source-scanner-template
              #@overlay/match by="name"
              - name: image-provider
                sources:
                #@overlay/match by="name"
                - name: source
                  resource: source-scanner
   ```

   For information about ytt overlays, see the
   [Carvel documentation](https://carvel.dev/ytt/docs/v0.43.0/ytt-overlays/).

2. Apply the `Secret` to your cluster:

   ```console
   kubectl apply -f secret.yml
   ```

3. Update your values file to include a `package_overlays` field:

    ```yaml
    package_overlays:
    - name: ootb-supply-chain-testing-scanning
      secrets:
      - name: ootb-supply-chain-testing-scanning-add-source-scanner
    ```

4. Update Tanzu Application Platform:

    ```console
    tanzu package installed update tap -p tap.tanzu.vmware.com -v {{ vars.tap_version }}  --values-file tap-values.yaml -n tap-install
    ```

For a multicluster installation, you must apply this to the build profile, because that
is where the scan components run. For information about Tanzu Application Platform profiles, see
[Installing Tanzu Application Platform package and profiles](../install-online/profile.hbs.md).

## <a id="image-scan"></a> Container image scan

A container image scan inspects the contents of a built container image for
vulnerabilities. This scan is performed on the container image after it is
uploaded to the container image registry and at periodic intervals after the initial
upload. Many container registries, such as
[Harbor](https://goharbor.io/docs/2.8.0/administration/vulnerability-scanning/)
and [Docker Hub](https://docs.docker.com/docker-hub/vulnerability-scanning/)
include this capability.

Tanzu Application Platform enables scanning container images for
vulnerabilities as part of your supply chain, allowing you to prevent deployment
of a container image if vulnerabilities are discovered that exceed your security
policy.
