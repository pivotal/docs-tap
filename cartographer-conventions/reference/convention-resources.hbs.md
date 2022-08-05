# Convention Resources

The convention controller is open to extension. These resources are typically consumed by platform developers and operators rather than by application developers.

## <a id="conv-service-resources"></a>Convention Service Resources

There are several [resources](convention-resources.md) involved in the application of conventions to workloads.

### <a id="api-structure"></a>API Structure

The [`PodConventionContext`](pod-convention-context.md) API object in the `webhooks.conventions.carto.run` API group is the structure used for both request and response from the convention server.

### <a id="template-status"></a>Template Status

The enriched `PodTemplateSpec` is reflected at [`.status.template`](pod-convention-context-status.md). For more information about `PodTemplateSpec`, see the [Kubernetes documentation](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec).

## <a id="chain-multi-conventions"></a>Chaining Multiple Conventions

You can define multiple `ClusterPodConventions` and apply them to different types of workloads.
You can also apply multiple conventions to a single workload.

The `PodIntent` reconciler lists all `ClusterPodConvention` resources and applies them serially.
To ensure the consistency of enriched [`PodTemplateSpec`](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-template-v1/#PodTemplateSpec),
the list of `ClusterPodConventions`is sorted alphabetically by name before applying conventions.
You can use strategic naming to control the order in which the conventions are applied.

After the conventions are applied, the `Ready` status condition on the `PodIntent` resource is used to indicate
whether it is applied successfully.
A list of all applied conventions is stored under the annotation `conventions.carto.run/applied-conventions`.

## <a id="collect-logs-from-ctrlr"></a>Collecting Logs from the Controller

The convention controller is a Kubernetes operator and can be deployed in a cluster with other components. If you have trouble, you can retrieve and examine the logs from the controller to help identify issues.

To retrieve Pod logs from the `conventions-controller-manager` running in the `conventions-system` namespace:

  ```console
  kubectl -n conventions-system logs -l control-plane=controller-manager
  ```

For example:

  ```console
  ...
  {"level":"info","ts":1637073467.3334172,"logger":"controllers.PodIntent.PodIntent.ApplyConventions","msg":"applied convention","diff":"  interface{}(\n- \ts\"&PodTemplateSpec{ObjectMeta:{      0 0001-01-01 00:00:00 +0000 UTC <nil> <nil> map[app.kubernetes.io/component:run app.kubernetes.io/part-of:spring-petclinic-app-db carto.run/workload-name:spring-petclinic-app-db] map[developer.conventions/target-container\"...,\n+ \tv1.PodTemplateSpec{\n+ \t\tObjectMeta: v1.ObjectMeta{\n+ \t\t\tLabels: map[string]string{\n+ \t\t\t\t\"app.kubernetes.io/component\": \"run\",\n+ \t\t\t\t\"app.kubernetes.io/part-of\":   \"spring-petclinic-app-db\",\n+ \t\t\t\t\"carto.run/workload-name\":     \"spring-petclinic-app-db\",\n+ \t\t\t\t\"tanzu.app.live.view\":         \"true\",\n+ \t\t\t\t...\n+ \t\t\t},\n+ \t\t\tAnnotations: map[string]string{\"developer.conventions/target-containers\": \"workload\"},\n+ \t\t},\n+ \t\tSpec: v1.PodSpec{Containers: []v1.Container\{{...}}, ServiceAccountName: \"default\"},\n+ \t},\n  )\n","convention":"appliveview-sample"}
  ...
  ```


****

## <a id="references"></a> References

+ [ImageConfig](image-config.md)
+ [PodConventionContextSpec](pod-convention-context-spec.md)
+ [PodConventionContextStatus](pod-convention-context-status.md)
+ [PodConventionContext](pod-convention-context.md)
+ [Cluster Pod Convention](cluster-pod-convention.md)
+ [PodIntent](pod-intent.md)
+ [BOM](bom.md)
