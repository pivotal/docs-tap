# Install Cartographer Conventions

This topic tells you how to install Cartographer Conventions from the Tanzu Application Platform
(commonly known as TAP) package repository.

>**Note** Follow the steps in this topic if you do not want to use a profile to install Source Controller.
For more information about profiles, see [Components and installation profiles](../about-package-profiles.hbs.md).

## <a id='cc-prereqs'></a>Prerequisites

Before installing Source Controller:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- Install cert-manager on the cluster. For more information, see [Install cert-manager](../cert-manager/install.md).

## <a id='cc-install'></a> Install

To install Source Controller:

1. List version information for the package by running:

    ```shell
    tanzu package available list cartographer.conventions.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```shell
    $ tanzu package available list cartographer.conventions.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for cartographer.conventions.apps.tanzu.vmware.com...
      NAME                                            VERSION        RELEASED-AT
      cartographer.conventions.apps.tanzu.vmware.com  0.8.0-build.2  2024-02-27 10:22:43 -0500 EST
    ```

2. (Optional) Gather the values schema:

    ```shell
    tanzu package available get cartographer.conventions.apps.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed in step 1 above.

    For example:

    ```shell
    tanzu package available get cartographer.conventions.apps.tanzu.vmware.com/0.8.0-build.2 --values-schema --namespace tap-install

      KEY               DEFAULT  TYPE    DESCRIPTION
      aws_iam_role_arn  ""       string  Optional: Arn role that has access to pull images from ECR container registry
      ca_cert_data      ""       string  Optional: PEM Encoded certificate data for image registries with private CA.
      resources                          Optional: Cartographer Conventions controller resource limit configuration
    ```

3. (Optional) Create a file named `cartographer-conventions-values.yaml` to override the default installation
   settings. You can configure the following fields:

    - `ca_cert_data`: Enables Cartographer Conventions controller to connect to image registries 
      that use self-signed or private certificate authorities.
      If a certificate error `x509: certificate signed by unknown authority` occurs, use this option
      to trust additional certificate authorities.

        To provide a custom certificate, add the PEM-encoded CA certificate data to `source-controller-values.yaml`.
        For example:

        ```yaml
        ca_cert_data: |
            -----BEGIN CERTIFICATE-----
            MIICpTCCAYUCBgkqhkiG9w0BBQ0wMzAbBgkqhkiG9w0BBQwwDgQIYg9x6gkCAggA
            ...
            9TlA7A4FFpQqbhAuAVH6KQ8WMZIrVxJSQ03c9lKVkI62wQ==
            -----END CERTIFICATE-----
        ```

    - `aws_iam_role_arn`: Annotates the Cartographer Conventions controller service with an AWS 
       Identity and Access Management (IAM) role. This allows Cartographer Conventions controllerto 
       pull images from Amazon Elastic Container Registry (ECR).

        To add the AWS IAM role Amazon Resource Name (ARN) to the Cartographer Conventions controller 
        service, add the ARN to `cartographer-conventions-values.yaml`. For example:

        ```yaml
        aws_iam_role_arn: "eks.amazonaws.com/role-arn: arn:aws:iam::112233445566:role/cartographer-conventions-controller-manager"
        ```

    - `resources`: Allows updating the default resource configuration for the Cartographer Conventions controller.
       By default Cartographer Convention controller resource configuration is set as following:

       ```yaml
       resources:
         limits:
           cpu: 100m
           memory: 512Mi
         requests:
           cpu: 100m
           memory: 20Mi
       ```

         To update the controller's default resource configuration, add the desired configuration to 
         `cartographer-conventions-values.yaml`. For example:

         ```yaml
         resources:
           limits:
              cpu: 100m
              memory: 1Gi
         ```

