# external-secrets cluster-external-secrets

This topic gives you reference information for interacting with external-secrets.io ClusterExternalSecrets.

## <a id="cluster-external-secret"></a> external-secrets cluster-external-secret

List external secrets cluster-external-secrets.

### <a id="ces-options"></a> Options

This command has the following options:

```console
  -h, --help   help for cluster-external-secrets
```

## <a id="ces-create"></a> external-secrets cluster-external-secrets create

Creates a cluster-external-secret external-secrets.io/v1beta1/ClusterExternalSecret resource.

```console
external-secrets cluster-external-secrets create [flags]
```

### <a id="ces-create-examples"></a> Examples

Create a ClusterExternalSecret resource from a YAML or JSON file:

```console
tanzu external-secrets cluster-external-secret create --filename <file.yaml>
```
<!-- angle brackets around file.yaml are required or not? -->

Create ClusterExternalSecret resource from YAML or JSON using stdin:

```console
cat <<EOF | tanzu external-secrets cluster-external-secret create -f -
apiVersion: external-secrets.io/v1beta1
kind: ClusterExternalSecret
...
EOF
```

### <a id="ces-create-options"></a> Options

This command has the following options:

```console
  -f, --filepath string     Yaml/Json file to create secret via external-secrets operator
  -h, --help                help for create
      --kubeconfig string   The path to the kubeconfig file, optional
      --verbose int32       Number for the log level verbosity(0-9)
  -y, --yes                 Accept all prompts
```

## <a id="ces-get"></a> external-secrets cluster-external-secrets get

Gets a specific external-secrets.io/v1beta1/ClusterExternalSecret resource.

```console
external-secrets cluster-external-secrets get [flags]
```

### <a id="ces-get-examples"></a> Examples

Get a cluster-external-secret in JSON output format:

```console
tanzu external-secrets cluster-external-secrets get $CLUSTER_EXTERNAL_SECRET_NAME -n test-ns -o json
```

### <a id="ces-get-options"></a> Options

This command has the following options:

```console
  -h, --help                help for get
      --kubeconfig string   The path to the kubeconfig file, optional
  -o, --output string       Output format (yaml|json|table), optional
      --verbose int32       Number for the log level verbosity(0-9)
```

## <a id="ces-list"></a> external-secrets cluster-external-secrets list

Lists all external-secrets.io/v1beta1/ClusterExternalSecret resources.

```console
external-secrets cluster-external-secrets list [flags]
```

### <a id="ces-list-examples"></a> Examples

List the cluster-external-secrets in JSON output format:

```console
tanzu external-secrets cluster-external-secrets list -o json
```

### <a id="ces-list-options"></a> Options

This command has the following options:

```console
  -h, --help                help for list
      --kubeconfig string   The path to the kubeconfig file, optional
  -o, --output string       Output format (yaml|json|table), optional
      --verbose int32       Number for the log level verbosity(0-9)
```

### <a id="see-also"></a> See also

- [external-secrets](external-secrets.md)
