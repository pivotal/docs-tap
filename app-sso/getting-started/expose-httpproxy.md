# Expose your authorization server through HTTPProxy

---

👉 This article assumes that you have completed the previous step in this Getting Started
guide. If not, please refer to instructions in [Provision an AuthServer](provision-auth-server.md).

👉 This article assumes that you are using the TAP-provided Contour ingress. Please refer to instructions
in [Tanzu Application Platform documentation](../../install.md#configure-envoy-lb).

---

In this tutorial, you are going to:

1. Expose your running authorization server through a `Service` + `HTTPProxy`
2. Ensure it is accessible from outside the cluster

## Expose through HTTPProxy

Assuming you deployed an `AuthServer` called `my-authserver-example` in the `default` namespace, expose it by creating
a `Service` + `HTTPProxy`.

---

✋ Note that we used `HTTPProxy.spec.virtualhost.fqdn` = `authserver.example.com`, but you should customize the URL to
match the domain of your TAP cluster. The FQDN should match the `issuerURI` that you declared
in [Provision an AuthServer](provision-auth-server.md).

---

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: my-authserver-example
  namespace: default
spec:
  selector:
    app.kubernetes.io/part-of: my-authserver-example
    app.kubernetes.io/component: authorization-server
  ports:
    - port: 80
      targetPort: 8080
---
apiVersion: projectcontour.io/v1
kind: HTTPProxy
metadata:
  name: my-authserver-example
  namespace: default
spec:
  virtualhost:
    fqdn: authserver.example.com
  routes:
    - conditions:
        - prefix: /
      services:
        - name: my-authserver-example
          port: 80
```

By applying the above resources, your authorization server should become accessible outside the cluster,
through `http://authserver.example.com`.
