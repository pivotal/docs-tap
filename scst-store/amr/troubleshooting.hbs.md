# Troubleshooting Artifact Metadata Repository (AMR)

This topic tells you how to troubleshoot issues with Artifact Metadata Repository (AMR).

## <a id='debug'></a> Debugging AMR

1. Pause reconciliation of the package
    
    ```bash
    tanzu package installed pause amr-observer -n tap-install
    # OR
    kctrl package installed pause -i amr-observer -n tap-install
    ```

2. Change the zap log level. 
    
    ```bash
    kubectl -n amr-observer-system \
    patch deployment amr-observer-controller-manager \
      --type='json' \
      -p='[{"op": "add", 
            "path": "/spec/template/spec/containers/1/args/-", 
            "value": "--zap-log-level=3"
          }]'
    ```

  Logs now show `LEVEL(-3)` with the example patch above.
  
  ```bash
  $ kubectl -n amr-observer-system logs deployments/amr-observer-controller-manager
  2023-06-20T15:42:39Z	LEVEL(-3)	httpclient.circuitbreaker	AMR CloudEventHandler	{"availability": true, "State": "closed"}
  ```

3. Unpause reconciliation of the package:

```bash
tanzu package installed kick amr-observer -n tap-install
# OR
kctrl package installed kick -i amr-observer -n tap-install
```

## <a id='health-check'></a> Health Check

AMR Observer does not send events to AMR CloudEvent Handler if either the AMRCloudEvent Handler, AMR, or MDS isn’t working.

Sample log in AMR Observer when HealthCheck is working:

```log
2023-06-20T15:51:50Z	INFO	httpclient.circuitbreaker	Received response with status	{"status": "204 No Content"}
2023-06-20T15:51:50Z	INFO	httpclient.circuitbreaker	Successfully sent CloudEvent
```

Sample log in AMR Observer when HealthCheck is failing:

```log
2023-06-20T19:01:58Z	INFO	httpclient.circuitbreaker	Received response with status	{"status": "503 Service Unavailable"}
2023-06-20T19:01:58Z	ERROR	httpclient		{"error": "request failed with status 503"}
gitlab.eng.vmware.com/tanzu-image-signing/amr-observer/internal/cloud/event/client.(*CloudEventClient).logAndReturnError
	/workspace/internal/cloud/event/client/client.go:53
gitlab.eng.vmware.com/tanzu-image-signing/amr-observer/internal/cloud/event/client.(*CloudEventClient).do
	/workspace/internal/cloud/event/client/client.go:102
gitlab.eng.vmware.com/tanzu-image-signing/amr-observer/internal/cloud/event/client.(*CloudEventClient).checkCloudEventHandlerAvailability.func1
	/workspace/internal/cloud/event/client/client.go:123
github.com/sony/gobreaker.(*CircuitBreaker).Execute
	/go/pkg/mod/github.com/sony/gobreaker@v0.5.0/gobreaker.go:242
gitlab.eng.vmware.com/tanzu-image-signing/amr-observer/internal/cloud/event/client.(*CloudEventClient).checkCloudEventHandlerAvailability
	/workspace/internal/cloud/event/client/client.go:117
gitlab.eng.vmware.com/tanzu-image-signing/amr-observer/internal/cloud/event/client.(*CloudEventClient).CheckAvailabilityPeriodically
	/workspace/internal/cloud/event/client/client.go:111
```

Sample log in AMR CloudEvent Handler:

```json
{"level":"error","ts":"2023-06-20T15:15:04.321672436Z","caller":"amr-persister/main.go:99","msg":"AMR is unavailable: Get \"https://artifact-metadata-repository-app.metadata-store.svc.cluster.local:8443/play\": dial tcp 10.28.116.184:8443: connect: connection refused","stacktrace":"<...>"}
```

```json
{"level":"error","ts":"2023-06-20T20:13:15.689628865Z","caller":"amr-persister/main.go:102","msg":"MDS is unavailable: Get \"https://metadata-store-app.metadata-store.svc.cluster.local:8443/api/health\": dial tcp 10.28.122.145:8443: connect: connection refused","stacktrace":"..."}
```
---

Unsupported protocol is used for the `amr.observer.eventhandler.endpoint`.

```log
2023-06-28T18:48:31Z	ERROR	httpclient	error sending request to AMR CloudEvent Handler	{"error": "Get \"amr-persister.example.com/healthz\": unsupported protocol scheme \"\""}

...

2023-06-28T18:48:31Z	ERROR	setup	unable to registry location	{"error": "failed to send, Post \"amr-persister.example.com\": unsupported protocol scheme \"\""}

...

2023-06-28T18:48:31Z	ERROR	httpclient.circuitbreaker	error contacting event handler	{"error": "Get \"amr-persister.example.com/healthz\": unsupported protocol scheme \"\""}
```

