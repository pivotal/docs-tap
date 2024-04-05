# Configure an HTTP or HTTPS proxy

You can configure Tanzu Developer Portal to route its traffic through a specified HTTP or HTTPS proxy.
This includes all outgoing requests that Backstage or Tanzu Developer Portal makes. This topic shows
you how to configure proxy settings through the values file.

## <a id='proxy-variables'></a> Proxy variables

Tanzu Developer Portal uses two optional variables to support HTTP and HTTPS proxy configuration:

- `HTTP_PROXY` is a host or IP address of a server that is a proxy. All outgoing requests, whether
  they are HTTP or HTTPS, are sent to this proxy instead of their intended destination. This value
  must include the proxy name or IP address and the port.

- `NO_PROXY` is a comma-separated list of hosts or IP addresses. When both this variable and
  `HTTP_PROXY` is set, traffic is directed through `HTTP_PROXY` unless it matches the host (or
  IP address) of one of the entries in this list.

If any plug-ins need access to resources that can only be accessed through a proxy then you add the
`HTTP_PROXY` value. For resources that are reachable without going through the proxy server, their
domains are listed in the `NO_PROXY` variable.

## <a id='def-proxy-server'></a> Define the proxy server

To define the proxy server in `tap-values.yaml` in a Tanzu Application Platform installation, add
the following example section and edit it as needed:

```yaml
tap_gui:
  HTTP_PROXY: http://foo:bar@127.0.0.1:8888
  NO_PROXY: 'bar.com,baz.com'
```
