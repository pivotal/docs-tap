A `portforward` enables you to easily access the application, when iterating locally, in the
Tanzu Workloads panel from a local URL (via the pop-up menu action) or a Knative URL (for the web type
of workloads).

The option to use a `portforward` is only available if containers in your workload have either:

- A `PORT` environment variable
- An entry in the `ports` array that specifies `TCP` as the `protocol`

For example:

```yaml
ports:
- containerPort: 8080
  name: user-port
  protocol: TCP
```

Existing `portforwards` are shown in the Tanzu Workloads panel.