# Troubleshoot AWS Services

This topic explains how you troubleshoot issues related to AWS Services on Tanzu Application Platform
(commonly known as TAP).

## <a id="private-reg"></a> Secret key name for Amazon MQ claims do not match the name used in the Spring Cloud Bindings library

**Symptom:**

When you create a claim for Amazon MQ (RabbitMQ), the resulting binding secret contains a key named `endpoint`.
This does not match the key name that the [Spring Cloud Bindings](https://github.com/spring-cloud/spring-cloud-bindings)
library expects, which is `addresses`.
As a result, when you bind Spring-based workloads to the Amazon MQ service, the connection is not
established automatically.

**Cause:**

This issue was originally caused due to a misconfiguration in the `CompositeResourceDefinition` and
`Composition` for the Amazon MQ service. These resources have since been updated to rectify the issue,
however Crossplane does not currently support changes to connectionSecretKeys in `CompositeResourceDefinition`
resources. There is however a fairly simple workaround to this issue. This should only be needed in cases
where you have upgraded your Tanzu Application Platform from v1.8.0 or v1.8.1 to v1.8.2+.

**Solution:**

To workaround this issue:

1. Find the name of the crossplane pod, for example:

    ```console
    kubectl get pod -lapp=crossplane -n crossplane-system
    ```

2. Delete the pod, for example:

    ```console
    kubectl delete pod <CROSSPLANE POD NAME> -n crossplane-system
    ```

The pod will be recreated and in doing so will re-read the updated list of connectionSecretKeys
from the `CompositeResourceDefinition`. New claims for Amazon MQ (RabbitMQ) will now contain the
correct set of key names.
