### Start Portforward

Users can portforward to your application directly from the workload panel.

Existing portforwards will be shown in the workload panel.

The option to portforward is only available if:

- containers in your workload has a `PORT` environment variable
- or containers in your workload has an entry in the `ports` array that specifies `TCP` as the `protocol`. ex.

```
ports:
- containerPort: 8080
  name: user-port
  protocol: TCP
```

### Stop Portforward

Users can stop a portforward through the workload panel. The option to stop a portforward is only available if there is an existing portforward.
