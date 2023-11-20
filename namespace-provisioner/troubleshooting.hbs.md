# Troubleshoot Namespace Provisioner

This topic tells you how to troubleshoot Namespace Provisioner in Tanzu Application Platform
(commonly known as TAP).

## Air-gapped installation

Namespace Provisioner relies on kapp-controller for any tasks involving communication
with external services, such as registries or Git repositories. When operating in air-gapped
environments or other scenarios where external services are secured by a Custom CA certificate,
you must configure kapp-controller with the CA certificate data to prevent
X.509 certificate errors. For more information, see [Deploy onto Cluster](https://{{ vars.staging_toggle }}.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html#deploy-onto-cluster-5)
in the Cluster Essentials for VMware Tanzu documentation.

## View controller logs

To get the logs when using the [controller](about.hbs.md#nsp-controller) workflow, run the following kubectl command:

```shell
kubectl -n tap-namespace-provisioning logs deployments/controller-manager
```

Use `-f` to follow the log output.

## Provisioner application error

After the Namespace Provisioner is installed in the Tanzu Application Platform cluster, the main resource to check is the [provisioner](about.hbs.md#carvel-app) Carvel Application in the `tap-namespace-provisioning` namespace. To check for the status of the Application, run the following kubectl command:

```shell
kubectl -n tap-namespace-provisioning get app/provisioner --template=\{{.status.usefulErrorMessage}}
```

## Common errors

You might encounter one of the following errors:

### Namespace selector malformed

When using the [controller](about.hbs.md#nsp-controller) and customizing the `namespace_selector` from `tap_values.yaml`, the match expression must be compliant with the [Kubernetes label selector](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors). If it is not compliant, the Namespace Provisioner controller fails and log an error message in the controller logs.

For example, if the configured `namespace_selector` is as follows:

```yaml
namespace_provisioner:
  controller: true
  namespace_selector:
    matchExpressions:
    - key: apps.tanzu.vmware.com/tap-ns
      operator: exists
```

This is not compliant as the operator must be `Exist` instead of `exists`. When labeling the namespace `dev` with `apps.tanzu.vmware.com/tap-ns`, the [controller](about.hbs.md#nsp-controller) produces an error message similar to the following, (followed by some reconciliation messages)

```console
{"level":"error","ts":"2022-12-14T15:41:44.639402794Z","logger":".0.1.NamespaceSelectorReconciler","msg":"unable to sync","controller":"namespace","controllerGroup":"","controllerKind":"Namespace","Namespace":{"name":"dev"},"namespace":"","name":"dev","reconcileID":"26395d34-418b-446d-9b5e-a4a73cc657ed","resourceType":"/v1, Kind=Namespace","error":"\"exists\" is not a valid pod selector operator","stacktrace":"..."}
```

### Debugging ytt templating errors in additional sources

When working with ytt, templating errors in the additional sources in your GitOps repository can cause the Provisioner Carvel application to go into `Reconcile Failed` state. To debug the Application, run the following command:

```shell
kubectl -n tap-namespace-provisioning get app/provisioner --template=\{{.status.usefulErrorMessage}}
```

Sample Error message from Application when there is a ytt templating error:

```console
ytt: Error:
- library.eval: Evaluating library 'witherror':
    in <toplevel>
      template.yaml:155 | #@          instances = overlay.apply(instance.eval(), customize())
    reason:
     - struct has no .gl_secret_user field or method
         in <toplevel>
           _ytt_lib/witherror/secrets.yaml:12 |   username: #@ data.values.gl_secret_user
```

### Unable to delete namespace

When a user tries to delete a namespace that was managed by Namespace Provisioner, it gets stucks in the `Terminating` status.

**Possible Cause 1:** When a provisioned namespace that has a Cartographer Workload in it is deleted, the namespace will likely remain in the Terminating state because some resources can not be deleted. One of the causes of this behavior is that the Cartographer Workload using the Out of the Box supply chains and delivery creates a Carvel Kapp App for the workload that references the ServiceAccount in the namespace. Deleting the namespace deletes the Service Account that Kapp relies on before the App itself is deleted. As a result, the Carvel App blocks the namespace termination while waiting for the ServiceAccount to exist with a `finalizer` (`finalizers.kapp-ctrl.k14s.io/delete`) message.

**Solution:** Remove the Kapp App finalizer in the Kapp App

**Possible Cause 2**: If you try to delete a namespace that was previously managed by the [controller](about.hbs.md#nsp-controller), and the namespace was not cleaned up before disabling the controller, it gets stuck in the `Terminating` state. This happens because the controller adds a `finalizer` to the namespaces (`namespace-provisioner.apps.tanzu.vmware.com/finalizer`) it manages, and is no longer there to clean up that finalizer as it was deactivated by the user.

**Solution:** Remove manually the finalizer in the namespace
