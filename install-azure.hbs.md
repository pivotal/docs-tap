Prerequisites:

The following are required to install Tanzu Application Platform on Azure:

VMware Tanzu Network and container image registry requirements

Installation requires:

- Access to VMware Tanzu Network:
	- A Tanzu Network account to download Tanzu Application Platform packages.
	- Network access to https://registry.tanzu.vmware.com.
- Cluster-specific registry:
	- For production environments, full dependencies are recommended to optimize security and performance. For more information about Tanzu Build Service dependencies, see 	About lite and full dependencies.
- Registry credentials with read and write access available to Tanzu Application Platform to store images.
- Network access to your chosen container image registry.

DNS Records

There are some DNS records created for a few TAP components. 

Kubernetes cluster requirements

Installation requires Kubernetes cluster v1.23, v1.24, v1.25, v1.26 on one of the following Kubernetes providers:

- Azure Kubernetes Service.

Resource requirements

- To deploy Tanzu Application Platform packages full profile, your cluster must have at least:
	- 8 GB of RAM available per node to Tanzu Application Platform.
	- 16 vCPUs available across all nodes to Tanzu Application Platform.
	- 100 GB of disk space available per node.
- To deploy Tanzu Application Platform packages build, run and iterate (shared) profile, your cluster must have at least:
	- 8 GB of RAM available per node to Tanzu Application Platform.
	- 12 vCPUs available across all nodes to Tanzu Application Platform.
	- 100 GB of disk space available per node.
	
Tools and CLI requirements

Installation requires:

- The Kubernetes CLI (kubectl) v1.23, v1.24, v1.25, v1.26 installed and authenticated with admin rights for your target cluster. See Install Tools in the Kubernetes documentation.

Accepting Tanzu Application Platform EULAs and installing Tanzu CLI

Selected product version:VMware Tanzu Application Platform 1.3 

This topic describes how to:

- Accept Tanzu Application Platform EULAs
- Set the Kubernetes cluster context
- Install or update the Tanzu CLI and plug-ins

Accept the End User License Agreements

Before downloading and installing Tanzu Application Platform packages, you must accept the End User License Agreements (EULAs) as follows:

1. Sign in to VMware Tanzu Network.
2. Accept or confirm that you have accepted the EULAs for each of the following:
	- Tanzu Application Platform
	- Cluster Essentials for VMware Tanzu


Example of accepting the Tanzu Application Platform EULA

To accept the Tanzu Application Platform EULA:

1. Go to Tanzu Application Platform.
2. Select the Click here to sign the EULA link in the yellow warning box under the release drop-down menu. If the yellow warning box is not visible, the EULA has already been accepted.

3. Select Agree in the bottom-right of the dialog box as seen in the following screenshot.

Install and Configure Azure CLI

Please refer to the Microsoft provided documentation in below link how to install and configure Azure CLI - documentation


Login to Azure

	az login
	az account set --subscription <<name of the subscription>>
	
Create Azure Resource Group
	
Create a resource group with the az group create command. 

	az group create --name myTAPResourceGroup --location eastus
	
Create an AKS Cluster
	
To create an AKS cluster using the az aks create command with the --enable-addons monitoring and --enable-msi-auth-for-monitoring parameter to enable Azure Monitor Container insights with managed identity authentication (preview). The following example creates a cluster named tap-on-azure with one node and enables a system-assigned managed identity:
	
Azure CLI 
	
	az aks create -g myTAPResourceGroup -n tap-on-azure --enable-managed-identity --node-count 6 --enable-addons monitoring --enable-msi-auth-for-monitoring --generate-ssh-	keys --node-vm-size Standard_D4ds_v4 --kubernetes-version 1.23.12
	
After a few minutes, the command completes and returns JSON-formatted information about the cluster.
	
Note
	
When you create an AKS cluster, a second resource group is automatically created to store the AKS resources. For more information, see Why are two resource groups created with AKS?
	
Connect to the cluster
	
To manage a Kubernetes cluster, use the Kubernetes command-line client, kubectl. kubectl is already installed if you use Azure Cloud Shell.
1. Install kubectl locally using the az aks install-cli command:

 AKS CLI 
 
	az aks install-cli
	
