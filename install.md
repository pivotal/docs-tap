  
 Demote headings (H1 → H2, etc.)
 HTML headings/IDs
 Wrap HTML
 Render HTML tags
 Suppress top comment
Help, Docs, Bugs
<!-- Output copied to clipboard! -->

<!-----
NEW: Check the "Suppress top comment" option to remove this info from the output.

Conversion time: 1.388 seconds.


Using this Markdown file:

1. Paste this output into your source file.
2. See the notes and action items below regarding this conversion run.
3. Check the rendered output (headings, lists, code blocks, tables) for proper
   formatting and use a linkchecker before you publish this page.

Conversion notes:

* Docs to Markdown version 1.0β30
* Tue Aug 24 2021 15:33:04 GMT-0700 (PDT)
* Source doc: Install Packages using TAP repo bundle
* Tables are currently converted to HTML tables.
* This document has images: check for >>>>>  gd2md-html alert:  inline image link in generated source and store images to your server. NOTE: Images in exported zip file from Google Docs may not appear in  the same order as they do in your doc. Please check the images!

----->


<p style="color: red; font-weight: bold">>>>>>  gd2md-html alert:  ERRORs: 0; WARNINGs: 0; ALERTS: 1.</p>
<ul style="color: red; font-weight: bold"><li>See top comment block for details on ERRORs and WARNINGs. <li>In the converted Markdown or HTML, search for inline alerts that start with >>>>>  gd2md-html alert:  for specific instances that need correction.</ul>

<p style="color: red; font-weight: bold">Links to alert messages:</p><a href="#gdcalert1">alert1</a>

<p style="color: red; font-weight: bold">>>>>> PLEASE check and correct alert issues and delete this message and the inline alerts.<hr></p>



[TOC]



# Install Packages using TAP repo bundle {#install-packages-using-tap-repo-bundle}

This document describes how to install Tanzu Application Platform packages from the TAP package repository


## Prerequisites {#prerequisites}



