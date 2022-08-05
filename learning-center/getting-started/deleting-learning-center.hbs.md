# Deleting Learning Center

Follow these steps to delete Learning Center:

1. Delete all current workshop environments by running:

    ```console
    kubectl delete workshops,trainingportals,workshoprequests,workshopsessions,workshopenvironments --all
    ```

    >**Note:** Ensure the Learning Center operator is still running when running this command.

1. Verify you have deleted all current workshop environments by running:

    ```console
    kubectl get workshops,trainingportals,workshoprequests,workshopsessions,workshopenvironments --all-namespaces
    ```

    >**Note:** This command does not delete the workshops in the `workshops.learningcenter.tanzu.vmware.com` package.

1. Uninstall the Learning Center package by running:

    ```console
    tanzu package installed delete {NAME_OF_THE_PACKAGE} -n tap-install
    ```

    >**Note:** This command also removes the added custom resource definitions and the `learningcenter` namespace.

    >**Note:** If you have installed the Tanzu Application Platform package, Learning Center will be recreated.

1. To remove the Learning Center package, add the following lines to your `tap-values` file.

    ```yaml
    excluded_packages:
    - learningcenter.tanzu.vmware.com
    - workshops.learningcenter.tanzu.vmware.com
    ```
