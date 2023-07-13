# tanzu apps workload tail

This topic tells you about the `tanzu apps workload tail` command.

The `tanzu apps workload tail` checks the runtime logs of a workload.

## Default view

Without timestamp set, `tanzu apps workload tail` shows the stage where it is and the related log.

```bash
+ spring-pet-clinic-build-1-build-pod › prepare
+ spring-pet-clinic-build-1-build-pod › detect
+ spring-pet-clinic-build-1-build-pod › analyze
+ spring-pet-clinic-build-1-build-pod › build
+ spring-pet-clinic-build-1-build-pod › restore
spring-pet-clinic-build-1-build-pod[detect] ======== Output: tanzu-buildpacks/poetry@0.1.0 ========
spring-pet-clinic-build-1-build-pod[detect] pyproject.toml must include [tool.poetry.dependencies.python], see https://python-poetry.org/docs/pyproject/#dependencies-and-dev-dependencies
spring-pet-clinic-build-1-build-pod[analyze] Restoring data for sbom from previous image
spring-pet-clinic-build-1-build-pod[detect] err:  tanzu-buildpacks/poetry@0.1.0 (1)
spring-pet-clinic-build-1-build-pod[detect] ======== Output: tanzu-buildpacks/poetry@0.1.0 ========
spring-pet-clinic-build-1-build-pod[detect] pyproject.toml must include [tool.poetry.dependencies.python], see https://python-poetry.org/docs/pyproject/#dependencies-and-dev-dependencies
spring-pet-clinic-build-1-build-pod[detect] err:  tanzu-buildpacks/poetry@0.1.0 (1)
spring-pet-clinic-build-1-build-pod[detect] 10 of 38 buildpacks participating
spring-pet-clinic-build-1-build-pod[detect] paketo-buildpacks/ca-certificates   3.1.0
spring-pet-clinic-build-1-build-pod[detect] paketo-buildpacks/bellsoft-liberica 9.2.0
spring-pet-clinic-build-1-build-pod[detect] paketo-buildpacks/syft              1.10.0
spring-pet-clinic-build-1-build-pod[detect] paketo-buildpacks/gradle            6.4.1
spring-pet-clinic-build-1-build-pod[detect] paketo-buildpacks/maven             6.4.0
spring-pet-clinic-build-1-build-pod[detect] paketo-buildpacks/executable-jar    6.1.0
spring-pet-clinic-build-1-build-pod[detect] paketo-buildpacks/apache-tomcat     7.2.0
spring-pet-clinic-build-1-build-pod[detect] paketo-buildpacks/dist-zip          5.2.0
spring-pet-clinic-build-1-build-pod[detect] paketo-buildpacks/spring-boot       5.8.0
spring-pet-clinic-build-1-build-pod[detect] paketo-buildpacks/image-labels      4.1.0
...
...
...
```

## tanzu apps workload tail flags

This section describes the `tanzu apps workload tail` flags.

### <a id="tail-component"></a> `--component`

Set the component from which the tail command should stream the logs. The values that the flag can
take depend on the final deployed pods label `app.kubernetes.io/component`, for example, `build`,
`run` and, `config-writer`

```console
tanzu apps workload tail pet-clinic --component build

pet-clinic-build-1-build-pod[export] Adding label 'io.buildpacks.project.metadata'
pet-clinic-build-1-build-pod[export] Adding label 'org.opencontainers.image.title'
pet-clinic-build-1-build-pod[export] Adding label 'org.opencontainers.image.version'
pet-clinic-build-1-build-pod[export] Adding label 'org.springframework.boot.version'
pet-clinic-build-1-build-pod[export] Adding label 'org.opencontainers.image.source'
pet-clinic-build-1-build-pod[export] Setting default process type 'web'
pet-clinic-build-1-build-pod[export] Saving gcr.io/dalfonso-tanzu-dev-frmwrk/pet-clinic-default...
pet-clinic-build-1-build-pod[export] *** Images (sha256:2ae6154c4433d870a330a0c2fc825340c3ead2603e3d1526e47c47cb6297fffe):
pet-clinic-build-1-build-pod[export]       gcr.io/dalfonso-tanzu-dev-frmwrk/pet-clinic-default
pet-clinic-build-1-build-pod[export]       gcr.io/dalfonso-tanzu-dev-frmwrk/pet-clinic-default:b1.20220603.181107
pet-clinic-build-1-build-pod[export] Adding cache layer 'paketo-buildpacks/bellsoft-liberica:jdk'
pet-clinic-build-1-build-pod[export] Adding cache layer 'paketo-buildpacks/syft:syft'
pet-clinic-build-1-build-pod[export] Adding cache layer 'paketo-buildpacks/maven:application'
pet-clinic-build-1-build-pod[export] Adding cache layer 'paketo-buildpacks/maven:cache'
pet-clinic-build-1-build-pod[export] Adding cache layer 'cache.sbom'
```

