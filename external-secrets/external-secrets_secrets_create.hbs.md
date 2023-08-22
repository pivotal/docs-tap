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

### SEE ALSO

* [external-secrets secrets](external-secrets_secrets.md)	 - Interacting with external-secrets.io ExternalSecrets