2. Configure kubectl to connect to your Kubernetes cluster using the az aks get-credentials command. The following command:
	
	- Downloads credentials and configures the Kubernetes CLI to use them.
	- Uses ~/.kube/config, the default location for the Kubernetes configuration file. Specify a different location for your Kubernetes configuration file using --file 	argument.
	
      Azure CLI 	
      
      		az aks get-credentials --resource-group myTAPResourceGroup --name tap-on-azure
      

Set the Kubernetes cluster context
	
To set the Kubernetes cluster context:
	
1. List the existing contexts by running:
	kubectl config get-contexts


For example:

	$ kubectl config get-contexts
	CURRENT   NAME                                CLUSTER           AUTHINFO                                NAMESPACE
	aks-repo-trial                      	   aks-repo-trial    	clusterUser_aks-rg-01_aks-repo-trial
    aks-tap-cluster                     	   aks-tap-cluster   	clusterUser_aks-rg-01_aks-tap-cluster

2. Set the context to the cluster that you want to use for the Tanzu Application Platform packages installation by running:
kubectl config use-context CONTEXT

Where CONTEXT is the cluster that you want to use. For example, aks-tap-cluster.
For example:

	$ kubectl config use-context aks-tap-cluster
	Switched to context "aks-tap-cluster".

Deploying Cluster Essentials

Please refer to the Tanzu Application Platform documentation for more information.

Creating Azure Resources for Tanzu Application Platform

To install Tanzu Application Platform within Azure Ecosystem, you must create several Azure resources. This guide walks you through creating:
- An Azure Kubernetes Service (AKS) cluster to install Tanzu Application Platform.
- Identity and Access Management (IAM) roles to allow authentication and authorization to read and write from Azure Container Registry (ACR).
- ACR Repositories for the Tanzu Application Platform container images.

Creating these resources enables Tanzu Application Platform to use an IAM role bound to a Kubernetes service account for authentication, rather than the typical username and password stored in a Kubernetes secret strategy. For more information, see this Azure documentation.

This is important when using ACR because authenticating to ACR is a two-step process:
1. Retrieve a token using your Azure credentials.
2. Use the token to authenticate to the registry.

To increase security, the token has a lifetime of 12 hours. This makes storing it as a secret for a service impractical because it has to be refreshed every 12 hours.

Using an IAM role on a service account mitigates the need to retrieve the token at all because it is handled by credential helpers within the services.

Prerequisites

Before installing Tanzu Application Platform on Azure, you need:
- An Azure Subscription. You need to create all of your resources within an Azure subscription, create an Azure free account before you begin.
- Azure CLI. This walkthrough uses the Azure CLI to both query and configure resources in Azure, such as IAM roles. For more information, see this Azure CLI documentation. 
- If you prefer to run CLI reference commands locally, install the Azure CLI.

Installing Tanzu Application Platform package and profiles on Azure

This topic describes how to install Tanzu Application Platform packages from the Tanzu Application Platform package repository on to Azure.
Before installing the packages, ensure you have:

- Completed the Prerequisites
- Created Azure Resources
- Accepted Tanzu Application Platform EULA and installed Tanzu CLI with any required plug-ins.
- Installed Cluster Essentials for Tanzu

Create a namespace called tap-install for deploying any component packages by running:
	kubectl create ns tap-install
This namespace keeps the objects grouped together logically.

Export the tanzunet registry by running:

	export INSTALL_REPO=tanzu-application-platform/tap-packages
	
Create registry secret for tanzunet:

	tanzu secret registry add tap-registry \
	--username ${INSTALL_REGISTRY_USERNAME} --password ${INSTALL_REGISTRY_PASSWORD} \
	--server ${INSTALL_REGISTRY_HOSTNAME} \
	--export-to-all-namespaces --yes --namespace tap-install
	tanzu secret registry list --namespace tap-install
	
Add the Tanzu Application Platform package repository to the cluster by running:

	tanzu package repository add tanzu-tap-repository \
  	--url ${INSTALL_REGISTRY_HOSTNAME}/${INSTALL_REPO}:$TAP_VERSION \
 	--namespace tap-install

Get the status of the Tanzu Application Platform package repository, and ensure the status updates to Reconcile succeeded by running:
	tanzu package repository get tanzu-tap-repository --namespace tap-install

