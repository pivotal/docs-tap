# Out of the Box Supply Chain with testing on Jenkins for Supply Chain Choreographer

This topic provides an overview of Out of the Box Supply Chain with testing on Jenkins for Supply Chain Choreographer.

The Out of the Box templates package now includes a Tekton `ClusterTask`
resource, which triggers a build for a specified Jenkins job.

You can configure the Jenkins task in both the [Out of the Box Supply Chain with Testing](ootb-supply-chain-testing.html)
and [Out of the Box Supply Chain With Testing and Scanning](ootb-supply-chain-testing-scanning.html)
to trigger a Jenkins job.  The task is implemented as a Tekton `ClusterTask` and
can now run from a Tekton `Pipeline`.

## <a id="prerequisite"></a> Prerequisites

Follow the instructions from either [Out of the Box Supply Chain With
Testing](ootb-supply-chain-testing.html) or [Out of the Box Supply Chain With
Testing and Scanning](ootb-supply-chain-testing-scanning.html) to
install the required packages. You need to set up only one of these packages.

Either of these Supply Chains can use the Jenkins service during the `source-tester`
phase of the pipeline.

### <a id="using-ootb-jenkins-task"></a> Using the Out of the Box Jenkins Task

The intent of the Jenkins task provided using Out of the Box templates is to help
Tanzu Application Platform users to integrate with and make use of the modern application
deployment pipeline provided by our platform while maintaining their existing test suites on
their Jenkins services.

The Out of the Box Jenkins task makes use of an existing Jenkins Job to run test suites on source code.

#### <a id="config-jenkins-existing"></a> Configuring a Jenkins job in an existing Jenkins Pipeline

This section of the guide shows how to configure a Jenkins job that you can kick off by the
Tanzu Application Platform Jenkins task.

#### <a id="ex-jenkins-job"></a> Example Jenkins Job

Here is an example of a script that you can add to your pipeline that specifies source URL and source revision
information for your source code target.
This example uses a Jenkins instance that is deployed on a Kubernetes cluster although this is not the only possible
configuration for a Jenkins instance.

```groovy
#!/bin/env groovy

pipeline {
  agent {
    // Use an agent that is appropriate
    // for your Jenkins installation.
    // This is only an example
    kubernetes {
      label 'maven'
    }
  }

  stages {
    stage('Checkout code') {
      steps {
        script {
          sourceUrl = params.SOURCE_REVISION
          indexSlash = sourceUrl.indexOf("/")
          if (indexSlash == -1) {
            // TAP 1.6+
            revision = sourceUrl.substring(sourceUrl.indexOf(":") + 1)
          } else {
            // pre TAP 1.6
            revision = sourceUrl.substring(indexSlash + 1)
          }
        }
        sh "git clone ${params.GIT_URL} target"
        dir("target") {
          sh "git checkout ${revision}"
        }
      }
    }

    stage('Maven test') {
      steps {
        container('maven') {
          dir("target") {
            // Example tests with maven
            sh "mvn clean test --no-transfer-progress"
          }
        }
      }
    }
  }
}
```

Where:

- `SOURCE_URL` **string** The URL of the source code being tested.  The `source-provider` resource in the supply chain provides this code and is only resolvable inside the Kubernetes cluster.  This URL is only useful if your Jenkins service is running inside the cluster or if there is ingress set up and the Jenkins service can make requests to services inside the cluster.

- `SOURCE_REVISION` **string** The revision of the source code being tested. The format of this value can vary depending on the implementation of the `source_provider` resource.  If the `source-provider` is the Flux CD `GitRepository` resource, then the value of the `SOURCE_REVISION` is the Git branch name followed by the commit SHA, both separated by a (`/`) slash character. For example, `main/2b1ed6c3c4f74f15b0e4de2732234eafd050eb1ca`. Your Jenkins pipeline script must extract the commit SHA from the `SOURCE_REVISION` to be useful.

>**Note**
>If you can't use the `SOURCE_URL` because your Jenkins service cannot
>make requests into the Kubernetes cluster, you can supply the source code
>URL to the Jenkins job with other parameters instead.

The following fields are also required in the Jenkins Job definition

- `SOURCE_REVISION` **string**
- `GIT_URL` **string**

To configure your `Workload` to pass the `GIT_URL` parameter into the Jenkins task:

```console
tanzu apps workload create workload \
  --namespace your-test-namespace \
  --git-branch main \
  --git-repo https://your.git/repository.git \
  --label apps.tanzu.vmware.com/has-tests=true \
  --label app.kubernetes.io/part-of=test-workload \
  --param-yaml testing_pipeline_matching_labels='{"apps.tanzu.vmware.com/pipeline":"jenkins-pipeline"}' \
  --param-yaml testing_pipeline_params='{"secret-name":"my-secret","job-name":"jenkins-job-name","job-params":"[{\"name\":\"GIT_URL\",\"value\":\"https://your.git/repository.git\"}]"}' \
  --type web \
  --yes
```

