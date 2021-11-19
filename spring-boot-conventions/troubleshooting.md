# Troubleshooting

## Collecting logs

To inspect which conventions are being applied follow these steps:   

1. The _Spring Boot Convention Server_ creates a namespace to contain all of the associated resources, by default the namespace is `spring-boot-convention`. Let's inspect the logs using the following command:

```bash
$ kubectl logs -l app=spring-boot-webhook -n spring-boot-convention

{"level":"info","timestamp":"2021-11-11T16:00:26.597Z","caller":"spring-boot-conventions/server.go:83","msg":"Succesfully applied convention: spring-boot","component":"spring-boot-conventions"}
{"level":"info","timestamp":"2021-11-11T16:00:26.597Z","caller":"spring-boot-conventions/server.go:83","msg":"Succesfully applied convention: spring-boot-graceful-shutdown","component":"spring-boot-conventions"}
{"level":"info","timestamp":"2021-11-11T16:00:26.597Z","caller":"spring-boot-conventions/server.go:83","msg":"Succesfully applied convention: spring-boot-web","component":"spring-boot-conventions"}
{"level":"info","timestamp":"2021-11-11T16:00:26.597Z","caller":"spring-boot-conventions/server.go:83","msg":"Succesfully applied convention: spring-boot-actuator","component":"spring-boot-conventions"}
{"level":"info","timestamp":"2021-11-11T16:00:26.597Z","caller":"spring-boot-conventions/server.go:83","msg":"Succesfully applied convention: service-intent-mysql","component":"spring-boot-conventions"}
```

2. For all the conventions that were applied succesfully a log entry will be added, and in case of an error a log entry will be added as well with a description