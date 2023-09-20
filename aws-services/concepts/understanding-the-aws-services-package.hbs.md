# Understanding the AWS Services Package

## Goals

The AWS Services Package strives to provide a simple, seamless integration for a variety of AWS Services into Tanzu Application Platform. The aim is to minimise the time to value so that users can both offer and consume the AWS Services they know and love on Tanzu Application Platform with minimal effort.

## Challenges

One of the main challenges in building an out of the box Package to provide integrations with AWS is that there exists a wide potential range of possible infrastructure and networking setups that must be taken into consideration. Consider the following, non-exhaustive list:

* TAP cluster running on AWS EKS in VPC A connecting to RDS PostgreSQL service instances running in VPC A
* TAP cluster running on AWS EKS in VPC A connecting to RDS PostgreSQL service instances running in VPC B
* TAP cluster running on AWS EKS in VPC A connecting to Elasticache Redis service instances running in VPC B
* TAP cluster running on Azure AKS connecting to RDS PostgreSQL service instances running in VPC A
* etc. etc.

Each setup has a slightly different set of infrastructure and configuration requirements which, if not handled carefully, could lead to an unwanted explosion of complexity surfaced to users via configuration values on the Package itself.

In order to keep a lid on the potential complexity, the AWS Services Package currently makes the following compromises:

* One-time infrastructure setup tasks (e.g. creation of an RDS DBSubnetGroup) may be asked of users
* All service instances for each given service type (e.g. RDS PostgreSQL) are created in the same VPC
* No multi-region support
* Instance-level configuration (e.g. instance class, engine version, etc.) is applied globally to all service instances of a given service type

As the AWS Services Package matures and we learn more about how it is being used, it's possible (not guaranteed) that we may remove some of these compromises if we believe it can be done in such a way as to keep the out of the box experience as simple as possible.

## Other Considerations

One other thought taken into consideration is that not every user will necessarily need or want to integrate AWS Services into their Tanzu Application Platform cluster. Therefore, unlike the [Bitnami Services](../../bitnami-services/about.hbs.md) Package which deploys service instances into the TAP cluster itself, the AWS Services Package is not installed by default as part of an installation of TAP. However, the Package is still included in the TAP PackageRepository which means that you can install it using the same tooling, credentials and image repositories that you used to install TAP.

On a similar note, even users who do want to integrate AWS services into their TAP installation may not necessarily want to integrate _all_ of the [services supported by the Package](../reference/supported-services.hbs.md). Therefore none of the services are enabled by default and it is up to the Service Operator to enable only the services they want via the [Package values](../reference/package-values.hbs.md).
