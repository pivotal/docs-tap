# Deploy your first air-gapped workload (beta)

This how-to guide walks developers through deploying your first workload on Tanzu Application Platform in an air-gapped environment.

For information about installing Tanzu Application Platform in an air-gapped environment, see [Install Tanzu Application Platform in an air-gapped environment (Beta)](install-air-gap.md.hbs).

## <a id="you-will"></a>What you will do

- Create a workload from Git.
- Create a basic supply chain workload.

>**Important:** This is a beta feature. Beta features have been tested for functionality, but not performance. Features enter the beta stage so that customers can gain early access and give feedback on design and behavior. Beta features might undergo changes based on this feedback before the end of the beta stage. VMware discourages running beta features in production and does not guarantee that you can upgrade any beta feature in the future.

## Create a workload from Git

To create a workload from Git through https, create a secret in your developer namespace with the caFile that matches the gitops_ssh_secret name in tap_values:

```console
   kubectl create secret generic custom-ca --from-file=caFile=CA_PATH -n NAMESPACE
```

If you would like to pass in a custom settings.xml for Java, create a file called settings-xml.yaml similar to the sample [settings-xml.yaml](https://gitlab.eng.vmware.com/tanzu-compliance/tap-airgapped/-/blob/main/service-bindings/settings-xml.yaml) on GitLab. To apply the file:

```console
   kubectl create -f settings-xml.yaml -n DEVELOPER-NAMESPACE
```   

## Create a basic supply chain workload

Next, create your basic supply chain workload. Due to a bug, you must pass in a build environment:

```console
tanzu apps workload create APPNAME --git-repo  https://GITURL --git-branch BRANCH --type web --label app.kubernetes.io/part-of=CATALOGNAME --yes --param-yaml buildServiceBindings='[{"name": "settings-xml", "kind": "Secret"}]' --build-env "BP_MAVEN_BUILD_ARGUMENTS=-Dmaven.test.skip=true --no-transfer-progress package"
```

If you would rather pass the CA certificate in at workload create time, use the following command:

```console
tanzu apps workload create APP-NAME --git-repo  https://GITREPO --git-branch BRANCH --type web --label app.kubernetes.io/part-of=CATALOGNAME --yes --param-yaml buildServiceBindings='[{"name": "settings-xml", "kind": "Secret"}]' --param "gitops_ssh_secret=git-ca" --build-env "BP_MAVEN_BUILD_ARGUMENTS=-Dmaven.test.skip=true --no-transfer-progress package"
```
