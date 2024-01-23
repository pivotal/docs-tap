# Supported topologies for AWS Services

This topic gives you the list of Tanzu Application Platform (commonly known as TAP) cluster to
service instance Virtual Private Cloud (VPC) topologies that the AWS Services package supports.
Each supported topology lists relevant package values configurations and one-time manual setup steps.

The topologies described in this topic are available for the PostgreSQL, MySQL, and RabbitMQ services.

## <a id="same-vpc"></a> Topology 1: service instance accessed by a workload in the same VPC

Topology 1 is a service instance in a VPC accessed by a workload in a Tanzu Application Platform
cluster in the same VPC.

This topology is very similar to a database instance in a VPC accessed by an EC2 instance in the same
VPC as described in the
[AWS documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.Scenarios.html#USER_VPC.Scenario1).

### <a id="same-vpc-properties"></a> Key properties for topology 1

The key properties of this topology are:

- Uses subnets to separate where application workloads run and where service instances run
- Uses security groups to manage access between the subnets
- Service instances are not publicly accessible

<!-- Maybe add a diagram? -->

This topology is recommended if your Tanzu Application Platform cluster is running in AWS.

### <a id="same-vpc-config"></a> Configuration tasks for topology 1

To configure the service from the AWS Services package for this type of topology you must:

- Manually create all required subnets and security groups in AWS.
- Add a rule to permit the TCP port from the subnet where the Tanzu Application Platform application
  workloads run to the subnet where the service instances run.
  Create the rule for TCP port 5432 for PostgreSQL and MySQL, or 5671 for RabbitMQ.
- For PostgreSQL and MySQL, create a database subnet group consisting of the subnets.

For instructions for these tasks, see the
[AWS documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.Scenarios.html#USER_VPC.Scenario1).

After completing configuration in AWS, you must configure your `aws-services-values.yaml` file using
the following values when installing the package:

PostgreSQL
:

  ```yaml
  postgresql:
    enabled: true
    region: "REGION"
    infrastructure:
      subnet_group:
        name: "SUBNET-GROUP-NAME"
      security_groups:
        - id: "SECURITY-GROUP-ID"
  ```

MySQL
:

  ```yaml
  mysql:
    enabled: true
    region: "REGION"
    infrastructure:
      subnet_group:
        name: "SUBNET-GROUP-NAME"
      security_groups:
        - id: "SECURITY-GROUP-ID"
  ```

RabbitMQ
:

  ```yaml
  rabbitmq:
    enabled: true
    region: "REGION"
    infrastructure:
      subnet_id: "SUBNET-ID"
      security_groups:
        - id: "SECURITY-GROUP-ID"
  ```

## <a id="external"></a> Topology 2: service instance accessed by a workload external to AWS

Topology 2 is a service instance in a VPC accessed by a workload in a Tanzu Application Platform
cluster running external to AWS.

This topology is very similar to a database instance in a VPC accessed by a client application through
the Internet as described in the [AWS documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.Scenarios.html#USER_VPC.Scenario4).

### <a id="external-vpc-properties"></a> Key properties for topology 2

The key properties of this topology are:

- Uses a public subnet in which to run service instances
- Uses an Internet gateway to provide connectivity over the Internet
- Uses security groups to manage access to the subnet
- Service instances are publicly accessible over the Internet

<!-- Maybe add a diagram? -->

This topology is recommended if your Tanzu Application Platform cluster is running external to AWS,
for example, on-prem or in another cloud such as Azure.

### <a id="external-vpc-config"></a> Configuration tasks for topology 2

To configure the service from the AWS Services package for this type of topology you must:

- Manually create all required subnets and security groups in AWS.
- Create an Internet gateway.
- Add a rule to permit TCP port 5432 (PostgreSQL, MySQL) or 5671 (RabbitMQ) from the subnet where the Tanzu Application Platform application
workloads run to the subnet where the service instances run.
- Create a database subnet group (PostgreSQL, MySQL) consisting of the subnets.

For instructions for these tasks, see the
[AWS documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.Scenarios.html#USER_VPC.Scenario4).

After completing configuration in AWS, you must configure your `aws-services-values.yaml` file using
the following values when installing the package:

PostgreSQL
:

  ```yaml
  postgresql:
    enabled: true
    region: "REGION"
    infrastructure:
      subnet_group:
        name: "SUBNET-GROUP-NAME"
      security_groups:
        - id: "SECURITY-GROUP-ID"
    instance_configuration:
      publicly_accessible: true
  ```

MySQL
:

  ```yaml
  mysql:
    enabled: true
    region: "REGION"
    infrastructure:
      subnet_group:
        name: "SUBNET-GROUP-NAME"
      security_groups:
        - id: "SECURITY-GROUP-ID"
    instance_configuration:
      publicly_accessible: true
  ```

RabbitMQ
:

  ```yaml
  rabbitmq:
    enabled: true
    region: "REGION"
    infrastructure:
      subnet_id: "SUBNET-ID"
    instance_configuration:
      publicly_accessible: true
  ```
