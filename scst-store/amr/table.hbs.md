# table


| **Field** | **Description** | **Example** |**Can be used as query argument**|
|--------|---------|------------|------------|
|`guid`|String value unique identifier for each AppAcceleratorRuns|`appAcceleratorRuns(query:{guid: "d2934b09-5d4c-45da-8eb1-e464f218454e"})`|Yes|
|`source`|String representing the client used to run the accelerator. Supported values include `TAP-GUI`, `VSCODE`, and `INTELLIJ`|`appAcceleratorRuns(query:{source: "TAP-GUI"})`|Yes|
|`username`|String representing the user name of the person who runs the accelerator, as captured by the client UI.|`appAcceleratorRuns(query:{username: "test.user"})`|Yes|
|`namespace` and `name`|Strings representing the accelerator that was used to create an application.|`appAcceleratorRuns(query:{name: "tanzu-java-web-app"})`|Yes|
|`appAcceleratorRepoURL`, `appAcceleratorRevision`, and `appAcceleratorSubpath`|Location in VCS (Version Control System) of the accelerator sources used.|`appAcceleratorRuns(query:{
appAcceleratorRepoURL: "https://github.com/vmware-tanzu/application-accelerator-samples.git", appAcceleratorRevision: "v1.6"`|Yes|
|`timestamp`|String representation of the exact time the accelerator ran. You can query for runs that happened `before` or `after` a particular instant.|`appAcceleratorRuns(query: {timestamp: {after: "2023-10-11T13:40:46.952Z"}}`)|Yes|


|`appAcceleratorFragments`|a one-to-many container of nodes representing the fragment versions used in each `AppAcceleratorRuns`. These fragment nodes share many of the fields with `AppAcceleratorRuns`, with the same semantics but applied to the particular fragment. These include:
  - `namespace` and `name`: strings representing the identity of the fragment
  - `appAcceleratorFragmentSourceRepoURL` , `appAcceleratorFragmentSourceRevision`, and  `appAcceleratorFragmentSourceSubpath`: actual location in VCS of the sources of the fragment used
  - `appAcceleratorFragmentSource`: VCS information of the sources of the fragment, but navigable as a commit.|------------|No|