To fix this, use the appropriate `https://` or `http://` prepended protocol.

---

If the log contains:

```log
2023/06/28 19:09:06 No certs appended, using system certs only
2023-06-28T19:09:06Z	INFO	controller-runtime.metrics	Metrics server is starting to listen	{"addr": "127.0.0.1:8080"}
2023-06-28T19:09:06Z	INFO	setup	Establishing	{"locationId": "d9fa1ee9-ba42-4262-aaf6-4128f99096b9"}
```

And if the following describe on the pod shows:

```bash
$ kubectl -n amr-observer-system describe pods "<amr-observer-controller-manager-...>"
```

Sample output:

```console
...

Events:
  Type     Reason     Age                    From               Message
  ----     ------     ----                   ----               -------
...

  Warning  Unhealthy  3m35s (x3 over 4m15s)  kubelet            Liveness probe failed: Get "http://192.168.45.78:8081/healthz": context deadline exceeded (Client.Timeout exceeded while awaiting headers)

...

  Warning  Unhealthy  3m5s (x10 over 4m25s)  kubelet            Readiness probe failed: Get "http://192.168.45.78:8081/readyz": context deadline exceeded (Client.Timeout exceeded while awaiting headers)
```

This is a symptom of a wrong protocol for `amr.observer.eventhandler.endpoint`. The fix is to use the appropriate `https://` or `http://` prepended protocol dependent on the TLS configuration.

---

## <a id='observer-logs'></a> AMR Observer Logs

```bash
kubectl -n amr-observer-system logs deployments/amr-observer-controller-manager
```
---

The AMR Observer is not observing `ImageVulnerabilityScan` CRD. 

```log
2023-06-20T15:47:09Z	INFO	ivs.SetupWithManager	Not registering ImageVulnerabilityScans Controller: customresourcedefinitions.apiextensions.k8s.io "imagevulnerabilityscans.app-scanning.apps.tanzu.vmware.com" not found"
```
---

The AMR Observer is observing `ImageVulnerabilityScan` CRD if it is installed.

```log
2023-06-28T17:56:43Z	INFO	Starting Controller	{"controller": "imagevulnerabilityscan", "controllerGroup": "app-scanning.apps.tanzu.vmware.com", "controllerKind": "ImageVulnerabilityScan"}
```
---

When Observer first starts up, it registers a Location to the Metadata Store. See <Configuration (Insert link to observer configuration of location)> for more information on customizing Locations.

```log
2023-06-20T15:47:09Z	INFO	setup	Establishing	{"locationId": "f17f073d-dfec-4624-953e-a133b694ecad"}
sent: type: vmware.tanzu.apps.location.created.v1
	source: f17f073d-dfec-4624-953e-a133b694ecad
	id: 1667244096281455275
Extensions:
map[]
```
---

Information on what CA certificates were added to the Observer's HTTP client.

```log
2023-06-20T15:47:05Z	INFO	setup	No additional certs read from configured path, continuing with system truststore"	{"path": "/truststore/ca.crt"}
```
---

No valid CA certificates were found.

```log
2023/06/28 18:41:04 No certs appended, using system certs only
```
---

When the ReplicaSet is observed to be deleted, it will attempt to send the result to AMR CloudEvent Handler. 
There is a known minor bug that even non workload replicaSets will be sent during create and delete events. The log will show an error, however, it is a no-op because AMR CloudEvent Handler will filter out ReplicaSet CloudEvents without a workload container.

```log
result: 204: sent: type: dev.knative.apiserver.resource.delete
	source: f17f073d-dfec-4624-953e-a133b694ecad
2023-06-20T19:01:23Z	INFO	replicaset.sendCloudEvent	received result	{"ceType": "dev.knative.apiserver.resource.delete", "result": "500: "}
	id: 4565357219078868493
Extensions:
map[kind:ReplicaSet name:artifact-metadata-repository-app-7ff9bc58f namespace:metadata-store]
```

There is partial legacy support for Knative ApiServerSource CloudEvents which the Observer leverages which is why there are CloudEvents formatted similarly to Knative APIServerSource being sent.

## <a id='cloudevent-logs'></a> AMR CloudEvent Handler Logs

```bash
kubectl -n metadata-store logs deployments/amr-persister
```
---

When an event is received, there are log messages for an event being handled:

```json
{"level":"debug","ts":"2023-06-20T15:47:09.203079201Z","caller":"persister/persisteradapter.go:76","msg":"Handle single event"}
{"level":"debug","ts":"2023-06-20T15:47:09.203160964Z","caller":"persister/persisteradapter.go:108","msg":"Handle Event"}
```
---

