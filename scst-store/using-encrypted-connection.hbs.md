# Configure target endpoint and certificate

The connection to the Supply Chain Security Tools - Store requires TLS encryption, and the configuration depends on the kind of installation.

For a production environment, it's recommended that Supply Chain Security Tools - Store is installed with ingress enabled. The following instructions will help set up the TLS connection assuming that you've deployed with ingress enabled.


## Using `Ingress`

When using an [Ingress setup](ingress.hbs.md), the Supply Chain Security Tools - Store creates a specific TLS Certificate for HTTPS communications under the `metadata-store` namespace.

{{> 'partials/insight-ingress-configuration' }}

## Next Step

- [Configure access token](configure-access-token.hbs.md)

## <a id='additional-resources'></a>Additional Resources

For instructions on deploying the Supply Chain Security Tools - Store **without** Ingress, see:

- [Using LoadBalancer](configuration/use-load-balancer.hbs.md)
- [Using NodePort](configuration/use-node-port.hbs.md)
