# External Secrets Operator (alpha)

>**Caution** External Secrets Operator is currently in alpha and is intended for evaluation and test purposes only. Do not use in a production environment.

The [External Secrets Operator](https://external-secrets.io) is a Kubernetes
operator that integrates with external secret management systems, for example Google
Secrets Manager and Hashicorp Vault. It reads information from external APIs and
automatically injects the values into a Kubernetes secret.

Starting with Tanzu Application Platform 1.4.0, Tanzu Application Platform repackages this open
source Kubernetes operator into a Carvel bundle that ships with Tanzu Application Platform.

Tanzu Application Platform's External Secrets package is alpha software and does not constitute an
entire solution.  VMware expects later Tanzu Application Platform releases to have a more comprehensive secret
management solution. Tanzu Application Platform 1.4.0 packages External Secrets Operator 0.6.1.

### Installing the External Secrets Operator

Tanzu Application Platform packages a version of the External Secrets Operator
that can be installed in the `tap-install` namespace.  The External Secrets
Operator is an optional Tanzu Application Platform component. It does not come installed with any of
the default Tanzu Application Platform profiles.

```sh
ESO_VERSION=0.6.1+tap.2
TAP_NAMESPACE=tap-install

tanzu package install external-secrets \
  --package-name external-secrets.apps.tanzu.vmware.com \
  --version "$ESO_VERSION" \
  --namespace "$TAP_NAMESPACE"
```

### Using the External Secrets Operator

Further instructions and guides for how to use the External Secrets Operator
can be found on the [External Secrets Operator site](https://external-secrets.io).
