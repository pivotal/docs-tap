# external-secrets stores

Interacting with external-secrets.io SecretStores

### Synopsis

List external secrets stores.

### Options

```console
  -h, --help   help for stores
```

## external-secrets stores create

Create secret store external-secrets.io/v1beta1/SecretStore

### Synopsis

Create secret store external-secrets.io/v1beta1/SecretStore

```
external-secrets stores create [flags]
```

### Examples

```

# Create SecretStore resource from yaml/json file
tanzu external-secrets stores create --filename <file.yaml>

# Create SecretStore resource from yaml/json stdin
cat <<EOF | tanzu external-secrets stores create -f -
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
...
EOF

```

### Options

```
  -f, --filepath string     Yaml/Json file to create secret store via external-secrets operator
  -h, --help                help for create
      --kubeconfig string   The path to the kubeconfig file, optional
  -n, --namespace string    Target namespace for the secret store, optional
      --verbose int32       Number for the log level verbosity(0-9)
  -y, --yes                 accept all prompts
```

## external-secrets stores get

Get a  specific external-secrets.io/v1beta1/SecretStore

### Synopsis

Get a specific external-secrets.io/v1beta1/SecretStore

```
external-secrets stores get [flags]
```

### Examples

```

# Get external-secret-store from specified namespace
tanzu external-secrets stores get $SECRET_STORE_NAME  -n test-ns

# Get external-secret-store in json output format
tanzu external-secrets stores get  $SECRET_STORE_NAME -n test-ns -o json
```

### Options

```
  -A, --all-namespaces      View secrets in all namespaces, optional
  -h, --help                help for get
      --kubeconfig string   The path to the kubeconfig file, optional
  -n, --namespace string    Target namespace for the external secret store, optional
  -o, --output string       Output format (yaml|json|table), optional
      --verbose int32       Number for the log level verbosity(0-9)
```

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

* [external-secrets](external-secrets.md)	 - interacts with external-secrets.io resources
