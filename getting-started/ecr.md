# AWS ECR Support

AWS Elastic Container Registry (ECR) is the container registry within the AWS ecosystem.

The Tanzu Application platform supports using ECR for both Tanzu Build Service images, as well as the images created as part of a workload in a supply chain.

While you can use the typical "secret" configuration to store credentials for ECR, the token that is used to authenticate to ECR expires every 12 hours.  For this reason, it is suggested to use an [AWS IAM role bound to a Kubernetes service account](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html) to allow the Tanzu Application Services to authenticate to ECR.

To use an IAM Role you have defined in your AWS project, configuration must be applied to the TAP installation  build clusters to allow the services to make use of the proper AWS IAM Role ARN.

From a platform configuration level, we need to ensure two configurations are in place:

1. TAP components have been provided with the IAM role ARN that they should
   make use of for gathering the credentials they need (configuration of
  `tap-values.yaml`)

2. In each developer developer namespace (i.e., namespaces where `Workload`
   objects are created), the `ServiceAccount` objects must
   be annotated with an AWS-specific annotation that maps to an IAM role.

If you're not familar with IAM Roles for ServiceAccounts, check out [AWS'
docs](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html).

## TAP Configuration

Multiple components shipped with TAP used by the Out of the Box Supply
chains can be configured to make use of this feature by having in
`tap-values.yaml` for build clusters the following configurations:

```yaml
# tap-values.yaml
#
buildservice:
  kp_default_repository: "REPO-NAME"
  kp_default_repository_aws_iam_role_arn: "IAM-ROLE-ARN"

cartographer:
  aws_iam_role_arn: "IAM-ROLE-ARN"

source_controller:
  aws_iam_role_arn: "IAM-ROLE-ARN"

ootb_templates:
  iaas_auth: true
```

- `ootb_templates`: with `iaas_auth: true`, when using RegOps (i.e., pushing
  Kubernetes configuration produced throughout the supply chain to an image
  registry instead of git repository) `imgpkg` will automatically load the
  credentials from the IaaS (in this case AWS) provider before pushing

- `source_controller`: in order to fetch container images from ECR via
  `ImageRepository`, the controller must be aware of the proper coordinates -
   in this case, provided by the `aws_iam_role_arn` configuration.  Typical EKS deployments have a node instance profile that provides read-only to ECR, so this configuration may be optional depending on your configuration.

- `cartographer`: `PodIntent` objects that reference images in ECR need to have
  the credentials to do so - `aws_iam_role_arn` allows one to provide the mapping to an IAM role for such access.  Typical EKS deployments have a node instance profile that provides read-only to ECR, so this configuration may be optional depending on your configuration.

- `buildservice`: The build service will use this IAM role to push and pull "system" images such as Base OS images and build packs.
  `kp_default_repository_aws_iam_role_arn` once can do so

With TAP configured, we can move on to the setup of developer namesapces.

## Developer namespace

When setting up developer namespaces, make sure to have the serviceaccount
properly annotated.

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: default
  annotations:
    eks.amazonaws.com/role-arn: "IAM-ROLE-ARN"
imagePullSecrets:
  - name: tap-registry
```

See [set up namespaces](../set-up-namespaces.md) for more details.