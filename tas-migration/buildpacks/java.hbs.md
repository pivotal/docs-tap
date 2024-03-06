# Migrate Java buildpack

<!-- do users do all these sections in order or do they choose the section for their use case -->

## Use a specific Java version

| Feature (lowest to highest priority)                                        | TAS                                           | TAP                     |
| --------------------------------------------------------------------------- | --------------------------------------------- | ----------------------- |
| Buildpack Default                                                           | 8                                             | 11                      |
| Maven MANIFEST.MF property                                                  | ❌ Not supported                              | ✅                      |
| Detects version from `.sdkmanrc` file                                       | ❌ Not supported                              | ✅                      |
| Override app-based version detection (see Using environment variable below) | Using `cf set-env`: `JBP_CONFIG_OPEN_JDK_JRE` | Using `$BP_JVM_VERSION` |

### Using environment variable

In TAS, changing from the default JVM v8 requires the following app environment variable key & value:

```
JBP_CONFIG_OPEN_JDK_JRE '{ jre: { version: 17.+ }}'
```

This will build the app with the version of Java 17 that was bundled with the buildpack,
currently 8, 11, 17 & 21.

In TAP, users can set the `$BP_JVM_VERSION` build-time environment variable to specify which version
of the JVM should be installed.
The value can simply be the major version of one of the LTS Java releases included in the buildpack,
currently also 8, 11, 17 & 21. Patches for these majors are released quarterly along with OpenJDK
release schedules.
See the [Java Buildpack Release Notes](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-release-notes-tanzu-java-release-notes.html)
for the buildpack’s exact versions.

Here’s an excerpt from the spec section of a sample `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_JVM_VERSION
       value: "17"
```

## Maven repository settings

| Feature                               | TAS              | TAP                                                      |
| ------------------------------------- | ---------------- | -------------------------------------------------------- |
| Connect to a private Maven repository | ❌ Not supported | ✅ Using a binding of type maven with key `settings.xml` |

In TAP, if your Maven settings contain sensitive data, you can provide your own `settings.xml` to the
build without explicitly including the file in the application directory.

Create the service binding as a secret like this example:

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

Apply the binding in the workload like this example:

```console
tanzu apps workload apply APP-NAME --param-yaml buildServiceBindings='[{"name": "settings-xml", "kind": "Secret"}]'
```

For more details about service bindings, please see TAP documentation https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/tanzu-build-service-tbs-workload-config.html

## Service Bindings

| Feature                           | TAS | TAP |
| --------------------------------- | --- | --- |
| Connect an app to a bound service | ✅  | ✅  |

In TAS, the Java Buildpack will supply Spring Boot 3 apps with the Java CF Env Library.
This library parses the `VCAP_SERVICES` variable and allows Spring Boot’s autoconfiguration to set
properties and connect to the bound service.

In TAP, Tanzu Buildpacks will supply a similar library, Spring Cloud Bindings, which instead supports
the Kubernetes-style service bindings, and enable it by default. This does the following:

- Adds a PropertySource with a flattened representation (`k8s.bindings.{name}.*`) of the bindings.
- Adds a PropertySource with binding-specific Spring Boot configuration properties.

Spring Boot’s autoconfiguration will configure application configuration properties appropriate for
the type of binding encountered.

