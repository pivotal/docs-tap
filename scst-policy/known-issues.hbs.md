# Known Issues

## Invalid TUF key

### Description

Installation of policy controller fails with the following error message:

```bash
panic: Failed to initialize TUF client from  : updating local metadata and targets:
error updating to TUF remote mirror: tuf: invalid key
```

Policy controller tries to initialize TUF keys during installation. Due to a breaking change in
[go-tuf](https://github.com/theupdateframework/go-tuf/issues/379) the initialization fails when using the Official Sigstore TUF root.

### Solution

The policy controller's dependency on go-tuf must be updated to the later version.

### Workarounds

Excluding Policy Controller during install or using a self-deployed Sigstore Stack.

1. Exclude policy controller package in all profile installations:
  ```yaml
  profile: <profile vaule>
  excluded_packages:
    - policy.apps.tanzu.vmware.com
  ```

2. Install Sigstore Stack and use the generated TUF system as the mirror and root of the Policy Controller. For more infomation, see [Install Sigstore Stack](./install-sigstore-stack.hbs.md).