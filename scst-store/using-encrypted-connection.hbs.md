# Configure your target endpoint and certificate for Supply Chain Security Tools - Store

This topic describes how you can configure your target endpoint and certificate for Supply Chain Security Tools (SCST) - Store.

## Overview

The connection to Supply Chain Security Tools - Store requires TLS
encryption, and the configuration depends on the kind of installation.

For a production environment, VMware recommends that SCST - Store is installed
with ingress enabled. The following instructions help set up the TLS connection,
assuming that you deployed with ingress enabled.

## Using `Ingress`

When using an [Ingress setup](ingress.hbs.md), SCST - Store creates a
specific TLS Certificate for HTTPS communications under the `metadata-store`
namespace.

{{> 'partials/insight-ingress-configuration' }}

## Next Step

- [Configure access token](configure-access-token.hbs.md)

## <a id='additional-resources'></a>Additional Resources

For information about deploying SCST - Store **without** Ingress, see:

- [Using LoadBalancer](use-load-balancer.hbs.md)
- [Using NodePort](use-node-port.hbs.md)
