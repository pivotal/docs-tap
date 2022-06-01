# Live Hover integration with Spring Boot Tools (Experimental)

## <a id="prerequisites"></a> Prerequisites

- A Tanzu Spring Boot application, such as [tanzu-java-web-app](https://github.com/sample-accelerators/tanzu-java-web-app)
- Spring Boot Tools [extension](https://marketplace.visualstudio.com/items?itemName=Pivotal.vscode-spring-boot) version `1.33` or later.

## <a id="activating-feature"></a> Activating Live Hover

In order to activate live hover, you need to start your vscode instance with `TAP_LIVER_HOVER=true`, eg.
`> TAP_LIVE_HOVER=true code /path/to/project`

Once you have a workload deployed, you should see the live hovers.

## A Concrete Example

Assuming you have the pre-requisited installed. Let's go through the 
steps deploy the sample app [tanzu-java-web-app](https://github.com/sample-accelerators/tanzu-java-web-app) to our cluster; and get live
hovers working.

*Step 1:* Clone the repo 

```
$ git clone https://github.com/sample-accelerators/tanzu-java-web-app
```

*Step 2*: Open the project in vscode, with the live-hover feature enabled

```
$ TAP_LIVE_HOVER=true code ./tanzu-java-web-app
```

*Step 3*: Target a cluster

Vscode-tanzu-tools will periodcailly connect to your cluster to try and 
find pods from which live-data may be extracted / shown.

Vscode-tanzu-tools will use your current context from `~/.kube/config`. 

Make sure that you are targetting the cluster on which you will be running
the workload. For example:

```
$ kubectl cluster-info
Kubernetes control plane is running at https://...
CoreDNS is running at https://...

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

*Step 3*: Deploy the workload to the cluster 

Vscode-tanzu-tools will periodically connect to the cluster pods in your 
cluster that match the workload configurations it finds in your workspace. 

If you don't have the workload running yet, now is a good time to deploy it.
For our sample there is a `config/workload.yaml` file in the git repo. So you 
can do:

```
$ kubectl create -f config/workload.yaml 
workload.carto.run/tanzu-java-web-app created
```

It will take some time for the workload to build and then startup running pod. 
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
After a short delay of upto 30 seconds (on account of a live-hover polling loop),
green bubbles will appear as highlights in your code. Hover over any of the bubbles
to see live info about the corresponding element. For more details about the
functionality refer to the  documentation of 
[Vscode Spring Boot Tools](https://marketplace.visualstudio.com/items?itemName=Pivotal.vscode-spring-boot). 