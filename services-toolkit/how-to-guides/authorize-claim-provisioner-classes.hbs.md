# Authorize users and groups to claim from provisioner-based classes

By default, only users with `cluster-admin` privileges are authorized to create claims for provisioner-based classes.
This is because creating claims for provisioner-based classes creates new service instances,
all of which consume resources and might incur monetary cost.
As such, you might want to configure some form of access control.

> **Note** There is one exception to this rule, which is that by default, users with the `app-operator` user role
> are authorized to create claims for the provisioner-based classes which are part of the pre-installed [Bitnami Services](../../bitnami-services/about.hbs.md)
> package. For how-to deactivate this default behavior, see [Revoke default authorization for claiming from the pre-installed Bitnami services classes](#bitnami-services).

This form of access control is implemented through standard Kubernetes RBAC with the use of the
custom verb `claim`.
The general approach is to create a rule in a `ClusterRole` which specifies the `claim` verb for one or
more `clusterinstanceclasses`, then to bind the `ClusterRole` to those you want to authorize to create
claims for the classes. This approach is particularly effective when paired with
Tanzu Application Platform's aggregated [user roles](authn-authz/role-descriptions.html).

## <a id="auth-all-users"></a> Authorize all users with the app-operator user role to claim from any namespace

Create a `ClusterRole` with a rule that specifies the `claim` verb for one or more `ClusterInstanceClass` resources and apply the relevant label.

For example:

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

This example specifies a `ClusterRole` that permits claiming from a class named `bigcorp-rabbitmq`.
The example also includes the `apps.tanzu.vmware.com/aggregate-to-app-operator-cluster-access: "true"` label,
which causes this `ClusterRole` to aggregate to Tanzu Application Platform's [app-operator](authn-authz/role-descriptions.html#app-operator)
user role at the cluster scope.
The result is that any user who has the `app-operator` role bound is now authorized to create claims
for the `bigcorp-rabbitmq` class in any namespace on the cluster.

## <a id="auth-one-user"></a> Authorize one specific user to claim from one specific namespace

Create a `ClusterRole` with a rule that specifies the `claim` verb for one or more `ClusterInstanceClass`
resources and a corresponding `RoleBinding` to bind it to a user.

For example:

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

This example specifies a `ClusterRole` which permits claiming from a class named `bigcorp-rabbitmq`.
The YAML also creates a `RoleBinding` in the `dev-team-1` namespace which binds the
`alice@example.com` user to the `ClusterRole`. The result is that `alice@example.com` is now authorized
to create claims for the `bigcorp-rabbitmq` class in the `dev-team-1` namespace on the cluster.

## <a id="bitnami-services"></a> Revoke default authorization for claiming from the pre-installed Bitnami services classes

By default, users with the `app-operator` user role are authorized to create claims for the
provisioner-based classes which are part of the pre-installed [Bitnami Services](../../bitnami-services/about.hbs.md) package.

To revoke this authorization, add the following to your `tap-values.yaml` file:

```yaml
bitnami_services:
  globals:
    create_clusterroles: false
```

And then update Tanzu Application Platform by running:

```console
tanzu package installed update tap -p tap.tanzu.vmware.com --values-file tap-values.yaml -n tap-install
```

The result is that any user who has the `app-operator` role is now not authorized to create claims
for any of the pre-installed Bitnami services in any namespace on the cluster.
