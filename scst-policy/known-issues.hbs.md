# Known Issues

## Invalid TUF key

### Description

Installation of Policy Controller v1.1.2 fails with the following error message:

```bash
panic: Failed to initialize TUF client from  : updating local metadata and targets:
error updating to TUF remote mirror: tuf: invalid key
```

Policy Controller tries to initialize TUF keys during installation. Because of a breaking change in
go-tuf the initialization fails when using the Official Sigstore TUF root.
For more information, see [go-tuf](https://github.com/theupdateframework/go-tuf/issues/379) in GitHub.

### Solution

The policy controller's dependency on go-tuf must be updated to the later version.

### Workarounds

Exclude Policy Controller during installation or use a self-deployed Sigstore Stack:

- Exclude the Policy Controller package in all profile installations by editing this YAML:

   ```yaml
   profile: PROFILE-VALUE
   excluded_packages:
    - policy.apps.tanzu.vmware.com
   ```

- Install Sigstore Stack and use the generated TUF system as the mirror and root of Policy Controller. For more information, see [Install Sigstore Stack](install-sigstore-stack.hbs.md).