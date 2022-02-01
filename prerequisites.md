
# Prerequisites

The following are required to install Tanzu Application Platform:

### <a id='tn-and-cont-img-reg-reqs'></a>Tanzu Network and container image registry requirements

Installation requires:

* A [Tanzu Network](https://network.tanzu.vmware.com/) account to download
Tanzu Application Platform packages.

* A container image registry, such as [Harbor](https://goharbor.io/) or
[Docker Hub](https://hub.docker.com/) for application images, base images, and runtime dependencies.
When available, VMware recommends using a paid registry account to avoid potential rate-limiting
associated with some free registry offerings.
    * If installing using the `lite` descriptor for Tanzu Build Service, 1&nbsp;GB of available
    storage is recommended.
    * If installing using the `full` descriptor for Tanzu Build Service, which is intended for production use
    and offline environments, 10&nbsp;GB of available storage is recommended.

* Registry credentials with push and write access made available to Tanzu Application Platform to
store images.

* Network access to https://registry.tanzu.vmware.com

* Network access to your chosen container image registry.

* Latest version of Chrome, Firefox, or Edge.
Tanzu Application Platform GUI currently does not support Safari browser.

#### <a id='dns-records'></a>DNS Records

There are some optional but recommended DNS records you should allocate if you decide to use these particular components:

- Cloud Native Runtimes (knative) - Allocate a wildcard subdomain for your developer's applications. This is specified in the `cnrs.domain_name` key of the `tap-values.yml` configuration file that you input with the installation. This wildcard should be pointed at the external IP address of the `tanzu-system-ingress`'s `envoy` service.
- Tanzu Learning Center - Similar to Cloud Native Runtimes, allocate a wildcard subdomain for your workshops and content. This is specified in the `learningcenter.ingressDomain` key of the `tap-values.yml` configuration file that you input with the installation. This wildcard should be pointed at the external IP address of the `tanzu-system-ingress`'s `envoy` service.
- Tanzu Application Platform GUI - Should you decide to implement the shared ingress and include the Tanzu Application Platform GUI, allocate a fully Qualified Domain Name (FQDN) that can be pointed at the `tanzu-system-ingress` service.
The default hostname consists of `tap-gui` plus an `IngressDomain` of your choice. For example,
`tap-gui.example.com`.


#### <a id='tap-gui'></a>Tanzu Application Platform GUI

- Git repository for the Tanzu Application Platform GUI's software catalogs, along with a token allowing read access.
  Supported Git infrastructure includes:
    - GitHub
    - GitLab
    - Azure DevOps
- Tanzu Application Platform GUI Blank Catalog from the Tanzu Application section of Tanzu Network
  - To install, navigate to [Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform/). Under the list of available files to download, there is a folder titled `tap-gui-catalogs-latest`. Inside that folder is a compressed archive titled `Tanzu Application Platform GUI Blank Catalog`. You must extract that catalog to the preceding Git repository of choice. This serves as the configuration location for your Organization's Catalog inside Tanzu Application Platform GUI.
- The Tanzu Application Platform GUI catalog allows for two approaches towards storing catalog information:
    - The default option uses an in-memory database and is suitable for test and development scenarios.
          This reads the catalog data from Git URLs that you specify in the `tap-values.yml` file.
          This data is temporary, and any operations that cause the `server` pod in the `tap-gui` namespace to be re-created
          also cause this data to be rebuilt from the Git location.
          This can cause issues when you manually register entities through the UI because
          they only exist in the database and are lost when that in-memory database gets rebuilt.
    - For production use-cases, use a PostgreSQL database that exists outside the
          Tanzu Application Platform packaging.
          The PostgreSQL database stores all the catalog data persistently both from the Git locations
          and the UI manual entity registrations. For more information, see
          [Configuring the Tanzu Application Platform GUI database](tap-gui/database.md)


### <a id='k8s-cluster-reqs'></a>Kubernetes cluster requirements

Installation requires:

* Kubernetes cluster versions 1.20, 1.21, or 1.22 on one of the following Kubernetes providers:

    * Azure Kubernetes Service
    * Amazon Elastic Kubernetes Service
    * Google Kubernetes Engine
        * GKE Autopilot clusters do not have required features enabled
    * Minikube
        * Reference the resource requirements below
        * Hyperkit driver is supported on macOS only; Docker driver is not supported.

### <a id="resource-requirements"></a>Resource requirements

* To deploy all Tanzu Application Platform packages, your cluster must have at least:
    * 8 GB of RAM across all nodes available to Tanzu Application Platform
    * 8 CPUs for i9 (or equivalent) available to Tanzu Application Platform components
    * 12 CPUs for i7 (or equivalent) available to Tanzu Application Platform components
    * 12 GB of RAM is available to build and deploy applications, including Minikube. VMware recommends 16 GB of RAM for an optimal experience.
    * 70 GB of disk space available per node

* For the [`full` profile](install.html#full-profile), or
    use of Security Chain Security Tools - Store, your cluster must have a configured default StorageClass.

* [Pod Security Policies](https://kubernetes.io/docs/concepts/policy/pod-security-policy/)
must be configured so that Tanzu Application Platform controller pods can run as root.

### <a id='tools-and-cli-reqs'></a>Tools and CLI requirements

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
