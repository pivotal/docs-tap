# Artifact Metadata Repository CloudEvent Handler

## Switching Context

If Artifact Metadata Repository CloudEvent Handler is installed on a separate cluster, such as with a view profile cluster, it is important that the correct cluster is targeted when updating the installation. Ensure that the correct cluster is targetted before updating package values.

```console
# 1. Switch context to view profile cluster
kubectl config use-context VIEW-CLUSTER-NAME

# 2. Update the tap-values.yaml in an editor according to the desired configuration

# 3. Update the installed TAP package on the cluster
tanzu package installed update tap --values-file tap-values.yaml -n tap-install
```

Where `VIEW-CLUSTER-NAME` is the name of the view profile cluster you want to use.

## Install

The AMR CloudEvent Handler is installed by default in TAP's Full and View
profiles.
