# external-secrets cluster-external-secrets

Interacting with external-secrets.io ClusterExternalSecrets

### Synopsis

List external secrets cluster-external-secrets.

### Options

```console
  -h, --help   help for cluster-external-secrets
```

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

* [external-secrets](external-secrets.md)	 - interacts with external-secrets.io resources
