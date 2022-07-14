# Configure Application Accelerator

This topic describes how to configure Application Accelerator for use in air-gapped environments or other
customized installations.

Application Accelerator pulls content from accelerator source repositories using either the "Flux SourceController" or the "Tanzu Application Platform Source Controller" components.

If the repository used is accessible anonymously from a public server, then you do not have to configure anything additional. Accelerators are created either using the Tanzu CLI or by applying a YAML manifest using `kubectl`.

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

If you are using the Tanzu CLI, then add the `--secret-ref` flag to your `tanzu accelerator create` command and provide the name of the secret for that flag.

### <a id="private-suorce-image-example"></a> Examples for a private source-image repository

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

- [Using Grype in offline and air-gapped environments](../scst-scan/offline-airgap.html)
