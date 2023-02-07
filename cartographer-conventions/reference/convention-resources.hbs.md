## <a id="conv-service-resources"></a>Convention Service Resources

There are several resources involved in the application of conventions to workloads and these 
typically consumed by platform developers and operators rather than by application developers. 
The resources include the following 

+ [ClusterPodConvention](cluster-pod-convention.md) - 
  This is a `clusterpodconventions.conventions.carto.run` type resource. See example below.
  
  ```yaml
    ---
  apiVersion: conventions.carto.run/v1alpha1
  kind: ClusterPodConvention
  metadata:
    name: sample
  spec:
    selectorTarget: PodTemplateSpec # optional field with options, defaults to PodTemplateSpec
    selectors: # optional, defaults to match all workloads
    - <metav1.LabelSelector>
    webhook:
      certificate:
        name: sample-cert
        namespace: sample-conventions
      clientConfig: 
        <admissionregistrationv1.WebhookClientConfig>
  ```
 
  A platform developer can have a single ClusterPodConvention target a single or multiple workloads 
  or even have multiple conventions being applied to a different types of workloads. 
  The choice around how to apply conventions is solely at the discretion of the Conventions Author. 



+ [PodIntent](pod-intent.md) 

  This is a `podintents.conventions.carto.run` type resource. See example below.
  ```yaml
  apiVersion: conventions.carto.run/v1alpha1
  kind: PodIntent
  metadata:
    name: sample
  spec:
    imagePullSecrets: <[]corev1.LocalObjectReference> # optional
    serviceAccountName: <string> # optional, defaults to 'default'
    template:
      <corev1.PodTemplateSpec>
  status:
    observedGeneration: 1 # reflected from .metadata.generation
    conditions:
    - <metav1.Condition>
    template: # enriched PodTemplateSpec
      <corev1.PodTemplateSpec>
    ```  
  
  When a`PodIntent` is created, the `PodIntent` reconciler lists all `ClusterPodConventions` resources 
  and applies them serially. To ensure the consistency of the enriched [`PodTemplateSpec`](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec), the list of `ClusterPodConventions`is sorted alphabetically 
  by name before applying the conventions.
  
  
   >**Tip** : *You can use strategic naming to control the order in which the conventions are applied.*

  After the conventions are applied, the `Ready` status condition on the `PodIntent` resource is used 
  to indicate whether it is applied successfully.
  A list of all applied conventions is stored under the annotation `conventions.carto.run/applied-conventions`.

## <a id="collect-logs-from-ctrlr"></a>Collecting Logs from the Controller

  The convention controller is a Kubernetes operator and can be deployed in a cluster with other 
  components. If you have trouble, you can retrieve and examine the logs from the controller to help identify issues.

  To retrieve Pod logs from the `cartographer-conventions-controller-manage` running in the `cartographer-system` namespace:

  ```bash
   kubectl -n cartographer-system logs -l control-plane=controller-manager
  ```

For example:

  ```bash
  ...
  {"level":"info","ts":"2023-02-06T20:49:19.855086032Z","logger":"MetricsReconciler","msg":"reconciling builders configmap","controller":"configmap","controllerGroup":"","controllerKind":"ConfigMap","ConfigMap":{"name":"controller-manager-metrics-data","namespace":"cartographer-system"},"namespace":"cartographer-system","name":"controller-manager-metrics-data","reconcileID":"6f5e38c7-0ce0-4c74-aff3-f938fb742dab","diff":"  map[string]string{\n- \t\"clusterpodconventions_names\": \"appliveview-sample\",\n+ \t\"clusterpodconventions_names\": \"appliveview-sample\\nspring-boot-convention\",\n  \t\"podintents_count\":            \"0\",\n  }\n"}
  {"level":"info","ts":"2023-02-06T20:49:20.101742252Z","logger":"MetricsReconciler","msg":"reconciling builders configmap","controller":"configmap","controllerGroup":"","controllerKind":"ConfigMap","ConfigMap":{"name":"controller-manager-metrics-data","namespace":"cartographer-system"},"namespace":"cartographer-system","name":"controller-manager-metrics-data","reconcileID":"3a1950bc-4c55-47bb-8380-2de574bd5d5e","diff":"  map[string]string{\n  \t\"clusterpodconventions_names\": strings.Join({\n  \t\t\"appliveview-sample\\n\",\n+ \t\t\"developer-conventions\\n\",\n  \t\t\"spring-boot-convention\",\n  \t}, \"\"),\n  \t\"podintents_count\": \"0\",\n  }\n"}
  ...
  ```


****

## <a id="references"></a> References

+ [ImageConfig](image-config.md)
+ [PodConventionContextSpec](pod-convention-context-spec.md)
+ [PodConventionContextStatus](pod-convention-context-status.md)
+ [PodConventionContext](pod-convention-context.md)
+ [ClusterPodConvention](cluster-pod-convention.md)
+ [PodIntent](pod-intent.md)
+ [BOM](bom.md)
