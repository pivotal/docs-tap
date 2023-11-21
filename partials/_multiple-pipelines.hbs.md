You can configure your developer namespace to include more than one pipeline
using either of the following methods:

- Use a single pipeline running on a container image that includes testing
  tools and runs a common script to execute tests. This allows you to
  accommodate multiple workloads based in different languages in the same
  namespace that use a common make test script, as shown in the following
  example:

    ```console
    apiVersion: tekton.dev/v1beta1
    kind: Pipeline
    metadata:
      name: developer-defined-tekton-pipeline
      labels:
        apps.tanzu.vmware.com/pipeline: test
    spec:
      #...
            steps:
              - name: test
                image: <image_that_has_JDK_and_Go>
                script: |-
                  cd `mktemp -d`
                  wget -qO- $(params.source-url) | tar xvz -m
                  make test
    ```

- Update the pipeline resources to include labels that differentiate between
  the pipelines. For example, differentiate between Java and Go pipelines by
  adding labels for Java and Go:

    ```console
    apiVersion: tekton.dev/v1beta1
    kind: Pipeline
    metadata:
      name: java-tests
      labels:
        apps.tanzu.vmware.com/pipeline: test
        apps.tanzu.vmware.com/language: java
    spec:
      #...
            steps:
              - name: test
                image: gradle
                script: |-
                  # ...
                  ./mvnw test
    ---
    apiVersion: tekton.dev/v1beta1
    kind: Pipeline
    metadata:
      name: go-tests
      labels:
        apps.tanzu.vmware.com/pipeline: test
        apps.tanzu.vmware.com/language: go
    spec:
      #...
            steps:
              - name: test
                image: golang
                script: |-
                  # ...
                  go test -v ./...
    ```

To match the correct pipeline, you add a `testing_pipeline_matching_labels`
parameter to the workload. For example, if you want to match to the Java
pipeline, you have the following `workload.yaml`:

```console
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: sample-java-app
  labels:
    apps.tanzu.vmware.com/has-tests: true
    apps.tanzu.vmware.com/workload-type: web
    app.kubernetes.io/part-of: sample-java-app
spec:
  params:
    - name: testing_pipeline_matching_labels
      value:
        apps.tanzu.vmware.com/pipeline: test
        apps.tanzu.vmware.com/language: java
  ...
```

This matches the workload to the pipeline with the `apps.tanzu.vmware.com/language: java` label.
