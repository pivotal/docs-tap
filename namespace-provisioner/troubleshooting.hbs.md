# Troubleshoot Namespace Provisioner

This topic provides information to help troubleshoot Namespace Provisioner.
## <a id="controller-logs"></a>Controller logs

To get the logs when using the [controller](about.hbs.md#nsp-controller) to manage the [desired-namespaces ConfigMap](about.hbs.md#desired-ns-configmap)

```terminal
kubectl -n tap-namespace-provisioning logs deployments/controller-manager
```

Use `-f` to follow the log output

## <a id="carvel-kapp-app-error"></a>Provisioner application error

After the Namespace Provisioner is installed in the Tanzu Application Platform cluster, the main
resource to check is the [provisioner application](about.hbs.md#nsp-component-carvel-app) in the
`tap-namespace-provisioning` namespace.

```terminal
kubectl -n tap-namespace-provisioning get app/provisioner --template=\{{.status.usefulErrorMessage}}
```

For information about why certain resources are not reconciled automatically,
and as a result, might need some manual configuration, see [Control the Namespace Provisioner reconcile behavior for specific resources](how-tos.hbs.md#control-reconcile-behavior).

>**Note** Any error with the [provisioner application](about.hbs.md#nsp-component-carvel-app) is
reported in the Carvel Package Install as a high level message.

```terminal
kubectl -n tap-install get packageinstalls.packaging.carvel.dev/namespace-provisioner --template=\{{.status.usefulErrorMessage}}
```

## <a id="common-errors"></a>Common errors

You might encounter one of the following errors:
### <a id="ns-selector-malformed"></a>Namespace selector malformed

When using the [controller](about.hbs.md#nsp-controller) to manage the [desired-namespaces ConfigMap](about.hbs.md#desired-ns-configmap) and customizing the
`namespace_selector` from `tap_values.yaml`, the match expression must be compliant with the [Kubernetes label selector](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors).
If it is not compliant when labeling a namespace, the Namespace Provisioner doesn't create any object
in the [desired-namespaces ConfigMap](about.hbs.md#desired-ns-configmap) and the controller outputs
a [log](#controller-logs) message.

For example, if the configured `namespace_selector` is

```yaml
namespace_provisioner:
  namespace_selector:
    matchExpressions:
    - key: apps.tanzu.vmware.com/tap-ns
      operator: exists
```

This is not compliant as the operator must be `Exist` instead of `exists`, then when labeling the
namespace `ns2` with `apps.tanzu.vmware.com/tap-ns`, the [controller](about.hbs.md#nsp-controller)
produces an error message similar to the following, (followed by some reconciliation messages)

```json
{"level":"error","ts":"2022-12-14T15:41:44.639402794Z","logger":".0.1.NamespaceSelectorReconciler","msg":"unable to sync","controller":"namespace","controllerGroup":"","controllerKind":"Namespace","Namespace":{"name":"ns2"},"namespace":"","name":"ns2","reconcileID":"26395d34-418b-446d-9b5e-a4a73cc657ed","resourceType":"/v1, Kind=Namespace","error":"\"exists\" is not a valid pod selector operator","stacktrace":"..."}
```

>**Note** The [provisioner application](about.hbs.md#nsp-component-carvel-app) won’t show an error
as the controller cannot update the [desired-namespaces ConfigMap](about.hbs.md#desired-ns-configmap).

### <a id="carvel-ytt-error"></a>Carvel-YTT error in additional_sources

When working with ytt, it is easy to mistakenly miswrite the template, as a result, the Namespace Provisioner
fails when the `additional_sources` is provided with errors. To check the problem in the
[provisioner application](about.hbs.md#nsp-component-carvel-app), see [Provisioner application error](#carvel-kapp-application-error).

For example, the following file is used as `additional_sources`

```yaml
#@ load("@ytt:data", "data")
---
apiVersion: v1
kind: Secret
metadata:
  name: gitlab-workload-token
  annotations:
    tekton.dev/git-0: https://git.company.com
type: kubernetes.io/basic-auth
stringData:
  #! data.values does not have any key of gl-secret-user nor gl-secret-pass
  username: #@ data.values.gl-secret-user
  password: #@ data.values.gl-secret-pass
---
apiVersion: v1
kind: Secret
metadata:
  name: github-workload-token
  annotations:
    tekton.dev/git-0: https://github.aetna.com
type: kubernetes.io/basic-auth
stringData:
  #! data.values does not have any key of gh-secret-user nor gh-secret-pass
  username: #@ data.values.gh-secret-user
  password: #@ data.values.gh-secret-pass
---
```

Where the used `data.values` does not exist, and after adding it as an `additional_source` in the
`witherror` library, the [provisioner application](about.hbs.md#nsp-component-carvel-app) shows an error as follows:

```terminal
$ kubectl -n tap-namespace-provisioning get app/provisioner --template=\{{.status.usefulErrorMessage}}

ytt: Error:
- library.eval: Evaluating library 'witherror':
    in <toplevel>
      template.yaml:155 | #@          instances = overlay.apply(instance.eval(), customize())

    reason:
     - struct has no .gl_secret_user field or method
         in <toplevel>
           _ytt_lib/witherror/secrets.yaml:12 |   username: #@ data.values.gl_secret_user
```

This shows any error coming from the Carvel-YTT template resolution.

Another common error is defining resources several times (like adding a resource that is created by
default instead of overlaying it), this is reported in the [provisioner application](about.hbs.md#nsp-component-carvel-app) also.

### <a id="unable-to-delete-ns"></a>Unable to delete namespace

When a namespaces is provisioned and listed in the [desired-namespaces ConfigMap](about.hbs.md#desired-ns-configmap) (with [controller](about.hbs.md#nsp-controller) or GitOps), delete it using the `kubectl delete namespace`
command.

It must be *cleared* of workload before being deleted. When the provisioned namespace is deleted and
there is a workload already created in the namespace,
the *`namespace`* will likely remain in the `Terminating` state because some resources can
not be deleted.

One of the causes of this behavior is that the workload creates a Carvel Kapp App that references
the ServiceAccount in the namespace. Kubectl does not adhere to Carvel kapp-controller delete order
and the ServiceAccount is deleted before the workload Carvel App. As a result, the Carvel App
blocks the namespace termination while waiting for the ServiceAccount to exist with a
*`finalizer`* (`finalizers.kapp-ctrl.k14s.io/delete`) message.

**Solution:** Remove the Kapp App *`finalizer`* in the Kapp App

- Another possible cause is when you use the [controller](about.hbs.md#nsp-controller) to manage the [desired-namespaces ConfigMap](about.hbs.md#desired-ns-configmap)
and it fails to remove the custom *`finalizer`* added to the namespace (`namespace-provisioner.apps.tanzu.vmware.com/finalizer`)

**Solution:** Remove the *`finalizer`* in the *`namespace`*
