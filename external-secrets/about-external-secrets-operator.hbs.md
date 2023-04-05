# External Secrets Operator (beta)

>**Caution** The External Secrets plugin available in the Tanzu CLI list of plug-ins is in beta and 
is intended for evaluation and test purposes only. Do not use it in a production environment.

The [External Secrets Operator](https://external-secrets.io) is a Kubernetes
operator that integrates with external secret management systems, for example,
Google Secrets Manager and Hashicorp Vault. It reads information from external
APIs and automatically inject the values into a Kubernetes secret. Tanzu Application Platform makes
use of the [External Secrets Operator](https://external-secrets.io) to simplify Kubernetes secret 
lifecycle management. External Secrets Operator is available in TAP packages with a Carvel Package 
named `external-secrets.apps.tanzu.vmware.com`. It is *not* part of any install profile.

The `external-secrets` plug-in available in the Tanzu CLI interacts with the 
[External Secrets Operator](https://external-secrets.io) API. Users can use this CLI plug-in to 
create and view External Secrets Operator resources on a Kubernetes cluster. 

## <a id='abouteso'></a>Where to start

Refer to the official [External Secrets Operator](https://external-secrets.io) documentation to learn
more about managing secrets with External Secrets in general. For installing the External Secrets 
Operator and the CLI plug-in refer to the following documentation. Additionally, refer to the example
integration of External-Secrets with Hashicorp Vault. 

- [Installing External Secrets Operator in TAP](install-external-secrets-operator.hbs.md)
- [Installing Tanzu CLI](../prerequisites.hbs.md)
- [External-Secrets with Hashicorp Vault](vault-example.md)
