# Configure Contour to Support TLS Termination at an AWS Network LoadBalancer

This topic tells you how to configure Contour so that it can accept traffic from an AWS NLB that terminates TLS traffic.

**Note:** This guide only applies to the Contour Package from TAP 1.7.0 and onwards.

## <a id="prereqs"></a>Prerequisites

* An EKS Cluster
* The Contour Package installed on the cluster
  * either as part of TAP, or from the [individual install](../install.hbs.md)
* Access to Route53 and AWS Certificate Manager
* A domain registered in Route53 (this guide will refer to this domain as DOMAIN)

## <a id="procedure"></a>Procedure

The following steps correspond to the steps in the [Open Source documentation](https://projectcontour.io/docs/1.25/guides/deploy-aws-tls-nlb/#configure). The only difference is in Step 2. Rather than creating/updating resources manually, this doc explains how make the appropriate configurations via the `tap-values.yaml` file.

1. Generate a TLS Certificate

   Create a public TLS certificate for DOMAIN using AWS Certificate Manager (ACM). This is streamlined when DOMAIN is managed by Route 53.

   Note down the ARN of the created certificate, it will be needed in the following steps.

2. Modify the Contour Package install values

   - If you are using a `tap-values.yml` file, update the Contour section with the following:

      ```
      contour:
        ...
        envoy:
          service:
	        loadBalancerTLSTermination: true
	        annotations: |
	          service.beta.kubernetes.io/aws-load-balancer-type: external
              service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
              service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
              service.beta.kubernetes.io/aws-load-balancer-ssl-cert: <ARN>
              service.beta.kubernetes.io/aws-load-balancer-ssl-ports: "443"
      ```

      Where `ARN` is the ARN noted down from Step 1

	  If you are only installing the Contour Package standlone, you just need to update your values file with the `envoy.service` section.
   - Update your TAP install:
 
	 ```
	 tanzu package installed update tap -n tap-install -f tap-values.yml -p tap.tanzu.vmware.com -v X.X.X
	 ```

	 where `X.X.X` is the version of TAP you are using.

3. Configure DNS

   - Get the External IP of the Envoy Service
     
	 ```
	 kubectl get svc envoy -n NAMESPACE
	 ```

	 where `NAMESPACE` is the namespace where Contour is installed (`tanzu-system-ingress` unless configured otherwise)

	 The result should look something like:

	 ```
	 NAME    TYPE           CLUSTER-IP      EXTERNAL-IP                                                                     PORT(S)            AGE
     envoy   LoadBalancer   10.100.24.154   a7ea2bbde8a164036a7e4c1ed5700cdf-154fb911d990bb1f.elb.us-east-2.amazonaws.com   443:31606/TCP      40d
	 ```

   - Setup a DNS Entry
 
	 Create a DNS record pointing from DOMAIN to the NLB Domain (the External IP value from the previous step)

	 If you **are not** using AWS Route53, then you will need to create a CNAME entry in your DNS provider.

	 Otherwise, with AWS Route53, you can create an "A" record type, and alias it to the Network Loadbalancer.

	 In the "route traffic to" section, you should set:
	 - "Alias to Network Loadbalancer"
	 - The appropriate region for your NLB
	 - The name of your NLB domain from the previous step

	 It will look something like this:

	 ![aws-dns-record-screenshot](images/aws-dns-record.png)



## <a id="verify"></a>Verify

You can verify this conifguration by applying a simple test app and corresponding HTTPProxy resource.

Make the sure FQDN on the HTTPProxy resource matches the DOMAIN you used in the setup.
