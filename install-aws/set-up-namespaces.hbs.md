# Set up developer namespaces to use your installed packages

You can choose either one of the following two approaches to create a `Workload`
for your application by using the registry credentials specified,
add credentials and Role-Based Access Control (RBAC) rules to the namespace
that you plan to create the `Workload` in:

- [Enable single user access](#single-user-access).
- [Enable additional users access with Kubernetes RBAC](#additional-user-access).

## <a id='single-user-access'></a>Enable single user access

Follow these steps to enable your current user to submit jobs to the Supply Chain:

1. (Optional) If the variable `AWS_ACCOUNT_ID environment` is not set during the [installation](profile.hbs.md) process, export the AWS Account ID.

    ```console
    export AWS_ACCOUNT_ID=MY-AWS-ACCOUNT-ID
    ```

1. Run the following to add secrets, a service account to execute the supply chain, and RBAC rules
   to authorize the service account to the developer namespace:

    ```console
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
    cat <<EOF | kubectl -n YOUR-NAMESPACE apply -f -
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: default
      annotations:
        eks.amazonaws.com/role-arn: "arn:aws:iam::${AWS_ACCOUNT_ID}:role/tap-workload"
    imagePullSecrets:
      - name: tap-registry
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

    Where `YOUR-NAMESPACE` is your developer namespace.

## <a id='additional-user-access'></a>Enable additional users access with Kubernetes RBAC

Follow these steps to enable additional users by using Kubernetes RBAC to submit jobs to the Supply Chain:

1. [Enable single user access](#single-user-access).

1. Choose either of the following options to give developers namespace-level access and view access to appropriate cluster-level resources:

    - **Option 1:** Use the [Tanzu Application Platform RBAC CLI plug-in (beta)](../authn-authz/binding.hbs.md#install).

        To use the `tanzu rbac` plug-in to grant `app-viewer` and `app-editor` roles to an identity provider group, run:

        ```console
        tanzu rbac binding add -g GROUP-FOR-APP-VIEWER -n YOUR-NAMESPACE -r app-viewer
        tanzu rbac binding add -g GROUP-FOR-APP-EDITOR -n YOUR-NAMESPACE -r app-editor
        ```

        Where:

        - `YOUR-NAMESPACE` is the name you give to the developer namespace.
        - `GROUP-FOR-APP-VIEWER` is the user group from the upstream identity provider that requires access to `app-viewer` resources on the current namespace and cluster.
        - `GROUP-FOR-APP-EDITOR` is the user group from the upstream identity provider that requires access to `app-editor` resources on the current namespace and cluster.

        For more information about `tanzu rbac`, see
        [Bind a user or group to a default role](../authn-authz/binding.html).

        VMware recommends creating a user group in your identity provider's grouping system for each
        developer namespace and then adding the users accordingly.

        Depending on your identity provider, you might need to take further action to
        federate user groups appropriately with your cluster.
        For an example of how to set up Azure Active Directory (AD) with your cluster, see
        [Integrating Azure Active Directory](../authn-authz/azure-ad.html).

    - **Option 2:** Use the native Kubernetes YAML.

        To apply the RBAC policy, run:

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
        - `GROUP-FOR-APP-VIEWER` is the user group from the upstream identity provider that requires access to `app-viewer` resources on the current namespace and cluster.
        - `GROUP-FOR-APP-EDITOR` is the user group from the upstream identity provider that requires access to `app-editor` resources on the current namespace and cluster.

        VMware recommends creating a user group in your identity provider's grouping system for each
        developer namespace and then adding the users accordingly.

        Depending on your identity provider, you might need to take further action to
        federate user groups appropriately with your cluster.
        For an example of how to set up Azure Active Directory (AD) with your cluster, see
        [Integrating Azure Active Directory](../authn-authz/azure-ad.html).

        Rather than granting roles directly to individuals, VMware recommends using your identity provider's user groups system to grant access to a group of developers.
        For an example of how to set up Azure AD with your cluster, see
        [Integrating Azure Active Directory](../authn-authz/azure-ad.html).

1. (Optional) Log in as a non-admin user, such as a developer, to see the effects of RBAC after the bindings are applied.

## <a id='next-steps'></a>Next steps

- [Install Tanzu Developer Tools for your VS Code](../vscode-extension/install.html)
