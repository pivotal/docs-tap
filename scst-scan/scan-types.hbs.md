# Scan Types for Supply Chain Security Tools - Scan

This topic tells you what scan types you can use with SCST - Scan. The out-of-box test and scan supply chain supports the Source and Image scan types.

## Source Scan

The source scan step in the test and scan supply chain performs a Software Composition Analysis (SCA) scan to inspect the open source dependencies of an application for vulnerabilities.  This is typically performed by inspecting the file that the language uses for dependency declaration.  For example:

| Language | Dependency File |
| ---- | ---- |
| Spring | pom.xml |
| .Net | deps.json |
| Node.JS | packages.json |
| Python | requirements.txt| 

Rather than declare specific dependency versions, some languages such as Spring, Java, and .Net resolve dependency versions at build time. For these languages, performing a SCA scan on the declaration file stored in the source code does not produce meaningful results, often creating false positives or false negatives.

Due to this, in Tanzu Application Platform 1.6, the source scan step is moved to an opt-in step in the supply chain. To add source scan to the supply chain, follow the steps below.

### Adding Source Scan to the Test and Scan Supply Chain

In order to add source scanning to the [out-of-the-box test and scan supply chain](../getting-started/about-supply-chains.hbs.md#3-ootb-testingscanning), you can apply an overlay in your install values.yaml.  This overlay will add the required resources to the supply chain in the correct location to opt-in to source scanning.

See [here](../customize-package-installation.hbs.md) for more detailed information on how overlays work with the Tanzu Application Platform.

To add source scanning to the default out-of-the-box test and scan supply chain, do the following steps.

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
       #@ load("@ytt:data", "data")
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
   ```

   For more information about ytt overlays, see the
   [Carvel documentation](https://carvel.dev/ytt/docs/v0.43.0/ytt-overlays/).

2. Apply the `Secret` to your cluster by running:

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
3. Update Tanzu Application Platform by running:

    ```console
    tanzu package installed update tap -p tap.tanzu.vmware.com -v {{ vars.tap_version }}  --values-file tap-values.yaml -n tap-install
    ```

For a multi-cluster installation, this only needs to be applied to the build build profile, as that is where the scan components run.  For information about Tanzu Application Platform profiles, see
[Installing Tanzu Application Platform package and profiles](install-online/profile.hbs.md). 
