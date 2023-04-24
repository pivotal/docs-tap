# Set up dynamic provisioning of service instances

In this tutorial you will learn how to set up a new, self-serve and "customized-to-your-needs"
service for Tanzu Application Platform.

The example uses Tanzu RabbitMQ the service, but the steps and learnings can apply to almost any other service.

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

You work at BigCorp and have been<!--฿ Consider replacing with |were| or shifting to present tense. ฿--> tasked to provide an on-demand, self-serve RabbitMQ service for BigCorp's development teams who are working with Tanzu Application Platform. You have already reviewed the out of the box<!--฿ Do not use |out of the box| figuratively. ฿--> offering<!--฿ Redundant word? ฿--> for RabbitMQ, but have determined<!--฿ |determine| has two meanings. Consider if the univocal |discover| or |verify| would be better. ฿--> that while it is an excellent service for kicking the tyres and for quickly getting started, it is not quite suitable for BigCorp's stringent and specifc needs. You are particularly concerned about BigCorp's auditing and logging policy, and wish<!--฿ |want| is preferred. ฿--> to enforce that every RabbitMQ cluster in use on the platform adheres to that policy. At the same time, you don't want to be a blocker for the application teams and wish<!--฿ |want| is preferred. ฿--> to offer them self-serve access to RabbitMQ whenever they need it, without incurring any untoward delays. You have heard great things about Tanzu Application Platform's Dynamic Provisioning capability, and are now looking to make use of it to help you complete your task.

By the end of this tutorial you will<!--฿ Avoid |will|: present tense is preferred. ฿--> have learned how to:

- Install the RabbitMQ Cluster Operator<!--฿ |RabbitMQ Cluster Kubernetes operator| or, after first use and where not ambiguous, |cluster operator|. ฿-->
- Create a `CompositeResourceDefinition`
- Create a `Composition`
- Create a provisioner-based class
- Understand and create the necessary RBAC permissions
- Create a claim for the class to test it all out
- Understand how all the pieces fit together to power the dynamic provisioning capability in
  Tanzu Application Platform

## <a id="concepts"></a> Concepts

Let's<!--฿ Re-word: too colloquial. ฿--> begin with a bird's-eye overview of the pieces that make up dynamic provisioning and see how they all fit together.

![Diagram shows a high-level overview of dynamic provisioning](../../images/stk-dynamic-provisioning-overview.png)<!--฿ In alt text, write a coherent sentence that ends with a period. ฿-->

There's<!--฿ Avoid a contraction if it is too colloquial or awkward or uncommonly used. ฿--> quite a lot to digest there, but don't worry! We<!--฿ |VMware|, the product name, or another term is preferred. Define who |We| is for the reader is preferred. ฿-->'ll be covering everything in more detail later on. For now, here is a very high-level overview of how the system works.

1. Service Operator creates a `CompositeResourceDefinition` and a `Composition`, which together define the configuration of the service instances that will<!--฿ Avoid |will|: present tense is preferred. ฿--> be dynamically provisioned
1. Service Operator creates a class pointing to the `CompositeResourceDefinition`, this advertises<!--฿ |informs| or similar is likely better. ฿--> the availability of the service to application development teams
1. Service Operator applies necessary RBAC to permit the system to create necessary resources, as well as<!--฿ |and| is preferred. ฿--> to authorize application development teams to create claims for the class

1. Application Developer creates a claim referring to the class, optionally<!--฿ Our style is (Optional) INSTRUCTION -- as a procedure header or a step. ฿--> passing through parameters to override any default configuration (where permissible)
1. The system creates a `CompositeResource`, merging info<!--฿ |information| is preferred. ฿--> provided in the claim with default configuration specified by the system as well as<!--฿ |and| is preferred. ฿--> configuration defined in the `Composition`
1. Crossplane reconciles the `CompositeResource` into a service instance and writes credentials for the instance into a `Secret`
1. The `Secret` is written back to the application developer<!--฿ |app developer| is preferred. ฿-->'s namespace, so that it can then be utilized by<!--฿ Active voice is preferred. ฿--> application workloads

Feel free to refer back to the diagram as/when needed as you continue through the rest of the tutorial.

## <a id="procedure"></a> Procedure

### <a id="install-operator"></a> Step 1: Install the operator

