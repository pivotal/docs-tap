# Integrating cloud services into Tanzu Application Platform

There are a countless and ever-growing number of cloud-based services available on the market
for consumers today.
The three big clouds - AWS, Azure and GCP all provide support for a wide range of fully-managed,
performant and on<!--฿ Insert the Oxford comma if it is missing here. ฿-->-demand services ranging from databases, to message queues, to storage solutions and beyond.
In this tutorial you will<!--฿ Avoid |will|: present tense is preferred. ฿--> learn what it takes to integrate any one of these services into
Tanzu Application Platform, so that it can be<!--฿ Consider switching to active voice. ฿--> can offered to and consumed by apps teams in a simple<!--฿ Avoid suggesting an instruction is |simple| or |easy|. ฿--> and effective way.

This tutorial is written at a slightly higher level than the other tutorials in this documentation.
This is because it is simply<!--฿ Avoid suggesting an instruction is |simple| or |easy|. ฿--> not feasible to write detailed, step-by-step documentation for integrating
each and every cloud-based service into Tanzu Application Platform.
There are far too many of them, each bringing with them a different set of considerations and concerns.
Instead, this tutorial guides you through the general approach to integrating cloud-based services into
Tanzu Application Platform.
While specific configurations will<!--฿ Avoid |will|: present tense is preferred. ฿--> of course change between services, the overall process<!--฿ Avoid nominalization: |while deleting| is better than |during the deletion process|. ฿--> remains
the same through a consistent set of steps.
It is these steps that this tutorial focusses on.
The aim is to give you just<!--฿ Avoid uses that suggest a task is simple. ฿--> enough understanding so that you are able to<!--฿ |can| is preferred. ฿--> go off and to integrate
whatever cloud-based service you like into Tanzu Application Platform.

If you are interested in a more specific and low-level walkthrough, see
[Configure dynamic provisioning of AWS RDS service instances](../how-to-guides/dynamic-provisioning-rds.hbs.md),
which walks through each step in detail for AWS RDS integration.
It may<!--฿ |can| usually works better. Use |might| to convey possibility. ฿--> be useful to read through that guide even if you are hoping to integrate with one of the other cloud providers.

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

