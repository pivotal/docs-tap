# Install Artifact Metadata Repository CloudEvent Handler

This topic tells you how to install the Artifact Metadata Repository (AMR) CloudEvent Handler.

## <a id='switch-context'></a>Switching Context

If AMR CloudEvent Handler is installed on a separate cluster, such as with a view profile cluster, it is important that you target the correct cluster when updating. Ensure that the correct cluster is targeted before updating package values.

```console
# 1. Switch context to view profile cluster
kubectl config use-context VIEW-CLUSTER-NAME

# 2. Update the tap-values.yaml in an editor according to the desired configuration

# 3. Update the installed TAP package on the cluster
tanzu package installed update tap --values-file tap-values.yaml -n tap-install
```

Where `VIEW-CLUSTER-NAME` is the name of the view profile cluster you want to use.

## <a id='install'></a>Install

The AMR CloudEvent Handler is installed by default in the Tanzu Application Platform Full and View
profiles.
