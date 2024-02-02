# Configure Contour to support TLS termination at an AWS NLB

This topic tells you how to configure Contour to accept traffic from an AWS 
Network LoadBalancer (NLB) that terminates TLS traffic.

This topic is adapted from this [AWS Knowledge Center Post](https://repost.aws/knowledge-center/terminate-https-traffic-eks-acm).

## <a id="prereqs"></a>Prerequisites

The following are required before proceeding with the configuration: 

- An EKS cluster.
- The Contour package installed on the cluster, either as part of Tanzu Application Platform or from the [standalone component installation](install.hbs.md).
- Access to AWS Certificate Manager.
- A domain (registered in Route53 or elsewhere). This topic refers to this domain as `DOMAIN`.
- A certificate for `*.DOMAIN`.

### <a id="domain-for-certificate"></a> A note on Certificates and Domains

This topic will cover the simplest case of using a wildcard cert for your domain.

For example, if your domain is `bigbiz.com`, then the certificate should be for the wildcard domain `*.bigbiz.com`, and everything routed through Contour should fit that domain pattern.

However, in TAP, the default URL pattern for Web Workloads (i.e. Knative Services) is `{{.Name}}.{{.Namespace}}.{{.Domain}}`.

The wildcard cert described previously will not apply to these URLs. To account for this, this topic will explain how to configure CNRs (Cloud Native Runtimes) such that Web Workload URLs will also fit the wildcard domain.

It is possible to keep the default URL pattern if your `DOMAIN` includes the namespace where web workloads will be deployed.

## <a id="procedure"></a>Procedure

### <a id="part1"></a>Part 1: Creating a TLS certificate in ACM

1. Using AWS Certificate Manager (ACM), import your certificate. 

    ![Image of ACM import certificate interface.](./images/aws-acm-import-certificate.png)
    
    This is streamlined when Route 53 manages `DOMAIN`.

    **Important:** Note down the `ARN` of the created certificate, which is required in the following steps.

### <a id="part2"></a>Part 2: Configuring TAP

1. Create the following overlay in `overlay-contour-envoy-secret.yaml` and apply it to your cluster:

   ```
   apiVersion: v1
   kind: Secret
   metadata:
    name: overlay-contour-envoy
    namespace: tap-install
   stringData:
    overlay-contour-envoy.yml: |
      #@ load("@ytt:overlay", "overlay")
   
      #@overlay/match by=overlay.subset({"kind": "Service", "metadata": {"name": "envoy"}})
      ---
      spec:
        ports:
        #@overlay/match by=overlay.subset({"name":"https"})
        -
          targetPort: 8080
   ```

   ```
   kubectl apply -f overlay-contour-envoy-secret.yaml
   ```

1. Add the following configurations to your TAP values file.

   ```yaml
   shared:
     ingress_issuer: ""
     ingress_domain: DOMAIN
   
   tap_gui:
     app_config:
        app:
          baseUrl: https://tap-gui.DOMAIN #! note the change in scheme
        backend:
          baseUrl: https://tap-gui.DOMAIN #! note the change in scheme
          reading:
            allow:
            - host: "*.DOMAIN"

   cnrs:
     default_external_scheme: "https"
     ingress_issuer: ""
     domain_template: "{{.Name}}-{{.Namespace}}.{{.Domain}}"

   contour:
     envoy:
       service:
         annotations:
           service.beta.kubernetes.io/aws-load-balancer-ssl-cert: ARN
           service.beta.kubernetes.io/aws-load-balancer-backend-protocol: http

   package_overlays:
   - name: contour
     secrets:
     - name: overlay-contour-envoy
   ```

   Where `ARN` is the ARN noted down from part 1.

1. Update your Tanzu Application Platform install:
 
    ```console
    tanzu package installed update tap -n tap-install --values-file tap-values.yaml -p tap.tanzu.vmware.com -v VERSION
    ```

    Where `VERSION` is the version of Tanzu Application Platform in use, which must be in the form of `X.X.X`.


Assuming TAP has updated successfully, move on to the next part.

### <a id="part3"></a> Part 3: Configuring AWS


1. (Optional) Find the load balancer associated with Contour's Envoy LoadBalancer Service and confirm that the HTTPS listeners are configured.
    
    At this point, you should have an AWS Load Balancer pointing to Contour's Envoy(s).

    On your LB, you should see two listeners, 80 and 443, both using the certificate associated with the `ARN` in your tap-values file.

    ![Image of listeners on AWS LB.](./images/aws-lb-https-listeners.png)

    > **Note:** In order to prevent your URLs from being accessible over HTTP, port 80 is also configured to listen on HTTPS. 
      If you wish to leave port 80 open to HTTP traffic, you can add the annotation `service.beta.kubernetes.io/aws-load-balancer-ssl-ports: "https"` to your tap-values file at `contour.envoy.service.annotations`.
      Without that annotation, by default, AWS will add SSL/HTTPS listeners for all ports on the Kubernetes Service. Using the annotation, it only adds an SSL/HTTPS listener for the `https` port on the service. More information on the annotations can be found [here](https://cloud-provider-aws.sigs.k8s.io/service_controller/).
    


1. Configure the domain name system (DNS).

    1. Get the External IP of the Envoy service:

        ```console
        kubectl get svc envoy -n NAMESPACE
        ```

        Where `NAMESPACE` is the namespace where Contour is installed. The default value is `tanzu-system-ingress` unless configured otherwise.

	      The result resembles the following:

        ```console
        NAME    TYPE           CLUSTER-IP      EXTERNAL-IP                                                                     PORT(S)            AGE
         envoy   LoadBalancer   10.100.24.154   a7ea2bbde8a164036a7e4c1ed5700cdf-154fb911d990bb1f.elb.us-east-2.amazonaws.com   443:31606/TCP      40d
        ```

    1. Create a DNS record pointing from `DOMAIN` to the NLB Domain, which is the External IP value from the previous step.


        In the **Route traffic to** section, you must set:

        - Alias to Network LoadBalancer.
        - The appropriate region for your NLB.
        - The name of your NLB domain from the previous step.

        It resembles the following:

        ![Screenshot displaying the AWS quick create record interface.](images/aws-dns-record.png)

	    >**Note:** If not using AWS Route53, you must create a CNAME entry in your DNS provider. Otherwise, with AWS Route53, you can create an "A" record type, and alias it to the Network Loadbalancer.

## <a id="verify"></a>Verification

If you have a Web Workload on the cluster, you can check to see that it available at `https://appname-appnamespace.DOMAIN`.