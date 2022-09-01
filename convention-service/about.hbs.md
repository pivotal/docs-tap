# Convention Service 

>**Caution:** This component is being deprecated in favor of [Cartographer Conventions](../cartographer-conventions/about.md).

The [Cartographer Conventions](../cartographer-conventions/about.md) component must be installed to add conventions to your Pod.
The v0.7.x version of the convention controller is a passive system that translates the CRDs to the [new group](../cartographer-conventions/reference/pod-intent.md).

There are several out of the box conventions provided with every TAP installation and these include the following three conventions 
+ [AppLiveView](/app-live-view/about-app-live-view.hbs.md)
  ```yaml
  ...
  # webhook configuration
    webhook:
    clientConfig:
      service:
        name: appliveview-webhook
        namespace: app-live-view-conventions
  ```
+ [Developer conventions](/developer-conventions/about.hbs.md)
  ```yaml
  ...
  # webhook configuration
  spec:
    webhook:
      clientConfig:
        service:
          name: webhook
          namespace: developer-conventions
  ```

+ [Spring Boot conventions](/spring-boot-conventions/about.hbs.md)
  ``` yaml
    ...
   # webhook configuration
    spec:
      webhook:
        clientConfig:
          service:
            name: spring-boot-webhook
            namespace: spring-boot-convention
    ```


  ```shell
  $ kubectl get clusterpodconventions

  NAME                     READY   REASON   AGE
  appliveview-sample       True    InSync   1d
  developer-conventions    True    InSync   1d
  spring-boot-convention   True    InSync   1d
  ```