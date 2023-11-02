# Troubleshoot Workload

This topic gives you guidance about how to troubleshoot issues with Supply Chain Workload.

## <a id="pod-security-workload"></a> Errors when the security context is misconfigured

If workload in the supply chain fails to progess with error status shown below, it is prossibly 
the workload  security context is misconfigured. For example:

```yaml
- lastTransitionTime: "2023-09-12T14:45:16Z"
   message: 'admission webhook "pod-security-webhook.kubernetes.io" denied the request:
     pods "tanzu-java-web-app-00001-deployment-7cb5db665b-hrl4c" is forbidden: violates PodSecurity "restricted:latest":
     allowPrivilegeEscalation != false (containers "prepare", "place-scripts", "step-main"
     must set securityContext.allowPrivilegeEscalation=false)'
   reason: HealthyConditionRule
   status: "False"
   type: ResourcesHealthy
```

This error means the supply chain created workload deployment does not meet 
[pod security standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)  
used in the cluster. Please see [Configuring Pod Security for Workloads](/security-and-compliance/pod-security-for-workloads.hbs.md)
for setting supply chain workload security context.
