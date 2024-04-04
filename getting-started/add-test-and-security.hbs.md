# Add testing and scanning to your application

This topic guides you through installing the optional OOTB Supply Chain with Testing and the optional
OOTB Supply Chain with Testing and Scanning.

For more information about available supply chains, see [Supply chains on Tanzu Application Platform](about-supply-chains.md).

## <a id="you-will"></a>What you will do

- Install OOTB Supply Chain with Testing.
- Add a Tekton pipeline to the cluster and update the workload to point to the pipeline and resolve errors.
- Install OOTB Supply Chain with Testing and Scanning.
- Update the workload to point to the Tekton pipeline and resolve errors.
- Query for vulnerabilities and dependencies.
- (Optional) Enable recurring scanning for post-build scans.

## <a id="overview"></a> Overview

The default Out of the Box (OOTB) Supply Chain Basic and its dependencies were installed on your cluster during the Tanzu Application Platform install. As demonstrated in this guide, you can add testing and security scanning to your application.
When you activate OOTB Supply Chain with Testing, it deactivates OOTB Supply Chain Basic.

The following installations also provide a sample Tekton pipeline that tests your sample application. The pipeline is configurable. Therefore, you can customize the steps to perform
either additional testing or other tasks with Tekton Pipelines.

## <a id="install-OOTB-test"></a>Install OOTB Supply Chain with Testing

To install OOTB Supply Chain with Testing:

1. You can activate the OOTB Supply Chain with Testing by updating your profile to use `testing` rather than `basic` as the selected supply chain for workloads in this cluster.
The `tap-values.yaml` is the file used to customize the profile in `Tanzu package install tap
--values-file=...`. Update `tap-values.yaml` with the following changes:

    ```yaml
    - supply_chain: basic
    + supply_chain: testing

    - ootb_supply_chain_basic:
    + ootb_supply_chain_testing:
        registry:
          server: "SERVER-NAME"
          repository: "REPO-NAME"
    ```

    Where:

    - `SERVER-NAME` is the name of your server.
    - `REPO-NAME` is the name of the image repository that hosts the container images.

1. Update the installed profile by running:

    ```console
    tanzu package installed update tap -p tap.tanzu.vmware.com -v VERSION-NUMBER --values-file tap-values.yaml -n tap-install
    ```

    Where `VERSION-NUMBER` is your Tanzu Application Platform version. For example, `{{ vars.tap_version }}`.

### <a id="tekton-config-example"></a>Tekton pipeline config example

In this section, a Tekton pipeline is added to the cluster. In the next section,
the workload is updated to point to the pipeline and resolve any current errors.

>**Note** Developers can perform this step because they know how their application must be tested. The operator can also add the Tekton pipeline to a cluster before the developer gets access.

To add the Tekton pipeline to the cluster, apply the following YAML to the cluster:

```yaml
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: developer-defined-tekton-pipeline
  namespace: DEVELOPER-NAMESPACE
  labels:
    apps.tanzu.vmware.com/pipeline: test     # (!) required
spec:
  params:
    - name: source-url                       # (!) required
    - name: source-revision                  # (!) required
  tasks:
    - name: test
      params:
        - name: source-url
          value: $(params.source-url)
        - name: source-revision
          value: $(params.source-revision)
      taskSpec:
        params:
          - name: source-url
          - name: source-revision
        steps:
          - name: test
            image: gradle
            script: |-
              cd `mktemp -d`

              wget -qO- $(params.source-url) | tar xvz -m
              ./mvnw test
```

Where `DEVELOPER-NAMESPACE` is the name of your developer namespace.

The preceding YAML puts a Tekton pipeline in the developer namespace you specify.
It defines the Tekton pipeline with a single step.
The step contained in the `steps` pulls the code from the repository indicated
in the developers `workload` and runs the tests within the repository.
The steps of the Tekton pipeline are configurable and allow the developer to add additional items
needed to test their code.

There are many steps in the supply chain. In this case, the next step is an image build.
Any additional steps the developer adds to the Tekton pipeline to test their code are independent of
the image being built and of any subsequent steps executed in the supply chain.
This independence gives the developer freedom to focus on testing their code.

The `params` are templated by Supply Chain Choreographer.
Additionally, Tekton pipelines require a Tekton `pipelineRun` to execute on the cluster.
Supply Chain Choreographer handles creating the `pipelineRun` dynamically each time
that step of the supply chain requires execution.

### <a id="test-workload-update"></a>Workload update

To connect the new supply chain to the workload,
the workload must be updated to point at your Tekton pipeline.

