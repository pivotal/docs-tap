# external-secrets secrets

This topic gives you reference information for interacting with external-secrets.io ExternalSecrets

## <a id="secrets"></a> external-secrets secrets

Interacts with external-secrets.io resources.

### <a id="secrets-options"></a> Options

This command has the following options:

```console
  -h, --help   help for secrets
```

## <a id="secrets-create"></a> external-secrets secrets create

Create an external-secret external-secrets.io/v1beta1/ExternalSecret resource.

```console
external-secrets secrets create [flags]
```

### <a id="secrets-create-examples"></a> Examples

Create an ExternalSecret resource from a YAML or JSON file:

```console
tanzu external-secrets secret create --filename <file.yaml>
```
<!-- angle brackets around file.yaml are required or not? -->

Create an ExternalSecret resource from YAML or JSON using stdin:

```console
cat <<EOF | tanzu external-secrets secret create -f -
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
...
EOF
```

### <a id="secrets-create-options"></a> Options

This command has the following options:

```console
  -f, --filepath string     Yaml/Json file to create secret via external-secrets operator
  -h, --help                help for create
      --kubeconfig string   The path to the kubeconfig file, optional
  -n, --namespace string    Target namespace for the external secret, optional
      --verbose int32       Number for the log level verbosity(0-9)
  -y, --yes                 accept all prompts
```

## <a id="secrets-get"></a> external-secrets secrets get

Gets a specific external-secrets.io/v1beta1/ExternalSecret and its correct owner reference.

```console
external-secrets secrets get [flags]
```

### <a id="secrets-get-examples"></a> Examples

Get a specific external-secret from a specified namespace:

```console
tanzu external-secrets secrets get $EXTERNAL_SECRET_NAME  -n example-ns
```

Get a specific external-secret from a specified namespace in JSON output format:

```console
tanzu external-secrets secret get $EXTERNAL_SECRET_NAME -n example-ns -o json
```

### <a id="secrets-get-options"></a> Options

This command has the following options:

```console
  -A, --all-namespaces      View secrets in all namespaces, optional
  -h, --help                help for get
      --kubeconfig string   The path to the kubeconfig file, optional
  -n, --namespace string    Target namespace for the external secret, optional
  -o, --output string       Output format (yaml|json|table), optional
      --verbose int32       Number for the log level verbosity(0-9)
```

## <a id="secrets-list"></a> external-secrets secrets list

Lists all external-secrets.io/v1beta1/ExternalSecret resources and checks for the associated v1/Secret
with the correct owner reference.

```console
external-secrets secrets list [flags]
```

### <a id="secrets-list-example"></a> Examples

List external-secrets across all namespaces:

```console
tanzu external-secrets list -A
```

List external-secrets from specified namespace:

```console
tanzu external-secrets secrets list -n test-ns
```

List external-secrets in JSON output format:

```console
tanzu external-secrets secret list -n test-ns -o json
```

### <a id="secrets-list-options"></a> Options

This command has the following options:

```console
  -A, --all-namespaces      View secrets in all namespaces, optional
  -h, --help                help for list
      --kubeconfig string   The path to the kubeconfig file, optional
  -n, --namespace string    Target namespace for the external secret, optional
  -o, --output string       Output format (yaml|json|table), optional
      --verbose int32       Number for the log level verbosity(0-9)
```

## <a id="secrets-sync"></a> external-secrets secrets sync

Force the synchronization of an external-secrets.io/v1beta1 secret

```console
external-secrets secrets sync [flags]
```

### <a id="secrets-sync-examples"></a> Examples

Trigger the sync of an external secret:

```console
tanzu external-secrets secrets sync <secret>
```

Trigger the sync of an external secret in a namespace

```console
tanzu external-secrets secrets sync <secret> -n dev
```
<!-- angle brackets around <secret> are required or not? Would that be the secret name? -->

### <a id="secrets-sync-options"></a> Options

This command has the following options:

```console
  -h, --help                help for sync
      --kubeconfig string   The path to the kubeconfig file, optional
  -n, --namespace string    Target namespace for the external secret, optional
      --verbose int32       Number for the log level verbosity(0-9)
```

### <a id="see-also"></a> See also

- [external-secrets](external-secrets.md)
