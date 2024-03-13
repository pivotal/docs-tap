# Migrate to the Python Cloud Native Buildpack

This topic tells you how to migrate your Python app from using a Cloud Foundry buildpack for Tanzu Application Service
(commonly known as TAS for VMs) to using a Cloud Native Buildpack for Tanzu Application Platform (commonly known as TAP).

<!-- do users do all these sections in order or do they choose the section for their use case -->

## <a id="versions"></a> Install a specific Python version

The following table compares how Tanzu Application Service and Tanzu Application Platform deals with
installing specific versions.

| Feature                                                                                         | Tanzu Application Service | Tanzu Application Platform |
| ----------------------------------------------------------------------------------------------- | ------------------------- | -------------------------- |
| Detects version from `runtime.txt`                                                              | ✅                        | ❌                         |
| Override app-based version detection (see [Configure the environment variable](#env-var) below) | ❌                        | Use `$BP_CPYTHON_VERSION`  |

### <a id="env-var"></a> Configure the environment variable

In Tanzu Application Platform, set the `$BP_CPYTHON_VERSION` environment variable to specify
which version of CPython 3 to install.

Example `spec` section from a `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_CPYTHON_VERSION
       value: "3.12.1"
```

## <a id="pip-version"></a> Install a specific pip version

Both Tanzu Application Service and Tanzu Application Platform Python buildpacks provide an
extra pip dependency. You can configure this dependency using the `$BP_PIP_VERSION` environment variable,
just `$BP_CPYTHON_VERSION`.
<!-- clarify -->

## <a id="pipenv-version"></a> Install a specific Pipenv version

Tanzu Application Service buildpack does not support selecting a version.
However, for the Tanzu Application Platform Python buildpack, you con configure the Pipenv version
using the `$BP_PIP_VERSION` environment variable.

## <a id="start-command"></a> Start Command

The Tanzu Application Service buildpack does not generate a default start command for your apps.
However, the Tanzu Application Platform Python buildpack sets the default start command to run the
Python read-eval-print loop (REPL) at launch.

For production apps, use a Procfile to specify the start command for both Tanzu Application Service
and Tanzu Application Platform.
For more information about Procfile on Tanzu Application Platform, see the
[Tanzu Buildpacks documentation](https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-procfile-procfile-buildpack.html).
