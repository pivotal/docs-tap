# Configure a corporate HTTP or HTTPS proxy

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

## <a id='no-proxy-def-values'></a> `NO_PROXY` default values

Tanzu Developer Portal applies default values for `NO_PROXY` to its Kubernetes manifests. These
default values are implemented any time you use the `HTTP_PROXY` variable, even when you have not
specified `NO_PROXY`. When you do specify a value for `NO_PROXY`, your input is prepended to the
default values with a comma.

`tap-values.yaml` snippet example:

```yaml
tap_gui:
  HTTP_PROXY: http://foo:bar@127.0.0.1:8888
  NO_PROXY: 'bar.com,baz.com'
```

Command output example:

```console
$ kubectl -n tap-gui get deployment server -o jsonpath="{.spec.template.spec.containers[0].env[?(@.name=='NO_PROXY')].value}"
bar.com,baz.com,.local,.local.,localhost,.metadata-store,.accelerator-system,$(KUBERNETES_SERVICE_HOST)
```

The list of default values is as follows and only affects requests within the cluster:

```console
.local,.local.,localhost,.metadata-store,.accelerator-system,$(KUBERNETES_SERVICE_HOST)
```

### <a id='see-values'></a> See which values are in use on your installation

To see which values are in use on your installation, run:

```console
kubectl -n tap-gui get deployment server -o jsonpath="{.spec.template.spec.containers[0].env[?(@.name=='NO_PROXY')].value}"
```

### <a id='override-def-values'></a> Override the default values

Currently the only way to override the list of default values is to use an overlay and replace the
entire list. For example:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: no-proxy-overlay
  namespace: tap-install
stringData:
  custom-app-image-overlay.yaml: |
    #@ load("@ytt:overlay", "overlay")

    #! makes an assumption that tap-gui is deployed in the namespace: "tap-gui"

    #@overlay/match by=overlay.subset({"kind": "Deployment", "metadata": {"name": "server", "namespace": "tap-gui"}}), expects="1+"
    ---
    spec:
      template:
        spec:
          containers:
            #@overlay/match by=overlay.subset({"name": "backstage"}),expects="1+"
            #@overlay/match-child-defaults missing_ok=True
            - env:
                - name: NO_PROXY
                  value: 'MY-VALUES'
```

For more information about how to apply overlays, see
[Customize your package installation](../customize-package-installation.hbs.md).
