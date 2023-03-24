# Troubleshooting

This topic provides information to help troubleshoot Namespace Provisioner.
## ✅ View Controller logs

To get the logs when using the [controller](#heading=h.fuuugva9krkd) workflow, run the following kubectl command:

```console
kubectl -n tap-namespace-provisioning logs deployments/controller-manager
```

Use - f to follow the log output.

## Provisioner application error

After the Namespace Provisioner is installed in the Tanzu Application Platform cluster, the main resource to check is the [provisioner](#heading=h.ppkq2k2gr7y8) Carvel Application in the `tap-namespace-provisioning` namespace. To check for the status of the Application, run the following kubectl command:

```console
kubectl -n tap-namespace-provisioning get app/provisioner --template={{.status.usefulErrorMessage}}
```

## Common errors

You might encounter one of the following errors:

## Namespace selector malformed

When using the [controller](#heading=h.fuuugva9krkd) and customizing the `namespace_selector` from `tap_values.yaml`, the match expression must be compliant with the [Kubernetes label selector](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors). If it is not compliant, the Namespace provisioner controller would fail and log an error message in the controller logs.

For example, if the configured `namespace_selector` is as follows:

```console
namespace_provisioner:
  controller: true
  namespace_selector:
    matchExpressions:
    - key: apps.tanzu.vmware.com/tap-ns
      operator: exists
```


This is not compliant as the operator must be `Exist` instead of `exists`. When labeling the namespace `dev` with `apps.tanzu.vmware.com/tap-ns`, the [controller](#heading=h.fuuugva9krkd) produces an error message similar to the following, (followed by some reconciliation messages)

```console
{"level":"error","ts":"2022-12-14T15:41:44.639402794Z","logger":".0.1.NamespaceSelectorReconciler","msg":"unable to sync","controller":"namespace","controllerGroup":"","controllerKind":"Namespace","Namespace":{"name":"dev"},"namespace":"","name":"dev","reconcileID":"26395d34-418b-446d-9b5e-a4a73cc657ed","resourceType":"/v1, Kind=Namespace","error":"\"exists\" is not a valid pod selector operator","stacktrace":"..."}
```

## Debugging ytt templating errors in additional sources

When working with ytt, templating errors in the additional sources in your GitOps repo can cause the Provisioner Carvel Application to go into `Reconcile Failed` state. To debug the Application, run the following command:


```console
kubectl -n tap-namespace-provisioning get app/provisioner --template={{.status.usefulErrorMessage}}
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

## Unable to delete namespace

When a user tries to delete a namespace that was managed by Namespace provisioner, it gets stocks in the `Terminating` status.

**Possible Cause 1:** When a provisioned namespace that has a Cartographer Workload in it is deleted, the <code><em>namespace</em></code> will likely remain in the <code>Terminating</code> state because some resources can not be deleted. One of the causes of this behavior is that the Cartographer Workload using the Out of the Box supply chains and delivery creates a Carvel Kapp App for the workload that references the ServiceAccount in the namespace. Deleting the namespace deletes the Service Account that Kapp relies on before the App itself is deleted. As a result, the Carvel App blocks the namespace termination while waiting for the ServiceAccount to exist with a <code><em>finalizer</em></code> (<code>finalizers.kapp-ctrl.k14s.io/delete</code>) message.

**Solution:** Remove the Kapp App <code><em>finalizer</em></code> in the Kapp App

**Possible Cause 2**: When a user tries to delete a namespace that was previously managed by the namespace provisioner controller, and the namespace was not cleaned up before disabling the controller, it will get stuck in the `Terminating` state. This happens because the namespace provisioner controller adds a <code><em>finalizer</em></code> to the namespaces (<code>namespace-provisioner.apps.tanzu.vmware.com/finalizer</code>) it manages, and is no longer there to clean up that finalizer as it was disabled by the user.

**Solution:** Remove manually the <code><em>finalizer</em></code> in the <code><em>namespace</em></code>