1. Update the workload by running the following with the Tanzu CLI:

    ```console
    tanzu apps workload apply tanzu-java-web-app \
      --git-repo https://github.com/vmware-tanzu/application-accelerator-samples \
      --sub-path tanzu-java-web-app \
      --git-branch main \
      --type web \
      --label apps.tanzu.vmware.com/has-tests=true \
      --label app.kubernetes.io/part-of=tanzu-java-web-app \
      --yes
    ```

    <!-- add example output -->

2. After accepting the workload creation, monitor the creation of new resources by the workload by running:

    ```console
    kubectl get workload,gitrepository,pipelinerun,images.kpack,podintent,app,services.serving
    ```

  The result is output similar to the following example that shows the objects created by Supply Chain Choreographer:

    ```console
    NAME                                    AGE
    workload.carto.run/tanzu-java-web-app   109s

    NAME                                                        URL                                                               READY   STATUS                                                            AGE
    gitrepository.source.toolkit.fluxcd.io/tanzu-java-web-app   https://github.com/vmware-tanzu/application-accelerator-samples   True    Fetched revision: main/872ff44c8866b7805fb2425130edb69a9853bfdf   109s

    NAME                                              SUCCEEDED   REASON      STARTTIME   COMPLETIONTIME
    pipelinerun.tekton.dev/tanzu-java-web-app-4ftlb   True        Succeeded   104s        77s

    NAME                                LATESTIMAGE                                                                                                      READY
    image.kpack.io/tanzu-java-web-app   10.188.0.3:5000/foo/tanzu-java-web-app@sha256:1d5bc4d3d1ffeb8629fbb721fcd1c4d28b896546e005f1efd98fbc4e79b7552c   True

    NAME                                                             READY   REASON   AGE
    podintent.conventions.carto.run/tanzu-java-web-app   True             7s

    NAME                                      DESCRIPTION           SINCE-DEPLOY   AGE
    app.kappctrl.k14s.io/tanzu-java-web-app   Reconcile succeeded   1s             2s

    NAME                                             URL                                               LATESTCREATED              LATESTREADY                READY     REASON
    service.serving.knative.dev/tanzu-java-web-app   http://tanzu-java-web-app.developer.example.com   tanzu-java-web-app-00001   tanzu-java-web-app-00001   Unknown   IngressNotConfigured
    ```

## <a id="install-OOTB-test-scan"></a>Install OOTB Supply Chain with Testing and Scanning

