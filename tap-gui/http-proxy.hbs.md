# Configure HTTP Proxy

Tanzu Developer Portal is configurable to route its traffic through a specified HTTP/HTTPS proxy. This includes all outgoing requests made by Backstage or the Tanzu Developer Portal. This section shows you how to configure proxy settings through the values file.

## <a id='variables'></a> Proxy Variables

Tanzu Developer Portal uses two optional variables to support HTTP and HTTPs proxy configuration:

1. HTTP_PROXY: A host or IP address of a server that is a proxy. All outgoing requests, whether they are HTTP or HTTPS, should be sent to this proxy instead of their intended destination. This value must include the proxy name/ IP address and the port.

2. NO_PROXY: A comma separated list of hosts or IP addresses.
When both this variable and HTTP_PROXY is set, traffic will be directed through the HTTP_PROXY unless it matches the host (or IP address) of one of entries in this list.

To summarize, if any plugins need access to resources that can only be accessed through a proxy, you would add the HTTP_PROXY value. For resources that are reachable without going through the proxy server, their domains would be listed in the NO_PROXY variable.

## <a id='config'></a> TAP Values Configuration
To define the proxy server in the `tap-values.yaml` file in a TAP installation, add the following example section:
```yaml
tap_gui:
  HTTP_PROXY: http://foo:bar@127.0.0.1:8888
  NO_PROXY: 'bar.com,baz.com'
```
