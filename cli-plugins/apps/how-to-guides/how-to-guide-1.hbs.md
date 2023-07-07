# How-to-Guides simple reference

## <a id='create-from-private-repo'></a> Create a workload from a private Git repository

Check how to setup a workload from a Private Git repository in 
[Out of the box supply chain with private Git repos](../../../scc/building-from-source.hbs.md#private-gitrepository),
how the supply chain manages these type of workloads in
[How it works](../../../scc/building-from-source.hbs.md#how-it-works) section and how to
override parameters to customize the behavior to manage then in
[Workload parameters](../../../scc/building-from-source.hbs.md#workload-parameters) section.

## <a id='bind-service-to-workload'></a> Bind a service to a workload

Tanzu Application Platform supports creating a workload with binding to multiple
services ([ServiceBinding](../../service-bindings/about.hbs.md)).
The cluster supply chain is in charge of provisioning those services.

The purpose of these bindings is to provide information from a service resource to an application.

- To bind a database service to a workload, run:

    ```console
    tanzu apps workload apply pet-clinic --service-ref "database=services.tanzu.vmware.com/v1alpha1:MySQL:my-prod-db"
    ```

The `--service-ref` flag references the service using the format `{service-ref-name}={apiVersion}:{kind}:{service-binding-name}`.

<!-- Add title for Workload with OOTB Supply chain-->