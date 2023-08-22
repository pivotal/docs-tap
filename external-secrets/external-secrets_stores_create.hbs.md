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

### SEE ALSO

* [external-secrets stores](external-secrets_stores.md)	 - Interacting with external-secrets.io SecretStores

