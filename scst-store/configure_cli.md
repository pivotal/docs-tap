# Configuring the CLI

Before using CLI commands, it needs be configured to know three things:
1. The location of an access token
1. Target endpoint — must be `https://metadata-store-app.metadata-store.svc.cluster.local:<port>`
1. The location of the CA Cert

## Setting the Access Token with `METADATA_STORE_ACCESS_TOKEN`

If you don't already have a service account, see [Creating Service Accounts and Access Tokens](create_service_account_access_token.md). The following is from that page.

When using the CLI, you'll need to either set the `METADATA_STORE_ACCESS_TOKEN` environment variable, or use the `--access-token` flag. It is not recommended to use the `--access-token` flag as the token will appear in your shell history. We recommend using `METADATA_STORE_ACCESS_TOKEN`.

The follow command will retrieve the access token from Kubernetes and store it in `METADATA_STORE_ACCESS_TOKEN`:

```sh
$ export METADATA_STORE_ACCESS_TOKEN=$(kubectl get secrets -n metadata-store -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='metadata-store-read-write-client')].data.token}" | base64 -d)
```

Replace `metadata-store-read-write-client` with name of the service account you plan to use.

## Set Target and CA Cert

Use `insight config set-target` to point the CLI to the right endpoint and where to look for the CA certificate:

```sh
$ insight config set-target https://metadata-store-app.metadata-store.svc.cluster.local:8443 [--ca-cert <path to CA certificate file>]
```

For example, if your CA certificate file is located at `/tmp/ca.crt` then use

```sh
$ insight config set-target https://metadata-store-app.metadata-store.svc.cluster.local:8443 --ca-cert /tmp/ca.crt

Using config file: /Users/username/.insight/config.yaml
Setting endpoint in config to: https://metadata-store-app.metadata-store.svc.cluster.local:8443

$ insight image get --digest example-digest
Error: {"message":"Image not found"}
...
```
