# Out of the Box Templates for Supply Chain Choreographer

This topic describes the templates you can use with Supply Chain Choreographer.

Templates define Kubernetes objects based on configuration in the workload,
supply chain Tanzu Application Platform values, and results output from other
templated objects. A supply chain organizes a set of templates into a directed
acyclic graph. This package contains templates that are used by the Out of the
Box Supply Chains and the Out of the Box Delivery. You must install this package
to have Workloads delivered properly.

The OOTB Template package includes:
- [Cartographer Templates](https://cartographer.sh/docs/v0.6.0/architecture/#templates):
  See [reference](ootb-template-reference.html)
- [Cartographer ClusterRunTemplates](https://cartographer.sh/docs/v0.6.0/runnable/architecture/#clusterruntemplate):
  See [reference](ootb-cluster-run-template-reference.hbs.md)
- [Tekton ClusterTasks](https://tekton.dev/docs/pipelines/tasks/#overview)
- [ClusterRoles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole)
- [openshift SecurityContextConstraints](https://docs.openshift.com/container-platform/3.11/admin_guide/manage_scc.html)

Read more about the OOTB Supply Chains/Delivery:

* [Out of the Box Supply Chain Basic](ootb-supply-chain-basic.html)
* [Out of the Box Supply Chain with Testing](ootb-supply-chain-testing.html)
* [Out of the Box Supply Chain with Testing and Scanning](ootb-supply-chain-testing-scanning.html)
* [Out of the Box Delivery Basic](ootb-delivery-basic.html)
