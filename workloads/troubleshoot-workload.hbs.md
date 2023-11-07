# Troubleshoot workloads

This topic gives you guidance about how to troubleshoot issues with supply chain workloads in Tanzu Application Platform (commonly known as TAP).

## <a id="pod-security-workload"></a> Errors when the security context is misconfigured

If the workload in the supply chain fails to progress with the error status shown below, the workload security context might be misconfigured. For example:

```yaml
- lastTransitionTime: "2023-09-12T14:45:16Z"
   message: 'admission webhook "pod-security-webhook.kubernetes.io" denied the request:
     pods "tanzu-java-web-app-00001-deployment-7cb5db665b-hrl4c" is forbidden: violates PodSecurity "restricted:latest"'
   reason: HealthyConditionRule
   status: "False"
   type: ResourcesHealthy
```

This error means that the workload deployment created by the supply chain does not meet
[pod security standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/) used in the cluster. For information about how to configure the supply chain workload security context, see [Configure pod security for workloads](../security-and-compliance/pod-security-for-workloads.hbs.md).
