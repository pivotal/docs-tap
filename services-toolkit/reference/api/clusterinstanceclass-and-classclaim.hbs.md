# ClusterInstanceClass and ClassClaim

Detailed API documentation for `ClusterInstanceClass` and `ClassClaim`.

## ClusterInstanceClass

`ClusterInstanceClasses` can be configured to one of two variants - either pool-based or provisioner-based. Claims for pool-based classes are fulfilled by identifying service instances using configuration in `.spec.pool`. Claims for provisioner-based classes are fulfilled by provisioning new service instances using configuration in `.spec.provisioner`. A class can either be a pool-based class or a provisioner-based class, but never both.

```yaml
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ClusterInstanceClass

metadata:
  # A name for the class. The class name will be used by consumers (application operators and developers) when creating
  # claims.
  name: mysql-unmanaged

spec:
  # Provide information about the class in the description.
  description:
    # A short description for the class. Aim to provide just enough information to help consumers (application
    # operators and developers) determine what's on offer by the class.
    short: MySQL by Bitnami

  # Configure a provisioner-based class.
  # (optional; must specify one of either `provisioner` or `pool`).
  provisioner:
    # Configure provisioning using Crossplane (https://www.crossplane.io/).
    crossplane:
      # CompositeResourceDefinition refers to a Composite Resource Definition ("XRD" in Crossplane parlance) by name.
      # For example, "xpostgresqlinstances.database.example.org".
      compositeResourceDefinition: xmysqlinstances.bitnami.database.tanzu.vmware.com

      # The compositionSelector allows you to match a Composition by labels rather than naming one explicitly. It is
      # used to set the compositionRef if none is specified explicitly.
      # (optional).
      compositionSelector:
        matchLabels:
          provider: bitnami
          type: mysql

      # CompositionRef specifies which Composition this XR will use to compose resources when it is created, updated,
      # or deleted. This can be omitted and will be set automatically if the XRD has a default or enforced composition
      # reference, or if the below composition selector is set.
      # (optional).
      compositionRef:
        name: composition-name

      # CompositionUpdatePolicy specifies how existing XRs should be updated to new revisions of their underlying
      # composition.
      # (optional; one of either 'Automatic' or 'Manual'; default=Automatic).
      compositionUpdatePolicy: Manual

  # Configure a pool-based class.
  # (optional; must specify one of either `provisioner` or `pool`).
  pool:
    # Group specifies the API group for the resources belonging to this class.
    # (optional).
    group:

    # Kind specifies the API Kind for the resources belonging to this class.
    kind:

    # FieldSelector specifies a set of fields that MUST match certain conditions.
    # See https://kubernetes.io/docs/concepts/overview/working-with-objects/field-selectors/.
    # (optional).
    fieldSelector:

    # LabelSelector specifies a set of labels that MUST match.
    # See https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors.
    # (optional).
    labelSelector:

# status is popuated by the controller
status:
  # Conditions for the class.
  conditions:
    # The condition type. Currently only 'Ready'.
    - type: Ready
      # status can be either 'True' or 'False'.
      status: "True"
      # A reason can be set if status: "False" in order to provide additional context as to why.
      # One of 'PooledResourceNotFound', 'CompositeResourceDefinitionNotFound', 'CompositeResourceDefinitionNotValid' or
      # 'CompositeResourceDefinitionNotReady'. Not set if status: "True".
      reason:

  # ClaimParameters contains the OpenAPIV3Schema used to configure claims for this class.
  # (optional; not set on pool-based classes).
  claimParameters:
    openAPIV3Schema:
      description: The OpenAPIV3Schema of this Composite Resource Definition.
      properties:
        storageGB:
          default: 1
          description: The desired storage capacity of the database, in Gigabytes.
          type: integer
      type: object

  # instanceType holds information about the resource selected by this Class. If using the crossplane provisioner, this
  # will refer to the CompositeResource ("XR") defined by the CompositeResourceDefinition ("XRD") referred to in the
  # class.
  instanceType:
    # Group specifies the API group.
    # (optional).
    group: bitnami.database.tanzu.vmware.com
    # Kind specifies the API Kind.
    kind: XMySQLInstance
    # Version specifies the API version.
    version: v1alpha1

  # populated based on metadata.generation when controller observes a change to the resource; if this value is out of
  # date, other status fields do not reflect latest state
  observedGeneration: 1
```

