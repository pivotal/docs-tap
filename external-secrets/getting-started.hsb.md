# External Secrets Operator ALPHA

The [External Secrets Operator](https://external-secrets.io) is a Kubernetes
operator that integrates with external secret management systems (e.g.: Google
Secrets Manager, Hashicorp Vault), reads information from external APIs, and
automatically injects the values into a Kubernetes Secret.

Starting with TAP 1.4.0, Tanzu Application Platform (TAP) repackages this open
source Kubernetes operator into a Carvel bundle that ships with TAP releases.

TAP's External Secrets package is ALPHA software and does not constitute an
entire solution.  Subsequent TAP releases will have a more comprehensive secret
management solution.

TAP 1.4.0 packages External Secrets Operator 0.6.1.

### Installing the External Secrets Operator 

Tanzu Application Platform packages a version of the External Secrets Operator
that can be installed in the `tap-install` namespace.  The External Secrets
Operator is an optional TAP component; it does not come installed with any of
the default TAP profiles.

```sh
ESO_VERSION=0.6.1+tap.2
TAP_NAMESPACE=tap-install

tanzu package install external-secrets \
  --package-name external-secrets.apps.tanzu.vmware.com \
  --version "$ESO_VERSION" \
  --namespace "$TAP_NAMESPACE"
```

### Using the External Secrets Operator

Further instructions and guides for how to use the External Secrets operator
can be found on the [External Secrets Operator site](https://external-secrets.io).
