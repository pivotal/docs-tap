# Create a Workload from the Supply Chain

This topic covers how to create and apply a workload from a Tanzu Supply Chain, how to observe a
workload, and how to verify the scanning performed in a workload.

## <a id="define-and-create-workload"></a> Define and create workload

This section covers how to create a workload from an existing [supply chain created in the previous page](./create-supply-chain-with-app-scanning.hbs.md) that was created using SCST - Scan 2.0 and with
either the Trivy Supply Chain Component or Customized Scanning Component.
See [Tanzu Supply Chain docs](../../supply-chain/development/how-to/create-workloads.hbs.md) for more details on how to create a workload.

A user can define a workload in `yaml` or use the Tanzu Workload CLI plug-in to generate a workload manifest.

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

    * `KIND` is the kind defined in the [previous section](./create-supply-chain-with-app-scanning.hbs.md#create-a-supply-chain-that-uses-scst---scan-20-with-a-component) about creating Tanzu Supply Chains
    * `REGISTRY-REPOSITORY` is the registry server used for the scan results location.
    * `REGISTRY-SERVER` is the registry repository used for the scan results location.
    * `GIT-URL` is the git repo URL to clone from for the source component.
    * `GIT-BRANCH` is the git branch ref to watch for the new source.
    * `GIT-SUBPATH` is the path inside the bundle to lcoate source code.
    * For the above `GIT-*` values, see [Source Git Provider](../../supply-chain/reference/catalog/about.hbs.md#source-git-provider) for more details

### <a id="generate-workload"></a> Generate workload
Use the Tanzu Workload CLI plug-in to generate a workload from a configuration:
  ```console
  tanzu workload generate NAME --kind KIND
  ```
  Where `KIND` is the kind api resource defined in the previous [section](./create-supply-chain-with-app-scanning.hbs.md#create-a-supply-chain-that-uses-scst---scan-20-with-a-component)

  See [How to create a Workload](../../supply-chain/development/how-to/create-workloads.hbs.md) for more details from Tanzu Supply Chain docs.

  This renders a sample workload YAML that you can configure and put in a `workload.yaml`.

### <a id="create-workload"></a> Create workload

   Using the `workload.yaml` created in the previous section, create the workload:
   ```console
   tanzu workload create --file workload.yaml --namespace DEV-NAMESPACE
   ```

## <a id="observe-workload"></a> Observe workload

This section shows how to use the Tanzu Workload CLI to observe a workload.

1. List workloads in cluster:

    ```console
    tanzu workload list -n DEV-NAMESPACE
    ```

    Example output:

    ```console
    $ tanzu workload list -n grype-app-scanning-catalog

    Listing workloads from all namespaces

      NAMESPACE                   NAME                         KIND                  VERSION   AGE
      grype-app-scanning-catalog  golang-app-grype-test  grypescs.example.com  v1alpha1  35m

    🔎 To see more details about a workload, use 'tanzu workload get workload-name --kind workload-kind'
    ```

2. View workload details:

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

    For more information, [How to observe the Runs of your Workload](../../supply-chain/development/how-to/observe-runs.hbs.md).

## <a id="verify-workload-scanning"></a>Verify workload performed scanning by checking scan results

Get the ivs name by looking for the IVS in the namespace it was created in:

```console
$ kubectl get ivs -n DEV-NAMESPACE

NAMESPACE                    NAME                          SUCCEEDED   REASON      AGE
DEV-NAMESPACE                golang-app-test-123-bbrpz     True        Succeeded   4m52s
```

For information about how to retrieve scan results by using the IVS name, see [Retrieve scan results](../verify-app-scanning.hbs.md#retrieve-scan-results).
