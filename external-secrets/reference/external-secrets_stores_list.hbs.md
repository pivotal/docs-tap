## external-secrets stores list

Lists all external-secrets.io/v1beta1/Secrets

### Synopsis

Lists all external-secrets.io/v1beta1/ExternalSecret and checks for the associated v1/Secret with the correct owner reference

```
external-secrets stores list [flags]
```

### Examples

```

# List all external secrets stores
tanzu external-secrets stores list -A
	
# List external secrets stores in specified namespace	
tanzu external-secrets stores list -n test-ns
	
# List all external secrets stores in json output format	
tanzu external-secrets stores list -n test-ns -o json
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

* [external-secrets stores](external-secrets_stores.md)	 - Interacting with external-secrets.io SecretStores
