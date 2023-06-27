# Known limitations for Services Toolkit

This topic describes known limitations and workarounds related to working with services on
Tanzu Application Platform (commonly known as TAP). For further troubleshooting guidance, see
[Troubleshoot Services Toolkit](../how-to-guides/troubleshooting.hbs.md).

## <a id="multi-workloads"></a> Cannot claim and bind to the same service instance from across multiple namespaces

**Description:**

Two or more workloads located in two or more distinct namespaces cannot claim and bind to the same
service instance.
This is due to the mutually exclusive nature of claims. After a claim has claimed a service instance,
no other claim can then claim that same service instance.

This limitation does not exist for two or more workloads located in the same namespace.
In this case, the workloads can all still all bind to one claim.
This is not possible across the namespace divide.

## <a id="compositeresourcedef"></a> Unexpected error if `additionalProperties` is `true` in a CompositeResourceDefinition

**Description:**

When creating a `CompositeResourceDefinition`, if you set `additionalProperties: true` in the
`openAPIV3Schema` section, an error occurs during the validation step of the creation of any
`ClassClaim` that refers to a class that refers to the `CompositeResourceDefinitions`.

**Error:**

```console
json: cannot unmarshal bool into Go struct field JSONSchemaProps.AdditionalProperties of type apiextensions.JSONSchemaPropsOrBool
```

**Workaround:**

Rather than setting `additionalProperties: true`, you can set `additionalProperties: {}` instead.
This has the same effect but does not cause unexpected errors.

## <a id="too-many-crds"></a> Cluster performance degradation due to large number of CRDs

**Description:**

While not strictly a limitation with Services Toolkit, take care before choosing to
install additional Crossplane `Providers` into Tanzu Application Platform.
Some of these `Providers` install hundreds of additional CRDs into the cluster.

This is particularly true of the `Providers` for AWS, Azure, and GCP.
For the number of CRDs installed with these `Providers`, see:

- [provider-aws CRDs](https://marketplace.upbound.io/providers/upbound/provider-aws/latest/crds)
- [provider-azure CRDs](https://marketplace.upbound.io/providers/upbound/provider-azure/latest/crds)
- [provider-gcp CRDs](https://marketplace.upbound.io/providers/upbound/provider-gcp/latest/crds)

You must ensure that your cluster has sufficient resource to support this number of additional CRDs
if you choose to install them.

**Workaround:**

Upbound have released a new feature named "Provider Families" which aims to address this issue. Refer to [Solving the Crossplane Provider CRD Scaling Problem with Provider Families](https://blog.crossplane.io/crd-scaling-provider-families/) to learn more.

## <a id="private-reg"></a> Private registry or VMware Application Catalog configuration does not take effect

**Description:**

As of Tanzu Application Platform v1.5.0, there is a known issue that occurs if you try to
[configure private registry integration for the Bitnami services](../../bitnami-services/how-to-guides/configure-private-reg-integration.hbs.md)
after having already created a claim for one or more of the Bitnami services using the default configuration.

The issue is that the updated private registry configuration does not appear to take effect.
This is due to caching behavior in the system which is not currently accounted for during configuration
updates.

**Workaround:**

Delete the `provider-helm-*` pods in the `crossplane-system` namespace and wait for new pods to come
back online after having applied the updated registry configuration.
