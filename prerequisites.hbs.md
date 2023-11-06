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

        >**Note** For production environments, `full` dependencies are recommended to
        >optimize security and performance. For more information about Tanzu Build Service
        >dependencies, see [About lite and full dependencies](tanzu-build-service/dependencies.md#lite-vs-full).

- Registry credentials with read and write access available to
Tanzu Application Platform to store images.

- Network access to your chosen container image registry.


### <a id='dns-records'></a>DNS Records

There are some optional but recommended DNS records you must allocate if you decide to use these particular components:

- Cloud Native Runtimes (Knative): Allocate a wildcard subdomain for your developer's applications. This is specified in the `shared.ingress_domain` key of the `tap-values.yaml` configuration file that you input with the installation. This wildcard must be pointed at the external IP address of the `tanzu-system-ingress`'s `envoy` service. See [Access with the shared Ingress method](tap-gui/accessing-tap-gui.html#ingress-method) for more information about `tanzu-system-ingress`.

- Tanzu Learning Center: Similar to Cloud Native Runtimes, allocate a wildcard subdomain for your workshops and content. This is also specified by the `shared.ingress_domain` key of the `tap-values.yaml` configuration file that you input with the installation. This wildcard must be pointed at the external IP address of the `tanzu-system-ingress`'s `envoy` service.

- Tanzu Developer Portal (formerly named Tanzu Application Platform GUI): If you decide to implement
  the shared ingress and include Tanzu Developer Portal, allocate a fully Qualified Domain Name
  (FQDN) that can be pointed at the `tanzu-system-ingress` service. The default host name consists
  of `tap-gui` and the `shared.ingress_domain` value. For example, `tap-gui.example.com`.

- Supply Chain Security Tools - Store: Similar to Tanzu Developer Portal, allocate a fully Qualified Domain Name (FQDN) that can be pointed at the `tanzu-system-ingress` service. The default host name consists of `metadata-store` and the `shared.ingress_domain` value. For example, `metadata-store.example.com`.

- Application Live View: If you select the `ingressEnabled` option, allocate a corresponding fully Qualified Domain Name (FQDN) that can be pointed at the `tanzu-system-ingress` service. The default host name consists of `appliveview` and the `shared.ingress_domain` value. For example,
`appliveview.example.com`.

### <a id='tap-gui'></a>Tanzu Developer Portal

For Tanzu Developer Portal, you must have:

- Latest version of Chrome, Firefox, or Edge. Tanzu Developer Portal currently does not support Safari browser.
- Git repository for Tanzu Developer Portal's software catalogs, with a token allowing read access. For more information about how to use your Git repository, see [Create an application accelerator](getting-started/create-app-accelerator.html#create-an-app-acc).
  Supported Git infrastructure includes:
    - GitHub
    - GitLab
    - Azure DevOps
- Tanzu Developer Portal Blank Catalog from the Tanzu Application section of VMware Tanzu Network.
  - To install, navigate to [Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform/). Under the list of available files to download, there is a folder titled `tap-gui-catalogs-latest`. Inside that folder is a compressed archive titled `Tanzu Developer Portal Blank Catalog`. You must extract that catalog to the preceding Git repository of choice. This serves as the configuration location for your organization's catalog inside Tanzu Developer Portal.
- The Tanzu Developer Portal catalog allows for two approaches to store catalog information:
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
          [Configure the Tanzu Developer Portal database](tap-gui/database.md)


## <a id='k8s-cluster-reqs'></a>Kubernetes cluster requirements

Installation requires Kubernetes cluster v1.25, v1.26 or v1.27 on one of the following Kubernetes
providers:

- Azure Kubernetes Service.
- Amazon Elastic Kubernetes Service.
    - containerd must be used as the Container Runtime Interface (CRI). Some versions of EKS default to Docker as the container runtime and must be changed to containerd.
    - EKS clusters on Kubernetes version 1.23 and above require the [Amazon EBS CSI Driver](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html) due to [CSIMigrationAWS](https://aws.amazon.com/blogs/containers/amazon-eks-now-supports-kubernetes-1-23/) is enabled by default in Kubernetes version 1.23 and above.
        - Users currently on EKS Kubernetes version 1.22 must install the Amazon EBS CSI Driver before upgrading to Kubernetes version 1.23 and above. See [AWS documentation](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi-migration-faq.html) for more information.
    - AWS Fargate is not supported.
- Google Kubernetes Engine.
    - GKE Autopilot clusters do not have the required features enabled.
    - GKE clusters that are set up in zonal mode might detect Kubernetes API errors when the GKE
    control plane is resized after traffic increases. Users can mitigate this by creating a
    regional cluster with three control-plane nodes right from the start.
- Minikube.
    - Reference the [resource requirements](#resource-requirements) in the following section.
    - Hyperkit driver is supported on macOS only. Docker driver is not supported.
- Red Hat OpenShift Container Platform v4.12 or v4.13.
    - vSphere
    - Baremetal
- Tanzu Kubernetes Grid (commonly called TKG) with Standalone Management Cluster. For more information, see the [Tanzu Kubernetes Grid documentation](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/index.html).
- vSphere with Tanzu v8.0.1c or later and Tanzu Application Platform v1.6.2 or later.
    - For vSphere with Tanzu, you must configure the pod security policies so the 
    Tanzu Application Platform controller pods can run as root. 
    For more information, see the [Kubernetes documentation](https://kubernetes.io/docs/concepts/policy/pod-security-policy/).

        To set the pod security policies, run:

        ```console
        kubectl create clusterrolebinding default-tkg-admin-privileged-binding --clusterrole=psp:vmware-system-privileged --group=system:authenticated
        ```

        For more information about the pod security policies on Tanzu for vSphere, 
        see the [VMware vSphere documentation](https://docs.vmware.com/en/VMware-vSphere/8.0/vsphere-with-tanzu-tkg/GUID-3B7F5B44-E31D-4819-B166-C531D4ECAE7D.html).

For more information about the supported Kubernetes versions, see [Kubernetes version support for Tanzu Application Platform](k8s-matrix.hbs.md).

## <a id="resource-requirements"></a>Resource requirements

- To deploy Tanzu Application Platform packages iterate profile on local Minikube cluster, your cluster must have at least:
    - 8&nbsp;vCPUs for i9 (or equivalent) available to Tanzu Application Platform components on Mac OS.
    - 12&nbsp;vCPUs for i7 (or equivalent) available to Tanzu Application Platform components on Mac OS.
    - 8&nbsp;vCPUs available to Tanzu Application Platform components on Linux and Windows.
    - 12&nbsp;GB of RAM available to Tanzu Application Platform components on Mac OS, Linux and Windows.
    - 70&nbsp;GB of disk space available per node.
- To deploy Tanzu Application Platform packages full profile, your cluster must have at least:
    - 8&nbsp;GB of RAM available per node to Tanzu Application Platform.
    - 16&nbsp;vCPUs available across all nodes to Tanzu Application Platform.
    - 100&nbsp;GB of disk space available per node.

    >**Important:** Tanzu Application Platform requires a minimum of 100 GB per node of ephemeral storage. If you do not allocate at least this amount of ephemeral storage for kubelet on all cluster nodes, you receive the error "minDiskPerNode: some cluster nodes don't meet minimum disk space requirement of '100Gi'." For more information about configuring the storage for a TKG cluster on Supervisor, see [v1alpha3 Example: TKC with Default Storage and Node Volumes](https://docs.vmware.com/en/VMware-vSphere/8.0/vsphere-with-tanzu-tkg/GUID-0DF355EF-AA36-4C0B-B0EF-35BF5F5FD5D4.html) and [v1beta1 Example: Custom Cluster Based on the Default ClusterClass](https://docs.vmware.com/en/VMware-vSphere/8.0/vsphere-with-tanzu-tkg/GUID-B60348F8-8976-4530-BB6F-3F144D963CE3.html).

- To deploy Tanzu Application Platform packages build, run and iterate (shared) profile, your cluster must have at least:
    - 8&nbsp;GB of RAM available per node to Tanzu Application Platform.
    - 12&nbsp;vCPUs available across all nodes to Tanzu Application Platform.
    - 100&nbsp;GB of disk space available per node.
- To deploy Tanzu Application Platform packages view profile, your cluster must have at least:
    - 8&nbsp;GB of RAM available per node to Tanzu Application Platform.
    - 8&nbsp;vCPUs available across all nodes to Tanzu Application Platform.
    - 100&nbsp;GB of disk space available per node.
- For the [full profile](install-online/profile.hbs.md#full-profile) or use of Security Chain Security Tools - Store, your cluster must have a configured default StorageClass.

- Pod security policies must be configured so that Tanzu Application Platform controller pods can run as root in the following optional configurations:
    - Tanzu Build Service, in which CustomStacks require root privileges. For more information, see [Tanzu Build Service documentation](https://docs.vmware.com/en/Tanzu-Build-Service/1.11/vmware-tanzu-build-service/managing-custom-stacks.html).
    - Supply Chain, in which Kaniko usage requires root privileges to build containers.
    - Tanzu Learning Center, which requires root privileges.

    For more information about pod security policies, see [Kubernetes documentation](https://kubernetes.io/docs/concepts/policy/pod-security-policy/).


## <a id='tools-and-cli-reqs'></a>Tools and CLI requirements

Installation requires:

- The Kubernetes CLI (kubectl) v1.25, v1.26 or v1.27 installed and authenticated with admin rights for your target cluster. See [Install Tools](https://kubernetes.io/docs/tasks/tools/) in the Kubernetes documentation.

## <a id='next-steps'></a>Next steps

- [Accept Tanzu Application Platform EULAs and installing the Tanzu CLI](install-tanzu-cli.html)
