# Deploy Spring Cloud Config applications

This topic describes how to run Spring applications that depend on Spring Cloud Config Server as workloads on Tanzu Application Platform.

## <a id="identify-spring-cloud-config-apps"></a> Identify Spring Cloud Config applications

The [Spring Cloud Config project](https://spring.io/projects/spring-cloud-config) is used within many common configuration services for Spring applications, including the following:

- The [Config Server](https://docs.vmware.com/en/Spring-Cloud-Services-for-VMware-Tanzu/3.1/spring-cloud-services/GUID-config-server-index.html) in [Spring Cloud Services for VMware Tanzu](https://docs.vmware.com/en/Spring-Cloud-Services-for-VMware-Tanzu/3.1/spring-cloud-services/GUID-index.html), a managed service tile for [VMware Tanzu Application Service for VMs](https://network.tanzu.vmware.com/products/elastic-runtime/).
- The [Application Configuration Service for Tanzu](https://learn.microsoft.com/en-us/azure/spring-apps/how-to-enterprise-application-configuration-service) in [Azure Spring Apps](https://azure.microsoft.com/en-us/products/spring-apps/).

Spring applications that use these configuration services often include a client dependency that interacts with the Spring Cloud Config Server:

- Applications that use the Spring Cloud Services Config Server on Tanzu Application Service typically include the `spring-cloud-services-starter-config-client` dependency from the `io.pivotal.spring.cloud` group. See the [Config Server](https://docs.vmware.com/en/Spring-Cloud-Services-for-VMware-Tanzu/3.1/spring-cloud-services/GUID-client-dependencies.html#config-server) section of the _Client Dependencies_ topic in the Spring Cloud Services documentation for more information.
- Applications that use the open-source Spring Cloud Config Server typically include the `spring-cloud-starter-config` dependency from the `org.springframework.cloud` group. See the [Client Side Usage](https://docs.spring.io/spring-cloud-config/docs/current/reference/html/#_client_side_usage) topic in the Spring Cloud Config documentation for more information.

## <a id="prerequisites"></a> Prerequisites

The [Application Configuration Service for VMware Tanzu](https://docs.vmware.com/en/Application-Configuration-Service-for-VMware-Tanzu/2.0/acs/GUID-overview.html) component of Tanzu Application Platform distributes configuration information to applications through Kubernetes Secrets that contain Spring properties. See [Install Application Configuration Service for VMware Tanzu](../application-configuration-service/install-app-config-service.hbs.md) for more information on installing this optional component of Tanzu Application Platform.

## <a id="configure-workloads"></a> Configure workloads

See [Configuring Workloads in Tanzu Application Platform using Application Configuration Service](https://docs.vmware.com/en/Application-Configuration-Service-for-VMware-Tanzu/2.0/acs/GUID-gettingstarted-configuringworkloads.html) in the Application Configuration Service for VMware Tanzu documentation for more information about how to run existing Spring applications that rely on the Spring Cloud Config Server as workloads in Tanzu Application Platform.
