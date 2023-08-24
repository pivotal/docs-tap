## external-secrets secrets get

Get a specific external-secrets.io/v1beta1/ExternalSecret

### Synopsis

Get a specific external-secrets.io/v1beta1/ExternalSecret and it's correct owner reference

```
external-secrets secrets get [flags]
```

### Examples

```

# Get a specific external-secret from a specified namespace
tanzu external-secrets secrets get $EXTERNAL_SECRET_NAME  -n example-ns
	
# Get a specific external-secret from a specified namespace in json output format
tanzu external-secrets secret get $EXTERNAL_SECRET_NAME -n example-ns -o json
```

### Options

```
  -A, --all-namespaces      View secrets in all namespaces, optional
  -h, --help                help for get
      --kubeconfig string   The path to the kubeconfig file, optional
  -n, --namespace string    Target namespace for the external secret, optional
  -o, --output string       Output format (yaml|json|table), optional
      --verbose int32       Number for the log level verbosity(0-9)
```

### SEE ALSO

* [external-secrets secrets](external-secrets_secrets.md)	 - Interacting with external-secrets.io ExternalSecrets
