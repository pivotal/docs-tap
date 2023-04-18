# Obtain credentials for VMware Application Catalog Integration

This topic describes how to obtain credentials for VMware Application Catalog (VAC) to use
when following the procedure in [Configure private registry and VMware Application Catalog integration for Bitnami Services](./configure-private-reg-integration.hbs.md).

## <a id='prereqs'></a> Prerequisites

Before obtaining credentials, you must have a VAC instance that can create access tokens from
within the VAC UI.

## <a id='repo'></a> Obtain the Helm chart repository for VMware Application Catalog

1. In VMware Application Catalog, navigate to the **Applications** side tab:

2. Search for Helm Charts in your catalog, for example, `MySQL`, and click **Details** for one of the charts you found:

   ![The applications tab in the VAC UI. The catalog is filtered with the search term MySQL and by type Helm chart.](../../images/vac-creds-2.png)

3. Take note of the repository shown under **For Helm CLI >= 3.7.0**. You must include the `oci://` prefix as shown on the page:

   ![A MySQL Helm chart page in the VAC UI. The name of the repository is highlighted in the list of commands required to consume the Helm chart.](../../images/vac-creds-3.png)

## <a id='creds'></a> Obtain pull credentials for VMware Application Catalog

1. In VMware Application Catalog, navigate to the **Registries** side tab:

2. Click on the registry that contains your Helm Charts and container images and record the **Registry URL**.

3. Click the **Registry Credentials** tab.

4. Click **Generate New Credentials**.

   ![The registry credentials tab in the VAC UI.](../../images/vac-creds-6.png)

5. Record the user name and token you are presented with.

   ![Generate new credentials dialog box showing a name and token.](../../images/vac-creds-7.png)

You can now take the repository, user name, and token and use it to configure VAC integration with
the Bitnami services by following the steps in
[Configure Private Registry and VMware Application Catalog Integration for Bitnami Services](./configure-private-reg-integration.hbs.md).
