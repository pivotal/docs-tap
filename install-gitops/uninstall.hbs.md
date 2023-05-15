# Uninstall Tanzu Application Platform by using GitOps

This document tells you how to uninstall Tanzu Application Platform (commonly known as TAP) when installed by using GitOps.

>**Caution** Tanzu Application Platform (GitOps) is currently in beta and is intended for evaluation and test purposes only. Do not use in a production environment.

To uninstall your Tanzu Application Platform:

- [Delete Tanzu Sync Application](#del-tanzu-sync)
- [Delete external resources (ESO installation only)](#del-aws-resources)
- [Remove the Tanzu CLI, plug-ins, and associated files](#remove-tanzu-cli)
- [Remove Cluster Essentials](#remove-ce)

## <a id='del-tap'></a>Delete Tanzu Sync Application

>**Caution** 

> - Deleting Tanzu Sync application removes all associated resources of Tanzu Application Platform on the cluster.
> - You must delete any applications that were installed manually into the `tap-install` namespace, 
> because they might interfere with the deletion of Tanzu Application Platform.

To delete Tanzu Sync Application, run:

```console
kapp delete -a tanzu-sync
```

## <a id='del-aws-resources'></a>Delete external resources (ESO installation only)

To delete external resources from AWS, run:

```console
cd $HOME/REPO-NAME/clusters/CLUSTER-NAME
./tanzu-sync/aws/scripts/delete-irsa.sh
./tanzu-sync/aws/scripts/delete-policies.sh
```

## <a id='remove-tanzu-cli'></a> Remove the Tanzu CLI, plug-ins, and associated files

To completely remove the Tanzu CLI, plug-ins, and associated files, 
run the following scrips for Linux or MacOS:

```console
#!/bin/zsh
rm -rf $HOME/tanzu/cli        # Remove previously downloaded cli files
sudo rm /usr/local/bin/tanzu  # Remove CLI binary (executable)
rm -rf ~/.config/tanzu/       # current location # Remove config directory
rm -rf ~/.tanzu/              # old location # Remove config directory
rm -rf ~/.cache/tanzu         # remove cached catalog.yaml
rm -rf ~/Library/Application\ Support/tanzu-cli/* # Remove plug-ins
```

## <a id='remove-ce'></a> Remove Cluster Essentials

To completely remove Cluster Essentials, see [Cluster Essentials documentation](https://docs.vmware.com/en/Cluster-Essentials-for-VMware-Tanzu/{{ vars.url_version }}/cluster-essentials/deploy.html#uninstall).
