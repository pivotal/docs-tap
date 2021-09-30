## Uninstalling

TODO: Update uninstall docs with uninstallation using `tanzu package uninstall`?

With plain `kubectl`:

```bash
kubectl delete -f ./releases/release.yaml
```

with `kapp`:

```bash
kapp delete -a cartographer
```

[cert-manager]: https://github.com/jetstack/cert-manager
[admission webhook]: https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/
