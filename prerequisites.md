# Prerequisites

The following are required to install Tanzu Application Platform:

## <a id='tn-and-cont-img-reg-reqs'></a> VMware Tanzu Network and container image registry requirements

Installation requires:

- Access to VMware Tanzu Network:

  - A [Tanzu Network](https://network.tanzu.vmware.com/) account to download
Tanzu Application Platform packages.
  - Network access to https://registry.tanzu.vmware.com.

- Cluster-specific registry:

  - A container image registry, such as [Harbor](https://goharbor.io/) or
[Docker Hub](https://hub.docker.com/) for application images, base images, and runtime dependencies.
When available, VMware recommends using a paid registry account to avoid potential rate-limiting
associated with some free registry offerings.

    - If installing using the `lite` descriptor for Tanzu Build Service, 1&nbsp;GB of available
    storage is recommended.
    - If installing using the `full` descriptor for Tanzu Build Service, which is intended for production use
    and offline environments, 10&nbsp;GB of available storage is recommended.

- Registry credentials with read and write access made available to
Tanzu Application Platform to store images.

- Network access to your chosen container image registry.


### <a id='dns-records'></a>DNS Records

There are some optional but recommended DNS records you should allocate if you decide to use these particular components:

- Cloud Native Runtimes (knative) - Allocate a wildcard subdomain for your developer's applications. This is specified in the `cnrs.domain_name` key of the `tap-values.yml` configuration file that you input with the installation. This wildcard should be pointed at the external IP address of the `tanzu-system-ingress`'s `envoy` service. See [Ingress Method](tap-gui/accessing-tap-gui.md#ingress-method) for more information about `tanzu-system-ingress`.
- Tanzu Learning Center - Similar to Cloud Native Runtimes, allocate a wildcard subdomain for your workshops and content. This is specified in the `learningcenter.ingressDomain` key of the `tap-values.yml` configuration file that you input with the installation. This wildcard should be pointed at the external IP address of the `tanzu-system-ingress`'s `envoy` service.
- Tanzu Application Platform GUI - If you decide to implement the shared ingress and include Tanzu Application Platform GUI, allocate a fully Qualified Domain Name (FQDN) that can be pointed at the `tanzu-system-ingress` service.
The default host name consists of `tap-gui` plus an `IngressDomain` of your choice. For example,
`tap-gui.example.com`.


### <a id='tap-gui'></a>Tanzu Application Platform GUI

* Latest version of Chrome, Firefox, or Edge. Tanzu Application Platform GUI currently does not support Safari browser.
- Git repository for Tanzu Application Platform GUI's software catalogs, along with a token allowing read access. For more information about how you will use your Git repository, see the Using accelerator.yaml section in [Getting started with the Tanzu Application Platform](getting-started.md#accelerator-yaml).
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


## <a id='k8s-cluster-reqs'></a>Kubernetes cluster requirements

Installation requires Kubernetes cluster v1.21, v1.22, or v1.23 on one of the following Kubernetes
providers:

* Azure Kubernetes Service
* Amazon Elastic Kubernetes Service
* Google Kubernetes Engine
    * GKE Autopilot clusters do not have required features enabled
    * GKE clusters that are set up in zonal mode might detect Kubernetes API errors when the GKE
    control plane is resized after traffic increases. Users can mitigate this by creating a
    regional cluster with 3 control-plane nodes right from the start.
* Minikube
    * Reference the resource requirements below
    * Hyperkit driver is supported on macOS only; Docker driver is not supported.
* Tanzu Kubernetes Grid multicloud
* vSphere with Tanzu v7.0 U3a (not possible with Tanzu Application Platform v1.0.0 or earlier).<br>
For vSphere with Tanzu, [pod security policies](https://kubernetes.io/docs/concepts/policy/pod-security-policy/)
must be configured so that Tanzu Application Platform controller pods can run as root.
To set the pod security policies, run:

    ```console
    kubectl create clusterrolebinding default-tkg-admin-privileged-binding --clusterrole=psp:vmware-system-privileged --group=system:authenticated
    ```

    For more information about Pod Security Policies on Tanzu for vSphere, see
    [Using Pod Security Policies with Tanzu Kubernetes Clusters in VMware vSphere Product Documentation](https://docs.vmware.com/en/VMware-vSphere/7.0/vmware-vsphere-with-tanzu/GUID-CD033D1D-BAD2-41C4-A46F-647A560BAEAB.html).

## <a id="resource-requirements"></a>Resource requirements

* To deploy all Tanzu Application Platform packages, your cluster must have at least:
    * 8&nbsp;CPUs for i9 (or equivalent) available to Tanzu Application Platform components
    * 12&nbsp;CPUs for i7 (or equivalent) available to Tanzu Application Platform components
    * 8&nbsp;GB of RAM across all nodes available to Tanzu Application Platform
    * 12&nbsp;GB of RAM is available to build and deploy applications, including Minikube. VMware recommends 16&nbsp;GB of RAM for an optimal experience.
    * 70&nbsp;GB of disk space available per node

* For the [`full` profile](install.html#full-profile), or
    use of Security Chain Security Tools - Store, your cluster must have a configured default StorageClass.

* [Pod Security Policies](https://kubernetes.io/docs/concepts/policy/pod-security-policy/)
must be configured so that Tanzu Application Platform controller pods can run as root.

## <a id='tools-and-cli-reqs'></a>Tools and CLI requirements

Installation requires:

* The Kubernetes CLI, kubectl, v1.20, v1.21 or v1.22, installed and authenticated with administrator rights for your target cluster. See [Install Tools](https://kubernetes.io/docs/tasks/tools/) in the Kubernetes documentation.
