# AWS' ECR Support

With an AWS IAM Role configured in the AWS project, to provide the necessary
credentials for reaching out to ECR we need to update the TAP installation for
our build clusters to have the controllers making use of the proper AWS IAM
Role ARN.

From a platform configuration level, we need ensure two things:

1. TAP components have been provided with the IAM role ARN that they should
   make use of for gathering the credentials they need (configuration of
  `tap-values.yaml`)

2. on each developer developer namespace (i.e., namespaces where `Workload`
   objects are created), the `ServiceAccount` objects created in there must
   also be annotated with an AWS-specific annotation.

If you're not familar with IAM Roles for ServiceAccounts, check out [AWS'
docs](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html).


## TAP Configuration

The several components shipped with TAP used by the Out of the Box Supply
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
  credentials from the provider before pushing

- `source_controller`: in order to fetch container images from ECR via
  `ImageRepository`, the controller must be aware of the proper coordinates -
  in this case, provided by the `aws_iam_role_arn` configuration.

- `cartographer`: `PodIntent` objects that reference images in ECR need to have
  the credentials to do so - `aws_iam_role_arn` allows one to provide the
  proper pointers for such

- `buildservice`: for the controller to make use of images from ECR, it's
  necessary to provide the proper coordinates - via
  `kp_default_repository_aws_iam_role_arn` once can do so

With TAP configured, we can move on to the setup of developer namesapces.

## Developer namespace

when setting up the developer namespace, make sure to have the serviceaccount
properly annotated:

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: default
  annotations:
    eks.amazonaws.com/role-arn: "IAM-ROLE-ARN"  # <<<
imagePullSecrets:
  - name: tap-registry
```

See [set up namespaces](../set-up-nmaespaces.md) for more details.

See https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html
