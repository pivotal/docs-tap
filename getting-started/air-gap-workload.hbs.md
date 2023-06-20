# Deploy your first air-gapped workload (beta)

This topic for developers guides you through deploying your first workload on Tanzu Application Platform
(commonly known as TAP) in an air-gapped environment.

For information about installing Tanzu Application Platform in an air-gapped environment, see [Install Tanzu Application Platform in an air-gapped environment (beta)](../install-offline/profile.hbs.md).

## <a id="you-will"></a>What you will do

- Create a workload from Git.
- Create a basic supply chain workload.

>**Caution:** Tanzu Application Platform in an air-gapped environment is currently in beta and is intended for evaluation and test purposes only. Do not use in a production environment.

## Create a workload from Git

To create a workload from Git through https, follow these steps:

1. Create a secret in your developer namespace with the caFile that matches the `gitops_ssh_secret` name in tap_values:

    ```console
    kubectl create secret generic custom-ca --from-file=caFile=CA_PATH -n NAMESPACE
    ```

2. If you would like to pass in a custom settings.xml for Java, create a file called `settings-xml.yaml` similar to the following example:

   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: settings-xml
   type: service.binding/maven
   stringData:
     type: maven
     provider: sample
     settings.xml: |
       <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">
           <mirrors>
               <mirror>
                   <id>reposilite</id>
                   <name>Tanzu seal Internal Repo</name>
                   <url>https://reposilite.tap-trust.cf-app.com/releases</url>
                   <mirrorOf>*</mirrorOf>
               </mirror>
           </mirrors>
           <servers>
                <server>
                   <id>reposilite</id>
                   <username>USERNAME</username>
                   <password>PASSWORD</password>
                </server>
           </servers>
       </settings>
   ```

3. Apply the file:

   ```console
   kubectl create -f settings-xml.yaml -n DEVELOPER-NAMESPACE
   ```

## Create a basic supply chain workload

Next, create your basic supply chain workload. Due to a bug, you must pass in a build environment:

```console
tanzu apps workload create APP-NAME --git-repo  https://GITURL --git-branch BRANCH --type web --label app.kubernetes.io/part-of=CATALOGNAME --yes --param-yaml buildServiceBindings='[{"name": "settings-xml", "kind": "Secret"}]' --build-env "BP_MAVEN_BUILD_ARGUMENTS=-Dmaven.test.skip=true --no-transfer-progress package"
```

If you would rather pass the CA certificate in at workload create time, use the following command:

```console
tanzu apps workload create APP-NAME --git-repo  https://GITREPO --git-branch BRANCH --type web --label app.kubernetes.io/part-of=CATALOGNAME --yes --param-yaml buildServiceBindings='[{"name": "settings-xml", "kind": "Secret"}]' --param "gitops_ssh_secret=git-ca" --build-env "BP_MAVEN_BUILD_ARGUMENTS=-Dmaven.test.skip=true --no-transfer-progress package"
```
