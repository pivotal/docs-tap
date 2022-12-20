# <a id="nsp-what-is-it"></a>What is Namespace Provisioner?

Namespace provisioner for Tanzu Application Platform provides an easy, secure, automated way for 
Platform Operators to provision namespaces with the resources and proper namespace-level privileges 
required for their workloads to function as intended. In addition, this component has been designed 
to be extended by customers who wish to add additional namespace-scoped resources as per the 
bespoke requirements of their organization.

>Links to more detailed Namespace Provisioner documentation can be found [**here**](#additional-links).

## <a id="nsp-motivation"></a>Motivation

Provisioning multiple developer namespaces in a shared cluster is a core value proposition of TAP. 
TAP should provide a way out of the box for users to automate provisioning of resources for 
development teams by operators. TAP should provide operators new to Kubernetes a simple way to 
provision developer namespaces which is also compatible with existing tooling for organizations 
which have already adopted Kubernetes solutions. Following diagram shows important components 
installed as part of the Namespace Provisioner package and how they work together to automate 
resource creation in developer namespaces.

## <a id="nsp-component-overview"></a>Component Overview 

Here is a brief overview of the Namespace Provisioner components.

![Namespace Provisioner Overview](../images/namespace-provisioner-overview-2.svg)

### <a id="nsp-component-carvel-app"></a>Provisioner Carvel App 

![Namespace Provisioner - Provisioner Carvel App](../images/namespace-provisioner-overview-2-c.svg)

A single Carvel App named **`provisioner`** is installed in the **`tap-namespace-provisioning`** 
namespace as part of the Namespace Provisioner package. The App resource provides a mechanism for 
expanding a set of resources into installations in many namespaces using ytt to iterate over and 
substitute namespace-specific customization into a template. The “provisioner” Carvel App 
references a ConfigMap and a Secret which are explained in more detail below.

### <a id="nsp-component-desired-namespaces-configmap"></a>Desired Namespaces ConfigMap

![Namespace Provisioner - Desired Namespaces ConfigMap](../images/namespace-provisioner-overview-2-a.svg)

The **`desired-namespaces`** ConfigMap in the **`tap-namespace-provisioning`** namespace provides a 
declarative way to indicate which namespaces should be populated with resources. The ConfigMap can 
be managed directly by the customer via [GitOps](#nsp-using-gitops), or via the 
[Namespace Provisioner Controller](#nsp-controller) described below. This will be a simple list of 
namespace objects, with a required `name` parameter, with the option to provide additional 
parameters which can be used as `data.values` for customizing platform-operator defined resources.

**Example:**

```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: desired-namespaces
  namespace: tap-namespace-provisioning
  annotations:
    kapp.k14s.io/create-strategy: fallback-on-update
    namespace-provisioner.apps.tanzu.vmware.com/no-overwrite: "" #! This annotation tells the provisioner app to not override this configMap as this is your desired state.
data:
  namespaces.yaml: |
    #@data/values
    ---
    namespaces:
    - name: dev-ns1
      # additional parameters about dev-ns1 in the object...
    - name: dev-ns2
      # additional parameters about dev-ns2 in the object...
```

### <a id="nsp-component-namespace-provisioner-controller"></a>Namespace Provisioner Controller

Some customers may prefer to have the **`desired-namespaces`** ConfigMap automatically managed by a 
controller on the cluster. An optional (controlled by tap-values) controller called the namespace 
provisioner controller is installed as part of Namespace Provisioner package installation which 
watches namespaces in the cluster and updates the **`desired-namespaces`** ConfigMap in the 
**`tap-namespace-provisioning`** namespace with a list of namespaces which match the 
namespace_selector label selector in tap-values. The default label selector is  configurable via 
tap-values.yaml file.

### <a id="nsp-component-default-resources"></a>Default Resources Secret

The **`default-resources`** Secret is templated by tap-values.yaml to contain the appropriate 
resources for the given profile, set of supply chains installed, and other similar values. The 
full list of resources that are created for different profiles can be found on the 
[TAP Profile Resource mapping](reference.hbs.md) document in the reference section of the docs.

### <a id="nsp-component-expansion-template"></a>Expansion Template ConfigMap

The **`expansion-template`** ConfigMap will contain the ytt logic to expand the 
**`default-resources`** Secret and any additional sources added into tap-values pointing 
to the platform-operator-defined resources into per-namespace resources as per the list of 
namespaces in the **`desired-namespaces`** ConfigMap. The intent is to only allow definition 
of Cluster-scoped or namespaced resources, but for TAP 1.4 we allow installation of the grype 
package in the tap-install namespace.

</br>

---

### <a id="additional-links"></a>Links to additional Namespace Provisioner documentation:

- [Installation](install.hbs.md)
- [Tutorial - Provisioning Namespaces](tutorials.hbs.md) 
- [How-To Provision and Customize Namespaces via GitOps](how-tos.hbs.md)
- [Troubleshooting](troubleshooting.hbs.md)
- [Reference Materials](reference.hbs.md)
