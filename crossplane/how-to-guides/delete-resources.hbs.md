# Delete all Crossplane resources upon deletion of Tanzu Application Platform

This topic describes how to configure the crossplane.tanzu.vmware.com Package to either orphan (default) or to delete Crossplane resources upon deletion of Tanzu Application Platform.

## About

By default, the crossplane.tanzu.vmware.com Package is configured to orphan (i.e. not delete) all Crossplane CRDs, providers, and managed resources when the package is uninstalled. This is in the interest of erring on the side of caution in relation to accidental deletion of stateful data. Picture the following scenario.

An organization is using Tanzu Application Platform. They have installed the AWS Provider for Crossplane and are offering development teams self-serve access to AWS RDS databases through [Dynamic Provisioning](../../services-toolkit/how-to-guides/dynamic-provisioning-rds.hbs.md). Development teams have created a number of AWS RDS databases and have bound them to their application workloads. The AWS RDS databases now contain stateful data for the applications. After some time, an operator decides to uninstall Tanzu Application Platform. What should happen to the AWS RDS databases in this situation?

The answer to this question depends on whether or not you view the lifecycle of external services provisioned via the platform to be intrinsically tied to the lifecycle of the platform itself. By default, Tanzu Application Platform assumes that the lifecycles should not be tied, meaning that any external resources must be explicitly deleted after deleting Tanzu Application Platform. However, a Package value `orphan_resources` is provided to override this default behaviour if desired.

## How to override the default orphaning behaviour

This option can be configured in tap-values.yaml.

```yaml
# tap-values.yaml

crossplane:
  orphan_resources: false
```
