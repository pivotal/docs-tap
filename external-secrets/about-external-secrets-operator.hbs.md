# Use External Secrets Operator in Tanzu Application Platform (beta)

The [External Secrets Operator](https://external-secrets.io) is a Kubernetes operator that integrates
with external secret management systems, for example, Google Secrets Manager and Hashicorp Vault.
It reads information from external APIs and automatically injects the values into a Kubernetes secret.

Tanzu Application Platform (commonly known as TAP) uses the
[External Secrets Operator](https://external-secrets.io) to simplify Kubernetes secret life cycle management.
The `external-secrets` plug-in, which is available in the Tanzu CLI, interacts with the
[External Secrets Operator](https://external-secrets.io) API. Users can use this CLI plug-in to
create and view External Secrets Operator resources on a Kubernetes cluster.

External Secrets Operator is available in Tanzu Application Platform packages with a Carvel Package
named `external-secrets.apps.tanzu.vmware.com`. It is not part of any installation profile.

>**Caution** The External Secrets plug-in is in beta and is intended for evaluation and test purposes only.
Do not use it in a production environment.

## <a id='abouteso'></a>Where to start

To learn more about managing secrets with External Secrets in general, see the official
[External Secrets Operator documentation](https://external-secrets.io).
For installing the External Secrets Operator and the CLI plug-in see the following documentation.
Also, see the example integration of External-Secrets with Hashicorp Vault.

- [Installing External Secrets Operator in TAP](install-external-secrets-operator.hbs.md)
- [Installing Tanzu CLI](../prerequisites.hbs.md)
- [External-Secrets with Hashicorp Vault](vault-example.md)
