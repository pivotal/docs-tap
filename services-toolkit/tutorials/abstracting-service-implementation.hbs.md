# Abstracting Service Implementations Behind A Class Across Clusters

**Target user role**:       Service Operator<br />
**Complexity**:             Medium<br />
**Estimated time**:         60 minutes<br />
**Topics covered**:         Classes, Claims, Claim-by-Class, Multi-Cluster<br />
**Learning outcomes**:      Ability to abstract the implementation (e.g. helm, tanzu data service, cloud) of a given service (e.g. RabbitMQ) across multiple clusters<br />

## Intro

This tutorial walks through a setup which allows for claims of a particular class to resolve to differing backing implementations of the service depending on which cluster it is in. This sort of setup allows the configurations of `Workloads` and `ClassClaims` to remain unchanged as they are promoted through environments, whilst also enabling Service Operators the ability to change the implementations of the backing services without further configuration. In order to help make the learning here as effective as possible, the tutorial is centered around the following hypothetical, but somewhat realistic, real-world scenario.

You work at BigCorp as a Service Operator. BigCorp makes use of 3 separate TAP clusters - `iterate`, `run-test` and `run-production`. Application `Workloads` start their life on the `iterate` cluster before being promoted to the `run-test` cluster and then finally to the `run-production` cluster. The application development team have asked you for a PostgreSQL service they can use with their `Workloads`, which must be available on all 3 clusters. You are aware that the SLOs for each cluster are different and so wish to tailor the implementation of the PostgreSQL service to each of the clusters accordingly. The `iterate` cluster has low level SLOs, so you wish to offer an unmanaged PostgreSQL service backed by simple Helm chart. `run-test` has more robust requirements, so you'd like to offer a PostgreSQL service backed by VMware Tanzu. `run-production` is critically important, so you wish to use a fully managed, cloud-based PostgreSQL implementation there. You want to ensure that this differing of implementations is completely opaque to development teams. They shouldn't need to know about the inner workings of the services, and shouldn't need to make any changes to their `Workloads` and `ClassClaims` as they are promoted across clusters. You have heard great things about TAP's claims and classes abstractions and wish to make use of them to help you complete your task.

## Pre-requisites

* Access to 3 separate TAP clusters (version >= 1.5.0)
  * This tutorial refers to them as `iterate`, `run-test` and `run-production`, but yours can be named however you like

## In a nutshell

![Diagram shows a postgres class backed by three different implementations across three clusters](../../images/stk-psql-class-across-three-clusters.png)

There's quite a lot to digest there, but don't worry! We'll be covering everything in more detail later on. For now, here is a very high-level overview of the key points.

* There are three clusters: `iterate`, `run-test`, and `run-production`.
* In each cluster, the Service Operator creates a `ClusterInstanceClass` called postgres.
  * In the `iterate` cluster, this is a provisioner-based class which uses the out of the box Bitnami services to provision helm instances of postgres.
  * In the `run-test` cluster, this is a provisioner-based class which uses VMware Tanzu Postgres to provision instances of postgres.
  * In the `run-production` cluster, this is a provisioner-based class which uses Amazon RDS to provision instances running in Amazon AWS RDS.
* The App Operator creates a `ClassClaim`, this gets applied along with a consuming `Workload`.
  * When it is applied in `iterate` it resolves to a helm chart instance.
  * When it is promoted to `run-test` it resolves to a VMware Tanzu Postgres instance.
  * When it is promoted in `run-production` it resolves to an Amazon AWS RDS instance.
* The definition of the `ClassClaim` remains identical across the clusters, thus making life nice and simple for the application development team

    > **Note** The backing service implementations and environment layouts used in this use case are arbitrary
    > and should not be taken as recommendations or requirements.

One other point worth mentioning is that although we are choosing to use provisioner-based classes on all three clusters here, it's also possible to use a combination of provisioner-based and pool-based classes across the clusters. This may be desirable in cases where, for example, you want to allow for dynamic provisioning of service instnaces in the `iterate` cluster, but wish to be more considered about the approach in `run-production` - like ensuring that `Workloads` only ever connect to one specific service instance. This could be achieved through use of a provisioner-based class on the `iterate` cluster and an identically named, pool-based class on the `run-production` cluster which is configured to only ever select from a pool consisting of 1 service instance.

## Step 1: Setup the run-test cluster

The first step is to configure the `run-test` cluster for dynamic provisioning of VMware Tanzu Postgres service instances. In order to do that, you can refer to the [Configure Dynamic Provisioning of VMware Tanzu Postgres Service Instances](../how-to-guides/dynamic-provisioning-tanzu-postgresql.hbs.md) tutorial, which uses VMware Tanzu Postgres as the example. You'll need to complete [Step 1: Install the Tanzu VMware Postgres Operator](../how-to-guides/dynamic-provisioning-tanzu-postgresql.hbs.md#install-postgres-operator), [Set up the namespace](../how-to-guides/dynamic-provisioning-tanzu-postgresql.hbs.md#set-up-namespace), [Step 3: Create CompositeResourceDefinition](../how-to-guides/dynamic-provisioning-tanzu-postgresql.hbs.md#compositeresourcedef), [Step 4: Create Composition](../how-to-guides/dynamic-provisioning-tanzu-postgresql.hbs.md#create-composition) and [Step 6: Configure RBAC](../how-to-guides/dynamic-provisioning-tanzu-postgresql.hbs.md#stk-dynamic-provisioning-tanzu-psql-step-6) only. Once you've completed those steps, return back here to continue.

