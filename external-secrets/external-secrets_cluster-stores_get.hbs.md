## external-secrets cluster-stores get

Get a specific external-secrets.io/v1beta1/ClusterSecretStore

### Synopsis

Get a specific external-secrets.io/v1beta1/ClusterSecretStore resource

```
external-secrets cluster-stores get [flags]
```

### Examples

```

		# Get external-secret-cluster-store
		tanzu external-secrets cluster-stores get $CLUSTER_STORE_NAME 
	
		# Get external-secret-cluster-store in json output format
		tanzu external-secrets cluster-stores get $CLUSTER_STORE_NAME -o json
```

### Options

```
  -h, --help                help for get
      --kubeconfig string   The path to the kubeconfig file, optional
  -o, --output string       Output format (yaml|json|table), optional
      --verbose int32       Number for the log level verbosity(0-9)
```

### SEE ALSO

* [external-secrets cluster-stores](external-secrets_cluster-stores.md)	 - Interacting with external-secrets.io ClusterStores