### <a id="tail-namespace"></a> `--namespace`, `-n`

Specifies the namespace where the workload was deployed to get logs from.

```console
tanzu apps workload tail pet-clinic -n development

pet-clinic-00004-deployment-6445565f7b-ts8l5[workload] 2022-06-14 16:28:52.684  INFO 1 --- [           main] org.apache.catalina.core.StandardEngine  : Starting Servlet engine: [Apache Tomcat/9.0.63]
+ pet-clinic-build-3-build-pod › export
pet-clinic-00004-deployment-6445565f7b-ts8l5[workload] 2022-06-14 16:28:52.699  INFO 1 --- [           main] o.a.c.c.C.[Tomcat-1].[localhost].[/]     : Initializing Spring embedded WebApplicationContext
pet-clinic-00004-deployment-6445565f7b-ts8l5[workload] 2022-06-14 16:28:52.699  INFO 1 --- [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 131 ms
pet-clinic-00004-deployment-6445565f7b-ts8l5[workload] 2022-06-14 16:28:52.755  INFO 1 --- [           main] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 13 endpoint(s) beneath base path '/actuator'
pet-clinic-00004-deployment-6445565f7b-ts8l5[workload] 2022-06-14 16:28:53.059  INFO 1 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8081 (http) with context path ''
pet-clinic-00004-deployment-6445565f7b-ts8l5[workload] 2022-06-14 16:28:53.074  INFO 1 --- [           main] o.s.s.petclinic.PetClinicApplication     : Started PetClinicApplication in 8.373 seconds (JVM running for 8.993)
pet-clinic-00004-deployment-6445565f7b-ts8l5[workload] 2022-06-14 16:28:53.229  INFO 1 --- [nio-8081-exec-1] o.a.c.c.C.[Tomcat-1].[localhost].[/]     : Initializing Spring DispatcherServlet 'dispatcherServlet'
pet-clinic-00004-deployment-6445565f7b-ts8l5[workload] 2022-06-14 16:28:53.229  INFO 1 --- [nio-8081-exec-1] o.s.web.servlet.DispatcherServlet        : Initializing Servlet 'dispatcherServlet'
pet-clinic-00004-deployment-6445565f7b-ts8l5[workload] 2022-06-14 16:28:53.231  INFO 1 --- [nio-8081-exec-1] o.s.web.servlet.DispatcherServlet        : Completed initialization in 2 ms
```

### <a id="tail-since"></a> `--since`

Sets the time duration to start reading logs from.

Set the unit value in seconds `s`, minutes `m` or
hours `h` in the format `0h0m0s`. You do not need to indicate a `0` duration for a unit
that is not being set. For example, 1 hour, 0 minutes and 1 seconds should be expressed as
`1h1s`.

The default value is 1 second `1s`

