# Known Issues

## Invalid TUF key 

### Description

Installation of policy controller fails with the following error message:

```bash
panic: Failed to initialize TUF client from  : updating local metadata and targets: 
error updating to TUF remote mirror: tuf: invalid key
```

Policy controller tries to initialize TUF keys during installation. Due to a breaking change in 
[go-tuf](https://github.com/theupdateframework/go-tuf/issues/379) the initialization fails.

### Solution

The policy controller's dependency on go-tuf must be updated to the later version.

### Workaround

Exclude policy controller package in all profile installations:

```yaml
profile: <profile vaule>
excluded_packages:
  - policy.apps.tanzu.vmware.com
```