4. Install the package by running:

    ```shell
    tanzu package install cartographer-conventions \
      --package cartographer.conventions.apps.tanzu.vmware.com \
      --version VERSION-NUMBER \
      --namespace tap-install \
      --values-file VALUES-FILE
    ```

    Where:

    - `VERSION-NUMBER` is the version of the package listed in step 1 above.
    - `VALUES-FILE` is the path to the file created in step 3.

    For example:

    ```shell
    $ tanzu package install cartographer-conventions
        --package cartographer.conventions.apps.tanzu.vmware.com
        --version 0.8.0-build.2
        --namespace tap-install
        --values-file cartogrpaher-conventions-values.yaml

    4:16:45PM: Creating service account 'cartographer-conventions-tap-install-sa'
    4:16:45PM: Creating cluster admin role 'cartographer-conventions-tap-install-cluster-role'
    4:16:45PM: Creating cluster role binding 'cartographer-conventions-tap-install-cluster-rolebinding'
    4:16:45PM: Creating secret 'cartographer-conventions-tap-install-values'
    4:16:45PM: Creating overlay secrets
    4:16:45PM: Creating package install resource
    4:16:45PM: Waiting for PackageInstall reconciliation for 'cartographer-conventions'
    4:16:45PM: Fetch started (3s ago)
    4:16:48PM: Fetching
            | apiVersion: vendir.k14s.io/v1alpha1
            | directories:
            | - contents:
            |   - imgpkgBundle:
            |       image: registry.tanzu.vmware.com/tanzu-application-platform/constellation/cartographer.conventions.apps.tanzu.vmware.com@sha256:c4bc900b883537f168f64ac6b725751752bcbe5cb522cd75abde96a1aa9cbfd5
            |     path: .
            |   path: "0"
            | kind: LockConfig
            |
    4:16:48PM: Fetch succeeded
    4:16:48PM: Template succeeded
    4:16:48PM: Deploy started (2s ago)
    4:16:50PM: Deploying
            | Target cluster 'https://10.96.0.1:443' (nodes: tap-local-control-plane)
            | Changes
            | Namespace           Name                                                         Kind                            Age  Op      Op st.  Wait to    Rs  Ri
            | (cluster)           cartographer-conventions-manager-role                        ClusterRole                     -    create  -       reconcile  -   -
            | ^                   cartographer-conventions-manager-rolebinding                 ClusterRoleBinding              -    create  -       reconcile  -   -
            | ^                   cartographer-conventions-mutating-webhook-configuration      MutatingWebhookConfiguration    -    create  -       reconcile  -   -
            | ^                   cartographer-conventions-proxy-role                          ClusterRole                     -    create  -       reconcile  -   -
            | ^                   cartographer-conventions-proxy-rolebinding                   ClusterRoleBinding              -    create  -       reconcile  -   -
            | ^                   cartographer-conventions-validating-webhook-configuration    ValidatingWebhookConfiguration  -    create  -       reconcile  -   -
            | ^                   clusterpodconventions.conventions.carto.run                  CustomResourceDefinition        -    create  -       reconcile  -   -
            | ^                   conventions-system                                           Namespace                       -    create  -       reconcile  -   -
            | ^                   podintents.conventions.carto.run                             CustomResourceDefinition        -    create  -       reconcile  -   -
            | conventions-system  cartographer-conventions-ca-certificates                     Secret                          -    create  -       reconcile  -   -
            | ^                   cartographer-conventions-controller-manager                  Deployment                      -    create  -       reconcile  -   -
            | ^                   cartographer-conventions-controller-manager                  ServiceAccount                  -    create  -       reconcile  -   -
            | ^                   cartographer-conventions-controller-manager-metrics-service  Service                         -    create  -       reconcile  -   -
            | ^                   cartographer-conventions-leader-election-role                Role                            -    create  -       reconcile  -   -
            | ^                   cartographer-conventions-leader-election-rolebinding         RoleBinding                     -    create  -       reconcile  -   -
            | ^                   cartographer-conventions-reg-creds                           Secret                          -    create  -       reconcile  -   -
            | ^                   cartographer-conventions-selfsigned-issuer                   Issuer                          -    create  -       reconcile  -   -
            | ^                   cartographer-conventions-serving-cert                        Certificate                     -    create  -       reconcile  -   -
            | ^                   cartographer-conventions-webhook-service                     Service                         -    create  -       reconcile  -   -
            | Op:      19 create, 0 delete, 0 update, 0 noop, 0 exists
            | Wait to: 19 reconcile, 0 delete, 0 noop
            | 8:16:48PM: ---- applying 7 changes [0/19 done] ----
            | ...
            | 8:17:07PM: ok: reconcile deployment/cartographer-conventions-controller-manager (apps/v1) namespace: conventions-system
            | 8:17:07PM: ---- applying complete [19/19 done] ----
            | 8:17:07PM: ---- waiting complete [19/19 done] ----
            | Succeeded
    4:17:07PM: Deploy succeeded
    ```

5. Verify the package installation by running:

    ```shell
    tanzu package installed get cartographer-conventions -n tap-install
    ```

    For example:

    ```shell
    tanzu package installed get cartographer-conventions -n tap-install
 
    NAMESPACE:          tap-install
    NAME:               cartographer-conventions
    PACKAGE-NAME:       cartographer.conventions.apps.tanzu.vmware.com
    PACKAGE-VERSION:    0.8.0-build.2
    STATUS:             Reconcile succeeded
    CONDITIONS:         - status: "True"
      type: ReconcileSucceeded
    ```

    Verify that `STATUS` is `Reconcile succeeded`:

    ```shell
    kubectl get pods -n conventions-system
    ```

    For example:

    ```shell
    $ kubectl get pods -n source-system
    NAME                                                         READY   STATUS    RESTARTS   AGE
    cartographer-conventions-controller-manager-6cc74788-2z2v9   1/1     Running   0          5m6s
    ```

    Verify that `STATUS` is `Running`.
