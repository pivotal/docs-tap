# Use the Application Accelerator Visual Studio Code extension

This topic describes how to use the Application Accelerator Visual Studio Code extension to explore
and generate projects from the defined accelerators in Tanzu Application Platform (commonly known as TAP) using VS Code.

The Application Accelerator Visual Studio Code extension lets you explore and generate projects
from the defined accelerators in Tanzu Application Platform using VS Code.

## <a id="dependencies"></a> Dependencies

- To use the VS Code extension, the extension must access the Tanzu Developer Portal URL.
  For information about how to retrieve the Tanzu Developer Portal URL, see
  [Retrieving the URL for the Tanzu Developer Portal](#fqdn-tap-gui-url).

- (Optionally) To use Git repository provisioning during project creation in the VS Code extension,
you must enable GitHub repository creation in the Application Accelerator plug-in.
For more information, see [Create an Application Accelerator Git repository during project creation](../tap-gui/plugins/application-accelerator-git-repo.hbs.md).

## <a id="vs-code-app-accel-install"></a> Installation

Use the following steps to install the Application Accelerator Visual Studio extension:

1. Sign in to VMware Tanzu Network and download the "Tanzu App Accelerator Extension for Visual
   Studio Code" file from the product page for [VMware Tanzu Application
   Platform](https://network.tanzu.vmware.com/products/tanzu-application-platform).

2. Open VS Code.

    **Option 1:**

    1. From the Command Palette (cmd + shift + P), run "Extensions: Install from VSIX...".

    2. Select the extension file **tanzu-app-accelerator-<EXTENSION_VERSION>.vsix**.

    **Option 2:**

    3. Select the **Extensions** tab: ![Shows the extensions tab icon.](../images/vscode-install2.png)

    4. Select `Install from VSIX…` from the overflow menu.

        ![The VS Code interface extensions page overflow menu is open with Install from VSIX... highlighted.](../images/vscode-install3v2.png)

## <a id="configure-the-extension"></a> Configure the extension

Before using the extension, you need follow the next steps:

1. Go to VS Code settings - click **Code > Preferences > Settings > Extensions > Tanzu App Accelerator**.

2. Look for the setting `Tap Gui Url`.

3. Add the Tanzu Application Platform GUI URL.

   ![The Server Configure Setting page is open with the acc server URL highlighted.](../images/app-accelerators-vscode-settings-tap-gui-url.png)

    An example URL: `https://tap-gui.myclusterdomain.myorg.com`. If you have access to the Tanzu
    Application Platform cluster that is running the Tanzu Developer Portal, you can run the
    following command to determine the fully-qualified domain name:

    ```console
    kubectl get httpproxy tap-gui -n tap-gui
    ```

## <a id="using-the-extension"></a> Using the extension

After adding the `Tap Gui Url` you can explore the defined accelerators
accessing the Application Accelerator extension icon:

![The explorer panel is open, the TIMELINE drop-down is selected, and the Demo Types icon is highlighted.](../images/app-accelerators-vscode-icon.png)

Choose any of the defined accelerators, fill the options and click  the `generate project`

![The accelerator tab is open to the Hello Fun accelerator form. The text boxes display example text and the Generate Project button is highlighted.](../images/app-accelerators-vscode-form.png)

## <a id="fqdn-tap-gui-url"></a> Retrieving the URL for the Tanzu Developer Portal

If you have access to the Tanzu Application Platform cluster that is running the Tanzu Application
Platform GUI, you can run the following command to determine the fully-qualified domain name:

```console
kubectl get httpproxy tap-gui -n tap-gui
```

With an expected response of something similar to:

```console
NAME      FQDN                                      TLS SECRET     STATUS   STATUS DESCRIPTION
tap-gui   tap-gui.tap.tapdemo.myorg.com             tap-gui-cert   valid    Valid HTTPProxy
```

## <a id="dl-inst-ss-certs"></a>Download and Install Self-Signed Certificates from the Tanzu Developer Portal

To enable the Application Accelerator extension for VS Code to communicate with a Tanzu Developer Portal instance that is secured using TLS, you must download and install the certificates locally.

### Prerequisites

[yq](https://github.com/mikefarah/yq) is required to process the YAML output.

### Procedure

1. Find the name of the Tanzu Developer Portal certificate. The name of the certificate
might look different to the following example.

    ```console
    kubectl get secret -n cert-manager
    ```

    ```console
    NAME                                           TYPE                             DATA   AGE
    canonical-registry-secret                      kubernetes.io/dockerconfigjson   1      18d
    cert-manager-webhook-ca                        Opaque                           3      18d
    postgres-operator-ca-certificate               kubernetes.io/tls                3      18d
    tanzu-sql-with-mysql-operator-ca-certificate   kubernetes.io/tls                3      18d
    tap-ingress-selfsigned-root-ca                 kubernetes.io/tls                3      18d <------- This is the certificate that is needed
    ```

2. Download the certificate:

    ```console
    kubectl get secret -n cert-manager tap-ingress-selfsigned-root-ca -o yaml | yq '.data."ca.crt"' | base64 -d > ca.crt
    ```

3. Install the certificate on your local system and fully restart any applications that uses
the certificate. After restarting, the application uses the certificate to communicate with the
endpoints using TLS. For more information, see [Installing a root CA certificate in the trust store](https://ubuntu.com/server/docs/security-trust-store) in the Ubuntu documentation.

    macOS
    : Run:

      ```console
      sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ca.crt
      ```

    Windows
    : Complete the following steps:

      1. Use Windows Explorer to navigate to the directory where the certificate was downloaded and click on the certificate.
      2. In the Certificate window, click **Install Certificate...**.
      3. Change the **Store Location** from **Current User** to **Local Machine**. Click **Next**.
      4. Select **Place all certificates in the following store**, click **Browse**, and select **Trusted Root Certification Authorities**
      5. Click **Finish**.
      6. A pop-up window stating **The import was successful.** is displayed.
