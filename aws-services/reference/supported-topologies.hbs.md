# Supported Topologies for AWS Services

This topic lists the Tanzu Application Platform cluster to service instance Virtual Private Cloud (VPC)
topologies that the AWS Services package supports.
Each supported topology lists relevant package values configurations and one-time manual setup steps.

## PostgreSQL

### A service instance in a VPC accessed by a workload in a TAP cluster in the same VPC

This topology is very similar to [A DB instance in a VPC accessed by an EC2 instance in the same VPC](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.Scenarios.html#USER_VPC.Scenario1) as described in the official AWS documentation. The key properties of this topology are:

* Use of subnets to separate where application workloads run from where RDS PostgreSQL service instances run
* Use of security groups to manage access between the subnets
* PostgreSQL service instances are not publicly accessible

You will likely want to use this sort of topology if your TAP cluster is running in AWS.

In order to configure the PostgreSQL service from the AWS Services Package for this type of topology you must:

* Manually create all required subnets and security groups in AWS
* Add a rule to permit TCP port 5432 from the subnet where the TAP application workloads run to the subnet where the RDS PostgreSQL service instances run
* Create a DB subnet group consisting of the subnets

For information on how to do this, please refer to the official AWS documenation linked above. Once done, you must configure the AWS Services Package using the following Package values:

```yaml
postgresql:
  enabled: true
  region: "REGION"
  infrastructure:
    subnet_group:
      name: "SUBNET_GROUP_NAME"
    security_groups:
      - id: "SECURITY_GROUP_ID"
```

### A service instance in a VPC accessed by a workload in a TAP cluster running external to AWS

This topology is very similar to [A DB instance in a VPC accessed by a client application through the internet](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.Scenarios.html#USER_VPC.Scenario4) as described in the official AWS documentation. The key properties of this topology are:

* Use of a public subnet to run RDS PostgreSQL service instances in
* Use of an internet gateway to provide connectivity over the Internet
* Use of security groups to manage access to the subnet
* PostgreSQL service instances are publicly accessible over the Internet

You will likely want to use this sort of topology if your TAP cluster is running external to AWS (e.g. on prem or in another cloud such as Azure).

In order to configure the PostgreSQL service from the AWS Services Package for this type of topology you must:

* Manually create all required subnets and security groups in AWS
* Create an internet gateway
* Add a rule to permit TCP port 5432 from the subnet where the TAP application workloads run to the subnet where the RDS PostgreSQL service instances run
* Create a DB subnet group consisting of the subnets

For information on how to do this, please refer to the official AWS documenation linked above. Once done, you must configure the AWS Services Package using the following Package values:

```yaml
postgresql:
  enabled: true
  region: "REGION"
  infrastructure:
    subnet_group:
      name: "SUBNET_GROUP_NAME"
    security_groups:
      - id: "SECURITY_GROUP_ID"
  instance_configuration:
    publicly_accessible: true
```
