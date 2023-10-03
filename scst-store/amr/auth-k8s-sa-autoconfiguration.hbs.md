# Kubernetes service account automatic configuration

This topic tells you about the resources that you create for Kubernetes service account automatic configuration for AMR
authentication and authorization. 

## <a id="overview"></a>Overview

This topic describes which resources play a role in the default configuration
and how to troubleshoot. For more information about the resources, for example,
if you use means to manage your service accounts or have other requirements
related to roles and bindings, see [User-defined kubernetes service account
configuration](auth-k8s-sa-user-defined.hbs.md)

The package-level configuration has a component top level key (TLK)prefix and
this topic describes how Tanzu Application Platform configurations can influence
this prefix.

## <a id="observer"></a>Observer

Observer configuration in the Tanzu Application Platform context has the prefix
TLK `amr.observer`. For authentication and authorization, the Tanzu Application
Platform profiles influence automatic configuration. Observer can only automatically
configure itself when co-located with the cloudevent handler, which is in the
`full` or `view` profile. If this is not the case
`auth.kubernetes_service_accounts.autoconfigure` is set to false at
installation.

If `auth.kubernetes_service_accounts.enable` and `auth.kubernetes_service_accounts.autoconfigure` are true, the observer package creates the following resources to set up authentication automatically in the `amr-observer-system` namespace:

- a `ServiceAccount` named `amr-observer-editor` that observer uses to send requests to the cloudevent handler
- a `Secret` named `amr-observer-edit-token` of type `kubernetes.io/service-account-token` which generates a long-lived token for the service account
- a `ClusterRole` named `tanzu:amr:observer:edit` defining the necessary `update` permissions for all resources in `cloudevents.amr.apps.tanzu.vmware.com`
- a `ClusterRoleBinding` named `tanzu:amr:observer:editor` binding the defined role to the service account

## <a id="cloudevent-handler"></a>Cloudevent handler

You can find the Cloudevent handler configuration in the Tanzu Application Platform context under the TLK `amr.cloudevent_handler`. This prefix is not stripped in this case.

On the package level, if `amr.cloudevent_handler.auth.kubernetes_service_accounts.enable` and `amr.cloudevent_handler.auth.kubernetes_service_accounts.autoconfigure` are true, the package  creates the following resources to set up authentication automatically in the `metadata-store` namespace:

- a `ServiceAccount` named `amr-cloudevent-handler-editor` that clients use to send requests to the cloudevent handler
- a `Secret` named `amr-cloudevent-handler-edit-token` of type `kubernetes.io/service-account-token` which generates a long-lived token for the service account
- a `ClusterRole` named `tanzu:amr:cloudevent-handler:edit` defining the necessary `update` permissions for all resources in `cloudevents.amr.apps.tanzu.vmware.com`
- a `ClusterRoleBinding` named `tanzu:amr:cloudevent-handler:editor` binding the defined role to the service account

## <a id="graphql-handler"></a>GraphQL handler

You can find the GraphQL configuration in the Tanzu Application Platform context under the TLK `amr.graphql`. This prefix is not stripped in this case.

If `amr.graphql.auth.kubernetes_service_accounts.enable` and `amr.graphql.auth.kubernetes_service_accounts.autoconfigure` are true, the package creates the following resources to set up authentication automatically in the `metadata-store` namespace:

- a `ServiceAccount` named `amr-graphql-viewer` that clients  use to send requests to the graphql interface
- a `Secret` named `amr-graphql-view-token` of type `kubernetes.io/service-account-token` which generates a long-lived token for the service account
- a `ClusterRole` named `tanzu:amr:graphql:view` defining the necessary `get` permissions for all resources in `graphql.amr.apps.tanzu.vmware.com`
- a `ClusterRoleBinding` named `tanzu:amr:graphql:viewer` binding the defined role to the service account