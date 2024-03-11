# Troubleshoot AWS Services

This topic explains how you troubleshoot issues related to AWS Services on Tanzu Application Platform
(commonly known as TAP).

## <a id="private-reg"></a> Secret key name for Amazon MQ (RabbitMQ) claims do not match corresponding name used in Spring Cloud Bindings library

**Symptom:**

If you create a claim for Amazon MQ (RabbitMQ), the resulting binding Secret will contain a key named `endpoint`. This does
not match the key name expected by the [Spring Cloud Bindings](https://github.com/spring-cloud/spring-cloud-bindings)
library, which uses `addresses`. As such, when binding spring-based workloads to the Amazon MQ (RabbitMQ) service, the
connection will not be established automatically.

**Cause:**

This is due to a misconfiguration in the `Composition` for the Amazon MQ (RabbitMQ) service.

**Solution:**

Until such time that the key name is updated in the `Composition`, you can apply the following workaround.

1. Pause reconciliation of the aws-services PackageInstall, for example:

```console
kubectl patch packageinstall/aws-services -n tap-install -p '{"spec":{"paused": true}}' --type=merge
```

2. Manually edit the Amazon MQ (RabbitMQ) CompositionResourceDefinition and Composition to change the key name, for example:

```console
kubectl edit xrd xrabbitmqbrokers.aws.queue.tanzu.vmware.com
# replace "endpoint" with "addresses"
kubectl edit composition xrabbitmqbrokers.aws.queue.tanzu.vmware.com
# replace "endpoint" with "addresses"
```

3. Create a new class claim for the Amazon MQ (RabbitMQ) service, for example:

```
tanzu service class-claim create <NAME> --class rabbitmq-managed-aws
```

Note that these changes will not have any effect on any existing claims for the Amazon MQ (RabbitMQ) service.
Also note that upgrading to a newer version of Tanzu Application Platform may overwrite these temporary workarounds, however
any existing service instances should continue to function as expected.
