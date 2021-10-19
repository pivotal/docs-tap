# Installing on a Tanzu Community Edition v0.9.1 Cluster

This topic lists prerequisites and instructions for installing Tanzu Application Platform on a
Tanzu Community Edition v0.9.1 cluster.

> **Warning**: VMware discourages installing Tanzu Application Platform on a Tanzu Community Edition v0.9.1 cluster in production environments.
This procedure includes a workaround for installing kapp-controller v0.27.0 on Tanzu Community Edition v0.9.1 however, this is not a supported workflow. VMware recommends that you follow this procedure for beta
environments only.
<!-- What is meant by a "supported workflow"? And which isn't the supported workflow,
the workaround or putting kapp-controller v0.27.0 on Tanzu Community Edition v0.9.1? -->

## Install Tanzu Community Edition v0.9.1 

To install on Tanzu Community Edition v0.9.1, follow the instructions in these two sections:

+ [Install kapp-controller](#kapp-controller)
+ [Install Tanzu CLI Plugins](#tanzucli)


### <a id='kapp-controller'></a> Install kapp-controller

To install kapp-controller v0.27.0 or later on Tanzu Community Edition v0.9.1, do the following:

1. Create a new workload or cluster. Do not install any packages on the cluster.
1. Set the kubectl context to the Tanzu Community Edition Management cluster or Tanzu Community Edition Standalone cluster by running:

    ```console
    kubectl config get-contexts
    CURRENT   NAME                          CLUSTER            AUTHINFO           NAMESPACE
   *         az-standalone-tce-admin@az-standalone-tce              az-standalone-tce                                      az-standalone-tce-admin   
          az-tanzu-ce-workload-admin@az-tanzu-ce-workload        az-tanzu-ce-workload                                   az-tanzu-ce-workload-admin
    ```

1. Prevent the Management cluster from reconciling the kapp-controller in the workload cluster by running: 
  >**Note:** Skip this step if you are using a Tanzu Community Edition v0.9.1 standalone cluster.

    ```console
    kubectl patch app/<WORKLOAD-CLUSTER>-kapp-controller -n default -p '{"spec":{"paused":true}}' --type=merge
    ```
    Where `<WORKLOAD-CLUSTER>` is the name of the cluster you created earlier.

1. Import the kubeconfig for the workload cluster by running:
  >**Note:** Skip this step if you're using Tanzu Community Edition v0.9.1 standalone cluster.

    ```console
    tanzu cluster kubeconfig get <WORKLOAD-CLUSTER> --admin
    ```
    Where `<WORKLOAD-CLUSTER>` is the name of the cluster you created earlier.

1.  Switch the kubectl context to the workload cluster by running:
  >**Note:**  Skip this step if you're using Tanzu Community Edition v0.9.1 standalone cluster.

    ```console
    kubectl config use-context <WORKLOAD-CLUSTER-CONTEXT>
    ```
    Where `<WORKLOAD-CLUSTER-CONTEXT>` is the kubeconfig context you imported earlier. 

1. Delete the current kapp-controller by running:

    ```console
    kubectl delete deployment kapp-controller -n tkg-system
    ```

1. Install kapp-controller v0.27.0 by running:

    ```console
    kubectl apply -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/v0.27.0/release.yml
    ```


### <a id='tanzucli'></a> Install the Tanzu CLI Plugins for Tanzu Application Platform

To install the Tanzu CLI plugins required for Tanzu Application Platform:

1. Create a directory named `tanzu-framework` by running:

    ```console
    mkdir $HOME/tanzu-framework
    ```

1. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

1. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/)
on Tanzu Network.

1. Click the **tanzu-cli-0.5.0** directory.

1. Download the CLI bundle corresponding with your operating system. For example, if your client
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

1. Install the `apps` plugin by running:

    ```console
    tanzu plugin install apps --local ./cli
    ```


## Install Tanzu Application Platform

1. Ensure you meet all the prerequisites to install Tanzu Application Platform.
See [Prerequisites](install-general.html#prerequisites-0) in _Installing Part I: Prerequisites, EULA, and CLI_.

    > **Note**: Do not attempt to install the cert-manager package from Tanzu Standard Repository.
    Follow the instructions in TAP documentation to meet all the prerequisites.

1. Follow the steps in [Installing Part II: Packages](install.md) to install
Tanzu Application Platform on a Tanzu Community Edition v0.9.1 cluster.
