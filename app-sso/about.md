# Application Single Sign-On for VMware Tanzu

_Application Single Sign-On for VMware Tanzu®_, short _AppSSO_, provides APIs for curating and consuming a "Single
Sign-On as a service" offering on _Tanzu Application Platform_.

> * ⏩ Are you a _**service operator**_ and want to provide app teams with Single Sign-On as a service?
    Start [here](https://docs-staging.vmware.com/en/Application-Single-Sign-On-for-VMware-Tanzu/1.0.0-beta/appsso-1.0.0-beta/GUID-service-operators-index.html).
> * ⏩ Are you an _**application operator**_ and want to secure your workload with Single Sign-On?
    Start [here](https://docs-staging.vmware.com/en/Application-Single-Sign-On-for-VMware-Tanzu/1.0.0-beta/appsso-1.0.0-beta/GUID-app-operators-index.html).
> * ⏩ Do you want to install AppSSO manually rather than using the TAP component?
    Start [here](https://docs-staging.vmware.com/en/Application-Single-Sign-On-for-VMware-Tanzu/1.0.0-beta/appsso-1.0.0-beta/GUID-platform-operators-index.html)

---

With AppSSO _Service Operators_ can configure and deploy authorization servers. _Application Operators_ can then
configure their Workloads with these authorization servers to provide Single Sign-On to their end-users.

AppSSO allows integrating authentication and authorization decisions early in the software development and release
lifecycle. It provides a seamless transition for workloads from development to production when including Single Sign-On
solutions in your software.

It's easy to get started with AppSSO; deploy an authorization server with static test users. Eventually, progress to
multiple authorization servers of production-grade scale with token key rotation, multiple upstream identity providers
and client restrictions.

AppSSO's authorization server is based off
of [Spring Authorization Server](https://github.com/spring-projects/spring-authorization-server).

**Important**: The functionality of beta features has been tested, but performance has not. Features enter the beta
stage for customers to gain early access to them and give feedback on their design and behavior. Beta features might
undergo changes based on that feedback before leaving beta. VMware discourages running beta features in production.
VMware does not guarantee that any beta feature can be upgraded in the future.
