# Out of the Box Supply Chain with Testing on Jenkins

The Out of the Box Templates package now includes a Tekton `ClusterTask`
resource which triggers a build for a specified Jenkins job.

The Jenkins task in both the [Out of the Box Supply Chain With
Testing](ootb-supply-chain-testing.html) and [Out of the Box Supply Chain With
Testing and Scanning](ootb-supply-chain-testing-scanning.html) may be configured
to trigger a Jenkins job.  The task is implemented as a Tekton `ClusterTask` and
can be run from a Tekton `Pipeline`.

## <a id="prerequisite"></a> Prerequisites

Follow the instructions from [Out of the Box Supply Chain With
Testing](ootb-supply-chain-testing.html) or [Out of the Box Supply Chain With
Testing and Scanning](ootb-supply-chain-testing-scanning.html) to successfully install the
required packages.  You now need to set up one, but not both, of those
packages.

These supply chains can use the Jenkins service during the `source-tester`
phase of the pipeline.

### <a id="making-a-jenkins-test-job"></a> Making a Jenkins test job

The intent of the Jenkins task for the Out of the Box Templates is to help Tanzu Application Platform
users keep their existing test suites on their Jenkins services and still
integrate with the modern application deployment pipeline that Tanzu Application Platform provides.

This section of the guide instructs you on how to configure a Jenkins job triggered by the Tanzu Application Platform Jenkins task.

It is assumed that the Jenkins job is being used to run test suites on some
code.  For the Jenkins job to know which source code to test, the
Jenkins task calls the Jenkins job with the following two parameters, even
if they are not declared in the `Workload` `job-params`.  The Jenkins task
only passes these parameters, however, if they are defined in the Jenkins job
itself. this URL

- `SOURCE_URL` **string** The URL of source code to be tested.  Note that it
  is served by the `source-provider` resource in the supply chain and is only
  resolvable inside the Kubernetes cluster.  This URL is only useful if your
  Jenkins service is running inside the cluster or there is some kind of ingress
  set up with the Jenkins service can make requests to services inside the
  cluster.

- `SOURCE_REVISION` **string** The revision of the source code to be tested.
  The format of this value can vary depending on the implementation of the
  `source-provider` resource.  If the "source-provider" is the FluxCD
  `GitRepository` resource then the value of the `SOURCE_REVISION` is  the
  Git branch name followed by the commit SHA, both separated by a slash (`/`)
  character (e.g. `main/2b1ed6c3c4f74f15b0e4de2732234eafd050eb1ca`).  Your
  Jenkins pipeline script has to extract the commit SHA from the
  `SOURCE_REVISION` to be useful.  See the example in the
  [Example Jenkins Job](#example-jenkins-job) for guidance.

If you can't use the `SOURCE_URL` (because your Jenkins service cannot
make requests into the Kubernetes cluster) then you can supply the source code
URL to the Jenkins job with other parameters instead.  See the following
example.

#### <a id="example-jenkins-job"></a> Example Jenkins Job

Add the following parameters to your Jenkins job:

- `SOURCE_REVISION`  **string**
- `GIT_URL`          **string**

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
          sourceUrl = params.SOURCE_REVISION
          indexSlash = sourceUrl.indexOf("/")
          revision = sourceUrl.substring(indexSlash + 1)
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

You need to configure your `Workload` to pass the `GIT_URL` parameter into
the Jenkins task:

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

### <a id="updates-to-developer-namespace"></a> Updates to the Developer Namespace

#### <a id="create-secret"></a> Create a secret

A secret must be created in the developer namespace with the following properties:

- `url` **required** URL of the Jenkins instance that hosts the job, including
  the scheme (e.g. "https://my-jenkins.com").
- `username` **required** User name of the user that has access to trigger a build on Jenkins.
- `password` **required** Password of the user that has access to trigger a build on Jenkins.
- `ca-cert` **optional** The PEM-encoded CA certificate to verify the Jenkins instance
  identity.

For example:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
type: Opaque
stringData:
  url: <Jenkins URL>
  username: <username>
  password: <password>
  ca-cert: <PEM-encoded CA certificate>
```

You cannot use the Tanzu CLI to create secrets such as this, but you can use
the Kubectl CLI instead.

If you have saved the password to a file and you have saved the
optional PEM-encoded CA certificate in a file, here is an example command to
create this kind of secret:

```bash
kubectl create secret generic my-secret \
  --from-literal=url=https://jenkins.instance \
  --from-literal=username=literal-username \
  --from-file=password=/path/to/file/with/password.txt \
  --from-file=ca-cert=/path/to/ca-certificate.pem \
