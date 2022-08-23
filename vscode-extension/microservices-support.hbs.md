# Microservices Support

In order to support microservice projects, we leverage VS Code's [multi-root workspace capability](https://code.visualstudio.com/docs/editor/multi-root-workspaces).

Add each Tanzu Project (ie. the directory containing the Tiltfile) as a workspace project. See these [instructions](https://code.visualstudio.com/docs/editor/multi-root-workspaces#_adding-folders) for adding new workspace folders.

## Debug

For multiple debug sessions, update the `tanzu.debugPort` setting so that it does not conflict with other debug sessions. See these [instructions](https://code.visualstudio.com/docs/editor/multi-root-workspaces#_settings) on updating individual workspace folder settings.


## Live Update

For multiple Live Update sessions, ensure that a port is available to port-forward the knative service.

For example, you might have this in your Tiltfile:

```
k8s_resource('tanzu-java-web-app', port_forwards=["8080:8080"],
            extra_pod_selectors=[{'serving.knative.dev/service': 'tanzu-java-web-app'}])
```

Update the first port in `port_forwards=["8080:8080"]` (eg. `port_forwards=["9999:8080"]`)