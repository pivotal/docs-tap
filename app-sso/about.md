# Application Single Sign-On for VMware Tanzu

Application Single Sign-On for VMware Tanzu® (AppSSO) provides APIs for curating and consuming a "Single
Sign-On as a service" offering on Tanzu Application Platform.

- To provide app teams with Single Sign-On service as a **service operator**, see [AppSSO for Service Operators](https://docs.vmware.com/en/Application-Single-Sign-On-for-VMware-Tanzu/1.0.0-beta/appsso-1.0.0-beta/GUID-service-operators-index.html).
- To secure your workload with Single Sign-On as an **application operator**, see [AppSSO for App Operators](https://docs.vmware.com/en/Application-Single-Sign-On-for-VMware-Tanzu/1.0.0-beta/appsso-1.0.0-beta/GUID-app-operators-index.html).
- To install AppSSO manually rather than using the Tanzu Application Platform component as a **platform operator**, see [AppSSO for Platform Operators](https://docs.vmware.com/en/Application-Single-Sign-On-for-VMware-Tanzu/1.0.0-beta/appsso-1.0.0-beta/GUID-platform-operators-index.html).

With AppSSO, Service Operators can configure and deploy authorization servers. Application Operators can then
configure their Workloads with these authorization servers to provide Single Sign-On to their end-users.

AppSSO allows integrating authentication and authorization decisions early in the software development and release
life cycle. It provides a seamless transition for workloads from development to production when including Single Sign-On solutions in your software.

It's easy to get started with AppSSO, deploy an authorization server with static test users, and eventually progress to
multiple authorization servers of production-grade scale with token key rotation, multiple upstream identity providers, 
and client restrictions.

AppSSO's authorization server is based off
of [Spring Authorization Server](https://github.com/spring-projects/spring-authorization-server) in GitHub.

> **Important:** The functionality of beta features is tested, but performance is not. Features enter the beta 
>stage for customers to gain early access to them and give feedback on their design and behavior. Beta features might 
>undergo changes based on that feedback before leaving beta. VMware discourages running beta features in production. 
>VMware does not guarantee that any beta feature can be upgraded in the future.
