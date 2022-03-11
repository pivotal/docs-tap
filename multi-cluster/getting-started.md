# Getting Started with Multicluster Tanzu Application Platform 

The purpose of the below procedures is to validate the successful implementation of a multicluster topology by taking a small sample Workload and passing it through the Supply Chains that exist on the Build and Run clusters. There are numerous ways that the supply chain can be configured in this topology, but we're going to focus on validating the most basic capbilities. At the end of this documenation you should have a application that was build on the Build profile clusters and delivered to run on the Run profile clusters. This Workload and associated objects should be viewable from the Tanzu Application Platform GUI interface on the View profile cluster.

## <a id='prerequisites'></a> Prerequisites

1. In order to continue, you'll need to make sure you've completed the [installation steps for the 3 profiles](./installing-multicluster.md): Build, Run, and View. 
2. For the sample Workload we'll be using the same Application Accelerator - Tanzu Java Web App that is used in the non-multicluster [Getting Started](../getting-started.md) guide. You can download this accelerator and put it on your own Git infrastructure of choice (additional configuration may be necessary regarding permissions) or you can leverage the [sample-accelerators GitHub repository](https://github.com/sample-accelerators/tanzu-java-web-app).
3. The two Supply Chains that will be used here are on the Build profile: `ootb-supply-chain-basic` and on the Run profile: `ootb-delivery-basic`
4. For both the Build and Run profiled clusters, perform the [Setup Developer Namespace](../install-components.md#setup) steps. For the purposes of this guide, we'll assume that the `default` namespace was used.

## <a id='build-cluster'></a> Start the Workload on the Build Profile Cluster

1. The Build cluster will start things off by taking the Workload and building the necessary bundle that will then be delivered to the Run cluster to start.
2. Use the Tanzu CLI to start the Workload down the first Supply Chain:

```bash
tanzu apps workload create tanzu-java-web-app \
--git-repo https://github.com/sample-accelerators/tanzu-java-web-app \
--git-branch main \
--type web \
--label app.kubernetes.io/part-of=tanzu-java-web-app \
--yes \
--namespace YOUR-DEVELOPER-NAMESPACE
```

Where:

- `YOUR-DEVELOPER-NAMESPACE` is the namespace you [setup prior](../install-components.md#setup). For the purposes of this tutorial, `default` will be used.

3. You can now monitor the progress of this process using the command below. To exit the monitoring session you can use `CTRL+C`

```
tanzu apps workload tail tanzu-java-web-app --since 10m --timestamp --namespace YOUR-DEVELOPER-NAMESPACE
```

Where `YOUR-DEVELOPER-NAMESPACE` is the namespace you [setup prior](../install-components.md#setup). For the purposes of this tutorial, `default` will be used.

1. You'll now need to check that your supply chain has produced the necessary `Deliverable` for the `Workload`. This `Deliverable` contains the reference to the `source`, in this case a bundle that has been paced on the image registy you specified for the Supply Chain. The supply chains can also leverage Git repositories instead of ImageRepositories, but that's out-of-scope for this guide.

```bash
kubectl get deliverable --namespace YOUR-DEVELOPER-NAMESPACE
```

Where `YOUR-DEVELOPER-NAMESPACE` is the namespace you [setup prior](../install-components.md#setup). For the purposes of this tutorial, `default` will be used.

The output should look simiar to the following:

```bash
kubectl get deliverable --namespace default
NAME                 SOURCE                                                                                                                DELIVERY   READY   REASON             AGE
tanzu-java-web-app   tapmulticluster.azurecr.io/tap-multi-build-dev/tanzu-java-web-app-default-bundle:xxxx-xxxx-xxxx-xxxx-xxxxx              False   DeliveryNotFound   28h
```

5. Now that you see there's a `Deliver` on the build cluster, you can create a `Deliverable`. You'll need to dump the contents of this to a file that you can take to the Run profile cluster(s):

```bash
kubectl get deliverable tanzu-java-web-app --namespace YOUR-DEVELOPER-NAMEPACE -oyaml > deliverable.yaml
```
Where `YOUR-DEVELOPER-NAMESPACE` is the namespace you [setup prior](../install-components.md#setup). For the purposes of this tutorial, `default` will be used.

6. Now you can edit this deliverable yaml down to just the key sections. You'll want to **delete** the following sections:`ownerReferences` and `status`. After editing you should be left with something similar to the following:

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

7. Now that you have this `Deliverable` file, you can take it to the Run profile cluster(s) and run the following command:

```bash
kubectl apply -f deliverable.yaml --namespace YOUR-DEVELOPER-NAMEPACE
```

Where `YOUR-DEVELOPER-NAMESPACE` is the namespace you [setup prior](../install-components.md#setup). For the purposes of this tutorial, `default` will be used.

8. The next step is to check that this `Deliverable` has been started and is `Ready`. You can do this with the following command:

```bash
kubectl get deliverables --namespace YOUR-DEVELOPER-NAMEPACE
```

Where `YOUR-DEVELOPER-NAMESPACE` is the namespace you [setup prior](../install-components.md#setup). For the purposes of this tutorial, `default` will be used

The output should resemble the following:

```bash
kubectl get deliverables --namespace default
NAME                 SOURCE                                                                                                                DELIVERY         READY   REASON   AGE
tanzu-java-web-app   tapmulticloud.azurecr.io/tap-multi-build-dev/tanzu-java-web-app-default-bundle:xxxx-xxxx-xxxx-xxxx-1a7beafd6389   delivery-basic   True    Ready    7m2s
```

9. In order to test the application, you'll need to query the URL for the application. You can find this by looking for the `httpProxy`:

```bash
kubectl get httpproxy --namespace YOUR-DEVELOPER-NAMESPACE
```

You should see the URL similar to the below:

```bash
kubectl get httpproxy --namespace default
NAME                                                              FQDN                                                       TLS SECRET   STATUS   STATUS DESCRIPTION
tanzu-java-web-app-contour-a98df54e3629c5ae9c82a395501ee1fdtanz   tanzu-java-web-app.default.svc.cluster.local                            valid    Valid HTTPProxy
tanzu-java-web-app-contour-e1d997a9ff9e7dfb6c22087e0ce6fd7ftanz   tanzu-java-web-app.default.apps.run.multi.kapplegate.com                valid    Valid HTTPProxy
tanzu-java-web-app-contour-tanzu-java-web-app.default             tanzu-java-web-app.default                                              valid    Valid HTTPProxy
tanzu-java-web-app-contour-tanzu-java-web-app.default.svc         tanzu-java-web-app.default.svc                                          valid    Valid HTTPProxy
```

Select the URL that corresponds to the domain you specified in your Run cluster's profile and type it into a browser. You should see the message "Greetings from Spring Boot + Tanzu!". 

10. If you'd like to see the component in the Tanzu Application Platform GUI, you can [follow the steps to Register the Component](../tap-gui/catalog/catalog-operations.md#register-comp) using the [catalog file from the sample accelerator](https://github.com/sample-accelerators/tanzu-java-web-app/blob/main/catalog/catalog-info.yaml).