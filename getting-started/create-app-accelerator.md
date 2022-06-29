# Create your application accelerator

This how-to guide walks you through creating an application accelerator by using Tanzu Application Platform GUI and CLI.

For background information about application accelerators, see [Application Accelerator](about-application-accelerator.md).

## <a id="you-will"></a>What you will do

- Select a Git repository to create your accelerator and clone the repository.
- Create an `accelerator.yaml` file that defines your accelerator and add it to your Git repository.
- Publish your application accelerator and view it in Tanzu Application Platform GUI.
- Begin to work with your accelerator.

## <a id="create-an-app-acc"></a>Create an application accelerator

You can use any Git repository to create an accelerator provided it: 

- Is public
- Contains a README.md file

You can configure these options when you create a repository on GitHub. You need the repository URL to create an accelerator.

To create a new application accelerator by using your Git repository, follow these steps:

1. Clone your Git repository.

2. Create a file named `accelerator.yaml` in the root directory of this Git repository.

3. Add the following content to the `accelerator.yaml` file:

    ```yaml
    accelerator:
      displayName: Simple Accelerator
      description: Contains just a README
      iconUrl: https://images.freecreatives.com/wp-content/uploads/2015/05/smiley-559124_640.jpg
      tags:
      - simple
      - getting-started
    ```

    >**Note:** You can use any icon with a reachable URL.

4. Add the new `accelerator.yaml` file, commit this change, and push it to your Git repository.

## <a id="publish-accelerator"></a>Publish the new accelerator

To publish the new application accelerator that is created in your Git repository, follow these steps:

1. To publish the new application accelerator, run:

    ```console
    tanzu accelerator create simple --git-repository YOUR-GIT-REPOSITORY-URL --git-branch YOUR-GIT-BRANCH
    ```

    Where:

    - `YOUR-GIT-REPOSITORY-URL` is the URL of your Git repository.
    - `YOUR-GIT-BRANCH` is the name of the branch where you pushed the new `accelerator.yaml` file.

2. Refresh Tanzu Application Platform GUI to reveal the newly published accelerator.

    ![Another accelerator appears in Tanzu Application Platform GUI](../images/new-accelerator-deployed-v1-1.png)

    >**Note:** It might take a few seconds for Tanzu Application Platform GUI to refresh the catalog and add an entry for your new accelerator.

## <a id="work-with-accelerators"></a>Working with accelerators

### <a id="accelerator-updates"></a>Updating an accelerator

After you push any changes to your Git repository, the accelerator is refreshed based on the `git.interval` setting for the Accelerator resource. The default value is 10 minutes. To force an immediate reconciliation, run:

```console
tanzu accelerator update ACCELERATOR-NAME --reconcile
```

Where `ACCELERATOR-NAME` is the name of your accelerator.

### <a id="accelerator-deletes"></a>Deleting an accelerator

When you no longer need your accelerator, you can delete it by using the Tanzu CLI:

```console
tanzu accelerator delete ACCELERATOR-NAME
```

### <a id="accelerator-manifest"></a>Using an accelerator manifest

You can also create a separate manifest file and apply it to the cluster by using the Tanzu CLI:

1. Create a `simple-manifest.yaml` file and add the following content:

    ```yaml
    apiVersion: accelerator.apps.tanzu.vmware.com/v1alpha1
    kind: Accelerator
    metadata:
      name: simple
      namespace: accelerator-system
    spec:
      git:
        url: YOUR-GIT-REPOSITORY-URL
        ref:
          branch: YOUR-GIT-BRANCH
    ```

    Where:

    - `YOUR-GIT-REPOSITORY-URL` is the URL of your Git repository.
    - `YOUR-GIT-BRANCH` is the name of the branch.

1. Apply the `simple-manifest.yaml` by running the following command in the directory where you created this file:

    ```console
    kubectl apply -f simple-manifest.yaml
    ```

## Next steps

- [Add testing and security scanning to your application](add-test-and-security.md.hbs)
