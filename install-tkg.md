# Installing on a Tanzu Kubernetes Grid v1.4 Cluster

This topic lists prerequisites and instructions for installing Tanzu Application Platform on a
Tanzu Kubernetes Grid v1.4 cluster.

> **Warning**: VMware discourages installing Tanzu Application Platform on a Tanzu Kubernetes Grid
v1.4 cluster in production environments.
This procedure includes a workaround for installing kapp-controller v0.29.0 on Tanzu Kubernetes Grid
v1.4, which is not a supported workflow. VMware recommends that you follow this procedure for beta
purposes only.
<!-- What is meant by a "supported workflow"? And which isn't the supported workflow,
the workaround or putting kapp-controller v0.29.0 on Tanzu Kubernetes Grid v1.4? -->


## Install Tanzu Kubernetes Grid v1.4

To install Tanzu Kubernetes Grid v1.4, you must:

+ [Install kapp-controller](#kapp-controller)
+ [Install Tanzu CLI Plugins](#tanzucli)


### <a id='kapp-controller'></a> Install kapp-controller

To install kapp-controller v0.29.0 or later on Tanzu Kubernetes Grid v1.4:

1. Create a new workload cluster. Do not install any packages in the cluster.
1. Ensure the kubectl context is set to the Tanzu Kubernetes Grid Management cluster by running:

    ```console
    kubectl config get-contexts
    CURRENT   NAME                          CLUSTER            AUTHINFO           NAMESPACE
        kind-dev-cluster              kind-dev-cluster   kind-dev-cluster
    *         tkg4tap-admin@tkg4tap         tkg4tap            tkg4tap-admin
        tkg4tapwld-admin@tkg4tapwld   tkg4tapwld         tkg4tapwld-admin
    ```

1. Prevent the Management cluster from reconciling the kapp-controller in the workload cluster by running:

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

1. Install kapp-controller v0.29.0 by running:

    ```console
    kubectl apply -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/v0.29.0/release.yml
    ```


### <a id='tanzucli'></a>Install the Tanzu CLI and Plugins for Tanzu Application Platform

Follow the **[instructions for updating Tanzu CLI which was originally installed for TKG/TCE](install-general.html#udpate-tkg-tce-tanzu-cli)**

Once completed, you may proceed to the next section.


## <a id='install-tap'></a>Install Tanzu Application Platform

1. Ensure you meet all the prerequisites to install Tanzu Application Platform.
See [Prerequisites](install-general.html#prerequisites-0) in _Installing Part I: Prerequisites, EULA, and CLI_.

    > **Note**: Do not attempt to install the cert-manager package from Tanzu Standard Repository:
    follow the instructions in TAP documentation to meet all the prerequisites.

1. Follow the steps in [Installing Part II: Profiles](install.md) to install
Tanzu Application Platform on a Tanzu Kubernetes Grid v1.4 cluster.