The `Workload` is described in the later [Developer Workload](#developer-workload)
section.

#### <a id="create-secret"></a> Create a secret with authentication credentials

A secret must be created in the developer namespace to contain the credentials required to authenticate and interact with your Jenkins instance's builds. The following properties are required:

- `url` **required**: URL of the Jenkins instance that hosts the job, including
  the scheme. For example: `https://my-jenkins.com`.
- `username` **required**: User name of the user that has access to trigger a build on Jenkins.
- `password` **required**: Password of the user that has access to trigger a build on Jenkins.
- `ca-cert` **optional**: The PEM-encoded CA certificate to verify the Jenkins instance identity.

Use the Kubernetes CLI tool (kubectl) to create the secret. You can provide the optional PEM-encoded CA certificate as a file using the `--from-file` flag:

```console
kubectl create secret generic my-secret \
  --from-literal=url=https://jenkins.instance \
  --from-literal=username=literal-username \
  --from-file=password=/path/to/file/with/password.txt \
  --from-file=ca-cert=/path/to/ca-certificate.pem \
```

The expected format of the secret is as follows:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: MY-SECRET # secret name that will be referenced by the workload
type: Opaque
stringData:
  url: JENKINS-URL # target jenkins instance url
  username: USERNAME # jenkins username
  password: PASSWORD # jenkins password or token
  ca-cert: PEM-CA-CERT # PEM encoded certificate
```

Where:

- `MY-SECRET` is the secret name that is referenced by the workload.
- `JENKINS-URL` is the target Jenkins instance URL.
- `USERNAME` is the Jenkins username.
- `PASSWORD` is the Jenkins password or token.
- `PEM-CA-CERT` is the PEM encoded certificate.

#### <a id="tekton-pipeline"></a> Create a Tekton pipeline

The developer must create a Tekton `Pipeline` object with the following
parameters:

- `source-url`, **required**: An HTTP address where a `.tar.gz` file containing
  all the source code being tested is supplied.
- `source-revision`, **required**: The revision of the commit or image reference
  found by the `source-provider`.
- `secret-name`, **required**: The secret that contains the URL, user name,
  password, and certificate (optional) to the Jenkins instance that houses the
  job that is required to run.
- `job-name`, **required**: The name of the Jenkins job that is required to run.
- `job-params`, **required**: A list of key-value pairs, encoded as a JSON
  string, that passes in parameters needed for the Jenkins job.

Tasks:

- `jenkins-task`, **required**: This `ClusterTask` is one of the tasks that the
  pipeline runs to trigger the Jenkins job.  It is installed in the cluster by the
  **Out of the Box Templates** package.

Results:

- `jenkins-job-url`: A string result that outputs the URL of the Jenkins build
  that the Tekton task triggered. The `jenkins-task`
  `ClusterTask` populates the output.

Here is an example of how to create a tekton pipeline with the required parameters

```console
cat <<EOF | kubectl apply -f -
---
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: developer-defined-jenkins-tekton-pipeline
  namespace: developer-namespace
  labels:
    #! This label should be provided to the Workload so that
    #! the supply chain can find this pipeline
    apps.tanzu.vmware.com/pipeline: jenkins-pipeline
spec:
  results:
  - name: jenkins-job-url   #! To show the job URL on the
    #! Tanzu Developer Portal
    value: $(tasks.jenkins-task.results.jenkins-job-url)
  params:
  - name: source-url        #! Required
  - name: source-revision   #! Required
  - name: secret-name       #! Required
  - name: job-name          #! Required
  - name: job-params        #! Required
  tasks:
  #! Required: Include the built-in task that triggers the
  #! given job in Jenkins
  - name: jenkins-task
    taskRef:
      name: jenkins-task
      kind: ClusterTask
    params:
      - name: source-url
        value: $(params.source-url)
      - name: source-revision
        value: $(params.source-revision)
      - name: secret-name
        value: $(params.secret-name)
      - name: job-name
        value: $(params.job-name)
      - name: job-params
        value: $(params.job-params)
EOF
```

#### <a id="patch-the-service-account"></a> Patching the default Service Account

Tanzu Application Platform includes a [Namespace Provisioner](../namespace-provisioner/about.hbs.md) which is not enabled by default.
This section requires that you do not use the Namespace Provisioner.

The `jenkins-task` `ClusterTask` resource uses a container image with the
Jenkins Adapter application to trigger the Jenkins job and wait for it to complete.
This container image is distributed with Tanzu Application Platform on VMware
Tanzu Network, but it is not installed at the same time as the other packages.
It is pulled at the time that the supply chain executes the job. As a result, it
does not implicitly have access to the `imagePullSecrets` with the required credentials.

> **Important** The `ServiceAccount` that a developer can configure with their
`Workload` is *not* passed to the task and is not used to pull the Jenkins
Adapter container image.  If you  followed the Tanzu Application Platform
Install Guide, then you have a `Secret` named `tap-registry` in each of your
cluster's namespaces. You can patch the default Service Account in your
workload's namespace so that your supply chain can pull the Jenkins Adapter
image. For example:

```console
kubectl patch serviceaccount default \
  --patch '{"imagePullSecrets": [{"name": "tap-registry"}]}' \
  --namespace developer-namespace
```

#### <a id="developer-workload"></a> Create a Developer Workload

Submit your `Workload` to the same namespace as the Tekton `Pipeline`
defined earlier.

To enable the supply chain to run Jenkins tasks, the `Workload` must include the
following parameters:

```yaml
parameters:

  #! Required: selects the pipeline
  - name: testing_pipeline_matching_labels
    value:
      #! This label must match the label on the pipeline created earlier
      apps.tanzu.vmware.com/pipeline: jenkins-pipeline

  #! Required: Passes parameters to pipeline
  - name: testing_pipeline_params
    value:

      #! Required: Name of the Jenkins job
      job-name: my-jenkins-job

      #! Required: The secret created earlier to access Jenkins
      secret-name: my-secret

      #! Required: The `job-params` element is required, but the parameter string
      #! might be empty. If empty, then set this value to `[]`.  If non-empty then the
      #! value contains a JSON-encoded list of parameters to pass to the Jenkins job.
      #! Ensure that the quotation marks inside the JSON-encoded string are escaped.
      job-params: "[{\"name\":\"A\",\"value\":\"x\"},{\"name\":\"B\",\"value\":\"y\"},...]"
```

You can create the workload by using the `apps` CLI plug-in. For example:

```console
readonly GIT_BRANCH="my-git-branch"
readonly WORKLOAD_NAME="my-workload-name"
readonly GITHUB_REPO="github-repository-url"
readonly DEVELOPER_WORKSPACE_NAME="my-developer-namespace"

tanzu apps workload create "${WORKLOAD_NAME}" \
  --namespace "${DEVELOPER_WORKSPACE_NAME}" \
  --git-branch "${GIT_BRANCH}" \
  --git-repo "${GITHUB_REPO}" \
  --label apps.tanzu.vmware.com/has-tests=true \
  --label app.kubernetes.io/part-of="${WORKLOAD_NAME}" \
  --param-yaml testing_pipeline_matching_labels='{"apps.tanzu.vmware.com/pipeline":"jenkins-pipeline"}' \
  --param-yaml testing_pipeline_params='{"secret-name":"jenkins-secret", "job-name": "jenkins-job", "job-params":"[{"name":"GIT_URL", "value":"https://github.com/spring-projects/spring-petclinic"}, {"name":"GIT_BRANCH", "value":"main"}]"}'\
  --type web
  ```

Where:

- `GIT_URL` is the URL of your GitHub repository.
- `GIT_BRANCH` is the branch you want to target.

The value of the `job-params` parameter is a list of zero-or-more parameters
that are sent to the Jenkins job.  The parameter is entered into the
`Workload` as a list of name-value pairs as shown in the example above.

>**Important** None of the fields in the `Workload` resource are implicitly passed to the
>Jenkins job. You have to set them in the `job-params` explicitly.
>An exception to this is the `SOURCE_URL` and `SOURCE_REVISION` parameters are sent to the
>Jenkins job implicitly by the Jenkins Adapter trigger application. For example, you can use the
>`SOURCE_REVISION` to verify which commit SHA to test.  See [Making
>a Jenkins Test Job](#making-a-jenkins-test-job) earlier for details about how to use
>the Git URL and source revision in a Jenkins test job.

Watch the quoting of the `job-params` value closely. In the earlier `tanzu apps
workload create` example, the `job-params` value is a string with a JSON
structure in it.  The value of the `--param-yaml testing_pipeline_params`
parameter is a JSON string. Add backslash (`\`) escape
characters before the double quote characters (`"`) in the `job-params` value.

Example output from the `tanzu apps workload create` command:

```console
Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  labels:
      6 + |    app.kubernetes.io/part-of: my-workload-name
      7 + |    apps.tanzu.vmware.com/has-tests: "true"
      8 + |  name: my-workload-name
      9 + |  namespace: developer-namespace
     10 + |spec:
     11 + |  params:
     12 + |  - name: testing_pipeline_matching_labels
     13 + |    value:
     14 + |      apps.tanzu.vmware.com/pipeline: jenkins-pipeline
     15 + |  - name: testing_pipeline_params
     16 + |    value:
     17 + |      job-name: jenkins-job
     18 + |      job-params:
     19 + |      - name: param1
     20 + |        value: value1
     21 + |      secret-name: my-secret
     22 + |  source:
     23 + |    git:
     24 + |      ref:
     25 + |        branch: my-branch
     26 + |      url: https://my-source-code-repository
```
