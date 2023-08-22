## external-secrets cluster-stores create

Create cluster-store external-secrets.io/v1beta1/ClusterSecretStore

### Synopsis

Create cluster-store external-secrets.io/v1beta1/ClusterSecretStore

```
external-secrets cluster-stores create [flags]
```

### Examples

```

# Create ClusterStore resource from yaml/json file
tanzu external-secrets cluster-stores create --filename <file.yaml>

# Create ClusterStore resource from yaml/json stdin 
cat <<EOF | tanzu external-secrets cluster-stores create -f -
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
...
EOF

```

### Options

```
  -f, --filepath string     Yaml/Json file to create cluster store secret via external-secrets operator
  -h, --help                help for create
      --kubeconfig string   The path to the kubeconfig file, optional
      --verbose int32       Number for the log level verbosity(0-9)
  -y, --yes                 accept all prompts
```

### SEE ALSO

* [external-secrets cluster-stores](external-secrets_cluster-stores.md)	 - Interacting with external-secrets.io ClusterStores

