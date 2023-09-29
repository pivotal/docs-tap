# Kubernetes service account autoconfiguration

This site is giving an overview about the resources that get created for the convenience feature of kubernetes service account autoconfiguration for AMR authentication and authorization. It will help you nderstand which resource play a role in the default configuration and where to look at in case issues arise. If you need a more deep understanding of the resources and if you are in need to set up these resources on your own, for example if you use means to manage your service accounts or have other requirements related to roles and bindings head over to [User-defined kubernetes service account configuration](auth-k8s-sa-user-defined.hbs.md)

All of the package-level configuration is prefixed with a component top level key (TLK) and can also be inflenced by certain TAP level configuration, which will be mentioned in the seperate sections.


## Observer

Observer configuration in the TAP context is prefixed with the TLK `amr.observer`.
For authentication and authorization the TAP profiles will influence autconfiguration. Observer can only autoconfigure itself when colocated with the cloudevent handler, which is currently defined as being in `full` or `view` profile. If this is not the case `auth.kubernetes_service_accounts.autoconfigure` will be set to false at install time.

On the package level, if `auth.kubernetes_service_accounts.enable` and `auth.kubernetes_service_accounts.autoconfigure` are true, the observer package will create the following resources to set up authentication automatically in namespace `amr-observer-system`:

* a `ServiceAccount` named `amr-observer-editor` that observer will use to send requests to the cloudevent handler
* a `Secret` named `amr-observer-edit-token` of type `kubernetes.io/service-account-token` which will generate a long-lived token for the service account
* a `ClusterRole` named `tanzu:amr:observer:edit` defining the necessary `update` permissons for all resources in `cloudevents.amr.apps.tanzu.vmware.com`
* a `ClusterRoleBinding` named `tanzu:amr:observer:editor` binding the defined role to the service account



## Cloudevent handler

Cloudevent handler configuration in the TAP context can be found under the TLK `amr.cloudevent_handler`. This prefix is not stripped in this case.

On the package level, if `amr.cloudevent_handler.auth.kubernetes_service_accounts.enable` and `amr.cloudevent_handler.auth.kubernetes_service_accounts.autoconfigure` are true, the package will create the following resources to set up authentication automatically in namespace `metadata-store`:

* a `ServiceAccount` named `amr-cloudevent-handler-editor` that clients will use to send requests to the cloudevent handler
* a `Secret` named `amr-cloudevent-handler-edit-token` of type `kubernetes.io/service-account-token` which will generate a long-lived token for the service account
* a `ClusterRole` named `tanzu:amr:cloudevent-handler:edit` defining the necessary `update` permissons for all resources in `cloudevents.amr.apps.tanzu.vmware.com`
* a `ClusterRoleBinding` named `tanzu:amr:cloudevent-handler:editor` binding the defined role to the service account


## GraphQL handler

GraphQL configuration in the TAP context can be found under the TLK `amr.graphql`. This prefix is not stripped in this case.

On the package level, if `amr.graphql.auth.kubernetes_service_accounts.enable` and `amr.graphql.auth.kubernetes_service_accounts.autoconfigure` are true, the package will create the following resources to set up authentication automatically in namespace `metadata-store`:

* a `ServiceAccount` named `amr-graphql-viewer` that clients will use to send requests to the graphql interface
* a `Secret` named `amr-graphql-view-token` of type `kubernetes.io/service-account-token` which will generate a long-lived token for the service account
* a `ClusterRole` named `tanzu:amr:graphql:view` defining the necessary `get` permissons for all resources in `graphql.amr.apps.tanzu.vmware.com`
* a `ClusterRoleBinding` named `tanzu:amr:graphql:viewer` binding the defined role to the service account