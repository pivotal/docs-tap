# ClusterInstanceClass and ClassClaim

This topic provides API documentation for `ClusterInstanceClass` and `ClassClaim`.

## <a id="clusterinstanceclass"></a> ClusterInstanceClass

You can configure `ClusterInstanceClass` to one of two variants - either pool-based or provisioner-based.

- Claims for pool-based classes are fulfilled by identifying service instances using the configuration
  in `.spec.pool`.

- Claims for provisioner-based classes are fulfilled by provisioning new service instances using the
  configuration in `.spec.provisioner`.

A class can either be a pool-based class or a provisioner-based class, but never both.

The following snippet outlines the `ClusterInstanceClass` YAML:

```yaml
apiVersion: services.apps.tanzu.vmware.com/v1alpha1
kind: ClusterInstanceClass

metadata:
  # A name for the class. The class name is used by consumers (application operators
  # and developers) when creating claims.
  name: mysql-unmanaged

spec:
  # Provide information about the class in the description.
  description:
    # A short description for the class. Aim to provide just enough information
    # to help consumers (application operators and developers) to understand
    # what's on offer by the class.
    short: MySQL by Bitnami

  # (Optional) Configure a provisioner-based class.
  # Must specify one of either `provisioner` or `pool`.
  provisioner:
    # Configure provisioning using Crossplane (https://www.crossplane.io/).
    crossplane:
      # CompositeResourceDefinition refers to the name of a Composite Resource Definition (XRD).
      # For example, "xpostgresqlinstances.database.example.org".
      compositeResourceDefinition: xmysqlinstances.bitnami.database.tanzu.vmware.com

      # (Optional) The compositionSelector allows you to match a Composition by
      # labels rather than naming one explicitly. It is used to set the compositionRef
      # if none is specified explicitly.
      compositionSelector:
        matchLabels:
          provider: bitnami
          type: mysql

      # (Optional) CompositionRef specifies which Composition this XR will use to
      # compose resources when it is created, updated, or deleted.
      # This can be omitted and is set automatically if the XRD has a default or
      # enforced composition reference, or if the below composition selector is set.
      compositionRef:
        name: composition-name

      # (Optional) CompositionUpdatePolicy specifies how existing XRs should be
      # updated to new revisions of their underlying composition.
      # One of either 'Automatic' or 'Manual'; default=Automatic.
      compositionUpdatePolicy: Manual

  # (Optional) Configure a pool-based class.
  # Must specify one of either `provisioner` or `pool`.
  pool:
    # (Optional) Group specifies the API group for the resources belonging to this class.
    group:

    # Kind specifies the API Kind for the resources belonging to this class.
    kind:

    # (Optional) FieldSelector specifies a set of fields that MUST match certain conditions.
    # See https://kubernetes.io/docs/concepts/overview/working-with-objects/field-selectors/.
    fieldSelector:

    # (Optional) LabelSelector specifies a set of labels that MUST match.
    # See https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors.
    labelSelector:

# status is populated by the controller
status:
  # Conditions for the class.
  conditions:
    # The condition type. Currently only 'Ready'.
    - type: Ready
      # status can be either 'True' or 'False'.
      status: "True"
      # reason provides a reason for status: "False" for additional context.
      # One of 'PooledResourceNotFound', 'CompositeResourceDefinitionNotFound',
      # 'CompositeResourceDefinitionNotValid', or 'CompositeResourceDefinitionNotReady'.
      # Not set if status: "True".
      reason:

  # (Optional) claimParameters contains the OpenAPIV3Schema used to configure
  # claims for this class.
  # Not set on pool-based classes.
  claimParameters:
    openAPIV3Schema:
      description: The OpenAPIV3Schema of this Composite Resource Definition.
      properties:
        storageGB:
          default: 1
          description: The desired storage capacity of the database, in Gigabytes.
          type: integer
      type: object

  # instanceType holds information about the resource selected by this class.
  # If using the Crossplane provisioner, this refers to the CompositeResource (XR)
  # defined by the CompositeResourceDefinition (XRD) referred to in the class.
  instanceType:
    # (Optional) Group specifies the API group.
    group: bitnami.database.tanzu.vmware.com
    # Kind specifies the API Kind.
    kind: XMySQLInstance
    # Version specifies the API version.
    version: v1alpha1

  # Populated based on metadata.generation when controller observes a change to
  # the resource. If this value is out of date, other status fields do not
  # reflect latest state.
  observedGeneration: 1
```

## <a id="classclaim"></a> ClassClaim

`ClassClaim` refers to a `ClusterInstanceClass` from which service instances are then either selected
(for pool-based classes) or provisioned (for provisioner-based classes) to fulfill the claim.
`ClassClaim` adheres to [Provisioned Service](https://github.com/servicebinding/spec#provisioned-service)
as defined by the Service Binding Specification for Kubernetes.You can bind a `ClassClaim` to an
application workload by using a reference in the workload's `.spec.serviceClaims` configuration.

The following snippet outlines the `ClassClaims` YAML:

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
    # For information about the permissions users must have to claim from the class,
    # see the note below this snippet.
    name: mysql-unmanaged

  # (Optional) parameters are key-value pairs that are configuration inputs to the
  # instance obtained from the referenced ClusterInstanceClass. These parameters
  # only take effect when referring to a provisioner-based class.
  parameters:
    key: value

status:
  # Conditions for the claim.
  conditions:
    # The condition type. Can be one of 'Ready', 'ClassMatched', 'Validated', or
    # 'ResourceClaimCreated'. All condition types are initialized for all claims.
    # The Ready condition reports status: "True" once all other condition types are healthy.
    - type: Ready
      # status can be either 'True' or 'False'.
      status: "True"
      # reason provides a reason for status: "False" for additional context.
      # One of 'UnableToFetchClass', 'ClassDoesNotExist', 'ClassNotReady',
      # 'UnableToQueryClaimableInstances', 'NoClaimableInstances',
      # 'UnableToCreateResourceClaim', 'UnableToCreateClaimableInstance', 'ResourceReady',
      # 'ResourceNotReady', 'ResourceReadyUnsupported', or 'ReasonParametersInvalid'.
      # Not set if status: "True".
      reason:

  # binding holds a reference to a secret, in the same namespace, which contains
  # credentials for accessing the claimed service instance.
  binding:
    # The name of the `Secret`. The presence of the .status.binding.name field
    # marks this resource as a Provisioned Service.
    name: 770845b6-02f0-4c1b-8d0c-3dae81bad35c

  # provisionedResourceRef contains a reference to the provisioned resource.
  # Only set if the claim refers to a provisioner-based class.
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

  # Populated based on metadata.generation when controller observes a change to
  # the resource. If this value is out of date, other status fields do not reflect
  # latest state.
  observedGeneration: 1
```

> **Note** If you refer to a provisioner-based class in `spec.classref.name`, you must have
> sufficient RBAC permission to claim from the class. For more information, see
> [Authorize users and groups to claim from provisioner-based classes](../../how-to-guides/authorize-claim-provisioner-classes.hbs.md).
