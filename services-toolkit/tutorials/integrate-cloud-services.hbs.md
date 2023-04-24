# Integrating cloud services into Tanzu Application Platform

There are a multitude of cloud-based services available on the market for consumers today.
AWS, Azure, and GCP all provide support for a wide range of fully-managed, performant and
on-demand services ranging from databases, to message queues, to storage solutions and beyond.
In this tutorial you will learn how to integrate any one of these services into Tanzu Application Platform,
so that you can offer it for apps teams to consume in a simple and effective way.

This tutorial is written at a slightly higher level than the other tutorials in this documentation.
This is because it is not feasible to write detailed, step-by-step documentation for integrating
every cloud-based service into Tanzu Application Platform.
Each service brings a different set of considerations and concerns.

Instead, this tutorial guides you through the general approach to integrating cloud-based services into
Tanzu Application Platform.
While specific configurations change between services, the overall process remains the same through a
consistent set of steps.
The aim is to give you enough understanding so that you can integrate any cloud-based service
you want into Tanzu Application Platform.

For a more specific and low-level procedure, see
[Configure dynamic provisioning of AWS RDS service instances](../how-to-guides/dynamic-provisioning-rds.hbs.md),
which provides each step in detail for AWS RDS integration.
It might be useful to read through that guide even if you want to integrate with one of the other
cloud providers.

## <a id="about"></a> About this tutorial

**Target user role**:       Service Operator<br />
**Complexity**:             Advanced<br />
**Estimated time**:         30 minutes<br />
**Topics covered**:         Dynamic Provisioning, Cloud-based Services, AWS, Azure, GCP, Crossplane<br />
**Learning outcomes**:      An understanding of the steps involved in integrating cloud-based services
into Tanzu Application Platform<br />

## <a id="concepts"></a> Concepts

The following diagram shows, at a high-level, what is required to integrate a cloud-based service into
Tanzu Application Platform.

![Diagram shows a high-level overview of the steps required to integrate a cloud-based service into Tanzu Application Platform.](../../images/stk-integrate-cloud-service.png)

## <a id="procedure"></a> Procedure

This tutorial provides the steps required to integrate cloud services, and includes tips and references
to example configurations where appropriate.

### <a id="install-provider"></a> Step 1: Installing a Provider

Install a suitable Crossplane `Provider` for your cloud of choice. Upbound provides support for the
three main cloud providers:

- [provider-aws](https://marketplace.upbound.io/providers/upbound/provider-aws/latest)
- [provider-azure](https://marketplace.upbound.io/providers/upbound/provider-azure/latest)
- [provider-gcp](https://marketplace.upbound.io/providers/upbound/provider-gcp/latest)

> **Note:** These cloud-based Providers often install many hundreds of additional CRDs onto the cluster,
> which can have a negative impact on cluster performance.
> For more information, see [Cluster performance degradation due to large number of CRDs](../reference/known-limitations.hbs.md#too-many-crds).

Choose the Provider you want, and then follow Upbound's official documentation to install the
`Provider` and to create a corresponding `ProviderConfig`.

> **Note** The official documentation for the `Provider` includes a step to "Install Universal Crossplane".
> You can skip this step because Crossplane is already installed as part of Tanzu Application Platform.
> The documentation also assumes Crossplane is installed in the `upbound-system` namespace.
> However, when working with Crossplane on Tanzu Application Platform, it is installed to the
> `crossplane-system` namespace by default.
> Bear this in mind when it comes to creating the `Secret` and the `ProviderConfig` with credentials
> for the `Provider`.

### <a id="procedure"></a> Step 2: Create CompositeResourceDefinition

Create a `CompositeResourceDefinition`, which defines the shape of a new API type which is used to
create the cloud-based resources.

For help creating the `CompositeResourceDefinition`, see the [Crossplane documentation](https://docs.crossplane.io/latest/concepts/composition/#defining-composite-resources),
or see [Create a CompositeResourceDefinition](../how-to-guides/dynamic-provisioning-rds.hbs.md#compositeresourcedef)
in _Configure dynamic provisioning of AWS RDS service instances_.

### <a id="create-composition"></a> Step 3: Create Composition

This step is likely to be the most time-consuming.
The `Composition` is where you define the configuration for the resources that make up the service
instances for app teams to claim.
Configure the necessary resources for usable service instances that users can connect to and use
over the network.

To get started with `Compositions`, first read through Configuring Composition in the
[Upbound documentation](https://docs.crossplane.io/v1.11/concepts/composition/#configuring-composition).
Then see the example `Compositions` to get a better feel for what they look like.

You can also see the following examples:

- For a `Composition` for AWS RDS, see
  [Define composite resource types (AWS)](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/usecases-consuming_aws_rds_with_crossplane.html#def-comp-rsrc-types).

- For a `Composition` for Azure Flexible Server, see
  [Define Composite Resource Types (Azure)](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/usecases-consuming_azure_database_with_crossplane.html#define-composite-resource-types-7).

- For a `Composition` for GCP Cloud SQL, see
  [Define Composite Resource Types (GCP)](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/usecases-consuming_gcp_sql_with_crossplane.html#define-composite-resource-types-5).

<!-- above examples could be moved to the TAP docs so we don't link to the old version of the STK docs -->

### <a id="clusterinstanceclass"></a> Step 4: Create provisioner-based ClusterInstanceClass

Create a provisioner-based `ClusterInstanceClass` which is configured to refer to the
`CompositeResourceDefinition` created earlier. For example:

```yaml
---
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ClusterInstanceClass
metadata:
  name: cloud-service-foo
spec:
  description:
    short: FooDB by cloud provider Foo!
  provisioner:
    crossplane:
      compositeResourceDefinition: NAME-OF-THE-COMPOSITE-RESOURCE-DEFINITION
```

For a real-world example, see [Make the service discoverable](../how-to-guides/dynamic-provisioning-rds.hbs.md#make-discoverable)
in _Configure dynamic provisioning of AWS RDS service instances_.

### <a id="configure-rbac"></a> Step 5: Configure RBAC

Create an Role-Based Access Control (RBAC) rule using the `claim` verb pointing to the
`ClusterInstanceClass` you created. For example:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: app-operator-claim-foo-db
  labels:
    apps.tanzu.vmware.com/aggregate-to-app-operator-cluster-access: "true"
rules:
- apiGroups:
  - "services.apps.tanzu.vmware.com"
  resources:
  - clusterinstanceclasses
  resourceNames:
  - cloud-service-foo
  verbs:
  - claim
```

For a real-world example, see [Configure RBAC](../how-to-guides/dynamic-provisioning-rds.hbs.md#configure-rbac)
in _Configure dynamic provisioning of AWS RDS service instances_.

### <a id="create-claim"></a> Step 6: Create ClassClaim

To test your integration, create a `ClassClaim` that points to the `ClusterInstanceClass` you created.
For example:

```yaml
---
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ClassClaim
metadata:
  name: claim-1
spec:
  classRef:
    name: cloud-service-foo
  parameters:
    key: value
```

Verify that the `ClassClaim` eventually transitions into a `READY=True` state.
If it doesn't, debug what has gone wrong, using kubectl.
For how to do this, see [Troubleshoot Services Toolkit](../how-to-guides/troubleshooting.hbs.md#debug-dynamic-provisioning).