For example:
	$ tanzu package repository get tanzu-tap-repository --namespace tap-install
	- Retrieving repository tap...
	NAME:          tanzu-tap-repository
	VERSION:       16253001
	REPOSITORY:    123456789012.dkr.acr.us-east.azure.com/tap-images
	TAG:           1.3.0
	STATUS:        Reconcile succeeded
	REASON:

Note: The VERSION and TAG numbers differ from the earlier example if you are on Tanzu Application Platform v1.0.2 or earlier.
List the available packages by running:
	tanzu package available list --namespace tap-install


For example:

	$ tanzu package available list --namespace tap-install
	/ Retrieving available packages...
  	NAME                                                 DISPLAY-NAME                                                              SHORT-DESCRIPTION
  	accelerator.apps.tanzu.vmware.com                    Application Accelerator for VMware Tanzu                                  Used to create new projects and 		configurations.
  	apis.apps.tanzu.vmware.com                           API Auto Registration for VMware Tanzu                                    A TAP component to automatically register 	API exposing workloads as API entities in TAP GUI.
  	api-portal.tanzu.vmware.com                          API portal                                                                A unified user interface to enable search, 	discovery and try-out of API endpoints at ease.
  	backend.appliveview.tanzu.vmware.com                 Application Live View for VMware Tanzu                                    App for monitoring and troubleshooting running apps
  	connector.appliveview.tanzu.vmware.com               Application Live View Connector for VMware Tanzu                          App for discovering and registering running apps
  	conventions.appliveview.tanzu.vmware.com             Application Live View Conventions for VMware Tanzu                        Application Live View convention server
  	buildservice.tanzu.vmware.com                        Tanzu Build Service                                                       Tanzu Build Service enables the building and automation of containerized software workflows securely and at scale.
  	cartographer.tanzu.vmware.com                        Cartographer                                                              Kubernetes native Supply Chain Choreographer.
  	cnrs.tanzu.vmware.com                                Cloud Native Runtimes                                                     Cloud Native Runtimes is a serverless runtime based on Knative
 	 controller.conventions.apps.tanzu.vmware.com         Convention Service for VMware Tanzu                                       Convention Service enables app operators to consistently apply desired runtime configurations to fleets of workloads.
  	controller.source.apps.tanzu.vmware.com              Tanzu Source Controller                                                   Tanzu Source Controller enables workload create/update from source code.
  	developer-conventions.tanzu.vmware.com               Tanzu App Platform Developer Conventions                                  Developer Conventions
  	grype.scanning.apps.tanzu.vmware.com                 Grype Scanner for Supply Chain Security Tools - Scan                      Default scan templates using Anchore Grype
  	image-policy-webhook.signing.apps.tanzu.vmware.com   Image Policy Webhook                                                      The Image Policy Webhook allows platform operators to define a policy that will use cosign to verify signatures of container images
  	learningcenter.tanzu.vmware.com                      Learning Center for Tanzu Application Platform                            Guided technical workshops
  	ootb-supply-chain-basic.tanzu.vmware.com             Tanzu App Platform Out of The Box Supply Chain Basic                      Out of The Box Supply Chain Basic.
  	ootb-supply-chain-testing-scanning.tanzu.vmware.com  Tanzu App Platform Out of The Box Supply Chain with Testing and Scanning  Out of The Box Supply Chain with Testing and Scanning.
  	ootb-supply-chain-testing.tanzu.vmware.com           Tanzu App Platform Out of The Box Supply Chain with Testing               Out of The Box Supply Chain with Testing.
  	ootb-templates.tanzu.vmware.com                      Tanzu App Platform Out of The Box Templates                               Out of The Box Templates.
  	scanning.apps.tanzu.vmware.com                       Supply Chain Security Tools - Scan                                        Scan for vulnerabilities and enforce policies directly within Kubernetes native Supply Chains.
 	metadata-store.apps.tanzu.vmware.com                 Tanzu Supply Chain Security Tools - Store                                 The Metadata Store enables saving and querying image, package, and vulnerability data.
  	service-bindings.labs.vmware.com                     Service Bindings for Kubernetes                                           Service Bindings for Kubernetes implements the Service Binding Specification.
  	services-toolkit.tanzu.vmware.com                    Services Toolkit                                                          The Services Toolkit enables the management, lifecycle, discoverability and connectivity of Service Resources (databases, message queues, DNS records, etc.).
  	spring-boot-conventions.tanzu.vmware.com             Tanzu Spring Boot Conventions Server                                      Default Spring Boot convention server.
  	sso.apps.tanzu.vmware.com                            AppSSO                                                                    Application Single Sign-On for Tanzu
  	tap-gui.tanzu.vmware.com                             Tanzu Application Platform GUI                                            web app graphical user interface for Tanzu Application Platform
  	tap.tanzu.vmware.com                                 Tanzu Application Platform                                                Package to install a set of TAP components to get you started based on your use case.
 	workshops.learningcenter.tanzu.vmware.com            Workshop Building Tutorial                                                Workshop Building Tutorial
	
