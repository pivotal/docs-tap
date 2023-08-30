# external-secrets cluster-stores

This topic provides reference information for interacting with external-secrets.io ClusterStores.

## <a id="cluster-stores"></a> external-secrets cluster-stores

Lists external secrets cluster stores.

### <a id="cs-options"></a> Options

This command has the following options:

```console
  -h, --help   help for cluster-stores
```

## <a id="cs-create"></a> external-secrets cluster-stores create

Creates a cluster-store external-secrets.io/v1beta1/ClusterSecretStore resource.

```console
external-secrets cluster-stores create [flags]
```

### <a id="cs-create-examples"></a> Examples

To create a ClusterStore resource from a YAML or JSON file, run:

```console
tanzu external-secrets cluster-stores create --filename <file.yaml>
```
<!-- angle brackets around file.yaml are required or not? -->

To create a ClusterStore resource from YAML or JSON using stdin, run:

```console
cat <<EOF | tanzu external-secrets cluster-stores create -f -
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
...
EOF
```

### <a id="cs-create-options"></a> Options

This command has the following options:

```console
  -f, --filepath string     Yaml/Json file to create cluster store secret via external-secrets operator
  -h, --help                help for create
      --kubeconfig string   The path to the kubeconfig file, optional
      --verbose int32       Number for the log level verbosity(0-9)
  -y, --yes                 accept all prompts
```

## <a id="cs-get"></a> external-secrets cluster-stores get

Gets a specific external-secrets.io/v1beta1/ClusterSecretStore resource.

```console
external-secrets cluster-stores get [flags]
```

### <a id="cs-get-examples"></a> Examples

To get a cluster-store, run:

```console
tanzu external-secrets cluster-stores get $CLUSTER_STORE_NAME
```

To get a cluster-store in JSON output format, run:

```console
tanzu external-secrets cluster-stores get $CLUSTER_STORE_NAME -o json
```

### <a id="cs-get-options"></a> Options

This command has the following options:

```console
  -h, --help                help for get
      --kubeconfig string   The path to the kubeconfig file, optional
  -o, --output string       Output format (yaml|json|table), optional
      --verbose int32       Number for the log level verbosity(0-9)
```

## <a id="cs-list"></a> external-secrets cluster-stores list

Lists all external-secrets.io/v1beta1/ClusterStores.

```console
external-secrets cluster-stores list [flags]
```

### <a id="cs-list-examples"></a> Examples

To list all external secrets cluster stores, run:

```console
tanzu external-secrets cluster-stores list
```

To list all external secrets cluster stores in JSON output format, run:

```console
tanzu external-secrets cluster-stores list -o json
```

### <a id="cs-list-options"></a> Options

This command has the following options:

```console
  -h, --help                help for list
      --kubeconfig string   The path to the kubeconfig file, optional
  -o, --output string       Output format (yaml|json|table), optional
      --verbose int32       Number for the log level verbosity(0-9)
```

## <a id="see-also"></a> See also

- [external-secrets](external-secrets.md)
