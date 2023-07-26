# Out of the Box Supply Chain with testing on Jenkins

The Out of the Box templates package now includes a Tekton `ClusterTask`
resource, which triggers a build for a specified Jenkins job.

You can configure the Jenkins task in both the [Out of the Box Supply Chain with Testing](ootb-supply-chain-testing.html)
and [Out of the Box Supply Chain With Testing and Scanning](ootb-supply-chain-testing-scanning.html)
to trigger a Jenkins job.  The task is implemented as a Tekton `ClusterTask` and
can now run from a Tekton `Pipeline`.

## <a id="prerequisite"></a> Prerequisites

Follow the instructions from [Out of the Box Supply Chain With
Testing](ootb-supply-chain-testing.html) or [Out of the Box Supply Chain With
Testing and Scanning](ootb-supply-chain-testing-scanning.html) to
install the required packages. You must set up only one of these packages.

These supply chains can use the Jenkins service during the `source-tester`
phase of the pipeline.

### <a id="making-a-jenkins-test-job"></a> Making a Jenkins test job

The intent of the Jenkins task for the Out of the Box templates is to help Tanzu Application Platform
users keep their existing test suites on their Jenkins services and still
integrate with the modern application deployment pipeline that Tanzu Application Platform provides.

This section of the guide instructs you on how to configure a Jenkins job triggered by the
Tanzu Application Platform Jenkins task.

It is assumed that you are using the Jenkins job to run test suites on code.
For the Jenkins job to know which source code to test, the
Jenkins task calls the Jenkins job with the `Workload` and `job-params` parameters, even
if they are not declared in `Workload` or `job-params`.  The Jenkins tasks
only pass these parameters if they are defined in the Jenkins job itself.

- `SOURCE-URL` **string** The URL of the source code being tested.  The
  `source-provider` resource in the supply chain provides this code and is only
  resolvable inside the Kubernetes cluster.  This URL is only useful if your
  Jenkins service is running inside the cluster or if there is ingress
  set up and the Jenkins service can make requests to services inside the
  cluster.

- `SOURCE-REVISION` **string** The revision of the source code being tested.
  The format of this value can vary depending on the implementation of the
  `source_provider` resource.  If the `source-provider` is the Flux CD
  `GitRepository` resource, then the value of the `SOURCE-REVISION` is the
  Git branch name followed by the commit SHA, both separated by a (`/`) slash
  character. For example: `main/2b1ed6c3c4f74f15b0e4de2732234eafd050eb1ca`. Your
  Jenkins pipeline script must extract the commit SHA from the
  `SOURCE-REVISION` to be useful.  See the example in the
  [Example Jenkins Job](#example-jenkins-job) for guidance.

If you can't use the `SOURCE-URL` because your Jenkins service cannot
make requests into the Kubernetes cluster, then you can supply the source code
URL to the Jenkins job with other parameters instead.  See the following
example.

#### <a id="example-jenkins-job"></a> Example Jenkins Job

Add the following parameters to your Jenkins job:

- `SOURCE-REVISION` **string**
- `GIT-URL` **string**

Use the following script in your pipeline:

```groovy
#!/bin/env groovy

pipeline {
  agent {
    kubernetes {
      label 'maven'
    }
  }

  stages {
    stage('Checkout code') {
      steps {
        script {
          sourceUrl = params.SOURCE-REVISION
          indexSlash = sourceUrl.indexOf("/")
          revision = sourceUrl.substring(indexSlash + 1)
        }
        sh "git clone ${params.GIT-URL} target"
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

To configure your `Workload` to pass the `GIT-URL` parameter into the Jenkins task:

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

### <a id="updates-to-dev-namespace"></a> Updates to the developer namespace

#### <a id="create-secret"></a> Create a secret

A secret must be created in the developer namespace with the following properties:

- `JENKINS-URL` **required**: URL of the Jenkins instance that hosts the job, including
  the scheme. For example: https://my-jenkins.com.
- `USERNAME` **required**: User name of the user that has access to trigger a build on Jenkins.
- `PASSWORD` **required**: Password of the user that has access to trigger a build on Jenkins.
- `PEM-CA-CERT` **optional**: The PEM-encoded CA certificate to verify the Jenkins instance identity.

For example:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: MY-SECRET
type: Opaque
stringData:
  url: JENKINS-URL
  username: USERNAME
  password: PASSWORD
  ca-cert: PEM-CA-CERT
```

You cannot use the Tanzu CLI to create secrets such as this, but you can use
the Kubernetes CLI tool (kubectl) instead.

If you saved the password to a file, and you saved the optional PEM-encoded CA certificate in a file,
here is an example command to create this kind of secret:

```console
kubectl create secret generic my-secret \
  --from-literal=url=https://jenkins.instance \
  --from-literal=username=literal-username \
  --from-file=password=/path/to/file/with/password.txt \
  --from-file=ca-cert=/path/to/ca-certificate.pem \
```

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
  "Out of the Box Templates" package.

Results:

- `jenkins-job-url`: A string result that outputs the URL of the Jenkins build
  that the Tekton task triggered. The `jenkins-task`
  `ClusterTask` populates the output.

For example:

```yaml
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
    #! Tanzu Application Platform GUI
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
```

Save the earlier YAML definition to a file, for example, `pipeline.yaml`. Run:

```console
kubectl apply -f pipeline.yaml
```

#### <a id="patch-the-service-account"></a> Patch the Service Account

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

These tasks are run by Tekton.  Tekton has other methods for configuring the
[custom service account credentials](https://tekton.dev/docs/pipelines/pipelineruns/#specifying-custom-serviceaccount-credentials)
used by running tasks, if you prefer.

## <a id="developer-workload"></a> Developer Workload

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

You can create the workload by using the `apps` CLI plug-in:

```console
tanzu apps workload create my-workload-name \
  --namespace developer-namespace \
  --git-branch my-branch \
  --git-repo https://my-source-code-repository \
  --label apps.tanzu.vmware.com/has-tests=true \
  --label app.kubernetes.io/part-of=my-workload-name \
  --param-yaml testing_pipeline_matching_labels='{"apps.tanzu.vmware.com/pipeline":"jenkins-pipeline"}' \
  --param-yaml testing_pipeline_params='{"secret-name":"my-secret", "job-name": "jenkins-job", "job-params": "SEE BELOW"}'
  --type web
```

The value of the `job-params` parameter is a list of zero-or-more parameters
that are sent to the Jenkins job.  The parameter is entered into the
`Workload` as a list of name-value pairs.  For example:

```json
[{"name":"GIT-URL", "value":"https://github.com/spring-projects/spring-petclinic"}, {"name":"GIT-BRANCH", "value":"main"}]
```

Where:

- `GIT-URL` is the URL of your GitHub repository.
- `GIT-BRANCH` is the branch you want to target.

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
