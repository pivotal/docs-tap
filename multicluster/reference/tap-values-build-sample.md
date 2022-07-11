# Build profile

The following is the YAML file sample for the build-profile:

```yaml
profile: build
ceip_policy_disclosed: FALSE-OR-TRUE-VALUE # Installation fails if this is not set to true. Not a string.
buildservice:
  kp_default_repository: "KP-DEFAULT-REPO"
  kp_default_repository_username: "KP-DEFAULT-REPO-USERNAME"
  kp_default_repository_password: "KP-DEFAULT-REPO-PASSWORD"
supply_chain: testing_scanning
ootb_supply_chain_testing_scanning:
  registry:
    server: "SERVER-NAME"
    repository: "REPO-NAME"
  gitops:
    ssh_secret: "SSH-SECRET-KEY"
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
    url: "" # Disable embedded integration since it's deprecated
```

Where:

- `KP-DEFAULT-REPO` is a writable repository in your registry. Tanzu Build Service dependencies are written to this location. Examples:
  * Harbor has the form `kp_default_repository: "my-harbor.io/my-project/build-service"`
  * Dockerhub has the form `kp_default_repository: "my-dockerhub-user/build-service"` or `kp_default_repository: "index.docker.io/my-user/build-service"`
  * Google Cloud Registry has the form `kp_default_repository: "gcr.io/my-project/build-service"`
- `KP-DEFAULT-REPO-USERNAME` is the user name that can write to `KP-DEFAULT-REPO`. You can `docker push` to this location with this credential.
  * For Google Cloud Registry, use `kp_default_repository_username: _json_key`
- `KP-DEFAULT-REPO-PASSWORD` is the password for the user that can write to `KP-DEFAULT-REPO`. You can `docker push` to this location with this credential. This credential can also be configured by using a Secret reference. For more information, see [Install Tanzu Build Service](../../tanzu-build-service/install-tbs.html#install-secret-refs) for details.
  * For Google Cloud Registry, use the contents of the service account JSON file.
- `SERVER-NAME` is the host name of the registry server. Examples:
    * Harbor has the form `server: "my-harbor.io"`.
    * Dockerhub has the form `server: "index.docker.io"`.
    * Google Cloud Registry has the form `server: "gcr.io"`.
- `REPO-NAME` is where workload images are stored in the registry.
Images are written to `SERVER-NAME/REPO-NAME/workload-name`. Examples:
    * Harbor has the form `repository: "my-project/supply-chain"`.
    * Dockerhub has the form `repository: "my-dockerhub-user"`.
    * Google Cloud Registry has the form `repository: "my-project/supply-chain"`.
- `SSH-SECRET-KEY` is the SSH secret key in the developer namespace for the supply chain to fetch source code from and push configuration to.
- `METADATA-STORE-URL-ON-VIEW-CLUSTER` references the URL of the Supply Chain Security Tools (SCST) - Store deployed on the View cluster. For more information, see SCST - Store's [Ingress and multicluster support](../../scst-store/ingress-multicluster.html#scst-scan-install) for additional details.
- `MY-DEV-NAMESPACE` is the namespace where you want to deploy the `ScanTemplates`.
This is the namespace where the scanning feature runs.
- `TARGET-REGISTRY-CREDENTIALS-SECRET` is the name of the Secret that contains the
credentials to pull an image from the registry for scanning.
If built images are pushed to the same registry as Tanzu Application Platform images,
you can reuse the `tap-registry` Secret created in
[Add the Tanzu Application Platform package repository](#add-tap-package-repo).

> **Note:** When you install Tanzu Application Platform, it is bootstrapped with the `lite`
> set of dependencies, including buildpacks and stacks, for application builds.
> For more information about buildpacks, see the [VMware Tanzu Buildpacks Documentation](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/index.html).
> You can find the buildpack and stack artifacts installed with Tanzu Application Platform
> on [Tanzu Network](https://network.pivotal.io/products/tbs-dependencies).
> You can update dependencies by [upgrading Tanzu Application Platform](../../upgrading.md)
> to the latest patch, or
> by using an [automatic update process (deprecated)](../../tanzu-build-service/install-tbs.md#auto-updates-config).

> **Note:** The `scanning.metadatastore.url` must be set to an empty string if you're installing Grype Scanner v1.2.0 or later or Snyk Scanner to disable the embedded Supply Chain Security Tools - Store integration.