## external-secrets cluster-external-secrets get

Get a specific external-secrets.io/v1beta1/ClusterExternalSecret

### Synopsis

Get a specific external-secrets.io/v1beta1/ClusterExternalSecret resource

```
external-secrets cluster-external-secrets get [flags]
```

### Examples

```
# Get cluster-external-secret in json output format
tanzu external-secrets cluster-external-secrets get $CLUSTER_EXTERNAL_SECRET_NAME -n test-ns -o json
```

### Options

```
  -h, --help                help for get
      --kubeconfig string   The path to the kubeconfig file, optional
  -o, --output string       Output format (yaml|json|table), optional
      --verbose int32       Number for the log level verbosity(0-9)
```

### SEE ALSO

* [external-secrets cluster-external-secrets](external-secrets_cluster-external-secrets.md)	 - Interacting with external-secrets.io ClusterExternalSecrets
