# Namespace Provisioner Troubleshooting

## <a id="controller-logs"></a>Controller logs

For getting the logs when using the controller to manage the `desire-namespaces`

```bash
kubectl -n tap-namespace-provisioning logs deployments/controller-manager
```

Use `-f` to follow the log output


## <a id="carvel-kapp-application-error"></a>Kapp Application error

After the namespace provisioner is installed in the TAP cluster, the main resource to check is the **[provisioner](about.hbs.md#nsp-component-carvel-app)** Kapp App in the `tap-namespace-provisioning` *`namespace`*.

```bash
kubectl -n tap-namespace-provisioning get app/provisioner --template={{.status.usefulErrorMessage}}
```

Please refer to [Control reconcile behavior of namespace provisioner for certain resources](how-tos.hbs.md#control-reconcile-behavior) to understand why certain resources are not reconciled automatically, and might need some manual intervention.

**Note:** Any error with the Kapp App will be reported in the Carvel Package Install as a high level message.

```bash
kubectl -n tap-install get packageinstalls.packaging.carvel.dev/namespace-provisioner --template={{.status.usefulErrorMessage}}
```

## <a id="common-errors"></a>Common errors

### <a id="namespace-selector-malformed"></a>Namespace selector malformed

When using the controller to manage `desire-namespaces` and customizing the `namespace_selector` from `tap_values` the match expression must be compliant with the [kubernetes label selector](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors), if it is not set as so, when labeling a namespaces the `namespace-provisioner` won't create any object in the desire namespace and the controller will output a [log](#controller-logs) message

For example, suppose that the configured `namespace_selector` is

```yaml
namespace_provisioner:
  namespace_selector:
    matchExpressions:
    - key: apps.tanzu.vmware.com/tap-ns
      operator: exists
```

This is *malformed* due to the operator must be `Exist` instead of `exist`, then when labeling the namespace `ns2` with `apps.tanzu.vmware.com/tap-ns`, the controller will produced an error message as follow, (followed from some reconciliation messages)

```json
{"level":"error","ts":"2022-12-14T15:41:44.639402794Z","logger":".0.1.NamespaceSelectorReconciler","msg":"unable to sync","controller":"namespace","controllerGroup":"","controllerKind":"Namespace","Namespace":{"name":"ns2"},"namespace":"","name":"ns2","reconcileID":"26395d34-418b-446d-9b5e-a4a73cc657ed","resourceType":"/v1, Kind=Namespace","error":"\"exists\" is not a valid pod selector operator","stacktrace":"..."}
```

**Note:** The Kapp App won’t show any error as the controller was not able to update the `desire-namespaces`


### <a id="carvel-ytt-error-additional-sources"></a>Carvel-YTT error in additional_sources

When working with ytt is very easy to mis-write the template, and namespace provisioner will fail when the `additional_sources` is provided with errors, to verify which the problem can be, it is necessary to [check the useful error message in the Kapp App](#carvel-kapp-application-error).

For example, let's assume that the following file is used as `additional_sources`

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

Where the used `data.values` does not exist, and after adding it as an `additional_source` in the `witherror` library, the Kapp App will show an error as follows:

```bash
$ kubectl -n tap-namespace-provisioning get app/provisioner --template={{.status.usefulErrorMessage}}

ytt: Error:
- library.eval: Evaluating library 'witherror':
    in <toplevel>
      template.yaml:155 | #@          instances = overlay.apply(instance.eval(), customize())

    reason:
     - struct has no .gl_secret_user field or method
         in <toplevel>
           _ytt_lib/witherror/secrets.yaml:12 |   username: #@ data.values.gl_secret_user
```

This will show any error coming from the Carvel-YTT template resolution.

Another common error is defining resources several times (like adding a resource which is created as default instead of ovelaying it), that will be reported in the Kapp App as well

### <a id="unable-to-delete-namespace"></a>Unable to delete namespace

When a namespaces is provisioned by be present in the `desired-namespaces` (via controller or GitOps), then it can be deleted in a common way by `kubectl` command

```bash
kubectl delete namespace {namespace-name}
```

but it needs to be *cleared* of workload before being deleted.

When the provisioned namespace is deleted and there is a workload already created in there, it is very likely that the *`namespace`* will keep the `Terminating` state because some resources can not be deleted.

- One of the causes of this behavior is because the workload creates a Carvel Kapp App to manage the workload referencing the `ServiceAccount` in the *`namespace`* and the `kubectl` command does not take precedence of the `ServiceAccount` over the Kapp App then it can be deleted first, and then the workload Kapp App will block the namespace termination failing itself while waiting the `ServiceAccount` to exist with a *`finalizer`* (`finalizers.kapp-ctrl.k14s.io/delete`).
**Solution:** Remove the Kapp App *`finalizer`* in the Kapp App

- Other possible cause is when the controller is used to manage the **desired-namespaces** *`ConfigMap`* and it fails removing the custom *`finalizer`* added to the namespace (`namespace-provisioner.apps.tanzu.vmware.com/finalizer`)
**Solution:** Remove the *`finalizer`* in the *`namespace`*

</br>

---

### Links to additional Namespace Provisioner documentation:
* [Overview](about.hbs.md)
* [Installation](install.hbs.md)
* [Tutorial - Provisioning Namespaces](tutorials.hbs.md) 
* [How-To Provision and Customize Namespaces via GitOps](how-tos.hbs.md)
* [Reference Materials](reference.hbs.md)