Install your Tanzu Application Platform profile

The tap.tanzu.vmware.com package installs predefined sets of packages based on your profile settings. This is done by using the package manager installed by Tanzu Cluster Essentials.

Setup Registry Credentials

	export KP_REGISTRY_USERNAME=
	export KP_REGISTRY_PASSWORD=YOUR_PASSWORD
	export KP_REGISTRY_HOSTNAME=

	echo $KP_REGISTRY_USERNAME
	echo $KP_REGISTRY_PASSWORD
	echo $KP_REGISTRY_HOSTNAME

	docker login $KP_REGISTRY_HOSTNAME -u $KP_REGISTRY_USERNAME -p $KP_REGISTRY_PASSWORD

	Create a registry secret & add it to a developer namespace

	export YOUR_NAMESPACE=mydev-ns

	echo $YOUR_NAMESPACE

	kubectl create ns $YOUR_NAMESPACE

	tanzu secret registry add registry-credentials --server $KP_REGISTRY_HOSTNAME --username $KP_REGISTRY_USERNAME --password $KP_REGISTRY_PASSWORD --namespace $YOUR_NAMESPACE

	kubectl get secret registry-credentials  -o jsonpath='{.data.\.dockerconfigjson}'  -n $YOUR_NAMESPACE| base64 --decode

For more information about profiles, see About Tanzu Application Platform components and profiles.

To prepare to install a profile:
	1. List version information for the package by running:
		tanzu package available list tap.tanzu.vmware.com --namespace tap-install
	2. Create a tap-values.yaml file by using the Full Profile (Azure), which contains the minimum configurations required to deploy Tanzu Application Platform on Azure. The 	     sample values file contains the necessary defaults for:
		- The meta-package, or parent Tanzu Application Platform package.
		- Subordinate packages, or individual child packages.
		Important: Keep the values file for future configuration use.
	3. View possible configuration settings for your package
	
Full profile (Azure)

The following command generates the YAML file sample for the full-profile on Azure by using the ACR repositories you created earlier. The profile: field takes full as the default value, but you can also set it to iterate, build, run, or view. Refer to Install multicluster Tanzu Application Platform profiles for more information.

Where:
	- INGRESS-DOMAIN is the subdomain for the host name that you point at the tanzu-shared-ingress services External IP address.
	- GIT-CATALOG-URL is the path to the catalog-info.yaml catalog definition file. You can download either a blank or populated catalog file from the Tanzu Application 		  Platform product page. Otherwise, you can use a Backstage-compliant catalog you have already built and posted on the Git infrastructure.
	- MY-DEV-NAMESPACE is the name of the developer namespace. SCST - Store exports secrets to the namespace, and SCST - Scan deploys the ScanTemplates there. This allows             the scanning feature to run in this namespace. If there are multiple developer namespaces, use ns_for_export_app_cert: "*" to export the SCST - Store CA certificate to           all namespaces.
	- TARGET-REGISTRY-CREDENTIALS-SECRET is the name of the secret that contains the credentials to pull an image from the registry for scanning.
	
