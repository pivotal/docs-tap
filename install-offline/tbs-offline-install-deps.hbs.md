# Install the Tanzu Build Service dependencies

<!-- The below partial is in the docs-tap/partials directory -->

{{> 'partials/full-deps' find_tbs_version="1. Get the latest version of the Tanzu Build Service package by running:

    ```console
    tanzu package available list buildservice.tanzu.vmware.com --namespace tap-install
    ```" }}

## <a id='next-steps'></a>Next steps

- [Configure custom CAs for Tanzu Application Platform GUI](tap-gui-non-standard-certs-offline.hbs.md)
