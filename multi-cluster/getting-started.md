# Getting started with multicluster Tanzu Application Platform

In this tutorial, we'll validate the successful implementation of a multicluster topology by taking a small sample workload and passing it through the supply chains on the Build and Run clusters. You can take various approaches to configuring the supply chain in this topology, but the following procedures validate the most basic capabilities.

The steps in this tutorial result in an application built on the Build profile clusters and delivered to run on the Run profile clusters. The workload and associated objects can then be viewed from the Tanzu Application Platform GUI interface on the View profile cluster.

## <a id='prerequisites'></a> Prerequisites

Before implementing a multicluster topology, complete the following: 

1. Complete all [installation steps for the 3 profiles](./installing-multicluster.md): Build, Run, and View.

1. For the sample workload, we use the same Application Accelerator - Tanzu Java Web App used in the non-multicluster [Getting Started](../getting-started.md) guide. You can download this accelerator and put it on your own Git infrastructure of choice. Additional configuration may be necessary regarding permissions. Otherwise, you can use the [sample-accelerators GitHub repository](https://github.com/sample-accelerators/tanzu-java-web-app).

1. The two supply chains used here are on the Build profile: `ootb-supply-chain-basic` and on the Run profile: `ootb-delivery-basic`. For both the Build and Run profiled clusters, perform the [Setup Developer Namespace](../install-components.md#setup) steps. This guide assumes that the `default` namespace is used.

1. To set the value of `DEVELOPER_NAMESPACE` to the appropriate namespace you setup in the previous step, run:

    ```bash
    export DEVELOPER_NAMESPACE=YOUR_DEVELOPER_NAMESPACE
    ```

    Where:
    
    - `YOUR-DEVELOPER-NAMESPACE` is the namespace you [set up prior](../install-components.md#setup). For the purposes of this tutorial, `default` is used.


## <a id='build-cluster'></a> Start the workload on the Build profile cluster

The Build cluster starts by building the necessary bundle for the workload that is delivered to the Run cluster.

1. Use the Tanzu CLI to start the workload down the first supply chain:

    ```bash
    tanzu apps workload create tanzu-java-web-app \
    --git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
    --git-branch main \
    --type web \
    --label app.kubernetes.io/part-of=tanzu-java-web-app \
    --yes \
    --namespace ${DEVELOPER_NAMESPACE}
    ```

1. To monitor the progress of this process, run:

    ```
    tanzu apps workload tail tanzu-java-web-app --since 10m --timestamp --namespace ${DEVELOPER_NAMESPACE}
    ```

1. To exit the monitoring session, press **CTRL**+**C**.

1. Check that your supply chain has produced the necessary `Deliverable` for the `Workload`. This `Deliverable` contains the reference to the `source`, in this case a bundle placed on the image registry you specified for the supply chain. The supply chains can also leverage Git repositories instead of ImageRepositories, but that's beyond the scope of this tutorial. To check for the `Deliverable`, run:

    ```bash
    kubectl get deliverable --namespace ${DEVELOPER_NAMESPACE}
    ```

    The output should look simiar to the following:

    ```bash
    kubectl get deliverable --namespace default
    NAME                 SOURCE                                                                                                                DELIVERY   READY   REASON             AGE
    tanzu-java-web-app   tapmulticluster.azurecr.io/tap-multi-build-dev/tanzu-java-web-app-default-bundle:xxxx-xxxx-xxxx-xxxx-xxxxx              False   DeliveryNotFound   28h
    ```

1. Now that you see there's a `Deliver` on the build cluster, you can create a `Deliverable`. Dump the contents of this to a file that you can take to the Run profile clusters:

    ```bash
    kubectl get deliverable tanzu-java-web-app --namespace ${DEVELOPER_NAMESPACE} -oyaml > deliverable.yaml
    ```

1. Edit this deliverable YAML to just the key sections. **Delete** the `ownerReferences` and `status` sections. After editing you are left with something similar to the following:

    ```yaml
    apiVersion: carto.run/v1alpha1
    kind: Deliverable
    metadata:
      creationTimestamp: "2022-03-10T14:35:52Z"
      generation: 1
      labels:
        app.kubernetes.io/component: deliverable
        app.kubernetes.io/part-of: tanzu-java-web-app
        app.tanzu.vmware.com/deliverable-type: web
        apps.tanzu.vmware.com/workload-type: web
        carto.run/cluster-template-name: deliverable-template
        carto.run/resource-name: deliverable
        carto.run/supply-chain-name: source-to-url
        carto.run/template-kind: ClusterTemplate
        carto.run/workload-name: tanzu-java-web-app
        carto.run/workload-namespace: default
      name: tanzu-java-web-app
      namespace: default
      resourceVersion: "635368"
      uid: xxxx-xxxx-xxxx-xxxx-xxxx
    spec:
      source:
        image: tapmulticluster.azurecr.io/tap-multi-build-dev/tanzu-java-web-app-default-bundle:xxxx-xxxx-xxxx-xxxx-xxxx
    ```

1. To take this `Deliverable` file to the **Run** profile clusters, run:

    ```bash
    kubectl apply -f deliverable.yaml --namespace ${DEVELOPER_NAMESPACE}
    ```

1. To check that this `Deliverable` is started and `Ready`, run:

    ```bash
    kubectl get deliverables --namespace ${DEVELOPER_NAMESPACE}
    ```

    The output resembles the following:

    ```bash
    kubectl get deliverables --namespace default
    NAME                 SOURCE                                                                                                                DELIVERY         READY   REASON   AGE
    tanzu-java-web-app   tapmulticloud.azurecr.io/tap-multi-build-dev/tanzu-java-web-app-default-bundle:xxxx-xxxx-xxxx-xxxx-1a7beafd6389   delivery-basic   True    Ready    7m2s
    ```

1. To test the application, query the URL for the application. Look for the `httpProxy` by running:

    ```bash
    kubectl get httpproxy --namespace ${DEVELOPER_NAMESPACE}
    ```

    The output resembles the following:

    ```bash
    kubectl get httpproxy --namespace default
    NAME                                                              FQDN                                                       TLS SECRET   STATUS   STATUS DESCRIPTION
    tanzu-java-web-app-contour-a98df54e3629c5ae9c82a395501ee1fdtanz   tanzu-java-web-app.default.svc.cluster.local                            valid    Valid HTTPProxy
    tanzu-java-web-app-contour-e1d997a9ff9e7dfb6c22087e0ce6fd7ftanz   tanzu-java-web-app.default.apps.run.multi.kapplegate.com                valid    Valid HTTPProxy
    tanzu-java-web-app-contour-tanzu-java-web-app.default             tanzu-java-web-app.default                                              valid    Valid HTTPProxy
    tanzu-java-web-app-contour-tanzu-java-web-app.default.svc         tanzu-java-web-app.default.svc                                          valid    Valid HTTPProxy
    ```

    Select the URL that corresponds to the domain you specified in your Run cluster's profile and type it into a browser. You should see the message "Greetings from Spring Boot + Tanzu!".

1. To see the component in the Tanzu Application Platform GUI, [follow the steps to Register the Component](../tap-gui/catalog/catalog-operations.md#register-comp) by using the [catalog file from the sample accelerator](https://github.com/sample-accelerators/tanzu-java-web-app/blob/main/catalog/catalog-info.yaml).