When the Observer starts up, it will send the Location CloudEvent and the AMR CloudEvent Handler will send the Location information to the Metadata Store. The log messages will contain where the request is sent to, the JSON payload, as well as the response body returned from the Metadata Store:

```json
{"level":"debug","ts":"2023-06-20T15:47:09.203390152Z","caller":"persister/persisteradapter.go:117","msg":"Registry Location Event"}
{"level":"info","ts":"2023-06-20T15:47:09.20349837Z","caller":"persister/persisteradapter.go:279","msg":"Sending request to: https://artifact-metadata-repository-app.metadata-store.svc.cluster.local:8443/api/v1/locations with payload: {\"alias\":\"f17f073d-dfec-4624-953e-a133b694ecad\",\"reference\":\"f17f073d-dfec-4624-953e-a133b694ecad\"}"}
{"level":"info","ts":"2023-06-20T15:47:09.238033374Z","caller":"persister/persisteradapter.go:299","msg":"status: 200, responseBody: {\"alias\":\"f17f073d-dfec-4624-953e-a133b694ecad\",\"reference\":\"f17f073d-dfec-4624-953e-a133b694ecad\",\"labels\":null}\n"}
```
---

When there is an error sending Location to the Metadata Store:

```json
{"level":"debug","ts":"2023-06-20T15:15:04.294883639Z","caller":"persister/persisteradapter.go:117","msg":"Registry Location Event"}
{"level":"info","ts":"2023-06-20T15:15:04.295528237Z","caller":"persister/persisteradapter.go:279","msg":"Sending request to: https://artifact-metadata-repository-app.metadata-store.svc.cluster.local:8443/api/v1/locations with payload: {\"alias\":\"f17f073d-dfec-4624-953e-a133b694ecad\",\"reference\":\"f17f073d-dfec-4624-953e-a133b694ecad\"}"}
{"level":"error","ts":"2023-06-20T15:15:04.304782986Z","caller":"persister/persisteradapter.go:283","msg":"post error: Post \"https://artifact-metadata-repository-app.metadata-store.svc.cluster.local:8443/api/v1/locations\": dial tcp 10.28.116.184:8443: connect: connection refused","stacktrace":"<...>"}
{"level":"error","ts":"2023-06-20T15:15:04.304878714Z","caller":"amr-persister/main.go:72","msg":"Error Handler received error Post \"https://artifact-metadata-repository-app.metadata-store.svc.cluster.local:8443/api/v1/locations\": dial tcp 10.28.116.184:8443: connect: connection refused","stacktrace":"..."}
```
---

When the AMR CloudEvent Handler is up and ready to receive CloudEvents:

```json
{"level":"info","ts":"2023-06-20T15:14:56.308829574Z","caller":"amr-persister/main.go:61","msg":"Start Receiving"}
```
---

When the Artifact Metadata Repository is unavailable:

```json
{"level":"error","ts":"2023-06-20T19:03:47.006718745Z","caller":"amr-persister/main.go:99","msg":"AMR is unavailable: Get \"https://artifact-metadata-repository-app.metadata-store.svc.cluster.local:8443/play\": dial tcp 10.28.116.184:8443: connect: connection refused","stacktrace":"..."}
```
---

When the Metadata Store is unavailable.

```json
{"level":"error","ts":"2023-06-20T20:13:15.689628865Z","caller":"amr-persister/main.go:102","msg":"MDS is unavailable: Get \"https://metadata-store-app.metadata-store.svc.cluster.local:8443/api/health\": dial tcp 10.28.122.145:8443: connect: connection refused","stacktrace":"..."}
```
---

The received ReplicaSet CloudEvent did not contain a "workload" container. Currently we only support ReplicaSets generated during a Workload run and contain a "workload" named container.

```json
{"level":"error","ts":"2023-06-20T20:13:11.60733257Z","caller":"persister/persisteradapter.go:218","msg":"generate application payload error: unable to find workload container","stacktrace":"..."}
```
---

The report already exists. This occurs when the resync period has been reached and the controllers are configured to reconcile the ImageVulnerability custom resource. This error is a non-issue as long as the previous submission of the report was successful.

```json
{"level":"info","ts":"2023-06-21T20:54:32.772037121Z","caller":"mds/handle-event.go:107","msg":"Error posting image report: Validation failed: {\"message\":\"a report with uid 'd1625dd5ad94c2c5f83a8de4c3a3c382e4e4774a77c2e71fcf68a0cd3f953f7b' already exists\"}\n"}
{"level":"error","ts":"2023-06-21T20:54:32.772060231Z","caller":"amr-persister/main.go:72","msg":"Error Handler received error Validation failed: {\"message\":\"a report with uid 'd1625dd5ad94c2c5f83a8de4c3a3c382e4e4774a77c2e71fcf68a0cd3f953f7b' already exists\"}\n","stacktrace":"..."}
```
