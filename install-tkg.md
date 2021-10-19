# Installing with Tanzu Kubernetes Grid v1.4

This topic lists prerequisites and instructions for installing Tanzu Application Platform on a
Tanzu Kubernetes Grid v1.4 cluster.

> **Warning**: VMware discourages installing Tanzu Application Platform on a Tanzu Kubernetes Grid v1.4
cluster in production environments.
This procedure includes a workaround for installing kapp-controller v0.27.0 on Tanzu Kubernetes Grid
v1.4, which is not a supported workflow. VMware recommends that you follow this procedure for beta
purposes only.
<!-- What is meant by a "supported workflow"? And which isn't the supported workflow,
the workaround or putting kapp-controller v0.27.0 on Tanzu Kubernetes Grid v1.4? -->


## Prerequisites

To install Tanzu Kubernetes Grid v1.4, you must:

+ [Install kapp-controller](#kapp-controller)
+ [Install Tanzu CLI Plugins](#tanzucli)


## Install kapp-controller

To install kapp-controller v0.27.0 or later on Tanzu Kubernetes Grid v1.4:

1. Create a new workload cluster. Do not install any packages in the cluster.
1. Ensure the kubectl context is set to the Tanzu Kubernetes Grid Management cluster by running:

    ```console
    kubectl config get-contexts
    CURRENT   NAME                          CLUSTER            AUTHINFO           NAMESPACE
        kind-dev-cluster              kind-dev-cluster   kind-dev-cluster
    *         tkg4tap-admin@tkg4tap         tkg4tap            tkg4tap-admin
        tkg4tapwld-admin@tkg4tapwld   tkg4tapwld         tkg4tapwld-admin
    ```

1. Prevent the Management cluster from reconciling <!-- reconciling with what? --> the kapp-controller in the workload cluster by running:

    ```console
    kubectl patch app/<WORKLOAD-CLUSTER>-kapp-controller -n default -p '{"spec":{"paused":true}}' --type=merge
    ```
    Where `<WORKLOAD-CLUSTER>` is the name of the cluster created earlier.

1. Import the kubeconfig for the workload cluster by running:

    ```console
    tanzu cluster kubeconfig get <WORKLOAD-CLUSTER> --admin
    ```
    Where `<WORKLOAD-CLUSTER>` is the name of the cluster created earlier.

1.  Switch the kubectl context to the workload cluster by running:

    ```console
    kubectl config use-context <WORKLOAD-CLUSTER-CONTEXT>
    ```
    Where `<WORKLOAD-CLUSTER-CONTEXT>` is the kubeconfig context imported earlier.

1. Delete the current kapp-controller by running:

    ```console
    kubectl delete deployment kapp-controller -n tkg-system
    ```

1. Install kapp-controller v0.27.0 by running:

    ```console
    kubectl apply -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/v0.27.0/release.yml
    ```


## Install Tanzu CLI Plugins

To install the Tanzu CLI plugins required for TAP:

1. Create a directory named `tanzu-framework` by running:

    ```console
    mkdir $HOME/tanzu-framework
    ```

1. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

1. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/)
on VMware Tanzu Network.

1. Click on the **tanzu-cli-0.5.0** directory.

1. Download the CLI bundle corresponding to your operating system. For example, if your client
operating system is Linux, download the `tanzu-framework-linux-amd64.tar` bundle.

1. Unpack the TAR file in the `tanzu-framework` directory by running:

    ```console
    tar -xvf tanzu-framework-linux-amd64.tar -C $HOME/tanzu-framework
    ```

1. Navigate to the `tanzu-framework` directory by running:

    ```console
    cd $HOME/tanzu-framework
    ```

1. Install the `imagepullsecret` plugin by running:

    ```console
    tanzu plugin install imagepullsecret --local ./cli
    ```

1. Install the `accelerator` plugin by running:

    ```console
    tanzu plugin install accelerator --local ./cli
    ```

1. Install the `apps` plugin by running: <!-- this should read install apps, right? -->

    ```console
    tanzu plugin install imagepullsecret --local ./cli
    ```


## Install Tanzu Application Platform with Tanzu Kubernetes Grid v1.4

1. Ensure you meet all the Prerequisites for Tanzu Application Platform installation.
See [Prerequisites](install-general.html#prerequisites-0) in _Installing Part I: Prerequisites, EULA, and CLI_.

    > **Note**: Do not attempt to install the cert-manager package from Tanzu Standard Repository:
    follow the instructions in TAP documentation to meet all the prerequisites.

1. Follow the steps in [Installing Part II: Packages](install.md) to install on a
Tanzu Kubernetes Grid v1.4 cluster.
