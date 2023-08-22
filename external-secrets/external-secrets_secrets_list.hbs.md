## external-secrets secrets list

Lists all external-secrets.io/v1beta1/ExternalSecret

### Synopsis

Lists all external-secrets.io/v1beta1/ExternalSecret and checks for the associated v1/Secret with the correct owner reference

```
external-secrets secrets list [flags]
```

### Examples

```

    # List external-secrets across all namespaces
    tanzu external-secrets list -A

    # List external-secrets from specified namespace
    tanzu external-secrets secrets list -n test-ns

    # List external-secrets in json output format
    tanzu external-secrets secret list -n test-ns -o json
```

### Options

```
  -A, --all-namespaces      View secrets in all namespaces, optional
  -h, --help                help for list
      --kubeconfig string   The path to the kubeconfig file, optional
  -n, --namespace string    Target namespace for the external secret, optional
  -o, --output string       Output format (yaml|json|table), optional
      --verbose int32       Number for the log level verbosity(0-9)
```

### SEE ALSO

* [external-secrets secrets](external-secrets_secrets.md)	 - Interacting with external-secrets.io ExternalSecrets

