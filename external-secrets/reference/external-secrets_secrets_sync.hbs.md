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

* [external-secrets secrets](external-secrets_secrets.md)	 - Interacting with external-secrets.io ExternalSecrets
