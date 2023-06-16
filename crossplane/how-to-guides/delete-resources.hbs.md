# Delete Crossplane resources when you uninstall Tanzu Application Platform

This topic describes how to configure the Crossplane package to either retain or delete Crossplane
resources when you uninstall Tanzu Application Platform.

## <a id="about"></a>About deleting Crossplane resources

By default, the `crossplane.tanzu.vmware.com` package is configured to retain all Crossplane CRDs,
providers, and managed resources when the package is uninstalled.
This is in the interest of caution in relation to accidental deletion of stateful data.

Consider the following scenario. An organization is using Tanzu Application Platform.
They have installed the AWS Provider for Crossplane and are offering development teams self-serve
access to AWS RDS databases through
[Dynamic Provisioning](../../services-toolkit/how-to-guides/dynamic-provisioning-rds.hbs.md).
Development teams have created a number of AWS RDS databases and have bound them to their application
workloads. The AWS RDS databases now contain stateful data for the applications.
If an operator decides to uninstall Tanzu Application Platform, what happens to the AWS RDS databases?

The answer depends on whether you view the life cycle of external services provisioned through the
platform to be tied to the life cycle of the platform itself.
By default, Tanzu Application Platform does not tie the life cycle of the platform to the life cycle
of external services.
This means that you must delete any external resources after deleting Tanzu Application Platform.
However, Tanzu Application Platform provides the package value `orphan_resources` to override this
default behavior.

## <a id="override"></a>Override the default retention behavior

You can configure Tanzu Application Platform to delete Crossplane resources to avoid orphaned resources.
To do so, update the `tap-values.yaml` as follows:

```yaml
# tap-values.yaml

crossplane:
  orphan_resources: false
```
