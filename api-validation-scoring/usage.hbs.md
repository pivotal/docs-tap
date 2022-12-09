# Use API scoring and validation

You can use API scoring and validation to see how the API is auto-registered and scored in Tanzu Application Platform GUI. API scoring and validation also provides you with the recommendations about how to improve the scoring.

The following example describes how to API scoring and validation:

1. Create a workload for your application by running:

    ```console
    tanzu apps workload create -f filename -n namespace
    ```

    Expect to see the following output:

    ```console
    tanzu apps workload create -f petclininc-knative.yaml -n my-apps
    Create workload:
         1 + |---
         2 + |apiVersion: carto.run/v1alpha1
         3 + |kind: Workload
         4 + |metadata:
         5 + |  labels:
         6 + |    apis.apps.tanzu.vmware.com/register-api: "true"
         7 + |    app.kubernetes.io/part-of: petclinic-gk
         8 + |    apps.kubernetes.io/name: petclinic-gk
         9 + |    apps.tanzu.vmware.com/has-tests: "true"
        10 + |    apps.tanzu.vmware.com/workload-type: web
        11 + |  name: petclinic-gk
        12 + |  namespace: my-apps
        13 + |spec:
        14 + |  params:
        15 + |  - name: api_descriptor
        16 + |    value:
        17 + |      description: A set of API endpoints to manage the resources within the petclinic
        18 + |        app.
        19 + |      location:
        20 + |        path: /v3/api-docs
        21 + |      owner: team-petclinic
        22 + |      system: pet-clinics
        23 + |      type: openapi
        24 + |  source:
        25 + |    git:
        26 + |      ref:
        27 + |        branch: accelerator
        28 + |      url: https://github.com/LittleBaiBai/spring-petclinic.git

    ? Do you want to create this workload? Yes
    Created workload "petclinic-gk"

    To see logs:   "tanzu apps workload tail petclinic-gk --namespace my-apps"
    To get status: "tanzu apps workload get petclinic-gk --namespace my-apps"
    ```

    For more information, see [Use API Auto Registration](../api-auto-registration/usage.hbs.md).

2. Verify the workload is ready by running:

    ```console
    tanzu apps workload list -n NAMESPACE
    ```

    Expect to see the following output:

    ```console
    tanzu apps workload get petclinic-gk --namespace my-apps
    Overview
      name:   petclinic-gk
      type:   web

    Source
      type:     git
      url:      https://github.com/LittleBaiBai/spring-petclinic.git
      branch:   accelerator

    Supply Chain
      name:   source-test-scan-to-url

      RESOURCE           READY   HEALTHY   TIME    OUTPUT
      source-provider    True    True      6m57s   GitRepository/petclinic-gk
      source-tester      True    True      6m41s   Runnable/petclinic-gk
      source-scanner     True    True      6m14s   SourceScan/petclinic-gk
      image-provider     True    True      4m11s   Image/petclinic-gk
      image-scanner      True    True      3m32s   ImageScan/petclinic-gk
      config-provider    True    True      3m26s   PodIntent/petclinic-gk
      app-config         True    True      3m26s   ConfigMap/petclinic-gk
      service-bindings   True    True      3m26s   ConfigMap/petclinic-gk-with-claims
      api-descriptors    True    True      3m26s   ConfigMap/petclinic-gk-with-api-descriptors
      config-writer      True    True      3m17s   Runnable/petclinic-gk-config-writer

    Delivery
      name:   delivery-basic

      RESOURCE          READY   HEALTHY   TIME    OUTPUT
      source-provider   True    True      2m57s   ImageRepository/petclinic-gk-delivery
      deployer          True    True      2m51s   App/petclinic-gk

    Messages
      No messages found.

    Pods
      NAME                                   READY   STATUS      RESTARTS   AGE
      petclinic-gk-build-1-build-pod         0/1     Completed   0          6m15s
      petclinic-gk-config-writer-9gd2r-pod   0/1     Completed   0          3m27s
      petclinic-gk-xvv4d-test-pod            0/1     Completed   0          6m56s
      scan-petclinic-gk-fh5r8-h9vcx          0/1     Completed   0          4m12s
      scan-petclinic-gk-r79bb-45pk4          0/1     Completed   0          6m42s

    Knative Services
      NAME           READY   URL
      petclinic-gk   Ready   http://petclinic-gk.my-apps.tap.maz-0212-dp.tapdemo.vmware.com

    To see logs: "tanzu apps workload tail petclinic-gk --namespace my-apps"
    ```

3. Navigate to the Tanzu Application Platform GUI to view the newly created workloads.

    ![Screenshot of 'TAP workload List' ](assets/tap_list_workload.png)

4. Navigate to **Apis** and select the API.

    ![Screenshot of 'TAP API specifications catalog'](assets/tap_list_apis.png)

5. The **Overview** tab shows the API scoring and validation.

    ![Screenshot of 'TAP API spec details' page](assets/tap_desc_api.png)

    To view further details about the validation analysis and the recommendations, click **MORE DETAILS**.

    ![Screenshot of 'APIX API Specification details' page](assets/ui_apix_spec_details.png)
