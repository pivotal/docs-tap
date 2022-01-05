# Known issues
The Apps plug-in for the Tanzu CLI has the following known issues:

* **`tanzu apps workload get`**
  * Passing in `--output json` along with and the `--export` flag returns yaml rather than json. Support for honoring the `--output json` with `--export` will be added in the next release.
* **`tanzu apps workload create/update/apply`**
  * `--image` is not supported by the default supply chain in Tanzu Application Platform Beta 3 release.
  * `--wait` functions as expected when a workload is created for the first time but may return prematurely on subsequent updates when passed with `workload update/apply` for existing workloads. 
    * When the `--wait` flag is included and you decline the "Do you want to create this workload?" prompt, the command continues to wait and must be cancelled manually.
