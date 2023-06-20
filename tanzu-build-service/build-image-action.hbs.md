# Create a GitHub build action (Alpha)

This topic tells you how to use a GitHub action to create a Tanzu Build Service build on a cluster.

> **Important** Alpha features are experimental and are not ready for production use. Configuration
> and behavior is likely to change, and functionality might be removed in a future release.

## Prerequisites

- Ensure that [Tanzu Application Platform](../install-intro.hbs.md) is installed.

## Procedure

### Developer namespace

1. Create a developer namespace where the build resource will be created.

    ```bash
    kubectl create namespace DEVELOPER-NAMESPACE
    ```

2. Create a service account in the `DEVELOPER-NAMESPACE` that has access to the registry
credentials. This service account name will be used in the action.

### Access to Kubernetes API server

The GitHub action talks directly to the Kubernetes API server, if you are running this on github.com
with the default action runners, ensure that your API server is accessible from
GitHub's [IP ranges](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/about-githubs-ip-addresses).
Alternatively, it might be possible to run the action on a custom runner within your firewall
(with access to the Tanzu Application Platform cluster).

#### Permissions Required

These are the minimum permissions required on the Tanzu Build Service cluster:

    ```bash
    ClusterRole
     └ kpack.io
       └ clusterbuilders verbs=[get]
    Role (DEVELOPER NAMESPACE)
     ├ ''
     │ ├ pods verbs=[get watch list] ✔
     │ └ pods/log verbs=[get] ✔
     └ kpack.io
       └ builds verbs=[get watch list create delete] ✔
    ```

This example contains the minimum required permissions:

    ```yaml
    apiVersion: v1
    kind: Namespace
    metadata:
       name: DEVELOPER_NAMESPACE
    ---
    apiVersion: v1
    kind: ServiceAccount
    metadata:
       namespace: DEVELOPER_NAMESPACE
       name: github-actions
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
       name: github-actions
    subjects:
       - kind: ServiceAccount
         namespace: DEVELOPER_NAMESPACE
         name: github-actions
    roleRef:
       kind: ClusterRole
       name: github-actions
       apiGroup: rbac.authorization.k8s.io
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
       name: github-actions
       namespace: DEVELOPER_NAMESPACE
    subjects:
       - kind: ServiceAccount
         namespace: DEVELOPER_NAMESPACE
         name: github-actions
    roleRef:
       kind: Role
       name: github-actions
       apiGroup: rbac.authorization.k8s.io
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
       name: github-actions
    rules:
       - apiGroups: ['kpack.io']
         resources:
            - clusterbuilders
         verbs: ['get']
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
       name: github-actions
       namespace: DEVELOPER_NAMESPACE
    rules:
       - apiGroups: ['']
         resources: ['pods']
         verbs: ['get', 'watch', 'list']
       - apiGroups: ['']
         resources: ['pods/log']
         verbs: ['get']
       - apiGroups: ['kpack.io']
         resources:
            - builds
         verbs: ['get', 'watch', 'list', 'create', 'delete']
    ```

To access the values on Google Kubernetes Engine (steps might vary on other IaaS providers):

      ```console
      DEV_NAMESPACE=DEVELOPER_NAMESPACE
      SECRET=$(kubectl get sa github-actions -oyaml -n $DEV_NAMESPACE | yq '.secrets[0].name')

      CA_CERT=$(kubectl get secret $SECRET -oyaml -n $DEV_NAMESPACE | yq '.data."ca.crt"')
      NAMESPACE=$(kubectl get secret $SECRET -oyaml -n $DEV_NAMESPACE | yq .data.namespace | base64 -d)
      TOKEN=$(kubectl get secret $SECRET -oyaml -n $DEV_NAMESPACE | yq .data.token | base64 -d)
      SERVER=$(kubectl config view --minify | yq '.clusters[0].cluster.server')
      ```

Create the required secrets on the repository
through [GitHub.com](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository)
or through the `gh` CLI:

    ```bash
    gh secret set CA_CERT --app actions --body "$CA_CERT"
    gh secret set NAMESPACE --app actions --body "$NAMESPACE"
    gh secret set TOKEN --app actions --body "$TOKEN"
    gh secret set SERVER --app actions --body "$SERVER"
    ```

### Use the action

1. To use the action in a workflow, run the following YAML:

    ```yaml
    - uses: vmware-tanzu/build-image-action@v1-alpha
      with:
        ## Authorization
        # Host of the API server
        server: `$\{{ secrets.SERVER }}`
        # CA Certificate of the API Server
        ca_cert: `$\{{ secrets.CA_CERT }}`
        # Service Account token to access Kubernetes
        token: `$\{{ secrets.TOKEN }}`
        # _(required)_ The namespace to create the build resource in
        namespace: `$\{{ secrets.NAMESPACE }}`

        ## Image configuration
        # _(required)_ Destination for the built image
        # Example: gcr.io/<my-project>/<my-image>
        destination: ''
        # Optional list of build time environment variables
        env: ''
        # Name of the service account in the namespace, defaults to `default`
        serviceAccountName: ''
        # Name of the cluster builder to use, defaults to `default`
        clusterBuilder: ''
        # Max active time that the pod can run for in seconds, defaults to 3600
        timeout:
    ```

      For example:

    ```yaml
    - name: Build Image
      id: build
      uses: vmware-tanzu/build-image-action@v1-alpha
      with:
        # Authorization
        server: $\{{ secrets.SERVER }}
        token: $\{{ secrets.TOKEN }}
        ca_cert: $\{{ secrets.CA_CERT }}
        namespace: $\{{ secrets.NAMESPACE }}
        # Image configuration
        destination: gcr.io/project-id/name-for-image
        serviceAccountName: my-sa-that-has-access-to-reg-credentials
        env: |
          BP_JAVA_VERSION=17
    ```

2. The previous step should output the full name, including the SHA of the built image. To use the
output in a subsequent step:

    ```yaml
    - name: Do something with image
      run:
        echo "$\{{ steps.build.outputs.name }}"
    ```

## Debugging

To run this action in "debug" mode, add a secret called `ACTIONS_STEP_DEBUG` with the value set to
`true` as documented in the [GitHub Action Docs](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging).
