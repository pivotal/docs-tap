# Tanzu Build Service (TBS) Integration

By default, the Out of the Box supply chains (`ootb-supply-chain-*`) in Tanzu Application Platform
make use of Tanzu Build Service (TBS) for building container images out of
source code.

You can configure a **platform operator** by using
`tap-values`:

1. The default container image registry where application images must be
   pushed:

    ```yaml
    ootb_supply_chain_basic:
      registry:
        server: <>
        repository: <>
    ```

2. The name of the Kpack `ClusterBuilder` used by default:

    ```yaml
    ootb_supply_chain_basic:
      cluster_builder: my-custom-cluster-builder
    ```

You can configure an **application operator** by using `Workload`:

- `spec.build.env` are the environment variables used during the build:

  ```yaml
  kind: Workload
  apiVersion: carto.run/v1alpha1
  metadata:
    name: tanzu-java-web-app
  spec:
    # ...
    build:
      env:
        - name: PORT
          value: "8080"
        - name: CA_CERTIFICATE
          valueFrom:
            secretKeyRef:
              name: secret-in-the-same-namespace-as-workload
              key: crt.pem
  ```


- `spec.params.clusterBuilder` is the name of the ClusterBuilder to use for
builds of that Workload:

  ```yaml
  kind: Workload
  apiVersion: carto.run/v1alpha1
  metadata:
    name: tanzu-java-web-app
  spec:
    # ...
    params:
      - name: clusterBuilder
        value: nodejs-cluster-builder
  ```


- `spec.params.buildServiceBindings` is the object carrying the definition of a list
  of service bindings to use at build time:

  ```yaml
  ---
  kind: Workload
  apiVersion: carto.run/v1alpha1
  metadata:
    name: tanzu-java-web-app
  spec:
    # ...
    params:
      - name: buildServiceBindings
        value:
          - name: settings-xml
            kind: Secret
            apiVersion: v1
  ---
  apiVersion: v1
  kind: Secret
  metadata:
    name: settings-xml
  type: service.binding/maven
  stringData:
    type: maven
    provider: sample
    settings.xml: <settings>...</settings>
  ```

>**Note:** See the Kpack [ServiceBinding documentation](https://github.com/pivotal/kpack/blob/main/docs/servicebindings.md) in GitHub 
for more details about build-time service bindings.

>**Note:** these configuration only take effect when Kpack
is used for building a container image. If you use Dockerfile-based builds
by leveraging the `dockerfile` parameter, see [dockerfile-based
 builds](dockerfile-based-builds.md) for more information.
