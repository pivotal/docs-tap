# Deactivate HTTP-to-HTTPS redirection

This topic tells you how to deactivate HTTP-to-HTTPS redirection with Cloud Native Runtimes.

## <a id="overview"></a> Overview

When you designate an ingress issuer for your workloads by setting either the `shared.ingress_issuer` or `cnrs.ingress_issuer` configuration value,
in your `tap-values.yaml` file, the auto-TLS feature is enabled in Cloud Native Runtimes.
When the auto-TLS is enabled, Cloud Native Runtimes automatically redirects traffic from HTTP to HTTPS.
However, there can be situations where you want to opt out of this behavior and continue serving content over HTTP.
To do this, you must deactivate the HTTPS redirection feature.

To deactivate HTTP-to-HTTPS redirection in Cloud Native Runtimes, you must edit your configuration values file:

1. Configure Cloud Native Runtimes to deactivate https redirection:

   ```yaml
   cnrs:
       https_redirection: false
   ```

2. Update your Tanzu Application Platform installation:

   ```console
   tanzu package installed update tap -p tap.tanzu.vmware.com -v ${TAP_VERSION} --values-file tap-values.yaml -n tap-install
   ```

3. Verify that the HTTP-to-HTTPS redirection is deactivated by accessing your workload using the HTTP protocol.
   You can access the service without being redirected to HTTPS. Use a web browser or a tool like `curl` to test the behavior:

   ```console
   curl -I http://your-workload.your-domain.com
   ```

   The response shows an HTTP status code without redirection to HTTPS.
