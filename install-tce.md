# Installing on a Tanzu Community Edition v0.9.1 cluster

This topic lists prerequisites and instructions for installing Tanzu Application Platform on a
Tanzu Community Edition v0.9.1 cluster.

> **Warning**: VMware discourages installing Tanzu Application Platform on a Tanzu Community Edition v0.9.1 cluster in production environments.
This procedure includes a workaround for installing kapp-controller v0.29.0 on Tanzu Community Edition v0.9.1; however, this is not a supported workflow. VMware recommends that you follow this procedure for beta
environments only.
<!-- What is meant by a "supported workflow"? And which isn't the supported workflow,
the workaround or putting kapp-controller v0.29.0 on Tanzu Community Edition v0.9.1? -->

## Install Tanzu Community Edition v0.9.1

To install on Tanzu Community Edition v0.9.1, follow the instructions in these two sections:

+ [Install kapp-controller](#kapp-controller)
+ [Install Tanzu CLI Plugins](#tanzucli)


### <a id='kapp-controller'></a> Install kapp-controller

To install kapp-controller v0.29.0 or later on Tanzu Community Edition v0.9.1:

1. Create a new workload or cluster. Do not install any packages on the cluster.
1. Ensure the kubectl context is set to the Tanzu Community Edition Management cluster or Tanzu Community Edition Standalone cluster by running:

    ```
    kubectl config get-contexts
    CURRENT   NAME                          CLUSTER            AUTHINFO           NAMESPACE
   *         az-standalone-tce-admin@az-standalone-tce              az-standalone-tce                                      az-standalone-tce-admin   
          az-tanzu-ce-workload-admin@az-tanzu-ce-workload        az-tanzu-ce-workload                                   az-tanzu-ce-workload-admin
    ```
    >**Note:** If you are using Tanzu Community Edition v0.9.1 standalone cluster, skip the following 3 steps. Go directly to step 6 to delete the current kapp-controller.
1. Prevent the Management cluster from reconciling the kapp-controller in the workload cluster by running: 

    ```
    kubectl patch app/WORKLOAD-CLUSTER-kapp-controller -n default -p '{"spec":{"paused":true}}' --type=merge
    ```
    Where `WORKLOAD-CLUSTER` is the name of the cluster you created earlier.

1. Import the kubeconfig for the workload cluster by running:

    ```
    tanzu cluster kubeconfig get WORKLOAD-CLUSTER --admin
    ```
    Where `WORKLOAD-CLUSTER` is the name of the cluster you created earlier.

1.  Switch the kubectl context to the workload cluster by running:

    ```
    kubectl config use-context WORKLOAD-CLUSTER-CONTEXT
    ```
    Where `WORKLOAD-CLUSTER-CONTEXT` is the kubeconfig context you imported earlier. 

1. Delete the current kapp-controller by running:

    ```
    kubectl delete deployment kapp-controller -n tkg-system
    ```

1. Install kapp-controller v0.29.0 by running:

    ```
    kubectl apply -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/v0.29.0/release.yml
    ```

1. Install secretgen-controller v0.7.1 or greater by running:

    ```
    kubectl create ns secretgen-controller
    kubectl apply -f https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/latest/download/release.yml
    ```

### <a id='tanzucli'></a> Install the Tanzu CLI plugins for Tanzu Application Platform

Follow the **[Instructions for Updating Tanzu CLI](install-general.html#udpate-tkg-tce-tanzu-cli)** previously installed for Tanzu Kubernetes Grid and Tanzu Community Edition.

After you've completed the update, you can proceed to the "Install Tanzu Application Platform" section below.


## <a id='install-tap'></a>Install Tanzu Application Platform

1. Ensure you meet all the prerequisites to install Tanzu Application Platform.
See [Prerequisites](install-general.html#prereqs) in _Installing part I: Prerequisites, EULA, and CLI_.

    > **Note:** Do not attempt to install the cert-manager package from Tanzu Standard Repository.
    Follow the instructions in the Tanzu Application Platform documentation to meet all the prerequisites.

1. Follow the steps in [Installing part II: Profiles](install.md) to install
Tanzu Application Platform on a Tanzu Community Edition v0.9.1 cluster.
