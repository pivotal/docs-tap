# Install Source Controller

This topic tells you how to install Source Controller from the Tanzu Application Platform
(commonly known as TAP) package repository.

>**Note** Follow the steps in this topic if you do not want to use a profile to install Source Controller.
For more information about profiles, see [Components and installation profiles](../about-package-profiles.hbs.md).

## <a id='sc-prereqs'></a>Prerequisites

Before installing Source Controller:

- Complete all prerequisites to install Tanzu Application Platform. For more information, see [Prerequisites](../prerequisites.md).
- Install cert-manager on the cluster. For more information, see [Install cert-manager](../cert-manager/install.md).

## <a id='sc-install'></a> Install

To install Source Controller:

1. List version information for the package by running:

    ```shell
    tanzu package available list controller.source.apps.tanzu.vmware.com --namespace tap-install
    ```

    For example:

    ```shell
    $ tanzu package available list controller.source.apps.tanzu.vmware.com --namespace tap-install
    - Retrieving package versions for controller.source.apps.tanzu.vmware.com...
      NAME                                     VERSION  RELEASED-AT
      controller.source.apps.tanzu.vmware.com  0.3.1    2022-01-23 19:00:00 -0500 -05
      controller.source.apps.tanzu.vmware.com  0.3.2    2022-02-21 19:00:00 -0500 -05
      controller.source.apps.tanzu.vmware.com  0.3.3    2022-03-03 19:00:00 -0500 -05
      controller.source.apps.tanzu.vmware.com  0.4.1    2022-06-09 19:00:00 -0500 -05
      controller.source.apps.tanzu.vmware.com  0.9.0    2024-03-19 00:00:00 -0500 -05
    ```

2. (Optional) Gather the values schema:

    ```shell
    tanzu package available get controller.source.apps.tanzu.vmware.com/VERSION-NUMBER --values-schema --namespace tap-install
    ```

    Where `VERSION-NUMBER` is the version of the package listed in step 1 above.

    For example:

    ```shell
    tanzu package available get controller.source.apps.tanzu.vmware.com/0.9.0-build.2 --values-schema --namespace tap-install

      KEY               DEFAULT  TYPE    DESCRIPTION
      resources                          Optional: Tanzu Source Controller resource limit configuration
      aws_iam_role_arn  ""       string  Optional: Arn role that has access to pull images from ECR container registry
      ca_cert_data      ""       string  Optional: PEM Encoded certificate data for image registries with private CA.

    ```

3. (Optional) Create a file named `source-controller-values.yaml` to override the default installation
   settings. You can configure the following fields:

    - `ca_cert_data`: Enables Source Controller to connect to image registries that use self-signed
      or private certificate authorities.
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

    - `aws_iam_role_arn`: Annotates the Source Controller service with an AWS Identity and Access Management
      (IAM) role. This allows Source Controller to pull images from Amazon Elastic Container Registry (ECR).

        To add the AWS IAM role Amazon Resource Name (ARN) to the Source Controller service, add the ARN
        to `source-controller-values.yaml`. For example:

        ```yaml
        aws_iam_role_arn: "eks.amazonaws.com/role-arn: arn:aws:iam::112233445566:role/source-controller-manager"
        ```

    - `resources`: Allows you to update the default resource configuration for the Source Controller.
       By default, the Source Controller resource configuration is set as follows:

        ```yaml
        resources:
          limits:
            cpu: 100m
            memory: 512Mi
          requests:
            cpu: 100m
            memory: 20Mi
        ```

        To update the default resource configuration, add the configuration you require to
        `source-controller-values.yaml`. For example:

        ```yaml
        resources:
          limits:
            cpu: 100m
            memory: 1Gi
        ```

