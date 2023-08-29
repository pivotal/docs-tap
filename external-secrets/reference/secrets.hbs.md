# external-secrets secrets

Interacting with external-secrets.io ExternalSecrets

### Synopsis

Interacts with external-secrets.io resources.

### Options

```
  -h, --help   help for secrets
```

## external-secrets secrets create

Create external-secret external-secrets.io/v1beta1/ExternalSecret

### Synopsis

Create external-secret external-secrets.io/v1beta1/ExternalSecret

```
external-secrets secrets create [flags]
```

### Examples

```

# Create ExternalSecret resource from yaml/json file
tanzu external-secrets secret create --filename <file.yaml>

# Create ExternalSecret resource from yaml/json stdin
cat <<EOF | tanzu external-secrets secret create -f -
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
...
EOF

```

### Options

```
  -f, --filepath string     Yaml/Json file to create secret via external-secrets operator
  -h, --help                help for create
      --kubeconfig string   The path to the kubeconfig file, optional
  -n, --namespace string    Target namespace for the external secret, optional
      --verbose int32       Number for the log level verbosity(0-9)
  -y, --yes                 accept all prompts
```

## external-secrets secrets get

Get a specific external-secrets.io/v1beta1/ExternalSecret

### Synopsis

Get a specific external-secrets.io/v1beta1/ExternalSecret and it's correct owner reference

```
external-secrets secrets get [flags]
```

### Examples

```

# Get a specific external-secret from a specified namespace
tanzu external-secrets secrets get $EXTERNAL_SECRET_NAME  -n example-ns

# Get a specific external-secret from a specified namespace in json output format
tanzu external-secrets secret get $EXTERNAL_SECRET_NAME -n example-ns -o json
```

### Options

```
  -A, --all-namespaces      View secrets in all namespaces, optional
  -h, --help                help for get
      --kubeconfig string   The path to the kubeconfig file, optional
  -n, --namespace string    Target namespace for the external secret, optional
  -o, --output string       Output format (yaml|json|table), optional
      --verbose int32       Number for the log level verbosity(0-9)
```

## external-secrets secrets list

Lists all external-secrets.io/v1beta1/ExternalSecret

### Synopsis

Lists all external-secrets.io/v1beta1/ExternalSecret and checks for the associated v1/Secret with the correct owner reference

```
external-secrets secrets list [flags]
```

### Examples

```

# List external-secrets across all namespaces
tanzu external-secrets list -A

# List external-secrets from specified namespace
tanzu external-secrets secrets list -n test-ns

# List external-secrets in json output format
tanzu external-secrets secret list -n test-ns -o json
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

## external-secrets secrets sync

Sync a secret

### Synopsis

Force the synchronization of an external-secrets.io/v1beta1 secret

```
external-secrets secrets sync [flags]
```

### Examples

```

# Trigger the sync of an external secret
tanzu external-secrets secrets sync <secret>

# Trigger the sync of an external secret in a namespace
tanzu external-secrets secrets sync <secret> -n dev
```

### Options

```
  -h, --help                help for sync
      --kubeconfig string   The path to the kubeconfig file, optional
  -n, --namespace string    Target namespace for the external secret, optional
      --verbose int32       Number for the log level verbosity(0-9)
```

### SEE ALSO

* [external-secrets](external-secrets.md)	 - interacts with external-secrets.io resources
