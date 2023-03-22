# Overview of Application Configuration Service for VMware Tanzu

Application Configuration Service provides a Kubernetes-native experience to enable the runtime
configuration of existing Spring applications that were previously leveraged by using
Spring Cloud Config Server.

Spring Cloud Config Server was an essential component in microservices architectures for providing
runtime configuration to Spring Boot applications.

Spring Cloud Config Server did this by enabling configuration management to be hosted in Git
repositories on different branches and in directories that could be used to generate runtime
configuration properties for applications.

Application Configuration Service is compatible with the existing Git repository configuration
management approach.
It filters runtime configuration for any application by using slices that produce secrets and
ConfigMaps.

For more information about Application Configuration Service, see the
[Application Configuration Service for VMware Tanzu documentation](https://docs.vmware.com/en/Application-Configuration-Service-for-VMware-Tanzu/2.0/acs/GUID-overview.html).