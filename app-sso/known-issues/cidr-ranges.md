# Redirect URIs get morphed to http instead of https

## Issue Description

AppSSO is making requests to external identity providers with `http` rather than `https`.

The external identity provider (IDP) informs the user that there’s an issue with the `redirect_uri` upon a redirect from
the AppSSO auth server to the IDP. The payload of the request to the IDP has a `redirect_uri` of AppSSO Issuer URI that
has http protocol prefix, while the configuration on the external IDP side has it registered as https protocol prefixed.

The underlying issue is that the default Classless Inter-Domain Routing (CIDR) for pod-to-pod traffic  is not a default
internal network trusted by `AppSSO`.

## Workaround

Add these CIDR ranges to the `AuthServer.spec` (this is a sample range):

```yaml
  server: |
    tomcat:
      remoteip:
        internal-proxies: "100\\.9[6-9]\\.\\d{1,3}\\.\\d{1,3}|\
          100\\.1[01]\\d\\.\\d{1,3}\\.\\d{1,3}|\
          100\\.12[0-7]\\.\\d{1,3}\\.\\d{1,3}"
```
