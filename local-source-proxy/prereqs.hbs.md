# Prerequisites for Local Source Proxy

You need the following prerequisites before you can install Local Source Proxy (LSP):

- The Tanzu Application Platform profile `full` or `iterate`. For more information, see
  [Components and installation profiles for Tanzu Application Platform](../about-package-profiles.hbs.md).

- A registry server with a repository capable of accepting and hosting OCI artifacts, such as Google
  Artifact Registry, JFrog Artifactory, Harbor, Elastic Container Registry, and so on.

- Either IaaS-specific trust for Kubernetes service accounts to access the registry, or a secret with
  sufficient privileges to push and pull artifacts from that repository.

The rest of this topic tells you how to obtain these prerequisites.

Using Tanzu CLI
: All registries except ECR can use the following code:

    ```console
    tanzu secret registry add lsp-push-credentials \
    --username USERNAME-VALUE --password PASSWORD-VALUE \
    --server REGISTRY-SERVER \
    --namespace tap-install --yes
    ```

Declarative syntax
: For declarative syntax:

    ```yaml
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: lsp-push-credentials
      namespace: tap-install
    type: kubernetes.io/dockerconfigjson
    stringData:
      .dockerconfigjson: BASE64-ENCODED-DOCKER-CONFIG-JSON
    ```

    The `dockerconfigjson` structure is as follows:

    ```json
    {"auths":{"REGISTRY-SERVER":{"username":"USERNAME-VALUE","password": "PASSWORD-VALUE"}}}
    ```

    If you're using the Tanzu Application Platform GitOps installer using Secrets OPerationS (SOPS),
    after using SOPS to encrypt the secret put the secret in the
    `clusters/CLUSTER-NAME/cluster-config/config/lsp` directory in your GitOps repository.

    If you're using the Tanzu Application Platform GitOps installer using ESO, create a secret as
    follows:

    ```json
    #@ load("@ytt:data", "data")
    #@ load("@ytt:json", "json")

    #@ def config():
    #@  return {
    #@    "auths": {
    #@      data.values.tap_value.{path-to-registry-host}: {
    #@       "username": data.values.tap_values.{path-to-registry-username},
    #@       "password": data.values.tap_values.{path-to-registry-password}
    #@      }
    #@    }
    #@  }
    #@ end
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: lsp-push-credentials
      namespace: tap-install
    type: kubernetes.io/dockerconfigjson
    stringData:
      .dockerconfigjson: #@ json.encode(config())
    ```

The procedure you use to obtain a secret with sufficient privileges depends on whether your registry
is Elastic Container Registry (ECR) or something else.

Using AWS
: If you're using Elastic Container Registry as your registry, you must create the container
  repository ahead of time.  Additionally you require an AWS Identity Access and Management (IAM) role
  Amazon Resource Name (ARN) that possesses the necessary privileges to push and pull artifacts to
  the ECR repository. This is limited in scope to the service account for Local Source Proxy.

  1. Export the variables by running:

    ```console
    export AWS_ACCOUNT_ID=012345678901  # Your AWS account ID
    export AWS_REGION=us-west-2         # The AWS region you are going to deploy to
    export EKS_CLUSTER_NAME=tap-on-aws  # The name of your Elastic Kubernetes Service Cluster
    ```

  1. Create the repository by running:

    ```console
    aws ecr create-repository --repository-name tap-lsp --region $AWS_REGION
    ```

  1. Output the files, and then use the policy documents to create the IAM roles, by running:

    ```console
    export OIDCPROVIDER=$(aws eks describe-cluster --name $EKS_CLUSTER_NAME --region $AWS_REGION \
    --output json | jq '.cluster.identity.oidc.issuer' | tr -d '"' | sed 's/https:\/\///')

    cat << EOF > local-source-proxy-trust-policy.json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Federated": "arn:aws:iam::${AWS_ACCOUNT_ID}:oidc-provider/${OIDCPROVIDER}"
                },
                "Action": "sts:AssumeRoleWithWebIdentity",
                "Condition": {
                    "StringEquals": {
                        "${OIDCPROVIDER}:aud": "sts.amazonaws.com"
                    },
                    "StringLike": {
                        "${OIDCPROVIDER}:sub": [
                            "system:serviceaccount:tap-local-source-system:proxy-manager"
                        ]
                    }
                }
            }
        ]
    }
    EOF

    cat << EOF > local-source-proxy-policy.json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": [
                    "ecr:GetAuthorizationToken"
                ],
                "Resource": "*",
                "Effect": "Allow",
                "Sid": "TAPLSPGlobal"
            },
            {
                "Effect": "Allow",
                "Action": [
                    "ecr:BatchCheckLayerAvailability",
                    "ecr:GetDownloadUrlForLayer",
                    "ecr:GetRepositoryPolicy",
                    "ecr:DescribeRepositories",
                    "ecr:ListImages",
                    "ecr:DescribeImages",
                    "ecr:BatchGetImage",
                    "ecr:GetLifecyclePolicy",
                    "ecr:GetLifecyclePolicyPreview",
                    "ecr:ListTagsForResource",
                    "ecr:DescribeImageScanFindings",
                    "ecr:InitiateLayerUpload",
                    "ecr:UploadLayerPart",
                    "ecr:CompleteLayerUpload",
                    "ecr:PutImage"
                ],
                "Resource": [
                    "arn:aws:ecr:${AWS_REGION}:${AWS_ACCOUNT_ID}:repository/tap-lsp"
                ],
                "Sid": "TAPLSPScoped"
            }
        ]
    }
    EOF

    # Create the TAP Local Source Proxy Role
    aws iam create-role --role-name tap-local-source-proxy --assume-role-policy-document \
    file://local-source-proxy-trust-policy.json
    # Attach the Policy to the tap-local-source-proxy Role created above
    aws iam put-role-policy --role-name tap-local-source-proxy --policy-name tapLocalSourcePolicy \
    --policy-document file://local-source-proxy-policy.json
    ```

Using a secret with pull privileges only
: You can use a secret with only pull privileges if you prefer to have a dedicated credential with a
  least-privilege policy, specifically for downloading artifacts instead of reusing credentials with
  higher privileges.

  The secret containing this credential is distributed across developer namespaces by using the
  Secretgen `SecretExport` resource. Namespace Provisioner automatically imports it to the developer
  namespace. However, for development purposes, you can skip this step and use the same secret for
  both pushing and pulling artifacts.

  To use a secret with pull privileges only, run:

    ```console
    # For all registries except ECR
    tanzu secret registry add lsp-pull-credentials \
    --username USERNAME-VALUE --password 'PASSWORD-VALUE' \
    --server REGISTRY-SERVER \
    --namespace tap-install --yes
    ```
