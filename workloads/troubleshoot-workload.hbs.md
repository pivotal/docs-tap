# Troubleshoot Workload

This topic gives you guidance about how to troubleshoot issues with Supply Chain Workload.

## <a id="pod-security-workload"></a> Errors when the security context is misconfigured

If workload in the supply chain fails to progess with the error status shown below, then it is
possible that the workload security context is misconfigured. For example:

```yaml
- lastTransitionTime: "2023-09-12T14:45:16Z"
   message: 'admission webhook "pod-security-webhook.kubernetes.io" denied the request:
     pods "tanzu-java-web-app-00001-deployment-7cb5db665b-hrl4c" is forbidden: violates PodSecurity "restricted:latest"'
   reason: HealthyConditionRule
   status: "False"
   type: ResourcesHealthy
```

This error means that the workload Deployment created by the supply chain does not meet 
[pod security standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)  
used in the cluster. Please see [Configuring Pod Security for Workloads](/security-and-compliance/pod-security-for-workloads.hbs.md)
for setting the supply chain workload security context.