4. Install the package by running:

    ```shell
    tanzu package install source-controller \
      --package controller.source.apps.tanzu.vmware.com \
      --version VERSION-NUMBER \
      --namespace tap-install \
      --values-file VALUES-FILE
    ```

    Where:

    - `VERSION-NUMBER` is the version of the package listed in step 1 above.
    - `VALUES-FILE` is the path to the file created in step 3.

    For example:

    ```shell
    $ tanzu package install source-controller
        --package controller.source.apps.tanzu.vmware.com
        --version 0.9.0-build.2
        --namespace tap-install
        --values-file source-controller-values.yaml

    4:33:18PM: Creating service account 'source-controller-tap-install-sa'
    4:33:18PM: Creating cluster admin role 'source-controller-tap-install-cluster-role'
    4:33:18PM: Creating cluster role binding 'source-controller-tap-install-cluster-rolebinding'
    4:33:18PM: Creating secret 'source-controller-tap-install-values'
    4:33:18PM: Creating overlay secrets
    4:33:18PM: Creating package install resource
    4:33:18PM: Waiting for PackageInstall reconciliation for 'source-controller'
    4:33:18PM: Fetch started (2s ago)
    4:33:20PM: Fetching
          | apiVersion: vendir.k14s.io/v1alpha1
          | directories:
          | - contents:
          |   - imgpkgBundle:
          |       image: dev.registry.tanzu.vmware.com/tanzu-application-platform/constellation/controller.source.apps.tanzu.vmware.com@sha256:ed0925a9533aae0349107ada38c2a508a6ae4a855b89c3c1c5b4019b706fe1b4
          |     path: .
          |   path: "0"
          | kind: LockConfig
          |
    4:33:20PM: Fetch succeeded
    4:33:20PM: Template succeeded
    4:33:20PM: Deploy started (2s ago)
    4:33:22PM: Deploying
          | Target cluster 'https://10.96.0.1:443' (nodes: tap-local-control-plane)
          | Changes
          | Namespace      Name                                            Kind                            Age  Op      Op st.  Wait to    Rs  Ri
          | (cluster)      imagerepositories.source.apps.tanzu.vmware.com  CustomResourceDefinition        -    create  -       reconcile  -   -
          | ^              mavenartifacts.source.apps.tanzu.vmware.com     CustomResourceDefinition        -    create  -       reconcile  -   -
          | ^              source-app-viewer                               ClusterRole                     -    create  -       reconcile  -   -
          | ^              source-manager-role                             ClusterRole                     -    create  -       reconcile  -   -
          | ^              source-manager-rolebinding                      ClusterRoleBinding              -    create  -       reconcile  -   -
          | ^              source-metrics-reader                           ClusterRole                     -    create  -       reconcile  -   -
          | ^              source-proxy-role                               ClusterRole                     -    create  -       reconcile  -   -
          | ^              source-proxy-rolebinding                        ClusterRoleBinding              -    create  -       reconcile  -   -
          | ^              source-system                                   Namespace                       -    create  -       reconcile  -   -
          | ^              source-validating-webhook-configuration         ValidatingWebhookConfiguration  -    create  -       reconcile  -   -
          | source-system  reg-creds                                       Secret                          -    create  -       reconcile  -   -
          | ^              source-ca-certificates                          Secret                          -    create  -       reconcile  -   -
          | ^              source-controller-manager                       Deployment                      -    create  -       reconcile  -   -
          | ^              source-controller-manager                       ServiceAccount                  -    create  -       reconcile  -   -
          | ^              source-controller-manager-artifact-service      Service                         -    create  -       reconcile  -   -
          | ^              source-controller-manager-metrics-service       Service                         -    create  -       reconcile  -   -
          | ^              source-leader-election-role                     Role                            -    create  -       reconcile  -   -
          | ^              source-leader-election-rolebinding              RoleBinding                     -    create  -       reconcile  -   -
          | ^              source-manager-config                           ConfigMap                       -    create  -       reconcile  -   -
          | ^              source-selfsigned-issuer                        Issuer                          -    create  -       reconcile  -   -
          | ^              source-serving-cert                             Certificate                     -    create  -       reconcile  -   -
          | ^              source-webhook-service                          Service                         -    create  -       reconcile  -   -
          | Op:      22 create, 0 delete, 0 update, 0 noop, 0 exists
          | Wait to: 22 reconcile, 0 delete, 0 noop
          | 8:33:20PM: ---- applying 8 changes [0/22 done] ----
          | ...
          | 8:33:45PM: ok: reconcile deployment/source-controller-manager (apps/v1) namespace: source-system
          | 8:33:45PM: ---- applying complete [22/22 done] ----
          | 8:33:45PM: ---- waiting complete [22/22 done] ----
          | Succeeded
    4:33:45PM: Deploy succeeded
    ```

5. Verify the package installation by running:

    ```shell
    tanzu package installed get source-controller -n tap-install
    ```

    For example:

    ```shell
    tanzu package installed get source-controller -n tap-install
    NAMESPACE:          tap-install
    NAME:               source-controller
    PACKAGE-NAME:       controller.source.apps.tanzu.vmware.com
    PACKAGE-VERSION:    0.9.0-build.2
    STATUS:             Reconcile succeeded
    CONDITIONS:         - status: "True"
      type: ReconcileSucceeded
    ```

    Verify that `STATUS` is `Reconcile succeeded`:

    ```shell
    kubectl get pods -n source-system
    ```

    For example:

    ```shell
    $ kubectl get pods -n source-system
    NAME                                        READY   STATUS    RESTARTS   AGE
    source-controller-manager-f68dc7bb6-4lrn6   1/1     Running   0          100s
    ```

    Verify that `STATUS` is `Running`.
