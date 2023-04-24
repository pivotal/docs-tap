# Set up dynamic provisioning of service instances

In this tutorial you will learn how to set up a new, self-serve and "customized-to-your-needs"
service for Tanzu Application Platform.
The example uses Tanzu RabbitMQ the service, but the steps and learnings can apply to almost any
other service.

## <a id="about"></a> About this tutorial

**Target user role**:       Service Operator<br />
**Complexity**:             Advanced<br />
**Estimated time**:         60 minutes<br />
**Topics covered**:         Dynamic Provisioning, Crossplane, Tanzu RabbitMQ Cluster Kubernetes operator<br />
**Learning outcomes**:      Ability to offer new, on-demand, and customized services in your Tanzu Application Platform clusters<br />

## <a id="prereqs"></a> Prerequisites

- Access to a Tanzu Application Platform cluster v1.5.0 or later.
- Surface level familiarity with Crossplane, particularly the concepts of
  [Composition and CompositeResourceDefinitions](https://docs.crossplane.io/v1.11/concepts/composition/).

## <a id="scenario"></a> Scenario

The tutorial is centered around the following hypothetical, but somewhat realistic, real-world scenario.

You work at BigCorp and are tasked to provide an on-demand, self-serve RabbitMQ service for BigCorp's
development teams who are working with Tanzu Application Platform.
You have already reviewed the pre-installed offering for RabbitMQ, but have discovered
that while it is an excellent service for testing and for quickly getting started,
it is not quite suitable for BigCorp's stringent and specific needs.

In particular, you must comply with BigCorp's auditing and logging policy, and want to enforce that
every RabbitMQ cluster in use on the platform adheres to that policy.
At the same time, you don't want to be a blocker for the application teams and want to offer
them self-serve access to RabbitMQ whenever they need it, without incurring any untoward delays.
You have heard great things about Tanzu Application Platform's dynamic provisioning capability, and
are now looking to make use of it to help you complete your task.

In this tutorial you will learn how to:

- Install the RabbitMQ Cluster Kubernetes operator
- Create a `CompositeResourceDefinition`
- Create a `Composition`
- Create a provisioner-based class
- Understand and create the necessary RBAC permissions
- Create a claim for the class to test it all out
- Understand how all the pieces fit together to power the dynamic provisioning capability in
  Tanzu Application Platform

## <a id="concepts"></a> Concepts

The following diagram provides an overview of the elements of dynamic provisioning and how they fit together.

![Diagram shows a high-level overview of dynamic provisioning.](../../images/stk-dynamic-provisioning-overview.png)

There's<!--฿ Avoid a contraction if it is too colloquial or awkward or uncommonly used. ฿--> quite a lot to digest there, but don't worry! We<!--฿ |VMware|, the product name, or another term is preferred. Define who |We| is for the reader is preferred. ฿-->'ll be covering everything in more detail later on. For now, here is a very high-level overview of how the system works.

1. The service operator creates a `CompositeResourceDefinition` and a `Composition`, which together
   define the configuration of the service instances that will be dynamically provisioned.
2. The service operator creates a class pointing to the `CompositeResourceDefinition`.
   This informs application development teams that the service is available.
3. The service operator applies necessary Role-Based Access Control (RBAC) to permit the system to
   create the necessary resources, and to authorize application development teams to create claims
   for the class.
4. The application developer creates a claim referring to the class, optionally passing through
   parameters to override any default configuration where permissible.
5. The system creates a `CompositeResource`, merging information provided in the claim with default
   configuration specified by the system and configuration defined in the `Composition`.
6. Crossplane reconciles the `CompositeResource` into a service instance and writes credentials for
   the instance into a `Secret`.
7. The `Secret` is written back to the application developer's namespace, so that application workloads
   can use it.

## <a id="procedure"></a> Procedure

The following steps show how to configure dynamic provisioning for a service.

### <a id="install-operator"></a> Step 1: Install the operator

When adding any new service to Tanzu Application Platform, ensure that there are a suitable set of
APIs available in the cluster from which to construct the service instances.
Usually, this involves installing one or more Kubernetes Operators into the cluster.

Given the aim of this tutorial is to set up a new RabbitMQ service, install the RabbitMQ Cluster
Operator for Kubernetes.

> **Note** The steps in this tutorial use the open source version of the operator.
> For most real-world deployments, VMware recommends using the official, supported version provided
> by VMware.
> For more information, see [VMware RabbitMQ for Kubernetes](https://docs.vmware.com/en/VMware-RabbitMQ-for-Kubernetes/index.html).

Use `kapp` to install the operator by running:

```console
kapp -y deploy --app rmq-operator --file https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yaml
```

This causes a new API Group/Version of `rabbitmq.com/v1beta1` and Kind named `RabbitmqCluster` to
become available in the cluster.
You can now use this API to create RabbitMQ cluster instances as part of the dynamic provisioning setup.

### <a id="create-xrd"></a> Step 2: Creating a `CompositeResourceDefinition`

Tanzu Application Platform's dynamic provisioning capability relies on
[Crossplane](https://www.crossplane.io/).
You can find the specific integration point at `.spec.provisioner.crossplane.compositeResourceDefinition`
in Tanzu Application Platform's `ClusterInstanceClass` API.

As the name suggests, this field is looking for a `CompositeResourceDefinition`, which you create
in this step of the procedure.
The `CompositeResourceDefinition` (XRD) defines the shape of a new, custom API type that encompasses
the specific set of requirements laid out by the scenario in this tutorial.

Create a file named `xrabbitmqclusters.messaging.bigcorp.org.xrd.yaml` and copy in the following contents.

```yaml
# xrabbitmqclusters.messaging.bigcorp.org.xrd.yaml

---
apiVersion: apiextensions.crossplane.io/v1
kind: CompositeResourceDefinition
metadata:
  name: xrabbitmqclusters.messaging.bigcorp.org
spec:
  connectionSecretKeys:
  - host
  - password
  - port
  - provider
  - type
  - username
  group: messaging.bigcorp.org
  names:
    kind: XRabbitmqCluster
    plural: xrabbitmqclusters
  versions:
  - name: v1alpha1
    referenceable: true
    schema:
      openAPIV3Schema:
        properties:
          spec:
            description: The OpenAPIV3Schema of this Composite Resource Definition.
            properties:
              replicas:
                description: The desired number of replicas forming the cluster
                type: integer
              storageGB:
                description: The desired storage capacity of a single replica, in GB.
                type: integer
            type: object
        type: object
    served: true
```

Then use kubectl to apply the file to the Tanzu Application Platform cluster.

```console
kubectl apply -f xrabbitmqclusters.messaging.bigcorp.org.xrd.yaml
```

For a full and detailed explanation of `CompositeResourceDefinition` see, the
[Crossplane documentation](https://docs.crossplane.io/v1.10/concepts/composition/#defining-composite-resources).

The following is a condensed explanation of the most relevant pieces of the `CompositeResourceDefinition`
configuration, provided in this section, as it relates to dynamic provisioning in Tanzu Application Platform.

The example in this tutorial does **not** specify `.spec.claimNames` in the XRD.
Tanzu Application Platform's dynamic provisioning capability makes use of Crossplane's cluster-scoped
Composite Resources, rather than the namespace-scoped Claims ("Claims" here not to be confused with Tanzu Application Platform's own concept of claims).
As such, this configuration is not required, although it does not cause any adverse effects if you add it.

Next, see the `.spec.connectionKeys` field. This field detects the keys that will exist in the `Secret`
resulting from the dynamic provisioning request.
You likely want this `Secret` to conform with the [Service Binding Specification for Kubernetes](https://github.com/servicebinding/spec),
as this, in part, is what allows for automatic configuration of the service instance by
Tanzu Application Platform's application workloads.
This is assuming that the application is using a binding-aware library such as [Spring Cloud Bindings](https://github.com/spring-cloud/spring-cloud-bindings).
Specific key name requirements vary by service type, however all must provide the `type` key.

Finally, see the `.spec.properties` section in the schema for `v1alpha1`.
This is where you, as the service operator, can set which configuration options you want to expose
to application development teams.
In the example in this section, there are two configuration options: `replicas` and `storageGB`.
By adding these properties to the specification, you are handing over control of these specific
configuration options to the development teams.
For example, you might want to add `storageGB` if the development teams have more knowledge about
how much storage their apps require than you do. By adding `storageGB` you can allow them to decide
for themselves how much storage they require.

You can choose to add as many or as few configuration options here as you like.
You can also choose to set default values. In highly regulated environments, you might not want to
allow for any configuration by developers at all.

In the scenario at the beginning of this tutorial, it says that you must comply with the auditing
and logging policy.
You do not specify any configuration related to auditing or logging in the XRD in this step.
This is intentional as in this scenario there are strict auditing and logging requirements and cannot
permit developers to override those.
In the next step you learn how to ensure that those requirements get enforced on the resulting
RabbitMQ clusters.

To verify the status of the XRD you created, run:

```console
kubectl get xrds
```

If successful, the `xrabbitmqclusters.messaging.bigcorp.org` is listed with `ESTABLISHED=True`.

You might see some other XRDs listed as well. These are the `*.bitnami.*.tanzu.vmware.com` XRDs.
These are part of the `bitnami.services.tanzu.vmware.com` package with Tanzu Application Platform and
serve as the basis of the pre-installed services.
You can ignore these other XRDs for now, but if you want to see how they are used in practice, see
[Claim services on Tanzu Application Platform](../../getting-started/consume-services.hbs.md) and
[Consume services on Tanzu Application Platform](../../getting-started/consume-services.hbs.md)
in the Tanzu Application Platform getting started guide.

As a result of creating the XRD, a new API Group/Version of `messaging.bigcorp.org/v1alpha1` and Kind
named `XRabbitmqCluster` become available in the cluster.
If you inspect this API further, notice that the `replicas` and `storageGB` properties configured in
the XRD are present in the specification of `XRabbitmqCluster`.

```console
kubectl explain --api-version=messaging.bigcorp.org/v1alpha1 xrabbitmqclusters.spec
```

You will also notice that Crossplane has injected some other fields into the specification as well,
but you can mostly ignore these for now.

### <a id="create-composition"></a> Step 3: Creating a Crossplane `Composition`

This step is the big one. Most of the time and effort involved in configuring dynamic provisioning will<!--฿ Avoid |will|: present tense is preferred. ฿--> likely be spent in creating Crossplane's `Compositions`. They can look quite intimidating at first, but fear not! This tutorial is here to guide you through all the most important steps. Like before, it is recommended<!--฿ Rewrite as an imperative if it is best practice. If you must recommend, specify the party recommending (VMware, Cloud Foundry, etc), give a reason, and do not recommend third-party software. ฿--> to refer to<!--฿ If telling the reader to read something else, use |see|. ฿--> Crossplane's official documentation for a full and detailed explanation of `Composition`s, what follows here are the basics you need to<!--฿ |must| is preferred or, better, rephrase as an imperative. ฿--> know to be able to<!--฿ |can| is preferred. ฿--> start creating `Compositions` for use in Tanzu Application Platform.

Start by creating a file named `xrabbitmqclusters.messaging.bigcorp.org.composition.yaml` and copying in the following contents.

```yaml
# xrabbitmqclusters.messaging.bigcorp.org.composition.yaml

---
apiVersion: apiextensions.crossplane.io/v1
kind: Composition
metadata:
  name: xrabbitmqclusters.messaging.bigcorp.org
spec:
  compositeTypeRef:
    apiVersion: messaging.bigcorp.org/v1alpha1
    kind: XRabbitmqCluster
  resources:
  - base:
      apiVersion: kubernetes.crossplane.io/v1alpha1
      kind: Object
      spec:
        forProvider:
          manifest:
            apiVersion: rabbitmq.com/v1beta1
            kind: RabbitmqCluster
            metadata:
              namespace: rmq-clusters
            spec:
              terminationGracePeriodSeconds: 0
              replicas: 1
              persistence:
                storage: 1Gi
              resources:
                requests:
                  cpu: 200m
                  memory: 1Gi
                limits:
                  cpu: 300m
                  memory: 1Gi
              rabbitmq:
                envConfig: |
                  RABBITMQ_LOGS=""
                additionalConfig: |
                  log.console = true
                  log.console.level = debug
                  log.console.formatter = json
                  log.console.formatter.json.field_map = verbosity:v time msg domain file line pid level:-
                  log.console.formatter.json.verbosity_map = debug:7 info:6 notice:5 warning:4 error:3 critical:2 alert:1 emergency:0
                  log.console.formatter.time_format = epoch_usecs
        connectionDetails:
        - apiVersion: v1
          kind: Secret
          namespace: rmq-clusters
          fieldPath: data.provider
          toConnectionSecretKey: provider
        - apiVersion: v1
          kind: Secret
          namespace: rmq-clusters
          fieldPath: data.type
          toConnectionSecretKey: type
        - apiVersion: v1
          kind: Secret
          namespace: rmq-clusters
          fieldPath: data.host
          toConnectionSecretKey: host
        - apiVersion: v1
          kind: Secret
          namespace: rmq-clusters
          fieldPath: data.port
          toConnectionSecretKey: port
        - apiVersion: v1
          kind: Secret
          namespace: rmq-clusters
          fieldPath: data.username
          toConnectionSecretKey: username
        - apiVersion: v1
          kind: Secret
          namespace: rmq-clusters
          fieldPath: data.password
          toConnectionSecretKey: password
        writeConnectionSecretToRef:
          namespace: rmq-clusters
    connectionDetails:
    - fromConnectionSecretKey: provider
    - fromConnectionSecretKey: type
    - fromConnectionSecretKey: host
    - fromConnectionSecretKey: port
    - fromConnectionSecretKey: username
    - fromConnectionSecretKey: password
    patches:
      - fromFieldPath: metadata.name
        toFieldPath: spec.forProvider.manifest.metadata.name
        type: FromCompositeFieldPath
      - fromFieldPath: spec.replicas
        toFieldPath: spec.forProvider.manifest.spec.replicas
        type: FromCompositeFieldPath
      - fromFieldPath: spec.storageGB
        toFieldPath: spec.forProvider.manifest.spec.persistence.storage
        transforms:
        - string:
            fmt: '%dGi'
            type: Format
          type: string
        type: FromCompositeFieldPath
      - fromFieldPath: metadata.name
        toFieldPath: spec.writeConnectionSecretToRef.name
        transforms:
        - string:
            fmt: '%s-rmq'
            type: Format
          type: string
        type: FromCompositeFieldPath
      - fromFieldPath: metadata.name
        toFieldPath: spec.connectionDetails[0].name
        transforms:
        - string:
            fmt: '%s-default-user'
            type: Format
          type: string
        type: FromCompositeFieldPath
      - fromFieldPath: metadata.name
        toFieldPath: spec.connectionDetails[1].name
        transforms:
        - string:
            fmt: '%s-default-user'
            type: Format
          type: string
        type: FromCompositeFieldPath
      - fromFieldPath: metadata.name
        toFieldPath: spec.connectionDetails[2].name
        transforms:
        - string:
            fmt: '%s-default-user'
            type: Format
          type: string
        type: FromCompositeFieldPath
      - fromFieldPath: metadata.name
        toFieldPath: spec.connectionDetails[3].name
        transforms:
        - string:
            fmt: '%s-default-user'
            type: Format
          type: string
        type: FromCompositeFieldPath
      - fromFieldPath: metadata.name
        toFieldPath: spec.connectionDetails[4].name
        transforms:
        - string:
            fmt: '%s-default-user'
            type: Format
          type: string
        type: FromCompositeFieldPath
      - fromFieldPath: metadata.name
        toFieldPath: spec.connectionDetails[5].name
        transforms:
        - string:
            fmt: '%s-default-user'
            type: Format
          type: string
        type: FromCompositeFieldPath
    readinessChecks:
      - type: MatchString
        fieldPath: status.atProvider.manifest.status.conditions[1].status # ClusterAvailable
        matchString: "True"
```

Then use kubectl to apply the file to the Tanzu Application Platform cluster.

```console
kubectl apply -f xrabbitmqclusters.messaging.bigcorp.org.composition.yaml
```

And now let's<!--฿ Re-word: too colloquial. ฿--> chat through the `Composition` step-by-step. The first thing to note is `.spec.compositeTypeRef`, which we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿-->'ve configured to refer to<!--฿ If telling the reader to read something else, use |see|. ฿--> `XRabbitmqCluster` on the `messaging.bigcorp.org/v1alpha1` API group/version.

```yaml
spec:
  compositeTypeRef:
    apiVersion: messaging.bigcorp.org/v1alpha1
    kind: XRabbitmqCluster
```

This is the API that was created in the previous step<!--฿ Write |earlier in this procedure| or, if referring to a separate procedure, link to it. ฿--> when you applied the XRD. By configuring `.spec.compositeTypeRef` to refer to<!--฿ If telling the reader to read something else, use |see|. ฿--> it, you are essentially instructing Crossplane to use the configuration contained within this `Composition` to compose subsequent Managed Resources (more on those in a minute) whenever it observes that a new `XRabbitmqCluster` resource has been<!--฿ Consider changing to |is| or |has| or rewrite for active voice. ฿--> created in the cluster. `XRabbitmqCluster` resources are what will<!--฿ Avoid |will|: present tense is preferred. ฿--> be created automatically by Tanzu Application Platform's dynamic provisioning system.

Side note: If you're feeling lost, it may<!--฿ |can| usually works better. Use |might| to convey possibility. ฿--> help to refer back to the diagram to visualize how these pieces fit together.

Next up is the `.spec.resources` section, here is where you specify the Managed Resources you want to be created. Managed Resources are tied to Crossplane's `Providers`, with each `Provider` defining a set of Managed Resources which can then be used here in compositions. Tanzu Application Platform ships with<!--฿ |includes| is preferred. ฿--> two `Providers` out of the box<!--฿ Do not use |out of the box| figuratively. ฿--> - [provider-helm](https://github.com/crossplane-contrib/provider-helm) and [provider-kubernetes](https://github.com/crossplane-contrib/provider-kubernetes). This results in<!--฿ Consider replacing with |causes|. ฿--> the availability of a `Release` managed resource, used to manage helm <!--฿ |Helm| is preferred. ฿-->releases, and an `Object` managed resource, used to manage arbitrary Kubernetes resources. Of course you are free to install and use any other `Provider` that you like. You can refer to<!--฿ If telling the reader to read something else, use |see|. ฿--> the [Upbound Marketplace](https://marketplace.upbound.io/providers) to find the latest and greatest providers. The more providers you install, the more managed resources you will<!--฿ Avoid |will|: present tense is preferred. ฿--> have to choose from in your compositions.

The overarching goal here is to compose whatever resources are necessary to result in<!--฿ Consider replacing with |cause|. ฿--> functioning, usable service instances and to surface the credentials and connectivity information required to connect to those instances in a known and repetable way. In this tutorial we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> plan to use the `RabbitmqCluster` resource, which, fortunately for us<!--฿ Specify the party (VMware, Cloud Foundry, etc). ฿-->, presents one single API we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> can use to create fully functioning RabbitMQ clusters, credentials for which get stored in `Secrets` in the cluster. However unfortunately<!--฿ Remove. ฿--> for us<!--฿ Specify the party (VMware, Cloud Foundry, etc). ฿-->, `RabbitmqCluster` is not a Crossplane Managed Resource so we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> cannot refer to<!--฿ If telling the reader to read something else, use |see|. ฿--> these directly under `.spec.resources`. This is where `provider-kubernetes` and its corresponding `Object` managed resource come into play. `Object` allows you to wrap any arbitrary Kubernetes resource (such as `RabbitmqCluster`) into a Crossplane managed resource and to then use them like any other managed resource inside `Compositions`.

```yaml
spec:
  resources:
  - base:
      apiVersion: kubernetes.crossplane.io/v1alpha1
      kind: Object
      spec:
        forProvider:
          manifest:
            apiVersion: rabbitmq.com/v1beta1
            kind: RabbitmqCluster
            metadata:
              namespace: rmq-clusters
            spec:
              terminationGracePeriodSeconds: 0
              replicas: 1
              persistence:
                storage: 1Gi
              resources:
                requests:
                  cpu: 200m
                  memory: 1Gi
                limits:
                  cpu: 300m
                  memory: 1Gi
              rabbitmq:
                envConfig: |
                  RABBITMQ_LOGS=""
                additionalConfig: |
                  log.console = true
                  log.console.level = debug
                  log.console.formatter = json
                  log.console.formatter.json.field_map = verbosity:v time msg domain file line pid level:-
                  log.console.formatter.json.verbosity_map = debug:7 info:6 notice:5 warning:4 error:3 critical:2 alert:1 emergency:0
                  log.console.formatter.time_format = epoch_usecs
```
<!--฿ Verify that no placeholders above require explanation in the style of |Where PLACEHOLDER is...| ฿-->
We<!--฿ |VMware|, the product name, or another term is preferred. Define who |We| is for the reader is preferred. ฿--> are making use of an `Object` managed resource in order to<!--฿ |to| is preferred. ฿--> configure `RabbitmqCluster` resources. This is the place in which you, the Service Operator, can now really fine-tune the configuration of the RabbitMQ Clusters to your needs. Recall from the hypothetical scenario that you are particularly concerned about your company's logging policy. Here you can see that we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> are translating that hypothetical policy into default configuration on the `RabbitmqCluster` resource by specifying configuration in `.spec.rabbitmq.additionalConfig` for the resource. This particular<!--฿ Redundant word? ฿--> configuration was taken from [one of the examples](https://github.com/rabbitmq/cluster-operator/blob/main/docs/examples/json-log/rabbitmq.yaml) on the RabbitMQ Cluster Operator<!--฿ |RabbitMQ Cluster Kubernetes operator| or, after first use and where not ambiguous, |cluster operator|. ฿--> GitHub repository, however you could<!--฿ |can| or |might| whenever possible is preferred. When providing examples, use simple present tense verbs instead of postulating what someone or something could or would do. ฿--> choose to configure the resource however you want and to whatever requirements may<!--฿ |can| usually works better. Use |might| to convey possibility. ฿--> be necessary.

You'll<!--฿ Avoid a contraction if it is too colloquial or awkward or uncommonly used. ฿--> also note we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> are setting default values for the number of replicas and the amount of persistent storage for new `RabbitmqClusters` - 1 replica and 1Gi. However you may<!--฿ |can| usually works better. Use |might| to convey possibility. ฿--> recall that when creating the XRD in the previous step<!--฿ Write |earlier in this procedure| or, if referring to a separate procedure, link to it. ฿-->, we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> decided that we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> wanted to allow these two values to be configurable by the application development teams. The way that can be<!--฿ Consider switching to active voice. ฿--> configured is via<!--฿ |through|, |using| and |by means of| are preferred. ฿--> the use of patches. Let's<!--฿ Re-word: too colloquial. ฿--> chat through the patches section in more detail.

```yaml
patches:
  - fromFieldPath: metadata.name
    toFieldPath: spec.forProvider.manifest.metadata.name
    type: FromCompositeFieldPath
```

The first thing to note is that all the patches are of type<!--฿ Use |enter| when the user input appears on the screen. Use |run| when you want users to run commands. ฿--> `FromCompositeFieldPath`, which essentially allows us<!--฿ Specify the party (VMware, Cloud Foundry, etc). ฿--> to take values defined on the composite resource (`XRabbitmqCluster` in this case) and to pass them through to the underlying managed resource (an `Object` wrapping `RabbitmqCluster` in this case). The first patch sets the name of the `RabbitmqCluster` to the same name as the name of the composite resource `XRabbitmqCluster`, which will<!--฿ Avoid |will|: present tense is preferred. ฿--> have been<!--฿ Consider replacing with |were| or shifting to present tense. ฿--> created using `generateName`, thereby ensuring a unique name for each dynamically provisioned `RabbitmqCluster` instance.

```yaml
patches:
  - fromFieldPath: spec.replicas
    toFieldPath: spec.forProvider.manifest.spec.replicas
    type: FromCompositeFieldPath
  - fromFieldPath: spec.storageGB
    toFieldPath: spec.forProvider.manifest.spec.persistence.storage
    transforms:
    - string:
        fmt: '%dGi'
        type: Format
      type: string
    type: FromCompositeFieldPath
```

The second and third patches are where we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> pass through configuration for the number of replicas and amount of persistent storage, thus<!--฿ Re-write the sentence to drop |thus| or, if that is not possible, replace with |therefore|. ฿--> essentially overriding the default values already configured.

The remaining patches all essentially do the same thing, which is to patch in the name of the `Secret` for the fields<!--฿ If referring to a UI, |text boxes| is preferred. ฿--> in the `connectionDetails` section.

```yaml
- fromFieldPath: metadata.name
  toFieldPath: spec.connectionDetails[0].name
  transforms:
  - string:
      fmt: '%s-default-user'
      type: Format
    type: string
  type: FromCompositeFieldPath
```

When creating a `RabbitmqCluster` resource using the RabbitMQ Cluster Operator<!--฿ |RabbitMQ Cluster Kubernetes operator| or, after first use and where not ambiguous, |cluster operator|. ฿-->, the operator creates a `Secret` containing credentials and connectivity information used to connect to the cluster. That `Secret` is named `x-default-user`, where `x` is the name of the `RabbitmqCluster` resource. Therefore because the name of the `RabbitmqCluster` cannot be known upfront, we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> have to use patches to ensure<!--฿ Remember to include |that| if introducing a restrictive clause. In prerequisites, use |verify that| instead of |ensure that|. Where possible just re-phrase: |Do x| is better than |Ensure that you do x|. ฿--> the `connectionDetails` section will<!--฿ Avoid |will|: present tense is preferred. ฿--> refer to<!--฿ If telling the reader to read something else, use |see|. ฿--> the correctly-named `Secret`. The `connectionDetails` sections themselves are where we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> configure which keys and values to expose in the resulting `Secret`. Note that<!--฿ If this is really a note, use note formatting. ฿--> we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> specify the same set of keys as defined in the original XRD.

Next we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> arrive at the `readinessChecks` section.

```yaml
readinessChecks:
  - type: MatchString
    fieldPath: status.atProvider.manifest.status.conditions[1].status # ClusterAvailable
    matchString: "True"
```

Configuring readiness checks helps to keep consumers of dynamic provisioning (i.e. application teams) informed about when the resulting service instances are actually<!--฿ Delete unless referring to a situation that is actual instead of virtual. Most uses are extraneous. ฿--> up and ready to be used by<!--฿ Active voice is preferred. ฿--> application workloads. Where possible it is simplest to use the `Ready` condition to determine<!--฿ |determine| has two meanings. Consider if the univocal |discover| or |verify| would be better. ฿--> readiness. However the `RabbitmqCluster` API doesn't expose a simple<!--฿ Avoid suggesting an instruction is |simple| or |easy|. ฿--> `Ready` condition, thus<!--฿ Re-write the sentence to drop |thus| or, if that is not possible, replace with |therefore|. ฿--> we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> instead configure the ready check <!--฿ |verify|, |ensure|, and |confirm| are all preferred. ฿-->on `ClusterAvailable` instead.

One final important decision to discuss before moving on is the name of the namespace in which to create the dynamically provisioned `RabbitmqCluster` resources. We<!--฿ |VMware|, the product name, or another term is preferred. Define who |We| is for the reader is preferred. ฿--> have chosen the `rmq-clusters` namespace.

```yaml
spec:
  resources:
  - base:
      apiVersion: kubernetes.crossplane.io/v1alpha1
      kind: Object
      spec:
        forProvider:
          manifest:
            apiVersion: rabbitmq.com/v1beta1
            kind: RabbitmqCluster
            metadata:
              namespace: rmq-clusters
```

You'll<!--฿ Avoid a contraction if it is too colloquial or awkward or uncommonly used. ฿--> need to<!--฿ |must| is preferred or, better, rephrase as an imperative. ฿--> make sure<!--฿ Redundant? |Make sure that you do X.| is weaker than |Do x.| ฿--> that this namespace exists.

```console
kubectl create namespace rmq-clusters
```

This configuration says that _all_ dynamically provisioned `RabbitmqCluster` resources will<!--฿ Avoid |will|: present tense is preferred. ฿--> be placed in the _same_ `rmq-clusters` namespace. You could<!--฿ |can| or |might| whenever possible is preferred. When providing examples, use simple present tense verbs instead of postulating what someone or something could or would do. ฿--> of course wish<!--฿ |want| is preferred. ฿--> to place each new cluster into a separate namespace. In order to do that, you'd<!--฿ Avoid a contraction if it is too colloquial or awkward or uncommonly used. ฿--> need to<!--฿ |must| is preferred or, better, rephrase as an imperative. ฿--> create an additional `Object` managed resource to wrap the creation of a `Namespace` and to apply patches to the resources accordingly. For now we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿-->'ll keep things simple<!--฿ Avoid suggesting an instruction is |simple| or |easy|. ฿--> with only 1 namespace.

### <a id="create-class"></a> Step 4: Creating a provisioner-based class

The creation of the XRD and the Composition brings to an end the Crossplane-centric part of this tutorial.
What remains is to integrate all that you configured into Tanzu Application Platform's classes and
claims model so that application teams can more easily make use of it.
The first step here is to create a provisioner-based class and to point it at the XRD you created.

Create a file named `bigcorp-rabbitmq.class.yaml` and copy in the following contents.

```yaml
# bigcorp-rabbitmq.class.yaml

---
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ClusterInstanceClass
metadata:
  name: bigcorp-rabbitmq
spec:
  description:
    short: On-demand RabbitMQ clusters precision engineered to meet the needs of BigCorp!
  provisioner:
    crossplane:
      compositeResourceDefinition: xrabbitmqclusters.messaging.bigcorp.org
```

Then use kubectl to apply the file to the Tanzu Application Platform cluster.

```console
kubectl apply -f bigcorp-rabbitmq.class.yaml
```

This is referred to as a provisioner-based class due to the configuration of `.spec.provisioner`.
For more information, see [ClusterInstanceClass](../reference/api/clusterinstanceclass-and-classclaim.hbs.md).

By creating this class you are informing application teams that the service is available.
Application teams can discover it by using the `tanzu service class list` command.
They can also use `tanzu service class get bigcorp-rabbitmq`, which provides detailed information
about the class, including details of the `replicas` and `storageGB` parameters that you configured earlier.

### <a id="create-rbac"></a> Step 5: Configure supporting RBAC

There are two parts of RBAC to consider when you set up a new service for dynamic provisioning in
Tanzu Application Platform.
The first relates to granting permissions to the providers used in the compositions.
The `Composition` created earlier uses `Object` managed resources ultimately to create
`RabbitmqCluster` resources.
Therefore, you must grant `provider-kubernetes` permission to create `RabbitmqCluster` resources.
You can do this by using an aggregating `ClusterRole` as follows.

Create a file named `provider-kubernetes-rmqcluster-read-writer.rbac.yaml` and copy in the
following contents.

```yaml
# provider-kubernetes-rmqcluster-read-writer.rbac.yaml

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: rmqcluster-read-writer
  labels:
    services.tanzu.vmware.com/aggregate-to-provider-kubernetes: "true"
rules:
- apiGroups:
  - rabbitmq.com
  resources:
  - rabbitmqclusters
  verbs:
  - "*"
```

Then use kubectl to apply the file to the Tanzu Application Platform cluster.

```console
kubectl apply -f provider-kubernetes-rmqcluster-read-writer.rbac.yaml
```

While not necessary here, a corresponding label `services.tanzu.vmware.com/aggregate-to-provider-helm: "true"`
exists for aggregating RBAC permissions to `provider-helm` as well.

The second element of RBAC detects who is authorized to use the new service.
This is an important piece of configuration.
You are configuring an on-demand service and making it available to application teams.
Without any other supporting policy in place, application teams can create as many `RabbitmqClusters`
as they like. This is of course the whole point of an on-demand service, but you must be conscious of
resource use, and might want to control who can create new service instances on-demand.

You can grant authorization by using standard Kubernetes RBAC resources.
Dynamic provisioning uses a custom RBAC verb, `claim`, which you can apply to classes to
permit claiming from classes.

Create a file named `app-operator-claim-class-bigcorp-rabbitmq.rbac.yaml` and copy in the following contents.

```yaml
# app-operator-claim-class-bigcorp-rabbitmq.rbac.yaml

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: app-operator-claim-class-bigcorp-rabbitmq
  labels:
    apps.tanzu.vmware.com/aggregate-to-app-operator-cluster-access: "true"
rules:
- apiGroups:
  - services.apps.tanzu.vmware.com
  resources:
  - clusterinstanceclasses
  resourceNames:
  - bigcorp-rabbitmq
  verbs:
  - claim
```

Then use kubectl to apply the file to the Tanzu Application Platform cluster.

```console
kubectl apply -f app-operator-claim-class-bigcorp-rabbitmq.rbac.yaml
```

This `ClusterRole` grants anyone holding the `app-operator` Tanzu Application Platform user role the
ability to claim from the `bigcorp-rabbitmq` class.

### <a id="verify"></a> Step 6: Verify your configuration

To test your configuration, create a claim for the class and thereby trigger the dynamic provisioning
of a new RabbitMQ cluster.
This step is typically performed by the application operator, rather than the service operator, but
it is important that you to confirm that everything is configured correctly.

Create a file named `bigcorp-rmq-1.claim.yaml` and copy in the following contents.

```yaml
# bigcorp-rmq-1.claim.yaml

---
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ClassClaim
metadata:
  name: bigcorp-rmq-1
spec:
  classRef:
    name: bigcorp-rabbitmq
  parameters:
    storageGB: 2
    replicas: 3
```

Then use kubectl to apply the file to the Tanzu Application Platform cluster.

```console
kubectl apply -f bigcorp-rmq-1.claim.yaml
```

After the RabbitMQ service is provisioned, the claim status reports `Ready=True`.

```console
kubectl get classclaim bigcorp-rmq-1
```
