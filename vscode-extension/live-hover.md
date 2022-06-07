# Live Hover integration with Spring Boot Tools (Experimental)

This topic describes Live Hover integration with Spring Boot Tools.


## <a id="prerequisites"></a> Prerequisites

To integrate Live Hover with Spring Boot Tools you need:

- A Tanzu Spring Boot application, such as [tanzu-java-web-app](https://github.com/sample-accelerators/tanzu-java-web-app)
- Spring Boot Tools [extension](https://marketplace.visualstudio.com/items?itemName=Pivotal.vscode-spring-boot) v1.33 or later.


## <a id="activate-feature"></a> Activate Live Hover

Activate Live Hover by starting your vscode instance with `TAP_LIVER_HOVER=true`, as in this example:

```console
> TAP_LIVE_HOVER=true code /path/to/project
```

After you have a workload deployed, the live hovers appear.

## A Concrete Example

Assuming you have the prerequisite [Spring Boot Tools](https://marketplace.visualstudio.com/items?itemName=Pivotal.vscode-spring-boot) installed.
Let's go through the steps to deploy the sample [tanzu-java-web-app](https://github.com/sample-accelerators/tanzu-java-web-app) workload to our cluster; and get live
hovers working.

*Step 1:* Clone the repo

```
$ git clone https://github.com/sample-accelerators/tanzu-java-web-app
```

*Step 2*: Open the project in Vscode, with the live-hover feature enabled

```
$ TAP_LIVE_HOVER=true code ./tanzu-java-web-app
```

*Step 3*: Target a cluster

Vscode Tanzu Tools will periodically connect to your cluster to try and
find pods from which live-data may be extracted and shown.

Vscode Tanzu Tools will use your current context from `~/.kube/config` to
determine the cluster to connect to.

Make sure that you are targetting the cluster on which you will be running
the workload. For example:

```
$ kubectl cluster-info
Kubernetes control plane is running at https://...
CoreDNS is running at https://...

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

*Step 3*: Deploy the workload to the cluster

Vscode Tanzu Tools will periodically look for pods in your
cluster that match the workload configurations it finds in your workspace.

If you don't have the workload running yet, now is a good time to deploy it.
For our sample there is a `config/workload.yaml` file in the git repo. So you
can do:

```
$ kubectl create -f config/workload.yaml
workload.carto.run/tanzu-java-web-app created
```

It will take some time for the workload to build and then startup a running pod.
To check if a pod is running yet you can do:

```
$ kubectl get pods
NAME                                                   READY   STATUS      RESTARTS   AGE
tanzu-java-web-app-00001-deployment-8596bfd9b4-5vgx2   2/2     Running     0          20s
tanzu-java-web-app-build-1-build-pod                   0/1     Completed   0          2m26s
tanzu-java-web-app-config-writer-fpnzb-pod             0/1     Completed   0          67s
```

Notice the `...-0001-deployment-...` pod. This is the pod from which live data
can be extracted.


*Step 5*: Open a file and see live hovers

To see some live hovers, simply open a Java file such as `HelloController.java`.
After a short delay of upto 30 seconds (on account of a 30 second polling loop),
green bubbles will appear as highlights in your code. Hover over any of the bubbles
to see live info about the corresponding element. For more details about the
functionality refer to the  documentation of
[Vscode Spring Boot Tools](https://marketplace.visualstudio.com/items?itemName=Pivotal.vscode-spring-boot).
