# Troubleshooting Cloud Native Runtimes

This topic tells you how to troubleshoot Cloud Native Runtimes, commonly known as CNRs, installation, or configuration.

## <a id='updates-fail'></a> Updates fail with error  annotation value is immutable error

### Symptom

After upgrading to Tanzu Application Platform v1.6.4 or later, if you attempt to update a web workload
created in Tanzu Application Platform v1.6.3 or earlier you see the following error:

```console
API server says: admission webhook "validation.webhook.serving.knative.dev" denied the request: validation failed: annotation value is immutable: metadata.annotations.serving.knative.dev/creator (reason: BadRequest)
```

### Explanation

Kapp controller, which is the orchestrator underneath workloads, deploys resources exactly as requested.
However, Knative adds annotations to Knative Services to track the creator and last modified time of
a resource.
This conflict between kapp controller and Knative is a known issue and expected behavior that is
mitigated by a kapp configuration that the supply chain defines and uses at deploy time.
The kapp config specifies that the annotations Knative adds must not be modified during updates.

As of Tanzu Application Platform v1.6.4, the kapp configuration moved from the delivery
supply chain to the build supply chain.
When a web workload is being updated, the delivery supply chain no longer provides the kapp configuration,
which causes the validation error.
Although the kapp configuration exists on v1.6.4 in a different part of the supply chain, existing
deliverables are not rebuilt to include it.

### Solution

To workaround this issue:

1. Deploy the following overlay as a secret to your Tanzu Application Platform installation namespace.
   In the following example, Tanzu Application Platform is installed to the `tap-install` namespace:

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: old-deliverables-patch
      namespace: tap-install #! namespace where tap is installed
    stringData:
      app-deploy-overlay.yaml: |
        #@ load("@ytt:overlay", "overlay")

        #@ def kapp_config_replace(left, right):
        #@ return left + "\n" + right
        #@ end

        #@overlay/match by=overlay.subset({"kind": "ClusterDeploymentTemplate", "metadata": {"name": "app-deploy"}})
        ---
        spec:
          #@overlay/replace via=kapp_config_replace
          ytt: |
            #@ load("@ytt:overlay", "overlay")
            #@ load("@ytt:yaml", "yaml")

            #@ def kapp_config_temp():
            apiVersion: kapp.k14s.io/v1alpha1
          kind: Config
          rebaseRules:
            - path: [metadata, annotations, serving.knative.dev/creator]
              type: copy
              sources: [new, existing]
              resourceMatchers: &matchers
                - apiVersionKindMatcher: {apiVersion: serving.knative.dev/v1, kind: Service}
            - path: [metadata, annotations, serving.knative.dev/lastModifier]
              type: copy
              sources: [new, existing]
              resourceMatchers: *matchers
          waitRules:
            - resourceMatchers:
              - apiVersionKindMatcher:
                  apiVersion: serving.knative.dev/v1
                  kind: Service
              conditionMatchers:
                - type: Ready
                  status: "True"
                  success: true
                - type: Ready
                  status: "False"
                  failure: true
          ownershipLabelRules:
            - path: [ spec, template, metadata, labels ]
              resourceMatchers:
                - apiVersionKindMatcher: { apiVersion: serving.knative.dev/v1, kind: Service }
          #@ end

          #@overlay/match by=overlay.subset({"apiVersion": "kappctrl.k14s.io/v1alpha1", "kind": "App", "metadata": { "name": data.values.deliverable.metadata.name}})
          ---
          spec:
            fetch:
              #@overlay/append
              - inline:
                  paths:
                    overlay-config.yml: #@ yaml.encode(kapp_config_temp())

    ```

1. If you installed Tanzu Application Platform using a profile, apply the overlay to the `ootb-templates`
   package by following the instructions in [Customize a package that was installed by using a profile](../../customize-package-installation.hbs.md#customize-a-package-that-was-installed-by-using-a-profile-1).

After you complete the steps, updates to the application will deploy.

> **Note** VMware plans to include a fix in future releases.

## <a id='reconcile-fails'></a> Installation fails to reconcile app/cloud-native-runtimes

### Symptom

When installing Cloud Native Runtimes, you see one of the following errors:

```console
11:41:16AM: ongoing: reconcile app/cloud-native-runtimes (kappctrl.k14s.io/v1alpha1) namespace: cloud-native-runtime
11:41:16AM:  ^ Waiting for generation 1 to be observed
kapp: Error: Timed out waiting after 15m0s
```

Or,

```console
3:15:34PM:  ^ Reconciling
3:16:09PM: fail: reconcile app/cloud-native-runtimes (kappctrl.k14s.io/v1alpha1) namespace: cloud-native-runtimes
3:16:09PM:  ^ Reconcile failed:  (message: Deploying: Error (see .status.usefulErrorMessage for details))