<<<<<<< HEAD
=======
> **Note** These steps are for Scan 1.0.  Scan 1.0 has been deprecated as of the TAP 1.9 release.  Scan 1.0 will remain the default in the [test and scan supply chain](../getting-started/add-test-and-security.hbs.md#add-testing-and-scanning-to-your-application) in the TAP 1.9 release but it is recommended to opt-in to Scan 2.0 as Scan 1.0 will be replaced as the default and removed in a future version.  For more information about Scan 1.0 versus Scan 2.0, see the [scan overview page](./overview.hbs.md)

>>>>>>> parent of 9f75374ce (Deprecate Scan 1.0)
To install OOTB Supply Chain with Testing and Scanning, you must install the Scan Controller
and the Grype scanner.

Leveraging both Grype and Tanzu Build Service in your Tanzu Application Platform supply chain enables
enhanced scanning coverage for languages and frameworks.
For the languages and frameworks supported, see the _Extended Scanning Coverage using Anchore Grype_
column in the [Language and Framework Support Table](../about-package-profiles.hbs.md#language-support).

To install OOTB Supply Chain with Testing and Scanning:

> **Note** The OOTB Supply Chain with Testing and Scanning capability has been changed to opt-in and
> is skipped by default starting in Tanzu Application Platform v1.6.
> For more information, see [Scan Types](../scst-scan/scan-types.hbs.md).

1. Supply Chain Security Tools (SCST) - Scan is installed as part of the Tanzu Application Platform profiles.
   Verify that Scan Controller is installed by running:

    ```console
    tanzu package installed get scanning -n tap-install
    ```

    If the package is not already installed, follow the steps in [Supply Chain Security Tools - Scan](../scst-scan/install-scst-scan.hbs.md)
    to install the required scanning components.

1. Grype Scanner for SCST - Scan is installed through Namespace Provisioner. Verify that Grype Scanner
   is present on your workload namespace:

    ```console
    tanzu package installed get grype-scanner-YOUR-DEV-NAMESPACE -n tap-install
    ```

    To install Grype Scanner to multiple namespaces, VMware recommends using
    [Namespace Provisioner](../namespace-provisioner/about.hbs.md).
    ScanTemplates with Grype scanner are automatically installed into namespaces created by
    Namespace Provisioner.

    Grype scanner must be present in the namespace that the workload is deployed to for scanning.

1. Apply a ScanPolicy in the required namespace. The sample ScanPolicy provided in this step is
   configured with `notAllowedSeverities := ["Critical","High","UnknownSeverity"]`.
   This blocks a supply chain when the scanner finds CVEs with critical, high, and unknown ratings.

    You can also configure the supply chain to use your own custom policies and apply exceptions when
    you want to ignore certain CVEs. See
    [Out of the Box Supply Chain with Testing and Scanning](../scc/ootb-supply-chain-testing-scanning.hbs.md#updates-to-developer-namespace).
    To apply the sample ScanPolicy, you can either add the namespace flag to the kubectl command or
    add the namespace field to the template by running:

    ```console
    kubectl apply -f - -o yaml << EOF
    ---
    apiVersion: scanning.apps.tanzu.vmware.com/v1beta1
    kind: ScanPolicy
    metadata:
      name: scan-policy
      labels:
        'app.kubernetes.io/part-of': 'enable-in-gui'
    spec:
      regoFile: |
        package main

        # Accepted Values: "Critical", "High", "Medium", "Low", "Negligible", "UnknownSeverity"
        notAllowedSeverities := ["Critical", "High", "UnknownSeverity"]
        ignoreCves := []

        contains(array, elem) = true {
          array[_] = elem
        } else = false { true }

        isSafe(match) {
          severities := { e | e := match.ratings.rating.severity } | { e | e := match.ratings.rating[_].severity }
          some i
          fails := contains(notAllowedSeverities, severities[i])
          not fails
        }

        isSafe(match) {
          ignore := contains(ignoreCves, match.id)
          ignore
        }

        deny[msg] {
          comps := { e | e := input.bom.components.component } | { e | e := input.bom.components.component[_] }
          some i
          comp := comps[i]
          vulns := { e | e := comp.vulnerabilities.vulnerability } | { e | e := comp.vulnerabilities.vulnerability[_] }
          some j
          vuln := vulns[j]
          ratings := { e | e := vuln.ratings.rating.severity } | { e | e := vuln.ratings.rating[_].severity }
          not isSafe(vuln)
          msg = sprintf("CVE %s %s %s", [comp.name, vuln.id, ratings])
        }
    EOF
    ```

1. (optional) The Tanzu Application Platform profiles install the [Supply Chain Security Tools - Store](../scst-store/overview.md) package by default. To persist and query the vulnerability results post-scan, confirm it is installed by running:

    ```console
    tanzu package installed get metadata-store -n tap-install
    ```

    If the package is not installed, follow the installation instructions at [Install Supply Chain Security Tools - Store independent from Tanzu Application Platform profiles](../scst-store/install-scst-store.md).

1. Update the profile to use the supply chain with testing and scanning by
   updating `tap-values.yaml` (the file used to customize the profile in `tanzu
   package install tap --values-file=...`) with the following changes:

    ```console
    - supply_chain: testing
    + supply_chain: testing_scanning

    - ootb_supply_chain_testing:
    + ootb_supply_chain_testing_scanning:
        registry:
          server: "<SERVER-NAME>"
          repository: "<REPO-NAME>"
    ```

1. Update the `tap` package:

    ```console
    tanzu package installed update tap -p tap.tanzu.vmware.com -v VERSION-NUMBER --values-file tap-values.yaml -n tap-install
    ```

    Where `VERSION-NUMBER` is your Tanzu Application Platform version. For example, `{{ vars.tap_version }}`.

### <a id="workload-update"></a>Workload update

To connect the new supply chain to the workload, update the workload to point to your Tekton
pipeline:

1. Update the workload by running the following using the Tanzu CLI:

    ```console
    tanzu apps workload apply tanzu-java-web-app \
      --git-repo https://github.com/vmware-tanzu/application-accelerator-samples \
      --sub-path tanzu-java-web-app \
      --git-branch main \
      --type web \
      --label apps.tanzu.vmware.com/has-tests=true \
      --label app.kubernetes.io/part-of=tanzu-java-web-app \
      --yes
    ```

    <!-- add example output -->

1. After accepting the workload creation, view the new resources that the workload created by running:

    ```console
    kubectl get workload,gitrepository,sourcescan,pipelinerun,images.kpack,imagescan,podintent,app,services.serving
    ```

    The following is an example output, which shows the objects that Supply Chain Choreographer created:

    ```console
    NAME                                    AGE
    workload.carto.run/tanzu-java-web-app   109s

    NAME                                                        URL                                                               READY   STATUS                                                            AGE
    gitrepository.source.toolkit.fluxcd.io/tanzu-java-web-app   https://github.com/vmware-tanzu/application-accelerator-samples   True    Fetched revision: main/872ff44c8866b7805fb2425130edb69a9853bfdf   109s

    NAME                                                           PHASE       SCANNEDREVISION                            SCANNEDREPOSITORY                                                 AGE    CRITICAL   HIGH   MEDIUM   LOW   UNKNOWN   CVETOTAL
    sourcescan.scanning.apps.tanzu.vmware.com/tanzu-java-web-app   Completed   187850b39b754e425621340787932759a0838795   https://github.com/vmware-tanzu/application-accelerator-samples   90s

    NAME                                              SUCCEEDED   REASON      STARTTIME   COMPLETIONTIME
    pipelinerun.tekton.dev/tanzu-java-web-app-4ftlb   True        Succeeded   104s        77s

    NAME                                LATESTIMAGE                                                                                                      READY
    image.kpack.io/tanzu-java-web-app   10.188.0.3:5000/foo/tanzu-java-web-app@sha256:1d5bc4d3d1ffeb8629fbb721fcd1c4d28b896546e005f1efd98fbc4e79b7552c   True

    NAME                                                          PHASE       SCANNEDIMAGE                                                                                                AGE   CRITICAL   HIGH   MEDIUM   LOW   UNKNOWN   CVETOTAL
    imagescan.scanning.apps.tanzu.vmware.com/tanzu-java-web-app   Completed   10.188.0.3:5000/foo/tanzu-java-web-app@sha256:1d5bc4d3d1ffeb8629fbb721fcd1c4d28b896546e005f1efd98fbc4e79b7552c   14s

    NAME                                                             READY   REASON   AGE
    podintent.conventions.carto.run/tanzu-java-web-app   True             7s

    NAME                                      DESCRIPTION           SINCE-DEPLOY   AGE
    app.kappctrl.k14s.io/tanzu-java-web-app   Reconcile succeeded   1s             2s

    NAME                                             URL                                               LATESTCREATED              LATESTREADY                READY     REASON
    service.serving.knative.dev/tanzu-java-web-app   http://tanzu-java-web-app.developer.example.com   tanzu-java-web-app-00001   tanzu-java-web-app-00001   Unknown   IngressNotConfigured
    ```

    > **Important** If the source or image scan has a "Failed" phase this means that the scan failed due to a scan policy violation and the supply chain stops. For information about the CVE triage workflow, see [Out of the Box Supply Chain with Testing and Scanning](../scc/ootb-supply-chain-testing-scanning.hbs.md#cve-triage-workflow).

### <a id="query-for-vuln"></a> Query for vulnerabilities

Scan reports are automatically saved to the [Supply Chain Security Tools - Store](../scst-store/overview.md), and you can query them for vulnerabilities and dependencies. For example, related to open-source software (OSS) or third-party packages.

Query the tanzu-java-web-app image dependencies and vulnerabilities by running:

```console
tanzu insight image get --digest DIGEST
tanzu insight image vulnerabilities --digest  DIGEST
```

Where `DIGEST` is the component version or image digest printed in the `KUBECTL GET` command.

For additional information and examples, see [Tanzu Insight plug-in overview](../cli-plugins/insight/cli-overview.md).
<br>

Congratulations! You have successfully added testing and security scanning to your application on the Tanzu Application Platform.

Take the next steps to learn about recommended supply chain security best practices and gain a powerful services journey experience on the Tanzu Application Platform by enabling several advanced use cases.

### <a id="enable-scan-post-build"></a> (Optional) Scan for vulnerabilities after build time

When you add the capability to scan image containers to your supply chain, you can detect
vulnerabilities at build time. However, as new vulnerabilities are discovered and reported daily,
it is important to frequently scan the container images to detect newly reported vulnerabilities.

You can enable recurring scanning to schedule periodic scans of images built by workloads and containers
running in Tanzu Application Platform clusters.
When you enable recurring scanning, an option to **View Latest Scan Results** becomes available on the
Supply Chain Choreographer plug-in.
For how to enable recurring scanning, see [Set up recurring scanning](../scst-scan/recurring-scanning.hbs.md).

## Next steps

- [Configure image signing and verification in your supply chain](config-supply-chain.md)