For Azure, the default settings creates a classic LoadBalancer. To use the Network LoadBalancer instead of the classic LoadBalancer for ingress, add the following to your tap-values.yaml:

	profile: full

	  ceip_policy_disclosed: true # Installation fails if this is set to 'false'
	  
	buildservice:
  	  kp_default_repository: tapbuildservice.azurecr.io/buildservice
  	  kp_default_repository_username: tapbuildservice
  	  kp_default_repository_password: <pw>
  	  enable_automatic_dependency_updates: false

	supply_chain: testing_scanning

	ootb_templates:
  	 iaas_auth: true

	ootb_supply_chain_testing:
  		registry:
    	        server: tapbuildservice.azurecr.io
    	        repository:tapsupplychain
  	gitops:
    	  ssh_secret: ""

	ootb_supply_chain_testing_scanning:
  	 registry:
    	  server: tapbuildservice.azurecr.io
    	  repository: tapsupplychain
  	gitops:
    	  ssh_secret: ""

        learningcenter:
          ingressDomain: learning-center.tap.com

        ootb_delivery_basic:
          service_account: default

	tap_gui:
  	 ingressEnabled: true
  	 ingressDomain: tap.com
  	 service_type: ClusterIP # NodePort for distributions that don't support LoadBalancer
  	app_config:
    	  supplyChain:
      	    enablePlugin: true
    	  auth:
     	    allowGuestAccess: true
    	  backend:
      	    baseUrl: http://tap-gui.tap.com
      	    cors:
              origin: http://tap-gui.tap.com
   	  app:
      	      baseUrl: http://tap-gui.tap.com

	scanning:
  	 metadataStore:
    	 url: ""

	metadata_store:
  	 ingressEnabled: true
  	 ingressDomain: tap.com
  	 app_service_type: ClusterIP
  	 ns_for_export_app_cert: tap-workload

	contour:
  	 envoy:
    	 service:
      	 type: LoadBalancer

	accelerator:
  	 server:
    	 service_type: "ClusterIP"


	cnrs:
  	  domain_name: tap.com

	grype:
  	  namespace: tap-workload
  	  targetImagePullSecret: registry-credentials
	  
Install your Tanzu Application Platform package

Follow these steps to install the Tanzu Application Platform package:

1. Install the package by running:
	tanzu package install tap -p tap.tanzu.vmware.com -v $TAP_VERSION --values-file tap-values.yaml -n tap-install

2. Verify the package install by running:
	tanzu package installed get tap -n tap-install

This can take 5-10 minutes because it installs several packages on your cluster.

3. Verify that the necessary packages in the profile are installed by running:
	tanzu package installed list -A
	
4. If you configured full dependencies in your tbs-values.yaml file, install the full dependencies by following the procedure in Install full dependencies.
   After installing the Full profile on your cluster, you can install the Tanzu Developer Tools for VS Code Extension to help you develop against it. For instructions, see 	    Installing Tanzu Developer Tools for VS Code.
   
   
Access Tanzu Application Platform GUI

To access Tanzu Application Platform GUI, you can use the host name that you configured earlier. This host name is pointed at the shared ingress. To configure LoadBalancer for Tanzu Application Platform GUI, see Accessing Tanzu Application Platform GUI.

You are now ready to start using Tanzu Application Platform GUI. Proceed to the Getting Started topic or the Tanzu Application Platform GUI - Catalog Operations topic.

Next steps

	- (Optional) Installing Individual Packages
	- Setting up developer namespaces to use installed packages
	
To view possible configuration settings for a package, run:

	tanzu package available get tap.tanzu.vmware.com/$TAP_VERSION --values-schema --namespace tap-install

Note: The tap.tanzu.vmware.com package does not show all configuration settings for packages it plans to install. The package only shows top-level keys. You can view individual package configuration settings with the same tanzu package available get command. For example, use tanzu package available get -n tap-install cnrs.tanzu.vmware.com/$TAP_VERSION --values-schema for Cloud Native Runtimes.
	profile: full
	# ...
	# For example, CNRs specific values go under its name
	cnrs:
  	 provider: local
# For example, App Accelerator specific values go under its name
	accelerator:
  	  server:
    	    service_type: "ClusterIP"
    