The first step when it comes to adding any new service into Tanzu Application Platform is to ensure<!--฿ Remember to include |that| if introducing a restrictive clause. In prerequisites, use |verify that| instead of |ensure that|. Where possible just re-phrase: |Do x| is better than |Ensure that you do x|. ฿--> there are a suitable set of APIs available in the cluster from which to construct desired<!--฿ |that you want| is preferred. ฿--> service instances. Usually this involves installing one or more Kubernetes Operators into the cluster. Given the aim of this tutorial is to setup<!--฿ |set up| is the action. |setup| is a noun. ฿--> a new RabbitMQ service, we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿-->'ll begin by installing the RabbitMQ Cluster Operator<!--฿ |RabbitMQ Cluster Kubernetes operator| or, after first use and where not ambiguous, |cluster operator|. ฿--> for Kubernetes.

> **Note** The steps below<!--฿ If referring to a page location, use |following| or |later| or, better, just use an anchor. If referring to product versions, use |earlier|. ฿--> use the open source version of the operator.
> For most real-world deployments, VMware recommends using the official, supported version provided by VMware.
> For more information, see [VMware RabbitMQ for Kubernetes](https://docs.vmware.com/en/VMware-RabbitMQ-for-Kubernetes/index.html).

Use `kapp` to install the operator by running:

```console
kapp -y deploy --app rmq-operator --file https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yaml
```
<!--฿ If this is just console output, such as an error message, break up the lines at sensible points with backslashes to make reading it easier. ฿-->
This results in<!--฿ Consider replacing with |causes|. ฿--> the availability of a new API Group/Version of `rabbitmq.com/v1beta1` and Kind named `RabbitmqCluster` in the cluster. We<!--฿ |VMware|, the product name, or another term is preferred. Define who |We| is for the reader is preferred. ฿--> can now use this API to create RabbitMQ cluster instances as part of our dynamic provisioning setup.

### <a id="create-xrd"></a> Step 2: Creating a `CompositeResourceDefinition`

Tanzu Application Platform's Dynamic Provisioning capability leans on [Crossplane](https://www.crossplane.io/) to do most of the heavy lifting. The specific integration point can be<!--฿ Consider switching to active voice. ฿--> found at `.spec.provisioner.crossplane.compositeResourceDefinition` in Tanzu Application Platform's `ClusterInstanceClass` API. As the name suggests, this field<!--฿ If referring to a UI, |text box| is preferred. ฿--> is looking for a `CompositeResourceDefinition`, and so that is what you will<!--฿ Avoid |will|: present tense is preferred. ฿--> be creating in this step of the tutorial. The `CompositeResourceDefinition` (or "XRD" in Crossplane parlance) essentially defines the shape of a new, custom API type which can encompass the specific set of requirements laid out by the scenario in this tutorial.

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

Then use `kubectl` <!--฿ Do not format |kubectl| as code. ฿-->to apply the file to the Tanzu Application Platform cluster.

```console
kubectl apply -f xrabbitmqclusters.messaging.bigcorp.org.xrd.yaml
```
<!--฿ If this is just console output, such as an error message, break up the lines at sensible points with backslashes to make reading it easier. ฿-->
For a full and detailed explanation of `CompositeResourceDefinition` it is best to refer to<!--฿ If telling the reader to read something else, use |see|. ฿--> Crossplane's official documentation. What follows here is a condensed explanation of the most relevant pieces of the above<!--฿ If referring to a page location, use |earlier| or, better, just use an anchor. If referring to product versions, use |later|. ฿--> config as it relates to Dynamic Provisioning in Tanzu Application Platform.

First and foremost note that<!--฿ If this is really a note, use note formatting. ฿--> we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> have **not** specified `.spec.claimNames` in the XRD. Tanzu Application Platform's dynamic provisioning capability makes use of Crossplane's cluster-scoped Composite Resources, rather than the namespace-scoped Claims ("Claims" here not to be confused with Tanzu Application Platform's own concept of claims!). As such, this configuration is not required, although it will<!--฿ Avoid |will|: present tense is preferred. ฿--> not cause any adverse effects if you choose to<!--฿ Consider if |choose| is redundant. ฿--> add it.

Next refer to<!--฿ If telling the reader to read something else, use |see|. ฿--> `.spec.connectionKeys`. This field<!--฿ If referring to a UI, |text box| is preferred. ฿--> determines<!--฿ |determine| has two meanings. Consider if the univocal |discover| or |verify| would be better. To avoid anthropomorphism, use |detect|. ฿--> the keys that will<!--฿ Avoid |will|: present tense is preferred. ฿--> exist in the `Secret` resulting from the dynamic provisioning request. You will<!--฿ Avoid |will|: present tense is preferred. ฿--> most likely want this `Secret` to be conformant<!--฿ Obsolete -- |conforming| is preferred. ฿--> with the [Service Binding Specification for Kubernetes](https://github.com/servicebinding/spec), as this, in part*, is what allows for automatic configuration of the service instance by Tanzu Application Platform's application workloads. Specific key name requirements vary by service type, however all should<!--฿ Favour certainty, agency, and imperatives: |the app now works| over |the app should now work|. |VMware recommends| over |you should|. If an imperative, |do this| over |you should do this|. If |should| is unavoidable, it must be paired with information on the exceptions that |should| implies exist. ฿--> provide the `type` key.

\* _Assuming the application is using a binding-aware<!--฿ To avoid anthropomorphism, use |detects|. ฿--> library such as [Spring Cloud Bindings](https://github.com/spring-cloud/spring-cloud-bindings)._

Finally, take a look at the `.spec.properties` section in the schema for `v1alpha1`. This is where you, as the Service Operator, can choose which<!--฿ |decide| is preferred. ฿--> configuration options you want to expose to application development teams. In the example above<!--฿ If referring to a page location, use |earlier| or, better, just use an anchor. If referring to product versions, use |later|. ฿--> there are two configuration options - `replicas` and `storageGB`. By adding these properties to the spec<!--฿ |specifications| is preferred. ฿--> you are handing over control of these specific configuration options to the development teams. Taking `storageGB` as an example,<!--฿ |for example,| might be better here. ฿--> the development teams probably have a better sense of how much storage their apps will<!--฿ Avoid |will|: present tense is preferred. ฿--> require than you do, so why not allow them to decide for themselves how much storage they require.

You can choose to add as many or as few configuration options here as you like. You can also optionally<!--฿ Our style is (Optional) INSTRUCTION -- as a procedure header or a step. ฿--> choose to set default values. In highly regulated environments, you may<!--฿ |can| usually works better. Use |might| to convey possibility. ฿--> not want to allow for any configuration by developers at all, and that's<!--฿ Avoid a contraction if it is too colloquial or awkward or uncommonly used. ฿--> totally fine! Recall back to the hypothetical scenario at the beginning of this tutorial. It says, "You are particularly concerned about BigCorp's auditing and logging policy". Note that<!--฿ If this is really a note, use note formatting. ฿--> we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> are not specifying any configuration related to auditing or logging in the XRD here. This is intentional as in this scenario we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> have strict auditing and logging requirements and don't want to permit developers to override those. In the next step you'll<!--฿ Avoid a contraction if it is too colloquial or awkward or uncommonly used. ฿--> learn how to ensure<!--฿ Remember to include |that| if introducing a restrictive clause. In prerequisites, use |verify that| instead of |ensure that|. Where possible just re-phrase: |Do x| is better than |Ensure that you do x|. ฿--> those requirements actually<!--฿ Delete unless referring to a situation that is actual instead of virtual. Most uses are extraneous. ฿--> do get enforced on the resulting RabbitMQ clusters.

Before moving on, let's<!--฿ Re-word: too colloquial. ฿--> check <!--฿ |verify|, |ensure|, and |confirm| are all preferred. ฿-->on the status of the XRD you just<!--฿ Avoid uses that suggest a task is simple. ฿--> created.

```console
kubectl get xrds
```

You should<!--฿ Favour certainty, agency, and imperatives: |the app now works| over |the app should now work|. |VMware recommends| over |you should|. If an imperative, |do this| over |you should do this|. If |should| is unavoidable, it must be paired with information on the exceptions that |should| implies exist. ฿--> see `xrabbitmqclusters.messaging.bigcorp.org` listed with `ESTABLISHED=True`. It's quite possible that you will<!--฿ Avoid |will|: present tense is preferred. ฿--> see some other XRDs listed as well - the `*.bitnami.*.tanzu.vmware.com` XRDs. These ship as part of the `bitnami.services.tanzu.vmware.com` Package with Tanzu Application Platform and serve as the basis of the out of the box<!--฿ Do not use |out of the box| figuratively. ฿--> services. These other XRDs can be<!--฿ Consider switching to active voice. ฿--> safely ignored for now, but if you'd<!--฿ Avoid a contraction if it is too colloquial or awkward or uncommonly used. ฿--> like to see how they are used in practice, please<!--฿ Do not use unless asking the reader to do you a favor, such as giving feedback. ฿--> refer to<!--฿ If telling the reader to read something else, use |see|. ฿--> the Getting Started Guide's [Claim services on Tanzu Application Platform](../../getting-started/consume-services.hbs.md) and [Consume services on Tanzu Application Platform](../../getting-started/consume-services.hbs.md).

As a result of creating the XRD, a new API Group/Version of `messaging.bigcorp.org/v1alpha1` and Kind named `XRabbitmqCluster` should<!--฿ Favour certainty, agency, and imperatives: |the app now works| over |the app should now work|. |VMware recommends| over |you should|. If an imperative, |do this| over |you should do this|. If |should| is unavoidable, it must be paired with information on the exceptions that |should| implies exist. ฿--> now be available in the cluster. If you inspect this API further, you will<!--฿ Avoid |will|: present tense is preferred. ฿--> note that<!--฿ If this is really a note, use note formatting. ฿--> the `replicas` and `storageGB` properties we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> configured in the XRD are present in the spec<!--฿ |specifications| is preferred. ฿--> of `XRabbitmqCluster`.

```console
kubectl explain --api-version=messaging.bigcorp.org/v1alpha1 xrabbitmqclusters.spec
```

You'll<!--฿ Avoid a contraction if it is too colloquial or awkward or uncommonly used. ฿--> also note that<!--฿ If this is really a note, use note formatting. ฿--> Crossplane has injected some other fields<!--฿ If referring to a UI, |text boxes| is preferred. ฿--> into the spec<!--฿ |specifications| is preferred. ฿--> as well, but you can mostly ignore these for now.

## <a id="create-composition"></a> Step 3: Creating a crossplane `Composition`

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
<!--฿ Verify that no placeholders above require explanation in the style of |Where PLACEHOLDER is...| ฿-->
Then use `kubectl` <!--฿ Do not format |kubectl| as code. ฿-->to apply the file to the Tanzu Application Platform cluster.

```console
kubectl apply -f xrabbitmqclusters.messaging.bigcorp.org.composition.yaml
```
<!--฿ If this is just console output, such as an error message, break up the lines at sensible points with backslashes to make reading it easier. ฿-->
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

## <a id="create-class"></a> Step 4: Creating a provisioner-based class

The creation of the XRD and the Composition brings to an end the Crossplane-centric part of this tutorial. What remains is to integrate all that we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿-->'ve just<!--฿ Avoid uses that suggest a task is simple. ฿--> configured into Tanzu Application Platform's classes and claims model so that application teams can more easily<!--฿ Avoid when describing an instruction. ฿--> make use of it. The first step here is to create a provisioner-based class and to point it at the XRD we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> have created.

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

Then use `kubectl` <!--฿ Do not format |kubectl| as code. ฿-->to apply the file to the Tanzu Application Platform cluster.

```console
kubectl apply -f bigcorp-rabbitmq.class.yaml
```
<!--฿ If this is just console output, such as an error message, break up the lines at sensible points with backslashes to make reading it easier. ฿-->
We<!--฿ |VMware|, the product name, or another term is preferred. Define who |We| is for the reader is preferred. ฿--> refer to<!--฿ If telling the reader to read something else, use |see|. ฿--> this as a provisioner-based class due to the configuration of `.spec.provisioner`. See [ClusterInstanceClass](../reference/api/clusterinstanceclass-and-classclaim.hbs.md) for more information.<!--฿ The xref style is |See LINK.| or |For more information about TOPIC, see LINK.| ฿-->

By creating this class we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> are now essentially advertising<!--฿ |informing| or similar is likely better. ฿--> the availability of the service to application teams. Application teams will<!--฿ Avoid |will|: present tense is preferred. ฿--> discover it via<!--฿ |through|, |using| and |by means of| are preferred. ฿--> the `tanzu service class list` command. They can also use `tanzu service class get bigcorp-rabbitmq`, which will<!--฿ Avoid |will|: present tense is preferred. ฿--> provide detailed information about the class, including details of the `replicas` and `storageGB` parameters we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> configured earlier.

## <a id="create-rbac"></a> Step 5: Configure supporting RBAC

There are two pieces of RBAC to consider whenever setting up a new service for dynamic provisioning in Tanzu Application Platform. The first relates to granting permissions to the providers used in the compositions. The `Composition` created earlier uses `Object` managed resources ultimately to create `RabbitmqCluster` resources. Thus<!--฿ Re-write the sentence to drop |Thus| or, if that is not possible, replace with |therefore|. ฿--> we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> must grant `provider-kubernetes` permission to create `RabbitmqCluster` resources. This can be<!--฿ Consider switching to active voice. ฿--> done using an aggregating `ClusterRole`, as follows:

Create a file named `provider-kubernetes-rmqcluster-read-writer.rbac.yaml` and copy in the following contents.

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

Then use `kubectl` <!--฿ Do not format |kubectl| as code. ฿-->to apply the file to the Tanzu Application Platform cluster.

```console
kubectl apply -f provider-kubernetes-rmqcluster-read-writer.rbac.yaml
```
<!--฿ If this is just console output, such as an error message, break up the lines at sensible points with backslashes to make reading it easier. ฿-->
While not necessary here, a corresponding label `services.tanzu.vmware.com/aggregate-to-provider-helm: "true"` exists for aggregating RBAC permissions to `provider-helm` as well.

The second piece of RBAC determines<!--฿ |determine| has two meanings. Consider if the univocal |discover| or |verify| would be better. To avoid anthropomorphism, use |detect|. ฿--> who is actually<!--฿ Delete unless referring to a situation that is actual instead of virtual. Most uses are extraneous. ฿--> authorized to use the new service. This is an important piece of configuration! We<!--฿ |VMware|, the product name, or another term is preferred. Define who |We| is for the reader is preferred. ฿--> are configuring an on-demand service and making it available to application teams. Without any other supporing policy in place, application teams will<!--฿ Avoid |will|: present tense is preferred. ฿--> be able to<!--฿ |can| is preferred. ฿--> create as many `RabbitmqClusters` as they like. This is of course the whole point of an on-demand service, however we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> do need to<!--฿ |must| is preferred or, better, rephrase as an imperative. ฿--> be concious of resource utilization<!--฿ To |utilize| is to use an item beyond its intended purpose. Otherwise you simply |use| it. ฿-->, and we<!--฿ |VMware|, the product name, or another term is preferred. Define who |we| is for the reader is preferred. ฿--> may<!--฿ |can| usually works better. Use |might| to convey possibility. ฿--> not want just<!--฿ Avoid uses that suggest a task is simple. ฿--> anyone who has access to the Tanzu Application Platform cluster to be able to<!--฿ |can| is preferred. ฿--> create new service instances on demand.

Authorization can be<!--฿ Consider switching to active voice. ฿--> granted using standard Kubernetes RBAC resources. Dynamic provisioning makes use of a custom RBAC verb - `claim` - which can be<!--฿ Consider switching to active voice. ฿--> applied to classes in order to<!--฿ |to| is preferred. ฿--> permit claiming from classes.

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

Then use `kubectl` <!--฿ Do not format |kubectl| as code. ฿-->to apply the file to the Tanzu Application Platform cluster.

```console
kubectl apply -f app-operator-claim-class-bigcorp-rabbitmq.rbac.yaml
```
<!--฿ If this is just console output, such as an error message, break up the lines at sensible points with backslashes to make reading it easier. ฿-->
This `ClusterRole` grants anyone holding the `app-operator` Tanzu Application Platform user role the ability to<!--฿ |can| is shorter. ฿--> claim from the `bigcorp-rabbitmq` class.

## <a id="verify"></a> Step 6: Verify your configuration

All that's<!--฿ Avoid a contraction if it is too colloquial or awkward or uncommonly used. ฿--> left to do now is to actually<!--฿ Delete unless referring to a situation that is actual instead of virtual. Most uses are extraneous. ฿--> create a claim for the class and thereby trigger the dynamic provisioning of a new RabbitMQ cluster. Note that<!--฿ If this is really a note, use note formatting. ฿--> this step is typically performed by the Application Operator, rather than the Service Operator, however it is important for us<!--฿ Specify the party (VMware, Cloud Foundry, etc). ฿--> to check <!--฿ |verify|, |ensure|, and |confirm| are all preferred. ฿-->that everything has been<!--฿ Consider changing to |is| or |has| or rewrite for active voice. ฿--> setup correctly.

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

Then use `kubectl` <!--฿ Do not format |kubectl| as code. ฿-->to apply the file to the Tanzu Application Platform cluster.

```console
kubectl apply -f bigcorp-rmq-1.claim.yaml
```
<!--฿ If this is just console output, such as an error message, break up the lines at sensible points with backslashes to make reading it easier. ฿-->
Once<!--฿ Only use |once| when you mean |one time|, not when you mean |after|. ฿--> the rabbitmq have been<!--฿ Consider replacing with |were| or shifting to present tense. ฿--> successfully<!--฿ Redundant word? ฿--> provisioned, you should<!--฿ Favour certainty, agency, and imperatives: |the app now works| over |the app should now work|. |VMware recommends| over |you should|. If an imperative, |do this| over |you should do this|. If |should| is unavoidable, it must be paired with information on the exceptions that |should| implies exist. ฿--> see the claim
status report `Ready=True`.

```console
kubectl get classclaim bigcorp-rmq-1
```
