# Opt out from an ingress issuer and deactivate automatic TLS feature

This topic tells you how to opt out from an ingress issuer and deactivate automatic TLS feature for Cloud Native Runtimes.

## <a id="deactivate-tls"></a> Deactivate TLS

You can deactivate automatic TLS certificate provisioning in Cloud Native Runtimes by setting the `ingress_issuer` property to an empty string as follows:

```yaml
cnrs:
    ingress_issuer: ""
```

Update your Tanzu Application Platform installation accordingly after following the step mentioned earlier.

```console
tanzu package installed update tap -p tap.tanzu.vmware.com -v ${TAP-VERSION} --values-file tap-values.yaml -n tap-install
```

Where `TAP-VERSION` is the version of Tanzu Application Platform you want to update to.