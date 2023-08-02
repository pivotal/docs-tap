# Troubleshooting Eventing

This topic tells you how to troubleshoot an Eventing installation or configuration.

## <a id='reconcile-fails'></a> Installation fails to reconcile app/eventing

### Symptom
When installing Eventing, you see one of the following errors:

```
11:41:16AM: ongoing: reconcile app/eventing (kappctrl.k14s.io/v1alpha1) namespace: eventing
11:41:16AM:  ^ Waiting for generation 1 to be observed
kapp: Error: Timed out waiting after 15m0s
```

Or,

```
3:15:34PM:  ^ Reconciling
3:16:09PM: fail: reconcile app/eventing (kappctrl.k14s.io/v1alpha1) namespace: eventing
3:16:09PM:  ^ Reconcile failed:  (message: Deploying: Error (see .status.usefulErrorMessage for details))

kapp: Error: waiting on reconcile app/eventing (kappctrl.k14s.io/v1alpha1) namespace: eventing:
  Finished unsuccessfully (Reconcile failed:  (message: Deploying: Error (see .status.usefulErrorMessage for details)))
```

### Explanation
The `eventing` deployment app installs the necessary subcomponents.
Error messages about reconciling indicate that one or more subcomponents have failed to install.

### Solution
Use the following procedure to examine logs:

1. Get the logs from the `eventing` app by running:

    ```sh
    kubectl get app/eventing -n eventing -o jsonpath="{.status.deploy.stdout}"
    ```

    > **Note:** If the command does not return log messages, then kapp-controller is not installed or is not running correctly.


1. Review the output for sub component deployments that have failed or are still ongoing.
   See the examples below for suggestions on resolving common problems.