The first step is to install a suitable Crossplane `Provider` for your cloud of choice. Upbound provides support for the 3 main clouds via<!--฿ |through|, |using| and |by means of| are preferred. ฿--> [provider-aws](https://marketplace.upbound.io/providers/upbound/provider-aws/latest), [provider-azure](https://marketplace.upbound.io/providers/upbound/provider-azure/latest) and [provider-gcp](https://marketplace.upbound.io/providers/upbound/provider-gcp/latest).

Choose whichever Provider you want,<!--฿ Consider deleting |then| or writing |and| after the comma. ฿--> then follow Upbound's official documentation to install the `Provider` and to create a corresponding `ProviderConfig`.

    > **Note** The official documentation for the Providers include a step to "Install Universal Crossplane",
    > which you can safely skip over as Crossplane is already installed as part of Tanzu Application Platform.
    > The documentation also assumes<!--฿ Do not write |this procedure assumes x|. Rewrite as prerequisites. ฿--> Crossplane to be installed in the `upbound-system` namespace,
    > however when working with Crossplane on Tanzu Application Platform it is installed to the `crossplane-system` namespace by default.
    > Bear this in mind when it comes to creating the `Secret` and the `ProviderConfig` with credentials for the `Provider`.

    > **Note** Be aware<!--฿ To avoid anthropomorphism, use |detects|. ฿--> of the fact that<!--฿ |because| might be better. ฿--> these cloud-based Providers often install many hundreds of additional CRDs into<!--฿ Do not stack notes. ฿-->
    > the cluster, which can have a negative impact on cluster performance.
    > See [Cluster performance degradation due to large number of CRDs](../reference/known-limitations.hbs.md#too-many-crds) for further information.

### <a id="procedure"></a> Step 2: Create CompositeResourceDefinition

The next step is to create a `CompositeResourceDefinition`, which defines the shape of a new API type which will<!--฿ Avoid |will|: present tense is preferred. ฿--> be used to create the cloud-based resource(s)<!--฿ Do not combine a singular and a plural. Maybe write |one or more| instead. ฿-->.

For help creating the `CompositeResourceDefinition`, refer to<!--฿ If telling the reader to read something else, use |see|. ฿--> [Defining Composite Resources](https://docs.crossplane.io/latest/concepts/composition/#defining-composite-resources) in the Upbound documentation, or refer to<!--฿ If telling the reader to read something else, use |see|. ฿--> [Step 2: Create CompositeResourceDefinition](../how-to-guides/dynamic-provisioning-rds.hbs.md#compositeresourcedef) in the how-to guide [Configure Dynamic Provisioning of AWS RDS Service Instances](../how-to-guides/dynamic-provisioning-rds.hbs.md) in the services toolkit documentation.

### <a id="create-composition"></a> Step 3: Create Composition

This step is likely to be the most difficult and time-consuming. The `Composition` is essentially where you define configuration for the resource(s)<!--฿ Do not combine a singular and a plural. Maybe write |one or more| instead. ฿--> that will<!--฿ Avoid |will|: present tense is preferred. ฿--> ultimately make up the service instances that will<!--฿ Avoid |will|: present tense is preferred. ฿--> be claimed by<!--฿ Active voice is preferred. ฿--> apps teams. You will<!--฿ Avoid |will|: present tense is preferred. ฿--> need to<!--฿ |must| is preferred or, better, rephrase as an imperative. ฿--> configure whatever resources are necessary to result in<!--฿ Consider replacing with |cause|. ฿--> usable service instances which can be<!--฿ Consider switching to active voice. ฿--> connected to and utilized over the network.

The best way to get started with `Compositions` is to first read through [Configuring Composition](https://docs.crossplane.io/v1.11/concepts/composition/#configuring-composition) in the Upbound documentation. Then refer to<!--฿ If telling the reader to read something else, use |see|. ฿--> example `Compositions` to get a better feel for what they look like. See an AWS example of [Define composite resource types](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/usecases-consuming_aws_rds_with_crossplane.html#define-composite-resource-types-5)<!--฿ Find the anchor this link points to and give it a short HTML anchor ID, such as |anchor-id| -- keep it under 25 chars and use dashes instead of spaces -- then change this link to point to that HTML anchor ID. ฿--> for a `Composition` for AWS RDS. See an Azure example of [Define Composite Resource Types](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/usecases-consuming_azure_database_with_crossplane.html#define-composite-resource-types-7)<!--฿ Find the anchor this link points to and give it a short HTML anchor ID, such as |anchor-id| -- keep it under 25 chars and use dashes instead of spaces -- then change this link to point to that HTML anchor ID. ฿--> for a `Composition` for Azure Flexible Server and see a GCP example of [Define Composite Resource Types](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.9/svc-tlk/usecases-consuming_gcp_sql_with_crossplane.html#define-composite-resource-types-5)<!--฿ Find the anchor this link points to and give it a short HTML anchor ID, such as |anchor-id| -- keep it under 25 chars and use dashes instead of spaces -- then change this link to point to that HTML anchor ID. ฿--> for a `Composition` for GCP Cloud SQL.

### <a id="clusterinstanceclass"></a> Step 4: Create provisioner-based ClusterInstanceClass

This step is fairly straightforward. You simply<!--฿ Avoid suggesting an instruction is |simple| or |easy|. ฿--> need to<!--฿ |must| is preferred or, better, rephrase as an imperative. ฿--> create a provisioner-based `ClusterInstanceClass` which is configured to refer to<!--฿ If telling the reader to read something else, use |see|. ฿--> the `CompositeResourceDefinition` created in step 2<!--฿ |earlier| or |later| is preferred instead of referring to the step number: numbers can change with edits. ฿-->. For example:

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
      compositeResourceDefinition: <NAME OF THE COMPOSITE RESOURCE DEFINITION>
```

See [Step 4: Make the service discoverable to application teams](../how-to-guides/dynamic-provisioning-rds.hbs.md#make-discoverable) for a real-world example.

### <a id="configure-rbac"></a> Step 5: Configure RBAC

This step is also fairly straightforward. You simply<!--฿ Avoid suggesting an instruction is |simple| or |easy|. ฿--> need to<!--฿ |must| is preferred or, better, rephrase as an imperative. ฿--> create an RBAC rule using the `claim` verb pointing to the `ClusterInstanceClass` created in the previous step<!--฿ Write |earlier in this procedure| or, if referring to a separate procedure, link to it. ฿-->. For example:

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

See [Step 5: Authorize users with the app-operator role to claim from the class](../how-to-guides/dynamic-provisioning-rds.hbs.md#configure-rbac) for a real-world example.

### <a id="create-claim"></a> Step 6: Create ClassClaim

This is the step in which everything comes together and is your first chance to test everything out end-to-end. Simply<!--฿ Redundant ฿--> create a `ClassClaim` which points to the `ClusterInstanceClass` created in the previous step<!--฿ Write |earlier in this procedure| or, if referring to a separate procedure, link to it. ฿-->. For example:

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

Check<!--฿ |Verify|, |Ensure|, and |Confirm| are all preferred. ฿--> to see that the `ClassClaim` eventually transitions into a `READY=True` state. If it doesn't, then you will<!--฿ Avoid |will|: present tense is preferred. ฿--> need to<!--฿ |must| is preferred or, better, rephrase as an imperative. ฿--> debug what has gone wrong, using `kubectl` <!--฿ Do not format |kubectl| as code. ฿-->to trace your way back from `ClassClaim` -> `ClusterInstanceClass` -> `CompositeResourceDefinition` -> `CompositeResource` -> Managed Resource(s)<!--฿ Do not combine a singular and a plural. Maybe write |one or more| instead. ฿--> and resolving any errors encountered along the way.
