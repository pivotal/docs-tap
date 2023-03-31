# Setup Dynamic Provisioning of Service Instances

**Target user role**:       Service Operator<br />
**Complexity**:             Advanced<br />
**Estimated time**:         60 minutes<br />
**Topics covered**:         Dynamic Provisioning, Crossplane, Tanzu RabbitMQ Cluster Operator<br />
**Learning outcomes**:      Ability to offer new, on-demand, and customized services in your Tanzu Application Platform cluster(s)<br />

## <a id="stk-setup-dynamic-provisioning-intro"></a> Intro

In this tutorial you will learn how to setup a new, self-serve and "customized-to-your-needs" service for Tanzu Application Platform (referred to as "TAP" from hereon in). We'll use Tanzu RabbitMQ as the example service, however the steps and learnings can apply to almost any other service you like the look of. In order to help make the learning here as effective as possible, the tutorial is centered around the following hypothetical, but somewhat realistic, real-world scenario.

You work at BigCorp and have been tasked to provide an on-demand, self-serve RabbitMQ service for BigCorp's development teams who are working with TAP. You have already reviewed the out of the box offering for RabbitMQ, but have determined that while it is an excellent service for kicking the tyres and for quickly getting started, it is not quite suitable for BigCorp's stringent and specifc needs. You are particularly concerned about BigCorp's auditing and logging policy, and wish to enforce that every RabbitMQ cluster in use on the platform adheres to that policy. At the same time, you don't want to be a blocker for the application teams and wish to offer them self-serve access to RabbitMQ whenever they need it, without incurring any untoward delays. You have heard great things about TAP's Dynamic Provisioning capability, and are now looking to make use of it to help you complete your task.

By the end of this tutorial you will have learned how to:

* Install the RabbitMQ Cluster Operator
* Create a `CompositeResourceDefinition`
* Create a `Composition`
* Create a provisioner-based class
* Understand and create the necessary RBAC permissions
* Create a claim for the class to test it all out
* Understand how all the pieces fit together to power the dynamic provisioning capability in TAP

## <a id="stk-setup-dynamic-provisioning-pre-reqs"></a> Pre-requisites

