# Configuring Cloud Native Runtimes with Tanzu Service Mesh

This topic tells you how to configure Cloud Native Runtimes, commonly known as CNR, with Tanzu Service Mesh.

## <a id='overview'></a> Overview

You cannot install Cloud Native Runtimes on a cluster that has Tanzu Service Mesh attached.

This workaround describes how you can configure Tanzu Service Mesh to ignore the
Cloud Native Runtimes. This allows Contour to provide ingress routing for the
Knative workloads, while Tanzu Service Mesh continues to satisfy other connectivity
concerns.

> **Note** Cloud Native Runtimes workloads are unable to use Tanzu Service Mesh features like Global Namespace, Mutual
Transport Layer Security authentication (mTLS), retries, and timeouts.

For information about Tanzu Service Mesh,
see [Tanzu Service Mesh Documentation](https://docs.vmware.com/en/VMware-Tanzu-Service-Mesh/index.html).

## <a id='prerecs'></a>Prerequisites

The following prerequisites are required: 

- A cluster attached to Tanzu Service Mesh
- You haven't installed Cloud Native Runtimes

> **Note** If you installed Cloud Native Runtimes on a cluster that has Tanzu Service Mesh attached before doing the following procedure, pods fail to start. To fix this problem, follow the procedure in this topic and then delete all pods in the excluded namespaces.

## <a id='run-cnr'></a> Run Cloud Native Runtimes on a cluster attached to Tanzu Service Mesh

Configure Tanzu Service Mesh to ignore namespaces related to Cloud Native Runtimes:

1. Navigate to the **Cluster Overview** tab in the Tanzu Service Mesh UI.
2. On the cluster where you want to install Cloud Native Runtimes, click **...**. 
3. Click **Edit Cluster...**.
4. Create an Is Exactly rule for each of the following namespaces:
    
    - CONTOUR-NS
    - knative-serving
    - tap-install
    - rabbitmq-system
    - kapp-controller
    - The namespace or namespaces where you plan to run Knative workloads.

    Where `CONTOUR-NS` is the one or more namespaces where Contour is installed on your cluster. If Cloud Native Runtimes was installed as part of a Tanzu Application Profile, this value is likely `tanzu-system-ingress`.

## <a id='next-steps'></a> Next steps

After configuring Tanzu Service Mesh, install Cloud Native Runtimes and verify your installation:

1. Install Cloud Native Runtimes. See [Installing Cloud Native Runtimes](./app-operators/install.hbs.md).
1. Verify your installation. See [Verifying Your Installation](./app-operators/verify-installation.hbs.md).

> **Note** You must create all Knative workloads in the namespace or namespaces where you plan to run these Knative workloads. If you do not, your pods fail to start.
