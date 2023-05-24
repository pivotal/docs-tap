# Troubleshoot Spring Boot conventions

This topic tells you how to troubleshoot Spring Boot conventions.

## <a id="collect-logs"></a>Collect logs

If you have trouble, you can retrieve and examine logs from the Spring Boot convention server as follows:

1. The Spring Boot convention server creates a namespace to contain all of the associated resources.
   By default the namespace is `spring-boot-convention`. To inspect the logs, run:

   ```console
   kubectl logs -l app=spring-boot-webhook -n spring-boot-convention
   ```

   For example:

   ```console
   $ kubectl logs -l app=spring-boot-webhook -n spring-boot-convention

   {"level":"info","timestamp":"2021-11-11T16:00:26.597Z","caller":"spring-boot-conventions/server.go:83","msg":"Successfully applied convention: spring-boot","component":"spring-boot-conventions"}
   {"level":"info","timestamp":"2021-11-11T16:00:26.597Z","caller":"spring-boot-conventions/server.go:83","msg":"Successfully applied convention: spring-boot-graceful-shutdown","component":"spring-boot-conventions"}
   {"level":"info","timestamp":"2021-11-11T16:00:26.597Z","caller":"spring-boot-conventions/server.go:83","msg":"Successfully applied convention: spring-boot-web","component":"spring-boot-conventions"}
   {"level":"info","timestamp":"2021-11-11T16:00:26.597Z","caller":"spring-boot-conventions/server.go:83","msg":"Successfully applied convention: spring-boot-actuator","component":"spring-boot-conventions"}
   {"level":"info","timestamp":"2021-11-11T16:00:26.597Z","caller":"spring-boot-conventions/server.go:83","msg":"Successfully applied convention: service-intent-mysql","component":"spring-boot-conventions"}
   ```

2. For all of the conventions that were applied successfully, a log entry is added.
   If an error occurs, a log entry is added with a description.
