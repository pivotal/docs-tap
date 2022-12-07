# Storage

AppSSOs `AuthServer` handles data pertaining to user's session, identity and access tokens, and approved or rejected
consents. For production environments, it is critical to provide your own storage source to enable enterprise
functions such as data backup and recovery, auditing, and long-term persistence, as per your organization's data and
security policies.

AppSSO currently only supports Redis `v6.0` or above as a storage solution. Version 6.0 introduced TLS support to ensure
encrypted client-server communication -- AppSSO enforces TLS by default.

<p class="note">
<strong>Note:</strong>
[Storage provided by default](#storage-provided-by-default) refers to an `AuthServer` resource in which the field
`.spec.storage` is not set.
</p>

## Configuring Redis

To configure Redis as authorization server storage, you must have the following details about your Redis server:

* **Server CA certificate** (optional) - the Certificate Authority (CA) certificate used to verify Redis TLS
  connections. If Redis Server certificate is signed by a public CA, providing this certificate is not required.
* **host** (required) - the domain name, IP address, or host name of your Redis server.
* **port** (optional) - the port number of your Redis server (default: `6379`). Must be a string.
* **username** (optional) - the username used to authenticate against your Redis server.
* **password** (optional) - the password used to authenticate against your Redis server.

<p class="note caution">
<strong>Caution:</strong>
AppSSO takes _secure-by-default_ approach and will not establish non-encrypted communication channels.
The `AuthServer` resource will enter an error state should a non-encrypted connection be attempted.
</p>

The following steps introduce the path to configuring Redis with AppSSO:

1. [Configuring Redis Server CA certificate](#configuring-redis-server-ca-certificate)
1. [Configuring a Redis Secret](#configuring-a-redis-secret)
1. [Attaching storage to an `AuthServer`](#attaching-storage-to-an-authserver)

### Configuring Redis Server CA certificate

If your Redis comes with a custom or non-public Server CA certificate, you will need to instruct AppSSO to
trust the CA certificate. This is required in order for the authorization server to communicate with your
Redis over TLS successfully.

There are multiple ways of configuring a CA certificate with AppSSO, please refer to
[CA certificates page](./ca-certs.md) for instructions.

### Configuring a Redis Secret

To provide _coordinates_ (the location details) of your Redis server, you have to create a `Secret` resource that
follows well-known Secret entries conventions specified
in [Service Bindings 1.0.0 specification](https://github.com/servicebinding/spec#well-known-secret-entries).

Here is an example of a properly formatted `Secret` resource:

<p class="note">
<strong>Note:</strong>
The Secret **must** be created in the same namespace as your `AuthServer`
</p>

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: redis-credentials
  namespace: my-authserver
type: servicebinding.io/redis        # required
stringData:
  type: "redis"                      # required, must equal 'redis'
  ssl: "true"                        # required, must equal 'true'
  host: "redis01.prod.example.com"   # required
  port: "6379"                       # optional, must be a string, defaults to "6379" if left empty
  password: "!!veryStrongPassword!!" # optional
  username: "redis01-user"           # optional
```

### Attaching storage to an AuthServer

Once a Redis Secret resource is applied, you may reference the Secret in `.spec.storage`. Here is an example of an
AuthServer with a reference to a Redis Secret:

```yaml
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: my-authserver-example
  namespace: my-authserver
spec:
  # ...
  storage:
    redis:
      serviceRef:
        apiVersion: "v1"
        kind: "Secret"
        name: redis-credentials
```

Once `AuthServer` is applied, ensure that its `Status` is equivalent to `Ready`, and you may query the status of the
configured storage as follows:

```bash
kubectl get authserver <authserver-name> \
  --namespace <authserver-namespace> \
  --output jsonpath="{.status.storage.redis}" | jq
```

## Storage provided by default

If no storage is defined, an `AuthServer` provides its own short-lived ephemeral storage solution,
Redis. The provided Redis is configured to never flush any data to any volume that may be attached to the Pods operating
the authorization server.

<p class="note caution">
<strong>Caution:</strong>
The default storage configuration is most useful in prototyping or testing environments, and **should not be relied on
in production environments.**
</p>

To view details for Redis of an `AuthServer`:

```shell
# Get the Redis image
kubectl get authserver <authserver-name> \
  --namespace <authserver-namespace> \
  --output jsonpath="{.status.deployments.redis}" | jq

# Get the Redis host and port
kubectl get authserver <authserver-name> \
  --namespace <authserver-namespace> \
  --output jsonpath="{.status.storage.redis}" | jq
```
