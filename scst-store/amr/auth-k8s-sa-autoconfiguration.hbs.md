# Kubernetes service account autoconfiguration

This site gives an overview of the resources created for the convenience feature of kubernetes service account autoconfiguration for AMR authentication and authorization. It will help you understand which resource plays a role in the default configuration and where to look in case issues arise. If you need a deeper understanding of the resources or if you need to set up these resources, head over to [User-defined kubernetes service account configuration](scst-store/amr/auth-k8s-sa-user-defined.hbs.md). 

All package-level configurations are prefixed with a component top level key (TLK) and can also be influenced by certain TAP level configurations, which will be mentioned in the separate sections.


## Observer

Observer configuration in the TAP context is prefixed with the TLK `amr.observer`. 
For authentication and authorization, the TAP profiles will influence autoconfiguration. The observer can only autoconfigure itself when colocated with the cloudevent handler, which is currently defined as being in `full` or `view` profile. If this is not the case `auth.kubernetes_service_accounts.autoconfigure` will be set to false at install time.

On the package level, if `auth.kubernetes_service_accounts.enable` and `auth.kubernetes_service_accounts.autoconfigure` are true, the observer package will create the following resources to set up authentication automatically in the namespace `amr-observer-system`:

* a `ServiceAccount` named `amr-observer-editor` that observer uses to send requests to the cloudevent handler
* a `Secret` named `amr-observer-edit-token` of type `kubernetes.io/service-account-token` which generates a long-lived token for the service account
* a `ClusterRole` named `tanzu:amr:observer:edit` defining the necessary `update` permissons for all resources in `cloudevents.amr.apps.tanzu.vmware.com`
* a `ClusterRoleBinding` named `tanzu:amr:observer:editor` binding the defined role to the service account


## Cloudevent handler

Cloudevent handler configuration in the TAP context can be found under the TLK `metadata_store.cloudevent_handler`. The `metadata_store` prefix is stripped during the transformation to package level configurations.

On the package level, if `cloudevent_handler.auth.kubernetes_service_accounts.enable` and `cloudevent_handler.auth.kubernetes_service_accounts.autoconfigure` are true, the package will create the following resources to set up authentication automatically in namespace `metadata-store`:

* a `ServiceAccount` named `amr-cloudevent-handler-editor` that clients use to send requests to the cloudevent handler
* a `Secret` named `amr-cloudevent-handler-edit-token` of type `kubernetes.io/service-account-token` which generates a long-lived token for the service account
* a `ClusterRole` named `tanzu:amr:cloudevent-handler:edit` defining the necessary `update` permissions for all resources in `cloudevents.amr.apps.tanzu.vmware.com`
* a `ClusterRoleBinding` named `tanzu:amr:cloudevent-handler:editor` binding the defined role to the service account


## GraphQL handler

GraphQL configuration in the TAP context can be found under the TLK `metadata_store.graphql`. The `metadata_store` prefix is stripped during the transformation to package level configurations.

On the package level, if `graphql.auth.kubernetes_service_accounts.enable` and `graphql.auth.kubernetes_service_accounts.autoconfigure` are true, the package will create the following resources to set up authentication automatically in namespace `metadata-store`:

* a `ServiceAccount` named `amr-graphql-viewer` that clients use to send requests to the graphql interface
* a `Secret` named `amr-graphql-view-token` of type `kubernetes.io/service-account-token` which generates a long-lived token for the service account
* a `ClusterRole` named `tanzu:amr:graphql:view` defining the necessary `get` permissons for all resources in `graphql.amr.apps.tanzu.vmware.com`
* a `ClusterRoleBinding` named `tanzu:amr:graphql:viewer` binding the defined role to the service account
