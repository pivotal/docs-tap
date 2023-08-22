## external-secrets cluster-external-secrets list

Lists all external-secrets.io/v1beta1/ClusterExternalSecret

### Synopsis

Lists all external-secrets.io/v1beta1/ClusterExternalSecret

```
external-secrets cluster-external-secrets list [flags]
```

### Examples

```

 # List cluster-external-secrets in json output format
tanzu external-secrets cluster-external-secrets list -o json
```

### Options

```
  -h, --help                help for list
      --kubeconfig string   The path to the kubeconfig file, optional
  -o, --output string       Output format (yaml|json|table), optional
      --verbose int32       Number for the log level verbosity(0-9)
```

### SEE ALSO

* [external-secrets cluster-external-secrets](external-secrets_cluster-external-secrets.md)	 - Interacting with external-secrets.io ClusterExternalSecrets