## external-secrets cluster-stores list

Lists all external-secrets.io/v1beta1/ClusterStores

### Synopsis

Lists all external-secrets.io/v1beta1/ClusterStores

```
external-secrets cluster-stores list [flags]
```

### Examples

```

# List all external secrets cluster stores
tanzu external-secrets cluster-stores list
	
# List all external secrets cluster stores in json output format	
tanzu external-secrets cluster-stores list -o json
```

### Options

```
  -h, --help                help for list
      --kubeconfig string   The path to the kubeconfig file, optional
  -o, --output string       Output format (yaml|json|table), optional
      --verbose int32       Number for the log level verbosity(0-9)
```

### SEE ALSO

* [external-secrets cluster-stores](external-secrets_cluster-stores.md)	 - Interacting with external-secrets.io ClusterStores
