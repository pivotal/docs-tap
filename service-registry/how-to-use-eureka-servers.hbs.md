# Create Eureka Servers for Service Discovery in Workloads

This topic describes how to create `EurekaServer` resources and how to bind to them in your workloads
 with Resource Claims.

## <a id="discover-params"></a> Discover available parameters

To examine the available parameters when creating a `EurekaServer` resource run:

```console
kubectl explain eurekaservers.service-registry.spring.apps.tanzu.vmware.com.spec
```

For example:

```console
$ kubectl explain eurekaservers.service-registry.spring.apps.tanzu.vmware.com.spec

GROUP:      service-registry.spring.apps.tanzu.vmware.com
KIND:       EurekaServer
VERSION:    v1alpha1

FIELD: spec <Object>

DESCRIPTION:
    EurekaServerSpec defines the desired state of EurekaServer

FIELDS:
  imagePullSecretName	<string>
    Name of secret to use for pulling the Eureka image

  replicas	<integer>
    Replica count for the EurekaServer StatefulSet
```

## <a id="claim-creds"></a>Create a EurekaServer

To create a `EurekaServer` resource with two replicas, use the following YAML definition:

```YAML
---
apiVersion: service-registry.spring.apps.tanzu.vmware.com/v1alpha1
kind: EurekaServer
metadata:
  name: my-eurekaserver
  namespace: my-namespace
spec:
  replicas: 2
```

Then apply the YAML:

```console
kubectl apply -f my-eurekaserver.yaml
```

Use `kubectl describe` to check the status of the `EurekaServer`. For example:

```console
$ kubectl describe eurekaservers.service-registry.spring.apps.tanzu.vmware.com my-eurekaserver

Name:         my-eurekaserver
Namespace:    my-namespace
Labels:       <none>
Annotations:  <none>
API Version:  service-registry.spring.apps.tanzu.vmware.com/v1alpha1
Kind:         EurekaServer
Metadata:
  Creation Timestamp:  2023-08-30T14:51:04Z
  Generation:          1
  Resource Version:    4698719
  UID:                 4dd60698-6332-43bf-a27d-cef610579c98
Spec:
  Replicas:  2
Status:
  Binding:
    Name:  eureka-my-eurekaserver-client-binding-mvvlx
  Conditions:
    Last Transition Time:  2023-08-30T14:51:04Z
    Message:               EurekaServer reconciled
    Observed Generation:   1
    Reason:                EurekaServerReconciled
    Status:                True
    Type:                  Ready
  Observed Generation:     1
  Server Binding:
    Name:  eureka-my-eurekaserver-server-binding-2jq76
Events:    <none>
```

The `Status.Conditions` field will inform you when the `EurekaServer` is ready.

## <a id="claim-creds"></a>Claim credentials

To claim credentials you can either use the `tanzu service resource-claim create` command
or create a `ResourceClaim` directly.

- **If using the Tanzu CLI,** claim credentials by running:

    ```console
    tanzu service resource-claim create CLAIM-NAME \
        --resource-kind EurekaServer \
        --resource-api-version service-registry.spring.apps.tanzu.vmware.com/v1alpha1 \
        --resource-name RESOURCE-NAME \
        --resource-namespace RESOURCE-NAMESPACE \
        --namespace NAMESPACE \
    ```

    Where:

    - `CLAIM-NAME` is a name you choose for your claim.
    - `RESOURCE-NAME` is the name of the EurekaServer resource you want to claim.
    - `RESOURCE-NAMESPACE` is the namespace that your EurekaServer resource is in.
    - `NAMESPACE` is the namespace that your workload is in.

    For example:

    ```console
    $ tanzu service resource-claim create my-eurekaserver-claim \
        --resource-kind EurekaServer \
        --resource-api-version service-registry.spring.apps.tanzu.vmware.com/v1alpha1 \
        --resource-name my-eurekaserver \
        --resource-namespace my-namespace \
        --namespace my-namespace \
    ```

- **If using a `ResourceClaim`,** create a YAML file similar to the following example:

    ```yaml
    ---
    apiVersion: services.apps.tanzu.vmware.com/v1alpha1
    kind: ResourceClaim
    metadata:
      name: my-eurekaserver-claim
      namespace: my-namespace
    spec:
      ref:
        apiVersion: service-registry.spring.apps.tanzu.vmware.com/v1alpha1
        kind: EurekaServer
        name: my-eurekaserver
        namespace: my-namespace
    ```

## <a id="inspect"></a>Inspect the progress of your claim

You can inspect the progress of you claim creation by running:

```console
tanzu service resource-claim get MY-CLAIM-NAME --namespace MY-NAMESPACE
```

or

```console
kubectl get resourceclaim MY-CLAIM-NAME --namespace MY-NAMESPACE --output yaml
```