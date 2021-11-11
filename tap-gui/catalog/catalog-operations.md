#Catalog Operations

This guide will focus on how you can set up software catalogs. We recommend that you get familiar with Backstage and their software catalog system before proceeding. The [Software Catalog Overview](https://backstage.io/docs/features/software-catalog/software-catalog-overview) and [Catalog Configuration](https://backstage.io/docs/features/software-catalog/configuration) pages are good places to start.

## Adding Catalog Entities
This section will describe how you can format your own catalog. Creating catalogs consists of building metadata YAML files stored together with the code. This information is read from a Git-compatible repository consisting of these YAML catalog definition files. Changes made to the catalog definitions on your Git infrastructure are automatically reflected every 200 seconds. For each catalog entity kind you create, there is a file format you must follow. Below is an overview of a few core entities, but details about all types of entities can be found [here](https://backstage.io/docs/features/software-catalog/descriptor-format). We also have an example blank catalog [here](https://gitlab.eng.vmware.com/project-star/pstar-backstage-poc/-/tree/master/sample-catalogs/blank) for now, to use as a loose guide for creating user, group, system, and main component YAML files.

Relationship Diagram:
![Tanzu Application Platform GUI Relationships](../images/tap-gui-relationships.jpg)

### Users and Groups
A User entity describes a specific person and is used for identity purposes. A Group entity describes an organizational team or unit. Users are members of one or more Groups.

The descriptor files for both require values for `apiVersion`, `kind`, `metadata.name`. Users also require `spec.memberOf`. Groups require `spec.type` and `spec.children`, where `spec.children` is another Group. To link a logged in user to a User entity, be sure to include the optional `spec.profile.email` field.

Example User and Group entities:

```yaml
apiVersion: backstage.io/v1alpha1
kind: User
metadata:
  name: default-user
spec:
  profile:
    displayName: Default User
    email: guest@example.com
    picture: https://avatars.dicebear.com/api/avataaars/guest@example.com.svg?background=%23fff
  memberOf: [default-team]
```

```yaml
apiVersion: backstage.io/v1alpha1
kind: Group
metadata:
  name: default-team
  description: Default Team
spec:
  type: team
  profile:
    displayName: Default Team
    email: team-a@example.com
    picture: https://avatars.dicebear.com/api/identicon/team-a@example.com.svg?background=%23fff
  parent: default-org
  children: []
```
More information about and examples for these entities can be found in Backstage documentation [here](https://backstage.io/docs/features/software-catalog/descriptor-format#kind-group) and [here](https://backstage.io/docs/features/software-catalog/descriptor-format#kind-group).


### Systems
A System entity is a collection of resources and components. System descriptor files require values for `apiVersion`, `kind`, `metadata.name`, and `spec.owner`, where `spec.owner` is a User or Group. A System has Components belonging to it when that Component specifies the System name in the field `spec.system`.

Example System entity
```yaml
apiVersion: backstage.io/v1alpha1
kind: System
metadata:
  name: backstage
  description: Tanzu Application Platform GUI System
spec:
  owner: default-team
```

More information about and examples for Systems can be found in Backstage documentation [here](https://backstage.io/docs/features/software-catalog/descriptor-format#kind-system).

### Components
A Component describes a software component, or a "unit of software". Component descriptor files require values for `apiVersion`, `kind`, `metadata.name`, `spec.type`, `spec.lifecycle`, and `spec.owner`. Some useful optional fields are `spec.system` and `spec.subcomponentOf`, both of which links a Component to an entity it is a part of.

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: backstage-component
  description: Tanzu Application Platform GUI Component
  annotations:
    'backstage.io/kubernetes-label-selector': 'app=backstage' #Identifies the Kubernetes objects that make up this component
    'backstage.io/techdocs-ref': dir:. #TechDocs label
spec:
  type: service
  lifecycle: alpha
  owner: default-team
  system: backstage
```


More information about and examples for Components can be found in Backstage documentation [here](https://backstage.io/docs/features/software-catalog/descriptor-format#kind-component).

## Adding an Additional Catalog Location

To register the components of a catalog through static configuration, add the catalog's location to the `app_config` section of `tap-gui-values.yaml` (or your existing custom values file used at installation time):

```yaml
catalog:
  locations:
    - type: url
      target: <Existing Catalog Location>
    - type: url
      target: <Additional Catalog Location>
```

Next, update the package to include the catalog:

```shell
tanzu package installed update backstage \
  --version <package-version> \
  -f <values-file>
```

You can check the status of this update with:

```shell
tanzu package installed list
```

## Updating Your Organization Catalog Location

To update the components of a catalog through static configuration, update the catalog's location to the `app_config` section of `tap-gui-values.yaml` (or your existing custom values file used at installation time):

```yaml
catalog:
  locations:
    - type: url
      target: <Updated Catalog Location>
```
Next, update the package to include the catalog:

```shell
tanzu package installed update backstage \
  --version <package-version> \
  -f <values-file>
```

You can check the status of this update with:

```shell
tanzu package installed list
```

## Installing demo apps and their catalogs
If you want to set up one of our demos, you can choose between a blank or a sample catalog.

### Yelb System
The [Yelb](https://github.com/mreferre/yelb/tree/master/deployments/platformdeployment/Kubernetes/yaml) demo catalog includes all the components that make up the Yelb system as well as the default Backstage components.
#### Install Yelb
1. Download the appropriate file for running the Yelb application itself from [here](https://github.com/mreferre/yelb/tree/master/deployments/platformdeployment/Kubernetes/yaml)
2. Install the application on the Kubernetes cluster that you've used for Tanzu Application Platform. It's important to preserve the metadata labels on the Yelb application's objects.


#### Install Yelb Catalog
1. Save the **Tanzu Application Platform GUI Yelb Catalog** from the Tanzu Network's [Tanzu Application Platform downloads](https://network.pivotal.io/products/tanzu-application-platform) under the "Tap-GUI-Catalogs" folder.
2. Using the steps for [Adding an Additional Catalog Location](#adding-an-additional-catalog-location), add the `catalog-info.yaml`