```console
tanzu apps workload tail pet-clinic --since 1h1s

pet-clinic-config-writer-9fbk6-pod[place-tools] 2022/06/14 16:28:04 Copied /ko-app/entrypoint to /tekton/bin/entrypoint
pet-clinic-config-writer-9fbk6-pod[place-scripts] 2022/06/14 16:28:06 Decoded script /tekton/scripts/script-0-dz84w
pet-clinic-config-writer-9fbk6-pod[step-init] 2022/06/14 16:28:05 Setup /step directories
pet-clinic-config-writer-9fbk6-pod[step-main] ++ mktemp -d
pet-clinic-config-writer-9fbk6-pod[step-main] + cd /tmp/tmp.n4ObHYVxpl
pet-clinic-config-writer-9fbk6-pod[step-main] + echo -e eyJkZWxpdmVyeS55bWwiOiJhcGlWZXJzaW9uOiBzZXJ2aW5nLmtuYXRpdmUuZGV2L3YxXG5raW5kOiBTZXJ2aWNlXG5tZXRhZGF0YTpcbiAgbmFtZTogcGV0LWNsaW5pY1xuICBsYWJlbHM6XG4gICAgYXBwcy50YW56dS52bXdhcmUuY29tL3dvcmtsb2FkLXR5cGU6IHdlYlxuICAgIGF1dG9zY2FsaW5nLmtuYXRpdmUuZGV2L21pbi1zY2FsZTogXCIxXCJcbiAgICBhcHAua3ViZXJuZXRlcy5pby9jb21wb25lbnQ6IHJ1blxuICAgIGNhcnRvLnJ1bi93b3JrbG9hZC1uYW1lOiBwZXQtY2xpbmljXG5zcGVjOlxuICB0ZW1wbGF0ZTpcbiAgICBtZXRhZGF0YTpcbiAgICAgIGFubm90YXRpb25zOlxuICAgICAgICBib290LnNwcmluZy5pby9hY3R1YXRvcjogaHR0cDovLzo4MDgxL2FjdHVhdG9yXG4gICAgICAgIGJvb3Quc3ByaW5nLmlvL3ZlcnNpb246IDIuNi44XG4gICAgICAgIGNvbnZlbnRpb25zLmFwcHMudGFuenUudm13YXJlLmNvbS9hcHBsaWVkLWNvbnZlbnRpb25zOiB8LVxuICAgICAgICAgIHNwcmluZy1ib290LWNvbnZlbnRpb24vc3ByaW5nLWJvb3RcbiAgICAgICAgICBzcHJpbmctYm9vdC1jb252ZW50aW9uL3NwcmluZy1ib290LWdyYWNlZnVsLXNodXRkb3duXG4gICAgICAgICAgc3ByaW5nLWJvb3QtY29udmVudGlvbi9zcHJpbmctYm9vdC13ZWJcbiAgICAgICAgICBzcHJpbmctYm9vdC1jb252ZW50aW9uL3NwcmluZy1ib290LWFjdHVhdG9yXG4gICAgICAgICAgc3ByaW5nLWJvb3QtY29udmVudGlvbi9zcHJpbmctYm9vdC1hY3R1YXRvci1wcm9iZXNcbiAgICAgICAgICBzcHJpbmctYm9vdC1jb252ZW50aW9uL3NlcnZpY2UtaW50ZW50LW15c3FsXG4gICAgICAgICAgc3ByaW5nLWJvb3QtY29udmVudGlvbi9zZXJ2aWNlLWludGVudC1wb3N0Z3Jlc1xuICAgICAgICAgIGFwcGxpdmV2aWV3LXNhbXBsZS9hcHAtbGl2ZS12aWV3LWNvbm5lY3RvclxuICAgICAgICAgIGFwcGxpdmV2aWV3LXNhbXBsZS9hcHAtbGl2ZS12aWV3LWFwcGZsYXZvdXJzXG4gICAgICAgICAgYXBwbGl2ZXZpZXctc2FtcGxlL2FwcC1saXZlLXZpZXctc3lzdGVtcHJvcGVydGllc1xuICAgICAgICBkZXZlbG9wZXIuY29udmVudGlvbnMvdGFyZ2V0LWNvbnRhaW5lcnM6IHdvcmtsb2FkXG4gICAgICAgIHNlcnZpY2VzLmNvbnZlbnRpb25zLmFwcHMudGFuenUudm13YXJlLmNvbS9teXNxbDogbXlzcWwtY29ubmVjdG9yLWphdmEvOC4wLjI5XG4gICAgICAgIHNlcnZpY2VzLmNvbnZlbnRpb25zLmFwcHMudGFuenUudm13YXJlLmNvbS9wb3N0Z3JlczogcG9zdGdyZXNxbC80Mi4zLjVcbiAgICAgIGxhYmVsczpcbiAgICAgICAgYXBwLmt1YmVybmV0ZXMuaW8vY29tcG9uZW50OiBydW5cbiAgICAgICAgYXBwcy50YW56dS52bXdhcmUuY29tL3dvcmtsb2FkLXR5cGU6IHdlYlxuICAgICAgICBjYXJ0by5ydW4vd29ya2xvYWQtbmFtZTogcGV0LWNsaW5pY1xuICAgICAgICBjb252ZW50aW9ucy5hcHBzLnRhbnp1LnZtd2FyZS5jb20vZnJhbWV3b3JrOiBzcHJpbmctYm9vdFxuICAgICAgICBzZXJ2aWNlcy5jb252ZW50aW9ucy5hcHBzLnRhbnp1LnZtd2FyZS5jb20vbXlzcWw6IHdvcmtsb2FkXG4gICAgICAgIHNlcnZpY2VzLmNvbnZlbnRpb25zLmFwcHMudGFuenUudm13YXJlLmNvbS9wb3N0Z3Jlczogd29ya2xvYWRcbiAgICAgICAgdGFuenUuYXBwLmxpdmUudmlldzogXCJ0cnVlXCJcbiAgICAgICAgdGFuenUuYXBwLmxpdmUudmlldy5hcHBsaWNhdGlvbi5hY3R1YXRvci5wb3J0OiBcIjgwODFcIlxuICAgICAgICB0YW56dS5hcHAubGl2ZS52aWV3LmFwcGxpY2F0aW9uLmZsYXZvdXJzOiBzcHJpbmctYm9vdFxuICAgICAgICB0YW56dS5hcHAubGl2ZS52aWV3LmFwcGxpY2F0aW9uLm5hbWU6IHBldGNsaW5pY1xuICAgIHNwZWM6XG4gICAgICBjb250YWluZXJzOlxuICAgICAgLSBlbnY6XG4gICAgICAgIC0gbmFtZTogSkFWQV9UT09MX09QVElPTlNcbiAgICAgICAgICB2YWx1ZTogLURtYW5hZ2VtZW50LmVuZHBvaW50LmhlYWx0aC5wcm9iZXMuYWRkLWFkZGl0aW9uYWwtcGF0aHM9XCJ0cnVlXCIgLURtYW5hZ2VtZW50LmVuZHBvaW50LmhlYWx0aC5zaG93LWRldGFpbHM9YWx3YXlzIC1EbWFuYWdlbWVudC5lbmRwb2ludHMud2ViLmJhc2UtcGF0aD1cIi9hY3R1YXRvclwiIC1EbWFuYWdlbWVudC5lbmRwb2ludHMud2ViLmV4cG9zdXJlLmluY2x1ZGU9KiAtRG1hbmFnZW1lbnQuaGVhbHRoLnByb2Jlcy5lbmFibGVkPVwidHJ1ZVwiIC1EbWFuYWdlbWVudC5zZXJ2ZXIucG9ydD1cIjgwODFcIiAtRHNlcnZlci5wb3J0PVwiODA4MFwiIC1Ec2VydmVyLnNodXRkb3duLmdyYWNlLXBlcmlvZD1cIjI0c1wiXG4gICAgICAgIGltYWdlOiBnY3IuaW8vZGFsZm9uc28tdGFuenUtZGV2LWZybXdyay9wZXQtY2xpbmljLWRlZmF1bHRAc2hhMjU2OjM5NjRiNTQwNTVlZjNkNmFiNWQ3YTM5MmVjOGU3OWJhOTg2NjczODU2NmIyOGE2OGY4ZDM2YWY5YjkyMGJhODNcbiAgICAgICAgbGl2ZW5lc3NQcm9iZTpcbiAgICAgICAgICBodHRwR2V0OlxuICAgICAgICAgICAgcGF0aDogL2xpdmV6XG4gICAgICAgICAgICBwb3J0OiA4MDgwXG4gICAgICAgICAgICBzY2hlbWU6IEhUVFBcbiAgICAgICAgbmFtZTogd29ya2xvYWRcbiAgICAgICAgcG9ydHM6XG4gICAgICAgIC0gY29udGFpbmVyUG9ydDogODA4MFxuICAgICAgICAgIHByb3RvY29sOiBUQ1BcbiAgICAgICAgcmVhZGluZXNzUHJvYmU6XG4gICAgICAgICAgaHR0cEdldDpcbiAgICAgICAgICAgIHBhdGg6IC9yZWFkeXpcbiAgICAgICAgICAgIHBvcnQ6IDgwODBcbiAgICAgICAgICAgIHNjaGVtZTogSFRUUFxuICAgICAgICByZXNvdXJjZXM6IHt9XG4gICAgICAgIHNlY3VyaXR5Q29udGV4dDpcbiAgICAgICAgICBydW5Bc1VzZXI6IDEwMDBcbiAgICAgIHNlcnZpY2VBY2NvdW50TmFtZTogZGVmYXVsdFxuIn0=
pet-clinic-config-writer-9fbk6-pod[step-main] + base64 --decode
pet-clinic-config-writer-9fbk6-pod[step-main] ++ cat files.json
+ pet-clinic-config-writer-kpmc6-pod › place-tools
pet-clinic-config-writer-9fbk6-pod[step-main] ++ jq -r 'to_entries | .[] | @sh "mkdir -p $(dirname \(.key)) && echo \(.value) > \(.key)"'
+ pet-clinic-config-writer-kpmc6-pod › step-main
+ pet-clinic-config-writer-kpmc6-pod › step-init
+ pet-clinic-config-writer-kpmc6-pod › place-scripts
pet-clinic-config-writer-9fbk6-pod[step-main] + eval 'mkdir -p $(dirname '\''delivery.yml'\'') && echo '\''apiVersion: serving.knative.dev/v1'
pet-clinic-config-writer-9fbk6-pod[step-main] kind: Service
pet-clinic-config-writer-9fbk6-pod[step-main] metadata:
pet-clinic-config-writer-9fbk6-pod[step-main]   name: pet-clinic
pet-clinic-config-writer-9fbk6-pod[step-main]   labels:
pet-clinic-config-writer-9fbk6-pod[step-main]     apps.tanzu.vmware.com/workload-type: web
pet-clinic-config-writer-9fbk6-pod[step-main]     autoscaling.knative.dev/min-scale: "1"
pet-clinic-config-writer-9fbk6-pod[step-main]     app.kubernetes.io/component: run
pet-clinic-config-writer-9fbk6-pod[step-main]     carto.run/workload-name: pet-clinic
```

