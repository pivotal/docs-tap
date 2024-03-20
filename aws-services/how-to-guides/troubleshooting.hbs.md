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

This is due to a misconfiguration in the `Composition` for the Amazon MQ service.

**Solution:**

To workaround this issue:

1. Pause reconciliation of the aws-services PackageInstall, for example:

    ```console
    kubectl patch packageinstall/aws-services -n tap-install -p '{"spec":{"paused": true}}' --type=merge
    ```

2. Manually edit the Amazon MQ (RabbitMQ) CompositionResourceDefinition and Composition to change the
   key name from `endpoint` to `addresses` by running these commands:

    ```console
    kubectl edit xrd xrabbitmqbrokers.aws.queue.tanzu.vmware.com
    # replace "endpoint" with "addresses"
    ```
    ```console
    kubectl edit composition xrabbitmqbrokers.aws.queue.tanzu.vmware.com
    # replace "endpoint" with "addresses"
    ```

3. Create a new class claim for the Amazon MQ (RabbitMQ) service, for example:

    ```
    tanzu service class-claim create NAME --class rabbitmq-managed-aws
    ```

    Where `NAME` is the name you choose for your class claim.

That these changes do not have any effect on any existing claims for the Amazon MQ (RabbitMQ) service.

Upgrading to a later version of Tanzu Application Platform might overwrite this temporary workaround,
but any existing service instances will continue to function as expected.
