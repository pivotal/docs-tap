# RBAC

Detailed API documentation for RBAC relating to Services Toolkit's APIs.

## Aggregation Labels

### servicebinding.io/controller: "true"

Use this label to grant the services toolkit and service bindings controllers permission to get, list and watch resources that will be claimed and bound to in the cluster.

For example, the following `ClusterRole` grants the controllers permission to get, list and watch `RabbitmqCluster` resources.

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

It will not be possible to successfully create `ClassClaims` or `ResourceClaims` unless the controllers have at least these permissions for each resource type being claimed.

### services.tanzu.vmware.com/aggregate-to-provider-kubernetes: "true"

Use this label to aggregate RBAC rules to `provider-kubernetes` - a Crossplane `Provider` installed by default as part of the [Crossplane](../../../crossplane/about.hbs.md) Package in Tanzu Application Platform. Relevant RBAC permissions must be granted for each API Group/Kind used during the creation of `Compositions` as part of setting up Dynamic Provisioning.

For example, the following `ClusterRole` grants `provider-kubernetes` full control over `rabbitmqclusters` on the `rabbitmq.com` API Group. This allows you to compose `rabbitmqclusters` in `Compositions`. See [Setup Dynamic Provisioning of Service Instances](../../tutorials/setup-dynamic-provisioning.hbs.md) for a full example and walkthrough.

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

### services.tanzu.vmware.com/aggregate-to-provider-helm: "true"

Use this label to aggregate RBAC rules to `provider-helm` - a Crossplane `Provider` installed by default as part of the [Crossplane](../../../crossplane/about.hbs.md) Package in Tanzu Application Platform. Relevant RBAC permissions must be granted for each API Group/Kind used during the creation of Helm releases when using the `Release` Managed Resource as part of `Compositions`.

For example, the following `ClusterRole` grants `provider-helm` full control over `rabbitmqclusters` on the `rabbitmq.com` API Group. This allows you to compose Helm `Releases` which themselves eventually deploy `rabbitmqclusters` in your `Compositions`.

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

## The claim verb for ClusterInstanceClass

Services Toolkit supports the usage of a `claim` verb for RBAC rules that apply to `clusterinstanceclasses`. This, along with relevant aggregating labels, `RoleBindings` or `ClusterRoleBindings` can be used as a form of access control to determine who is able to claim from which `ClusterInstanceClass` and from where. See [Authorize users and groups to claim from provisioner-based classes](../../how-to-guides/authorize-claim-provisioner-classes.hbs.md) for further information.

For example:

```yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: app-operator-claim-class-bigcorp-rabbitmq
  labels:
    # aggregate this ClusterRole to TAP's app-operator user role at the cluster scope
    # you could choose to aggregate this to any of the other standard user roles as well
    # (optional)
    apps.tanzu.vmware.com/aggregate-to-app-operator-cluster-access: "true"
rules:
# permit claiming from the 'bigcorp-rabbitmq' class
- apiGroups:
  - services.apps.tanzu.vmware.com
  resources:
  - clusterinstanceclasses
  resourceNames:
  - bigcorp-rabbitmq
  verbs:
  - claim
```
