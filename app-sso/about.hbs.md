# Overview of Application Single Sign-On for VMware Tanzu® {{ vars.app-sso.version }}

Application Single Sign-On for VMware Tanzu® (AppSSO) provides APIs for curating and consuming a "Single
Sign-On as a service" offering on Tanzu Application Platform.

To get started with AppSSO, see [Get started with Application Single Sign-On](./getting-started/index.hbs.md).

With AppSSO, Service Operators can configure and deploy authorization servers. Application Operators can then
secure their Workloads with these authorization servers to provide Single Sign-On to their end-users.

AppSSO allows integrating authentication and authorization decisions early in the software development and release
life cycle. It provides a seamless transition for workloads from development to production when including Single Sign-On
solutions in your software.

It's easy to get started with AppSSO, deploy an authorization server with static test users, and eventually progress to
multiple authorization servers of production-grade scale with token key rotation, multiple upstream identity providers,
configured secure storage, and client restrictions.

AppSSO's authorization server is based on the Spring Authorization Server project.
For more information, see [Spring documentation](https://spring.io/projects/spring-authorization-server).

## <a id="doc-org"></a> Document organization

The Application Single Sign-On component documentation consists of the following
subsections that relate to what you want to achieve:

- [How-to guides](how-to-guides/index.hbs.md): To find a set of steps to solve
  a specific problem acting as a certain user persona.
- [Concepts](concepts/index.hbs.md): To gain a deeper understanding of Application
  Single Sign-On.
- [Reference](reference/index.hbs.md): To find specific information such as
  Application Single Sign-On's APIs.

Tutorials and concepts are of most relevance when studying, while how-to guides
and reference material are of most use while working.

The following is a selection of useful topics on offer:

**For application developers:**

- [Application Single Sign-On for App Operators](how-to-guides/app-operators/index.hbs.md)

**For service operators:**

- [Application Single Sign-On for Service Operators](how-to-guides/service-operators/index.hbs.md)

**For platform operators:**

- [Application Single Sign-On for Platform Operators](how-to-guides/platform-operators/index.hbs.md)

**For everyone:**

- [Levels of consumption for Application Single Sign-On](concepts/levels-of-consumption.hbs.md)
