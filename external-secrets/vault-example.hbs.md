# External Secrets Operator example integration with HashiCorp Vault

This topic shows you how External Secrets Operator can integrate with HashiCorp Vault, which is an external
secret Management System. The operator synchronizes secret data from external APIs to a Kubernetes
secret resource. For more information about Kubernetes secret resources, see the
[Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/secret).

> **Important** This example integration is constructed to showcase the features
> available and must not be considered in a production environment.

## <a id='eso-vault-prereqs'></a> Prerequisites

Before proceeding with this example, you must:

- Install External Secrets Operator. For more information, see
  [Install External Secrets Operator](install-external-secrets-operator.hbs.md).

- Install the Tanzu CLI. The Tanzu CLI includes the plug-in `external-secrets`.
  For Tanzu CLI installation, see [Tanzu CLI](../install-tanzu-cli.hbs.md).

- Have a running instance of HashiCorp Vault. In this instance, there is a secret defined with
  the key `eso-demo/reg-cred`.

## <a id='eso-vault-setup'></a> Set up the integration

To set up the External Secrets Operator integration with HashiCorp Vault:

1. Create a `Secret` with the vault token. For example:

    ```console
    VAULT_TOKEN="vault-token-value"

    cat <<EOF | kubectl apply -f -
    apiVersion: v1
    kind: Secret
    metadata:
    name: vault-token
    stringData:
    token: $VAULT_TOKEN
    EOF
    ```

1. Create a `SecretStore` resource referencing the `vault-token` secret. For example:

    > **Caution** When creating the `SecretStore`, ensure that you match the Vault KV secret engine version.
    > This is either `v1` or `v2`. The default is `v2`. For more information, see
    > Vault [KV Secrets Engine documentation](https://developer.hashicorp.com/vault/docs/secrets/kv).

    ```console
    VAULT_SERVER="http://my.vault.server:8200"
    VAULT_PATH="eso-demo"

    cat <<EOF | tanzu external-secrets store create -y -f -
    ---
    apiVersion: external-secrets.io/v1beta1
    kind: SecretStore
    metadata:
      name: vault-secret-store
    spec:
      provider:
        vault:
          server: $VAULT_SERVER
          path: $VAULT_PATH
          version: v2
          auth:
            tokenSecretRef:
              name: "vault-token" # vault-token created in the previous step
              key: "token"
    EOF
    ```

    > **Important** If you are using a secret store service with a custom CA certificate then you must
    > provide this certificate to External Secret Operator directly by including the CA `SecretStore` or
    > `ClusterSecretStore` resource.
    >
    > The Tanzu Application Platform distribution of External Secret Operator does not support the
    > Tanzu Application Platform field `shared.ca_cert_data`.
    > For more information about setting the CA in the ESO configuration, see the
    > [ESO documentation](https://external-secrets.io/v0.8.3/api/secretstore/).

1. Verify that the status of the `SecretStore` resource is `Valid` by running:

    ```console
    tanzu external-secrets store list
    ```

    Example output:

    ```console
    NAMESPACE  NAME                PROVIDER         STATUS
    default    vault-secret-store  Hashicorp Vault  Valid
    ```

1. Create an `ExternalSecret` resource that uses the `SecretStore` you just created by running:

    ```sh
    cat <<EOF | tanzu external-secrets secret create -y -f -
    ---
    apiVersion: external-secrets.io/v1beta1
    kind: ExternalSecret
    metadata:
      name: vault-secret-example
    spec:
      refreshInterval: 15m
      secretStoreRef:
        name: vault-secret-store
        kind: SecretStore
      target:
        name: registry-secret
        template:
          type: kubernetes.io/dockerconfigjson
          data:
            .dockerconfigjson: "\{{ .registryCred | toString }}"
        creationPolicy: Owner
      data:
      - secretKey: registryCred
        remoteRef:
          key: $VAULT_PATH/eso-demo
          property: reg-cred
    EOF
    ```

1. Verify that the status of the `ExternalSecret` resource is `Valid` by running:

    ```console
    tanzu external-secrets secret list
    ```

    Example output:

    ```console
    NAMESPACE  NAME                  SECRET NAME      STORE               REFRESH INTERVAL  STATUS             LAST UPDATED  LAST REFRESH
    default    vault-secret-example  registry-secret  vault-secret-store  15m               SecretSynced  21s           10m
    ```

1. After the resource has reconciled, a Kubernetes `secret` resource is created.
   Look for a secret named `registry-secret` created by the referenced `ExternalSecret`. For example:

    ```console
    kubectl get secrets registry-secret -o="jsonpath={.data.\.dockerconfigjson}" | base64 -D
    {"auths":{"my-registry.example:8200":{"username":"foo","password":"bar4","email":"foo@bar.example","auth":"Zm9vOmJhcjQ="}}}
    ```
