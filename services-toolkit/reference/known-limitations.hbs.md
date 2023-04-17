# Known Limitations

This topic provides details of known issues and workarounds related to working with services on Tanzu Application
Platform.

## <a id="stk-known-limitation-multi-workloads"></a> Cannot claim and bind to the same service instance from across multiple namespaces

**Description**

It is not currently possible for two or more workloads residing in two or more distinct namespaces to claim and bind to the same service instance. This is due to the mutually exclusive nature of claims - once a claim has successfully claimed a service instance, no other claim can then claim that same service instance. This limitation does not exist for two or more workloads residing in the same namespace, as in this case the workloads can all still all bind to the one claim. This is not currently possible across the namespace divide. We are planning to remove this limitation in the future.

## Unexpected error if `"additionalProperties": true` is set in a CompositeResourceDefinition

**Description**

When creating a `CompositeResourceDefinition`, if you set `additionalProperties: true` in the `openAPIV3Schema` section, then an error will be encountered during the validation step of the creation of any `ClassClaim` which referrs to a class which referrs to the `CompositeResourceDefinitions`.

**Error**

`json: cannot unmarshal bool into Go struct field JSONSchemaProps.AdditionalProperties of type apiextensions.JSONSchemaPropsOrBool`

**Workaround**

Rather than setting `additionalProperties: true`, you can set `additionalProperties: {}` instead, which will have the same effect but will not result in unexpected errors.

## <a id="stk-known-limitation-too-many-crds"></a> Cluster performance degradation due to large number of CRDs

**Description**

While not strictly a limitation with Services Toolkit per se, care should be taken before choosing to install additional Crossplane `Providers` into Tanzu Application Platform. Some of these `Providers` install multiple hundreds of additional CRDs into the cluster. This is particularly true of the `Providers` for the three big clouds - AWS, Azure and GCP. At the time of writing `provider-aws` installs [894](https://marketplace.upbound.io/providers/upbound/provider-aws/latest/crds), `provider-azure` installs [705 CRDs](https://marketplace.upbound.io/providers/upbound/provider-azure/latest/crds) and `provider-gcp` installs [329 CRDs](https://marketplace.upbound.io/providers/upbound/provider-gcp/latest/crds). You must ensure your cluster has sufficient resource to support this number of additional CRDs if choosing to install them.

## Private registry or VMware Application Catalog (VAC) configuration does not seem to take effect

**Description**

As of Tanzu Application Platform v1.5.0 there is a known issue that occurs if you try to
[configure private registry integration for the Bitnami services](../../bitnami-services/how-to-guides/configure-private-reg-integration.hbs.md)
after having already created a claim for one or more of the Bitnami services using the default configuration.
The issue is that the updated private registry configuration does not appear to take effect.
This is due to caching behavior in the system which is not currently accounted for during configuration
updates.

**Workaround**

Delete the `provider-helm-*` pods in the `crossplane-system` namespace and wait for new pods to come
back online after having applied the updated registry configuration.
