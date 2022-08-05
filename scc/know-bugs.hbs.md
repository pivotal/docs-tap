# Known bugs

## Unbound number of TaskRuns in pull-request based GitOps

> **Note**: this fix is necessary _only_ for TAP 1.2.0 and a fix is included
> for TAP 1.2.1+. It affects only those installations making use of
> [pull requests](scc/gitops-regops.md#pull-requests) as the method of
> configuration promotion.

In TAP 1.2.0 with the introduction of pull-request based workflows in the
supply chains, a bug has been introduced that leads to the creation of an
unbound number of Tekton TaskRun objects in case multiple `Workload`s in the
same namespace reference the same `ClusterRunTemplate`.

In this particular version, the workaround is to update the
`ClusterRunTemplate` to include `$(runnable.metadata.name)$` as part of the
name used for the TaskRun.

To do so, we must patch the object, which can be achieved by providing a
package overlay during the installation of TAP:

1. create a Kubernetes `Secret` object in the `tap-install` with the overlay to
   be applied:

  ```yaml
  ---
  apiVersion: v1
  kind: Secret
  metadata:
    name: ootb-templates-overlay
    namespace: tap-install
  stringData:
    runtemplate-fix.yaml: |-
      #@ load("@ytt:overlay", "overlay")

      #@ def commit_clusterruntemp():
      kind: ClusterRunTemplate
      metadata:
        name: commit-and-pr-pipelinerun
      #@ end

      #@overlay/match by=overlay.subset(commit_clusterruntemp())
      ---
      spec:
        template:
          metadata:
            generateName: $(runnable.metadata.name)$-pr-
            #@overlay/match missing_ok=True
            labels: $(runnable.metadata.labels)$
  ```

2. reference the secret containing the overlay in the `package_overlays` field
   of `tap-values.yaml`, for instance:

  ```yaml
  # tap-values.yaml

  package_overlays:
    - name: "ootb-templates"
      secrets:
        - name: ootb-templates-overlay
  ```

3. update the TAP installation

  ```console
  tanzu package installed update tap -n tap-install --values-file tap-values.yaml
  ```

With TAP updated, you should be able to obseve that the
`commit-and-pr-pipelinerun` `ClusterRunTemplate` object has been successfully
patched:

- before:

  ```console
  $ kubectl get clusterruntemplate commit-and-pr-pipelinerun -o yaml
  ```

  ```yaml
  # ...
  kind: TaskRun
  metadata:
    generateName: commit-and-pr-
  ```

- after:

  ```console
  $ kubectl get clusterruntemplate commit-and-pr-pipelinerun -o yaml
  ```

  ```yaml
  # ...
  kind: TaskRun
  metadata:
    generateName: $(runnable.metadata.name)$-pr-
  ```
