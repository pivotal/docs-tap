#Tools and CLI requirements

Installation requires:

* The Kubernetes CLI, kubectl, v1.20, v1.21 or v1.22, installed and authenticated with administrator rights for your target cluster. See [Install Tools](https://kubernetes.io/docs/tasks/tools/) in the Kubernetes documentation.

* To set the Kubernetes cluster context:

    1. List the existing contexts by running:

        ```
        kubectl config get-contexts
        ```

        For example:

        ```
        $ kubectl config get-contexts
        CURRENT   NAME                                CLUSTER           AUTHINFO                                NAMESPACE
                aks-repo-trial                      aks-repo-trial    clusterUser_aks-rg-01_aks-repo-trial
        *       aks-tap-cluster                     aks-tap-cluster   clusterUser_aks-rg-01_aks-tap-cluster

        ```

    2.  Set the context to the cluster that you want to use for the Tanzu Application Platform packages install.
        For example, set the context to the `aks-tap-cluster` context by running:

        ```
        kubectl config use-context aks-tap-cluster
        ```

        For example:

        ```
        $ kubectl config use-context aks-tap-cluster
        Switched to context "aks-tap-cluster".
        ```
