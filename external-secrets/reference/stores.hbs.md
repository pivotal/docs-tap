# external-secrets stores

Interacting with external-secrets.io SecretStores

## <a id="stores"></a> external-secrets stores

List external secrets stores.

### <a id="stores-options"></a> Options

This command has the following options:

```console
  -h, --help   help for stores
```

## <a id="stores-create"></a> external-secrets stores create

Creates a secret store external-secrets.io/v1beta1/SecretStore.

```console
external-secrets stores create [flags]
```

### <a id="stores-create-examples"></a> Examples

To create SecretStore resource from a YAML or JSON file, run:

```console
tanzu external-secrets stores create --filename <file.yaml>
```
<!-- angle brackets around file.yaml are required or not? -->

To create SecretStore resource from YAML or JSON using stdin, run:

```console
cat <<EOF | tanzu external-secrets stores create -f -
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
...
EOF
```

### <a id="stores-create-options"></a> Options

This command has the following options:

```console
  -f, --filepath string     Yaml/Json file to create secret store via external-secrets operator
  -h, --help                help for create
      --kubeconfig string   The path to the kubeconfig file, optional
  -n, --namespace string    Target namespace for the secret store, optional
      --verbose int32       Number for the log level verbosity(0-9)
  -y, --yes                 accept all prompts
```

## <a id="stores-get"></a> external-secrets stores get

Gets a specific external-secrets.io/v1beta1/SecretStore.

```console
external-secrets stores get [flags]
```

### <a id="stores-get-examples"></a> Examples

To get an external-secret-store from the specified namespace, run:

```console
tanzu external-secrets stores get $SECRET_STORE_NAME  -n test-ns
```

To get an external-secret-store in JSON output format, run:

```console
tanzu external-secrets stores get  $SECRET_STORE_NAME -n test-ns -o json
```

### <a id="stores-get-options"></a> Options

This command has the following options:

```console
  -A, --all-namespaces      View secrets in all namespaces, optional
  -h, --help                help for get
      --kubeconfig string   The path to the kubeconfig file, optional
  -n, --namespace string    Target namespace for the external secret store, optional
  -o, --output string       Output format (yaml|json|table), optional
      --verbose int32       Number for the log level verbosity(0-9)
```

## <a id="stores-list"></a> external-secrets stores list

Lists all external-secrets.io/v1beta1/ExternalSecret resources and checks for the associated v1/Secret
with the correct owner reference.

```console
external-secrets stores list [flags]
```

### <a id="stores-list-examples"></a> Examples

To list all external secrets stores, run:

```console
tanzu external-secrets stores list -A

To list external secrets stores in a specified namespace, run:

```console
tanzu external-secrets stores list -n test-ns

To list all external secrets stores in JSON output format, run:

```console
tanzu external-secrets stores list -n test-ns -o json
```

### <a id="stores-list-options"></a> Options

This command has the following options:

```console
  -A, --all-namespaces      View secrets in all namespaces, optional
  -h, --help                help for list
      --kubeconfig string   The path to the kubeconfig file, optional
  -n, --namespace string    Target namespace for the external secret, optional
  -o, --output string       Output format (yaml|json|table), optional
      --verbose int32       Number for the log level verbosity(0-9)
```

## <a id="see-also"></a> See also

- [external-secrets](external-secrets.md)
