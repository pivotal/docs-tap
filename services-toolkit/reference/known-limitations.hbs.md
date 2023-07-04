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

- [provider-aws CRDs](https://marketplace.upbound.io/providers/upbound/provider-aws/latest/managed-resources)
- [provider-azure CRDs](https://marketplace.upbound.io/providers/upbound/provider-azure/latest/managed-resources)
- [provider-gcp CRDs](https://marketplace.upbound.io/providers/upbound/provider-gcp/latest/managed-resources)

You must ensure that your cluster has sufficient resource to support this number of additional CRDs
if you choose to install them.

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

## <a id="default-cluster-admin"></a>Default cluster-admin IAM roles on GKE do not allow claiming of Bitnami Services

**Description:**

For Tanzu Application Platform installations on Google Kubernetes Engine (GKE) clusters,
users with cluster-admin Role-Based Access Control (RBAC) permissions are not able to
create class claims for any of the Bitnami Services. The following error occurs:

```console
Error: admission webhook "vclassclaim.validation.resourceclaims.services.apps.tanzu.vmware.com" denied the request: user 'user@example.com' cannot 'claim' from clusterinstanceclass 'mysql-unmanaged'
Error: exit status 1
```

**Workaround:**

Explicitly create a ClusterRoleBinding for your user or group to the corresponding
`app-operator-claim-class-SERVICE` ClusterRole, where `SERVICE` is one of `mysql`, `postgresql`,
`rabbitmq`, or `redis`.

## <a id="crossplane-providers-custom-cert"></a>Crossplane Providers do not transition to HEALTHY=True if using a custom cert for your registry

**Description:**

A known issue exists relating to the installation and configuration of the Crossplane Providers when using a custom certificate for your registry. This prevents ClassClaims used for dynamic provisioning from reconciling successfully. A common symptom of this issue is ClassClaims indefinitely reporting a status condition of ResourceMatched=False with Reason=ResourceNotReady.

You can confirm the current status of the Crossplane Providers by running `kubectl get providers`:

```console
NAME                  INSTALLED   HEALTHY   PACKAGE                                                                                                                             AGE
provider-helm                               registry.example.com/tap/tap-packages:provider-helm@sha256:a3a14b07b79a8983257d1a2cc0449a4806753868178055554cfa38de7b649467         3d5h
provider-kubernetes                         registry.example.com/tap/tap-packages:provider-kubernetes@sha256:8039f7e56376b46532e3ce0eb7fc4a4501f2d85decf4912bb5952083abb41b7b   3d5h
```

The Providers here are not reporting INSTALLED=True or HEALTH=True, and thus may be effected by this issue.

The cause of the issue is related to the fact that the Providers are installed by Crossplane itself rather than directly via the [Crossplane Package](../../crossplane/about.hbs.md). CA certificate data configured via the tap-values.yaml file is not currently passed down to Crossplane, and therefore it is unable to successfully pull the Provider images.

**Workaround:**

You can work around the issue by creating a `ConfigMap` with your CA cert pem, and then setting `crossplane.registryCaBundleConfig` to refer to said `ConfigMap` in tap-values.yaml. Starting from TAP 1.6, the Crossplane Package will inherit the data configured via `shared_cert_data` and this temporary workaround will no longer be needed.

## <a id="crossplane-providers-custom-cert-inject"></a>Crossplane Providers are not able to communicate with systems that use a custom CA

**Description:**

A known issue exists for Crossplane Providers when they need to communicate with systems that are set up with a custom CA. A prime example for that is the Crossplane Helm Provider trying to pull a helm chart from a registry which uses a custom CA, by using a `releases.helm.crossplane.io`. In such a case you will see that:
- the `releases.helm.crossplane.io` never reports the status condition Ready=True
- shows a certificate verification error
   - in the Reason for the status condition of type Synced
   - as an event on the `release.helm.crossplane.io`

You can check the status by running `kubectl get releases.helm.crossplane.io`

```console
NAME                CHART   VERSION   SYNCED   READY   STATE   REVISION   DESCRIPTION   AGE
wordpress-example           15.2.5    False    False                                    7m37s
```

And you can dig into the reason with e.g. `kubectl get event --namespace default --field-selector involvedObject.name=wordpress-example,involvedObject.kind=Release,type!=Normal | grep -e 'LAST SEEN' -e 'failed to login'`

```console
LAST SEEN   TYPE      REASON                            OBJECT                      MESSAGE
3m41s       Warning   CannotCreateExternalResource      release/wordpress-example   failed to install release: failed to login to registry: Get "https://insecure-registry:443/v2/": tls: failed to verify certificate: x509: certificate signed by unknown authority
```

The cause of the issue is related to the fact that the Providers are installed by Crossplane itself rather than directly via the [Crossplane Package](../../crossplane/about.hbs.md). CA certificate data configured via the tap-values.yaml file is not currently passed down to Crossplane Providers, and therefore the Providers themselves are unable to successfully connect to the systems they need to communicate with (e.g. for the Helm Provider a registry hosting the helm charts, for the Kubernetes Provider a Kubernetes APIServer).

**Workaround:**

You need to use some sort of admission control which allows to mutate object, in this specific case Pods, and inject the appropriate CA certificate(s). An example for such a system is [Kyverno], specifically [this example][CaInjectExample]. However, any system which can mutate objects at admission time can be used to mutate the Crossplane Provider Pods. Starting from TAP 1.7, the Crossplane Package will inherit the data configured via `shared_cert_data` and configure the Crossplane Providers accordingly, thus this temporary workaround will no longer be needed.

[Kyverno]: https://kyverno.io/
[CaInjectExample]: https://kyverno.io/policies/other/add-certificates-volume/add-certificates-volume/
