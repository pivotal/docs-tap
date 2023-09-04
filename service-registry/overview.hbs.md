# Overview of Service Registry

Service Registry for VMware Tanzu provides on-demand Eureka servers for your Tanzu Application Platform
(commonly known as TAP) clusters. With Service Registry, you can create Eureka servers in your
namespaces and bind Spring Boot workloads to them. This provides a smooth transition from the past
practice of using Spring Cloud Services for Tanzu Application Service to create Eureka servers.

On-demand namespaced Eureka server instances can be provisioned for microservices Spring Boot
applications that rely on service discovery.

## <a id='capacity-reqs'></a> Capacity Requirements

Each node of the Eureka controller requires:

- 64 MiB of memory
- 10m of vCPU

with limits of:

- 128 MiB of memory
- 500m of vCPU

You can scale the controller horizontally for higher availability.
