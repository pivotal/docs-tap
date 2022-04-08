# Build profile

The following is the YAML file sample for the build-profile:

```yaml
profile: build
ceip_policy_disclosed: FALSE-OR-TRUE-VALUE # Installation fails if this is not set to true. Not a string.
buildservice:
  kp_default_repository: "KP-DEFAULT-REPO"
  kp_default_repository_username: "KP-DEFAULT-REPO-USERNAME"
  kp_default_repository_password: "KP-DEFAULT-REPO-PASSWORD"
  tanzunet_username: "TANZUNET-USERNAME"
  tanzunet_password: "TANZUNET-PASSWORD"
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

- `KP-DEFAULT-REPO` is a writable repository in your registry. Tanzu Build Service dependencies are written to this location. Examples:
  * Harbor has the form `kp_default_repository: "my-harbor.io/my-project/build-service"`
  * Dockerhub has the form `kp_default_repository: "my-dockerhub-user/build-service"` or `kp_default_repository: "index.docker.io/my-user/build-service"`
  * Google Cloud Registry has the form `kp_default_repository: "gcr.io/my-project/build-service"`
- `KP-DEFAULT-REPO-USERNAME` is the username that can write to `KP-DEFAULT-REPO`. You should be able to `docker push` to this location with this credential.
  * For Google Cloud Registry, use `kp_default_repository_username: _json_key`
- `KP-DEFAULT-REPO-PASSWORD` is the password for the user that can write to `KP-DEFAULT-REPO`. You can `docker push` to this location with this credential. This credential can also be configured via a Secret reference. See [here](../../tanzu-build-service/install-tbs.html#install-secret-refs) for details.
  * For Google Cloud Registry, use the contents of the service account json file.
- `TANZUNET-USERNAME` and `TANZUNET-PASSWORD` are the email address and password that you use to log in to VMware Tanzu Network. Your VMware Tanzu Network credentials enable you to configure the dependencies updater. This resource accesses and installs the build dependencies (buildpacks and stacks) Tanzu Build Service needs on your cluster. It can also optionally keep these dependencies up to date as new versions are released on VMware Tanzu Network. This credential can also be configured via a Secret reference. See [here](../../tanzu-build-service/install-tbs.html#install-secret-refs) for details.
- `DESCRIPTOR-NAME` is the name of the descriptor to import. See more details [here](../../tanzu-build-service/tbs-about.html#dependencies-descriptors). Available options are:
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

> **Note:** When TAP is installed it is bootstrapped with a set of dependencies (buildpacks and stacks) for application
> builds. Documentation about buildpacks and stacks can be found [here](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/index.html). The buildpack and stack artifacts installed
> with TAP can be found in the descriptor on [Tanzu Network](https://network.pivotal.io/products/tbs-dependencies).
> The current installed version of the descriptor is
> [100.0.279](https://network.pivotal.io/products/tbs-dependencies#/releases/1066670). Sometimes the dependencies get
> out of date and require updates. This can be done via
> [manual process in a CI/CD context](tanzu-build-service/tbs-about.html#dependencies-manual), or
> [updated automatically](tanzu-build-service/tbs-about.html#dependencies-auto-updates) in the background by TAP.
