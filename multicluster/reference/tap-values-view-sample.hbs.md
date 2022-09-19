# View profile

The following is the YAML file sample for the view-profile:

```yaml
profile: view
ceip_policy_disclosed: FALSE-OR-TRUE-VALUE # Installation fails if this is not set to true. Not a string.

shared:
  ingress_domain: "INGRESS-DOMAIN"
  kubernetes_distribution: "openshift" # To be passed only for Openshift. Defaults to "".

contour:
  envoy:
    service:
      type: LoadBalancer #NodePort can be used if your Kubernetes cluster doesn't support LoadBalancing

tap_gui:
  service_type: ClusterIP
  app_config:
    app:
      baseUrl: http://tap-gui.INGRESS-DOMAIN
    catalog:
      locations:
        - type: url
          target: https://GIT-CATALOG-URL/catalog-info.yaml
    backend:
      baseUrl: http://tap-gui.INGRESS-DOMAIN
      cors:
        origin: http://tap-gui.INGRESS-DOMAIN
    kubernetes:
      serviceLocatorMethod:
        type: 'multiTenant'
      clusterLocatorMethods:
        - type: 'config'
          clusters:
            - url: CLUSTER-URL
              name: CLUSTER-NAME
              authProvider: serviceAccount
              serviceAccountToken: CLUSTER-TOKEN
              skipTLSVerify: TRUE-OR-FALSE-VALUE
tap_telemetry:
  customer_entitlement_account_number: "CUSTOMER-ENTITLEMENT-ACCOUNT-NUMBER" # (optional) identify data for creation of TAP usage reports
```

Where:

- `INGRESS-DOMAIN` is the subdomain for the host name that you point at the `tanzu-shared-ingress`
service's external IP address.
- `GIT-CATALOG-URL` is the path to the `catalog-info.yaml` catalog definition file. You can download either a blank or populated catalog file from the [Tanzu Application Platform product page](https://network.pivotal.io/products/tanzu-application-platform/#/releases/1043418/file_groups/6091). Otherwise, use a Backstage-compliant catalog you've already built and posted on the Git infrastructure in the Integration section.
- `CLUSTER-URL`, `CLUSTER-NAME` and `CLUSTER-TOKEN` are described in the [Viewing resources on multiple clusters in Tanzu Application Platform GUI](../../tap-gui/cluster-view-setup.md). Observe the [order of operations](../installing-multicluster.md#order-of-operations) laid out in the previous steps.
- `APP-LIVE-VIEW-INGRESS-DOMAIN` is the subdomain you setup to communicate with the App Live View Connectors on your Run-profile servers. This corresponds to the value key `appliveview_connector.backend.host`.
- `CUSTOMER-ENTITLEMENT-ACCOUNT-NUMBER` (optional) The Entitlement Account Number (EAN) is a unique identifier VMware assigns to its customers.  TAP telemetry can use this number to identify data that belongs to a particular customers so that we can prepare usage reports that summarize usage.  Documentation to locate the number can be found [here](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.5/vmware-tanzu-kubernetes-grid-15/GUID-cluster-lifecycle-ceip.html#identify-the-entitlement-account-number-2)
