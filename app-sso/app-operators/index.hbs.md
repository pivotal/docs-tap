# Application Single Sign-On for App Operators

This topic tells you how to secure a sample app with Application Single Sign-On 
(commonly called AppSSO).

To secure a `Workload` with AppSSO you need a `ClientRegistration` with these ingredients:

* A unique label selector for the `AuthServer` you want to register a client for
* Remaining configuration of your OAuth2 client

Talk to your _Service Operator_ to learn which `AuthServers` they are running and which labels you should use.
Once you have those labels, you can create a `ClientRegistration` as follows:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClientRegistration
metadata:
  name: my-client
  namespace: my-team
spec:
  authServerSelector:
    matchLabels: # for example
      env: staging
      ldap: True
      team: my-team
```

Continue with learning how to customize your `ClientRegistration`
by [securing a Workload with SSO](tutorials/securing-first-workload.md).

Learn more about [grant types](grant-types.md) and find [help for common issues](../troubleshoot.md)
