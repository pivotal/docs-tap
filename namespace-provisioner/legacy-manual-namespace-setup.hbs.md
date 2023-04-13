# Legacy manual developer namespace setup instructions

Using [Namespace Provisioner](about.hbs.md) is the recommended best practice for setting up
developer namespaces on Tanzu Application Platform.

To provision namespaces manually, complete the following steps:

1. [Enable single user access](#single-user-access).

2. (Optional) [Enable additional users with Kubernetes RBAC](#additional-user-access).

## <a id='single-user-access'></a>Enable single user access

1. To add read/write registry credentials to the developer namespace, run the following command:

    ```console
    tanzu secret registry add registry-credentials --server REGISTRY-SERVER --username REGISTRY-USERNAME --password REGISTRY-PASSWORD --namespace YOUR-NAMESPACE
    ```

    Where:

    - `YOUR-NAMESPACE` is the name you give to the developer namespace. For example, use
     `default` for the default namespace.
    - `REGISTRY-SERVER` is the URL of the registry. You can use the same registry server as in
     `ootb_supply_chain_basic` - `registry` - `server`. For more information, see
     [Install Tanzu Application Platform package and profiles](../install.hbs.md).
      - For Docker Hub, the value is `https://index.docker.io/v1/`. It must have the leading
      `https://`, the `v1` path, and the trailing `/`.
      - For Google Container Registry (GCR), the value is `gcr.io`.
    - `REGISTRY-PASSWORD` is the password of the registry.
      - For GCR or Google Artifact Registry, this must be the concatenated version of the JSON key. For example: `"$(cat ~/gcp-key.json)"`

    If you observe the following issue:

    ```console
    panic: runtime error: invalid memory address or nil pointer dereference
   [signal SIGSEGV: segmentation violation code=0x1 addr=0x128 pc=0x2bcce00]
    ```

    Use kubectl to create the secret instead:

   ```console
    kubectl create secret docker-registry registry-credentials --docker-server=REGISTRY-SERVER --docker-username=REGISTRY-USERNAME --docker-password=REGISTRY-PASSWORD -n YOUR-NAMESPACE
    ```

    >**Note** This step is not required if you install Tanzu Application Platform on AWS with EKS
    and use [IAM Roles for Kubernetes Service Accounts](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html) instead of secrets.
    You can specify the Role Amazon Resource Name (ARN) in the next step.

2. Run the following to add secrets, a service account to execute the supply chain, and RBAC rules
   to authorize the service account to the developer namespace:

    ```console
    cat <<EOF | kubectl -n YOUR-NAMESPACE apply -f -
    apiVersion: v1
    kind: Secret
    metadata:
      name: tap-registry
      annotations:
        secretgen.carvel.dev/image-pull-secret: ""
    type: kubernetes.io/dockerconfigjson
    data:
      .dockerconfigjson: e30K
    ---
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: default
    secrets:
      - name: registry-credentials
    imagePullSecrets:
      - name: registry-credentials
      - name: tap-registry
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: default-permit-deliverable
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: deliverable
    subjects:
      - kind: ServiceAccount
        name: default
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: default-permit-workload
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: workload
    subjects:
      - kind: ServiceAccount
        name: default
    EOF
    ```

    >**Note** If you install Tanzu Application Platform on AWS with EKS and use
    [IAM Roles for Kubernetes Service Accounts](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html),
    you must annotate the ARN of the IAM Role and remove the `registry-credentials` secret. Your
    service account entry then looks like the following:

    ```console
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: default
      annotations:
        eks.amazonaws.com/role-arn: <Role ARN>
    imagePullSecrets:
      - name: tap-registry
    ```

## <a id='additional-user-access'></a>Enable additional users with Kubernetes RBAC

Follow these steps to enable additional users in your namespace by using Kubernetes RBAC:

1. Before you begin, ensure that you have [enabled single user access](#single-user-access).
2. Choose either of the following options to give developers namespace-level access and view access
   to the appropriate cluster-level resources:

    - **Option 1:** Use the [Tanzu Application Platform RBAC CLI plug-in (beta)](../authn-authz/binding.hbs.md#install).

        To use the `tanzu rbac` plug-in to grant `app-viewer` and `app-editor` roles to an identity
        provider group, run:

        ```console
        tanzu rbac binding add -g GROUP-FOR-APP-VIEWER -n YOUR-NAMESPACE -r app-viewer
        tanzu rbac binding add -g GROUP-FOR-APP-EDITOR -n YOUR-NAMESPACE -r app-editor
        ```

        Where:

        - `YOUR-NAMESPACE` is the name you give to the developer namespace.
        - `GROUP-FOR-APP-VIEWER` is the user group from the upstream identity provider that
          requires access to `app-viewer` resources on the current namespace and cluster.
        - `GROUP-FOR-APP-EDITOR` is the user group from the upstream identity provider that
          requires access to `app-editor` resources on the current namespace and cluster.

        For more information about `tanzu rbac`, see
        [Bind a user or group to a default role](../authn-authz/binding.hbs.md)

        VMware recommends creating a user group in your identity provider's grouping system for each
        developer namespace and then adding the users accordingly.

        Depending on your identity provider, you might need to take further action to
        federate user groups appropriately with your cluster.
        For an example of how to set up Azure Active Directory (Azure AD) with your cluster, see
        [Integrate Azure Active Directory](../authn-authz/azure-ad.hbs.md).

    - **Option 2:** Use the native Kubernetes YAML.

        Run the following to apply the RBAC policy:

        ```console
        cat <<EOF | kubectl -n YOUR-NAMESPACE apply -f -
        apiVersion: rbac.authorization.k8s.io/v1
        kind: RoleBinding
        metadata:
          name: dev-permit-app-viewer
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: ClusterRole
          name: app-viewer
        subjects:
          - kind: Group
            name: GROUP-FOR-APP-VIEWER
            apiGroup: rbac.authorization.k8s.io
        ---
        apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRoleBinding
        metadata:
          name: YOUR-NAMESPACE-permit-app-viewer
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: ClusterRole
          name: app-viewer-cluster-access
        subjects:
          - kind: Group
            name: GROUP-FOR-APP-VIEWER
            apiGroup: rbac.authorization.k8s.io
        ---
        apiVersion: rbac.authorization.k8s.io/v1
        kind: RoleBinding
        metadata:
          name: dev-permit-app-editor
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: ClusterRole
          name: app-editor
        subjects:
          - kind: Group
            name: GROUP-FOR-APP-EDITOR
            apiGroup: rbac.authorization.k8s.io
        ---
        apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRoleBinding
        metadata:
          name: YOUR-NAMESPACE-permit-app-editor
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: ClusterRole
          name: app-editor-cluster-access
        subjects:
          - kind: Group
            name: GROUP-FOR-APP-EDITOR
            apiGroup: rbac.authorization.k8s.io
        EOF
        ```

        Where:

        - `YOUR-NAMESPACE` is the name you give to the developer namespace.
        - `GROUP-FOR-APP-VIEWER` is the user group from the upstream identity provider that
          requires access to `app-viewer` resources on the current namespace and cluster.
        - `GROUP-FOR-APP-EDITOR` is the user group from the upstream identity provider that
          requires access to `app-editor` resources on the current namespace and cluster.

        VMware recommends creating a user group in your identity provider's grouping system for
        each developer namespace and then adding the users accordingly.

        Depending on your identity provider, you might need to take further action to
        federate user groups appropriately with your cluster.

        Rather than granting roles directly to individuals, VMware recommends using your identity
        provider's user groups system to grant access to a group of developers.

        For an example of how to set up Azure Active Directory (AD) with your cluster, see
        [Integrate Azure Active Directory](../authn-authz/azure-ad.hbs.md).

3. (Optional) Log in as a non-admin user, such as a developer, to see the effects of RBAC after the
   role bindings are applied.

## Additional configuration for testing and scanning

If you plan to install Out of the Box Supply Chains with Testing and Scanning, see [Developer Namespace](../scc/ootb-supply-chain-testing.hbs.md#developer-namespace).
