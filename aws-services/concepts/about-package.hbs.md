# About the AWS Services package

This topic tells you about the goal of the AWS Services package and some of its limitations.

## <a id="goals"></a> Goals

The AWS Services package aims to provide simple and seamless integration into Tanzu Application Platform
for a variety of services from AWS.
The goal is to minimize the time to value so that users can both offer and consume the services that
they want on Tanzu Application Platform with minimal effort.

## <a id="limitations"></a> Limitations

The AWS Services package has to accommodate a wide range of infrastructure and networking setups.
Each setup has different infrastructure and configuration requirements.

Example setups include:

- A Tanzu Application Platform cluster running on AWS EKS in "VPC A" connecting to RDS PostgreSQL service instances running in "VPC A"
- A Tanzu Application Platform cluster running on AWS EKS in "VPC A" connecting to RDS PostgreSQL service instances running in "VPC B"
- A Tanzu Application Platform cluster running on AWS EKS in "VPC A" connecting to RDS MySQL service instances running in "VPC B"
- A Tanzu Application Platform cluster running on Azure AKS connecting to RDS MySQL service instances running in "VPC A"

If not handled carefully, accommodating these differences could lead to the package configuration
becoming too complex.

To control the potential complexity, the AWS Services package makes the following compromises:

- You might have to complete one-time infrastructure setup tasks, for example, creating an RDS DBSubnetGroup.
- All service instances for each service type, such as RDS PostgreSQL, are created in the same VPC.
- There is no multi-region support.
- Instance-level configuration, such as instance class or engine version, is applied globally to all
service instances of a service type.

As the AWS Services package matures and VMware learns more about how it is being used,
VMware might remove some of these compromises if it can be achieved while keeping the experience as
simple as possible. This is not guaranteed.

## <a id="other"></a> Other Considerations

The AWS Services package is not installed as part of any of the Tanzu Application Platform profiles.
This is because not every user needs to integrate services from AWS into their Tanzu Application Platform
cluster. However, the package is in the Tanzu Application Platform packageRepository, which means
that you can install it using the same tooling, credentials, and image repositories that you use to
install Tanzu Application Platform. See [Install AWS Services](../install-aws-services.hbs.md).

You might not want to integrate all of the services supported by the package.
Therefore, none of the services are enabled by default.
It is up to service operators to enable the services they want using the [Package values](../reference/package-values.hbs.md).
For the list of services you can enable, see [Supported AWS Services](../reference/supported-services.hbs.md).
