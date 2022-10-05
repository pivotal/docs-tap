# Configure Application Accelerator

This topic describes advanced configuration options available for Application Accelerator. This includes configuring Git-Ops style deployments of accelerators as well as configurations for use with non-public repositories and in air-gapped environments.

Accelerators can be created either using the Tanzu CLI or by applying a YAML manifest using `kubectl`. Another option is [Using a Git-Ops style configuration for deploying a set of managed accelerators](#using-git-ops).

Application Accelerator pulls content from accelerator source repositories using either the "Flux SourceController" or the "Tanzu Application Platform Source Controller" components.
If the repository used is accessible anonymously from a public server, then you do not have to configure anything additional. In any other case you need to provide authenication as explained in [Using non-public repositories](#non-public-repos). There are also options for making these configurations easier explained in [Configuring `tap-values.yaml` with Git credentials secret](#creating-git-credentials)

## <a id="using-git-ops"></a> Using a Git-Ops style configuration for deploying a set of managed accelerators

In order to enable a Git-Ops style of managing resources used for deploying accelerators there is a new set of properties for the App Accelerator configuration. The resources will be managed using a Carvel kapp-controller App that watches a Git repository containing the mainifests for the accelerators. This means that you can make changes to the manifests, or to the accelerators they point to, and the changes will be reconciled and reflected in the deployed resources.

You can specify the following accelerator configuration properties when installing the Application Accelerator. The same properties can be provided in the `accelerator` section of the `tap-values.yaml` file:

```yaml
managed_resources:
  enable: true
  git:
    url: GIT-REPO-URL
    ref: origin/main
    sub_path: null
    secret_ref: git-credentials
```

Where:

- `GIT-REPO-URL` is the URL of a Git repository that contains manifest YAML files for the accelerators that you want to have managed (see below for manifest examples). You can specify a `sub_path` if necessary and also a `secret_ref` if the repository requires authentication. If not needed, then leave these additional properties out. See below for configuration of a [Git credentials secret](#creating-git-credentials).

## <a id="examples-creating-acc"></a> Examples for creating accelerators

### <a id="examples-minimal"></a> A minimal example for creating an accelerator

A minimal example could look like the following manifest:

> hello-fun.yaml

```yaml
apiVersion: accelerator.apps.tanzu.vmware.com/v1alpha1
kind: Accelerator
metadata:
  name: hello-fun
spec:
  git:
    url: https://github.com/sample-accelerators/hello-fun
    ref:
      branch: main
```

This minimal example creates an accelerator named `hello-fun`. The `displayName`, `description`, `iconUrl`, and `tags` fields are populated based on the content under the `accelerator` key in the `accelerator.yaml` file found in the `main` branch of the Git repository at https://github.com/sample-accelerators/hello-fun. For example:

> accelerator.yaml

```yaml
accelerator:
  displayName: Hello Fun
  description: A simple Spring Cloud Function serverless app
  iconUrl: https://raw.githubusercontent.com/simple-starters/icons/master/icon-cloud.png
  tags:
  - java
  - spring
  - cloud
  - function
  - serverless
  - tanzu
...
```

To create this accelerator with `kubectl` run:

```sh
kubectl apply --namespace --accelerator-system --filename hello-fun.yaml
```

Or, you could use the Tanzu CLI and run:

```sh
tanzu accelerator create hello-fun --git-repo https://github.com/sample-accelerators/hello-fun --git-branch main
```

### <a id="examples-custom"></a> An example for creating an accelerator with customized properties

You can also explicitly specify the `displayName`, `description`, `iconUrl`, and `tags` fields and this overrides any values provided in the accelerator's Git repository. The following example explicitly sets those fields and the `ignore` field:

> my-hello-fun.yaml

```yaml
apiVersion: accelerator.apps.tanzu.vmware.com/v1alpha1
kind: Accelerator
metadata:
  name: my-hello-fun
spec:
  displayName: My Hello Fun
  description: My own Spring Cloud Function serverless app
  iconUrl: https://raw.githubusercontent.com/sample-accelerators/icons/master/icon-tanzu-light.png
  tags:
    - spring
    - cloud
    - function
    - serverless
  git:
    ignore: ".git/, bin/"
    url: https://github.com/sample-accelerators/hello-fun
    ref:
      branch: test
```

To create this accelerator with `kubectl` you could run:

```sh
kubectl apply --namespace --accelerator-system --filename my-hello-fun.yaml
```

Or, you could use the Tanzu CLI and run:

```sh
tanzu accelerator create my-hello-fun --git-repo https://github.com/sample-accelerators/hello-fun --git-branch main \
  --description "My own Spring Cloud Function serverless app" \
  --display-name "My Hello Fun" \
  --icon-url https://raw.githubusercontent.com/sample-accelerators/icons/master/icon-tanzu-light.png \
  --tags "spring,cloud,function,serverless"
```

>**Note:** It is not currently possible to provide the `git.ignore` option with the Tanzu CLI.

## <a id="creating-git-credentials"></a> Configuring `tap-values.yaml` with Git credentials secret

When deploying accelerators using Git repositories that need authentication and/or are installed with custom CA certificates then you need to provide some additional authentication values in a Secret. The examples in the next section provide more details about this. In this section we describe how to conventiently configure a Git credentials secret that can be used for some of the Git based examples below.

You can specify the following accelerator configuration properties when installing the Application Accelerator. The same properties can be provided in the `accelerator` section of the `tap-values.yaml` file:

```yaml
accelerator:
  git_credentials:
    secret_name: git-credentials
    username: GIT-USER-NAME
    password: GIT-PASSWORD-OR-ACCESS-TOKEN
    ca_file: CUSTOM-CA-CERT
```

Where:

- `GIT-USER-NAME` is the user name for authenticating with the Git repository.
- `GIT-PASSWORD-OR-ACCESS-TOKEN` is the password or access token used for authenticating with the Git repository. We recommend using an access token for this.
- `CUSTOM-CA-CERT` is the certificate data needed when accessing the Git repository.

This is an example of this part of a `tap-values.yaml` configuration:

```yaml
accelerator:
  git_credentials:
    secret_name: git-credentials
    username: testuser
    password: s3cret
    ca_file: |
      -----BEGIN CERTIFICATE-----
      .
      .
      .  < certificate data >
      .
      .
      -----END CERTIFICATE-----
```

You can specify the Custom CA certificate data using the shared config value `shared.ca_cert_data` and it will be propagated to all components that can make use of it, including the App Accelerator configuration. The example above would look like this using the shared value:

```yaml
shared:
  ca_cert_data: |
    -----BEGIN CERTIFICATE-----
    .
    .
    .  < certificate data >
    .
    .
    -----END CERTIFICATE-----

accelerator:
  git_credentials:
    secret_name: git-credentials
    username: testuser
    password: s3cret
```

## <a id="non-public-repos"></a> Using non-public repositories

For Git repositories that aren't accessible anonymously, you need to provide credentials in a Secret.

- For HTTPS repositories the secret must contain user name and password fields. The password field can contain a personal access token instead of an actual password. See [fluxcd/source-controller Basic access authentication](https://fluxcd.io/docs/components/source/gitrepositories/#basic-access-authentication)
- For HTTPS with self-signed certificates, you can add a `.data.caFile` value to the secret created for HTTPS authentication. See [fluxcd/source-controller HTTPS Certificate Authority](https://fluxcd.io/docs/components/source/gitrepositories/#https-certificate-authority)
- For SSH repositories, the secret must contain identity, identity.pub and known_hosts fields. See [fluxcd/source-controller SSH authentication](https://fluxcd.io/docs/components/source/gitrepositories/#ssh-authentication).
- For Image repositories that aren't publicly available, an image pull secret may be provided. For more information, see [Using imagePullSecrets](https://kubernetes.io/docs/concepts/configuration/secret/#using-imagepullsecrets).


### <a id="private-git-repo-example"></a> Examples for a private Git repository

#### <a id="http-cred-example"></a> Example using http credentials

To create an accelerator using a private Git repository, first create a secret with the HTTP credentials.

>**Note:** For better security, use an access token as the password.

```sh
kubectl create secret generic https-credentials \
    --namespace accelerator-system \
    --from-literal=username=<user> \
    --from-literal=password=<access-token>
```

This creates a secret such as the following:

> https-credentials.yaml

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: https-credentials
  namespace: accelerator-system
type: Opaque
data:
  username: <BASE64>
  password: <BASE64>
```

After you have the secret created, you can create the accelerator by using the `spec.git.secretRef.name` property:

> private-acc.yaml

```yaml
apiVersion: accelerator.apps.tanzu.vmware.com/v1alpha1
kind: Accelerator
metadata:
  name: private-acc
spec:
  displayName: private
  description: Accelerator using private repository
  git:
    url: <repository-URL>
    ref:
      branch: main
    secretRef:
      name: https-credentials
```

> **Note:**  For https credentials the `repository-URL` must use `https://` as the URL scheme

If you are using the Tanzu CLI, then add the `--secret-ref` flag to your `tanzu accelerator create` command and provide the name of the secret for that flag.

#### <a id="http-ca-cred-example"></a> Example using http credentials with self-signed certificate

To create an accelerator using a private Git repository with a self-signed certificate, first create a secret with the HTTP credentials and the certificate.

>**Note:** For better security, use an access token as the password.

```sh
kubectl create secret generic https-ca-credentials \
    --namespace accelerator-system \
    --from-literal=username=<user> \
    --from-literal=password=<access-token> \
    --from-file=caFile=<path-to-CA-file>
```

This creates a secret that looks like this:

> https-ca-credentials.yaml

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: https-ca-credentials
  namespace: accelerator-system
type: Opaque
data:
  username: <BASE64>
  password: <BASE64>
  caFile: <BASE64>
```

After you have the secret created, you can create the accelerator by using the `spec.git.secretRef.name` property:

> private-acc.yaml

```yaml
apiVersion: accelerator.apps.tanzu.vmware.com/v1alpha1
kind: Accelerator
metadata:
  name: private-acc
spec:
  displayName: private
  description: Accelerator using private repository
  git:
    url: <repository-URL>
    ref:
      branch: main
    secretRef:
      name: https-ca-credentials
```

> **Note:**  For https credentials the `repository-URL` must use `https://` as the URL scheme

If you are using the Tanzu CLI, then add the `--secret-ref` flag to your `tanzu accelerator create` command and provide the name of the secret for that flag.

#### <a id="ssh-example"></a> Example using SSH credentials

To create an accelerator using a private Git repository, first create a secret with the SSH credentials like this example:

```sh
ssh-keygen -q -N "" -f ./identity
ssh-keyscan github.com > ./known_hosts
kubectl create secret generic ssh-credentials \
    --namespace accelerator-system \
    --from-file=./identity \
    --from-file=./identity.pub \
    --from-file=./known_hosts
```

This example assumes that you don't have a key file already created. If you do, skip the `ssh-keygen` and `ssh-keyscan` steps and replace the values for the `kubectl create secret` command using the following:

- `--from-file=identity=<path to your identity file>`
- `--from-file=identity.pub=<path to your identity.pub file>`
- `--from-file=known_hosts=<path to your know_hosts file>`

The secret that is created will look like this:

> ssh-credentials.yaml

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: ssh-credentials
  namespace: accelerator-system
type: Opaque
data:
  identity: <BASE64>
  identity.pub: <BASE64>
  known_hosts: <BASE64>
```

To use this secret when creating an accelerator, provide the secret name in the `spec.git.secretRef.name` property:

> private-acc-ssh.yaml

```yaml
apiVersion: accelerator.apps.tanzu.vmware.com/v1alpha1
kind: Accelerator
metadata:
  name: private-acc
spec:
  displayName: private
  description: Accelerator using private repository
  git:
    url: <repository-URL>
    ref:
      branch: main
    secretRef:
      name: ssh-credentials
```

> **Note:**  When using ssh credentials, the `repository-URL` must include the username as part of the URL like `ssh://user@example.com:22/repository.git`. See the [Flux documentation](https://fluxcd.io/flux/components/source/gitrepositories/#url) for more detail.

If you are using the Tanzu CLI, then add the `--secret-ref` flag to your `tanzu accelerator create` command and provide the name of the secret for that flag.

### <a id="private-source-image-example"></a> Examples for a private source-image repository

If your registry uses a self-signed certificate then you must add the CA certificate data to the configuration for the "Tanzu Application Platform Source Controller" component. The easiest way to do that is to add it under `source_controller.ca_cert_data` in your `tap-values.yaml` file that is used during installation.

> tap-values.yaml

```yaml
source_controller:
  ca_cert_data: |-
    -----BEGIN CERTIFICATE-----
    .
    .
    .  < certificate data >
    .
    .
    -----END CERTIFICATE-----
```

#### <a id="image-pull-example"></a> Example using image-pull credentials

To create an accelerator using a private source-image repository, first create a secret with the image-pull credentials:

```sh
create secret generic registry-credentials \
    --namespace accelerator-system \
    --from-literal=username=<user> \
    --from-literal=password=<password>
```

This creates a secret that looks like this:

> https-credentials.yaml

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: registry-credentials
  namespace: accelerator-system
type: Opaque
data:
  username: <BASE64>
  password: <BASE64>
```

After you have the secret created, you can create the accelerator by using the `spec.git.secretRef.name` property:

> private-acc.yaml

```yaml
apiVersion: accelerator.apps.tanzu.vmware.com/v1alpha1
kind: Accelerator
metadata:
  name: private-acc
spec:
  displayName: private
  description: Accelerator using private repository
  source:
    image: "registry.example.com/test/private-acc-src:latest"
    imagePullSecrets:
    - name: registry-credentials
```

If you are using the Tanzu CLI, then add the `--secret-ref` flag to your `tanzu accelerator create` command and provide the name of the secret for that flag.

## <a id='next-steps'></a>Next steps

- [Creating accelerators](creating-accelerators/creating-accelerators.html)
