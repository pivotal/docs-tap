# RBAC

This topic provides API documentation for Role-Based Access Control (RBAC) relating
to Services Toolkit's APIs.

## <a id="aggregation-labels"></a> Aggregation labels

This section describes the following Aggregation labels:

- [servicebinding.io/controller: "true"](#controller)
- [services.tanzu.vmware.com/aggregate-to-provider-kubernetes: "true"](#aggregate-to-provider-kubernetes)
- [services.tanzu.vmware.com/aggregate-to-provider-helm: "true"](#aggregate-to-provider-helm)

### <a id="controller"></a> servicebinding.io/controller: "true"

Use this label to grant the Services Toolkit and service bindings controllers permission to get,
list, and watch resources to be claimed and bound in the cluster.

For example, the following `ClusterRole` grants the controllers permission to get, list, and watch
`RabbitmqCluster` resources.
You cannot create `ClassClaims` or `ResourceClaims` unless the controllers have at least these
permissions for each resource type being claimed.

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: resource-claims-rmq-role
  labels:
    servicebinding.io/controller: "true"
rules:
- apiGroups:
  - rabbitmq.com
  resources:
  - rabbitmqclusters
  verbs:
  - get
  - list
  - watch
```

### <a id="aggregate-to-provider-kubernetes"></a> services.tanzu.vmware.com/aggregate-to-provider-kubernetes: "true"

Use this label to aggregate RBAC rules to `provider-kubernetes`, which is a Crossplane `Provider`
installed by default as part of the [Crossplane](../../../crossplane/about.hbs.md) package in
Tanzu Application Platform.
You must grant relevant RBAC permissions for each API Group/Kind used during the creation of
`Compositions` as part of setting up dynamic provisioning.

For example, the following `ClusterRole` grants `provider-kubernetes` full control over
`rabbitmqclusters` on the `rabbitmq.com` API Group.
This allows you to compose `rabbitmqclusters` in `Compositions`.
For a full example, see [Setup Dynamic Provisioning of Service Instances](../../tutorials/setup-dynamic-provisioning.hbs.md).

```yaml
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

### <a id="aggregate-to-provider-helm"></a> services.tanzu.vmware.com/aggregate-to-provider-helm: "true"

Use this label to aggregate RBAC rules to `provider-helm`, which is a Crossplane `Provider`
installed by default as part of the [Crossplane](../../../crossplane/about.hbs.md) package in
Tanzu Application Platform.
You must grant relevant RBAC permissions for each API Group/Kind used during the creation of Helm
releases when using the `Release` Managed Resource as part of `Compositions`.

For example, the following `ClusterRole` grants `provider-helm` full control over `rabbitmqclusters`
on the `rabbitmq.com` API Group.
This allows you to compose Helm `Releases` which themselves eventually deploy `rabbitmqclusters`
in your `Compositions`.

```yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: rmqcluster-read-writer
  labels:
    services.tanzu.vmware.com/aggregate-to-provider-helm: "true"
rules:
- apiGroups:
  - rabbitmq.com
  resources:
  - rabbitmqclusters
  verbs:
  - "*"
```

## <a id="claim-verb"></a> The claim verb for ClusterInstanceClass

Services Toolkit supports using the `claim` verb for RBAC rules that apply to `clusterinstanceclasses`.
You can use this with relevant aggregating labels, `RoleBindings`, or `ClusterRoleBindings`
as a form of access control to specify who can claim from which `ClusterInstanceClass`
and from where.
For more information, see [Authorize users and groups to claim from provisioner-based classes](../../how-to-guides/authorize-claim-provisioner-classes.hbs.md).

For example:

```yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: app-operator-claim-class-bigcorp-rabbitmq
  labels:
    # (Optional) Aggregates this ClusterRole to Tanzu Application Platform's
    # app-operator user role at the cluster scope. You can choose to aggregate
    # this to any of the other standard user roles as well.
    apps.tanzu.vmware.com/aggregate-to-app-operator-cluster-access: "true"
rules:
# Permits claiming from the 'bigcorp-rabbitmq' class
- apiGroups:
  - services.apps.tanzu.vmware.com
  resources:
  - clusterinstanceclasses
  resourceNames:
  - bigcorp-rabbitmq
  verbs:
  - claim
```
