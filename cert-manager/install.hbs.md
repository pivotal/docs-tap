# Install cert-manager

This topic tells you how to install cert-manager from the Tanzu Application Platform (commonly known as TAP) package repository.

>**Note** Follow the steps in this topic if you do not want to use a profile to install cert-manager. 
For more information about profiles, see [About Tanzu Application Platform components and profiles](../about-package-profiles.hbs.md).

The cert-manager package installs cert-manager and, optionally, a number of `ClusterIssuer`.

To install cert-manager with a self-signed `ClusterIssuer` from the Tanzu Application Platform package repository:

1. List version information for the package by running:

    ```console
    tanzu package available list cert-manager.tanzu.vmware.com -n tap-install
    ```

    For example:

    ```console
    $ tanzu package available list cert-manager.tanzu.vmware.com -n tap-install
    / Retrieving package versions for cert-manager.tanzu.vmware.com...
      NAME                           VERSION           RELEASED-AT
      cert-manager.tanzu.vmware.com  2.0.0             ...
    ```

2. Discover available configuration for the package by running:

    ```console
    tanzu package available get cert-manager.tanzu.vmware.com/2.0.0 --namespace tap-install --values-schema
    ```

    For example:

    ```console
    $ tanzu package available get cert-manager.tanzu.vmware.com/2.0.0 --namespace tap-install --values-schema

    KEY                   DEFAULT  TYPE    DESCRIPTION
    certManager.pspNames  []       array   PodSecurityPolicy names which cert-manager is allowed to use
    issuers               []       array   The ClusterIssuers to install - default: []
    namespace                      string  Cert-manager's namespace - also used as its cluster resource namespace
    https://cert-manager.io/v1.9-docs/faq/cluster-resource/
    ```

3. Create a file named `cert-manager-rbac.yaml` by using the following sample:

    ```yaml
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: cert-manager-tap-install-cluster-admin-role
    rules:
    - apiGroups:
      - '*'
      resources:
      - '*'
      verbs:
      - '*'
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: cert-manager-tap-install-cluster-admin-role-binding
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: cert-manager-tap-install-cluster-admin-role
    subjects:
    - kind: ServiceAccount
      name: cert-manager-tap-install-sa
      namespace: tap-install
    ---
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: cert-manager-tap-install-sa
      namespace: tap-install
    ```

    Apply the configuration:

    ```console
    kubectl apply -f cert-manager-rbac.yaml
    ```

4. Create a file named `cert-manager-install.yaml` by using the following sample:

    ```yaml
    ---
    apiVersion: packaging.carvel.dev/v1alpha1
    kind: PackageInstall
    metadata:
      name: cert-manager
      namespace: tap-install
    spec:
      serviceAccountName: cert-manager-tap-install-sa
      packageRef:
        refName: cert-manager.tanzu.vmware.com
        versionSelection:
          constraints: "VERSION-NUMBER"
          prereleases: {}
      values:
        - secretRef:
            name: cert-manager-values

    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: cert-manager-values
      namespace: tap-install
    stringData:
      values.yaml: |
        issuers:
          - name: tap-ingress-selfsigned
            self_signed: {}
    ```

    Where:

    - `VERSION-NUMBER` is the version of the package listed earlier.
    - Secret `cert-manager-values` contains your configuration of the cert-manager package.

    Apply the configuration:

    ```console
    kubectl apply -f cert-manager-install.yaml
    ```

5. Verify the package installation:

    ```console
    tanzu package installed get cert-manager -n tap-install
    ```

    For example:

    ```console
    $ tanzu package installed get cert-manager -n tap-install
    / Retrieving installation details for cert-manager...
    NAME:                    cert-manager
    PACKAGE-NAME:            cert-manager.tanzu.vmware.com
    PACKAGE-VERSION:         2.0.0
    STATUS:                  Reconcile succeeded
    CONDITIONS:              [{ReconcileSucceeded True}]
    USEFUL-ERROR-MESSAGE:
    ```

    Verify that `STATUS` is `Reconcile succeeded`

6. Verify that cert-manager is up and running:

    ```console
    kubectl get deployment -n cert-manager
    ```

    For example:

    ```console
    $ kubectl get deployment -n cert-manager
    NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
    cert-manager              1/1     1            1           5m
    cert-manager-cainjector   1/1     1            1           5m
    cert-manager-webhook      1/1     1            1           5m
    ```

7. Verify that the self-signed `ClusterIssuer` is present:

    ```console
    kubectl get clusterissuer
    ```

    For example:

    ```console
    $ kubectl get clusterissuer
    NAME                               READY   AGE
    tap-ingress-selfsigned             True    5m
    tap-ingress-selfsigned-bootstrap   True    5m
    ...
    ```
