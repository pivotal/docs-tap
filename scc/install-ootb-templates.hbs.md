# Install Out of the Box Templates for Supply Chain Choreographer

This topic describes how you can install Out of the Box Templates for Supply
Chain Choreographer from the Tanzu Application Platform package repository.

> **Note** Follow the steps in this topic if you do not want to use a profile to install Out of the Box Templates. For more information about profiles, see [Components and installation profiles](../about-package-profiles.hbs.md).

The Out of the Box Templates package is used by all the Out of the Box Supply
Chains to provide the templates that are used by the Supply Chains to create
the objects that drive source code all the way to a deployed application in a
cluster.

## <a id='ootb-templ-prereqs'></a>Prerequisites

Before installing Out of the Box Templates:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- Install cartographer. For more information, see [Install Supply Chain Choreographer](install-scc.md).
- Install [Tekton Pipelines](../tekton/install-tekton.md).

## <a id='inst-ootb-templ-proc'></a> Install

To install Out of the Box Templates:

1. View the configurable values of the package by running:

    ```console
    tanzu package available get ootb-templates.tanzu.vmware.com/0.14.7 \
      --values-schema \
      -n tap-install
    ```

    For example:

    ```console
    KEY                                                               DEFAULT                                                                           TYPE     DESCRIPTION
    kubernetes_version                                                ""                                                                                string   Optional: The Kubernetes Version. Valid values are '1.24.*', or ''

    label_propagation_exclusions                                      - kapp.k14s.io/app -                                                              array    List of workload/deliverable labels to avoid propagating to stamped resources
                                                                      kapp.k14s.io/association
    podintent_security_context.runAsGroup                                                                                                               integer  The GID to run the entrypoint of the container process.
    podintent_security_context.runAsNonRoot                                                                                                             boolean  Indicates that the container must run as a non-root user.
    podintent_security_context.runAsUser                                                                                                                integer  The UID to run the entrypoint of the container process.
    podintent_security_context.windowsOptions.runAsUserName                                                                                             string   The UserName in Windows to run the entrypoint of the container process.
    podintent_security_context.windowsOptions.gmsaCredentialSpec                                                                                        string   GMSACredentialSpec is where the GMSA admission webhook
                                                                                                                                                                (https://github.com/kubernetes-sigs/windows-gmsa) inlines the contents of the
                                                                                                                                                                GMSA credential spec named by the GMSACredentialSpecName field.
    podintent_security_context.windowsOptions.gmsaCredentialSpecName                                                                                    string   GMSACredentialSpecName is the name of the GMSA credential spec to use.
    podintent_security_context.windowsOptions.hostProcess                                                                                               boolean  HostProcess determines if a container should be run as a 'Host Process'
                                                                                                                                                                container.
    podintent_security_context.allowPrivilegeEscalation                                                                                                 boolean  AllowPrivilegeEscalation controls whether a process can gain more privileges
                                                                                                                                                                than its parent process.
    podintent_security_context.capabilities.add                                                                                                         array
    podintent_security_context.capabilities.drop                                                                                                        array
    podintent_security_context.readOnlyRootFilesystem                                                                                                   boolean  Whether this container has a read-only root filesystem. Default is false.
    podintent_security_context.seLinuxOptions.level                                                                                                     string   Level is SELinux level label that applies to the container.
    podintent_security_context.seLinuxOptions.role                                                                                                      string   Role is a SELinux role label that applies to the container.
    podintent_security_context.seLinuxOptions.type                                                                                                      string   Type is a SELinux type label that applies to the container.
    podintent_security_context.seLinuxOptions.user                                                                                                      string   User is a SELinux user label that applies to the container.
    podintent_security_context.seccompProfile.localhostProfile                                                                                          string   localhostProfile indicates a profile defined in a file on the node should
                                                                                                                                                                be used. The profile must be preconfigured on the node to work. Must be a
                                                                                                                                                                descending path, relative to the kubelet's configured seccomp profile location.
                                                                                                                                                                Must only be set if type is "Localhost".
    podintent_security_context.seccompProfile.type                                                                                                      string   type indicates which kind of seccomp profile will be applied. Valid options
                                                                                                                                                                are, Localhost - a profile defined in a file on the node should be used.
                                                                                                                                                                RuntimeDefault - the container runtime default profile should be used.
                                                                                                                                                                Unconfined - no profile should be applied.
    podintent_security_context.privileged                                                                                                               boolean  Run container in privileged mode. Defaults to false.
    podintent_security_context.procMount                                                                                                                string   procMount denotes the type of proc mount to use for the containers.
    ca_cert_data                                                                                                                                        string   PEM encoded certificate data for the image registry where the image will be
                                                                                                                                                                pushed to.
    excluded_templates                                                                                                                                  array    List of templates to exclude from the installation (e.g. ['git-writer'])
    iaas_auth                                                         false                                                                             boolean  Enable the use of IAAS based authentication for imgpkg
    kubernetes_distribution                                                                                                                             string   Optional: Type of K8s infrastructure being used. Supported Values: 'openshift',
                                                                                                                                                                ''                                                                                                                            
    ```

1. Create a file named `ootb-templates.yaml` that specifies the corresponding
   values to the properties you want to change.

   For example, the contents of the file might look like this:

    ```yaml
    excluded_templates: []
    podintent_secuirty_context:
      allowPrivilegeEscalation: false
      runAsNonRoot: true
      seccompProfile:
        type: RuntimeDefault
      capabilities:
        drop:
        - ALL
    ```


1. After the configuration is ready, install the package by running:

    ```console
    tanzu package install ootb-templates \
      --package ootb-templates.tanzu.vmware.com \
      --version 0.7.0 \
      --namespace tap-install \
      --values-file ootb-templates-values.yaml
    ```

    Example output:

    ```console
    \ Installing package 'ootb-templates.tanzu.vmware.com'
    | Getting package metadata for 'ootb-templates.tanzu.vmware.com'
    | Creating service account 'ootb-templates-tap-install-sa'
    | Creating cluster admin role 'ootb-templates-tap-install-cluster-role'
    | Creating cluster role binding 'ootb-templates-tap-install-cluster-rolebinding'
    | Creating secret 'ootb-templates-tap-install-values'
    | Creating package resource
    - Waiting for 'PackageInstall' reconciliation for 'ootb-templates'
    / 'PackageInstall' resource install status: Reconciling

     Added installed package 'ootb-templates' in namespace 'tap-install'
    ```
