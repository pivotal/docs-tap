The current state of the workloads is visible in the Tanzu Workloads view.
This view is a separate section in the bottom of the Explorer view in the Side Bar.
The view shows the current status of each workload, namespace, and cluster.
It also shows whether Live Update and Debug is running, stopped, or deactivated.

The Tanzu Activity tab in the Panels view enables developers to visualize the supply chain, delivery,
and running application pods.
The tab enables a developer to view and describe logs on each resource associated with a workload
from within their IDE. The tab displays detailed error messages for each resource in an error state.

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