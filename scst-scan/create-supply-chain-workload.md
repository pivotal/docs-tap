# Create a Workload from the Supply Chain

This topic covers how to create and apply a workload from a Tanzu Supply Chain, how to observe a workload, and how to verify the scanning performed in a workload.

## <a id="overview"></a> Overview

* [Create and apply workload](./create-supply-chain-workload.md#create-and-apply-workload)
* [Observe workload](./create-supply-chain-workload.md#observe-workload)
* [Verify workload performed scanning by checking scan results](./create-supply-chain-workload.md#verify-workload-performed-scanning-by-checking-scan-results)

### <a id="create-and-apply-workload"></a> Create and apply workload

This sections covers how to create a workload from an existing [supply chain](./create-supply-chain-with-app-scanning.md).

* Use the Tanzu Cartographer plugin to create workload from a specific supply chain:
  ```
  $ tanzu cartographer workload generate

  ? Select the supply chain:   [Use arrows to move, type to filter]
  > SCANNER-supply-chain-1.0.0 (11h)
    trivy-supply-chain-1.0.0 (3d)
  kind: Sample
  apiVersion: sample.com/v1alpha1
  metadata:
    name: example-sample
  spec:
    registry:
      ...
    scanning:
      ...
  ```
  Here the user can create a supply chain workload from the:
  * [Trivy Supply Chain](./create-supply-chain-with-app-scanning.md#create-supply-chain-with-scst---scan-20-and-trivy-supply-chain-component)
  * [Supply Chain with Custom Scanner Component](./create-supply-chain-with-app-scanning.md#create-supply-chain-with-scst---scan-20-and-the-custom-scanning-component)

This will render a sample workload yaml that the user can configure and put in a `workload.yaml`.

* Apply workload:
  ```
  $ kubectl apply -f workload.yaml -n DEV-NAMESPACE
  ```


### <a id="observe-workload"></a> Observe workload

This section shows how to use the Tanzu Cartographer CLI to observe a workload.

* List workloads in cluster:
  ```
  $ tanzu cartographer workload list
  ```

  The following is an example of the output of this command:
  ```
  $ tanzu cartographer workload list

  NAME                           NAMESPACE                   SUPPLY CHAIN                LATEST RUN                                  READY        AGE   MESSAGE                                     PROGRESS
  Sample/golang-app-test-123     grype-app-scanning-catalog  sample-supply-chain-1.0.0   SampleRun/golang-app-test-123-run-ccmrq     Running      2m4s  waiting for stage buildpack-build & 1 more  ##-
  Example/golang-app-test-456    grype-app-scanning-catalog  example-supply-chain-1.0.0  ExampleRun/golang-app-test-456-run-m4vb9    Not          33h                      ...
  ```

* View logs for a specific workload:
  ```
  $ tanzu cartographer workload tail Sample WORKLOAD-NAME
  ```
  Where WORKLOAD-NAME is the name of the workload for a specific Kind defined from the supply chain.

* View workload details:
  ```
  $ tanzu cartographer workload get Sample WORKLOAD-NAME
  ```


See [Tanzu Supply Chain docs](../supply-chain/development/how-to/observe-runs.hbs.md) for more details on how to observe runs of the workload.


### <a id="verify-workload-scanning-by-checking-scan-results"></a>Verify workload performed scanning by checking scan results

* Get the ivs name by looking for the IVS in the namespace it was created in:
  ```
  $ kubectl get ivs -n DEV-NAMESPACE

  NAMESPACE                    NAME                          SUCCEEDED   REASON      AGE
  DEV-NAMESPACE                golang-app-test-123-bbrpz     True        Succeeded   4m52s
  ```

* Follow this [verify app-scanning page](./verify-app-scanning.hbs.md#retrieve-scan-results) to see how to retrieve scan results by using the IVS name found in the previous step.