# Observing and troubleshooting

This section shows how to observe the scan job and get logs.


## <a id="watch-inflight-jobs"></a> Watching in-flight jobs

The scan will run inside the job, which creates a Pod. Both the job and Pod will be cleaned up
automatically after completion.
You can set a watch on the job and Pod before applying a new scan to observe the job deployment.

```console
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```


## <a id="troubleshooting"></a> Troubleshooting

If you run into any problems or face non-expected behavior, you can always address the logs to get 
more feedback.

```console
kubectl -n scan-link-system logs -f deployment/scan-link-controller-manager -c manager
```


### <a id="miss-img-ps"></a> Missing target image pull secret

Scanning an image from a private registry requires an image pull secret to exist in the Scan CR's
namespace and be referenced as `grype.targetImagePullSecret` in `tap-values.yaml`.
See [Installing the Tanzu Application Platform Package and Profiles](../install.md) for more
information.

If a private image scan is triggered and the secret is not configured, the scan job will fail with
the error as follows:

```console
Job.batch "scan-${app}-${id}" is invalid: [spec.template.spec.volumes[2].secret.secretName: Required value, spec.template.spec.containers[0].volumeMounts[2].name: Not found: "registry-cred"]
```


### <a id="diasble-scst-store"></a> Disable Supply Chain Security Tools - Store

The installation of Supply Chain Security Tools - Scan assumes that the
Supply Chain Security Tools - Store is already present.
If you choose to install without the Supply Chain Security Tools - Store,  you need to edit the
configurations to disable the Store.

    ```yaml
    ---
    metadataStore:
      url: ""
    ```

    Install the package with the edited configurations by running:

    ```console
    tanzu package install scan-controller \
      --package-name scanning.apps.tanzu.vmware.com \
      --version VERSION \
      --namespace tap-install \
      --values-file tap-values.yaml
    ```
