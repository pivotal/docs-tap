# Set up developer namespaces to use installed packages

To create a `Workload` for your application using the registry credentials specified,
run these commands to add credentials and Role-Based Access Control (RBAC) rules to the namespace
that you plan to create the `Workload` in:

1. Add read/write registry credentials to the developer namespace by running:

    ```console
    tanzu secret registry add registry-credentials --server REGISTRY-SERVER --username REGISTRY-USERNAME --password REGISTRY-PASSWORD --namespace YOUR-NAMESPACE
    ```

    Where:

    - `YOUR-NAMESPACE` is the name that you want to use for the developer namespace.
    For example, use `default` for the default namespace.
    - `REGISTRY-SERVER` is the URL of the registry. For Dockerhub, this must be
    `https://index.docker.io/v1/`. Specifically, it must have the leading `https://`, the `v1` path,
    and the trailing `/`. For GCR, this is `gcr.io`.
    Based on the information used in [Installing the Tanzu Application Platform Package and Profiles](install.md), you can use the
    same registry server as in `ootb_supply_chain_basic` - `registry` - `server`.
    - `REGISTRY-PASSWORD` is the password of the registry.
    For GCR or Google Artifact Registry, this must be the concatenated version of the JSON key. For example: `"$(cat ~/gcp-key.json)"`.

    **Note:** If you observe the following issue with the above command:

    ```console
    panic: runtime error: invalid memory address or nil pointer dereference
    [signal SIGSEGV: segmentation violation code=0x1 addr=0x128 pc=0x2bcce00]
    ```

    Use `kubectl` to create the secret:

    ```console
    kubectl create secret docker-registry registry-credentials --docker-server=REGISTRY-SERVER --docker-username=REGISTRY-USERNAME --docker-password=REGISTRY-PASSWORD -n YOUR-NAMESPACE
    ```

    >**Note:** If you install Tanzu Application Platform on AWS with EKS and use [IAM Roles for Kubernetes Service Accounts](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html) instead of secrets, this step is not required. You can specify the Role ARN in the next step.

2. Add secrets, a service account to execute the supply chain, and RBAC rules to authorize the service account to the developer namespace by running:

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

    >**Note:** If you install Tanzu Application Platform on AWS with EKS and use [IAM Roles for Kubernetes Service Accounts](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html), you must annotate the ARN of the IAM Role and remove the `registry-credentials` secret. Your service account entry will look like the following:

    ```
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: default
      annotations:
        eks.amazonaws.com/role-arn: <Role ARN>
    imagePullSecrets:
      - name: tap-registry
    ```

3. Perform one of the following actions to give developers namespace-level access and view access to appropriate cluster-level resources:

    * Use the `tanzu rbac` plug-in to grant `app-viewer` and `app-editor` roles to an identity provider group by running:

        ```console
        tanzu rbac binding add -g GROUP-FOR-APP-VIEWER -n YOUR-NAMESPACE -r app-viewer
        tanzu rbac binding add -g GROUP-FOR-APP-EDITOR -n YOUR-NAMESPACE -r app-editor
        ```

        Where:

        - `YOUR-NAMESPACE` is the name that you want to use for the developer namespace
        - `GROUP-FOR-APP-VIEWER` is the user group from the upstream identity provider that requires access to `app-viewer` resources on the current namespace and cluster
        - `GROUP-FOR-APP-EDITOR` is the user group from the upstream identity provider that requires access to `app-editor` resources on the current namespace and cluster

        For more information about `tanzu rbac`, see
        [Bind a user or group to a default role](authn-authz/binding.html).

        VMware recommends creating a user group in your identity provider's grouping system for each
        developer namespace, and then adding the users accordingly.

        Depending on your identity provider, you might need to take further action to
        federate user groups appropriately with your cluster.
        For an example of how to set up Azure Active Directory (AD) with your cluster, see
        [Integrating Azure Active Directory](authn-authz/azure-ad.html).

    * Apply the RBAC policy by running:

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

        - `YOUR-NAMESPACE` is the name that you want to use for the developer namespace
        - `GROUP-FOR-APP-VIEWER` is the user group from the upstream identity provider that requires access to `app-viewer` resources on the current namespace and cluster
        - `GROUP-FOR-APP-EDITOR` is the user group from the upstream identity provider that requires access to `app-editor` resources on the current namespace and cluster

        VMware recommends creating a user group in your identity provider's grouping system for each
        developer namespace, and then adding the users accordingly.

        Depending on your identity provider, you might need to take further action to
        federate user groups appropriately with your cluster.
        For an example of how to set up Azure AD with your cluster, see
        [Integrating Azure Active Directory](authn-authz/azure-ad.html).

        VMware recommends using your identity provider's user groups system to grant access to a
        group of developers, rather than granting roles directly to individuals.
        For an example of how to set up Azure AD with your cluster, see
        [Integrating Azure Active Directory](authn-authz/azure-ad.html).

4. (Optional) Log in as a non-admin user, such as a developer, to see the effects of RBAC after the bindings are applied.

## <a id='next-steps'></a>Next steps

For online installation:

- [Installing Tanzu Developer Tools for VS Code](vscode-extension/install.html)

For air-gapped installation:

- [Deploy your first air-gapped workload (beta)](getting-started/air-gap-workload.html)
