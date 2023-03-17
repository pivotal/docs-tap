The current state of the workloads is visible on the Tanzu Workloads panel in the bottom of the editor
window.
The panel shows the current status of each workload, namespace, and cluster.
It also shows whether Live Update and Debug is running, stopped, or deactivated.

Because each workload is deployed on the cluster, the activity section on the right in the
Tanzu Workloads panel enables developers to visualize the supply chain, delivery, and running
application pods.
The panel displays detailed error messages on each resource and enables a developer to view and
describe logs on these resources from within their editor.

Workload commands are available from the Tanzu Workloads panel on workloads that have an associated
module in the current project.

This association is based on a module name and a workload name matching.
For example, a project with a module named `my-app` is associated with a deployed workload named
`my-app`.

When taking an action from the Tanzu Workloads panel, the action uses the namespace of the deployed
workload regardless of the configuration in the module.

For example, you might have a Live Update configuration with a namespace argument of `my-apps-1`,
but running the action from a deployed workload in namespace `my-apps-2` starts a Live Update
session with a namespace argument of `my-apps-2`.

The Tanzu Workloads panel uses the cluster and defaults to the namespace specified in the current
kubectl context.