Once you have applied a ServiceBinding, for example to a PostGres database, [Spring Cloud Bindings](https://github.com/spring-cloud/spring-cloud-bindings)
should automatically use the properties from the binding to set the relevant Spring Boot properties:

```console
tanzu apps workload apply app-name --service-ref "psql=services.apps.tanzu.vmware.com/v1alpha1:ClassClaim:psql"
```

For more details about service bindings, see TAP documentation https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.7/tap/tanzu-build-service-tbs-workload-config.html

## Deploy With Tomcat

| Feature                  | TAS                                                               | TAP                        |
| ------------------------ | ----------------------------------------------------------------- | -------------------------- |
| Configure Tomcat Version | ❌ Not possible without creating a custom (unsupported) buildpack | ✅ Use `BP_TOMCAT_VERSION` |
| Use External Tomcat      | ✅                                                                | ✅                         |

In TAP, the Apache Tomcat buildpack includes versions 8, 9 & 10.1. The detection criteria to deploy
with the buildpack-provided Tomcat remains the same as in TAS - the presence of a WEB-INF directory
and no Main-Class entry in the Manifest.

Configuring an external Tomcat instance for use is supported by environment variables as in TAS.
More details on configuration options can be found in the
[Tanzu Java Buildpacks documentation](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-java-java-buildpack.html).

## Choose Java distribution

| Feature                         | TAS                                                               | TAP |
| ------------------------------- | ----------------------------------------------------------------- | --- |
| Use an alternative JVM provider | ❌ Not possible without creating a custom (unsupported) buildpack | ✅  |

## Third Party Integrations

| Partner                              | TAS | TAP        |
| ------------------------------------ | --- | ---------- |
| Apache Skywalking                    | ✅  | ✅         |
| AppDynamics                          | ✅  | ✅         |
| AppInternals (Aternity/Riverbed)     | ✅  | ✅         |
| AspectJ                              | ✅  | ✅         |
| Azure App Insights                   | ✅  | ✅         |
| Checkmarx                            | ✅  | ✅         |
| Contrast Security                    | ✅  | ✅         |
| Datadog                              | ✅  | ✅         |
| Elastic APM                          | ✅  | ✅         |
| Dynatrace                            | ✅  | ✅         |
| Google Stackdriver                   | ✅  | ✅         |
| Introscope (Broadcom)                | ✅  | ?          |
| JaCoCo                               | ✅  | ✅         |
| Java Memory Assistant                | ✅  | ✅         |
| JProfiler                            | ✅  | ✅         |
| JRebel                               | ✅  | ✅         |
| Luna Sec Provider                    | ✅  | ✅         |
| MariaDB Client</br>PostgreSQL Client | ✅  | *See Notes |
| Metric Writer                        | ✅  | *See Notes |
| New Relic                            | ✅  | ✅         |
| OpenTelemetry Agent                  | ✅  | ✅         |
| ProtectApp (Thales)                  | ✅  | ❌         |
| Sealights                            | ✅  | ❌         |
| Seeker Security/Synopsys             | ✅  | ✅         |
| Spring Insight                       | ❌* | *See Notes |
| Takipi                               | ✅  | ✅         |
| YourKit                              | ✅  | ✅         |

Most of the third-party integrations that are supported in TAS are also supported in TAP.
The detection criteria to trigger enabling the integration (for example, adding a Java Agent to the JVM)
is as follows:

- In TAS - binding a TAS service of the relevant type, and/or setting an environment variable
- In TAP - providing a TAP binding of the relevant type, and/or setting an environment variable

Notes:

The following integrations do not have a TAP equivalent:

- Metrics Writer - this integration library provides CloudFoundry-specific tags for micrometer enabled apps, and so does not have a TAP equivalent.
- MariaDB/Postgres Client Libraries - the recommended way to include these libraries is as an application dependency rather than supplied by the buildpack. Therefore in TAP, these should be included by the app, e.g. via pom.xml entry.
- Spring Insight - this is no longer supported and is no longer available in TAS

### TAP Only Integrations

The following integrations are only available in TAP via Cloud Native Buildpacks:

- Checkmarx - contributes the [Checkmarx](https://checkmarx.com/product/application-security-platform/) CxIAST agent
- Snyk - contributes [Snyk](https://snyk.io/) scanning and configures it to connect to the service
- Synopsys - contributes [Synopsys](https://www.synopsys.com) scanning and configures it to connect to the service.

## Debug your application

| Feature                 | TAS                    | TAP                     |
| ----------------------- | ---------------------- | ----------------------- |
| Enable Remote Debugging | ✅ `$JBP_CONFIG_DEBUG` | ✅ `$BPL_DEBUG_ENABLED` |

Enabling remote debugging for Java apps in TAP is similar to in TAS, simply specify a runtime
environment variable as follows:

```yaml
spec:
  env:
  - name: BPL_DEBUG_ENABLED
    value: "true"
```

This will add the JVM argument:

```
-agentlib:jdwp=transport=dt_socket,server=y,address=*:8000,suspend=n
```

You can optionally specify `BPL_DEBUG_PORT` & `BPL_DEBUG_SUSPEND` to change the defaults for these
options as in TAS.

## APM with Datadog

Either using TAS or TAP, triggering the buildpack with an environment variable is not enough.
It will allow the buildpack to contribute the Datadaog Tracing library to the app classpath, but you also need to install the Datadog Agent on your platform.
For TAP, you can follow [the instructions](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.8/tap/integrations-external-observability-tools.html#use-datadog-as-your-observability-tool-2)
to install the Datadog agent.

>**Note** It’s possible your TAP environment is restricted to the
>[baseline pod security standard](https://kubernetes.io/docs/concepts/security/pod-security-standards/#baseline),
>in that case you’ll need to lift such restrictions to install the Datadog Agent DaemonSet.

| Feature        | TAS                  | TAP                           |
| -------------- | -------------------- | ----------------------------- |
| Enable Datadog | ✅ `$DD_API_KEY=XXX` | ✅ `$BP_DATADOG_ENABLED=true` |

Supposing you previously deployed this workload to TAP:

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

To enable Datadog with this workload, you’ll need to change it this way:

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

## Buildpack Log Level

| Feature              | TAS                       | TAP                      |
| -------------------- | ------------------------- | ------------------------ |
| Enable Debug Logging | ✅ `$JBP_LOG_LEVEL=DEBUG` | ✅ `$BP_LOG_LEVEL=DEBUG` |

In TAP, changing the log level to DEBUG is similar to in TAS. You can set the following environment variable:

```yaml
spec:
 build:
  env:
  - name: BP_LOG_LEVEL
    value: "DEBUG"
```

This will show debug level output for buildpacks during the build phase.
