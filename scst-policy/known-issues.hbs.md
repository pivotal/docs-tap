# Supply Chain Security Tools - Policy Controller Known Issues

## TUF key is not valid

### Description

Installation of Policy Controller v1.1.2 fails with the following error message:

```bash
panic: Failed to initialize TUF client from  : updating local metadata and targets:
error updating to TUF remote mirror: tuf: invalid key
```

Policy Controller tries to initialize TUF keys during installation.
The initialization fails because of a breaking change in
go-tuf when using the Official Sigstore TUF root. See [go-tuf](https://github.com/theupdateframework/go-tuf/issues/379) in GitHub.

### Solution

Policy Controller v1.1.3 contains a fix with the updated go-tuf.

### Workarounds

One workaround is to exclude Policy Controller during installation.
Another workaround is to use a self-deployed Sigstore Stack.

- **Option 1:** Exclude the Policy Controller package in all profile installations by adding
  Policy Controller to the `excluded_packages` list in `tap-values.yaml`. Example:

   ```yaml
   profile: PROFILE-VALUE
   excluded_packages:
    - policy.apps.tanzu.vmware.com
   ```

- **Option 2:** Install Sigstore Stack and use the generated TUF system as the mirror and root of
  Policy Controller. For more information, see [Install Sigstore Stack](install-sigstore-stack.hbs.md).