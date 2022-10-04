# Build profile

The following is the YAML file sample for the build-profile:

```yaml
profile: build
ceip_policy_disclosed: FALSE-OR-TRUE-VALUE # Installation fails if this is not set to true. Not a string.

shared:
  ingress_domain: "INGRESS-DOMAIN"
  kubernetes_distribution: "openshift" # To be passed only for Openshift. Defaults to "".
  image_registry:
    project_path: "SERVER-NAME/REPO-NAME" # Will be used by Build Service by appending "/buildservice" and used by Supply chain by appending "/workloads"
    username: "KP-DEFAULT-REPO-USERNAME"
    password: "KP-DEFAULT-REPO-PASSWORD"

ceip_policy_disclosed: FALSE-OR-TRUE-VALUE # Installation fails if this is not set to true. Not a string.

#The above shared keys may be overridden in the below sesion.

buildservice: #optional if the corresponding shared keys are provided
  kp_default_repository: "KP-DEFAULT-REPO"
  kp_default_repository_username: "KP-DEFAULT-REPO-USERNAME"
  kp_default_repository_password: "KP-DEFAULT-REPO-PASSWORD"
supply_chain: testing_scanning
ootb_supply_chain_testing_scanning: #Optional if the shared above mentioned shared keys are provided.
  registry:
    server: "SERVER-NAME"
    repository: "REPO-NAME"
  gitops:
    ssh_secret: "SSH-SECRET-KEY" # (optional) Defaults to "".
grype:
  namespace: "MY-DEV-NAMESPACE" # (optional) Defaults to default namespace.
  targetImagePullSecret: "TARGET-REGISTRY-CREDENTIALS-SECRET"
  metadataStore:
    url: METADATA-STORE-URL-ON-VIEW-CLUSTER
    caSecret:
        name: store-ca-cert
        importFromNamespace: metadata-store-secrets
    authSecret:
        name: store-auth-token
        importFromNamespace: metadata-store-secrets
scanning:
  metadataStore:
    url: "" # Deactivate embedded integration since it's deprecated
tap_telemetry:
  customer_entitlement_account_number: "CUSTOMER-ENTITLEMENT-ACCOUNT-NUMBER" # (optional) identify data for creation of TAP usage reports
```

Where:

- `KP-DEFAULT-REPO` is a writable repository in your registry. Tanzu Build Service dependencies are written to this location. Examples:
    - Harbor has the form `kp_default_repository: "my-harbor.io/my-project/build-service"`
    - Docker Hub has the form `kp_default_repository: "my-dockerhub-user/build-service"` or `kp_default_repository: "index.docker.io/my-user/build-service"`
    - Google Cloud Registry has the form `kp_default_repository: "gcr.io/my-project/build-service"`
- `KP-DEFAULT-REPO-USERNAME` is the user name that can write to `KP-DEFAULT-REPO`. You can `docker push` to this location with this credential.
    - For Google Cloud Registry, use `kp_default_repository_username: _json_key`
- `KP-DEFAULT-REPO-PASSWORD` is the password for the user that can write to `KP-DEFAULT-REPO`. You can `docker push` to this location with this credential. This credential can also be configured by using a Secret reference. For more information, see [Install Tanzu Build Service](../../tanzu-build-service/install-tbs.html#install-secret-refs) for details.
    - For Google Cloud Registry, use the contents of the service account JSON file.
- `SERVER-NAME` is the host name of the registry server. Examples:
    - Harbor has the form `server: "my-harbor.io"`.
    - Docker Hub has the form `server: "index.docker.io"`.
    - Google Cloud Registry has the form `server: "gcr.io"`.
- `REPO-NAME` is where workload images are stored in the registry.
Images are written to `SERVER-NAME/REPO-NAME/workload-name`. Examples:
    - Harbor has the form `repository: "my-project/supply-chain"`.
    - Docker Hub has the form `repository: "my-dockerhub-user"`.
    - Google Cloud Registry has the form `repository: "my-project/supply-chain"`.
- `SSH-SECRET-KEY` is the SSH secret key in the developer namespace for the supply chain to fetch source code from and push configuration to.
- `METADATA-STORE-URL-ON-VIEW-CLUSTER` references the URL of the Supply Chain Security Tools (SCST) - Store deployed on the View cluster. For more information, see SCST - Store's [Ingress and multicluster support](../../scst-store/ingress-multicluster.html#scst-scan-install) for additional details.
- `MY-DEV-NAMESPACE` is the namespace where you want to deploy the `ScanTemplates`.
This is the namespace where the scanning feature runs.
- `TARGET-REGISTRY-CREDENTIALS-SECRET` is the name of the Secret that contains the
credentials to pull an image from the registry for scanning.
- `CUSTOMER-ENTITLEMENT-ACCOUNT-NUMBER` (optional) refers to the Entitlement Account Number (EAN), which is a unique identifier VMware assigns to its customers. Tanzu Application Platform telemetry uses this number to identify data that belongs to a particular customers and prepare usage reports. See [Kubernetes Grid documentation](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.5/vmware-tanzu-kubernetes-grid-15/GUID-cluster-lifecycle-ceip.html#identify-the-entitlement-account-number-2) for more information about identifying the Entitlement Account Number.

> **Note:** When you install Tanzu Application Platform, it is bootstrapped with the `lite`
> set of dependencies, including buildpacks and stacks, for application builds.
> For more information about buildpacks, see the [VMware Tanzu Buildpacks Documentation](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-index.html).
> You can find the buildpack and stack artifacts installed with Tanzu Application Platform
> on [Tanzu Network](https://network.pivotal.io/products/tbs-dependencies).
> You can update dependencies by [upgrading Tanzu Application Platform](../../upgrading.md)
> to the latest patch, or
> by using an [automatic update process (deprecated)](../../tanzu-build-service/install-tbs.md#auto-updates-config).

> **Note:** The `scanning.metadatastore.url` must be set to an empty string if you're installing Grype Scanner v1.2.0 or later or Snyk Scanner to deactivate the embedded Supply Chain Security Tools - Store integration.