```

#### <a id="tekton-pipeline"></a> Create a Tekton pipeline

The developer must create a Tekton `Pipeline` object with the following
parameters:

- `source-url`, **required** An HTTP address where a `.tar.gz` file containing
  all the source code to be tested is supplied.
- `source-revision`, **required** The revision of the commit or image reference
  found by the `source-provider`.
- `secret-name`, **required** The secret that contains the URL, user name,
  password, and certificate (optional) to the Jenkins instance that houses the
  job that is required to be run.
- `job-name`, **required** The name of the Jenkins job that is reqired to run.
- `job-params`, **required** A list of key-value pairs, encoded as a JSON
  string, that passes in parameters needed for the Jenkins job.

Tasks:

- `jenkins-task`, **required** This `ClusterTask` is one of the tasks that the
  pipeline runs to successfully trigger the Jenkins job.  It is
  installed in the cluster by the "Out of the Box Templates" package.

Results:

- `jenkins-job-url`, A string result that outputs the URL of the Jenkins build
  that the Tekton task triggered. This output is populated by the `jenkins-task`
  `ClusterTask`.

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
  - name: jenkins-job-url   #! To show the job URL on the TAP GUI
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

Save the earlier YAML definition to a file (e.g.: `pipeline.yaml`), then run the
following command to add the pipeline to your cluster.

```console
kubectl apply -f pipeline.yaml
```

#### <a id="patch-the-service-account"></a> Patch the Service Account

The `jenkins-task` `ClusterTask` resource uses a container image with the
Jenkins Adapter program to trigger the Jenkins job and wait for it to
complete. This container image is distributed with Tanzu Application Platform on VMware Tanzu Network but is
not installed at the same time as all the other packages. It is pulled at the
time that supply chain executes the job. As a result, it does not implicitly have
access to the `imagePullSecrets` with the required credentials.

*Important:* The `ServiceAccount` that a developer can configure with their
`Workload`s is *not* passed to the task and is not used to pull the Jenkins
Adapter container image.  If you have followed the Tanzu Application Platform Install Guide then you
have a `Secret` named `tap-registry` in each of your cluster's namespaces.
You can patch the default Service Account in your workload's namespace so that
your supply chain can pull the Jenkins Adapter image successfully.  e.g.:

```console
kubectl patch serviceaccount default \
  --patch '{"imagePullSecrets": [{"name": "tap-registry"}]}' \
  --namespace developer-namespace
```

These tasks are run by Tekton.  Tekton has other methods for configuring the
[service account credentials](https://tekton.dev/docs/pipelines/pipelineruns/#specifying-custom-serviceaccount-credentials)
used by running tasks, if you prefer.

## <a id="developer-workload"></a> Developer Workload

Submit your `Workload` to the same namespace as the Tekton `Pipeline`
defined earlier.

To enable the supply chain to run Jenkins tasks the `Workload` must include the
following parameters:

```yaml
params<!--฿ |parameters| is preferred. ฿-->:

  #! Required: picks the pipeline
  - name: testing_pipeline_matching_labels
    value:
      #! This label must match the label on the pipeline created earlier
      apps.tanzu<!--฿ The brand is |Tanzu|. ฿-->.vmware<!--฿ |VMware| is preferred. ฿-->.com/pipeline: jenkins-pipeline

  #! Required: Passes parameters to pipeline
  - name: testing_pipeline_params
    value:

      #! Required: Name of the Jenkins job
      job-name: my-jenkins-job

      #! Required: The secret created earlier to access Jenkins
      secret-name: my-secret

      #! Required: The `job-params` element is required, but the parameter string
      #! may be empty. If empty, then set this value to `[]`.  If non-empty then the
      #! value contains a JSON-encoded list of parameters to pass to the Jenkins job.
      #! Ensure that the quotation marks inside the JSON-encoded string are escaped.
      job-params: "[{\"name\":\"A\",\"value\":\"x\"},{\"name\":\"B\",\"value\":\"y\"},...]"
```

The workload can also be created using the `apps` CLI plug-in:

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
that is sent to the Jenkins job.  The parameter are entered into the
`Workload` as a list of name-value pairs.  For example:

```json
[{"name":"GIT_URL", "value":"https://github.com/spring-projects/spring-petclinic"}, {"name":"GIT_BRANCH", "value":"main"}]
```

*Important:* None of the fields in the `Workload` resource are implicitly passed to the
Jenkins job. You have to set them in the `job-params` explicitly.

*Exception:* The `SOURCE_URL` and `SOURCE_REVISION` parameters are sent to the
Jenkins job implicitly by the Jenkins Adapter trigger program.  You can use the
`SOURCE_REVISION` to verify which commit SHA to test, for example.  See [Making
a Jenkins Test Job](#making-a-jenkins-test-job) earlier for details about how to use
the Git URL and source revision in a Jenkins test job.

Watch the quoting of the `job-params` value closely.  In the earlier tanzu apps
workload create example the `job-params` value is a string with a JSON
structure in it.  The value of the `--param-yaml testing_pipeline_params`
parameter itself is a JSON string, so the backslash escape characters before
the double quote characters (`"`) in the `job-params` value.

Example output form the `tanzu apps workload create` command:

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

