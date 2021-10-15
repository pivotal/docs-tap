# <a id='installing-tkg'></a> Installing with Tanzu Kubernetes Grid v1.4

This topic provides prerequisities and installation instructions for installing Tanzu Application Platform on a Tanzu Kubernetes Grid v1.4 cluster.

**Warning**: VMware does not recommend installing Tanzu Application Platform on a Tanzu Kubernetes Grid v1.4 cluster in production environments. This procedure includes a workaround for installing kapp-controller v0.27.0 on Tanzu Kubernetes Grid v1.4, which is not a supported workflow. VMware recommends that you follow this procedure for beta purposes only. 

+ [Prerequisites](#prereqs)

## <a id='prereqs'></a>Prerequisites

Before you install Tanzu Application Platform on a Tanzu Kubernetes Grid v1.4 cluster, you must do the following:
- Create a new workload cluster. Do not install any packages in the cluster.

- To Install kapp-controller v0.27.0 or later on TKG v1.4:
	1. Ensure the kubectl context is set to TKGm's Management cluster
	```
	kubectl config get-contexts
	CURRENT   NAME                          CLUSTER            AUTHINFO           NAMESPACE
		  kind-dev-cluster              kind-dev-cluster   kind-dev-cluster
	*         tkg4tap-admin@tkg4tap         tkg4tap            tkg4tap-admin
		  tkg4tapwld-admin@tkg4tapwld   tkg4tapwld         tkg4tapwld-admin
	```
	2. Stop Management Cluster from reconciling the kapp-controller in the workload cluster by executing the following command.
	```
	kubectl patch app/<WORKLOAD-CLUSTER>-kapp-controller -n default -p '{"spec":{"paused":true}}' --type=merge
	```
	where `WORKLOAD-CLUSTER` is the name of the cluster created in previous step.
	3. Import the kubeconfig for the workload cluster.
	```
	tanzu cluster kubeconfig get <WORKLOAD-CLUSTER> --admin
	```
	where `WORKLOAD-CLUSTER` is the name of the cluster created in step-1
	4.  Switch the kubectl context to the workload cluster
	```
	kubectl config use-context <WORKLOAD-CLUSTER-CONTEXT>
	```
	where `WORKLOAD-CLUSTER-CONTEXT` is the kubeconfig context imported in the previous step
- Install the tanzu cli plugins required for TAP
	1. Create a directory named `tanzu-framework`.
	   ```
	   mkdir $HOME/tanzu-framework
	   ```
	2. Sign in to [Tanzu Network](https://network.tanzu.vmware.com).

	3. Navigate to [Tanzu Application Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform/) on Tanzu Network.

	4. Click on the `tanzu-cli-0.5.0` folder.

	5. Download the cli bundle for corresponding to your operating system and unpack the TAR file into the `tanzu-framework` directory.
	   For example, if your client operating system is `Linux`, download `tanzu-framework-linux-amd64.tar` bundle.
	   ```
	   tar -xvf tanzu-framework-linux-amd64.tar -C $HOME/tanzu-framework
	   ```
	6. Navigate to the `tanzu-framework` directory.
	   ```
	   cd $HOME/tanzu-framework
	   ```
	8. Install the Imagepullsecret plugin
	   ```
	   tanzu plugin install imagepullsecret --local ./cli
	   ```
	9. Install the accelerator plugin
	   ```
	   tanzu plugin install accelerator --local ./cli
	   ```
	10. Install the apps plugin
	    ```
	    tanzu plugin install imagepullsecret --local ./cli
	   ```

-  Ensure you meet all the Prerequisites for Tanzu Application Platform installation. See [Prerequisites](install-general.html#prerequisites-0) in _Installing Part I: Prerequisites, EULA, and CLI_.
[NOTE: Do not attempt to install cert manager package from Tanzu Standard Repository as part of prerequisite. Follow the instructions in TAP doc for installing all prerequisites]
## <a id='install'></a> Install Tanzu Application Platform with Tanzu Kubernetes Grid v1.4

Proceed to [install Tanzu Application Platform packages](install.md) on a Tanzu Kubernetes Grid v1.4 cluster.
