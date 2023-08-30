# Overview of Service Registry

Service Registry provides on demand Eureka Servers for Tanzu Application
Platform clusters. Customers can create Eureka Servers in their namespaces and
bind Spring Boot Workloads to them. This provides a smoother transition to
customers accustomed to creating Eureka servers via Spring Cloud Services for
Tanzu Application Service.

## Key Features

Service Registry for VMware Tanzu includes the following key features:

- On-demand namespaced Eureka Server instances that can be provisioned for
  microservices Spring Boot applications that rely on service discovery.

## Capacity Requirements

Each node of the Eureka Controller requires:

- 64 MiB of memory
- 10m of vCPU

With limits of:

- 128 MiB of memory
- 500m of vCPU

The controller may be scaled horizontally for higher availability.
