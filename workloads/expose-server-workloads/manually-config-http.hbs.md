# Expose HTTP server workloads outside the cluster manually

You can expose HTTP `server` workloads outside the cluster by creating an Ingress resource and using
cert-manager to provision TLS-signed certificates. To do so:

1. Using the `spring-sensors-consumer-web` workload from
   [Bind an application workload to the service instance](../../getting-started/consume-services.hbs.md#stk-bind)
   as an example, create the following `Ingress`:

   ```console
   apiVersion: networking.k8s.io/v1
   kind: Ingress
   metadata:
     name: spring-sensors-consumer-web
     namespace: DEVELOPER-NAMESPACE
     annotations:
       cert-manager.io/cluster-issuer: tap-ingress-selfsigned
       ingress.kubernetes.io/force-ssl-redirect: "true"
       kubernetes.io/ingress.class: contour
       kubernetes.io/tls-acme: "true"
   spec:
     tls:
       - secretName: spring-sensors-consumer-web
         hosts:
           - "spring-sensors-consumer-web.INGRESS-DOMAIN"
     rules:
       - host: "spring-sensors-consumer-web.INGRESS-DOMAIN"
         http:
           paths:
             - pathType: Prefix
               path: /
               backend:
                 service:
                   name: spring-sensors-consumer-web
                   port:
                     number: 8080
   ```

   - Replace `DEVELOPER-NAMESPACE` with your developer namespace.
   - Replace `INGRESS-DOMAIN` with the domain name defined in `tap-values.yaml` during the installation.
   - Set the annotation `cert-manager.io/cluster-issuer` to the `shared.ingress_issuer` value
     configured during installation or leave it as `tap-ingress-selfsigned` to use the default value.
   - Update the port exposed by your `Service` resource, which is set as `8080` in the example.

1. Access the `server` workload with HTTPS:

   ```console
   curl -k https://spring-sensors-consumer-web.INGRESS-DOMAIN
   ```