# Configure Application Accelerator

This topic tells you about advanced configuration options available for Application Accelerator. This includes configuring Git-Ops style deployments of accelerators and configurations for use with non-public repositories and in air-gapped environments.

Accelerators are created either using the Tanzu CLI or by applying a YAML manifest using kubectl.
Another option is [Using a Git-Ops style configuration for deploying a set of managed accelerators](#using-git-ops).

Application Accelerator pulls content from accelerator source repositories using either the
"Flux SourceController" or the "Tanzu Application Platform Source Controller" components.
If the repository used is accessible anonymously from a public server, you do not have to
configure anything additional. Otherwise, provide authentication as explained in
[Using non-public repositories](#non-public-repos). There are also options for making these
configurations easier explained in [Configuring tap-values.yaml with Git credentials secret](#creating-git-credentials)

## <a id="using-git-ops"></a> Using a Git-Ops style configuration for deploying a set of managed accelerators

To enable a Git-Ops style of managing resources used for deploying accelerators, there is a new set
of properties for the Application Accelerator configuration. The resources are managed using a
Carvel kapp-controller App in the `accelerator-system` namespace that watches a Git repository
containing the manifests for the accelerators. This means that you can make changes to the manifests,
or to the accelerators they point to, and the changes are reconciled and reflected in the
deployed resources.

You can specify the following accelerator configuration properties when installing the Application
Accelerator. The same properties are provided in the `accelerator` section of the `tap-values.yaml` file:

```yaml
accelerator:
  managed_resources:
    enable: true
    git:
      url: GIT-REPO-URL
      ref: origin/main
      sub_path: null
      secret_ref: git-credentials
```

Where:

- `GIT-REPO-URL` is the URL of a Git repository that contains manifest YAML files for the
  accelerators that you want to have managed. The URL must start with `https://` or `git@`.
  You can specify a `sub_path` if   necessary and also a `secret_ref` if the repository requires authentication. If not needed, then leave these additional properties out.

  For more information, see [Configure tap-values.yaml with Git credentials secret](#creating-git-credentials) and [Creating a manifest with multiple accelerators and fragments](#examples-multi-manifest) in this topic.

### <a id="functional-considerations"></a> Functional and Organizational Considerations

Any accelerator manifest that is defined under the `GIT-REPO-URL` and optional `sub_path` is
selected by the kapp-controller app. If there are multiple manifests at the defined `GIT-REPO-URL`,
they are all watched for changes and displayed to the user as a merged catalog.

For example: if you have two manifests containing multiple accelerator or fragment
definitions, `manifest-1.yaml`, and `manifest-2.yaml`, on the same path in the organizational
considerations. The resulting catalog is (`manifest-1.yaml` + `manifest-2.yaml`).

## <a id="examples-creating-acc"></a> Examples for creating accelerators

### <a id="examples-minimal"></a> A minimal example for creating an accelerator

A minimal example might look like the following manifest:

**`spring-cloud-serverless.yaml`**

```yaml
apiVersion: accelerator.apps.tanzu.vmware.com/v1alpha1
kind: Accelerator
metadata:
  name: spring-cloud-serverless
spec:
  git:
    url: https://github.com/vmware-tanzu/application-accelerator-samples
    subPath: spring-cloud-serverless
    ref:
      branch: main
```

This example creates an accelerator named `spring-cloud-serverless`. The `displayName`, `description`,
`iconUrl`, and `tags` text boxes are populated based on the content under the `accelerator` key in the
`accelerator.yaml` file found in the `main` branch of the Git repository
at [Application Accelerator Samples](https://github.com/vmware<-tanzu</application-accelerator-samples)
under the sub-path `spring-cloud-serverless`. For example:

**`accelerator.yaml`**

```yaml
accelerator:
  displayName: Spring Cloud Serverless
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

To create this accelerator with kubectl, run:

```console
kubectl apply --namespace --accelerator-system --filename spring-cloud-serverless.yaml
```

Or, you can use the Tanzu CLI and run:

```console
tanzu accelerator create spring-cloud-serverless --git-repo https://github.com/vmware-tanzu/application-accelerator-samples.git --git-branch main --git-sub-path spring-cloud-serverless
```

### <a id="examples-custom"></a> An example for creating an accelerator with customized properties

You can specify the `displayName`, `description`, `iconUrl`, and `tags` text boxes and
this overrides any values provided in the accelerator's Git repository. The following example
explicitly sets those text boxes and the `ignore` text box:

**`my-spring-cloud-serverless.yaml`**

```yaml
apiVersion: accelerator.apps.tanzu.vmware.com/v1alpha1
kind: Accelerator
metadata:
  name: my-spring-cloud-serverless
spec:
  displayName: My Spring Cloud Serverless
  description: My own Spring Cloud Function serverless app
  iconUrl: https://raw.githubusercontent.com/simple-starters/icons/master/icon-cloud.png
  tags:
    - spring
    - cloud
    - function
    - serverless
  git:
    ignore: ".git/, bin/"
    url: https://github.com/vmware-tanzu/application-accelerator-samples
    subPath: spring-cloud-serverless
    ref:
      branch: test
```

To create this accelerator with kubectl, run:

```console
kubectl apply --namespace --accelerator-system --filename my-spring-cloud-serverless.yaml
```

To use the Tanzu CLI, run:

```console
tanzu accelerator create my-spring-cloud-serverless --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --git-branch main --git-sub-path spring-cloud-serverless \
  --description "My own Spring Cloud Function serverless app" \
  --display-name "My Spring Cloud Serverless" \
  --icon-url https://raw.githubusercontent.com/simple-starters/icons/master/icon-cloud.png \
  --tags "spring,cloud,function,serverless"
```

>**Note** It is not possible to provide the `git.ignore` option with the Tanzu CLI.

### <a id="examples-multi-manifest"></a> Creating a manifest with multiple accelerators and fragments

You might have a manifest that contains multiple accelerators or fragments. For example:

**`accelerator-collection.yaml`**

```yaml
---
apiVersion: accelerator.apps.tanzu.vmware.com/v1alpha1
kind: Accelerator
metadata:
  name: spring-cloud-serverless
spec:
  git:
    url: https://github.com/vmware-tanzu/application-accelerator-samples
    subPath: spring-cloud-serverless
    ref:
      branch: main
---
apiVersion: accelerator.apps.tanzu.vmware.com/v1alpha1
kind: Accelerator
metadata:
  name: tanzu-java-web-app
spec:
  git:
    url: https://github.com/vmware-tanzu/application-accelerator-samples.git
    subPath: tanzu-java-web-app
    ref:
      branch: main
```

For a larger example of this,
see [Sample Accelerators Main](https://github.com/vmware-tanzu/application-accelerator-samples/blob/main/sample-accelerators-main.yaml).
Optionally, use this to create an initial catalog of accelerators and fragments during a fresh
Application Accelerator install.

## <a id="creating-git-credentials"></a> Configure `tap-values.yaml` with Git credentials secret

> **Note** For how to create a new OAuth Token for optional Git repository creation, see
> [Create an Application Accelerator Git repository during project creation](/docs-tap/tap-gui/plugins/application-accelerator-git-repo.hbs.md).

When deploying accelerators using Git repositories that requires authentication or are installed
with custom CA certificates, you must provide some additional authentication values in a secret. The
examples in the next section provide more details. This section describes how to configure a Git
credentials secret that is used in later Git-based examples.

You can specify the following accelerator configuration properties when installing Application
Accelerator. The same properties are provided in the `accelerator` section of the `tap-values.yaml` file:

```yaml
accelerator:
  git_credentials:
    secret_name: git-credentials
    username: GIT-USER-NAME
    password: GIT-CREDENTIALS
    ca_file: CUSTOM-CA-CERT
```

Where:

- `GIT-USER-NAME` is the user name for authenticating with the Git repository.
- `GIT-CREDENTIALS` is the password or access token used for authenticating with the
  Git repository. VMware recommends using an access token for this.
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

You can specify the custom CA certificate data using the shared config value `shared.ca_cert_data` and
it propagates to all components that can make use of it, including the App Accelerator configuration.
The example earlier produces an output such as this using the shared value:

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

For GitHub repositories that aren't accessible anonymously, you must provide credentials in a Secret.

- For HTTPS repositories the secret must contain user name and password fields. The password field
  can contain a personal access token instead of an actual password.
  For more information, see [Fluxcd/source-controller basic access authentication](https://fluxcd.io/docs/components/source/gitrepositories/#basic-access-authentication).
- For HTTPS with self-signed certificates, you can add a `.data.caFile` value to the secret created
  for HTTPS authentication. For more information, see [fluxcd/source-controller HTTPS Certificate Authority](https://fluxcd.io/docs/components/source/gitrepositories/#https-certificate-authority).
- For SSH repositories, the secret must contain identity, identity.pub, and known_hosts text boxes.
  For more information, see [fluxcd/source-controller SSH authentication](https://fluxcd.io/docs/components/source/gitrepositories/#ssh-authentication).
- For Image repositories that aren't publicly available, an image pull secret might be provided.
  For more information, see [Kubernetes documentation on using imagePullSecrets](https://kubernetes.io/docs/concepts/configuration/secret/#using-imagepullsecrets).

### <a id="private-git-repo-example"></a> Examples for a private Git repository

#### <a id="http-cred-example"></a> Example using http credentials

To create an accelerator using a private Git repository, first create a secret with the HTTP credentials.

>**Note** For better security, use an access token as the password.

```console
kubectl create secret generic https-credentials \
    --namespace accelerator-system \
    --from-literal=username=<user> \
    --from-literal=password=<access-token>
```

Verify that your secret was created by running:

```console
kubectl get secret --namespace accelerator-system https-credentials -o yaml
```

The output is similar to:

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

After you created and verified the secret, you can create the accelerator by using the
`spec.git.secretRef.name` property:

**`private-acc.yaml`**

```yaml
apiVersion: accelerator.apps.tanzu.vmware.com/v1alpha1
kind: Accelerator
metadata:
  name: private-acc
spec:
  displayName: private
  description: Accelerator using a private repository
  git:
    url: REPOSITORY-URL
    ref:
      branch: main
    secretRef:
      name: https-credentials
```

For https credentials, the `REPOSITORY-URL` must use `https://` as the URL scheme.

If you are using the Tanzu CLI, add the `--secret-ref` flag to your `tanzu accelerator create`
command and provide the name of the secret for that flag.

#### <a id="http-ca-cred-example"></a> Example using http credentials with self-signed certificate

To create an accelerator using a private Git repository with a self-signed certificate, create
a secret with the HTTP credentials and the certificate.

>**Note** For better security, use an access token as the password.

```console
kubectl create secret generic https-ca-credentials \
    --namespace accelerator-system \
    --from-literal=username=<user> \
    --from-literal=password=<access-token> \
    --from-file=caFile=<path-to-CA-file>
```

Verify that your secret was created by running:

```console
kubectl get secret --namespace accelerator-system https-ca-credentials -o yaml
```

The output is similar to:

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

After you have the secret created, you can create the accelerator by using the
`spec.git.secretRef.name` property:

**`private-acc.yaml`**

```yaml
apiVersion: accelerator.apps.tanzu.vmware.com/v1alpha1
kind: Accelerator
metadata:
  name: private-acc
spec:
  displayName: private
  description: Accelerator using a private repository
  git:
    url: REPOSITORY-URL
    ref:
      branch: main
    secretRef:
      name: https-ca-credentials
```

> **Important** For https credentials, the `REPOSITORY-URL` must use `https://` as the URL scheme.

If you are using the Tanzu CLI, add the `--secret-ref` flag to your `tanzu accelerator create`
command and provide the name of the secret for that flag.

#### <a id="ssh-example"></a> Example using SSH credentials

To create an accelerator using a private Git repository, create a secret with the SSH
credentials such as this example:

```console
ssh-keygen -q -N "" -f ./identity
ssh-keyscan github.com > ./known_hosts
kubectl create secret generic ssh-credentials \
    --namespace accelerator-system \
    --from-file=./identity \
    --from-file=./identity.pub \
    --from-file=./known_hosts
```

If you have a key file already created, skip the `ssh-keygen` and `ssh-keyscan` steps and replace
the values for the `kubectl create secret` command. Such as:

- `--from-file=identity=<path to your identity file>`
- `--from-file=identity.pub=<path to your identity.pub file>`
- `--from-file=known_hosts=<path to your know_hosts file>`

Verify that your secret was created by running:

```console
kubectl get secret --namespace accelerator-system ssh-credentials -o yaml
```

The output is similar to :

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

To use this secret when creating an accelerator, provide the secret name in the
`spec.git.secretRef.name` property:

**`private-acc-ssh.yaml`**

```yaml
apiVersion: accelerator.apps.tanzu.vmware.com/v1alpha1
kind: Accelerator
metadata:
  name: private-acc
spec:
  displayName: private
  description: Accelerator using a private repository
  git:
    url: REPOSITORY-URL
    ref:
      branch: main
    secretRef:
      name: ssh-credentials
```

When using SSH credentials, the `REPOSITORY-URL` must include the user name as part of
the URL. For example: `ssh://user@example.com:22/repository.git`.
For more information, see [Flux documentation](https://fluxcd.io/flux/components/source/gitrepositories/#url).

If you are using the Tanzu CLI, add the `--secret-ref` flag to your `tanzu accelerator create`
command and provide the name of the secret for that flag.

### <a id="private-source-imageexmpl"></a> Examples for a private source-image repository

If your registry uses a self-signed certificate then you must add the CA certificate data to the
configuration for the "Tanzu Application Platform Source Controller" component. Add it under
`source_controller.ca_cert_data` in your `tap-values.yaml` file that is
used during installation.

**`tap-values.yaml`**

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

To create an accelerator using a private source-image repository, create a secret with the
image-pull credentials:

```console
create secret generic registry-credentials \
    --namespace accelerator-system \
    --from-literal=username=<user> \
    --from-literal=password=<password>
```

Verify that your secret was created by running:

```console
kubectl get secret --namespace accelerator-system registry-credentials -o yaml
```

The output is similar to:

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

After you have the secret created, you can create the accelerator by using the
`spec.git.secretRef.name` property:

**`private-acc.yaml`**

```yaml
apiVersion: accelerator.apps.tanzu.vmware.com/v1alpha1
kind: Accelerator
metadata:
  name: private-acc
spec:
  displayName: private
  description: Accelerator using a private repository
  source:
    image: "registry.example.com/test/private-acc-src:latest"
    imagePullSecrets:
    - name: registry-credentials
```

If you are using the Tanzu CLI, add the `--secret-ref` flag to your `tanzu accelerator create`
command and provide the name of the secret for that flag.

## <a id='configure-timeouts'></a>Configure ingress timeouts when some accelerators take longer to generate

If Tanzu Application Platform is configured to use an ingress for
Tanzu Application Platform GUI and the Accelerator
Server, then it might detect a timeout during accelerator generation. This can happen if the
accelerator takes a longer time to generate than the default timeout. When this happens,
Tanzu Application Platform GUI appears to continue to run for an indefinite period.
In the IDE extension, it shows a `504` error. To mitigate this, you can increase the timeout value
for the HTTPProxy resources used for the ingress by applying secrets with overlays to edit the
HTTPProxy resources.

### <a id='timeout-secrets-created'></a>Configure an ingress timeout overlay secret for each HTTPProxy

For Tanzu Application Platform GUI, create the following overlay secret in the `tap-install` namespace:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: patch-tap-gui-timeout
  namespace: tap-install
stringData:
  patch.yaml: |
    #@ load("@ytt:overlay", "overlay")
    #@overlay/match by=overlay.subset({"kind": "HTTPProxy", "metadata": {"name": "tap-gui"}})
    ---
    spec:
      routes:
        #@overlay/match by=overlay.subset({"services": [{"name": "server"}]})
        #@overlay/match-child-defaults missing_ok=True
        - timeoutPolicy:
            idle: 30s
            response: 30s
```

For Accelerator Server (used for IDE extension), create the following overlay secret in the
`tap-install` namespace:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: patch-accelerator-timeout
  namespace: tap-install
stringData:
  patch.yaml: |
    #@ load("@ytt:overlay", "overlay")
    #@overlay/match by=overlay.subset({"kind": "HTTPProxy", "metadata": {"name": "accelerator"}})
    ---
    spec:
      routes:
        #@overlay/match by=overlay.subset({"services": [{"name": "acc-server"}]})
        #@overlay/match-child-defaults missing_ok=True
        - timeoutPolicy:
            idle: 30s
            response: 30s
```

### <a id='timeout-secrets-applied'></a>Apply the timeout overlay secrets in tap-values.yaml

Add the following `package_overlays` section to `tap-values.yaml` before installing or
updating Tanzu Application Platform:

```yaml
package_overlays:
- name: tap-gui
  secrets:
  - name: patch-tap-gui-timeout
- name: accelerator
  secrets:
  - name: patch-accelerator-timeout
```

## <a id="skip-sources-tls-veri"></a> Configuring skipping TLS verification for access to Source Controller

You can configure the Flux or Tanzu Application Platform Source Controller to use Transport Layer
Security (TLS) and use custom certificates. In that case, configure the Accelerator System to skip
the TLS verification for calls to access the sources by providing the following property in the
`accelerator` section of the `tap-values.yaml` file:

```yaml
sources:
  skip_tls_verify: true
```

## <a id="enabling-tls-server"></a> Enabling TLS for Accelerator Server

To enable TLS for the Accelerator Server, the following properties must be provided in
the `accelerator` section of the `tap-values.yaml` file:

```yaml
server:
  tls:
    enabled: true
    key: SERVER-PRIVATE-KEY
    crt: SERVER-CERTIFICATE
```

Where:

- `SERVER-PRIVATE-KEY` is the pem encoded server private key.
- `SERVER-CERTIFICATE` is the pem encoded server certificate.

Here is a sample `tap-values.yaml` configuration with TLS enabled for Accelerators Server:

```yaml
server:
  tls:
    enabled: true
    key: |
      -----BEGIN PRIVATE KEY-----
      .
      .  < private key data >
      .
      -----END PRIVATE KEY-----
    crt: |
      -----BEGIN CERTIFICATE-----
      .
      .  < certificate data >
      .
      -----END CERTIFICATE-----
```

## <a id="skip-engine-tls-verifi"></a> Configuring skipping TLS verification of Engine calls for Accelerator Server

If you configure the Accelerator Engine to use TLS and use custom certificates, then you can configure
the Accelerator Server to skip the TLS verification for calls to the Engine by providing the following
property in the `accelerator` section of the `tap-values.yaml` file:

```yaml
server:
  engine_skip_tls_verify: true
```

## <a id="enabling-tls-engine"></a> Enabling TLS for Accelerator Engine

To enable TLS for the Accelerator Engine, the following properties are provided in the
 `accelerator` section of the `tap-values.yaml` file:

```yaml
engine:
  tls:
    enabled: true
    key: ENGINE-PRIVATE-KEY
    crt: ENGINE-CERTIFICATE
```

Where:

- `ENGINE-PRIVATE-KEY` is the pem encoded acc-engine private key.
- `ENGINE-CERTIFICATE` is the pem encoded acc-engine certificate.

Here is a sample `tap-values.yaml` configuration with TLS enabled for Accelerators Engine:

```yaml
engine:
  tls:
    enabled: true
    key: |
      -----BEGIN PRIVATE KEY-----
      .
      .  < private key data >
      .
      -----END PRIVATE KEY-----
    crt: |
      -----BEGIN CERTIFICATE-----
      .
      .  < certificate data >
      .
      -----END CERTIFICATE-----
```

## <a id='next-steps'></a>Next steps

- [Creating accelerators](creating-accelerators/creating-accelerators.hbs.md)
