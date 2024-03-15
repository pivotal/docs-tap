# Migrate to the Java Cloud Native Buildpack

This topic tells you how to migrate your Java app from using a Cloud Foundry buildpack for Tanzu Application Service
(commonly known as TAS for VMs) to using a Cloud Native Buildpack for Tanzu Application Platform (commonly known as TAP).

## <a id="versions"></a> Use a specific Java version

The following table compares how Tanzu Application Service and Tanzu Application Platform handle
installing specific versions.

| Feature (lowest to highest priority)  | Tanzu Application Service                   | Tanzu Application Platform |
| ------------------------------------- | ------------------------------------------- | -------------------------- |
| Buildpack Default                     | 8                                           | 11                         |
| Maven MANIFEST.MF property            | ❌ Not supported                            | ✅                         |
| Detects version from `.sdkmanrc` file | ❌ Not supported                            | ✅                         |
| Override app-based version detection  | Use `cf set-env`: `JBP_CONFIG_OPEN_JDK_JRE` | Use `$BP_JVM_VERSION`      |

### <a id="override-version-tas"></a> Tanzu Application Service: Override version detection

In Tanzu Application Service, changing from the default JVM v8 requires you to configure the following app
environment variable key and value:

```
JBP_CONFIG_OPEN_JDK_JRE '{ jre: { version: 17.+ }}'
```

This builds the app with the version of Java 17 that was bundled with the buildpack,
currently 8, 11, 17, and 21.
<!-- why does it mention Java 17 then 8, 11, 17 & 21? -->

### <a id="override-version-tap"></a> Tanzu Application Platform: Override version detection

In Tanzu Application Platform, set the `$BP_JVM_VERSION` build-time environment variable to specify which version
of the JVM to install.
The value can be the major version of one of the LTS Java releases included in the buildpack,
currently 8, 11, 17, and 21.
Patches for these majors are released quarterly along with OpenJDK release schedules.
For the buildpack’s exact versions, see the [Java Buildpack Release Notes](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-release-notes-tanzu-java-release-notes.html).

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_JVM_VERSION
       value: "17"
```

## <a id="maven"></a> Configure Maven repository settings

The following table compares configuring Maven repository settings in Tanzu Application Service and
Tanzu Application Platform.

| Feature                               | Tanzu Application Service | Tanzu Application Platform                               |
| ------------------------------------- | ------------------------- | -------------------------------------------------------- |
| Connect to a private Maven repository | ❌ Not supported          | ✅ Use a binding of type `maven` with key `settings.xml` |

### <a id="maven-config-secret"></a> Configure Maven repository settings with sensitive data

In Tanzu Application Platform, if your Maven settings contain sensitive data, you can provide your
own `settings.xml` to the build without explicitly including the file in the application directory.

To provide your `settings.xml` without including it in the directory:

1. Create the service binding as a secret. For example:

    ```yaml
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: settings-xml
      namespace: my-apps
    type: service.binding/maven
    stringData:
      type: maven
      settings.xml: |
        <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
          <servers>
            <server>
              <id>myrepo</id>
              <username>admin</username>
              <password>changeme</password>
            </server>
          </servers>

          <mirrors>
            <mirror>
              <id>myrepo</id>
              <name>myrepo</name>
              <url>http://myrepo/</url>
              <mirrorOf>*</mirrorOf>
            </mirror>
          </mirrors>
        </settings>
    ```

1. Apply the binding in the workload by running:

    ```console
    tanzu apps workload apply APP-NAME \
      --param-yaml buildServiceBindings='[{"name": "settings-xml", "kind": "Secret"}]'
    ```

    Where `APP-NAME` is the name of your app.

For more information about service bindings, see
[Configure Tanzu Build Service properties on a workload](../../tanzu-build-service/tbs-workload-config.hbs.md).

## <a id="service-bindings"></a> Service bindings

The following table compares service bindings in Tanzu Application Service and Tanzu Application Platform.

| Feature                           | Tanzu Application Service | Tanzu Application Platform |
| --------------------------------- | ------------------------- | -------------------------- |
| Connect an app to a bound service | ✅                        | ✅                         |

### <a id="service-bindings-tas"></a> Tanzu Application Service: Service bindings

In Tanzu Application Service, the Java Buildpack supplies Spring Boot v3 apps with the Java CF Env Library.
This library parses the `VCAP_SERVICES` variable and allows the auto-configuration for Spring Boot to set
properties and connect to the bound service.

### <a id="service-bindings-tap"></a> Tanzu Application Platform: Service bindings

In Tanzu Application Platform, Tanzu Buildpacks supply a similar library, named Spring Cloud Bindings,
which supports the Kubernetes-style service bindings, and enable it by default.
<!-- what does "it" mean in this sentence" -->
This does the following:

- Adds a PropertySource with a flattened representation, `k8s.bindings.{name}.*`, of the bindings.
- Adds a PropertySource with binding-specific Spring Boot configuration properties.

The auto-configuration for Spring Boot configures application properties appropriate for the type of
binding encountered.

After you have applied a service binding, for example to a PostgreSQL database,
[Spring Cloud Bindings](https://github.com/spring-cloud/spring-cloud-bindings)
automatically uses the properties from the binding to set the relevant Spring Boot properties:

```console
tanzu apps workload apply APP-NAME \
  --service-ref "psql=services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:psql"
