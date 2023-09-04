# Configure your external DNS with Cloud Native Runtimes

This topic tells you how to configure your external DNS with Cloud Native Runtimes, commonly known as CNR.

## <a id='overview'></a> Overview

Knative uses `svc.cluster.local` as the default domain.

> **Note** If you are setting up Cloud Native Runtimes for development or testing, you do not have to set up an external DNS.
However, to access your workloads over the Internet, you must set up a custom domain and an external DNS.

## <a id='config-custom'></a> Configure custom domain

To set up the custom domain and its external DNS record:

1. Configure your custom domain:

   When your workloads are created, Knative automatically creates URLs for each workload based on the configuration in the domain ConfigMap.

   - To set a default custom domain, edit your `cnr-values.yaml` file to contain the following:

      ```yaml
      ---
      domain_name: "mydomain.com"
      ```

      This edits the Knative domain ConfigMap to use `domain_name` as the default domain.

      > **Note** `domain_name` must be a valid DNS subdomain.

   - **Advanced** To overwrite the domain ConfigMap entirely, edit your `cnr-values.yaml` file to contain the config-domain options that you want, similar to the following:
      
      ```yaml
      ---
      domain_config: |
         ---
         mydomain.com: |

         mydomain.org: |
            selector:
               app: nonprofit
      ```

      This replaces the body of the Knative domain ConfigMap with `domain_config`. This allows you to configure multiple custom domains, and configure a custom domain for a service depending on its labels.

      See [Changing the default domain](https://knative.dev/docs/serving/using-a-custom-domain/#changing-the-default-domain) for more information about the structure of the domain ConfigMap.

      > **Note** `domain_config` must be valid YAML and a valid domain ConfigMap.

   > **Note** You can only use one of `domain_config` or `domain_name` at a time. You can not use both.

2. Get the address of the cluster load balancer:

   ```console
   kubectl get service envoy -n EXTERNAL-CONTOUR-NS --output 'jsonpath={.status.loadBalancer.ingress}'
   ```

   Where `EXTERNAL-CONTOUR-NS` is the namespace where a Contour serving external traffic is installed. If Cloud Native Runtimes was installed as part of a Tanzu Application Profile, this value is likely `tanzu-system-ingress`.

    If this command returns a URL instead of an IP address,
    `ping` the URL to get the load balancer IP address.

3. Create a wildcard DNS `A` record that assigns the custom domain to the load balancer IP.
   Follow the instructions provided by your domain name registrar for creating records.

    The following is an example of the record you create:

    ```console
    *.DOMAIN IN A TTL LOADBALANCER-IP
    ```

    Where:

    * `DOMAIN` is the custom domain.
    * `TTL` is the time-to-live.
    * `LOADBALANCER-IP` is the load balancer IP.

    For example:

    <pre class="terminal">*.mydomain.com IN A 3600 198.51.100.6</pre>

    > If you chose to configure multiple custom domains, you must create a wildcard DNS record for each domain.

## <a id='service-domain'></a> Configure Knative service domain template

Knative uses domain template which specifies the golang text template string to use when constructing the Knative service's DNS name.
The default value is `\{{.Name}}.\{{.Namespace}}.\{{.Domain}}`.
Valid variables defined in the template include Name, Namespace, Domain, Labels, and Annotations.

To configure domain template for the created Knative Services, add the following to your `cnr-values.yaml` file:

```yaml
---
domain_template: "\{{.Name}}-\{{.Namespace}}.\{{.Domain}}"
```

This edits the Knative `domain-template` ConfigMap to use `domain_template` as the default domain template.

Changing this value might be necessary when the extra levels in the domain name generated are problematic for wildcard certificates that only support a single level of domain name added to the certificate's domain.
In those cases you might consider using a value of `\{{.Name}}-\{{.Namespace}}.\{{.Domain}}`, or removing the Namespace entirely from the template.

When choosing a new value, be thoughtful of the potential for conflicts, such as when users the use of characters like `-` in their service or namespace names.

You can use `\{{.Annotations}}` or `\{{.Labels}}` for any customization in the go template if needed.

VMware recommends to keeping namespace in the template to avoid domain name clashes.
For example, `\{{.Name}}-\{{.Namespace}}.\{{ index .Annotations "sub"}}.\{{.Domain}}` and you have an annotation `{"sub":"foo"}`, the generated template is `{Name}-{Namespace}.foo.{Domain}`.
