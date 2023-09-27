# Understanding the AWS Services package

This topic tells you about what the AWS Services package is, why it is useful, and ....

## <a id="goals"></a> Goals

The AWS Services package aims to provide a simple, seamless integration for a variety of AWS Services
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
If not handled carefully, this could lead to the configuration for the package becoming too complex.

To control the potential complexity, the AWS Services package makes the following compromises:

- You might have to complete one-time infrastructure setup tasks, for example, creating an RDS DBSubnetGroup.
- All service instances for each service type, such as RDS PostgreSQL, are created in the same VPC.
- There is no multi-region support.
- Instance-level configuration, such as instance class or engine version, is applied globally to all
service instances of a given service type.

As the AWS Services package matures and VMware learns more about how it is being used,
VMware might remove some of these compromises if it can be achieved while keeping the experience as
simple as possible. This is not guaranteed.

## <a id="other"></a> Other Considerations

One other thought taken into consideration is that not every user will necessarily need or want to
integrate AWS Services into their Tanzu Application Platform cluster.
Therefore, unlike the [Bitnami Services](../../bitnami-services/about.hbs.md) package which deploys
service instances into the Tanzu Application Platform cluster itself, the AWS Services Package is not
installed by default as part of an installation of Tanzu Application Platform.
However, the Package is still included in the Tanzu Application Platform PackageRepository which means
that you can install it using the same tooling, credentials and image repositories that you used to
install Tanzu Application Platform.

On a similar note, even users who do want to integrate AWS services into their Tanzu Application Platform
installation may not necessarily want to integrate _all_ of the
[services supported by the Package](../reference/supported-services.hbs.md).
Therefore none of the services are enabled by default and it is up to the Service Operator to enable
only the services they want via the [Package values](../reference/package-values.hbs.md).
