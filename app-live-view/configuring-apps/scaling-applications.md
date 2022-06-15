# Scaling Knative apps in Tanzu Application Platform

This topic describes how to use Application Live View when scaling Knative apps or developer workloads in Tanzu Application Platform.

Application Live View is focused on monitoring apps for a `live` window and does not apply to any of the apps that are scaled down to zero. The intended behavior for Knative apps is to keep track of revisions to allow you to rollback easily, but also scale all of the unused revision instances down to zero to keep resource consumption low.

You can configure Knative apps to set `autoscaling.knative.dev/minScale` to `1` so that App Live View can still observe app instance. This ensures that there is at least one instance of the latest revision, while still scaling down the older instances.

You can configure any app in Tanzu Application Platform using the `Workload` resource. To scale a Knative app, add the annotation `autoscaling.knative.dev/minScale` in the `Workload` and set it to the value you want. For Application Live View to observe an app and have at least one instance of the latest revision, set `autoscaling.knative.dev/minScale = "1"`.

The annotations or labels in the `Workload` get propagated through the Tanzu Application Platform supply chain as follows:

Workload > PodIntent > ConfigMap > Push Config > to repository/registry > git-repository/imagerepository picks the Config from repository/registry > kapp-ctrl deploys and knative runs the config > final pod running on the Kubernetes cluster.


## <a id="config-dev-workloads"></a> Configure the developer workload in Tanzu Application Platform

The following YAML is an example `Workload` that adds the annotation `autoscaling.knative.dev/minScale = "1"` to set the minimum scale for the `spring-petclinic` app:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: spring-petclinic
  namespace: default
  labels:
    app.kubernetes.io/part-of: tanzu-java-web-app
    apps.tanzu.vmware.com/workload-type: web
  annotations:
    autoscaling.knative.dev/minScale: "1"
spec:
  source:
    git:
      ref:
        branch: main
      url: https://github.com/kdvolder/spring-petclinic
```

## <a id="deploy-workloads"></a> Deploy the workload

To deploy the workload, run:

```console
kapp -y deploy -n default -a workloads -f workloads.yaml
```

## <a id="verify-propagation"></a> Verify the annotation has propagated through the Supply Chain

To verify the annotation:

1. Verify that the workload build is successful by ensuring that `SUCCEEDED` is set to `True`:

    ```console
    kubectl get builds
    NAME                         IMAGE                                                                                                                                                 SUCCEEDED
    spring-petclinic-build-1     dev.registry.tanzu.vmware.com/app-live-view/test/spring-petclinic-default@sha256:9db2a8a8e77e9215239431fd8afe3f2ecdf09cce8afac565dad7b5f0c5ac0cdf     True
    ```

1. Verify the PodIntent of your workload by ensuring `status.template.metadata.annotations`
shows the newly added annotation has propagated through the Supply Chain:

    ```console
    kubectl get podintents.conventions.carto.run spring-petclinic -oyaml  

    status:
      conditions:
      - lastTransitionTime: "2021-12-03T15:14:33Z"
        status: "True"
        type: ConventionsApplied
      - lastTransitionTime: "2021-12-03T15:14:33Z"
        status: "True"
        type: Ready
      observedGeneration: 3
      template:
        metadata:
          annotations:
            autoscaling.knative.dev/minScale: "1"
    ```

1. Verify the ConfigMap was created for the app by ensuring `spec.template.metadata.annotations`
shows the newly added annotation has propagated through the Supply Chain:

    ```console
    kubectl describe configmap spring-petclinic
    Name:         spring-petclinic
    Namespace:    default
    Labels:       carto.run/cluster-supply-chain-name=source-to-url
                  carto.run/cluster-template-name=config-template
                  carto.run/resource-name=app-config
                  carto.run/template-kind=ClusterConfigTemplate
                  carto.run/workload-name=spring-petclinic
                  carto.run/workload-namespace=default
    Annotations:  <none>

    Data
    ====
    delivery.yml:
    ----
    apiVersion: serving.knative.dev/v1
    kind: Service
    metadata:
      name: spring-petclinic
      labels:
        app.kubernetes.io/part-of: tanzu-java-web-app
        apps.tanzu.vmware.com/workload-type: web
        kapp.k14s.io/app: "1638455805474051000"
        kapp.k14s.io/association: v1.5a9384bd7b93ca74ef494c4dec2caa4b
        tanzu.app.live.view: "false"
        app.kubernetes.io/component: run
        carto.run/workload-name: spring-petclinic
    spec:
      template:
        metadata:
          annotations:
            autoscaling.knative.dev/minScale: "1"
    ```

1. Verify the running Knative application pod by ensuring `annotations` shows the newly
added annotation on the Knative application pod:

    ```console
    kubectl get pods -o yaml spring-petclinic-00002-deployment-77dbb85c65-cf7rn | grep annotations
      annotations:
        kapp.k14s.io/original: '{"apiVersion":"carto.run/v1alpha1","kind":"Workload","metadata":{"annotations":{"autoscaling.knative.dev/minScale":"1"},"labels":{"app.kubernetes.io/part-of":"tanzu-java-web-app","apps.tanzu.vmware.com/workload-type":"web","kapp.k14s.io/app":"1638455805474051000","kapp.k14s.io/association":"v1.5a9384bd7b93ca74ef494c4dec2caa4b","tanzu.app.live.view":"false"},"name":"spring-petclinic","namespace":"default"},"spec":{"source":{"git":{"ref":{"branch":"main"},"url":"https://github.com/ksankaranara-vmw/spring-petclinic"}}}}'
    ```

Your Knative app is now set to a minimum scale of one so that Application Live View
can observe the instance of the app.
