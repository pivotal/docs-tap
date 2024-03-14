# Create a Workload from the Supply Chain

This topic tells you how to create and apply a workload from a Supply Chain, how to observe a
workload, and how to verify the scanning performed in a workload.

## <a id="define-and-create-wl"></a> Define and create a workload

This section tells you how to create a workload from an existing supply chain that was created by using SCST - Scan 2.0 and one of the following:

- [Trivy Supply Chain Component](create-supply-chain-with-app-scanning.hbs.md#scan-2.0-and-trivy) 
- [Custom Scanning Component](create-supply-chain-with-app-scanning.hbs.md#scan-2.0-and-custom-scanning)

For more information about how to create a workload, see [Work with Workloads](../../supply-chain/development/how-to/discover-workloads.hbs.md).

You can define a workload in YAML or use the Tanzu Workload CLI plug-in to generate a workload manifest.

### <a id="define-workload"></a> Define a workload

Define a `workload.yaml` to run:

```yaml
kind: KIND
apiVersion: example.com/v1alpha1
metadata:
  name: WORKLOAD-NAME
spec:
  registry:
    repository: REGISTRY-REPOSITORY
    server: REGISTRY-SERVER
  source:
    git:
      branch: main
      url: GIT-URL
    subPath: ""
```

Where:

- `KIND` is the kind defined in the [Trivy Supply Chain Component](create-supply-chain-with-app-scanning.hbs.md#scan-2.0-and-trivy) or [Custom Scanning Component](create-supply-chain-with-app-scanning.hbs.md#scan-2.0-and-custom-scanning). The kind can be found in the supplychain YAML in the supplychains directory.
- `API-VERSION` is defined in the [Create a Supply Chain with SCST - Scan 2.0 and Trivy Supply Chain Component](create-supply-chain-with-app-scanning.hbs.md#create-a-supply-chain-with-scst---scan-20-and-trivy-supply-chain-component) or [Create Supply Chain with SCST - Scan 2.0 and Custom Scanning Component](create-supply-chain-with-app-scanning.hbs.md#create-supply-chain-with-scst---scan-20-and-custom-scanning-component). `API-VERSION` is the `group` and `version` found in the supplychain YAML in the supplychains directory.
- `REGISTRY-REPOSITORY` is the registry repository used for the scan results location.
- `REGISTRY-SERVER` is the registry server used for the scan results location.
- `GIT-URL` is the Git repository URL to clone from for the source component.
- `GIT-BRANCH` is the Git branch reference to watch for the new source.
- `GIT-SUBPATH` is the path where the source code is located.

For more information about any of the `GIT-*` values, see [Source Git Provider](../../supply-chain/reference/catalog/about.hbs.md#source-git-provider).

### <a id="generate-workload"></a> Generate a workload

Use the Tanzu Workload CLI plug-in to generate a workload from a configuration by running:

```console
tanzu workload generate NAME --kind KIND
```

Where `KIND` is the kind API resource defined in the [Trivy Supply Chain Component](create-supply-chain-with-app-scanning.hbs.md#scan-2.0-and-trivy) or [Custom Scanning Component](create-supply-chain-with-app-scanning.hbs.md#scan-2.0-and-custom-scanning).

This renders a sample workload YAML that you can configure and put in a `workload.yaml`.

### <a id="create-workload"></a> Create a workload

Using the `workload.yaml` created in the previous section, create the workload:

```console
tanzu workload create --file workload.yaml --namespace DEV-NAMESPACE
```

Where `DEV-NAMESPACE` is the same namespace where the intended workload will be.

## <a id="observe-workload"></a> Observe the workload

This section shows you how to use the Tanzu Workload CLI plug-in to observe a workload.

1. List workloads in the cluster by running:

    ```console
    tanzu workload list -n DEV-NAMESPACE
    ```

    Where `DEV-NAMESPACE` is the namespace where the workload is.

    Example output:

    ```console
    $ tanzu workload list -n grype-app-scanning-catalog

    Listing workloads from all namespaces

      NAMESPACE                   NAME                         KIND                  VERSION   AGE
      grype-app-scanning-catalog  golang-app-grype-test  grypescs.example.com  v1alpha1  35m

    🔎 To see more details about a workload, use 'tanzu workload get workload-name --kind workload-kind'
    ```

2. View workload details by running:

    ```console
    tanzu workload get Sample WORKLOAD-NAME
    ```

    Example output:

    ```console
    $ tanzu workload get golang-app-grype-test  -n grype-app-scanning-catalog
    📡 Overview
      name:       golang-app-grype-test
      kind:       grypescs.example.com/golang-app-grype-test
      namespace:  grype-app-scanning-catalog
      age:        37m

    🏃 Runs:
      ID                                     STATUS     DURATION  AGE
      golang-app-grype-test-run-btlvx  Succeeded  4m13s     37m

    🔎 To view a run information, use 'tanzu workload run get run-id'
    ```

    For more information, [How to observe the Runs of your Workload](../../supply-chain/development/how-to/discover-workloads.hbs.md).

## <a id="verify-workload-scanning"></a>Check the workload scan results

Get the `ImageVulnerabilityScan` name by looking in the namespace it was created in:

```console
kubectl get ivs -n DEV-NAMESPACE
```

Example output:

```console
NAMESPACE                    NAME                          SUCCEEDED   REASON      AGE
dev-namespace                golang-app-test-123-bbrpz     True        Succeeded   4m52s
```

For information about how to retrieve scan results by using the `ImageVulnerabilityScan` name, see [Retrieve scan results](../verify-app-scanning.hbs.md#retrieve-scan-results).

For more information about how to create a workload, see [Work with Workloads](../../supply-chain/development/how-to/discover-workloads.hbs.md).
