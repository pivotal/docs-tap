# Application Configuration Service for VMware Tanzu

Application Configuration Service provides a kubernetes-native experience to enable the runtime 
configuration existing Spring applications previously leveraged via Spring Cloud Config Server. 
Spring Cloud Config Server was an essential component in microservices architectures in providing 
runtime configuration to Spring Boot applications. It did this by allowing configuration management 
to be hosted in Git repositories on different branches and folders that could be used to generate 
runtime configuration properties for applications. Application Configuration Service is compatible 
with the existing Git repository configuration management approach and filters runtime configuration 
for any application via slices which produce Secrets and ConfigMaps.

For more information about Application Configuration Service, see the 
[Application Configuration Service for VMware Tanzu documentation](https://docs.vmware.com/en/Application-Configuration-Service-for-VMware-Tanzu/index.html).