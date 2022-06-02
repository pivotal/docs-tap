# Release notes

This topic contains release notes for Tanzu Application Platform v1.2


## <a id='1-2-0'></a> v1.2.0

**Release Date**: MONTH DAY, 2022

### <a id='1-2-new-features'></a> New features


This release includes the following changes, listed by component and area.


#### <a id="app-acc-features"></a> Application Accelerator

- Feature 1
- Feature 2

#### Application Live View

- Feature 1
- Feature 2

#### Tanzu CLI - Apps plug-in

- Feature 1
- Feature 2

#### Service Bindings

- Feature 1
- Feature 2

#### Source Controller

- Feature 1
- Feature 2

#### Spring Boot Conventions

- Feature 1
- Feature 2

#### Supply Chain Choreographer

- View resource status on a workload
  - Added ability to indicate how Cartographer can read the state of the resource and reflect it on the owner status.
  - Surfaces information about the health of resources directly on the owner status.
  - Adds a field in the spec `healthRule` where authors can specify how to determine the health of the underlying resource for that template. The resource can be in one of the following states: A stamped resource can be in one of three states: 'Healthy' (status True), 'Unhealthy' (status False), or 'Unknown'  (status Unknown). If no healthRule is defined, Cartographer defaults to listing the resource as `Healthy` once it is successfully applied to the cluster and any outputs are read off the resource.

#### Supply Chain Security Tools - Scan

- Feature 1
- Feature 2

#### Supply Chain Security Tools - Sign

- Feature 1
- Feature 2

#### Supply Chain Security Tools - Store

- Feature 1
- Feature 2

#### Tanzu Application Platform GUI

- Supply Chain Plug-in
  - Added ability to visualize CVE scan results in the Details pane for both Build and Image Scan stages, as well as scan policy information, without using the CLI
  - Added ability to visualize the deployment of a workload as a deliverable in a multicluster environment in the supply chain graph
  - Added a deeplink to view approvals for PRs in a GitHub repository so that PRs can be reviewed and approved, resulting in the deployment of a workload to any cluster configured to accept a deployment
  - Added Reason column to the Workloads table to indicate causes for errors encountered during supply chain execution

- Feature 2

#### Functions (Beta)

- Feature 1
- Feature 2


### <a id='1-2-breaking-changes'></a> Breaking changes

This release has the following breaking changes, listed by area and component.

#### <a id="app-acc-changes"></a> Application Accelerator

- Breaking change 1
- Breaking change 2

#### Supply Chain Security Tools - Scan

- Breaking change 1
- Breaking change 2

#### Supply Chain Security Tools - Store

- Breaking change 1
- Breaking change 2


### <a id='1-2-resolved-issues'></a> Resolved issues

This following issues, listed by area and component, are resolved in this release.


#### <a id="app-acc-resolved"></a> Application Accelerator

- Resolved issue 1
- Resolved issue 2

#### <a id="alv-resolved"></a> Application Live View

- Resolved issue 1
- Resolved issue 2

#### Services Toolkit

- Resolved issue 1
- Resolved issue 2

#### Supply Chain Security Tools - Scan

- Resolved issue 1
- Resolved issue 2

#### Grype Scanner

- Resolved issue 1
- Resolved issue 2

#### Supply Chain Security Tools - Store

- Resolved issue 1
- Resolved issue 2

#### Tanzu CLI - Apps plug-in

- Resolved issue 1
- Resolved issue 2

#### Tanzu Application Platform GUI

- Resolved issue 1
- Resolved issue 2


### <a id='1-2-known-issues'></a> Known issues

This release has the following known issues, listed by area and component.

#### Tanzu Application Platform

- Known issue 1
- Known issue 2

#### Tanzu Cluster Essentials

- Known issue 1
- Known issue 2

#### Application Live View

- Known issue 1
- Known issue 2

#### Grype scanner

- Known issue 1
- Known issue 2

#### Supply Chain Security Tools - Scan

- Known issue 1
- Known issue 2

#### Supply Chain Security Tools - Store

- Known issue 1
- Known issue 2

#### Tanzu Application Platform GUI

- Known issue 1
- Known issue 2
