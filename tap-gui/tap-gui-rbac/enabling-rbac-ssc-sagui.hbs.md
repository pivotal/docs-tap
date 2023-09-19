# Enable RBAC for SSC and SAGUI Plugins

This topic tells you how to be able to view workloads on SSC and SAGUI when using a cluster with RBAC and namespace-scoped access.

## Adding permissions to list namespaces
In order to be able to get the information from the scoped namespaces, the users must have permissions to list namespaces. To do that you need to create a new ClusterRole and ClusterRoleBinding.

``` yml
# namespace-cluster-role.yaml 
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: namespaces-role
rules:
- apiGroups: ['']
  resources: ['namespaces']
  verbs: ['get', 'list']
```

``` yml
# namespaces-cluster-role-binding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: namespaces-rolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: namespaces-role
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: <YOUR_USER_ID>
```

## Add label to the scoped namespaces
Our current implementation requires the scoped namespaces to have an specific label or annotation. If you are using the namespace provisioner one of the required labels will be present, however in order to be sure run the following command to add the supported annotation to the scoped namespaces:

```
kubectl annotate namespaces <NAMESPACE> apps.tanzu.vmware.com/tap-managed-ns=""
```

With this annotation the UI will be able to pick the scoped namespaces and allow you to view workloads on such namespaces.

![Showing RBAC Enabled on SAGUI and SSC Plugins.](../images/rbac-on-ssc-and-sagui-plugins.png)