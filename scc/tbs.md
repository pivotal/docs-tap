# Tanzu Build Service (TBS) Integration

By default, the Out of the Box supply chains (`ootb-supply-chain-*`) in TAP
make use of Tanzu Build Service (TBS) for building container images out of
source code.

To tweak its behavior, a **platform operator** is able of configuring via
`tap-values`:

1. the default container image registry where application images should be
   pushed to

    ```yaml
    ootb_supply_chain_basic:
      registry:
        server: <>
        repository: <>
    ```

2. name of the Kpack `ClusterBuilder` to use by default

    ```yaml
    ootb_supply_chain_basic:
      cluster_builder: my-custom-cluster-builder
    ```

Similarly, an **application operator** can configure via `Workload`:

- `spec.build.env`: environment variables to be during the build

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


- `spec.params.clusterBuilder`: name of the ClusterBuilder to make use of for
  builds of that Workload

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


- `spec.params.buildServiceBindings`: object carrying the definition of a list
  of service bindings to make use of at build time

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

 > **Note**: see Kpack's [ServiceBinding
 > documentation](https://github.com/pivotal/kpack/blob/main/docs/servicebindings.md)
 > for more details about build-time service bindings.

> **Note**: these configuration will only take effect in the case of Kpack
> being used for building container image. If instead Dockerfile-based builds
> are used (by leveraging the `dockerfile` parameter - see [dockerfile-based
> builds](dockerfile-based-builds.md) for details).
