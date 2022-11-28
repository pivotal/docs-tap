# Debugging workloads

## <a id="check-build-logs"></a> Check build logs

Once the workload is created, you can tail the workload to view the build and runtime logs.

- Check logs by running:

    ```bash
    tanzu apps workload tail pet-clinic --since 10m --timestamp
    ```

    Where:

    - `pet-clinic` is the name you gave the workload.
    - `--since` (optional) the amount of time to go back to begin streaming logs. The default is 1 second.
    - `--timestamp` (optional) prints the timestamp with each log line.

## <a id="workload-status"></a> Get the workload status and details

After the workload build process is complete, create a Knative service to run the workload.
You can view workload details at anytime in the process. Some details, such as the workload URL, are only available after the workload is running.

1. To check the workload details, run:

    ```bash
    tanzu apps workload get pet-clinic
    ```

    Where:

    - `pet-clinic` is the name of the workload you want details about.

2. You can now see the running workload. When the workload is created, `tanzu apps workload get` includes the URL for the running workload. Some terminals allow you to `ctrl`+click the URL to view it. You can also copy and paste the URL into your web browser to see the workload.

## <a id="common-workload-errors"></a> Common workload errors

A workload can either be ready, on error or with an unknown status.

There are known errors that will make the workload enter in an error or unknown status. The most common are:

- *Local Path Development Error Cases*
	- *Message*: Writing `registry/project/repo/workload:latest`: Writing image: Unexpected status code *401 Unauthorized* (HEAD responses have no body, use GET for details)
		- *Cause*: Apps plugin cannot talk to the registry because the registry credentials are missing or invalid.
		- *Resolution*:
			- Run  `docker logout registry` and `docker login registry` commands and specify the valid credentials for the registry.
	- *Message*: Writing `registry/project/workload:latest`: Writing image: HEAD Unexpected status code *400 Bad Request* (HEAD responses have no body, use GET for details)
		- *Cause*: Certain registries like Harbor or GCR have a concept of `Project`. 400 Bad request is sent when either the project does not exists, the user does not have access to it, or the path in the `—source-image` flag is missing either project or repo.
		- *Resolution*:
			- Fix the path in the `—source-image` flag value to point to a valid repo path.

- *WorkloadLabelsMissing* / *SupplyChainNotFound*
	- *Message*: No supply chain found where full selector is satisfied by `labels: map[app.kubernetes.io/part-of:spring-petclinic]`
		- *Cause*: The labels and attributes in the workload object did not fully satisfy any installed supply chain on the cluster.
		- *Resolution*: Use the `tanzu apps csc list` and `tanzu apps csc get <supply-chain>` commands to see the selector criterias for the supply chains. You can apply the missing labels to a workload by using `tanzu apps workload apply`
		- e.g. `tanzu apps workload apply workload-name —-type web`
		- e.g. `tanzu apps workload apply workload-name --label apps.tanzu.vmware.com/workload-type=web`

- *MissingValueAtPath*
	- *Message*: Waiting to read value `[.status.artifact.url]` from resource gitrepository.source.toolkit.fluxcd.io  in namespace `[ns]`
	- *Possible Causes*:
		- The git `url/tag/branch/commit` params passed in the workload are not valid.
			- *Resolution*: Fix the invalid git param by using *tanzu apps workload apply*
		- The git repo is not accessible from the cluster
			- *Resolution*: Configure your cluster networking or your Git repo networking so that they can communicate with each other.
		- The namespace is missing the git secret for communicating with the private repository
			- *Resolution*: Checkout this page on how to setup Git Authentication for Private repositories [Link to [Git authentication](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.1/tap/GUID-scc-git-auth.html)]

- *TemplateRejectedByAPIServer*
	- *Message*: Unable to apply object `[ns/workload-name]` for resource `[source-provider]` in supply chain `[source-to-url]`: failed to get unstructured `[ns/workload-name]` from api server: imagerepositories.source.apps.tanzu.vmware.com "workload-name" is forbidden: User "system:serviceaccount:ns:default" cannot get resource "imagerepositories" in API group "source.apps.tanzu.vmware.com" in the namespace "ns"
	- *Cause*: This error happens when the service account in the workload object does not have permissions to create objects that are stamped out by the supply chain.
		- *Resolution*: This can be fixed by setting up the [Set up developer namespaces to use installed packages](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-set-up-namespaces.html) with the required service account and permissions.

## <a id="steps-failure"></a> Supply Chain steps

After a workload is created, the steps it goes through in the supply chain are surfaced with `workload get` command.
The output looks like the following:

```bash
...
📦 Supply Chain
   name:   source-to-url

   NAME               READY   HEALTHY   UPDATED   RESOURCE
   source-provider    True    True      71m       gitrepositories.source.toolkit.fluxcd.io/spring-petclinic
   image-provider     True    True      70m       images.kpack.io/spring-petclinic
   config-provider    True    True      69m       podintents.conventions.carto.run/spring-petclinic
   app-config         True    True      69m       configmaps/spring-petclinic
   service-bindings   True    True      69m       configmaps/spring-petclinic-with-claims
   api-descriptors    True    True      69m       configmaps/spring-petclinic-with-api-descriptors
   config-writer      True    True      69m       runnables.carto.run/spring-petclinic-config-writer

🚚 Delivery
   name:   delivery-basic

   NAME              READY   HEALTHY   UPDATED   RESOURCE
   source-provider   True    True      69m       imagerepositories.source.apps.tanzu.vmware.com/spring-petclinic-delivery
   deployer          True    True      69m       apps.kappctrl.k14s.io/spring-petclinic

💬 Messages
   No messages found.
...
```

In the `Supply Chain` section, the resources of the supply chain related to the workload are displayed, alongside their reconcile state. In case of failure, the `READY` column will show `Unknown` or `False`, and the `HEALTHY` column will surface, as its name implies, if the resource is healthy or not.

In case there is a resource in `Unknown` or `False` status, it can be inspected with:
```
$ kubectl describe <resource-name>
```
Where `resource-name` refers to the name of the stamped out resource, displayed in `RESOURCE` column.

For example, if something like this is retrieved in `workload get` command
```bash
NAME               READY   HEALTHY   UPDATED   RESOURCE
source-provider    False   False     3h12m     gitrepositories.source.toolkit.fluxcd.io/spring-petclinic
```
Whatever is going on with this resource can be checked with:
```bash
kubectl describe gitrepositories.source.toolkit.fluxcd.io/spring-petclinic
```

But also, `workload get` command notifies the top level issue in the `Messages` section, which could give a hint to what went wrong in the process.

For example, a message like this could be shown:
```bash
💬 Messages
   Workload [HealthyConditionRule]:   failed to checkout and determine revision: failed to resolve commit object for '425ae9a2a2f84d195a9f3862668e8b2abf81418a': object not found
```
This could mean that the given commit does not belong to the specified branch or does not exist in the repo.