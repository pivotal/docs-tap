# Troubleshooting Application Accelerator for VMware Tanzu

This topic has troubleshooting steps for:

- [Development issues](#dev-issues)
- [Accelerator authorship issues](#authorship-issues)
- [Operations issues](#ops-issues)

## <a id="dev-issues"></a> Development issues

### <a id="fail-generate"></a>Failure to generate a new project

#### <a id="uri-not-absolute-error"></a>`URI is not absolute` error

The `generate` command fails with the following error:

```console
% tanzu accelerator generate test --server-url https://accelerator.example.com
Error: there was an error generating the accelerator, the server response was: "URI is not absolute"

Use:
  tanzu accelerator generate [flags]

Examples:
  tanzu accelerator generate <accelerator-name> --options '{"projectName":"test"}'

Flags:
  -h, --help                  help for generate
      --options string        options JSON string
      --options-file string   path to file containing options JSON string
      --output-dir string     directory that the zip file will be written to
      --server-url string     the URL for the Application Accelerator server

Global Flags:
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)

there was an error generating the accelerator, the server response was: "URI is not absolute"

Error: exit status 1

✖  exit status 1
```

This indicates that the accelerator resource requested is not in a `READY` state.
Review the instructions in the [When Accelerator ready column is false](#ts-ready-false) section or
contact your system admin.


## <a id="authorship-issues"></a> Accelerator authorship issues

### <a id="tips"></a>General tips

#### <a id="speed-reconciliation"></a>Speed up the reconciliation of the accelerator

Set the `git.interval` to make the accelerator reconcile sooner.
The default interval is 10 minutes, which is too long when developing an accelerator.

You can set this when using the YAML manifest:

```yaml
apiVersion: accelerator.apps.tanzu.vmware.com/v1alpha1
kind: Accelerator
metadata:
  name: test-accelerator
spec:
  git:
    url: https://github.com/trisberg/test-accelerator
    ref:
      branch: main
    interval: 10s
```

You can also set this when creating the accelerator resource. To do so from the Tanzu CLI, run:

``` console
tanzu accelerator create test-accelerator --git-repo https://github.com/trisberg/test-accelerator --git-branch main --interval 10s
```

#### <a id="use-source-image"></a>Use a source image with local accelerator source directory

You don't have to use a Git repository when developing an accelerator.
You can create an accelerator based on content in a local directory using `--local-path` when
creating the accelerator resource.

Push the local path content to an OCI image by running:

```console
tanzu accelerator create test-accelerator --local-path . --source-image REPO-PREFIX/test-accelerator --interval 10s
```

Where `REPO-PREFIX` is your own repository prefix.
Use a repository that the deployed Application Accelerator system can access.

The interval is 10s so that you can push changes to the source-image repository and get faster
reconcile time for the accelerator resource.
When you have made changes to your accelerator source, push those changes by running:

```console
tanzu accelerator push --local-path . --source-image REPO-PREFIX/test-accelerator
```

Where `REPO-PREFIX` is your own repository prefix.
Use a repository that is accessible to the deployed Application Accelerator system.

### <a id="expression-eval-errors"></a>Expression evaluation errors

Expression evaluation errors include:

- Expression `evaluated to null`, such as:

    ```console
    Could not read response from accelerator: java.lang.IllegalArgumentException: Expression '#mytestexp' evaluated to null
    ```

    In most cases, a typo in the variable name causes this error.
    Compare the expression with the defined options or any variables declared with `let`.

- `could not parse SpEL expression`, such as:

    ```console
    Could not read response from accelerator: Error reading manifest:could not parse SpEL expression at [Source: (InputStreamReader); line: 65, column: 1] (through reference chain: com.vmware.tanzu.accelerator.engine.manifest.Manifest["engine"]->com.vmware.tanzu.accelerator.engine.transform.transforms.Combo["let"]->java.util.ArrayList[0]->com.vmware.tanzu.accelerator.engine.transform.transforms.Let$DerivedSymbol["expression"])
    ```

    In most cases, an error in a `let` expression causes this error.
    Review the error message and, for more information, see [SpEL samples](creating-accelerators/spel-samples.md).

- `SpelEvaluationException`, such as:

    ```console
    Could not read response from accelerator: org.springframework.expression.spel.SpelEvaluationException: EL1007E: Property or field 'test' cannot be found on null
    ```

    In most cases, an error in a transform expression causes this error.
    Review the error message and, for more information, see [SpEL samples](creating-accelerators/spel-samples.md).


## <a id="ops-issues"></a> Operations issues

### <a id="check-status"></a>Check status of accelerator resources

Verify the status of accelerator resources by using kubectl or the Tanzu CLI:

- From kubectl, run:

    ```console
    kubectl get accelerators.accelerator.apps.tanzu.vmware.com -n accelerator-system
    ```

- From the Tanzu CLI, run:

    ```console
    tanzu accelerator list
    ```

Verify that the `READY` status is `true` for all accelerators.

### <a id="ready-blank"></a>When Accelerator ready column is blank

1. View the status of `accelerator-system` by running:

    ```console
    kubectl get deployment -n accelerator-system
    ```

    Example output:

    ```console
    NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
    acc-engine                       1/1     1            1           3d5h
    acc-server                       1/1     1            1           2d1h
    accelerator-controller-manager   0/1     1            0           3d5h
    ```

2. View the logs for any component with no Pods available by running:

    ```console
    kubectl logs deployment/COMPONENT-NAME/ -n accelerator-system -p
    ```

    Where `COMPONENT-NAME` is the component with no pods you retrieved in the previous step.

    - If the log has the following error then the FluxCD source-controller is not installed:

        ```console
        2021-11-18T20:55:18.963Z ERROR setup problem running manager {"error": "failed to wait for accelerator caches to sync: no matches for kind \"GitRepository\" in version \"source.toolkit.fluxcd.io/v1beta1\""}
        ```

    - If the log has the following error, the Tanzu Application Platform source-controller is not installed:

        ```console
        2021-11-18T20:50:10.557Z ERROR setup problem running manager {"error": "failed to wait for accelerator caches to sync: no matches for kind \"ImageRepository\" in version \"source.apps.tanzu.vmware.com/v1alpha1\""}
        ```

### <a id="ts-ready-false"></a> When Accelerator ready column is false

View the `REASON` column for non-ready accelerators. Run:

```console
kubectl get accelerators.accelerator.apps.tanzu.vmware.com -n accelerator-system
```

#### <a id="reason-GitRepositoryResolutionFailed"></a> REASON: `GitRepositoryResolutionFailed`

For example:

```console
$ kubectl get accelerators.accelerator.apps.tanzu.vmware.com -n accelerator-system
NAME        READY   REASON                             AGE
more-fun    False   GitRepositoryResolutionFailed      28s
```

1. View the resource status. Run:

    ```console
    kubectl get -oyaml accelerators.accelerator.apps.tanzu.vmware.com -n accelerator-system hello-fun
    ```

2. Read `status.conditions.message` near the end of the output to learn the likely
cause of failure. For example:

    ```yaml
    status:
      address:
        url: http://accelerator-engine.accelerator-system.svc.cluster.local/invocations
      artifact:
        message: 'unable to clone ''https://github.com/sample-accelerators/hello-fun'',
          error: couldn''t find remote ref "refs/heads/test"'
        ready: false
        url: ""
      conditions:
      - lastTransitionTime: "2021-11-18T21:05:47Z"
        message: |-
          failed to resolve GitRepository
          unable to clone 'https://github.com/sample-accelerators/hello-fun', error: couldn't find remote ref "refs/heads/test"
        reason: GitRepositoryResolutionFailed
        status: "False"
        type: Ready
      description: Test-git
      observedGeneration: 1
    ```

    In this example, `couldn't find remote ref "refs/heads/test"` reveals that the branch or tag
    specified doesn't exist.

    Another common problem is that the Git repository doesn't exist.
    For example:

    ```yaml
    status:
      address:
        url: http://accelerator-engine.accelerator-system.svc.cluster.local/invocations
      artifact:
        message: 'unable to clone ''https://github.com/sample-accelerators/hello-funk'',
          error: authentication required'
        ready: false
        url: ""
      conditions:
      - lastTransitionTime: "2021-11-18T21:09:52Z"
        message: |-
          failed to resolve GitRepository
          unable to clone 'https://github.com/sample-accelerators/hello-funk', error: authentication required
        reason: GitRepositoryResolutionFailed
        status: "False"
        type: Ready
      description: Test-git
      observedGeneration: 1
    ```

    An error message about failed authentication might display because the Git repository doesn't
    exist. For example:

    ```console
    unable to clone 'https://github.com/sample-accelerators/hello-funk', error: authentication required
    ```

#### <a id="reason-GitRepositoryResolutionPending"></a> REASON: `GitRepositoryResolutionPending`

For example:

```console
$ kubectl get accelerators.accelerator.apps.tanzu.vmware.com -n accelerator-system
NAME        READY   REASON                             AGE
more-fun    False   GitRepositoryResolutionPending     28s
```

1. See the resource status. Run:

    ```console
    kubectl get -oyaml accelerators.accelerator.apps.tanzu.vmware.com -n accelerator-system hello-fun
    ```

2. Locate `status.conditions` at the end of the output. For example:

    ```yaml
    status:
      address:
        url: http://accelerator-engine.accelerator-system.svc.cluster.local/invocations
      artifact:
        message: ""
        ready: false
        url: ""
      conditions:
      - lastTransitionTime: "2021-11-18T20:17:38Z"
        message: GitRepository not yet resolved
        reason: GitRepositoryResolutionPending
        status: "False"
        type: Ready
      description: Test-git
      observedGeneration: 1
    ```

3. Verify that the Flux system is running and that the `READY` column has `1/1`. Run:

    ```console
    kubectl get -n flux-system deployment/source-controller
    ```

    Example output:

    ```console
    NAME                READY   UP-TO-DATE   AVAILABLE   AGE
    source-controller   1/1     0            0           5d4h
    ```

#### <a id="reason-ImageRepositoryResolutionPending"></a> REASON: `ImageRepositoryResolutionPending`

For example:

```console
$ kubectl get accelerators.accelerator.apps.tanzu.vmware.com -n accelerator-system
NAME        READY   REASON                             AGE
more-fun    False   ImageRepositoryResolutionPending   28s
```

1. See the resource status. Run:

    ```console
    kubectl get -oyaml accelerators.accelerator.apps.tanzu.vmware.com -n accelerator-system hello-fun
    ```

2. Locate `status.conditions` at the end of the output. For example:

    ```console
    $ kubectl get -oyaml accelerators.accelerator.apps.tanzu.vmware.com -n accelerator-system more-fun

    apiVersion: accelerator.apps.tanzu.vmware.com/v1alpha1
    kind: Accelerator
    metadata:
      annotations:
        kubectl.kubernetes.io/last-applied-configuration: |
          {"apiVersion":"accelerator.apps.tanzu.vmware.com/v1alpha1","kind":"Accelerator","metadata":{"annotations":{},"name":"more-fun","namespace":"accelerator-system"},"spec":{"description":"Test-image","source":{"image":"trisberg/more-fun-source"}}}
      creationTimestamp: "2021-11-18T20:32:36Z"
      generation: 1
      name: more-fun
      namespace: accelerator-system
      resourceVersion: "605401"
      uid: 407b565d-14aa-44fe-ad8d-c9b3c3a7e5ce
    spec:
      description: Test-image
      source:
        image: trisberg/more-fun-source
    status:
      address:
        url: http://accelerator-engine.accelerator-system.svc.cluster.local/invocations
      artifact:
        message: ""
        ready: false
        url: ""
      conditions:
      - lastTransitionTime: "2021-11-18T20:32:36Z"
        message: ImageRepository not yet resolved
        reason: ImageRepositoryResolutionPending
        status: "False"
        type: Ready
      description: Test-image
      observedGeneration: 1
    ```

3. Verify that Tanzu Application Platform source-controller system is running and
the `READY` column has `1/1`. Run:

    ```console
    kubectl get -n source-system deployment/source-controller-manager
    ```

    Expected output:

    ```console
    NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
    source-controller-manager   1/1     0            0           5d5h
    ```
