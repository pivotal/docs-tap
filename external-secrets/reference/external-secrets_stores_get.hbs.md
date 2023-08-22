## external-secrets stores get

Get a  specific external-secrets.io/v1beta1/SecretStore

### Synopsis

Get a specific external-secrets.io/v1beta1/SecretStore

```
external-secrets stores get [flags]
```

### Examples

```

# Get external-secret-store from specified namespace
tanzu external-secrets stores get $SECRET_STORE_NAME  -n test-ns
	
# Get external-secret-store in json output format
tanzu external-secrets stores get  $SECRET_STORE_NAME -n test-ns -o json
```

### Options

```
  -A, --all-namespaces      View secrets in all namespaces, optional
  -h, --help                help for get
      --kubeconfig string   The path to the kubeconfig file, optional
  -n, --namespace string    Target namespace for the external secret store, optional
  -o, --output string       Output format (yaml|json|table), optional
      --verbose int32       Number for the log level verbosity(0-9)
```

### SEE ALSO

* [external-secrets stores](external-secrets_stores.md)	 - Interacting with external-secrets.io SecretStores
