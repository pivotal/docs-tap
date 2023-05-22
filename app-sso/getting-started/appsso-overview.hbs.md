# Get started with Application Single Sign-On

At the core of AppSSO is the concept of an Authorization Server, outlined by
the [AuthServer custom resource](../crds/authserver.md). Service Operators create those resources to provision running
Authorization Servers, which are [OpenID Connect](https://openid.net/specs/openid-connect-core-1_0.html)
Providers. They issue [ID Tokens](https://openid.net/specs/openid-connect-core-1_0.html#IDToken) to Client applications,
which contain identity information about the End-User (such as email, first name, last name, etc).

![Diagram of AppSSO's components and how they interact with End-Users and Client applications](../../images/app-sso/appsso-concepts.png)

When a Client application uses an AuthServer to authenticate an End-User, the typical steps are:

1. The End-User visits the Client application
2. The Client application redirects the End-User to the AuthServer, with an OAuth2 request
3. The End-User logs in with the AuthServer, usually using an external Identity Provider (e.g. Google, Azure AD)
    1. Identity Providers are set up by Service Operators
    2. AuthServers may use various protocols to obtain identity information about the user, such as OpenID Connect, SAML
       or LDAP, which may involve additional redirects
4. The AuthServer redirects the End-User to the Client application with an authorization code
5. The Client application exchanges with the AuthServer for an `id_token`
    1. The Client application does not know how the identity information was obtained by the AuthServer, it only gets
       identity information in the form of an ID Token.

[ID Tokens](https://openid.net/specs/openid-connect-core-1_0.html#IDToken) are JSON Web Tokens containing standard
Claims about the identity of the user (e.g. name, email, etc) and about the token itself (e.g. "expires at", "audience",
etc.). Here is an example of an `id_token` as issued by an Authorization Server:

```json
{
  "iss": "https://appsso.example.com",
  "sub": "213435498y",
  "aud": "my-client",
  "nonce": "fkg0-90_mg",
  "exp": 1656929172,
  "iat": 1656928872,
  "name": "Jane Doe",
  "given_name": "Jane",
  "family_name": "Doe",
  "email": "jane.doe@example.com"
}
```

ID Tokens are signed by the `AuthServer`, using [Token Signature Keys](../service-operators/token-signature.md). Client
applications may verify their validity using the AuthServer's public keys.

## Getting started

---

👉 This section assumes AppSSO is installed on your TAP cluster. To install AppSSO, refer to the instructions
in [Install AppSSO](../platform-operators/installation.md).

---

In this section, you will:

1. [Set up your first authorization server](provision-auth-server.md), and validate that it is running
1. [Provision a ClientRegistration](client-registration.md), and validate it is working
1. [Deploy an application](application.md) that uses the provisioned ClientRegistration to enable SSO

---

✅ Once you have completed the above steps, you can continue
by [securing a Workload](../app-operators/tutorials/securing-first-workload.md).

---

---

⏩ Move on to [Provision your first AuthServer](provision-auth-server.md)

---
