Native Image is technology for compiling Java code ahead of time to a binary, which is a native
executable file. For more information about Native Image, see the
[GraalVM documentation](https://www.graalvm.org/latest/reference-manual/native-image/).

Native Image requires some changes to your `workload.yaml` files, such as adding new environment
variables to the build section of the workload specifications:

```yaml
spec:
  build:
    env:
      - name: BP_NATIVE_IMAGE
        value: "true"
      - name: BP_MAVEN_BUILD_ARGUMENTS
        value: -Dmaven.test.skip=true --no-transfer-progress package -Pnative
      - name: BP_JVM_VERSION
        value: 17 ## only JVM 17 and later versions support native images. Depending on your configuration, this might already be the default value.
```

### <a id="java-native-maven"></a> Use native images with Maven

If you are using Maven, you must also add a native profile that includes `native-maven-plugin`
for the build phase in `pom.xml`:

```xml
<profiles>
   	<profile>
        <id>native</id>
        <build>
           <plugins>
              <plugin>
                 <groupId>org.graalvm.buildtools</groupId>
                   <artifactId>native-maven-plugin</artifactId>
                </plugin>
            </plugins>
         </build>
   	</profile>
</profiles>
```

### <a id="java-native-features"></a> Supported Features

There are some differences on supported features when working with Native images:

- You can deploy workloads with native images by running the `Tanzu: Apply Workload` [command](#apply-workload).
- You can delete workloads with native images by running the `Tanzu: Delete Workload` [command](#delete-workload).
- Debug and Live Update are not supported when using native images. However you can add an
  additional `workload.yaml` file that doesn't use a native image to iterate on your development.

This example `workload.yaml` specification has a native image flag:

```yaml
...
spec:
  build:
    env:
      - name: BP_NATIVE_IMAGE
        value: "true"
...
```

This example `workload.yaml` specification doesn't have a native image flag:

```yaml
...
spec:
  build:
    env:
      #- name: BP_NATIVE_IMAGE
      #  value: "true"
...
```

The Tanzu Workloads panel adds the `Native` label to any workloads that contain native images.