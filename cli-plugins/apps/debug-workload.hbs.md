# Debug workloads

This topic describes steps you can take to debug workloads.

## <a id="check-build-logs"></a> Check build logs

After a workload is created, tail the workload to view the build and runtime logs.

Check logs by running:

```console
tanzu apps workload tail pet-clinic --since 10m --timestamp
 ```

Where:

- `pet-clinic` is the name you gave the workload.
- `--since` (optional) the amount of time to go back to begin streaming logs. The default is 1 second.
- `--timestamp` (optional) prints the timestamp with each log entry.

## <a id="workload-status"></a> Get the workload status and details

After the workload build process is complete, create a Knative service to run the workload.
You can view workload details at any time during the process. Some details, such as the workload
URL, are only available after the workload is running.

To check the workload details, run:

```console
tanzu apps workload get pet-clinic
```

Where:

`pet-clinic` is the name of the workload you want details about.

You can now see the running workload. When the workload is created, `tanzu apps workload get`
includes the URL for the running workload. Some terminals allow you to `ctrl`+click the URL to
view it. You can also copy and paste the URL into your web browser to see the workload.

## <a id="common-workload-errors"></a> Common workload errors

A workload can either be ready, on error or with an unknown status.

There are known errors that cause the workload to enter an error or unknown status. The most common are:

### Local Path Development Error Cases

Message: Writing `registry/project/repo/workload:latest`: Writing image: Unexpected status code
*401 Unauthorized* (HEAD responses have no body, use GET for details)

Cause: Apps plug-in cannot talk to the registry because the registry credentials are missing or invalid.

Resolution: Run  `docker logout registry` and `docker login registry` commands and specify the valid
credentials for the registry.

Message: Writing `registry/project/workload:latest`: Writing image: HEAD Unexpected status code
*400 Bad Request* (HEAD responses have no body, use GET for details)

Cause: Certain registries like Harbor or GCR have a concept of `Project`. A 400 Bad request is sent
when either the project does not exist, the user does not have access to it, or the path in the
`—source-image` flag is missing either project or repository.

Resolution: Fix the path in the `—source-image` flag value to point to a valid repository path.

### WorkloadLabelsMissing/SupplyChainNotFound

Message: No supply chain found where full selector is satisfied by `labels: map[app.kubernetes.io/part-of:spring-petclinic]`

Cause: The labels and attributes in the workload object did not fully satisfy any installed supply
chain on the cluster.

Resolution: Use the `tanzu apps cluster-supply-chain list` (alias `csc`) and
`tanzu apps csc get <supply-chain-name>` commands to see the workload selection criteria for the
supply chain available on the cluster. Apply any missing labels to a workload by using
`tanzu apps workload apply --label required-label-name=required-label-value`. For example:

```console
tanzu apps workload apply workload-name —-type web
tanzu apps workload apply workload-name --label apps.tanzu.vmware.com/workload-type=web
```

### MissingValueAtPath

Message: Waiting to read value `[.status.artifact.url]` from resource
gitrepository.source.toolkit.fluxcd.io  in namespace `[ns]`

Possible Cause: The Git `url/tag/branch/commit` parameters passed in the workload are not valid.

Resolution: Fix the invalid Git parameters by using `tanzu apps workload apply`

Possible Cause: The Git repository is not accessible from the cluster

Resolution: Configure your cluster networking or your Git repository networking so that they can
communicate with each other.

Possible Cause: The namespace is missing the Git secret for communicating with the private repository

Resolution: For more information, see [Git authentication](../../scc/git-auth.hbs.md)

### TemplateRejectedByAPIServer

Message: Unable to apply object `[ns/workload-name]` for resource `[source-provider]` in supply
chain `[source-to-url]`: failed to get unstructured `[ns/workload-name]` from API server:
imagerepositories.source.apps.tanzu.vmware.com "workload-name" is forbidden:
User "system:serviceaccount:ns:default" cannot get resource "imagerepositories" in API group
"source.apps.tanzu.vmware.com" in the namespace "ns"

Cause: This error happens when the service account in the workload object does not have permission
to create objects that are stamped out by the supply chain.

Resolution: Set up the
[Set up developer namespaces to use your installed packages](../../scst-store/developer-namespace-setup.hbs.md)
with the required service account and permissions.

## <a id="steps-failure"></a> Review supply chain steps

After you create a workload with the `tanzu apps workload create (or) apply`, command, you can run
the `tanzu apps workload get` command to display the current condition of each supply chain.

For example:

```console
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

The `Supply Chain` section displays the supply chain steps associated with the workload.
If a step fails, the `READY` column value is `Unknown` or `False`, and
the `HEALTHY` column value is `False`. If there is a resource in `Unknown` or `False` status,
inspect it with:

```console
kubectl describe RESOURCE-NAME
```

Where `RESOURCE-NAME` refers to the name of the stamped out resource, displayed in `RESOURCE` column.

For example, if `tanzu apps workload get` command returns this resource:

```console
NAME               READY   HEALTHY   UPDATED   RESOURCE
source-provider    False   False     3h12m     gitrepositories.source.toolkit.fluxcd.io/spring-petclinic
```

Check this resource with:

```console
kubectl describe gitrepositories.source.toolkit.fluxcd.io/spring-petclinic
```

The `Messages` section might give a hint as to what went wrong in the process.
For example, a message similar to the following is shown:

```console
💬 Messages
   Workload [HealthyConditionRule]:   failed to checkout and determine revision: failed to resolve commit object for '425ae9a2a2f84d195a9f3862668e8b2abf81418a': object not found
```

This might mean that the commit does not belong to the specified branch or does not exist in the repository.

## <a id="additional-tsg"></a>Additional Troubleshooting References

For more workload troubleshooting tips, see [Troubleshoot using Tanzu Application Platform page](../../troubleshooting-tap/troubleshoot-using-tap.hbs.md).
