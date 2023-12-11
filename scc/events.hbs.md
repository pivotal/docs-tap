# Events reference for Supply Chain Choreographer

This topic describes each event you can view with Supply Chain Choreographer.

Events are emitted when Choreographer edits resources or notices a change in
their output or healthy state. Don't treat events like logs, however they can
offer valuable insight into what's happening in a supply chain over time. For
example, very high occurrences of events in a short period of time might be a
sign of slow application-level processing due to many page faults and a lack of storage resources.

Events are published on Workload, Deliverable, and Runnable resources. You can
view them manually using:

```console
kubectl describe workload.carto.run <workload-name> -n <workload-ns>
kubectl describe runnable.carto.run <runnable-name> -n <runnable-ns>
kubectl describe deliverable.carto.run <deliverable-name> -n <deliverable-ns>
```

## Events

The following sections define the different events.

### StampedObjectApplied

This event is emitted every time Choreographer creates or updates a resource. The created or updated resource is
referenced in the event message.

Example messages:

```console
Created object [gitrepositories.source.toolkit.fluxcd.io/my-project]
Updated object [apps.kappctrl.k14s.io/my-project-app]
```

### StampedObjectRemoved

This event is emitted every time Choreographer deletes a resource. This currently
only occurs when Runnable resources expire. The deleted object is referenced in
the event message.

Example message:

```console
Deleted object [task.tekton.dev/my-project-a737bdf]
```

### ResourceOutputChanged

This event is emitted every time Choreographer recognizes a new output from a resource.

Example message:

```console
[source-provider] found a new output in [imagerepositories.source.apps.tanzu.vmware.com/app]
```

### ResourceHealthyStatusChanged

This event is emitted every time Choreographer recognizes that the healthy status of a resource has changed.

Example message:

```console
[image-provider] found healthy status in [images.kpack.io/app] changed to [True]
[source-provider] found healthy status in [[gitrepositories.source.toolkit.fluxcd.io/my-project]] changed to [False]
```
