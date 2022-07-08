# Application Single Sign-On for VMware Tanzu

Application Single Sign-On for VMware Tanzu® (AppSSO) provides APIs for curating and consuming a "Single
Sign-On as a service" offering on Tanzu Application Platform.

With AppSSO, Service Operators can configure and deploy authorization servers. Application Operators can then
configure their Workloads with these authorization servers to provide Single Sign-On to their end-users.

AppSSO allows integrating authentication and authorization decisions early in the software development and release
life cycle. It provides a seamless transition for workloads from development to production when including Single Sign-On solutions in your software.

It's easy to get started with AppSSO, deploy an authorization server with static test users, and eventually progress to
multiple authorization servers of production-grade scale with token key rotation, multiple upstream identity providers, 
and client restrictions.

AppSSO's authorization server is based off
of [Spring Authorization Server](https://github.com/spring-projects/spring-authorization-server).
