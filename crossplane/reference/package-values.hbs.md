# Package Values

This topic lists the keys and values you can use to configure the behavior of the Crossplane Package.
Configuration is split between configuration specific to Crossplane in Tanzu Application Platform
and configuration of the Upbound Universal Crossplane (UXP) Helm Chart.

If you are applying configuration to Tanzu Application Platform through the use of profiles and the `tap-values.yaml`,
all configuration must exist under the `crossplane` top-level key.

For example:

```yaml
crossplane:
  replicas: 3
```

## <a id="tap-specific"></a> Tanzu Application Platform configuration

The following table lists configuration specific to Crossplane in Tanzu Application Platform:

| KEY                                                  |DEFAULT                                     |TYPE    | DESCRIPTION |
|------------------------------------------------------|--------------------------------------------|--------|------------|
| kubernetes_version                                   |""                                          |string   Optional: The Kubernetes Version. Valid values are '' or take the form '1.25.0' |
| kubernetes_distribution                              |""                                          |string   Optional: The Kubernetes Distribution. Valid values are '' or 'openshift' |

## <a id="crossplane"></a> Standard Crossplane configuration

The following table lists configuration for the UXP Helm Chart:

| KEY                                                  |DEFAULT                                     |TYPE    | DESCRIPTION |
|------------------------------------------------------|--------------------------------------------|--------|------------|
| replicas                                             |1                                           |integer |
| serviceAccount.customAnnotations                     |'{}'                                        |object |
| bootstrapper.resources                               |'{}'                                        |object |
| bootstrapper.config.args                             |                                            |array |
| bootstrapper.config.debugMode                        |false                                       |boolean |
| bootstrapper.config.envVars                          |'{}'                                        |object |
| bootstrapper.image.pullPolicy                        |IfNotPresent                                |string |
| bootstrapper.image.repository                        |xpkg.upbound.io/upbound/uxp-bootstrapper    |string |
| bootstrapper.image.tag                               |v1.11.0-up.1                                |string |
| maxReconcileRate                                     |""                                          |string  | How frequently Crossplane may reconcile its resources (seconds). Default: 10 |
| metrics.enabled                                      |false                                       |boolean |
| securityContextCrossplane.allowPrivilegeEscalation   |false                                       |boolean |
| securityContextCrossplane.readOnlyRootFilesystem     |true                                        |boolean |
| securityContextCrossplane.runAsGroup                 |65532                                       |integer |
| securityContextCrossplane.runAsUser                  |65532                                       |integer |
| xfn.securityContext.allowPrivilegeEscalation         |false                                       |boolean |
| xfn.securityContext.capabilities.add                 |                                            |array |
| xfn.securityContext.readOnlyRootFilesystem           |true                                        |boolean |
| xfn.securityContext.runAsGroup                       |65532                                       |integer |
| xfn.securityContext.runAsUser                        |65532                                       |integer |
| xfn.securityContext.seccompProfile.type              |Unconfined                                  |string |
| xfn.args                                             |'{}'                                        |object |
| xfn.cache.configMap                                  |""                                          |string |
| xfn.cache.medium                                     |""                                          |string |
| xfn.cache.pvc                                        |""                                          |string |
| xfn.cache.sizeLimit                                  |1Gi                                         |string |
| xfn.enabled                                          |false                                       |boolean |
| xfn.extraEnvVars                                     |'{}'                                        |object |
| xfn.image.pullPolicy                                 |IfNotPresent                                |string |
| xfn.image.repository                                 |crossplane/xfn                              |string |
| xfn.image.tag                                        |v1.11.0-up.1                                |string |
| xfn.resources.requests.cpu                           |1000m                                       |string |
| xfn.resources.requests.memory                        |1Gi                                         |string |
| xfn.resources.limits.memory                          |2Gi                                         |string |
| xfn.resources.limits.cpu                             |2000m                                       |string |
| resourcesCrossplane.limits.cpu                       |500m                                        |string |
| resourcesCrossplane.limits.memory                    |1Gi                                         |string |
| resourcesCrossplane.requests.cpu                     |250m                                        |string |
| resourcesCrossplane.requests.memory                  |768Mi                                       |string |
| resourcesRBACManager.limits.memory                   |768Mi                                       |string |
| resourcesRBACManager.limits.cpu                      |100m                                        |string |
| resourcesRBACManager.requests.cpu                    |100m                                        |string |
| resourcesRBACManager.requests.memory                 |512Mi                                       |string |
| configuration.packages                               |                                            |array |
| deploymentStrategy                                   |RollingUpdate                               |string |
| extraEnvVarsCrossplane                               |'{}'                                        |object   List of extra environment variables to set in the crossplane deployment. EXAMPLE extraEnvironmentVars:   sample.key: value1   ANOTHER.KEY: value2 RESULT   - name: sample_key     value: "value1"   - name: ANOTHER_KEY     value: "value2" |
| registryCaBundleConfig                               |'{}'                                        |object |
| billing.awsMarketplace.iamRoleARN                    |arn:aws:iam::<ACCOUNT_ID>:role/<ROLE_NAME>  |string |
| billing.awsMarketplace.enabled                       |false                                       |boolean |
| image.pullPolicy                                     |IfNotPresent                                |string |
| image.repository                                     |upbound/crossplane                          |string |
| image.tag                                            |v1.11.0-up.1                                |string |
| packageCache.configMap                               |""                                          |string |
| packageCache.medium                                  |""                                          |string |
| packageCache.pvc                                     |""                                          |string |
| packageCache.sizeLimit                               |5Mi                                         |string |
| securityContextRBACManager.allowPrivilegeEscalation  |false                                       |boolean |
| securityContextRBACManager.readOnlyRootFilesystem    |true                                        |boolean |
| securityContextRBACManager.runAsGroup                |65532                                       |integer |
| securityContextRBACManager.runAsUser                 |65532                                       |integer |
| rbacManager.managementPolicy                         |Basic                                       |string |
| rbacManager.nodeSelector                             |'{}'                                        |object |
| rbacManager.affinity                                 |'{}'                                        |object |
| rbacManager.args                                     |'{}'                                        |object |
| rbacManager.deploy                                   |true                                        |boolean |
| rbacManager.leaderElection                           |true                                        |boolean |
| rbacManager.replicas                                 |1                                           |integer |
| rbacManager.skipAggregatedClusterRoles               |true                                        |boolean |
| rbacManager.tolerations                              |                                            |array |
| customAnnotations                                    |'{}'                                        |object   Custom annotations to add to the Crossplane deployment and pod |
| customLabels                                         |'{}'                                        |object   Custom labels to add into metadata |
| leaderElection                                       |true                                        |boolean |
| nodeSelector                                         |'{}'                                        |object |
| podSecurityContextCrossplane                         |'{}'                                        |object |
| webhooks.enabled                                     |false                                       |boolean |
| args                                                 |'{}'                                        |object |
| podSecurityContextRBACManager                        |'{}'                                        |object |
| provider.packages                                    |                                            |array |
| tolerations                                          |                                            |array |
| upbound.controlPlane.permission                      |edit                                        |string |
| affinity                                             |'{}'                                        |object |
| extraEnvVarsRBACManager                              |'{}'                                        |object   List of extra environment variables to set in the crossplane rbac manager deployment. EXAMPLE extraEnvironmentVars:   sample.key: value1   ANOTHER.KEY: value2 RESULT   - name: sample_key     value: "value1"   - name: ANOTHER_KEY value: "value2" |
| nameOverride                                         |crossplane                                  |string |
| priorityClassName                                    |""                                          |string |