```

<!-- when should users run this command? it says that it's automatic. -->

For more information about service bindings, see
[Configure Tanzu Build Service properties on a workload](../../tanzu-build-service/tbs-workload-config.hbs.md).

## <a id="tomcat"></a> Deploy with Tomcat

The following table compares deploying with Tomcat for Tanzu Application Service and Tanzu Application Platform.

| Feature                  | Tanzu Application Service                                         | Tanzu Application Platform |
| ------------------------ | ----------------------------------------------------------------- | -------------------------- |
| Configure Tomcat Version | ❌ Not possible without creating a custom (unsupported) buildpack | ✅ Use `BP_TOMCAT_VERSION` |
| Use External Tomcat      | ✅                                                                | ✅                         |

In Tanzu Application Platform, the Apache Tomcat buildpack includes versions 8, 9, and 10.1.
The detection criteria to deploy with the buildpack-provided Tomcat remains the same as in
Tanzu Application Service, which is the presence of a WEB-INF directory and no Main-Class entry in the manifest.

You can configure an external Tomcat instance by using environment variables.
For more information about configuration options, see the
[Tanzu Java Buildpacks documentation](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-java-java-buildpack.html).

## <a id="java-distribution"></a> Choose Java distribution

The following table compares deploying choosing a Java distribution for Tanzu Application Service and
Tanzu Application Platform.

| Feature                         | Tanzu Application Service                                         | Tanzu Application Platform |
| ------------------------------- | ----------------------------------------------------------------- | -------------------------- |
| Use an alternative JVM provider | ❌ Not possible without creating a custom (unsupported) buildpack | ✅                         |

## <a id="integrations"></a> Compare third-party integrations

The following table compares third-party integrations available for Tanzu Application Service and
Tanzu Application Platform.

| Partner                              | Tanzu Application Service | Tanzu Application Platform |
| ------------------------------------ | ------------------------- | -------------------------- |
| Apache Skywalking                    | ✅                        | ✅                         |
| AppDynamics                          | ✅                        | ✅                         |
| AppInternals (Aternity/Riverbed)     | ✅                        | ✅                         |
| AspectJ                              | ✅                        | ✅                         |
| Azure App Insights                   | ✅                        | ✅                         |
| Checkmarx                            | ✅                        | ✅                         |
| Contrast Security                    | ✅                        | ✅                         |
| Datadog                              | ✅                        | ✅                         |
| Elastic APM                          | ✅                        | ✅                         |
| Dynatrace                            | ✅                        | ✅                         |
| Google Stackdriver                   | ✅                        | ✅                         |
| Introscope (Broadcom)                | ✅                        | ?                          |
| JaCoCo                               | ✅                        | ✅                         |
| Java Memory Assistant                | ✅                        | ✅                         |
| JProfiler                            | ✅                        | ✅                         |
| JRebel                               | ✅                        | ✅                         |
| Luna Sec Provider                    | ✅                        | ✅                         |
| MariaDB Client</br>PostgreSQL Client | ✅                        | ❌ See Notes               |
| Metric Writer                        | ✅                        | ❌ See Notes               |
| New Relic                            | ✅                        | ✅                         |
| OpenTelemetry Agent                  | ✅                        | ✅                         |
| ProtectApp (Thales)                  | ✅                        | ❌                         |
| Sealights                            | ✅                        | ❌                         |
| Seeker Security/Synopsys             | ✅                        | ✅                         |
| Spring Insight                       | ❌ See Notes              | ❌ See Notes               |
| Takipi                               | ✅                        | ✅                         |
| YourKit                              | ✅                        | ✅                         |

<div class="note">
  <span class="note__title">Note</span>
  <p>The following integrations do not have a Tanzu Application Platform equivalent:</p>
  <ul>
    <li><strong>MariaDB and PostgreSQL Client Libraries:</strong> The recommended way to include these
      libraries is as an application dependency rather than supplied by the buildpack.
      Therefore in Tanzu Application Platform, included in the app, for example, using a <code>pom.xml</code> entry.</li>
    <li><strong>Metrics Writer:</strong> This integration library provides Cloud Foundry-specific tags
      for micrometer enabled apps, and so does not have a Tanzu Application Platform equivalent.</li>
    <li><strong>Spring Insight:</strong> This is no longer supported and is no longer available in
      Tanzu Application Service or Tanzu Application Platform.</li>
  </ul>
</div>

Most of the third-party integrations that are supported in Tanzu Application Service are also supported
in Tanzu Application Platform.
The detection criteria to trigger enabling the integration, for example, adding a Java Agent to the JVM,
is as follows:

- **Tanzu Application Service:** Bind a Tanzu Application Service service of the relevant type, or
  set an environment variable.
- **Tanzu Application Platform:** Provide a Tanzu Application Platform binding of the relevant type,
  or setting an environment variable.

### <a id="integrations-tap"></a> Tanzu Application Platform only integrations

The following integrations are only available in Tanzu Application Platform through Cloud Native Buildpacks:

- **Checkmarx:** Contributes the [Checkmarx](https://checkmarx.com/product/application-security-platform/) CxIAST agent.
- **Snyk:** Contributes [Snyk](https://snyk.io/) scanning and configures it to connect to the service.
- **Synopsys:** Contributes [Synopsys](https://www.synopsys.com) scanning and configures it to connect to the service.

## <a id="debug"></a> Configure debugging for your application

The following table compares configuring debugging for your app in Tanzu Application Service and
Tanzu Application Platform.

| Feature                 | Tanzu Application Service | Tanzu Application Platform |
| ----------------------- | ------------------------- | -------------------------- |
| Enable Remote Debugging | ✅ `$JBP_CONFIG_DEBUG`    | ✅ `$BPL_DEBUG_ENABLED`    |

Enabling remote debugging for Java apps in Tanzu Application Platform is similar to Tanzu Application Service.
Specify a runtime environment variable in your `workload.yaml` as follows:

```yaml
spec:
  env:
  - name: BPL_DEBUG_ENABLED
    value: "true"
