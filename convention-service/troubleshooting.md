# Troubleshooting

## Collecting logs from the controller

1. Identify the deployed `Pod` within the convention controller in the `conventions-system` namespace using:

    ```bash
    $ kubectl get pods -n conventions-system
 
      NAME                                              READY   STATUS    RESTARTS   AGE
      conventions-controller-manager-7bb95b64cf-74kdn   1/1     Running   1          10d
    ```

2. Retrieve the logs from the identified `Pod`:

   ```bash
   $ kubectl logs -n conventions-system conventions-controller-manager-7bb95b64cf-74kdn

    ...
    {"level":"info","ts":1637073467.3334172,"logger":"controllers.PodIntent.PodIntent.ApplyConventions","msg":"applied convention","diff":"  interface{}(\n- \ts\"&PodTemplateSpec{ObjectMeta:{      0 0001-01-01 00:00:00 +0000 UTC <nil> <nil> map[app.kubernetes.io/component:run app.kubernetes.io/part-of:spring-petclinic-app-db carto.run/workload-name:spring-petclinic-app-db] map[developer.conventions/target-container\"...,\n+ \tv1.PodTemplateSpec{\n+ \t\tObjectMeta: v1.ObjectMeta{\n+ \t\t\tLabels: map[string]string{\n+ \t\t\t\t\"app.kubernetes.io/component\": \"run\",\n+ \t\t\t\t\"app.kubernetes.io/part-of\":   \"spring-petclinic-app-db\",\n+ \t\t\t\t\"carto.run/workload-name\":     \"spring-petclinic-app-db\",\n+ \t\t\t\t\"tanzu.app.live.view\":         \"true\",\n+ \t\t\t\t...\n+ \t\t\t},\n+ \t\t\tAnnotations: map[string]string{\"developer.conventions/target-containers\": \"workload\"},\n+ \t\t},\n+ \t\tSpec: v1.PodSpec{Containers: []v1.Container{{...}}, ServiceAccountName: \"default\"},\n+ \t},\n  )\n","convention":"appliveview-sample"}
   ```
