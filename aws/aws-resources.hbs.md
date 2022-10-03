# Creating AWS Resources for Tanzu Application Platform

To install the Tanzu Application Platform within the AWS Ecosystem, several AWS resources need to be created.  This guide will walk you through creating the following resources:

- An EKS Cluster to install Tanzu Application Platform
- IAM Roles to allow authentication and authorization to read and write from ECR
- ECR Repositories for the Tanzu Application Platform container images

Creating these resources will enable the Tanzu Application Platform to use an [IAM role bound to a Kubernetes service account](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html) for authentication rather than the typical username and password stored in a kubernetes secret strategy.  This is important when using the Elastic Container Registry (ECR) because authenticating to ECR is a two step process:  

1. Retrieve a token using your AWS credentials
1. Use the token to authenticate to the registry  

To increase security posture, the token has a lifetime of 12 hours.  This makes storing it as a secret for a service impracticle, as it would have to be refereshed every 12 hours.

Leveraging an IAM role on a service account mitigates the need to retrieve the token at all, as it is handled by credential helpers within the services.

# Prerequisites

## AWS Account

We will be creating all of our resources within Amazon Web Services, so therefore we will need an Amazon account.

To create an Amazon account, use the [following guide](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/).

Note that you will need your account ID during the guide.

## AWS CLI

This walkthrough will use the AWS CLI to both query and configure resources in AWS such as IAM roles.

To install the AWS CLI, use the [following guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).

## EKSCTL

The EKSCTL command line makes managing the lifecycle of EKS clusters very simple.  This guide will use it to create clusters.

