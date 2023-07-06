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

On the view profile cluster or full profile cluster, the Metadata Store installation must be updated to have Artifact Metadata Repository deployed. 
When the Artifact Metadata Repository is deployed, Artifact Metadata Repository CloudEvent Handler is deployed alongside it. 

To do so, additional Tanzu Application Platform values are required:

```yaml
metadata_store:
    amr:
        deploy: true
```

## Uninstall

Artifact Metadata Repository CloudEvent Handler is deployed alongside Artifact Metadata Repository. Therefore, to undeploy Artifact Metadata Repository CloudEvent Handler, the Tanzu Application Platform values are updated with:

```yaml
metadata_store:
    amr:
        deploy: false
```

>**Note** When Artifact Metadata Repository Observer is deployed on the same cluster with the full Tanzu Application Platform profile, Artifact Metadata Repository Observer is undeployed when Artifact Metadata Repository is undeployed.