```

This adds the JVM argument:

```
-agentlib:jdwp=transport=dt_socket,server=y,address=*:8000,suspend=n
```

(Optional) You can specify `BPL_DEBUG_PORT` and `BPL_DEBUG_SUSPEND` to change the defaults for these
options.

## <a id="apm"></a> Enable Application Performance Monitoring (APM) with Datadog

To enable Datadog, you must first install the Datadog Agent on your platform.
After installing Datadog, the environment variable allows the buildpack to contribute the
Datadaog Tracing library to the app classpath.
To install the Datadog agent for Tanzu Application Platform, follow the instructions in
[Use Datadog as your observability tool](../../integrations/external-observability-tools.hbs.md#install-datadog-agent).

> **Note** Your Tanzu Application Platform environment might be restricted to the baseline pod security standard
> For more information about the baseline pod security standard, see the
> [Kubernetes documentation](https://kubernetes.io/docs/concepts/security/pod-security-standards/#baseline).
> In that case, you must remove the restriction before you can install the Datadog Agent DaemonSet.

The following table compares enabling APM in Tanzu Application Service and Tanzu Application Platform.

| Feature        | Tanzu Application Service | Tanzu Application Platform    |
| -------------- | ------------------------- | ----------------------------- |
| Enable Datadog | ✅ `$DD_API_KEY=XXX`      | ✅ `$BP_DATADOG_ENABLED=true` |

### <a id="example"></a> Example Datadog configuration

If you previously deployed the following `workload.yaml` to Tanzu Application Platform:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
 labels:
   app.kubernetes.io/part-of: petclinic
   apps.tanzu.vmware.com/has-tests: "true"
   apps.tanzu.vmware.com/workload-type: web
 name: petclinic
 namespace: apps
spec:
 build:
   env:
   - name: BP_JVM_VERSION
     value: "17"
 params:
 - name: annotations
   value:
     autoscaling.knative.dev/minScale: "1"
 source:
   git:
     ref:
       branch: main
     url: https://github.com/spring-projects/spring-petclinic
```

To enable Datadog, change the `workload.yaml` as follows:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
 labels:
   app.kubernetes.io/part-of: petclinic
   apps.tanzu.vmware.com/has-tests: "true"
   apps.tanzu.vmware.com/workload-type: web
   tags.datadoghq.com/env: "dev"
   tags.datadoghq.com/service: "petclinic"
   tags.datadoghq.com/version: "0.0.1"
 name: petclinic
 namespace: apps
spec:
 build:
   env:
   - name: BP_JVM_VERSION
     value: "17"
   - name: BP_DATADOG_ENABLED
     value: "true"
 env:
   - name: DD_AGENT_HOST
     value: "datadog-agent"
   - name: DD_ENV
     value: "dev"
   - name: DD_SERVICE
     value: "petclinic"
   - name: DD_VERSION
     value: "0.0.1"
 params:
 - name: annotations
   value:
     autoscaling.knative.dev/minScale: "1"
 source:
   git:
     ref:
       branch: main
     url: https://github.com/spring-projects/spring-petclinic
```

## <a id="log-level"></a> Configure the log level for buildpacks

The following table compares configuring the log level in Tanzu Application Service and Tanzu Application Platform.

| Feature              | Tanzu Application Service | Tanzu Application Platform |
| -------------------- | ------------------------- | -------------------------- |
| Enable Debug Logging | ✅ `$JBP_LOG_LEVEL=DEBUG` | ✅ `$BP_LOG_LEVEL=DEBUG`   |

In Tanzu Application Platform, changing the log level to DEBUG is similar to Tanzu Application Service.
Set the environment variable in your `workload.yaml` as follows:

```yaml
spec:
 build:
  env:
  - name: BP_LOG_LEVEL
    value: "DEBUG"
```

This shows debug level output for buildpacks during the build phase.
