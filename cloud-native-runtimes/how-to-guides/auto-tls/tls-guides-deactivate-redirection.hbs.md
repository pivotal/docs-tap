# Deactivate HTTP-to-HTTPS redirection

When you designate an ingress issuer for your workloads by setting either the `shared.ingress_issuer` or `cnrs.ingress_issuer` configuration value,
in your `tap-values.yaml` file, the auto-TLS feature is enabled in Cloud Native Runtimes.
When the auto-TLS is enabled, Cloud Native Runtimes will automatically redirect traffic from HTTP to HTTPS.
However, there may be situations where you want to opt out this behavior and continue serving content over HTTP.
If this applies to your case, you must turn off the HTTPS redirection feature.

To deactivate HTTP-to-HTTPS redirection in Cloud Native Runtimes, you must modify your configuration values file 
and follow the steps below:

1. Configure Cloud Native Runtimes to deactivate https redirection

   ```yaml
   cnrs:
       https_redirection: false
   ```

2. Update your Tanzu Application Platform installation

   ```sh
   tanzu package installed update tap -p tap.tanzu.vmware.com -v ${TAP_VERSION} --values-file tap-values.yaml -n tap-install
   ```

3. Verify that the HTTP-to-HTTPS redirection is deactivated by accessing your workload using the HTTP protocol.
   You should be able to access the service without being redirected to HTTPS. Use a web browser or a tool like `curl` to test the behavior:

   ```sh
   curl -I http://your-workload.your-domain.com
   ```

   The response should show an HTTP status code without redirection to HTTPS.
