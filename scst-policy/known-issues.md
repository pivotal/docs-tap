# Known Issues

## Invalid TUF key 

### Description

TAP 1.3+ installation with Policy controller included fails with the following error:

```bash
panic: Failed to initialize TUF client from  : updating local metadata and targets: 
error updating to TUF remote mirror: tuf: invalid key
```

Policy controller is trying to initialize TUF keys during installation. Due to a breaking change in 
[go-tuf](https://github.com/theupdateframework/go-tuf/issues/379) the initialization fails

### Solution

The policy controller's dependency on go-tuf should be updated to the newer version.

### Workaround

Exclude policy controller package in all profile installations:

```yaml
profile: <profile vaule>
excluded_packages:
  - policy.apps.tanzu.vmware.com
```
