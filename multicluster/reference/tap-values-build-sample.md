# Build profile

The following is the YAML file sample for the build-profile:

```yaml
profile: build
ceip_policy_disclosed: FALSE-OR-TRUE-VALUE # Installation fails if this is not set to true. Not a string.
buildservice:
  kp_default_repository: "KP-DEFAULT-REPO"
  kp_default_repository_username: "KP-DEFAULT-REPO-USERNAME"    # Mutually exclusive with kp_default_repository_secret
  kp_default_repository_password: "KP-DEFAULT-REPO-PASSWORD"    # Mutually exclusive with kp_default_repository_secret
  kp_default_repository_secret:                                 # Mutually exclusive with kp_default_repository_username/kp_default_repository_password
    name: "KP-DEFAULT-REPO-SECRET-NAME"
    namespace: "KP-DEFAULT-REPO-SECRET-NAMESPACE"
  tanzunet_username: "TANZUNET-USERNAME"                        # Mutually exclusive with tanzunet_secret
  tanzunet_password: "TANZUNET-PASSWORD"                        # Mutually exclusive with tanzunet_secret
  tanzunet_secret:                                              # Mutually exclusive with tanzunet_username/tanzunet_password
    name: "TANZUNET-SECRET-NAME"
    namespace: "TANZUNET-SECRET-NAMESPACE"
  enable_automatic_dependency_updates: TRUE-OR-FALSE-VALUE # Optional, set as true or false. Not a string.
supply_chain: basic

ootb_supply_chain_basic:
  registry:
    server: "SERVER-NAME"
    repository: "REPO-NAME"
  gitops:
    ssh_secret: "SSH-SECRET-KEY"

grype:
  namespace: "MY-DEV-NAMESPACE" # (optional) Defaults to default namespace.
  targetImagePullSecret: "TARGET-REGISTRY-CREDENTIALS-SECRET"
```

Where:

- For `buildservice` top level key:
  - `KP-DEFAULT-REPO` is a writable repository in your registry. Tanzu Build Service dependencies are written to this location. Examples:
    * Harbor has the form `kp_default_repository: "my-harbor.io/my-project/build-service"`
    * Dockerhub has the form `kp_default_repository: "my-dockerhub-user/build-service"` or `kp_default_repository: "index.docker.io/my-user/build-service"`
    * Google Cloud Registry has the form `kp_default_repository: "gcr.io/my-project/build-service"`
  - **Registry credentials**: Credentials are required for the `kp_default_repository` and the Tanzu Network registry. They can be applied in the configuration directly via `_username` and `_password` fields or via a Secret with `_secret` nested fields.
    - `kp_default_repository`:
      - `KP-DEFAULT-REPO-USERNAME` is the username that can write to `KP-DEFAULT-REPO`. You should be able to `docker push` to this location with this credential.
        * For Google Cloud Registry, use `kp_default_repository_username: _json_key`
      - `KP-DEFAULT-REPO-PASSWORD` is the password for the user that can write to `KP-DEFAULT-REPO`. You can `docker push` to this location with this credential.
        * For Google Cloud Registry, use the contents of the service account json file.

      **or**

      - `KP-DEFAULT-REPO-SECRET-NAME` is the name of the `kubernetes.io/dockerconfigjson` Secret containing credentials for `KP-DEFAULT-REPO`. You should be able to `docker push` to this location with this credential.
      - `KP-DEFAULT-REPO-SECRET-NAMESPACE` is the namespace of the `kubernetes.io/dockerconfigjson` Secret containing credentials for `KP-DEFAULT-REPO`. You should be able to `docker push` to this location with this credential.
    - Tanzu Network Registry (`registry.tanzu.vmware.com`)
      - `TANZUNET-USERNAME` and `TANZUNET-PASSWORD` are the email address and password that you use to log in to VMware Tanzu Network.

      **or**

      - `TANZUNET-SECRET-NAME` is the name of the `kubernetes.io/dockerconfigjson` Secret containing credentials for VMware Tanzu Network registry.
      - `TANZUNET-SECRET-NAMESPACE` is the namespace of the `kubernetes.io/dockerconfigjson` Secret containing credentials for VMware Tanzu Network registry.
  - `DESCRIPTOR-NAME` is the name of the descriptor to import. See more details [here](tanzu-build-service/tbs-about.html#dependencies-descriptors). Available options are:
    * `lite` (default if unset) has a smaller footprint that enables faster installations.
    * `full` optimized to speed up builds and includes dependencies for all supported workload types.
- `SERVER-NAME` is the host name of the registry server. Examples:
    * Harbor has the form `server: "my-harbor.io"`.
    * Dockerhub has the form `server: "index.docker.io"`.
    * Google Cloud Registry has the form `server: "gcr.io"`.
- `REPO-NAME` is where workload images are stored in the registry.
Images are written to `SERVER-NAME/REPO-NAME/workload-name`. Examples:
    * Harbor has the form `repository: "my-project/supply-chain"`.
    * Dockerhub has the form `repository: "my-dockerhub-user"`.
    * Google Cloud Registry has the form `repository: "my-project/supply-chain"`.
- `SSH-SECRET-KEY` is the SSH secret key supported by the specific package.
See [Identify the SSH secret key for your package](#ssh-secret-key) for more information.
- `MY-DEV-NAMESPACE` is the namespace where you want to deploy the `ScanTemplates`.
This is the namespace where the scanning feature runs.
- `TARGET-REGISTRY-CREDENTIALS-SECRET` is the name of the secret that contains the
credentials to pull an image from the registry for scanning.
If built images are pushed to the same registry as Tanzu Application Platform images,
you can reuse the `tap-registry` secret created in
[Add the Tanzu Application Platform package repository](#add-tap-package-repo).

>**Note:** When using the `tbs-values.yaml` configuration,
>`enable_automatic_dependency_updates: true` causes the dependency updater to update
>Tanzu Build Service dependencies, such as buildpacks and stacks, when they are released on
>VMware Tanzu Network. Use `false` to pause the automatic update of Build Service dependencies.
>When automatic updates are paused, the pinned version of the descriptor for TAP 1.1.0 is [100.0.279](https://network.pivotal.io/products/tbs-dependencies#/releases/1066670)
>The default value is `false`.
