# Troubleshoot Contour

This topic tells you how to troubleshoot Contour installation and configuration.

## <a id='malformed-ip-address'></a> Envoy pods fail with malformed IP address errors 

**Symptom:**

The Contour package fails to reconcile, and the Envoy pods fail with errors like:

```console
23-11-23 01:55:11.503][1][warning][config] [source/common/config/grpc_subscription_impl.cc:128] gRPC config for type.googleapis.com/envoy.config.listener.v3.Listener rejected: Error adding/updating listener(s) ingress_http: malformed IP address: :: 
```

**Explanation:**

By default, the Contour package programs Envoy's listeners to use IPv6 addresses. 
In most cases, this is OK. However, some clusters, such as TKGI, only support IPv4.

**Solution:**

>**Important** This solution only applies to Contour v1.26 or later, which is included in Tanzu Application Platform v1.8.0 and later.

To use IPv4 addresses on the listeners, update the Tanzu Application Platform values file (commonly called `tap-values.yaml`).

The following is an example of the Contour section of the values file:

```yaml
contour:
  envoy:
    listenIPFamily: IPv4
```
