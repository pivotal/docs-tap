## external-secrets cluster-external-secrets create

Create cluster-external-secret external-secrets.io/v1beta1/ClusterExternalSecret

### Synopsis

Create cluster-external-secret external-secrets.io/v1beta1/ClusterExternalSecret

```
external-secrets cluster-external-secrets create [flags]
```

### Examples

```

# Create ClusterExternalSecret resource from yaml/json file
tanzu external-secrets cluster-external-secret create --filename <file.yaml>

# Create ClusterExternalSecret resource from yaml/json stdin 
cat <<EOF | tanzu external-secrets cluster-external-secret create -f -
apiVersion: external-secrets.io/v1beta1
kind: ClusterExternalSecret
...
EOF

```

### Options

```
  -f, --filepath string     Yaml/Json file to create secret via external-secrets operator
  -h, --help                help for create
      --kubeconfig string   The path to the kubeconfig file, optional
      --verbose int32       Number for the log level verbosity(0-9)
  -y, --yes                 Accept all prompts
```

### SEE ALSO

* [external-secrets cluster-external-secrets](external-secrets_cluster-external-secrets.md)	 - Interacting with external-secrets.io ClusterExternalSecrets