## <a id="conv-service-resources"></a>Convention Service Resources

There are several resources involved in the application of conventions to workloads and these 
are typically consumed by platform developers and operators rather than by application developers. 

+ [ClusterPodConvention](cluster-pod-convention.md) 

  The following is an example `conventions.carto.run/v1alpha1` type:

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

  A `ClusterPodConvention` can target a one or more workloads of different types. 
  You can apply multiple conventions to a single workload. 
  It is at the discretion of the "Conventions Author" how a convention is applied.

  To list out available conventions in your cluster, run the following `kubectl`command 
    
    ```console 

    ❯ kubectl get clusterpodconventions.conventions.carto.run

      NAME                     AGE
      appliveview-sample       23h
      developer-conventions    23h
      spring-boot-convention   23h
    ```

+ [PodIntent](pod-intent.md) 

  The following is an example `conventions.carto.run/v1alpha1` resource:

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

  To list out available `PodIntent` resources in your cluster, run the following kubectl command
  
  ```console
   # specify relevant namespace
   kubectl get podintents.conventions.carto.run -n my-apps

    NAME            READY   REASON               AGE
    spring-sample   True    ConventionsApplied   8m5s
  ```

  When a`PodIntent` is created, the `PodIntent` reconciler lists all `ClusterPodConventions` resources 
  and applies them serially. To ensure that the consistency of the enriched [PodTemplateSpec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec), 
  the list of `ClusterPodConventions`is sorted alphabetically by name before applying the conventions.
  
  >**Tip** : *You can use strategic naming to control the order in which the conventions are applied.*

  After the conventions are applied, the `Ready` status condition on the `PodIntent` resource is used 
  to indicate whether it is applied.
  A list of all applied conventions is stored under the annotation `conventions.carto.run/applied-conventions`.

There are also a few other resources available to the `Conventions Author` that are not persisted in your cluster, including:

+ [ImageConfig](image-config.md)
+ [PodConventionContextSpec](pod-convention-context-spec.md)
+ [PodConventionContextStatus](pod-convention-context-status.md)
+ [PodConventionContext](pod-convention-context.md)
+ [BOM](bom.md)

## <a id="collect-logs-from-ctrlr"></a>Collecting Logs from the Controller

  A successful deployment of the convention service creates it's resources on the following `cartographer-system` namespace:

  ```console 
  ❯ kubectl get all -n cartographer-system
    NAME                                                               READY   STATUS    RESTARTS   AGE
    ...
    pod/cartographer-conventions-controller-manager-76fd86789f-lzh86   1/1     Running   0          20h

    NAME                                                                  TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
    ...
    service/cartographer-conventions-controller-manager-metrics-service   ClusterIP   10.0.250.231   <none>        8443/TCP   20h
    service/cartographer-conventions-webhook-service                      ClusterIP   10.0.6.254     <none>        443/TCP    20h
    ...

    NAME                                                          READY   UP-TO-DATE   AVAILABLE   AGE
    ...
    deployment.apps/cartographer-conventions-controller-manager   1/1     1            1           20h

    NAME                                                                     DESIRED   CURRENT   READY   AGE
    ...
    replicaset.apps/cartographer-conventions-controller-manager-76fd86789f   1         1         1       20h
  ```

  In order to examine logs from the cartographer conventions controller to help identify issues, inspect the cartographer conventions controller manager pod as follows  

  ```console
   kubectl -n cartographer-system logs -l control-plane=controller-manager
  ...
  {"level":"info","ts":"2023-02-06T20:49:19.855086032Z","logger":"MetricsReconciler","msg":"reconciling builders configmap","controller":"configmap","controllerGroup":"","controllerKind":"ConfigMap","ConfigMap":{"name":"controller-manager-metrics-data","namespace":"cartographer-system"},"namespace":"cartographer-system","name":"controller-manager-metrics-data","reconcileID":"6f5e38c7-0ce0-4c74-aff3-f938fb742dab","diff":"  map[string]string{\n- \t\"clusterpodconventions_names\": \"appliveview-sample\",\n+ \t\"clusterpodconventions_names\": \"appliveview-sample\\nspring-boot-convention\",\n  \t\"podintents_count\":            \"0\",\n  }\n"}
  {"level":"info","ts":"2023-02-06T20:49:20.101742252Z","logger":"MetricsReconciler","msg":"reconciling builders configmap","controller":"configmap","controllerGroup":"","controllerKind":"ConfigMap","ConfigMap":{"name":"controller-manager-metrics-data","namespace":"cartographer-system"},"namespace":"cartographer-system","name":"controller-manager-metrics-data","reconcileID":"3a1950bc-4c55-47bb-8380-2de574bd5d5e","diff":"  map[string]string{\n  \t\"clusterpodconventions_names\": strings.Join({\n  \t\t\"appliveview-sample\\n\",\n+ \t\t\"developer-conventions\\n\",\n  \t\t\"spring-boot-convention\",\n  \t}, \"\"),\n  \t\"podintents_count\": \"0\",\n  }\n"}
  ...
  ```