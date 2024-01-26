# Install Tanzu Application Platform Build profile

This topic tells you how to install Build profile cluster by using a reduced values file.

## Prerequisites

Before installing the Build profile, follow all the steps in [Install View cluster](../installing-multicluster.hbs.md#install-view-cluster).

## Example values.yaml

The following is the YAML file sample for the build-profile:

```yaml
profile: build
ceip_policy_disclosed: FALSE-OR-TRUE-VALUE # Installation fails if this is not set to true. Not a string.

shared:
  ingress_domain: "INGRESS-DOMAIN"
  kubernetes_distribution: "openshift" # To be passed only for OpenShift. Defaults to "".
  kubernetes_version: "K8S-VERSION"
  image_registry:
    project_path: "SERVER-NAME/REPO-NAME" # To be used by Build Service by appending "/buildservice" and used by Supply chain by appending "/workloads".
    secret:
      name: "KP-DEFAULT-REPO-SECRET"
      namespace: "KP-DEFAULT-REPO-SECRET-NAMESPACE"
  ca_cert_data: | # To be passed if using custom certificates.
    -----BEGIN CERTIFICATE-----
    MIIFXzCCA0egAwIBAgIJAJYm37SFocjlMA0GCSqGSIb3DQEBDQUAMEY...
    -----END CERTIFICATE-----

# The above shared keys can be overridden in the below section.

buildservice:
# Takes the value from the shared section by default, but can be overridden by setting a different value.
  kp_default_repository: "KP-DEFAULT-REPO"
  kp_default_repository_secret:
    name: "KP-DEFAULT-REPO-SECRET"
    namespace: "KP-DEFAULT-REPO-SECRET-NAMESPACE"
supply_chain: testing_scanning
ootb_supply_chain_testing_scanning: # Optional if the corresponding shared keys are provided.
  registry:
    server: "SERVER-NAME"
    repository: "REPO-NAME"
  gitops:
    ssh_secret: "SSH-SECRET-KEY" # (Optional) Defaults to "".
tap_telemetry:
  customer_entitlement_account_number: "CUSTOMER-ENTITLEMENT-ACCOUNT-NUMBER" # (Optional) Identify data for creating Tanzu Application Platform usage reports.

amr:
  observer:
    auth:
      kubernetes_service_accounts:
        enable: true
    cloudevent_handler:
      endpoint: https://amr-cloudevent-handler.VIEW-CLUSTER-INGRESS-DOMAIN # AMR CloudEvent Handler location at the View profile cluster.
    ca_cert_data: |
        "AMR-CLOUDEVENT-HANDLER-CA"
```

> **Important** Installing Grype by using `tap-values.yaml` as follows is
> deprecated in v1.6 and will be removed in v1.8:
>
> ```yaml
> grype:
>   targetImagePullSecret: "TARGET-REGISTRY-CREDENTIALS-SECRET"
>```
>
> You can install Grype by using Namespace Provisioner instead.

Where:

- `K8S-VERSION` is the Kubernetes version used by your OpenShift cluster. It must be in the form of `1.23.x` or `1.24.x`, where `x` stands for the patch version. Examples:
    - Red Hat OpenShift Container Platform v4.10 uses the Kubernetes version `1.23.3`.
    - Red Hat OpenShift Container Platform v4.11 uses the Kubernetes version `1.24.1`.
- `KP-DEFAULT-REPO` is a writable repository in your registry. The Tanzu Build Service dependencies are written to this location. Examples:
    - Harbor has the form `kp_default_repository: "my-harbor.io/my-project/build-service"`
    - Docker Hub has the form `kp_default_repository: "my-dockerhub-user/build-service"` or `kp_default_repository: "index.docker.io/my-user/build-service"`
    - Google Cloud Registry has the form `kp_default_repository: "gcr.io/my-project/build-service"`
    - For Google Cloud Registry, use the contents of the service account JSON file.
- `KP-DEFAULT-REPO-SECRET` is the secret with user credentials that can write to `KP-DEFAULT-REPO`. You can `docker push` to this location with this credential.
    - For Google Cloud Registry, use `kp_default_repository_username: _json_key`.
    - You must create the secret before the installation. For example, you can use the `registry-credentials` secret created earlier.
- `KP-DEFAULT-REPO-SECRET-NAMESPACE` is the namespace where `KP-DEFAULT-REPO-SECRET` is created.
- `SERVER-NAME` is the host name of the registry server. Examples:
    - Harbor has the form `server: "my-harbor.io"`.
    - Docker Hub has the form `server: "index.docker.io"`.
    - Google Cloud Registry has the form `server: "gcr.io"`.
- `REPO-NAME` is where workload images are stored in the registry.
Images are written to `SERVER-NAME/REPO-NAME/workload-name`. Examples:
    - Harbor has the form `repository: "my-project/supply-chain"`.
    - Docker Hub has the form `repository: "my-dockerhub-user"`.
    - Google Cloud Registry has the form `repository: "my-project/supply-chain"`.
- `SSH-SECRET-KEY` is the SSH secret key in the developer namespace for the supply chain to fetch source code from and push configuration to. See [Git authentication](../../scc/git-auth.hbs.md) for more information.
- `METADATA-STORE-URL-ON-VIEW-CLUSTER` is the URL of the Supply Chain Security Tools (SCST) - Store deployed on the View cluster. For example, `https://metadata-store.example.com`. For information about `caSecret` and `store-auth-token`, see [Set up multicluster Supply Chain Security Tools (SCST) - Store](../../scst-store/multicluster-setup.hbs.md).
- `MY-DEV-NAMESPACE` is the name of the developer namespace. SCST - Scan deploys the `ScanTemplates` there. This allows the scanning feature to run in this namespace.
- `TARGET-REGISTRY-CREDENTIALS-SECRET` is the name of the Secret that contains the
credentials to pull an image from the registry for scanning.
- `CUSTOMER-ENTITLEMENT-ACCOUNT-NUMBER` (optional) refers to the Entitlement Account Number (EAN), which is a unique identifier VMware assigns to its customers. Tanzu Application Platform telemetry uses this number to identify data that belongs to a particular customers and prepare usage reports. See the [Tanzu Kubernetes Grid documentation](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.5/vmware-tanzu-kubernetes-grid-15/GUID-cluster-lifecycle-ceip.html#identify-the-entitlement-account-number-2) for more information about identifying the Entitlement Account Number.
- `VIEW-CLUSTER-INGRESS-DOMAIN` is the subdomain you set up on the View profile cluster. This matches the `shared.ingress_domain` on the View profile cluster.
- `AMR-CLOUDEVENT-HANDLER-CA` contains the AMR CloudEvent Handler CA data. For more information about configuring the `amr` portion of the values file, see [Set up multicluster Supply Chain Security Tools (SCST) - Store](../../scst-store/multicluster-setup.hbs.md).

When you install Tanzu Application Platform, it is bootstrapped with the `lite`
set of dependencies, including buildpacks and stacks, for application builds.
For more information about buildpacks, see the [VMware Tanzu Buildpacks Documentation](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-index.html).
You can find the buildpack and stack artifacts installed with Tanzu Application Platform
on [Tanzu Network](https://network.pivotal.io/products/tbs-dependencies).
You can update the dependencies by [upgrading Tanzu Application Platform](../../upgrading.md) to the latest patch.

See [Set up multicluster Supply Chain Security Tools (SCST) - Store](../../scst-store/multicluster-setup.hbs.md) for more information about the value settings of `grype.metadataStore`.

You must set the `scanning.metadatastore.url` to an empty string if you're installing Grype Scanner v1.2.0 and later or Snyk Scanner to deactivate the embedded SCST - Store integration.

If you use custom CA certificates, you must provide one or more PEM-encoded CA certificates under the `ca_cert_data` key. If you configured `shared.ca_cert_data`, Tanzu Application Platform component packages inherit that value by default.
