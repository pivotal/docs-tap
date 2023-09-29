# About the AWS Services package

This topic tells you about what the AWS Services package is, why it is useful, and ....

## <a id="goals"></a> Goals

The AWS Services package aims to provide a simple and seamless integration for a variety of AWS Services
into Tanzu Application Platform. The goal is to minimize the time to value so that users can both offer
and consume the AWS Services that they want on Tanzu Application Platform with minimal effort.

## <a id="challenges"></a> Challenges

One of the main challenges in building a package to provide integrations with AWS is
that there is a wide range of infrastructure and networking setups that must
be taken into consideration. Consider the following, non-exhaustive list:

- A Tanzu Application Platform cluster running on AWS EKS in "VPC A" connecting to RDS PostgreSQL service instances running in "VPC A"
- A Tanzu Application Platform cluster running on AWS EKS in "VPC A" connecting to RDS PostgreSQL service instances running in "VPC B"
- A Tanzu Application Platform cluster running on AWS EKS in "VPC A" connecting to Elasticache Redis service instances running in "VPC B"
- A Tanzu Application Platform cluster running on Azure AKS connecting to RDS PostgreSQL service instances running in "VPC A"

Each setup has a different set of infrastructure and configuration requirements.
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

Because not every user needs to integrate AWS Services into their Tanzu Application Platform cluster,
the AWS Services package is not installed by default as part of an installation of Tanzu Application Platform.
<!-- should this say installed as part of any of the TAP profiles? -->
However, the package is in the Tanzu Application Platform packageRepository which means
that you can install it using the same tooling, credentials, and image repositories that you used to
install Tanzu Application Platform.

You might not want to integrate all of the services supported by the package.
Therefore, none of the services are enabled by default.
It is up to service operators to enable the services they want using the [Package values](../reference/package-values.hbs.md).
For the list of services you can enable, see [Supported AWS Services](../reference/supported-services.hbs.md).