### <a id="tail-timestamp"></a> `--timestamp`, `-t`

Adds the timestamp to the beginning of each log message

```console
tanzu apps workload tail pet-clinic -t

pet-clinic-00002-deployment-5cc69cfdc8-t45sc[workload] 2022-06-09T18:10:07.645910625-05:00
pet-clinic-00002-deployment-5cc69cfdc8-t45sc[workload] 2022-06-09T18:10:07.645942876-05:00
pet-clinic-00002-deployment-5cc69cfdc8-t45sc[workload] 2022-06-09T18:10:07.645951930-05:00               |\      _,,,--,,_
pet-clinic-00002-deployment-5cc69cfdc8-t45sc[workload] 2022-06-09T18:10:07.645957151-05:00              /,`.-'`'   ._  \-;;,_
pet-clinic-00002-deployment-5cc69cfdc8-t45sc[workload] 2022-06-09T18:10:07.645961411-05:00   _______ __|,4-  ) )_   .;.(__`'-'__     ___ __    _ ___ _______
pet-clinic-00002-deployment-5cc69cfdc8-t45sc[workload] 2022-06-09T18:10:07.645967316-05:00  |       | '---''(_/._)-'(_\_)   |   |   |   |  |  | |   |       |
pet-clinic-00002-deployment-5cc69cfdc8-t45sc[workload] 2022-06-09T18:10:07.645971010-05:00  |    _  |    ___|_     _|       |   |   |   |   |_| |   |       | __ _ _
pet-clinic-00002-deployment-5cc69cfdc8-t45sc[workload] 2022-06-09T18:10:07.645976591-05:00  |   |_| |   |___  |   | |       |   |   |   |       |   |       | \ \ \ \
pet-clinic-00002-deployment-5cc69cfdc8-t45sc[workload] 2022-06-09T18:10:07.645986474-05:00  |    ___|    ___| |   | |      _|   |___|   |  _    |   |      _|  \ \ \ \
pet-clinic-00002-deployment-5cc69cfdc8-t45sc[workload] 2022-06-09T18:10:07.645990521-05:00  |   |   |   |___  |   | |     |_|       |   | | |   |   |     |_    ) ) ) )
pet-clinic-00002-deployment-5cc69cfdc8-t45sc[workload] 2022-06-09T18:10:07.645994112-05:00  |___|   |_______| |___| |_______|_______|___|_|  |__|___|_______|  / / / /
pet-clinic-00002-deployment-5cc69cfdc8-t45sc[workload] 2022-06-09T18:10:07.645998053-05:00  ==================================================================/_/_/_/
pet-clinic-00002-deployment-5cc69cfdc8-t45sc[workload] 2022-06-09T18:10:07.646001577-05:00
pet-clinic-00002-deployment-5cc69cfdc8-t45sc[workload] 2022-06-09T18:10:07.646005296-05:00 :: Built with Spring Boot :: 2.6.8
```
