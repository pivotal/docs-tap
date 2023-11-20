# Deploy an air-gapped workload on Tanzu Application Platform

This topic for developers guides you through deploying your first workload on Tanzu Application Platform (commonly known as TAP)
in an air-gapped environment.

For information about installing Tanzu Application Platform in an air-gapped environment, see
[Install Tanzu Application Platform in an air-gapped environment](../install-offline/profile.hbs.md).

## <a id="you-will"></a>What you will do

- Create a workload from Git.
- Create a basic supply chain workload.
- Create a testing supply chain workload.
- Create a testing scanning supply chain workload.

## <a id="prereqs"></a>Prerequisites

Before you begin, a Platform operator must configure the air-gapped environment using Namespace Provisioner.
For instructions, see [Work with Git repositories in air-gapped environments with Namespace Provisioner](../namespace-provisioner/use-case7.hbs.md).

## <a id="create-workload"></a>Create a workload from Git

To create a workload from Git through HTTPS, follow these steps:

1. (Optional) To pass in login credentials for a Git repository with the certificate authority (CA)
   certificate, create a file called `git-credentials.yaml`. For example:

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: git-ca
      # namespace: default
    type: Opaque
    stringData:
      username: USERNAME
      password: PASSWORD
      caFile: |
        CADATA
    ```

    Where:

    - `USERNAME` is the user name.
    - `PASSWORD` is the password.
    - `CADATA` is the PEM-encoded CA certificate for the Git repository.

1. To pass in a custom `settings.xml` for Java, create a file called `settings-xml.yaml`. For example:

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
      name: settings-xml
    type: service.binding/maven
    stringData:
      type: maven
      provider: sample
      settings.xml: |
        <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
            <mirrors>
                <mirror>
                    <id>reposilite</id>
                    <name>Tanzu seal Internal Repo</name>
                    <url>https://reposilite.tap-trust.cf-app.com/releases</url>
                    <mirrorOf>*</mirrorOf>
                </mirror>
            </mirrors>
            <servers>
                <server>
                    <id>reposilite</id>
                    <username>USERNAME</username>
                    <password>PASSWORD</password>
                </server>
            </servers>
        </settings>
    ```

1. Apply the file:

    ```console
    kubectl create -f settings-xml.yaml -n DEVELOPER-NAMESPACE
    ```

## <a id="create-basic-wkload"></a>Create a basic supply chain workload

Next, create your basic supply chain workload.

To pass the CA certificate in when you create the workload, run:

```console
tanzu apps workload create APP-NAME --git-repo  https://GITREPO --git-branch BRANCH --type web --label app.kubernetes.io/part-of=CATALOGNAME --yes --param-yaml buildServiceBindings='[{"name": "settings-xml", "kind": "Secret"}]' --param "gitops_ssh_secret=git-ca"
```

## <a id="create-test-wkload"></a>Create a testing supply chain workload

For instructions about creating a workload with the testing supply chain, see [Install OOTB Supply Chain with Testing](add-test-and-security.hbs.md#install-OOTB-test).

To add the Tekton supply chain to the cluster, apply the following YAML to the cluster:

```yaml
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: developer-defined-tekton-pipeline
  labels:
    apps.tanzu.vmware.com/pipeline: test     # (!) required
spec:
  params:
    - name: source-url                       # (!) required
    - name: source-revision                  # (!) required
  tasks:
    - name: test
      params:
        - name: source-url
          value: $(params.source-url)
        - name: source-revision
          value: $(params.source-revision)
      taskSpec:
        params:
          - name: source-url
          - name: source-revision
        steps:
          - name: test
            image: MY-REGISTRY/gradle
            script: |-
              cd `mktemp -d`
```

Where `MY-REGISTRY` is your container image registry. Relocate all the images given in the pipeline YAML to your private container registry.

Create the workload by running:

```console
tanzu apps workload create APP-NAME --git-repo  https://GITURL --git-branch BRANCH --type web --label app.kubernetes.io/part-of=CATALOGNAME --yes --param-yaml --label apps.tanzu.vmware.com/has-tests=true buildServiceBindings='[{"name": "settings-xml", "kind": "Secret"}]'
```

To instead pass the CA certificate when you create the workload, run:

```console
tanzu apps workload create APP-NAME --git-repo  https://GITREPO --git-branch BRANCH --type web --label app.kubernetes.io/part-of=CATALOGNAME --yes --param-yaml --label apps.tanzu.vmware.com/has-tests=true buildServiceBindings='[{"name": "settings-xml", "kind": "Secret"}]' --param "gitops_ssh_secret=git-ca"
```

## <a id="create-test-scan-wkload"></a>Create a testing scanning supply chain workload

For instructions about creating a workload with the testing and scanning supply chain, see [Install OOTB Supply Chain with Testing and Scanning](add-test-and-security.hbs.md#install-OOTB-test-scan).

In addition to the prerequisites given at [Prerequisites](add-test-and-security.hbs.md#prereqs-install-OOTB-test-scan),
follow [Using Grype in offline and air-gapped environments](../scst-scan/offline-airgap.hbs.md)
before workload creation.

Create workload by running:

```console
tanzu apps workload create APP-NAME --git-repo  https://GITURL --git-branch BRANCH --type web --label app.kubernetes.io/part-of=CATALOGNAME --yes --param-yaml --label apps.tanzu.vmware.com/has-tests=true buildServiceBindings='[{"name": "settings-xml", "kind": "Secret"}]'
```

To instead pass the CA certificate when you create the workload, run:

```console
tanzu apps workload create APP-NAME --git-repo  https://GITREPO --git-branch BRANCH --type web --label app.kubernetes.io/part-of=CATALOGNAME --yes --param-yaml --label apps.tanzu.vmware.com/has-tests=true buildServiceBindings='[{"name": "settings-xml", "kind": "Secret"}]' --param "gitops_ssh_secret=git-ca"
```