* Access to a TAP cluster (version >= 1.5.0)
* Surface level familiarity with Crossplane, particularly the concepts of [Composition and CompositeResourceDefinitions](https://docs.crossplane.io/v1.11/concepts/composition/)

## <a id="stk-setup-dynamic-provisioning-nutshell"></a> In a nutshell

Let's begin with a bird's-eye overview of the pieces that make up dynamic provisioning and see how they all fit together.

![Diagram shows a high-level overview of dynamic provisioning](../../images/stk-dynamic-provisioning-overview.png)

There's quite a lot to digest there, but don't worry! We'll be covering everything in more detail later on. For now, here is a very high-level overview of how the system works.

1. Service Operator creates a `CompositeResourceDefinition` and a `Composition`, which together define the configuration of the service instances that will be dynamically provisioned
1. Service Operator creates a class pointing to the `CompositeResourceDefinition`, this advertises the availability of the service to application development teams
1. Service Operator applies necessary RBAC to permit the system to create necessary resources, as well as to authorize application development teams to create claims for the class

1. Application Developer creates a claim referring to the class, optionally passing through parameters to override any default configuration (where permissible)
1. The system creates a `CompositeResource`, merging info provided in the claim with default configuration specified by the system as well as configuration defined in the `Composition`
1. Crossplane reconciles the `CompositeResource` into a service instance and writes credentials for the instance into a `Secret`
1. The `Secret` is written back to the application developer's namespace, so that it can then be utilized by application workloads

Feel free to refer back to the diagram as/when needed as you continue through the rest of the tutorial.

## <a id="stk-setup-dynamic-provisioning-install-operator"></a> Installing the operator

The first step when it comes to adding any new service into TAP is to ensure there are a suitable set of APIs available in the cluster from which to construct desired service instances. Usually this involves installing one or more Kubernetes Operators into the cluster. Given the aim of this tutorial is to setup a new RabbitMQ service, we'll begin by installing the RabbitMQ Cluster Operator for Kubernetes.

    > **Note** The steps below use the open source version of the operator.
    > For most real-world deployments, VMware recommends using the official, supported version provided by VMware.
    > For more information, see [VMware RabbitMQ for Kubernetes](https://docs.vmware.com/en/VMware-RabbitMQ-for-Kubernetes/index.html).

Use `kapp` to install the operator by running:

```console
kapp -y deploy --app rmq-operator --file https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml
```

This results in the availability of a new API Group/Version of `rabbitmq.com/v1beta1` and Kind named `RabbitmqCluster` in the cluster. We can now use this API to create RabbitMQ cluster instances as part of our dynamic provisioning setup.

## <a id="stk-setup-dynamic-provisioning-create-xrd"></a> Creating a `CompositeResourceDefinition`

TAP's Dynamic Provisioning capability leans on [Crossplane](https://www.crossplane.io/) to do most of the heavy lifting. The specific integration point can be found at `.spec.provisioner.crossplane.compositeResourceDefinition` in TAP's `ClusterInstanceClass` API. As the name suggests, this field is looking for a `CompositeResourceDefinition`, and so that is what you will be creating in this step of the tutorial. The `CompositeResourceDefinition` (or "XRD" in Crossplane parlance) essentially defines the shape of a new, custom API type which can encompass the specific set of requirements laid out by the scenario in this tutorial.

Create a file named `xrabbitmqclusters.messaging.bigcorp.org.xrd.yml` and copy in the following contents.

```yaml
# xrabbitmqclusters.messaging.bigcorp.org.xrd.yml

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

Then use `kubectl` to apply the file to the TAP cluster.

```console
kubectl apply -f xrabbitmqclusters.messaging.bigcorp.org.xrd.yml
```

For a full and detailed explanation of `CompositeResourceDefinition` it is best to refer to Crossplane's official documentation. What follows here is a condensed explanation of the most relevant pieces of the above config as it relates to Dynamic Provisioning in TAP.

First and foremost note that we have **not** specified `.spec.claimNames` in the XRD. TAP's dynamic provisioning capability makes use of Crossplane's cluster-scoped Composite Resources, rather than the namespace-scoped Claims ("Claims" here not to be confused with TAP's own concept of claims!). As such, this configuration is not required, although it will not cause any adverse effects if you choose to add it.

Next refer to `.spec.connectionKeys`. This field determines the keys that will exist in the `Secret` resulting from the dynamic provisioning request. You will most likely want this `Secret` to be conformant with the [Service Binding Specification for Kubernetes](https://github.com/servicebinding/spec), as this, in part*, is what allows for automatic configuration of the service instance by TAP's application workloads. Specific key name requirements vary by service type, however all should provide the `type` key.

\* _Assuming the application is using a binding-aware library such as [Spring Cloud Bindings](https://github.com/spring-cloud/spring-cloud-bindings)._

Finally, take a look at the `.spec.properties` section in the schema for `v1alpha1`. This is where you, as the Service Operator, can choose which configuration options you want to expose to application development teams. In the example above there are two configuration options - `replicas` and `storageGB`. By adding these properties to the spec you are handing over control of these specific configuration options to the development teams. Taking `storageGB` as an example, the development teams probably have a better sense of how much storage their apps will require than you do, so why not allow them to decide for themselves how much storage they require.

You can choose to add as many or as few configuration options here as you like. You can also optionally choose to set default values. In highly regulated environments, you may not want to allow for any configuration by developers at all, and that's totally fine! Recall back to the hypothetical scenario at the beginning of this tutorial. It says, "You are particularly concerned about BigCorp's auditing and logging policy". Note that we are not specifying any configuration related to auditing or logging in the XRD here. This is intentional as in this scenario we have strict auditing and logging requirements and don't want to permit developers to override those. In the next step you'll learn how to ensure those requirements actually do get enforced on the resulting RabbitMQ clusters.

Before moving on, let's check on the status of the XRD you just created.

```console
kubectl get xrds
```

You should see `xrabbitmqclusters.messaging.bigcorp.org` listed with `ESTABLISHED=True`. It's quite possible that you will see some other XRDs listed as well - the `*.bitnami.*.tanzu.vmware.com` XRDs. These ship as part of the `bitnami.services.tanzu.vmware.com` Package with TAP and serve as the basis of the out of the box services. These other XRDs can be safely ignored for now, but if you'd like to see how they are used in practice, please refer to the Getting Started Guide's [Claim services on Tanzu Application Platform](../../getting-started/consume-services.hbs.md) and [Consume services on Tanzu Application Platform](../../getting-started/consume-services.hbs.md).

As a result of creating the XRD, a new API Group/Version of `messaging.bigcorp.org/v1alpha1` and Kind named `XRabbitmqCluster` should now be available in the cluster. If you inspect this API further, you will note that the `replicas` and `storageGB` properties we configured in the XRD are present in the spec of `XRabbitmqCluster`.

```console
kubectl explain --api-version=messaging.bigcorp.org/v1alpha1 xrabbitmqclusters.spec
```

You'll also note that Crossplane has injected some other fields into the spec as well, but you can mostly ignore these for now.

## <a id="stk-setup-dynamic-provisioning-create-composition"></a> Creating a crossplane `Composition`

This step is the big one. Most of the time and effort involved in configuring dynamic provisioning will likely be spent in creating Crossplane's `Compositions`. They can look quite intimidating at first, but fear not! This tutorial is here to guide you through all the most important steps. Like before, it is recommended to refer to Crossplane's official documentation for a full and detailed explanation of `Composition`s, what follows here are the basics you need to know to be able to start creating `Compositions` for use in TAP.

Start by creating a file named `xrabbitmqclusters.messaging.bigcorp.org.composition.yml` and copying in the following contents.

```yaml
# xrabbitmqclusters.messaging.bigcorp.org.composition.yml

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

Then use `kubectl` to apply the file to the TAP cluster.

```console
kubectl apply -f xrabbitmqclusters.messaging.bigcorp.org.composition.yml
```

And now let's chat through the `Composition` step-by-step. The first thing to note is `.spec.compositeTypeRef`, which we've configured to refer to `XRabbitmqCluster` on the `messaging.bigcorp.org/v1alpha1` API group/version.

```yaml
spec:
  compositeTypeRef:
    apiVersion: messaging.bigcorp.org/v1alpha1
    kind: XRabbitmqCluster
```

This is the API that was created in the previous step when you applied the XRD. By configuring `.spec.compositeTypeRef` to refer to it, you are essentially instructing Crossplane to use the configuration contained within this `Composition` to compose subsequent Managed Resources (more on those in a minute) whenever it observes that a new `XRabbitmqCluster` resource has been created in the cluster. `XRabbitmqCluster` resources are what will be created automatically by TAP's dynamic provisioning system.

Side note: If you're feeling lost, it may help to refer back to the diagram to visualize how these pieces fit together.

Next up is the `.spec.resources` section, here is where you specify the Managed Resources you want to be created. Managed Resources are tied to Crossplane's `Providers`, with each `Provider` defining a set of Managed Resources which can then be used here in compositions. TAP ships with two `Providers` out of the box - [provider-helm](https://github.com/crossplane-contrib/provider-helm) and [provider-kubernetes](https://github.com/crossplane-contrib/provider-kubernetes). This results in the availability of a `Release` managed resource, used to manage helm releases, and an `Object` managed resource, used to manage arbitrary Kubernetes resources. Of course you are free to install and use any other `Provider` that you like. You can refer to the [Upbound Marketplace](https://marketplace.upbound.io/providers) to find the latest and greatest providers. The more providers you install, the more managed resources you will have to choose from in your compositions.

The overarching goal here is to compose whatever resources are necessary to result in functioning, usable service instances and to surface the credentials and connectivity information required to connect to those instances in a known and repetable way. In this tutorial we plan to use the `RabbitmqCluster` resource, which, fortunately for us, presents one single API we can use to create fully functioning RabbitMQ clusters, credentials for which get stored in `Secrets` in the cluster. However unfortunately for us, `RabbitmqCluster` is not a Crossplane Managed Resource so we cannot refer to these directly under `.spec.resources`. This is where `provider-kubernetes` and its corresponding `Object` managed resource come into play. `Object` allows you to wrap any arbitrary Kubernetes resource (such as `RabbitmqCluster`) into a Crossplane managed resource and to then use them like any other managed resource inside `Compositions`.

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

We are making use of an `Object` managed resource in order to configure `RabbitmqCluster` resources. This is the place in which you, the Service Operator, can now really fine-tune the configuration of the RabbitMQ Clusters to your needs. Recall from the hypothetical scenario that you are particularly concerned about your company's logging policy. Here you can see that we are translating that hypothetical policy into default configuration on the `RabbitmqCluster` resource by specifying configuration in `.spec.rabbitmq.additionalConfig` for the resource. This particular configuration was taken from [one of the examples](https://github.com/rabbitmq/cluster-operator/blob/main/docs/examples/json-log/rabbitmq.yaml) on the RabbitMQ Cluster Operator GitHub repository, however you could choose to configure the resource however you want and to whatever requirements may be necessary.

You'll also note we are setting default values for the number of replicas and the amount of persistent storage for new `RabbitmqClusters` - 1 replica and 1Gi. However you may recall that when creating the XRD in the previous step, we decided that we wanted to allow these two values to be configurable by the application development teams. The way that can be configured is via the use of patches. Let's chat through the patches section in more detail.

```yaml
patches:
  - fromFieldPath: metadata.name
    toFieldPath: spec.forProvider.manifest.metadata.name
    type: FromCompositeFieldPath
```

The first thing to note is that all the patches are of type `FromCompositeFieldPath`, which essentially allows us to take values defined on the composite resource (`XRabbitmqCluster` in this case) and to pass them through to the underlying managed resource (an `Object` wrapping `RabbitmqCluster` in this case). The first patch sets the name of the `RabbitmqCluster` to the same name as the name of the composite resource `XRabbitmqCluster`, which will have been created using `generateName`, thereby ensuring a unique name for each dynamically provisioned `RabbitmqCluster` instance.

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

The second and third patches are where we pass through configuration for the number of replicas and amount of persistent storage, thus essentially overriding the default values already configured.

The remaining patches all essentially do the same thing, which is to patch in the name of the `Secret` for the fields in the `connectionDetails` section.

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

When creating a `RabbitmqCluster` resource using the RabbitMQ Cluster Operator, the operator creates a `Secret` containing credentials and connectivity information used to connect to the cluster. That `Secret` is named `x-default-user`, where `x` is the name of the `RabbitmqCluster` resource. Therefore because the name of the `RabbitmqCluster` cannot be known upfront, we have to use patches to ensure the `connectionDetails` section will refer to the correctly-named `Secret`. The `connectionDetails` sections themselves are where we configure which keys and values to expose in the resulting `Secret`. Note that we specify the same set of keys as defined in the original XRD.

Next we arrive at the `readinessChecks` section.

```yaml
readinessChecks:
  - type: MatchString
    fieldPath: status.atProvider.manifest.status.conditions[1].status # ClusterAvailable
    matchString: "True"
```

Configuring readiness checks helps to keep consumers of dynamic provisioning (i.e. application teams) informed about when the resulting service instances are actually up and ready to be used by application workloads. Where possible it is simplest to use the `Ready` condition to determine readiness. However the `RabbitmqCluster` API doesn't expose a simple `Ready` condition, thus we instead configure the ready check on `ClusterAvailable` instead.

One final important decision to discuss before moving on is the name of the namespace in which to create the dynamically provisioned `RabbitmqCluster` resources. We have chosen the `rmq-clusters` namespace.

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

You'll need to make sure that this namespace exists.

```console
kubectl create namespace rmq-clusters
```

This configuration says that _all_ dynamically provisioned `RabbitmqCluster` resources will be placed in the _same_ `rmq-clusters` namespace. You could of course wish to place each new cluster into a separate namespace. In order to do that, you'd need to create an additional `Object` managed resource to wrap the creation of a `Namespace` and to apply patches to the resources accordingly. For now we'll keep things simple with only 1 namespace.

## <a id="stk-setup-dynamic-provisioning-create-class"></a> Creating a provisioner-based class

The creation of the XRD and the Composition brings to an end the Crossplane-centric part of this tutorial. What remains is to integrate all that we've just configured into TAP's classes and claims model so that application teams can more easily make use of it. The first step here is to create a provisioner-based class and to point it at the XRD we have created.

Create a file named `bigcorp-rabbitmq.class.yml` and copy in the following contents.

```yaml
# bigcorp-rabbitmq.class.yml

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

Then use `kubectl` to apply the file to the TAP cluster.

```console
kubectl apply -f bigcorp-rabbitmq.class.yml
```

We refer to this as a provisioner-based class due to the configuration of `.spec.provisioner`. See [ClusterInstanceClass](../reference/api/clusterinstanceclass-and-classclaim.hbs.md) for more information.

By creating this class we are now essentially advertising the availability of the service to application teams. Application teams will discover it via the `tanzu service class list` command. They can also use `tanzu service class get bigcorp-rabbitmq`, which will provide detailed information about the class, including details of the `replicas` and `storageGB` parameters we configured earlier.

## <a id="stk-setup-dynamic-provisioning-create-rbac"></a> Create supporting RBAC

There are two pieces of RBAC to consider whenever setting up a new service for dynamic provisioning in TAP. The first relates to granting permissions to the providers used in the compositions. The `Composition` created earlier uses `Object` managed resources ultimately to create `RabbitmqCluster` resources. Thus we must grant `provider-kubernetes` permission to create `RabbitmqCluster` resources. This can be done using an aggregating `ClusterRole`, as follows:

Create a file named `provider-kubernetes-rmqcluster-read-writer.rbac.yml` and copy in the following contents.

```yaml
# provider-kubernetes-rmqcluster-read-writer.rbac.yml

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

Then use `kubectl` to apply the file to the TAP cluster.

```console
kubectl apply -f provider-kubernetes-rmqcluster-read-writer.rbac.yml
```

While not necessary here, a corresponding label `services.tanzu.vmware.com/aggregate-to-provider-helm: "true"` exists for aggregating RBAC permissions to `provider-helm` as well.

The second piece of RBAC determines who is actually authorized to use the new service. This is an important piece of configuration! We are configuring an on-demand service and making it available to application teams. Without any other supporing policy in place, application teams will be able to create as many `RabbitmqClusters` as they like. This is of course the whole point of an on-demand service, however we do need to be concious of resource utilization, and we may not want just anyone who has access to the TAP cluster to be able to create new service instances on demand.

Authorization can be granted using standard Kubernetes RBAC resources. Dynamic provisioning makes use of a custom RBAC verb - `claim` - which can be applied to classes in order to permit claiming from classes.

Create a file named `app-operator-claim-class-bigcorp-rabbitmq.rbac.yml` and copy in the following contents.

```yaml
# app-operator-claim-class-bigcorp-rabbitmq.rbac.yml

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

Then use `kubectl` to apply the file to the TAP cluster.

```console
kubectl apply -f app-operator-claim-class-bigcorp-rabbitmq.rbac.yml
```

This `ClusterRole` grants anyone holding the `app-operator` TAP user role the ability to claim from the `bigcorp-rabbitmq` class.

## <a id="stk-setup-dynamic-provisioning-create-claim"></a> Create claim

All that's left to do now is to actually create a claim for the class and thereby trigger the dynamic provisioning of a new RabbitMQ cluster. Note that this step is typically performed by the Application Operator, rather than the Service Operator, however it is important for us to check that everything has been setup correctly.

Create a file named `bigcorp-rmq-1.claim.yml` and copy in the following contents.

```yaml
# bigcorp-rmq-1.claim.yml

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

Then use `kubectl` to apply the file to the TAP cluster.

```console
kubectl apply -f bigcorp-rmq-1.claim.yml
```

Once the rabbitmq have been successfully provisioned, you should see the claim
status report `Ready=True`.

```console
kubectl get classclaim bigcorp-rmq-1
```
