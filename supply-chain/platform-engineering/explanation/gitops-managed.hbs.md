# GitOps managed SupplyChains

SupplyChains, especially the authoring resources ([SupplyChain], [Component] and Tekton Pipeline/Task), are designed to
be delivered to clusters via a Git repository and GitOps source promotion style.

The expected flow is as follows:

1. Author the SupplyChain as a collection of yaml files in a file system backed by Git.
2. Test and debug by pushing all the files to a single namespace.
3. When you're happy with your new or modified SupplyChain, commit it to Git and create a pull/merge request.
4. Using continuous integration, test and ultimately approve the pull/merge request
5. Using continuous deployment, deliver your edits to build clusters.

Note: Both the integration and deployment of your SupplyChains should be managed by SupplyChains. Tanzu plans on releasing
examples of integration and delivery SupplyChains _for_ SupplyChains in coming releases.
