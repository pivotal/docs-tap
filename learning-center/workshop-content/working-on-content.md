# Workshop content

Workshop content is either embedded in a custom workshop image or downloaded from a Git repository or web server when the workshop session is created. To speed up the iterative loop of editing and testing a workshop when developing workshop content, there are a number of best practices you can use.

## Disabling reserved sessions

Use an instance of a training portal when developing content where reserved sessions are disabled.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-sample-workshop
spec:
  portal:
    sessions:
      maximum: 1
  workshops:
  - name: lab-sample-workshop
    reserved: 0
    expires: 120m
    orphaned: 15m
```

If you don't disable reserved sessions, then a new session is always created ready for the next workshop session when there is available capacity to do so. If you modify workshop content while testing the current workshop session and then terminate the session and start a new one, it picks up the reserved session, which still has a copy of the old content.

By disabling reserved sessions a new workshop session is always created on demand, ensuring the latest workshop content is used.

As there can be a slight delay in being able to create a new workshop, shut down the existing workshop session first. The new workshop session may also take some time to start if an updated version of the workshop image also has to be pulled down.

## Live updates to the content

If you download workshop content from a Git repository or web server and you are only doing simple updates to workshop instructions, scripts, or files bundled with the workshop, you can update the content in place without needing to restart the workshop session. To perform an update, do this after you have pushed back any changes to the hosted Git repository or updated the content available via the web server. From the workshop session terminal run:

```
update-workshop
```

This command downloads any workshop content from the Git repository or web server, unpacks it into the live workshop session, and re-runs any script files found in the ``workshop/setup.d`` directory.

If you want to see from where the workshop content is being downloaded, you can find the location by viewing the file:

```
~/.eduk8s/workshop-files.txt
```

The location saved in this file could be changed if, for example, it referenced a specific version of the workshop content and you wanted to test with a different version.

Once the workshop content has been updated you can reload the current page of the workshop instructions by clicking on the reload icon on the dashboard while holding down the shift key.

If additional pages are added to the workshop instructions or pages are renamed, you need to restart the workshop renderer process. This can be done by running:

```
restart-workshop
```

As long as you didn't rename the current pager or if the name had changed, you can trigger a reload of the current page. Click the home icon, if the name of the first page didn't change, or refresh the whole browser window.

If action blocks within the workshop instructions are broken and you want to make a change to the workshop instructions within the live workshop session to test, you can make edits to the appropriate page under ``/opt/workshop/content``. Navigate to the modified page or reload it to verify the change.

If you want to make a change to set up scripts which create files specific to a workshop session and re-run them, make the edit to the script under ``/opt/workshop/setup.d``. To trigger running of any setup scripts, then run:

```
rebuild-workshop
```

If local changes to the workshop session are working, then you can modify the file back in the original Git repository where you are keeping content.

Updating workshop content in a live session in this way does not undo any deployments or changes you make in the Kubernetes cluster for that session. If you want to retest parts of the workshop instructions you may have to manually undo changes in the cluster in order to replay them. This depends on your specific workshop content.

## Custom workshop image changes

If your workshop uses a custom workshop image in order to provide additional tools, and, as a result, you have included the workshop instructions as part of the workshop image,  always use an image tag of ``main``, ``master``, ``develop`` or ``latest``during development of workshop content.  Do not use a version image reference. For example:

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-sample-workshop
spec:
  title: Sample Workshop
  description: A sample workshop
  content:
    image: <YOUR-GIT-REPO>/lab-sample-workshop:master
```

When an image tag of ``main``, ``master``, ``develop`` or ``latest`` is used, the image pull policy is set to ``Always`` to ensure that the custom workshop image is pulled down again for a new workshop session if the remote image changes. If the image tag was for a specific version, it is necessary to change the workshop definition every time a change occurred to the workshop image.

## Custom workshop image overlay

Even where you have a custom workshop image, set up the workshop definition to also pull down the workshop content from the hosted Git repository or web server as the following example shows:

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-sample-workshop
spec:
  title: Sample Workshop
  description: A sample workshop
  content:
    image: ghcr.io/eduk8s-labs/lab-sample-workshop:master
    files: <YOUR-GIT-REPO>/lab-sample-workshop
```

By pulling down the workshop content as an overlay on top of the contents of the custom workshop image when the workshop session starts, you need to rebuild only the custom workshop image when you need to make changes as to what additional tools are needed or when you want to ensure the latest workshop instructions are also a part of the final custom workshop image.

As the location of the workshop files is known, you can then also do live updates of workshop content in the session using this method as described previously.

If the additional set of tools required for a workshop is not too specific to a workshop, it is recommended that you create a standalone workshop base image where just the tools are added. You can always pull down content for a specific workshop from a Git repository or web server when the workshop session starts.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: Workshop
metadata:
  name: lab-sample-workshop
spec:
  title: Sample Workshop
  description: A sample workshop
  content:
    image: ghcr.io/eduk8s-labs/custom-environment:master
    files: github.com/eduk8s-labs/lab-sample-workshop
```

This separates generic tooling from specific workshops and allows the custom workshop base image to be used for multiple workshops on different, but related topics, which require the same tooling.

## Changes to workshop definition

By default, if you need to modify the definition for a workshop, you need to delete the training portal instance, update the workshop definition in the cluster, and recreate the training portal.

During development of workshop content, when working on the workshop definition itself to change things like resource allocations, role access, or what resource objects are automatically created for the workshop environment or a specific workshop session, you can enable automatic updates in the training portal definition on changes to the workshop definition.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-sample-workshop
spec:
  portal:
    sessions:
      maximum: 1
    updates:
      workshop: true
  workshops:
  - name: lab-sample-workshop
    expires: 120m
    orphaned: 15m
```

Whenever the workshop definition in the cluster is modified with this option enabled, the existing workshop environment managed by the training portal for that workshop is shut down and replaced with a new workshop environment using the updated workshop definition.

When an active workshop session is still running, the actual deletion of the old workshop environment is delayed until that workshop session is terminated.

## Local build of workshop image

Even if you are not packaging up a workshop into a custom workshop image, in order to avoid the need to keep pushing changes up to a hosted Git repository for local development of workshop content using a Kubernetes cluster, it can be easier to build a custom workshop image locally on your own machine using ``docker``.

In order to do this and avoid having to still push the image to a public image registry on the internet, you need to deploy an image registry to your local Kubernetes cluster where the Learning Center is being run. A basic deployment of an image registry in a local cluster access usually is insecure. This means you have to configure the Kubernetes cluster to trust the insecure registry. This may be difficult to do depending on the Kubernetes cluster being used but can makes for quicker turnaround as you do not have to push or pull the custom workshop image across the public internet.

Once the custom workshop image built locally has been pushed to the local image registry, you can set the image reference in the workshop definition to pull it from the local registry in the same cluster. To ensure that the custom workshop image is always pulled for a new workshop session if updated, use the ``latest`` tag when tagging and pushing the image to the local registry.
