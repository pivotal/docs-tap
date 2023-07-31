# Known issues for Learning Center

This topic gives you information about known issues for Learning Center and how to mitigate them.

## <a id="CVE-2023-26114"></a>Mitigation for CVE-2023-26114

Critical: [CVE-2023-26114](https://nvd.nist.gov/vuln/detail/CVE-2023-26114) (GHSA ID: [GHSA-frjg-g767-7363](https://github.com/advisories/GHSA-frjg-g767-7363))

**Description:**

Versions of the package code-server before v4.10.1 are vulnerable to Missing Origin Validation in WebSocket
handshakes. This affects those who use older browsers that do not support SameSite cookies and those
who access code-server under a shared domain with other users on separate sub-domains.
Exploiting this vulnerability might allow an adversary to access data from, and connect to, the
code-server instance.

**Learning Center Context:**

Learning Center includes VS Code server as an IDE for the workshop session, giving users the ability
to create and edit workshop files.
Each time there is a new session, the operator deploys a new VS Code instance that is used only for
that specific session for a single user. This VS Code server is an ephemeral instance used only
for the amount of time that is declared in the workshop definition. After that amount of time,
the Learning Center operator removes the workshop resources and the VS Code instance.

**Mitigation:**

You can mitigate this issue in the following ways:

- If you don't require an IDE for your workshop, deactivate the VS Code editor in the workshop definition.
  For more information, see
  [Enabling the integrated editor](../learning-center/runtime-environment/workshop-definition.hbs.md#enable-integrated-editor).

- Enable an event access code on the portal, so there is no way to consume the VS Code instance without
  the access code.
  For more information, see
  [Specify an event access code](../learning-center/runtime-environment/training-portal.hbs.md#specify-event-access-code)

- Reduce the exposition by setting up workshop sessions to expire after a set time.
  After it has expired, the workshop session is deleted.
  [Expiration of workshop sessions](../learning-center/runtime-environment/training-portal.hbs.md#expiring-of-ws-sessions)

- Some load balancers allow access only from specific IPs. If this is an available option,
  configure the load balancer to limit access to the company network or specific IPs.
