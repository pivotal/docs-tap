# Install Tanzu Build Service

This document describes how to install Tanzu Build Service
from the Tanzu Application Platform package repository by using the Tanzu CLI.

>**Note:** Use the instructions on this page if you do not want to use a profile to install packages.
Both the full and light profiles include Tanzu Build Service.
For more information about profiles, see [Installing the Tanzu Application Platform Package and Profiles](../install.md).

>**Note:** The following procedure might not include some configurations required for your specific environment.
>For more advanced details on installing Tanzu Build Service, see
>[Installing Tanzu Build Service](https://docs.vmware.com/en/VMware-Tanzu-Build-Service/index.html).

## <a id='tbs-prereqs'></a> Prerequisites

Before installing Tanzu Build Service:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- You must have access to a Docker registry that Tanzu Build Service can use to create builder images.
Approximately 10&nbsp;GB of registry space is required when using the full descriptor.
- Your Docker registry must be accessible with username and password credentials.

## <a id='tbs-tcli-install'></a> Install Tanzu Build Service by using the Tanzu CLI

To install Tanzu Build Service by using the Tanzu CLI:

1. List version information for the package by running:

    ```
    tanzu package available list buildservice.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```
    $ tanzu package available list buildservice.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for buildservice.tanzu.vmware.com...
      NAME                           VERSION  RELEASED-AT
      buildservice.tanzu.vmware.com  1.5.0    2022-12-17T00:00:00Z
    ```

1. (Optional) To make changes to the default installation settings, run:

    ```
    tanzu package available get buildservice.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed in step 1 above.

    For example:

    ```
    $ tanzu package available get buildservice.tanzu.vmware.com/1.5.0 --values-schema --namespace tap-install
    ```


1. Gather the values schema by running:

    ```
    tanzu package available get buildservice.tanzu.vmware.com/1.5.0 --values-schema --namespace tap-install
    ```

2. Create a `tbs-values.yaml` file.

    ```
    ---
    kp_default_repository: "KP-DEFAULT-REPO"
    kp_default_repository_username: "KP-DEFAULT-REPO-USERNAME"
    kp_default_repository_password: "KP-DEFAULT-REPO-PASSWORD"
    tanzunet_username: "TANZUNET-USERNAME"
    tanzunet_password: "TANZUNET-PASSWORD"
    enable_automatic_dependency_updates: TRUE-OR-FALSE-VALUE      # Optional, set as true or false. Not a string.
    ```
    Where:

   - `KP-DEFAULT-REPO` is a writable repository in your registry. Tanzu Build Service dependencies are written to this location. Examples:
     * Harbor has the form `kp_default_repository: "my-harbor.io/my-project/build-service"`
     * Dockerhub has the form `kp_default_repository: "my-dockerhub-user/build-service"` or `kp_default_repository: "index.docker.io/my-user/build-service"`
     * Google Cloud Registry has the form `kp_default_repository: "gcr.io/my-project/build-service"`
   - `KP-DEFAULT-REPO-USERNAME` is the username that can write to `KP-DEFAULT-REPO`. You should be able to `docker push` to this location with this credential.
     * For Google Cloud Registry, use `kp_default_repository_username: _json_key`
   - `KP-DEFAULT-REPO-PASSWORD` is the password for the user that can write to `KP-DEFAULT-REPO`. You can `docker push` to this location with this credential. This credential can also be configured via a Secret reference. See [here](#install-secret-refs) for details.
     * For Google Cloud Registry, use the contents of the service account json file.
   - `TANZUNET-USERNAME` and `TANZUNET-PASSWORD` are the email address and password that you use to log in to VMware Tanzu Network. Your VMware Tanzu Network credentials enable you to configure the dependencies updater. This resource accesses and installs the build dependencies (buildpacks and stacks) Tanzu Build Service needs on your cluster. It can also optionally keep these dependencies up to date as new versions are released on VMware Tanzu Network. This credential can also be configured via a Secret reference. See [here](#install-secret-refs) for details.
   - `DESCRIPTOR-NAME` is the name of the descriptor to import. See more details [here](tanzu-build-service/tbs-about.html#dependencies-descriptors). Available options are:
     * `lite` (default if unset) has a smaller footprint that enables faster installations.
     * `full` optimized to speed up builds and includes dependencies for all supported workload types.
           
     >**Note:** By using the `tbs-values.yaml` configuration,
     >`enable_automatic_dependency_updates: true` causes the dependency updater to update
     >Tanzu Build Service dependencies (buildpacks and stacks) when they are released on
     >VMware Tanzu Network. You can set `enable_automatic_dependency_updates` as `false` to
     >pause the automatic update of Build Service dependencies. When automatic updates are paused, 
     >the pinned version of the descriptor for TAP 1.1.0 is [100.0.279](https://network.pivotal.io/products/tbs-dependencies#/releases/1066670)
     >If left undefined, this value is `false`.

3. Install the package by running:

    ```
    tanzu package install tbs -p buildservice.tanzu.vmware.com -v 1.5.0 -n tap-install -f tbs-values.yaml --poll-timeout 30m
    ```

    For example:

    ```
    $ tanzu package install tbs -p buildservice.tanzu.vmware.com -v 1.5.0 -n tap-install -f tbs-values.yaml --poll-timeout 30m
    | Installing package 'buildservice.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    | Getting package metadata for 'buildservice.tanzu.vmware.com'
    | Creating service account 'tbs-tap-install-sa'
    | Creating cluster admin role 'tbs-tap-install-cluster-role'
    | Creating cluster role binding 'tbs-tap-install-cluster-rolebinding'
    | Creating secret 'tbs-tap-install-values'
    - Creating package resource
    - Package install status: Reconciling

     Added installed package 'tbs' in namespace 'tap-install'
    ```

    >**Note:** Installing the `buildservice.tanzu.vmware.com` package with Tanzu Network credentials
    >automatically relocates buildpack dependencies to your cluster. This install process can take
    >some time and the `--poll-timeout` flag increases the timeout duration.
    >Using the `lite` descriptor speeds this up significantly.
    >If the command times out, periodically run the installation verification step provided in the
    >following optional step. Image relocation continues in the background.

4. (Optional) Verify the clusterbuilders created by the Tanzu Build Service install by running:

    ```
    tanzu package installed get tbs -n tap-install
    ```

## <a id='tbs-tcli-install-offline'></a> Install Tanzu Build Service using the Tanzu CLI air-gapped

Tanzu Build Service can be installed to a Kubernetes Cluster and registry that are air-gapped from external traffic.

These steps assume that you have installed the TAP packages in your air-gapped environment.

To install the Tanzu Build Service package air-gapped:

1. Gather the values schema by running:

    ```
    tanzu package available get buildservice.tanzu.vmware.com/1.5.0 --values-schema --namespace tap-install
    ```

1. Create a `tbs-values.yaml` file. The required fields for an air-gapped installation are:

    ```
    ---
    kp_default_repository: REPOSITORY
    kp_default_repository_username: REGISTRY-USERNAME
    kp_default_repository_password: REGISTRY-PASSWORD
    ca_cert_data: CA-CERT-CONTENTS
    ```

    Where:

    - `REPOSITORY` is the fully qualified path to the Tanzu Build Service repository. This path must be writable. For example:
        * Harbor: `harbor.io/my-project/build-service`
        * Artifactory: `artifactory.com/my-project/build-service`
    - `REGISTRY-USERNAME` and `REGISTRY-PASSWORD` are the user name and password for the internal registry.
    - `CA-CERT-CONTENTS` are the contents of the PEM-encoded CA certificate for the internal registry

1. Install the package by running:

    ```
   tanzu package install tbs -p buildservice.tanzu.vmware.com -v 1.5.0 -n tap-install -f tbs-values.yaml
    ```

   For example:

    ```
    $ tanzu package install tbs -p buildservice.tanzu.vmware.com -v 1.5.0 -n tap-install -f tbs-values.yaml
    | Installing package 'buildservice.tanzu.vmware.com'
    | Getting namespace 'tap-install'
    | Getting package metadata for 'buildservice.tanzu.vmware.com'
    | Creating service account 'tbs-tap-install-sa'
    | Creating cluster admin role 'tbs-tap-install-cluster-role'
    | Creating cluster role binding 'tbs-tap-install-cluster-rolebinding'
    | Creating secret 'tbs-tap-install-values'
    - Creating package resource
    - Package install status: Reconciling
     Added installed package 'tbs' in namespace 'tap-install'
    ```

1. Keep Tanzu Build Service dependencies up-to-date.

When installing Tanzu Build Service to an air-gapped environment, dependencies cannot be automatically pulled in from the external internet.
So dependencies must be imported and kept up to date manually. To import dependencies to an air-gapped Tanzu Build Service, follow the official [Tanzu Build Service docs](https://docs.vmware.com/en/Tanzu-Build-Service/1.4/vmware-tanzu-build-service-v14/GUID-updating-deps.html#online-update).

#### <a id='install-secret-refs'> Installion using Secret References for registry credentials

Tanzu Build Service requires credentials for the `kp_default_repository` and the Tanzu Network registry.

They can be applied in the `values.yaml` configuration directly inline via `_username` and `_password` fields such as `kp_default_repository_username/kp_default_repository_password` and `tanzunet_username/tanzunet_password`.

If you do not want credentials saved in ConfigMaps in plaintext, you can use Secret references in the `values.yaml` configuration to use existing Secrets.

To use secret references you must create Secrets of type `kubernetes.io/dockerconfigjson` containing credentials for `kp_default_repository` and Tanzu Network Registry.

Use the following alternative configuration for `values.yaml`:

    ```
    ---
    kp_default_repository: "KP-DEFAULT-REPO"
    kp_default_repository_secret:
      name: "KP-DEFAULT-REPO-SECRET-NAME"
      namespace: "KP-DEFAULT-REPO-SECRET-NAMESPACE"
    tanzunet_secret:
      name: "TANZUNET-SECRET-NAME"
      namespace: "TANZUNET-SECRET-NAMESPACE"
    enable_automatic_dependency_updates: TRUE-OR-FALSE-VALUE
    ```

    Where:

- `KP-DEFAULT-REPO` is a writable repository in your registry. Tanzu Build Service dependencies are written to this location. Examples:
    * Harbor has the form `kp_default_repository: "my-harbor.io/my-project/build-service"`
    * Dockerhub has the form `kp_default_repository: "my-dockerhub-user/build-service"` or `kp_default_repository: "index.docker.io/my-user/build-service"`
    * Google Cloud Registry has the form `kp_default_repository: "gcr.io/my-project/build-service"`
- `KP-DEFAULT-REPO-SECRET-NAME` is the name of the `kubernetes.io/dockerconfigjson` Secret containing credentials for `KP-DEFAULT-REPO`. You should be able to `docker push` to this location with this credential.
- `KP-DEFAULT-REPO-SECRET-NAMESPACE` is the namespace of the `kubernetes.io/dockerconfigjson` Secret containing credentials for `KP-DEFAULT-REPO`. You should be able to `docker push` to this location with this credential.
- `TANZUNET-SECRET-NAME` is the name of the `kubernetes.io/dockerconfigjson` Secret containing credentials for VMware Tanzu Network registry.
- `TANZUNET-SECRET-NAMESPACE` is the namespace of the `kubernetes.io/dockerconfigjson` Secret containing credentials for VMware Tanzu Network registry.
- `DESCRIPTOR-NAME` is the name of the descriptor to import. See more details [here](tanzu-build-service/tbs-about.html#dependencies-descriptors). Available options are:
    * `lite` (default if unset) has a smaller footprint that enables faster installations.
    * `full` optimized to speed up builds and includes dependencies for all supported workload types.
