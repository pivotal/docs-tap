# Create EurekaServer resources

This topic tells you about options when creating a `EurekaServer` resource.

## <a id="discover-params"></a> Discover available parameters

Examine the available parameters when creating a `EurekaServer` resource by running:

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

## <a id="create-eurekaserver"></a> Create a EurekaServer resource

To create a `EurekaServer` resource:

1. Create a `EurekaServer` resource with two replicas by using the following YAML definition:

    ```yaml
    ---
    apiVersion: service-registry.spring.apps.tanzu.vmware.com/v1alpha1
    kind: EurekaServer
    metadata:
      name: my-eurekaserver
      namespace: my-namespace
    spec:
      replicas: 2
    ```

1. Apply the YAML definition by running:

   ```console
   kubectl apply -f my-eurekaserver.yaml
   ```

1. Check the status of the `EurekaServer` resource by running:

   ```console
   kubectl describe YOUR-ADDRESS RESOURCE-NAME
   ```

   For example:

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

   A successful `EurekaServer` resource has a `Ready` condition set to `true` and a
   `status.binding.name` field pointing to a secret containing connection information.
