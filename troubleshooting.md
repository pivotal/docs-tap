# Troubleshooting Tanzu Application Platform

This topic describes troubleshooting information for problems with installing Tanzu Application Platform.

## <a id='unauthorized-to-access'></a> Unauthorized to Access Error

An authentication error when installing a package, reconciliation fails.

### Symptom

You run the `tanzu package install` command and receive an `UNAUTHORIZED: unauthorized to access repository:` error.

For example:

```
$ tanzu package install app-live-view -p appliveview.tanzu.vmware.com -v 0.1.0 -n tap-install -f ./app-live-view.yml

Error: package reconciliation failed: vendir: Error: Syncing directory '0':
  Syncing directory '.' with imgpkgBundle contents:
    Imgpkg: exit status 1 (stderr: Error: Checking if image is bundle: Collecting images: Working with registry.pivotal.io/app-live-view/application-live-view-install-bundle@sha256:b13b9ba81bcc985d76607cfc04bcbb8829b4cc2820e64a99e0af840681da12aa: GET https://registry.pivotal.io/v2/app-live-view/application-live-view-install-bundle/manifests/sha256:b13b9ba81bcc985d76607cfc04bcbb8829b4cc2820e64a99e0af840681da12aa: UNAUTHORIZED: unauthorized to access repository: app-live-view/application-live-view-install-bundle, action: pull: unauthorized to access repository: app-live-view/application-live-view-install-bundle, action: pull 
```

> Note: The sample above shows Application Live View as the package, however, this error can occur
 with other packages as well.
 
### Cause

A common cause of this error is that the Tanzu Network credentials needed to access the package
are missing or incorrect. 

### Solution

To fix this problem:

1. Repeat the step to create a secret for the namespace, see [Add the TAP Package Repository](install.md#add-package-repositories).
   Ensure that you provide the correct credentials.

   When the secret has the correct credentials,
   the authentication error should resolve itself and the reconciliation succeed.
   Do not reinstall the package.

2. List the status of the installed packages to confirm that the reconcile has succeeded.
   For instructions, see [Verify the Installed Packages](install.md#verify).

## <a id='existing-service-account'></a> Already Existing Service Account Error

A service account error when installing a package, reconciliation fails.

### Symptom

You run the `tanzu package install` command and receive an `failed to create ServiceAccount resource: serviceaccounts already exists` error.

For example:

```
$ tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v 0.2.0 -n tap-install -f app-accelerator-values.yaml

Error: failed to create ServiceAccount resource: serviceaccounts "app-accelerator-tap-install-sa" already exists 
```

> Note: The sample above shows App Accelerator as the package, however, this error can occur
 with other packges as well.
 
### Cause

A common cause of this error is that the `tanzu package install` command is being executed again after it has failed once. 

### Solution

To fix this problem:

1. Use `tanzu package update` command after the first use of `tanzu package install` command if you want to update the package.
