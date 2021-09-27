# <a id='installing'></a> Prerequisites for Tanzu Application Platform

This document presents the prerequisites that you need to install Tanzu Application Platform.


## <a id='prereqs'></a>Prerequisites

The following prerequisites are required to install Tanzu Application Platform:

* A Kubernetes cluster (v1.19 or later) on one of the following Kubernetes providers:

    * Azure Kubernetes Service
    * Amazon Elastic Kubernetes Service
    * kind
    * minikube
    * Tanzu Kubernetes Grid v1.4.0 and later.
      > **Note:** Tanzu Kubernetes Grid v1.3 is not supported.
      If you want support for v1.3, please send feedback.

* The [kapp Carvel command line tool](https://github.com/vmware-tanzu/carvel-kapp/releases) (v0.37.0 or later)

* kapp-controller v0.24.0 or later:

    * For Azure Kubernetes Service, Amazon Elastic Kubernetes Service, kind, and minikube,
      Install kapp-controller by running:
      ```
      kapp deploy -a kc -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/KC-VERSION/release.yml
      ```
      Where `KC-VERSION` is the kapp-controller version being installed. Please select v0.24.0+ kapp-controller version from the [Releases page](https://github.com/vmware-tanzu/carvel-kapp-controller/releases).

      For example:
      ```
      kapp deploy -a kc -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/download/v0.24.0/release.yml
      ```

    * For Tanzu Kubernetes Grid, ensure that you are using Tanzu Kubernetes Grid v1.4.0 or later.
      Clusters of this version have kapp-controller v0.23.0 pre-installed.

    * To Verify installed kapp-controller version:

      1. Get kapp-controller deployment and namespace by running:


        ```
        kubectl get deployments -A | grep kapp-controller
        ```
        For example:
        ```
        kubectl get deployments -A | grep kapp-controller
        NAMESPACE                NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
        kapp-controller          kapp-controller                  1/1     1            1           25h   
        ```


      2. Get kapp controller version by running:


        ```
        kubectl get deployment KC-DEPLOYMENT -n KC-NAMESPACE -o yaml | grep kapp-controller.carvel.dev/version
        ```

        Where `KC-DEPLOYMENT` and `KC-NAMESPACE` are kapp-controller deployment name and kapp-controller namespace name respectively from the output of step a.

        For example:

        ```
        kubectl get deployment kapp-controller -n kapp-controller  -o yaml | grep kapp-controller.carvel.dev/version
        kapp-controller.carvel.dev/version: v0.24.0
        kapp.k14s.io/original: '{"apiVersion":"apps/v1","kind":"Deployment","metadata":{"annotations":{"kapp-controller.carvel.dev/version":"v0.24.0","kbld.k14s.io/images":"-
        ```


* secretgen-controller v0.5.0 or later:

    * Install secretgen-controller by running:

      ```
      kapp deploy -a sg -f https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/download/SG-VERSION/release.yml
      ```

      Where `SG-VERSION` is the secretgen-controller version being installed. Please select v0.5.0+ secretgen-controller version from the [Releases page](https://github.com/vmware-tanzu/carvel-secretgen-controller/releases).

      For example:
      ```
      kapp deploy -a sg -f https://github.com/vmware-tanzu/carvel-secretgen-controller/releases/download/v0.5.0/release.yml
      ```

    * To Verify installed secretgen-controller version:

      1. Get secretgen-controller deployment and namespace by running:


        ```
        kubectl get deployments -A | grep secretgen-controller
        ```
        For example:
        ```
        kubectl get deployments -A | grep secretgen-controller
        NAMESPACE                NAME                             READY   UP-TO-DATE   AVAILABLE   AGE
        secretgen-controller     secretgen-controller             1/1     1            1           22d   
        ```

      2. Get secretgen-controller version by running:


        ```
        kubectl get deployment SG-DEPLOYMENT -n SG-NAMESPACE -o yaml | grep secretgen-controller.carvel.dev/version
        ```
        Where `SG-DEPLOYMENT` and `SG-NAMESPACE` are secretgen-controller deployment name and secretgen-controller namespace name respectively from the output of step a.

        For example:

        ```
        kubectl get deployment secretgen-controller -n secretgen-controller -oyaml | grep secretgen-controller.carvel.dev/version
        secretgen-controller.carvel.dev/version: v0.5.0
        ```


* The Kubernetes command line tool, kubectl, v1.19 or later, installed and authenticated with administrator rights for your target cluster.

* For Tanzu Kubernetes Grid, the minimum cluster configuration is as follows:

    * Tanzu Kubernetes Grid on vSphere:
      <table class="nice">
        <tr>
          <td>Deployment Type:</td>
          <td>Dev, Prod</td>
        </tr>
        <tr>
          <td>Instance type:</td>
          <td>Medium (2 vCPUs, 8&nbsp;GiB memory)</td>
        </tr>
        <tr>
          <td>Number of worker nodes:</td>
          <td>3</td>
        </tr>
       </table>

    * Tanzu Kubernetes Grid on Azure:
      <table class="nice">
        <tr>
          <td>Deployment Type:</td>
          <td>Dev, Prod</td>
        </tr>
        <tr>
          <td>Instance type:</td>
          <td>Standard D2s v3 (2 vCPUs, 8&nbsp;GiB memory)</td>
        </tr>
        <tr>
          <td>Number of worker nodes:</td>
          <td>3</td>
        </tr>
        </table>

    * Tanzu Kubernetes Grid on AWS:
      <table class="nice">
        <tr>
          <td>Deployment Type:</td>
          <td>Dev, Prod</td>
          </tr>
        <tr>
          <td>Instance type:</td>
          <td>t2.large (2 vCPUs, 8&nbsp;GiB memory)</td>
        </tr>
        <tr>
          <td>Number of worker nodes:</td>
          <td>3</td>
        </tr>
      </table>

