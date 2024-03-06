# Migrate Python buildpack

<!-- do users do all these sections in order or do they choose the section for their use case -->

## Install a specific Python version

| Feature                                                                     | TAS | TAP                         |
| --------------------------------------------------------------------------- | --- | --------------------------- |
| Detects version from `runtime.txt`                                          | ✅  | ❌                          |
| Override app-based version detection (see Using environment variable below) | ❌  | Using `$BP_CPYTHON_VERSION` |

### Using environment variable

In TAP, users can set the `$BP_CPYTHON_VERSION` environment variable to specify which version of
CPython 3 should be installed.

Here’s an excerpt from the spec section of a sample `workload.yaml`:

```yaml
---
spec:
  build:
    env:
    - name: BP_CPYTHON_VERSION
       value: "3.12.1"
```

## Install a specific Pip version

Both TAS and TAP Python buildpacks provide an additional pip dependency whose version can be configured
using the `$BP_PIP_VERSION` environment variable, just `$BP_CPYTHON_VERSION`.

## Install a specific Pipenv version

TAS buildpack does not support selecting a version, but in TAP Python buildpack, the Pipenv version
can be configured using the `$BP_PIP_VERSION` environment variable.

## Start Command

The TAS Python buildpack does not generate a default start command for your apps, whereas the TAP
buildpack sets the default start command to run the Python REPL (read-eval-print loop) at launch.

A production app is expected to use a Procfile to specify their own start command in both cases.
For more information about Procfile on TAP, see https://docs.vmware.com/en/VMware-Tanzu-Buildpacks/services/tanzu-buildpacks/GUID-procfile-procfile-buildpack.html