* The following [Carvel](https://carvel.dev/#whole-suite) tools are required to install packages using TAP repo bundle.
    * **kapp** version [v0.37.0](https://github.com/vmware-tanzu/carvel-kapp/releases/tag/v0.37.0) or later
    * **ytt** version [v0.34.0](https://github.com/vmware-tanzu/carvel-ytt/releases) or later
    * **imgpkg** version [v0.14.0](https://github.com/vmware-tanzu/carvel-imgpkg/releases) or later
    * **kbld** version [v0.30.0](https://github.com/vmware-tanzu/carvel-kbld/releases) or later
    * **kapp-controller** version v0.20.00.20 or later
* The kubectl CLI should be installed and authenticated with administrator rights for your target cluster.
* The Kubernetes and kubectl version should be v1.17 or later
* Tanzu Cli should be installed and package plugin enabled.


## Kubernetes Cluster {#kubernetes-cluster}

Run the following commands to set and verify the cluster configuration:


```

kubectl config get-contexts
CURRENT   NAME                                CLUSTER           AUTHINFO                                NAMESPACE
          aks-repo-trial                      aks-repo-trial    clusterUser_aks-rg-01_aks-repo-trial
*         aks-tap-cluster                     aks-tap-cluster   clusterUser_aks-rg-01_aks-tap-cluster
          tkg-mgmt-vc-admin@tkg-mgmt-vc       tkg-mgmt-vc       tkg-mgmt-vc-admin
          tkg-vc-antrea-admin@tkg-vc-antrea   tkg-vc-antrea     tkg-vc-antrea-admin

kubectl config use-context aks-tap-cluster
Switched to context "aks-tap-cluster".

kubectl config current-context
aks-tap-cluster

kubectl cluster-info
Kubernetes control plane is running at https://aks-tap-cluster-dns-eec0876a.hcp.eastus.azmk8s.io:443
healthmodel-replicaset-service is running at https://aks-tap-cluster-dns-eec0876a.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/healthmodel-replicaset-service/proxy
CoreDNS is running at https://aks-tap-cluster-dns-eec0876a.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
Metrics-server is running at https://aks-tap-cluster-dns-eec0876a.hcp.eastus.azmk8s.io:443/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

```


If the kapp-controller is not installed in the cluster already, install it using the following commands.


```
kapp deploy -a kc -f \ https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml
```



## Available Packages in Beta-1



* Tanzu Build Services 
* Cloud Native Runtimes
* Application Accelerator for VMware Tanzu
* App live view for VMware Tanzu

Tanzu Build Services v1.2.2 can be installed directly from Tanzunet. Please refer to the [Tanzu Build Services documentation](https://docs.pivotal.io/build-service/1-2/index.html) for the installation procedure.

Cloud Native Runtimes, Application Accelerator for VMware Tanzu and App live view for VMware Tanzu are available as a package in TAP Repo Bundle. The instructions to add the TAP packageRepository and install packages from the repository are explained in below sections.


## Accepting EULA

End User Licence Agreement has to be accepted for all the components separately in order to install packages. Make sure EULA is accepted on the Tanzunet for the following components on the corresponding product pages.



1. Tanzu Application Platform
2. Tanzu Build Services
3. Cloud Native Runtimes
4. Application Accelerator for VMware Tanzu
5. App live view for VMware Tanzu



<p id="gdcalert1" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline image link here (to images/image1.png). Store image on your image server and adjust path/filename/extension if necessary. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert2">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>


![alt_text](images/image1.png "image_tooltip")



## Adding PackageRepositories {#adding-packagerepositories}


#### Creating a namespace and secret. Used for package deployment (all the components). It is to keep the objects logically grouped together. This is a common process; TKG also uses this process. 


#### Create a namespace and secret for PackageRepository Pull {#create-a-namespace-and-secret-for-packagerepository-pull}

Create a namespace and install the PackageRepository.


```
kubectl create ns tap-install
​​kubectl create secret docker-registry tap-registry \ 
-n tap-install \
--docker-server='registry.pivotal.io' \
--docker-username=<tanzunet_username> \   --docker-password=<tanzunet_password>
```


**_Note: The secret tap-registry is special since it was hard coded into the Package CR fetch section. The secret name has to be the same._**


#### Create a PackageRepository CR {#create-a-packagerepository-cr}

Download the sample PackageRepository CR from tanzunet under Tanzu Application Platform.` Alternatively, `create a PackageRepository CR named tap-package-repo.yml and populate it with TAP repo bundle location and registry Secret as below


```
apiVersion: packaging.carvel.dev/v1alpha1
kind: PackageRepository
metadata:
  name: tanzu-tap-repository
spec:
  fetch:
    imgpkgBundle:
      image: registry.pivotal.io/tanzu-application-platform/tap-packages:0.1.0 #image location
      secretRef:
        name: tap-registry
```



#### Add PackageRepository to the cluster  {#add-packagerepository-to-the-cluster}

Apply the PackageRepository yaml from above to add the PackageRepository to the cluster using the following commands


```
kapp deploy -a tap-package-repo -n tap-install -f ./tap-package-repo.yml -y
```


Get Package repository status by running command,


```
tanzu package repository list -n tap-install
- Retrieving repositories... 
  NAME                  REPOSITORY                                                         STATUS               DETAILS  
  tanzu-tap-repository  registry.pivotal.io/tanzu-application-platform/tap-packages:0.1.0  Reconcile succeeded
```


Get available packages by running command


```
tanzu package available list -n tap-install
/ Retrieving available packages...
  NAME                          DISPLAY-NAME                              SHORT-DESCRIPTION
accelerator.apps.tanzu.vmware.com  Application Accelerator for VMware Tanzu  Used to create new projects and configurations.                                      
  appliveview.tanzu.vmware.com       Application Live View for VMware Tanzu    App for monitoring and troubleshooting running apps                                  
  cnrs.tanzu.vmware.com              Cloud Native Runtimes                     Cloud Native Runtimes is a serverless runtime based on Knative 


```


Get packages version details by running command,


```
tanzu package available list cnrs.tanzu.vmware.com -n tap-install
- Retrieving package versions for cnrs.tanzu.vmware.com...
  NAME                   VERSION  RELEASED-AT
  cnrs.tanzu.vmware.com  1.0.1    2021-07-30T15:18:46Z
```



## Installing packages {#installing-packages}

To install any package from the PackageRepository, the parameters that are required for the installation need to be defined in a YAML file. 

The required parameters for the individual packages can be identified by the values schema that are defined in the package and the same can be gathered by running a command.

 `tanzu package available get &lt;package-name>/&lt;version> --values-schema`

The installation of the package is explained in the following examples.


#### Install Cloud Native Runtimes {#install-cloud-native-runtimes}

Follow the instructions under the [Installing Packages](#installing-packages) section and gather the values schema and populate the values.yaml.


```
tanzu package available get cnrs.tanzu.vmware.com/1.0.1 --values-schema -n tap-install
| Retrieving package details for cnrs.tanzu.vmware.com/1.0.1...
  KEY                         DEFAULT  TYPE             DESCRIPTION
  registry.server             <nil>    registry server  <nil>
  registry.username           <nil>    string           registry username
  ingress.external.namespace  <nil>    string           external namespace
  ingress.internal.namespace  <nil>    string           internal namespace
  ingress.reuse_crds          false    string           set true to reuse existing Contour instance
  local_dns                   <nil>    string           <nil>
  provider                    <nil>    string           Kubernetes cluster provider
  registry.password           <nil>    string           registry password
```


Sample values.yaml for Cloud Native Runtimes


```
---
registry:
 server: registry.pivotal.io
 username: <tanzunet_username>
 password: <tanzunet_password>

provider:
pdb:
 enable: true

ingress:
 reuse_crds:
 external:
   namespace:
 internal:
   namespace:

Local_dns:
```


In TKG environments, the contour addons might already be present and it will conflict with the Cloud Native Runtimes installation. Refer to the Cloud Native Runtimes [documentation](https://docs-staging.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-contour.html) and provide values for **ingress.reuse_crds, ingress.external.namespace, ingress.internal.namespace** accordingly.

Also refer to the Cloud Native Runtimes [documentation](https://docs-staging.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-install.html) and provide a provider based on Infrastructure provider. \
Example: For vSphere provider=tkgs for Local kubernetes cluster provider=local, for rest it is not needed.

Install the package by running the command,


```
root@tkg-cli-client:~# tanzu package install cloud-native-runtimes -p cnrs.tanzu.vmware.com -v 1.0.1 -n tap-install -f values.yml
- Installing package 'cnrs.tanzu.vmware.com'
| Getting package metadata for 'cnrs.tanzu.vmware.com'
| Creating service account 'cloud-native-runtimes-tap-install-sa'
| Creating cluster admin role 'cloud-native-runtimes-tap-install-cluster-role'
| Creating cluster role binding 'cloud-native-runtimes-tap-install-cluster-rolebinding'
- Creating package resource
- Package install status: Reconciling


 Added installed package 'cloud-native-runtimes' in namespace 'tap-install'
```



#### Install App Accelerator {#install-app-accelerator}

Installing App Accelerator requires Flux to be pre-installed in the cluster. Details can be found in [App Accelerator documentation](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/0.1/acc-docs/GUID-installation-install.html)

Follow the instructions under [Installing Packages](#installing-packages) section and gather the values schema for Application accelerator and populate the values.yaml.

Sample values YAML for App Accelerator


```
registry:
  server: "registry.pivotal.io"
  username: "<tanzunet_username>"
  password: "<tanzunet_password>"
server:
  service_type: "LoadBalancer"
  watched_namespace: "default"
  engine_invocation_url: "http://acc-engine.accelerator-system.svc.cluster.local/invocations"
engine:
  service_type: "ClusterIP"

```


Install the package by running the command,


```
 tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v 0.2.0 -n tap-install -f values.yml
- Installing package 'accelerator.apps.tanzu.vmware.com'
| Getting package metadata for 'accelerator.apps.tanzu.vmware.com'
| Creating service account 'app-accelerator-tap-install-sa'
| Creating cluster admin role 'app-accelerator-tap-install-cluster-role'
| Creating cluster role binding 'app-accelerator-tap-install-cluster-rolebinding'
| Creating secret 'app-accelerator-tap-install-values'
- Creating package resource
- Package install status: Reconciling

 Added installed package 'app-accelerator' in namespace 'tap-install'
```



#### Install App Live View {#install-app-live-view}

Follow the instructions under the [Installing Packages](#installing-packages) section and gather the values schema and populate the values.yaml.

Sample Values.yml 


```
---
registry:
  server: registry.pivotal.io
  username: <tanzunet_username>
  password: <tanzunet_password>
```


Install the package using the command


```
tanzu package install app-live-view -p appliveview.tanzu.vmware.com -v 0.1.0 -n tap-install -f values.yml
- Installing package 'appliveview.tanzu.vmware.com'
| Getting package metadata for 'appliveview.tanzu.vmware.com'
| Creating service account 'app-live-view-tap-install-sa'
| Creating cluster admin role 'app-live-view-tap-install-cluster-role'
| Creating cluster role binding 'app-live-view-tap-install-cluster-role binding'
| Creating secret 'app-live-view-tap-install-values'
- Creating package resource
- Package install status: Reconciling

 Added installed package 'app-live-view' in namespace 'tap-install'
```



## Verifying Installed Packages {#verifying-installed-packages}

The packages installed can be verified using the command

<code>tanzu package <strong>installed l</strong>ist</code> 


```
tanzu package installed list -n tap-install
\ Retrieving installed packages...
  NAME                   PACKAGE-NAME                       PACKAGE-VERSION  STATUS
  app-accelerator        accelerator.apps.tanzu.vmware.com  0.2.0            Reconcile succeeded
  app-live-view         appliveview.tanzu.vmware.com       0.1.0            Reconcile succeeded
  cloud-native-runtimes  cnrs.tanzu.vmware.com              1.0.1            Reconcile succeeded
```



## Deleting Packages {#deleting-packages}

The installed packages can be removed by running the command


```
tanzu package installed delete <installed-package-name>
```



```
tanzu package installed delete cloud-native-runtimes -n tap-install
| Uninstalling package 'cloud-native-runtimes' from namespace 'tap-install'
/ Getting package install for 'cloud-native-runtimes'
\ Deleting package install 'cloud-native-runtimes' from namespace 'tap-install'
\ Package uninstall status: Reconciling
/ Package uninstall status: Deleting
| Deleting admin role 'cloud-native-runtimes-tap-install-cluster-role'
| Deleting role binding 'cloud-native-runtimes-tap-install-cluster-rolebinding'
| Deleting secret 'cloud-native-runtimes-tap-install-values'
/ Deleting service account 'cloud-native-runtimes-tap-install-sa'

 Uninstalled package 'cloud-native-runtimes' from namespace 'tap-install'
```



## Deleting PackageRepository

Retrieve the packagerepository name by running the command \
 \



```
tanzu package repository list -n tap-install
/ Retrieving repositories... 
  NAME                                           REPOSITORY                                                         STATUS               DETAILS  
  tanzu-application-platform-package-repository  registry.pivotal.io/tanzu-application-platform/tap-packages:0.1.0  Reconcile succeeded 
```


The packageRepository can be removed by running the command \



```
tanzu package repository delete <packagerepository-name>
```



```
tanzu package repository delete tanzu-application-platform-package-repository -n tap-install
- Deleting package repository 'tanzu-application-platform-package-repository'... 
 Deleted package repository 'tanzu-application-platform-package-repository' in namespace 'tap-install'
```



