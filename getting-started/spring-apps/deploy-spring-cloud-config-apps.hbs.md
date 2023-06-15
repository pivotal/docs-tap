# Deploy Spring Cloud Config applications to Tanzu Application Platform

This topic tells you how to run Spring applications that depend on Spring Cloud Config Server as
workloads on Tanzu Application Platform (commonly known as TAP).

## <a id="identify-apps"></a> Identify Spring Cloud Config applications

The [Spring Cloud Config project](https://spring.io/projects/spring-cloud-config) is used within many
common configuration services for Spring applications, including the following:

- The [Config Server](https://docs.vmware.com/en/Spring-Cloud-Services-for-VMware-Tanzu/3.1/spring-cloud-services/GUID-config-server-index.html)
  in the managed service tile Spring Cloud Services for VMware Tanzu
  that is supported by VMware Tanzu Application Service for VMs.

- [Application Configuration Service for Tanzu](https://learn.microsoft.com/en-us/azure/spring-apps/how-to-enterprise-application-configuration-service) in Azure Spring Apps.
  For more information about Azure Spring Apps, see the
  [Microsoft Azure documentation](https://azure.microsoft.com/en-us/products/spring-apps/).

Spring applications that use these configuration services often include a client dependency that
interacts with the Spring Cloud Config Server:

- Applications that use the Spring Cloud Services Config Server on Tanzu Application Service
  typically include the `spring-cloud-services-starter-config-client` dependency from the
  `io.pivotal.spring.cloud` group.
  For more information, see the [Config Server](https://docs.vmware.com/en/Spring-Cloud-Services-for-VMware-Tanzu/3.1/spring-cloud-services/GUID-client-dependencies.html#config-server)
  in the Spring Cloud Services documentation.

- Applications that use the open-source Spring Cloud Config Server typically include the
   `spring-cloud-starter-config` dependency from the `org.springframework.cloud` group.
   For more information, see the [Spring Cloud Config documentation](https://docs.spring.io/spring-cloud-config/docs/current/reference/html/#_client_side_usage).

## <a id="prerequisites"></a> Prerequisites

Before you can deploy Spring Cloud Config applications, you must
[Install Application Configuration Service for VMware Tanzu](../../application-configuration-service/install-app-config-service.hbs.md).

The Application Configuration Service for VMware Tanzu component in Tanzu Application Platform distributes
configuration information to applications through Kubernetes Secrets that contain Spring properties.

## <a id="configure-workloads"></a> Configure workloads

For instructions for how to run existing Spring applications that rely on the
Spring Cloud Config Server as workloads in Tanzu Application Platform, see
[Configuring Workloads in Tanzu Application Platform using Application Configuration Service](https://docs.vmware.com/en/Application-Configuration-Service-for-VMware-Tanzu/2.0/acs/GUID-gettingstarted-configuringworkloads.html)
in the Application Configuration Service for VMware Tanzu documentation.
