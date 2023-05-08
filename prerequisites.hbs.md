# Prerequisites for installing Tanzu Application Platform 

The following are required to install Tanzu Application Platform (commonly known as TAP):

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
    
    - Recommended storage space for container image registry: 

        - 1&nbsp;GB of available storage if installing Tanzu Build Service with the `lite` set of dependencies.
        - 10 GB of available storage if installing Tanzu Build Service with the `full` set of dependencies, which are suitable for offline
        environments.

        >**Note:** For production environments, `full` dependencies are recommended to
        >optimize security and performance. For more information about Tanzu Build Service
        >dependencies, see [About lite and full dependencies](tanzu-build-service/dependencies.md#lite-vs-full).

- Registry credentials with read and write access available to
Tanzu Application Platform to store images.

- Network access to your chosen container image registry.


### <a id='dns-records'></a>DNS Records

There are some optional but recommended DNS records you must allocate if you decide to use these particular components:

- Cloud Native Runtimes (knative): Allocate a wildcard subdomain for your developer's applications. This is specified in the `shared.ingress_domain` key of the `tap-values.yaml` configuration file that you input with the installation. This wildcard must be pointed at the external IP address of the `tanzu-system-ingress`'s `envoy` service. See [Access with the shared Ingress method](tap-gui/accessing-tap-gui.html#ingress-method) for more information about `tanzu-system-ingress`.

- Tanzu Learning Center: Similar to Cloud Native Runtimes, allocate a wildcard subdomain for your workshops and content. This is also specified by the `shared.ingress_domain` key of the `tap-values.yaml` configuration file that you input with the installation. This wildcard must be pointed at the external IP address of the `tanzu-system-ingress`'s `envoy` service.

- Tanzu Application Platform GUI: If you decide to implement the shared ingress and include Tanzu Application Platform GUI, allocate a fully Qualified Domain Name (FQDN) that can be pointed at the `tanzu-system-ingress` service.
The default host name consists of `tap-gui` and the `shared.ingress_domain` value. For example,
`tap-gui.example.com`.

- Supply Chain Security Tools - Store: Similar to Tanzu Application Platform GUI, allocate a fully Qualified Domain Name (FQDN) that can be pointed at the `tanzu-system-ingress` service. The default host name consists of `metadata-store` and the `shared.ingress_domain` value. For example, `metadata-store.example.com`.

- Application Live View: If you select the `ingressEnabled` option, allocate a corresponding fully Qualified Domain Name (FQDN) that can be pointed at the `tanzu-system-ingress` service. The default host name consists of `appliveview` and the `shared.ingress_domain` value. For example,
`appliveview.example.com`.

### <a id='tap-gui'></a>Tanzu Application Platform GUI

For Tanzu Application Platform GUI, you must have:

- Latest version of Chrome, Firefox, or Edge. Tanzu Application Platform GUI currently does not support Safari browser.
- Git repository for Tanzu Application Platform GUI's software catalogs, with a token allowing read access. For more information about how to use your Git repository, see [Create an application accelerator](getting-started/create-app-accelerator.html#create-an-app-acc).
  Supported Git infrastructure includes:
    - GitHub
    - GitLab
    - Azure DevOps
- Tanzu Application Platform GUI Blank Catalog from the Tanzu Application section of VMware Tanzu Network.
  - To install, navigate to [Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform/). Under the list of available files to download, there is a folder titled `tap-gui-catalogs-latest`. Inside that folder is a compressed archive titled `Tanzu Application Platform GUI Blank Catalog`. You must extract that catalog to the preceding Git repository of choice. This serves as the configuration location for your organization's catalog inside Tanzu Application Platform GUI.
- The Tanzu Application Platform GUI catalog allows for two approaches to store catalog information:
    - The default option uses an in-memory database and is suitable for test and development scenarios.
          This reads the catalog data from Git URLs that you specify in the `tap-values.yaml` file.
          This data is temporary. Any operations that cause the `server` pod in the `tap-gui` namespace to be re-created
          also cause this data to be rebuilt from the Git location.
          This can cause issues when you manually register entities by using the UI, because
          they only exist in the database and are lost when that in-memory database gets rebuilt.
    - For production use cases, use a PostgreSQL database that exists outside the
          Tanzu Application Platform packaging.
          The PostgreSQL database stores all the catalog data persistently both from the Git locations
          and the UI manual entity registrations. For more information, see
          [Configuring the Tanzu Application Platform GUI database](tap-gui/database.md)


## <a id='k8s-cluster-reqs'></a>Kubernetes cluster requirements

Installation requires Kubernetes cluster v1.22 or v1.23 on one of the following Kubernetes
providers:

- Azure Kubernetes Service.
- Amazon Elastic Kubernetes Service.
    - containerd must be used as the Container Runtime Interface (CRI). Some versions of EKS default to Docker as the container runtime and must be changed to containerd.
    - EKS clusters on Kubernetes version 1.23 require the [Amazon EBS CSI Driver](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html) due to the [CSIMigrationAWS](https://aws.amazon.com/blogs/containers/amazon-eks-now-supports-kubernetes-1-23/) is enabled by default in Kubernetes 1.23.
        - Users currently on EKS Kubernetes version 1.22 must install the Amazon EBS CSI Driver before upgrading to Kubernetes version 1.23. See [AWS documentation](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi-migration-faq.html) for more information.
    - AWS Fargate is not supported.
- Google Kubernetes Engine.
    - GKE Autopilot clusters do not have the required features enabled.
    - GKE clusters that are set up in zonal mode might detect Kubernetes API errors when the GKE
    control plane is resized after traffic increases. Users can mitigate this by creating a
    regional cluster with three control-plane nodes right from the start.
- Minikube.
    - Reference the [resource requirements](#resource-requirements) in the following section.
    - Hyperkit driver is supported on macOS only. Docker driver is not supported.
- Tanzu Kubernetes Grid multicloud.
- vSphere with Tanzu v7.0 U3a.<br>
For vSphere with Tanzu, pod security policies must be configured so that Tanzu Application Platform controller pods can run as root.
For more information, see the [Kubernetes documentation](https://kubernetes.io/docs/concepts/policy/pod-security-policy/).

    To set the pod security policies, run:

    ```console
    kubectl create clusterrolebinding default-tkg-admin-privileged-binding --clusterrole=psp:vmware-system-privileged --group=system:authenticated
    ```

    For more information about pod security policies on Tanzu for vSphere, see
    [Using Pod Security Policies with Tanzu Kubernetes Clusters in VMware vSphere Product Documentation](https://docs.vmware.com/en/VMware-vSphere/7.0/vmware-vsphere-with-tanzu/GUID-CD033D1D-BAD2-41C4-A46F-647A560BAEAB.html).

## <a id="resource-requirements"></a>Resource requirements

- To deploy all Tanzu Application Platform packages, your cluster must have at least:
    - 8&nbsp;CPUs for i9 (or equivalent) available to Tanzu Application Platform components.
    - 12&nbsp;CPUs for i7 (or equivalent) available to Tanzu Application Platform components.
    - 8&nbsp;GB of RAM across all nodes available to Tanzu Application Platform.
    - 12&nbsp;GB of RAM is available to build and deploy applications, including Minikube. VMware recommends 16&nbsp;GB of RAM for an optimal experience.
    - 70&nbsp;GB of disk space available per node.

- For the [full profile](install-online/profile.hbs.md#full-profile) or use of Security Chain Security Tools - Store, your cluster must have a configured default StorageClass.

- Pod security policies must be configured so that Tanzu Application Platform controller pods can run as root.
See [Kubernetes documentation](https://kubernetes.io/docs/concepts/policy/pod-security-policy/) for more information.


## <a id='tools-and-cli-reqs'></a>Tools and CLI requirements

Installation requires:

- The Kubernetes CLI, kubectl, v1.22 or v1.23, installed and authenticated with admin rights for your target cluster. See [Install Tools](https://kubernetes.io/docs/tasks/tools/) in the Kubernetes documentation.

## <a id='next-steps'></a>Next steps

- [Accepting Tanzu Application Platform EULAs and installing the Tanzu CLI](install-tanzu-cli.html)