kapp: Error: waiting on reconcile app/cloud-native-runtimes (kappctrl.k14s.io/v1alpha1) namespace: cloud-native-runtimes:
  Finished unsuccessfully (Reconcile failed:  (message: Deploying: Error (see .status.usefulErrorMessage for details)))
```

### Explanation

The `cloud-native-runtimes` deployment app installs the subcomponents of Cloud Native Runtimes.
Error messages about reconciling indicate that one or more subcomponents have failed to install.

### Solution

Use the following procedure to examine logs:

1. Get the logs from the `cloud-native-runtimes` app by running:

    ```console
    kubectl get app/cloud-native-runtimes -n cloud-native-runtimes -o jsonpath="{.status.deploy.stdout}"
    ```

    > **Note** If the command does not return log entries,  kapp-controller is not installed or is not running correctly.

2. Review the output for sub component deployments that have failed or are still ongoing.
   See the following examples for suggestions on resolving common problems.

#### Example 1: The Cloud Provider does not support the creation of Service type LoadBalancer

Follow these steps to identify and resolve the problem of the cloud provider not supporting services of type `LoadBalancer`:

1. Search the log output for `Load balancer`, for example, by running:

    ```console
    kubectl -n cloud-native-runtimes get app cloud-native-runtimes -ojsonpath="{.status.deploy.stdout}" | grep "Load balancer" -C 1
    ```

2. If the output looks similar to the following,
   ensure that your cloud provider supports services of type `LoadBalancer`.
   For more information, see [Access Tanzu Developer Portal](../../tap-gui/accessing-tap-gui.hbs.md).

    ```console
    6:30:22PM: ongoing: reconcile service/envoy (v1) namespace: CONTOUR-NS
    6:30:22PM:  ^ Load balancer ingress is empty
    6:30:29PM: ---- waiting on 1 changes [322/323 done] ----
    ```

    Where `CONTOUR-NS` is the namespace where Contour is installed on your cluster. If Cloud Native Runtimes was installed as part of a Tanzu Application Profile, this value is likely `tanzu-system-ingress`.

#### Example 2: The webhook deployment failed

Follow these steps to identify and resolve the problem of the `webhook` deployment failing in the `knative-serving` namespace:

1. Review the logs for output similar to the following:

    ```console
    10:51:58PM: ok: reconcile customresourcedefinition/httpproxies.projectcontour.io (apiextensions.k8s.io/v1) cluster
    10:51:58PM: fail: reconcile deployment/webhook (apps/v1) namespace: knative-serving
    10:51:58PM:  ^ Deployment is not progressing: ProgressDeadlineExceeded (message: ReplicaSet "webhook-6f5d979b7d" has timed out progressing.)
    ```

2. Run `kubectl get pods` to find the name of the pod:

    ```console
    kubectl get pods --show-labels -n NAMESPACE
    ```

    Where `NAMESPACE` is the namespace associated with the reconcile error, for example, `knative-serving`.

    For example,

    ```console
    $ kubectl get pods --show-labels -n knative-serving
    NAME                       READY   STATUS    RESTARTS   AGE   LABELS
    webhook-6f5d979b7d-cxr9k   0/1     Pending   0          44h   app=webhook,kapp.k14s.io/app=1626302357703846007,kapp.k14s.io/association=v1.9621e0a793b4e925077dd557acedbcfe,pod-template-hash=6f5d979b7d,role=webhook
    ```

3. Run `kubectl logs` and `kubectl describe`:

    ```console
    kubectl logs PODNAME -n NAMESPACE
    kubectl describe pod PODNAME -n NAMESPACE
    ```

    Where:

    - `PODNAME` is found in the output of step 3. For example, `webhook-6f5d979b7d-cxr9k`.
    - `NAMESPACE` is the namespace associated with the reconcile error, for example, `knative-serving`.

    For example:

    ```console
    $ kubectl logs webhook-6f5d979b7d-cxr9k -n knative-serving

    $ kubectl describe pod webhook-6f5d979b7d-cxr9k  -n knative-serving
    Events:
    Type     Reason            Age                 From               Message
    ----     ------            ----                ----               -------
    Warning  FailedScheduling  80s (x14 over 14m)  default-scheduler  0/1 nodes are available: 1 Insufficient cpu.
    ```

4. Review the output from the `kubectl logs` and `kubectl describe` commands and take further action.

    For this example of the webhook deployment, the output indicates that the scheduler does not have enough CPU to run the pod.
    In this case, the solution is to add nodes or CPU cores to the cluster.
    If you are using Tanzu Mission Control (TMC), increase the number of workers in the node pool
    to three or more through the TMC UI.
    See [Edit a Node Pool](https://docs.vmware.com/en/VMware-Tanzu-Mission-Control/services/tanzumc-using/GUID-53D4E904-3FFE-464A-8814-13942E03232A.html),
    in the TMC documentation.

## <a id='invalid-httpproxy'></a> Knative Service Fails to Come up Due to Invalid HTTPPRoxy

### Symptom

When creating a Knative Service, it does not reach ready status. The corresponding Route resource has the status  `Ready=Unknown` with `Reason=EndpointsNotReady`. When you inspect the logs for the `net-contour-controller`, you see an error like this:

```json
{"severity":"ERROR","timestamp":"2022-12-08T16:27:08.320604183Z","logger":"net-contour-controller","caller":"ingress/reconciler.go:313","message":"Returned an error","commit":"041f9e3","knative.dev/controller":"knative.dev.net-contour.pkg.reconciler.contour.Reconciler","knative.dev/kind":"networking.internal.knative.dev.Ingress","knative.dev/traceid":"9d615387-f552-449c-a8cd-04c69dd1849e","knative.dev/key":"cody/foo-java","targetMethod":"ReconcileKind","error":"HTTPProxy.projectcontour.io \"foo-java-contour-5f549ae3e6f584a5f33d069a0650c0d8foo-java.cody.\" is invalid: metadata.name: Invalid value: \"foo-java-contour-5f549ae3e6f584a5f33d069a0650c0d8foo-java.cody.\": a lowercase RFC 1123 subdomain must consist of lower case alphanumeric characters, '-' or '.', and must start and end with an alphanumeric character (e.g. 'example.com', regex used for validation is '[a-z0-9]([-a-z0-9]*[a-z0-9])?(\\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*')","stacktrace":"knative.dev/networking/pkg/client/injection/reconciler/networking/v1alpha1/ingress.(*reconcilerImpl).Reconcile\n\tknative.dev/networking@v0.0.0-20221012062251-58f3e6239b4f/pkg/client/injection/reconciler/networking/v1alpha1/ingress/reconciler.go:313\nknative.dev/pkg/controller.(*Impl).processNextWorkItem\n\tknative.dev/pkg@v0.0.0-20221011175852-714b7630a836/controller/controller.go:542\nknative.dev/pkg/controller.(*Impl).RunContext.func3\n\tknative.dev/pkg@v0.0.0-20221011175852-714b7630a836/controller/controller.go:491"}
```

### Solution

Because [the `ChildName` function produces invalid resource names](https://github.com/knative/pkg/issues/2659), certain combinations of Name, Namespace, and Domain yield invalid names for HTTPProxy resources because of the way the name is hashed and trimmed to fit the size requirement. It can have non-alphanumeric characters at the end of the name.

Resolving this is unique to each Knative service. It is likely to involve renaming your app to be shorter so that after the hash and trim procedure, the name is cut to end on an alphanumeric character.

For example, `foo-java.cody.iterate.tanzu-azure-lab.winterfell.fun` is hashed and trimmed into `foo-java-contour-5f549ae3e6f584a5f33d069a0650c0d8foo-java.cody.`, leaving an invalid `.` at the end.

However, changing the app name to `foo-jav` causes `foo-jav-contour-SOME-DIFFERENT-HASH-foo-jav.cody.it`, which is a valid name.
