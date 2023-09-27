# Supported Topologies for AWS Services

This topic gives you the list of Tanzu Application Platform (commonly known as TAP) cluster to
service instance Virtual Private Cloud (VPC) topologies that the AWS Services package supports.
Each supported topology lists relevant package values configurations and one-time manual setup steps.

## <a id="postgresql"></a> PostgreSQL

This section describes the available topologies for PostgreSQL.

### <a id="same-vpc"></a> A service instance in a VPC accessed by a workload in a Tanzu Application Platform cluster in the same VPC

This topology is very similar to a database instance in a VPC accessed by an EC2 instance in the same
VPC as described in the
[AWS documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.Scenarios.html#USER_VPC.Scenario1).

#### <a id="same-vpc-properties"></a> Key properties

The key properties of this topology are:

- Uses subnets to separate where application workloads run and where RDS PostgreSQL service instances run
- Uses security groups to manage access between the subnets
- PostgreSQL service instances are not publicly accessible

<!-- Maybe add a diagram? -->

This topology is recommended if your Tanzu Application Platform cluster is running in AWS.

#### <a id="same-vpc-config"></a> Configuration

To configure the PostgreSQL service from the AWS Services package for this type of topology you must:

- Manually create all required subnets and security groups in AWS.
- Add a rule to permit TCP port 5432 from the subnet where the Tanzu Application Platform application
workloads run to the subnet where the RDS PostgreSQL service instances run.
- Create a database subnet group consisting of the subnets.

For instructions for these tasks, see the
[AWS documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.Scenarios.html#USER_VPC.Scenario1).

After completing configuration in AWS, you must configure the AWS Services package using the following
package values:

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

<!-- Are REGION, SUBNET_GROUP_NAME, and SECURITY_GROUP_ID placeholders? -->

### <a id="external"></a> A service instance in a VPC accessed by a workload in a Tanzu Application Platform cluster running external to AWS

This topology is very similar to a database instance in a VPC accessed by a client application through
the Internet as described in the [AWS documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.Scenarios.html#USER_VPC.Scenario4).

#### <a id="same-vpc-properties"></a> Key properties

The key properties of this topology are:

- Uses a public subnet in which to run RDS PostgreSQL service instances
- Uses an Internet gateway to provide connectivity over the Internet
- Uses security groups to manage access to the subnet
- PostgreSQL service instances are publicly accessible over the Internet

<!-- Maybe add a diagram? -->

This topology is recommended if your Tanzu Application Platform cluster is running external to AWS,
for example, on-prem or in another cloud such as Azure.

#### <a id="same-vpc-config"></a> Configuration

To configure the PostgreSQL service from the AWS Services Package for this type of topology you must:

- Manually create all required subnets and security groups in AWS.
- Create an Internet gateway.
- Add a rule to permit TCP port 5432 from the subnet where the Tanzu Application Platform application
workloads run to the subnet where the RDS PostgreSQL service instances run.
- Create a database subnet group consisting of the subnets.

For instructions for these tasks, see the
[AWS documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_VPC.Scenarios.html#USER_VPC.Scenario4).

After completing configuration in AWS, you must configure the AWS Services package using the following
package values:

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

<!-- Are REGION, SUBNET_GROUP_NAME, and SECURITY_GROUP_ID placeholders? -->
