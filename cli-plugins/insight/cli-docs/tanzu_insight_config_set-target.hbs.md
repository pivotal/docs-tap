# tanzu insight config set-target

Use this command to set the metadata store endpoint.

## <a id='synopsis'></a>Synopsis

To set the target endpoint for the metadata store, run@

```console
tanzu insight config set-target <endpoint> [--ca-cert <ca certificate path to verify peer against>] [--access-token <kubernetes service account access token>] [flags]
```

## <a id='examples'></a>Examples

```console
insight config set-target https://localhost:8443 --ca-cert=/tmp/ca.crt --access-token eyJhbGc...
```

## <a id='options'></a>Options

```console
      --access-token string   Kubernetes access token. It is recommended to use the Environment Variable METADATA_STORE_ACCESS_TOKEN during the API calls, this will override access token flag. Note: using the the access-token flag stores the token on disk, the Environment Variable is retrieved at the time of the API call
      --ca-cert string        trusted ca certificate
  -h, --help                  help for set-target
```

## <a id='see-also'></a>See also

* [tanzu insight config](tanzu_insight_config.hbs.md)	 - Config commands