The following table summarizes the top-level keys used for package-specific configuration within your tap-values.yaml.

		Package                       Top-level Key
	see table below  			shared
	API Auto Registration 			api_auto_registration
	API portal 				api_portal
	Application Accelerator 		accelerator
	Application Live View			appliveview
	Application Live View Connector 	appliveview_connector
	Application Live View Conventions  	appliveview-conventions
	Cartographer 				cartographer
	Cloud Native Runtimes 			cnrs
	Convention Controller 			convention_controller
	Source Controller 			source_controller
	Supply Chain 				supply_chain
	Supply Chain Basic 			ootb_supply_chain_basic
	Supply Chain Testing 			ootb_supply_chain_testing
	Supply Chain Testing Scanning 		ootb_supply_chain_testing_scanning
	Supply Chain Security Tools - Scan	scanning
	Supply Chain Security Tools - Scan
	(Grype Scanner) 			grype
	Supply Chain Security Tools - Store 	metadata_store
	Image Policy Webhook 			image_policy_webhook
	Build Service 				buildservice
	Tanzu Application Platform GUI 		tap_gui
	Learning Center 			learningcenter

Shared Keys define values that configure multiple packages. These keys are defined under the shared Top-level Key, as summarized in the following table:

	Shared Key 		Used By 					Description

	ca_cert_data 		convention_controller, source_controller 	Optional: PEM Encoded certificate data to trust TLS connections with a private CA.

For information about package-specific configuration, see Installing individual packages.

Set up developer namespaces to use installed packages

You can choose either one of the following two approaches to create a Workload for your application by using the registry credentials specified, add credentials and Role-Based Access Control (RBAC) rules to the namespace that you plan to create the Workload in:

- Enable single user access.
- Enable additional users access with Kubernetes RBAC.

Enable single user access

Follow these steps to enable your current user to submit jobs to the Supply Chain:

  1. Gather the ARN created for workloads in the Create Azure Resources.
  2. Update the YOUR-NAMESPACE and ROLE-ARN and run the following command to add secrets, a service account to execute the supply chain, and RBAC rules to authorize the service      account to the developer namespace.
     	cat <<EOF | kubectl -n YOUR-NAMESPACE apply -f -
     	apiVersion: v1
     	kind: Secret
     	metadata:
	  name: tap-registry
      	annotations:
        secretgen.carvel.dev/image-pull-secret: ""
      	type: kubernetes.io/dockerconfigjson
      	data:
         .dockerconfigjson: e30K

       ---
     apiVersion: v1
     kind: ServiceAccount
     metadata:
      name: default
    secrets:
      - name: registry-credentials
    imagePullSecrets:
      - name: registry-credentials
      - name: tap-registry

   ---
   apiVersion: rbac.authorization.k8s.io/v1
   kind: Role
   metadata:
   name: default
   rules:
   - apiGroups: [source.toolkit.fluxcd.io]
     resources: [gitrepositories]
     verbs: ['*']
   - apiGroups: [source.apps.tanzu.vmware.com]
     resources: [imagerepositories]
     verbs: ['*']
   - apiGroups: [carto.run]
     resources: [deliverables, runnables]
     verbs: ['*']
   - apiGroups: [kpack.io]
     resources: [images]
     verbs: ['*']
   - apiGroups: [conventions.apps.tanzu.vmware.com]
     resources: [podintents]
     verbs: ['*']
   - apiGroups: [""]
     resources: ['configmaps']
     verbs: ['*']
   - apiGroups: [""]
     resources: ['pods']
     verbs: ['list']
   - apiGroups: [tekton.dev]
     resources: [taskruns, pipelineruns]
    verbs: ['*']
  - apiGroups: [tekton.dev]
    resources: [pipelines]
    verbs: ['list']
  - apiGroups: [kappctrl.k14s.io]
    resources: [apps]
    verbs: ['*']
  - apiGroups: [serving.knative.dev]
    resources: ['services']
    verbs: ['*']
  - apiGroups: [servicebinding.io]
   resources: ['servicebindings']
    verbs: ['*']
  - apiGroups: [services.apps.tanzu.vmware.com]
    resources: ['resourceclaims']
    verbs: ['*']
  - apiGroups: [scanning.apps.tanzu.vmware.com]
    resources: ['imagescans', 'sourcescans']
    verbs: ['*']

  ---
  apiVersion: rbac.authorization.k8s.io/v1
  kind: RoleBinding
  metadata:
   name: default
  roleRef:
   apiGroup: rbac.authorization.k8s.io
   kind: Role
   name: default
  subjects:
   - kind: ServiceAccount
     name: default



