# Authorize users and groups to claim from provisioner-based classes

## About

By default, only users with `cluster-admin` privileges are authorized to create claims for provisioner-based classes*. This is because the creation of claims for provisioner-based classes results in the creation of new service instances, all of which will consume resource and/or incur monetary cost. As such, some form of access control is desirable.

    > **Note** There is one exception to this rule, which is that by default, users with the `app-operator` user role
    > are authorized to create claims for the provisioner-based classes which ship as part of out of the box [Bitnami Services](../../bitnami-services/about.hbs.md)
    > package. See below for how-to disable this default behaviour if desired.

This form of access control is implemented through standard Kubernetes RBAC along with the use of a custom verb - `claim`. The general approach is to create a rule in a `ClusterRole` which specifies the `claim` verb for one or more `clusterinstanceclasses`, then to bind the `ClusterRole` to those you wish to authorize to create claims for the class(es). This approach is particularly effective when paired with Tanzu Application Platform's aggregated [user roles](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/authn-authz-role-descriptions.html).

## Example 1: Authorize all users with the app-operator user role to claim from any namespace

Create a `ClusterRole` with a rule that specifies the `claim` verb for one (or more) `ClusterInstanceClass` resources and apply the relevant label. For example:

```yaml
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

In the example above we specify a `ClusterRole` which permits claiming from a class named `bigcorp-rabbitmq`. We have also added the `apps.tanzu.vmware.com/aggregate-to-app-operator-cluster-access: "true"` label, which causes this `ClusterRole` to aggregate to TAP's [app-operator](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/authn-authz-role-descriptions.html#appoperator-2) user role at the cluster scope. The result is that any user who has the `app-operator` role bound is now authorized to create claims for the `bigcorp-rabbitmq` class in any namespace on the cluster.

## Example 2: Authorize one specific user to claim from one specific namespace

Create a `ClusterRole` with a rule that specifies the `claim` verb for one (or more) `ClusterInstanceClass` resources and a corresponding `RoleBinding` to bind it to a user. For example:

```yaml
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: claim-class-bigcorp-rabbitmq
rules:
- apiGroups:
  - services.apps.tanzu.vmware.com
  resources:
  - clusterinstanceclasses
  resourceNames:
  - bigcorp-rabbitmq
  verbs:
  - claim

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: alice-claim-class-bigcorp-rabbitmq
  namespace: dev-team-1
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: claim-class-bigcorp-rabbitmq
subjects:
- kind: User
  name: "alice@example.com"
  apiGroup: rbac.authorization.k8s.io
```

In the example above we specify a `ClusterRole` which permits claiming from a class named `bigcorp-rabbitmq`. We then create a `RoleBinding` in the `dev-team-1` namespace which binds the `alice@example.com` user to the `ClusterRole`. The result is that `alice@example.com` is now authorized to create claims for the `bigcorp-rabbitmq` class in the `dev-team-1` namespace on the cluster.

## Example 3: Disable the default behaviour authorizing claiming from the out of the box Bitnami services classes

Add the following to your `tap-values.yaml` file:

```yaml
bitnami_services:
  globals:
    create_clusterroles: false
```

And then update Tanzu Application Platform by running:

```console
tanzu package installed update tap -p tap.tanzu.vmware.com --values-file tap-values.yaml -n tap-install
```

The result is that any user who has the `app-operator` role is now not authorized to create claims for any of the out of the box Bitnami services in any namespace on the cluster.
