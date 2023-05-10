## Tanzu insight config set-target

Set the metadata store endpoint.

### <a id='synopsis'></a>Synopsis

Set the target endpoint for the metadata store.

```console
tanzu insight config set-target <endpoint> [--ca-cert <ca certificate path to verify peer against>] [--access-token <kubernetes service account access token>] [flags]
```

### <a id='examples'></a>Examples

```console
tanzu insight config set-target https://localhost:8443 --ca-cert=/tmp/ca.crt --access-token eyJhbGc...
```

### <a id='options'></a>Options

```console
      --access-token string   Kubernetes access token. It is recommended to use the Environment Variable METADATA_STORE_ACCESS_TOKEN during the API calls, this will override access token flag. Note: using the access-token flag stores the token on disk, the Environment Variable is retrieved at the time of the API call
      --ca-cert string        trusted ca certificate
  -h, --help                  help for set-target
```

### <a id='see-also'></a>See also

* [Tanzu insight config](insight-config.md)	 - Config commands
