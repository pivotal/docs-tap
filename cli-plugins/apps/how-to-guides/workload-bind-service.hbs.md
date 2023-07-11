# Bind a service to a workload

Tanzu Application Platform supports creating a workload with binding to multiple
services ([ServiceBinding](/service-bindings/about.hbs.md)).
The cluster supply chain is in charge of provisioning those services.

The purpose of these bindings is to provide information from a service resource to an application.

- To bind a database service to a workload, run:

    ```console
    tanzu apps workload apply pet-clinic --service-ref "database=services.tanzu.vmware.com/v1alpha1:MySQL:my-prod-db"
    ```

The `--service-ref` flag references the service using the format `{service-ref-name}={apiVersion}:{kind}:{service-binding-name}`.