To install the eksctl cli, use the [following guide](https://eksctl.io/introduction/#installation).

# Export Environment Variables

Some variables are used throughout the guide, to simplify the process and minimize the opportunity for errors, let's export these variables.

```
export AWS_ACCOUNT_ID=012345678901
export AWS_REGION=us-west-2
export EKS_CLUSTER_NAME=tap-on-aws
```

Where:

| Variable | Description |
| -------- | ----------- |
| AWS_ACCOUNT_ID | Your AWS account ID |
| AWS_REGION | The AWS region you are going to deploy to |
| EKS_CLUSTER_NAME | The name of your EKS Cluster |


# Create an EKS Cluster

Create an EKS cluster in the specified region using the following command.  Creating the control plane and node group can take  take anywhere from 30-60 minutes. 

```
eksctl create cluster --name $EKS_CLUSTER_NAME --managed --region $AWS_REGION --instance-types t3.large --version 1.22 --with-oidc -N 5
```

Note: This step is optional if you already have an existing EKS Cluster.  Note, however that it has to be at least version 1.22 and have the OIDC authentication enabled.  To enable the OIDC provider, use the [following guide](https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html).

# Create the Container Repositories

ECR requires the container repositories to be precreated.

For the Tanzu Application Platform, we need to create two repositories.

- A repository to store the Tanzu Application Platform service container images
- A repository to store Tanzu Build Service Base OS and Buildpack container images

To create these repositories, run the following commands:

```
aws ecr create-repository --repository-name tap-images --region $AWS_REGION
aws ecr create-repository --repository-name tap-build-service --region $AWS_REGION
```

You can name the repositories any name you would like, just note them for when we build the configuration later.

# Create IAM Roles

By default, the EKS cluster will be provisioned with an [EC2 instance profile](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html) that provides read-only access for the entire EKS cluster to the ECR registery within your AWS account.

However, some of the services within the Tanzu Application Platform require write access to the container repositories. In order to provide that access, we will create IAM roles and add the ARN to the K8S service accounts that those services use.  This will ensure that only the required services have access to write container images to ECR, rather than a blanket policy that applies to the entire cluster.

We'll create two IAM Roles.

1.  Tanzu Build Service: Gives write access to the repository to allow the service to automatically upload new images.  This is limited in scope to the service account for kpack and the dependency updater.
2.  Workload:  Gives write access to the entire ECR registry with a prepended path.  This prevents you from having to update the policy for each new workload created.  

In order to create the roles, we need to establish two policys:

1. Trust Policy: Limits the scope to the OIDC endpoint for the Kubernetes Cluster and the Kubernetes service account we'll attach the role to
1. Permission Policy:  Limits the scope of what actions can be taken on what resources by the role.  

**Note** Both of these policies are best effort at a least privledge model, but be sure to review to ensure if they adhere to your organizations policies.

In order to simplify this guide, we'll use a script to create these policy documents and create the roles.  This script will output the files, then create the IAM roles using the policy documents.  

To run the script, do the following:

```console
oidcProvider=$(aws eks describe-cluster --name $EKS_CLUSTER_NAME --region $AWS_REGION | jq '.cluster.identity.oidc.issuer' | tr -d '"' | sed 's/https:\/\///')
cat << EOF > build-service-trust-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::${AWS_ACCOUNT_ID}:oidc-provider/${oidcProvider}"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "${oidcProvider}:aud": "sts.amazonaws.com"
                },
                "StringLike": {
                    "${oidcProvider}:sub": [
                        "system:serviceaccount:kpack:controller",
                        "system:serviceaccount:build-service:dependency-updater-controller-serviceaccount"
                    ]
                }
            }
        }
    ]
}
EOF

cat << EOF > build-service-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ecr:DescribeRegistry",
                "ecr:GetAuthorizationToken",
                "ecr:GetRegistryPolicy",
                "ecr:PutRegistryPolicy",
                "ecr:PutReplicationConfiguration",
                "ecr:DeleteRegistryPolicy"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "TAPEcrBuildServiceGlobal"
        },
        {
            "Action": [
                "ecr:DescribeImages",
                "ecr:ListImages",
                "ecr:BatchCheckLayerAvailability",
                "ecr:BatchGetImage",
                "ecr:BatchGetRepositoryScanningConfiguration",
                "ecr:DescribeImageReplicationStatus",
                "ecr:DescribeImageScanFindings",
                "ecr:DescribeRepositories",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetLifecyclePolicy",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:GetRegistryScanningConfiguration",
                "ecr:GetRepositoryPolicy",
                "ecr:ListTagsForResource",
                "ecr:TagResource",
                "ecr:UntagResource",
                "ecr:BatchDeleteImage",
                "ecr:BatchImportUpstreamImage",
                "ecr:CompleteLayerUpload",
                "ecr:CreatePullThroughCacheRule",
                "ecr:CreateRepository",
                "ecr:DeleteLifecyclePolicy",
                "ecr:DeletePullThroughCacheRule",
                "ecr:DeleteRepository",
                "ecr:InitiateLayerUpload",
                "ecr:PutImage",
                "ecr:PutImageScanningConfiguration",
                "ecr:PutImageTagMutability",
                "ecr:PutLifecyclePolicy",
                "ecr:PutRegistryScanningConfiguration",
                "ecr:ReplicateImage",
                "ecr:StartImageScan",
                "ecr:StartLifecyclePolicyPreview",
                "ecr:UploadLayerPart",
                "ecr:DeleteRepositoryPolicy",
                "ecr:SetRepositoryPolicy"
            ],
            "Resource": [
                "arn:aws:ecr:${AWS_REGION}:${AWS_ACCOUNT_ID}:repository/tap-build-service",
                "arn:aws:ecr:${AWS_REGION}:${AWS_ACCOUNT_ID}:repository/tap-images"
            ],
            "Effect": "Allow",
            "Sid": "TAPEcrBuildServiceScoped"
        }
    ]
}
EOF

cat << EOF > workload-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ecr:DescribeRegistry",
                "ecr:GetAuthorizationToken",
                "ecr:GetRegistryPolicy",
                "ecr:PutRegistryPolicy",
                "ecr:PutReplicationConfiguration",
                "ecr:DeleteRegistryPolicy"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Sid": "TAPEcrWorkloadGlobal"
        },
        {
            "Action": [
                "ecr:DescribeImages",
                "ecr:ListImages",
                "ecr:BatchCheckLayerAvailability",
                "ecr:BatchGetImage",
                "ecr:BatchGetRepositoryScanningConfiguration",
                "ecr:DescribeImageReplicationStatus",
                "ecr:DescribeImageScanFindings",
                "ecr:DescribeRepositories",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetLifecyclePolicy",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:GetRegistryScanningConfiguration",
                "ecr:GetRepositoryPolicy",
                "ecr:ListTagsForResource",
                "ecr:TagResource",
                "ecr:UntagResource",
                "ecr:BatchDeleteImage",
                "ecr:BatchImportUpstreamImage",
                "ecr:CompleteLayerUpload",
                "ecr:CreatePullThroughCacheRule",
                "ecr:CreateRepository",
                "ecr:DeleteLifecyclePolicy",
                "ecr:DeletePullThroughCacheRule",
                "ecr:DeleteRepository",
                "ecr:InitiateLayerUpload",
                "ecr:PutImage",
                "ecr:PutImageScanningConfiguration",
                "ecr:PutImageTagMutability",
                "ecr:PutLifecyclePolicy",
                "ecr:PutRegistryScanningConfiguration",
                "ecr:ReplicateImage",
                "ecr:StartImageScan",
                "ecr:StartLifecyclePolicyPreview",
                "ecr:UploadLayerPart",
                "ecr:DeleteRepositoryPolicy",
                "ecr:SetRepositoryPolicy"
            ],
            "Resource": [
                "arn:aws:ecr:${AWS_REGION}:${AWS_ACCOUNT_ID}:repository/tap-build-service",
                "arn:aws:ecr:${AWS_REGION}:${AWS_ACCOUNT_ID}:repository/tanzu-application-platform/tanzu-java-web-app",
                "arn:aws:ecr:${AWS_REGION}:${AWS_ACCOUNT_ID}:repository/tanzu-application-platform/tanzu-java-web-app-bundle",
                "arn:aws:ecr:${AWS_REGION}:${AWS_ACCOUNT_ID}:repository/tanzu-application-platform",
                "arn:aws:ecr:${AWS_REGION}:${AWS_ACCOUNT_ID}:repository/tanzu-application-platform/*"
            ],
            "Effect": "Allow",
            "Sid": "TAPEcrWorkloadScoped"
        }
    ]
}
EOF

cat << EOF > workload-trust-policy.json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::${AWS_ACCOUNT_ID}:oidc-provider/${oidcProvider}"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "${oidcProvider}:sub": "system:serviceaccount:default:default",
                    "${oidcProvider}:aud": "sts.amazonaws.com"
                }
            }
        }
    ]
}
EOF


# Create the Build Service Role
aws iam create-role --role-name tap-build-service --assume-role-policy-document file://build-service-trust-policy.json
# Attach the Policy to the Build Role
aws iam put-role-policy --role-name tap-build-service --policy-name tapBuildServicePolicy --policy-document file://build-service-policy.json

# Create the Workload Role
aws iam create-role --role-name tap-workload --assume-role-policy-document file://workload-trust-policy.json
# Attach the Policy to the Workload Role
aws iam put-role-policy --role-name tap-workload --policy-name tapWorkload --policy-document file://workload-policy.json
```