## ClassClaim

`ClassClaims` refer to a `ClusterInstanceClass`, from which service instances are then either selected (pool-based classes) or provisioned (provisioner-based classes) in order to fulfill the claim. `ClassClaims` adhere to [Provisioned Service](https://github.com/servicebinding/spec#provisioned-service) as defined by the Service Binding Specification for Kubernetes, and as such can be bound to Application Workloads via reference in a given Workload's `.spec.serviceClaims` configuration.

```yaml
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ClassClaim

metadata:
  # The name for the claim.
  name: mysql-claim-1
  # The namespace in which to create the claim.
  namespace: my-apps

spec:
  # classRef holds a reference to a ClusterInstanceClass.
  classRef:
    # The name of the class from which to claim a service instance.
    # Note: If referring to a provisioner-based class, then users must have sufficient RBAC permission to claim from
    # the class. See [Authorize users and groups to claim from provisioner-based classes](../../how-to-guides/authorize-claim-provisioner-classes.hbs.md) for further information.
    name: mysql-unmanaged

  # Parameters are key-value pairs that are configuration inputs to the instance obtained from the referenced
  # ClusterInstanceClass. These parameters only take effect when referring to a provisioner-based class.
  # (optional).
  parameters:
    key: value

status:
  # Conditions for the claim.
  conditions:
    # The condition type. Can be one of 'Ready', 'ClassMatched', 'Validated' or 'ResourceClaimCreated'.
    # All condition types are initialized for all claims.
    # The Ready condition reports status: "True" once all other condition types are healthy.
    - type: Ready
      # status can be either 'True' or 'False'.
      status: "True"
      # A reason can be set if status: "False" in order to provide additional context as to why.
      # One of 'UnableToFetchClass', 'ClassDoesNotExist', 'ClassNotReady', 'UnableToQueryClaimableInstances',
      # 'NoClaimableInstances', 'UnableToCreateResourceClaim', 'UnableToCreateClaimableInstance', 'ResourceReady',
      # 'ResourceNotReady', 'ResourceReadyUnsupported' or 'ReasonParametersInvalid'.
      # Not set if status: "True".
      reason:

  # binding holds a reference to a Secret in the same namespace which contains credentials for accessing the claimed
  # service instance.
  binding:
    # The name of the `Secret`. The presence of the .status.binding.name field marks this resource as a
    # [Provisioned Service](https://github.com/servicebinding/spec#provisioned-service).
    name: 770845b6-02f0-4c1b-8d0c-3dae81bad35c

  # provisionedResourceRef contains a reference to the provisioned resource.
  # Only set if the claim referrs to a provisioner-based class.
  provisionedResourceRef:
    # The API Group/Version of the provisioned resource in the GROUP/VERSION format.
    apiVersion: bitnami.database.tanzu.vmware.com/v1alpha1
    # The API kind of the provisioned resource.
    kind: XMysqlInstance
    # The name of the provisioned resource.
    name: mysql-1-57dr7

  # resourceRef contains a reference to the claimed resource.
  resourceRef:
    # The API Group/Version of the claimed resource in the GROUP/VERSION format.
    apiVersion: v1
    # The API kind of the claimed resource.
    kind: Secret
    # The name of the claimed resource.
    name: 770845b6-02f0-4c1b-8d0c-3dae81bad35c
    # The namespace of the claimed resource.
    namespace: my-apps

  # populated based on metadata.generation when controller observes a change to the resource; if this value is out of
  # date, other status fields do not reflect latest state
  observedGeneration: 1
```
