# Release notes

This topic contains release notes for Tanzu Application Platform v1.0.

## <a id='1-0'></a> v1.0

**Release Date**: MMMM DD, 2022

### Features

New features and changes in this release:

* Feature 1
* Feature 2

**Updated Components**

The following components have been updated in Tanzu Application Platform v1.0:

- Supply Chain Security Tools
    - **Sign v1.0.0-beta.3:** For more information, see the [Supply Chain Security Tools - Sign release notes](scst-sign/release-notes.md).

### Known issues

This release has the following issues:

* Known issue 1
* Known issue 2

### Security issues

This release has the following security issues:

* Security issue 1
* Security issue 2

### Component release notes

The following components have separate release notes. 

| Component                                | Release notes                                                |
| ---------------------------------------- | ------------------------------------------------------------ |
| Application Accelerator for VMware Tanzu | [Release notes](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/0.5/acc-docs/GUID-release-notes.html) |
| Application Live View for VMware Tanzu   | [Release notes](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/1.0/docs/GUID-release-notes.html) |
| Cloud Native Runtimes for VMware Tanzu   | [Release notes](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-release-notes.html) |
| [Supply Chain Security Tools - Scan]()   | [Release notes](scst-scan/release-notes.md)                  |
| Supply Chain Security Tools - Sign       | [Release notes](scst-sign/release-notes.md)                  |
| Supply Chain Security Tools - Store      | [Release notes](scst-store/release-notes.md)                 |
| VMware Tanzu Build Service               | [Release notes](https://docs.vmware.com/en/Tanzu-Build-Service/1.3/vmware-tanzu-build-service-v13/GUID-release-notes.html) |


## <a id='0-4-0'></a> v0.4.0 beta release

**Release Date**: December 10, 2021

### Features

New features and changes in this release:

**Installation Profiles**

The Full profile now includes Supply Chain Security Tools - Store.

The Dev profile now includes:

- Application Accelerator
- Out of the Box Supply Chain - Testing

The Dev profile no longer includes Image Policy Webhook.

**Updated Components**

The following components have been updated in Tanzu Application Platform v0.4.0:

- Supply Chain Security Tools
    - [Scan v1.0.0](scst-scan/overview.md)
    - [Sign v1.0.0-beta.2](scst-sign/overview.md)
- [Tanzu Application Platform GUI v1.0.0-rc.72](tap-gui/about.md)

**Renamed Components**

Workload Visibility Plugin is renamed Runtime Visibility Plugin.


### Known issues

This release has the following issues:

- **Convention Service:** Convention Service uses a workaround for supporting a self-signed certificate for the private
registry.
For more information, see [Convention Service self-signed registry workaround](convention-service/self-signed-registry-workaround.md).
- **Installing Tanzu Application Platform on Google Kubernetes Engine (GKE):** When installing Tanzu Application Platform on GKE, Kubernetes control plane may be unavailable for several minutes during the install. Package installs can enter the ReconcileFailed state. When API server becomes available, packages try to reconcile to completion.
  - This can happen on newly provisioned clusters which have not gone through GKE API server autoscaling. When GKE scales up an API server, the current Tanzu Application install continues, and any subsequent installs succeed without interruption.
- **Supply Chain Security Tools - Sign:** If all webhook nodes or Pods are evicted by the cluster or scaled down,
the admission policy blocks any Pods from being created in the cluster.
To resolve the issue, delete the `MutatingWebhookConfiguration` and reapply it when the cluster is stable.
For more information, see [Supply Chain Security Tools - Sign known issues](scst-sign/known_issues.md).


## <a id='0-3-0'></a> v0.3.0 beta release

**Release Date**: November 8, 2021

### Features

New features and changes in this release:

**Installation Profiles**

You can now install Tanzu Application Platform through profiles.
The Full profile installs all of the component packages.
The Dev profile installs the packages that a developer needs.

For more information, see [Installation Profiles and Profiles in Tanzu Application Platform v0.3](overview.md#profiles-and-packages) and
[About Tanzu Application Platform Package Profiles](install.md#about-package-profiles).

**New Components**

The following components are new in Tanzu Application Platform v0.3.0:

Tanzu Packages:

- Supply Chain Choreographer for VMware Tanzu:
  - Out of the Box Supply Chain Basic v0.3.0
  - Out of the Box Supply Chain with Testing v0.3.0
  - Out of the Box Supply Chain with Testing and Scanning v0.3.0
  - Out of the Box Templates v0.3.0
- Tanzu Application Platform GUI v0.3.0
  - Workload Visibility Plugin v1.0.0
  - Application Live View Plugin v0.3.0
- Convention Service for VMware Tanzu
  - Spring Boot Convention v0.1.2
- Tanzu Learning Center

**Updated Components**

The following components have been updated in Tanzu Application Platform v0.3.0:

- [Supply Chain Choreographer for VMware Tanzu](scc/about.md)
  - Cartographer v0.0.7
- Supply Chain Security Tools for VMware Tanzu
  - [Scan v1.0.0-beta.2](scst-scan/overview.md)
  - Image Policy Webhook v1.0.0-beta.1
  - [Store v1.0.0-beta.1](scst-store/overview.md)
- Services Toolkit v0.4.0
- [Convention Service for VMware Tanzu](convention-service/about.md)
  - [Developer Conventions](developer-conventions/about.md) v0.3.0
- [Cloud Native Runtimes v1.0.3](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-cnr-overview.html)
- [Application Accelerator for VMware Tanzu v0.4.0](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/0.4/acc-docs/GUID-index.html)
- [Application Live View for VMware Tanzu v0.3.0](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/0.3/docs/GUID-index.html)
- [Tanzu Developer Tools for Visual Studio Code v0.3.0](https://docs-staging.vmware.com/en/VMware-Tanzu-Application-Platform/0.3/tap-0-3/GUID-vscode-extension-about.html)


### Known issues

This release has the following issues:


- **Image Policy Webhook:** If all webhook nodes or Pods are evicted by the cluster or scaled down, the admission policy blocks any Pods from being created in the cluster. To resolve the issue, the administrator needs to kubectl delete the Image Policy Webhook and reapply it once the cluster is stable.
- When you use the `Tanzu Developer Tools for VSCode` extension, delete the workload before performing any of the following actions. This will avoid workload update errors.
    - Switching between the `Live Update` & `Debug` capabilities
    - Disabling `Live Update` & re-starting `Live Update`

    You can do so by performing the following steps:
    1. Click the `Terminal` menu and select the `Run Task` option
    2. Type `tanzuWorkload delete` in the command palette that appears and hit enter
    3. View the Terminal tab to confirm that the Workload has been deleted

- Tanzu App CLI Plugin:
  - *`tanzu apps workload get`*: passing in `--output json` along with and the `--export` flag will return YAML rather than JSON (support for honoring the `--output json` in conjunction with `--export` will be added in the next release).
  - *`tanzu apps workload create/update/apply`*: when the `--wait` flag has been included and the "Do you want to create this workload?" prompt is declined, the command continues to wait rather exit


### Security issues

This release has the following security issue:

**In Learning Center, exported registry credentials are visible across namespaces:**
Because SecretExport CR allows you to export registry credentials to other namespaces, they are
visible to users of those namespaces.
VMware recommends that the registry credentials you export give read-only access to the registry and
have minimal scope within the registry.

## <a id='0-2-0'></a> v0.2.0 beta release

**Release Date**: October 07, 2021

### New features

The following components are new in Tanzu Application Platform v0.2.0:

Tanzu Packages:

- Supply Chain Choreographer for VMware Tanzu
  - Cartographer v0.0.6
  - Default Supply Chain v0.2.0
  - Default Supply Chain with Testing v0.2.0
- Supply Chain Security Tools for VMware Tanzu
  - Scan v1.0.0-beta
  - Image Policy Webhook v1.0.0-beta.0
  - Store v1.0.0-beta.0
- Convention Service for VMware Tanzu
  - Conventions Controller v0.4.2
  - Image Source Controller v0.1.2
  - Developer Conventions v0.2.0
- API Portal for VMware Tanzu v1.0.2
- Service Control Plane Toolkit v0.3.0
- Service Bindings for Kubernetes v0.5.0
- Tanzu Developer Tools for Visual Studio Code v0.2.0

Tanzu CLI Plugins:

- Tanzu Accelerator CLI Plugin v0.3.0
- Tanzu App CLI Plugin v0.2.0
- Tanzu ImagePullSecret CLI Plugin v0.5.0
- Tanzu Package CLI Plugin v0.5.0

The following components have been updated in Tanzu Application Platform v0.2.0

- [VMware Tanzu Build Service v1.3](https://docs.vmware.com/en/Tanzu-Build-Service/1.3/vmware-tanzu-build-service-v13/GUID-index.html)
- [Cloud Native Runtimes v1.0.2](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/1.0/tanzu-cloud-native-runtimes-1-0/GUID-cnr-overview.html)
- [Application Accelerator for VMware Tanzu v0.3.0](https://docs.vmware.com/en/Application-Accelerator-for-VMware-Tanzu/index.html)
- [Application Live View for VMware Tanzu v0.2.0](https://docs.vmware.com/en/Application-Live-View-for-VMware-Tanzu/0.2/docs/GUID-index.html)


### Known issues

This release has the following issues:

- If your install workflow involves [Carvel imgpkg](https://github.com/vmware-tanzu/carvel-imgpkg), use version.
  v0.19.0 or later to avoid auth errors.
- If package installation fails, use `tanzu package installed update` with the `--install` flag to continue installation.
- When you use the `Tanzu Developer Tools for VSCode` extension,
  delete the workload before performing any of the following actions. This will avoid workload update errors.
    - Switching between the `Live Update` & `Debug` capabilities
    - Disabling `Live Update` & re-starting `Live Update`

    You can do so by performing the following steps:
    1. Click the `Terminal` menu and select the `Run Task` option
    2. Type `tanzuWorkload delete` in the command palette that appears and hit enter
    3. View the Terminal tab to confirm that the Workload has been deleted

## <a id='0-1-0'></a> v0.1.0 beta release

**Release Date**: September 1, 2021

Initial release
