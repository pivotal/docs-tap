# external-secrets cluster-stores

Interacting with external-secrets.io ClusterStores

### Synopsis

List external secrets cluster stores.

### Options

```
  -h, --help   help for cluster-stores
```

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

* [external-secrets](external-secrets.md)	 - interacts with external-secrets.io resources
