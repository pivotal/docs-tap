# DNS Records

There are some optional but recommended DNS records you should allocate if you decide to use these particular components:

- Cloud Native Runtimes (knative) - Allocate a wildcard subdomain for your developer's applications. This is specified in the `cnrs.domain_name` key of the `tap-values.yml` configuration file that you input with the installation. This wildcard should be pointed at the external IP address of the `tanzu-system-ingress`'s `envoy` service.
- Tanzu Learning Center - Similar to Cloud Native Runtimes, allocate a wildcard subdomain for your workshops and content. This is specified in the `learningcenter.ingressDomain` key of the `tap-values.yml` configuration file that you input with the installation. This wildcard should be pointed at the external IP address of the `tanzu-system-ingress`'s `envoy` service.
- Tanzu Application Platform GUI - Should you decide to implement the share ingress and include the Tanzu Application Platform GUI, allocate a fully Qualified Domain Name (FQDN) that can be pointed at the `tanzu-system-ingress` service.
The default hostname consists of `tap-gui` plus an `IngressDomain` of your choice. For example,
`tap-gui.example.com`.
