# Installing Cloud Native Runtimes with your existing Contour installation

This topic describes how you can configure Cloud Native Runtimes, commonly known
as CNRs, with your existing Contour instance. Cloud Native Runtimes uses Contour
to manage internal and external access to the services in a cluster.

## <a id='overview'></a> About using Contour with Cloud Native Runtimes

Follow the instructions in this topic if:

- You installed Contour as part of Tanzu Application Platform and want to configure Cloud Native Runtimes to use it.
- You see an error about `an existing Contour installation` when you install the Cloud Native Runtimes package.

Cloud Native Runtimes needs two instances of Contour:

- An instance for exposing services outside the cluster
- An instance for services that are private in your network

If installed as part of a Tanzu Application Platform profile,
by default Cloud Native Runtimes use the Contour instance installed in the
namespace `tanzu-system-ingress` for both internal and external traffic.

If you already use a Contour instance to route requests from clients outside and
inside the cluster, you can use your own Contour if it matches the Contour
version used by [Tanzu Application Platform](../../cert-manager/install.hbs.md).

You can use the same single instance of Contour for both internal and external
traffic. However, this causes Contour to handle internal and external traffic
the same way. For example, if the Contour instance is configured to be
accessible from clients outside the cluster, then any internal traffic is also
accessible from outside the cluster. Tanzu Application Platform only supports
using a single Contour instance for both internal and external traffic.

In all of these cases, Cloud Native Runtimes uses the Tanzu Application Platform's Contour `CustomResourceDefinition`s.

## <a id='prerecs'></a> Prerequisites

The following prerequisites are required to configure Cloud Native Runtimes with an existing Contour installation:

- Contour version v1.25.2, the Contour version that is installed as part of Tanzu Application Platform. To identify your cluster’s Contour version, see [Identify Your Contour Version](#identify-version).
- Contour `CustomResourceDefinition`s versions:

    | Resource Name                                 | Version  |
    | ----------------------------------------------| -------- |
    | `contourdeployments.projectcontour.io`        | v1alpha1 |
    | `contourconfigurations.projectcontour.io`     | v1alpha1 |
    | `extensionservices.projectcontour.io`         | v1alpha1 |
    | `httpproxies.projectcontour.io`               | v1       |
    | `tlscertificatedelegations.projectcontour.io` | v1       |

## <a id='identify-version'></a> Identify your Contour version

To identify your cluster's Contour version, run:

```shell script
export CONTOUR_NAMESPACE=CONTOUR-NAMESPACE
export CONTOUR_DEPLOYMENT=$(kubectl get deployment --namespace $CONTOUR_NAMESPACE --output name)
kubectl get $CONTOUR_DEPLOYMENT --namespace $CONTOUR_NAMESPACE --output jsonpath="{.spec.template.spec.containers[].image}"
kubectl get crds extensionservices.projectcontour.io --output jsonpath="{.status.storedVersions}"
kubectl get crds httpproxies.projectcontour.io --output jsonpath="{.status.storedVersions}"
kubectl get crds tlscertificatedelegations.projectcontour.io --output jsonpath="{.status.storedVersions}"
```

Where `CONTOUR-NAMESPACE` is the namespace where Contour is installed on your Kubernetes cluster.

## <a id='install-existing-contour'></a> Install Cloud Native Runtimes on a cluster with your existing Contour instance

To install Cloud Native Runtimes on a cluster with an existing Contour instance,
you can add values to your `cnr-values.yaml` file so that Cloud Native Runtimes uses your Contour instance.

An example of a `cnr-values.yaml` file where Cloud Native Runtimes uses the Contour version in a different namespace:

```yaml
---
contour:
  external:
    namespace: "tanzu-system-ingress"
  internal:
    namespace: "tanzu-system-ingress"
```

> **Note** If your Contour instance is removed or configured incorrectly, apps running on Cloud Native Runtimes lose connectivity.
