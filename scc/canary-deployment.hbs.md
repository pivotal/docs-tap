# Use Canary deployment with Contour and Carvel Packages for Supply Chain Choreographer (alpha)

Canary deployment is an incremental approach to releasing an application where traffic is divided between the existing deployed version and a new version.
It involves introducing the new version to a smaller group of users before extending it to the entire user base.
This topic outlines how to automate canary releases using Contour ingress controller and Flagger with Packages and PackageInstalls.

## <a id="prereqs"></a> Prerequisites

To use canary deployment, you must complete the following prerequisites:

- Complete the prerequisites in [Configure and deploy to multiple environments with custom parameters](config-deploy-multi-env.hbs.md).
- Configure your Supply Chain to output Carvel Packages. See [Output Carvel Packages from your Supply Chain](carvel-package-supply-chain.hbs.md).
- Deploy Carvel Packages using the tool of your choice:
  - [Deploy Carvel Packages using Carvel App CR](delivery-with-carvel-app.hbs.md)
  - [Deploy Carvel Packages using FluxCD Kustomization](delivery-with-flux.hbs.md)
  - [Deploy Carvel Packages using ArgoCD](delivery-with-argo.hbs.md)
- Install Flagger on your Kubernetes cluster. See [Flagger Install on Kubernetes](https://docs.flagger.app/install/flagger-install-on-kubernetes).

## <a id="instructions"></a> How to use Contour ingress controller and Flagger to create a canary release

Flagger is a tool that facilitates a controlled process of shifting traffic to a canary deployment while monitoring essential performance metrics
such as the success rate of HTTP requests, average request duration, and the health of the application's pods.
By analyzing these key indicators, Flagger determines whether to promote the canary deployment to a wider audience or
abort it if any issues arise.

For creating canary releases, you can refer to the guide available at [Contour Canary Deployments](https://docs.flagger.app/tutorials/contour-progressive-delivery).
In summary, the process explained in the guide above involves the following steps:

1. Install Flagger on your Kubernetes cluster.

2. Add the label `app.kubernetes.io/name` to your `Workload`.
   
    The target deployment must have a single label selector in the format `app: <DEPLOYMENT-NAME>`.
    In addition to `app`, Flagger supports `name` and `app.kubernetes.io/name` selectors.
    
    > **Note** You can use `tanzu apps workload apply <WORKLOAD-NAME> --label "app.kubernetes.io/name=<WORKLOAD-NAME>"` to modify an existing workload and add the required label.

3. Add HTTPProxy to the deployment.

4. Create a Canary resource that defines a canary release with progressive traffic shifting.
    
    To configure the Canary resource, you need to specify the Kubernetes Deployment that corresponds to your Workload.
    Ensure that you set `spec.targetRef.name` to match the name of your TAP Workload, which is the same as its Kubernetes Deployment name.

    Flagger will generate some Kubernetes objects. The primary deployment represents the stable release of your application.
    It receives all incoming traffic while the target deployment is scaled down to zero.
    Flagger actively monitors changes in the target deployment, including secrets and configmaps.
    Prior to promoting the new version as the primary release, Flagger conducts a thorough canary analysis to ensure its stability and performance.

    Within the Canary resource, you have the ability to define the canary analysis. This analysis definition is used by Flagger
    to determine the duration of the canary phase, which runs periodically until it reaches the maximum traffic weight or the specified number of iterations.
    During each iteration, Flagger executes webhooks, evaluates metrics, and checks for any exceeded failed checks threshold.
    If the threshold is surpassed, indicating potential issues, Flagger takes immediate action to halt the analysis and roll back the canary.
    In case where the no potential issues are found, Flagger rolls out the new version as the primary release.

5. Make changes to GitOps repository and observe the progressive delivery in action
   
    As changes are made to your GitOps repository, the GitOps tools in place in your environment, such as FluxCD and ArgoCD,
    will deploy the `Package`s onto your clusters. Flagger will detect any changes to the target deployment (including secrets and configmaps)
    and will start a new rollout. The new version will be either promoted or rolled back.

   You can monitor the traffic shifting with:

    ```shell
    watch kubectl get canary -n $WORKLOAD_NAMESPACE
    kubectl describe canary <CANARY-RESOURCE-NAME> -n $WORKLOAD_NAMESPACE
    ```

## <a id="canary-references"></a> References and further reading

* [Deployment Strategies](https://docs.flagger.app/usage/deployment-strategies)
* [Contour Canary Deployments](https://docs.flagger.app/tutorials/contour-progressive-delivery)
* [Flagger - How it works](https://docs.flagger.app/usage/how-it-works)