## Step 2: Setup the run-production cluster

The next step is to configure the `run-production` cluster for dynamic provisioning of AWS RDS PostgreSQL service instances. In order to do that, you can refer to the [Configure Dynamic Provisioning of AWS RDS Service Instances](../how-to-guides/dynamic-provisioning-rds.hbs.md) how-to guide. You'll need to complete [Step 1: Install the AWS Provider for Crossplane](../how-to-guides/dynamic-provisioning-rds.hbs.md#install-aws-provider), [Step 2: Create CompositeResourceDefinition](../how-to-guides/dynamic-provisioning-rds.hbs.md#compositeresourcedef), [Step 3: Create Composition](../how-to-guides/dynamic-provisioning-rds.hbs.md#create-composition) and [Step 5: Configure RBAC](../how-to-guides/dynamic-provisioning-rds.hbs.md#configure-rbac) only. Once you've completed those steps, return back here to continue.

## Step 3: Creating the class

The `ClusterInstanceClass` will act as the abstraction fronting the differing service implementations across the differing clusters. We'll create a class with the same name on all three of the clusters, but the configuration of the class will vary slightly on each. The fact that the class name remains consistent is what allows for `ClassClaims` (which refer classes by name) created by the application development teams to remain unchanged as they are promoted across the clusters.

Create a file named `postgres.class.iterate-cluster.yml` and copy in the following contents.

```yaml
# postgres.class.iterate-cluster.yml

---
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ClusterInstanceClass
metadata:
  name: bigcorp-postgresql
spec:
  description:
    short: PostgreSQL by BigCorp
  provisioner:
    crossplane:
      compositeResourceDefinition: xpostgresqlinstances.bitnami.database.tanzu.vmware.com
```

This class refers to the `xpostgresqlinstances.bitnami.database.tanzu.vmware.com` CompositeResourceDefinition. This ships as part of the [Bitnami Services](../../bitnami-services/about.hbs.md) Package and is used to power the out of the box postgres service. We are simply reusing the underlying CompositeResourceDefinition here from a different class using the desired class name.

Use `kubectl` to apply the file to the `iterate` cluster.

```console
kubectl apply -f postgres.class.iterate-cluster.yml
```

Create a file named `postgres.class.run-test-cluster.yml` and copy in the following contents.

```yaml
# postgres.class.run-test-cluster.yml

---
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ClusterInstanceClass
metadata:
  name: bigcorp-postgresql
spec:
  description:
    short: PostgreSQL by BigCorp
  provisioner:
    crossplane:
      compositeResourceDefinition: xpostgresqlinstances.database.tanzu.example.org
```

This class is almost identical to the previous one, however this one refers instead to the `xpostgresqlinstances.database.tanzu.example.org` CompositeResourceDefinition.

Use `kubectl` to apply the file to the `run-test` cluster.

```console
kubectl apply -f postgres.class.run-test-cluster.yml
```

Create a file named `postgres.class.run-production-cluster.yml` and copy in the following contents.

```yaml
# postgres.class.run-production-cluster.yml

---
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ClusterInstanceClass
metadata:
  name: bigcorp-postgresql
spec:
  description:
    short: PostgreSQL by BigCorp
  provisioner:
    crossplane:
      compositeResourceDefinition: xpostgresqlinstances.database.rds.example.org
```

Again, this class is almost identical to the previous two, but this time refers to the `xpostgresqlinstances.database.rds.example.org` CompositeResourceDefinition.

Use `kubectl` to apply the file to the `run-production` cluster.

```console
kubectl apply -f postgres.class.run-production-cluster.yml
```

## Step 4: Create and Promote the `Workload` and `ClassClaim`

Now that all the setup is done, we can switch roles to that of the Application Operator/Developer, create our `Workload` and `ClassClaim` yaml and promote it through the three clusters.

Create a file named `app-with-postgres.yml` and copy in the following contents.

```yaml
# app-with-postgres.yml

---
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ClassClaim
metadata:
  name: postgres
  namespace: default
spec:
  classRef:
    name: bigcorp-postgresql

---
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: pet-clinic
  namespace: default
  labels:
    apps.tanzu.vmware.com/workload-type: web
    app.kubernetes.io/part-of: pet-clinic
spec:
  params:
  - name: annotations
    value:
      autoscaling.knative.dev/minScale: "1"
  env:
  - name: SPRING_PROFILES_ACTIVE
    value: postgres
  serviceClaims:
  - name: db
    ref:
      apiVersion: services.apps.tanzu.vmware.com/v1alpha1
      kind: ClassClaim
      name: postgres
  source:
    git:
      url: https://github.com/sample-accelerators/spring-petclinic
      ref:
        branch: main
        tag: tap-1.2
```

Then use `kubectl` to apply the file to the `iterate` cluster.

```console
kubectl apply -f app-with-postgres.yml
```

Wait for the Workload to become ready and then inspect the cluster to see that the workload is bound to a **helm-based** postgres service instance. Target the `iterate` cluster then run `helm list -A` to confirm.

Next, apply the **exact same** `app-with-postgres.yml` to the `run-test` cluster. Once ready, confirm that the workload is bound to a **tanzu-based** postgres service instance. Target the `run-test` cluster then run `kubectl get postgres -n tanzu-psql-service-instances` to confirm.

Finally, apply the **exact same** `app-with-postgres.yml` to the `run-production` cluster. Once ready, confirm that the workload is bound to a **rds-based** postgres service instance. Target the `run-production` cluster then run `kubectl get RDSInstance -A` to confirm.
