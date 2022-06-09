# Creating accelerators

This topic describes how to create an accelerator in Tanzu Application Platform GUI. An accelerator contains your enterprise-conformant code and configurations that developers can use to create new projects that by default follow the standards defined in your accelerators.

## <a id="creating-accelerators-prerequisites"></a>Prerequisites

The following prerequisites are required to create an accelerator:

  - Application Accelerator is installed. For information about installing Application Accelerator, see [Installing Application Accelerator for VMware Tanzu](../installation/install.md)
  - You can access Tanzu Application Platform GUI from a browser. For more information, see the "Tanzu Application Platform GUI" section in the most recent release for [Tanzu Application Platform documentation](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/index.html)
  - kubectl v1.20 and later. The Kubernetes command line tool (kubectl) is installed and authenticated with admin rights for your target cluster.

## <a id="creating-accelerators-getting-started"></a>Getting started

You can use any Git repository to create an accelerator. You need the URL for the repository to create an accelerator.

For this example, the Git repository is `public` and contains a `README.md` file. These are options available when you create repositories on GitHub.

Use the following procedure to create an accelerator based on this Git repository:

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

    Feel free to use a different icon if it uses a reachable URL.

4. Add the new `accelerator.yaml` file, commit this change, and push to your Git repository.

## <a id="publishing-the-new-accelerator"></a>Publishing the new accelerator

2. To publish your new accelerator, run this command in your terminal:
    
    ```sh
    tanzu acc create simple --git-repository YOUR-GIT-REPOSITORY-URL --git-branch YOUR-GIT-BRANCH
    ```

    Where:
    
    - `YOUR-GIT-REPOSITORY-URL` is the URL for your Git repository.
    - `YOUR-GIT-BRANCH` is the name of the branch where you pushed the new `accelerator.yaml` file.

3. Refresh Tanzu Application Platform GUI to reveal the newly published accelerator.

    ![Screenshot of another accelerator in Tanzu Application Platform GUI](../images/new-accelerator-deployed-v1-1.png)

    >**Note:** It might take a few seconds for Tanzu Application Platform GUI to refresh the catalog and add an entry for your new accelerator.

An alternative to using the Tanzu CLI is to create a separate manifest file and apply it to the cluster:

1. Create a `simple-manifest.yaml` file and add the following content, filling in with your Git repository and branch values.

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

1. To apply the `simple-manifest.yaml`, run this command in your terminal in the directory where you created this file:

    ```sh
    kubectl apply -f simple-manifest.yaml
    ```


## <a id="Next-steps"></a>Next steps

Learn how to:

- Write an [accelerator.yaml](accelerator-yaml.md).
- Configure accelerators with [Accelerator Custom Resources](accelerator-crd.md).
- Manipulate files using [Transforms](transform-intro.md).
- Use [SpEL in the accelerator.yaml file](spel-samples.md).
