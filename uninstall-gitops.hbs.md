# Uninstall Tanzu Application Platform via Gitops

>**Caution** Tanzu Application Platform (GitOps)) is currently in beta and is intended for evaluation and test purposes only. Do not use in a production environment.

This document describes how to uninstall Tanzu Application Platform when installed via Gitops.

To uninstall Tanzu Application Platform:

- [Delete Tanzu Sync Application](#del-tanzu-sync)
- [Remove Tanzu CLI, plug-ins, and associated files](#remove-tanzu-cli)
- [Remove Cluster Essentials](#remove-ce)

## <a id='del-tap'></a>Delete Tanzu Sync Application

>**Caution** Deleting Tanzu Sync application will delete all associated resources of Tanzu Application Platform on the cluster.

To delete Tanzu Sync Application, run:

```console
kapp delete -a tanzu-sync
```

## <a id='remove-tanzu-cli'></a> Remove Tanzu CLI, plug-ins, and associated files

To completely remove the Tanzu CLI, plug-ins, and associated files, run the script for your OS:

For Linux or MacOS, run:

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
