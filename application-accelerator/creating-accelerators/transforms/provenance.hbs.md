# Provenance transform

This topic tells you about the Application Accelerator `Provenance` transform in Tanzu Application Platform (commonly known as TAP).

The `Provenance` transform is a special transform used to generate a file that
provides details of the accelerator engine transform.

## <a id="syntax-reference"></a>Syntax reference

``` console
type: Provenance
condition: <SpEL expression>
```

The `Provenance` transform is added as a child to the top-most
transform, which is usually a `Merge` or a `Chain`, using a `Combo`.

## <a id="behavior"></a>Behavior

The `Provenance` transform ignores its input and outputs
a single resource named `accelerator-info.yaml`. For example:

``` console
id: <unique GUID of invocation>
timestamp: <timestamp in RFC3339 format>
username: <captured username of user triggering the run>
source: <client environment from which accelerator was run>
accelerator:
  name: <name of registered accelerator>
  git:
    url: <git repository location>
    ref:
      branch: <branch name> or
      tag: <tag name> or
      commit: <specific requested commit>
    subPath: <optional subpath inside the repo>
    commit: <actual SHA the branch or tag pointed to>
fragments:
  - name: <name of registered fragment 1>
    git:
      url: <git repository location>
      ref:
        branch: <branch name> or
        tag: <tag name> or
        commit: <specific requested commit>
      subPath: <optional subpath inside the repo>
      commit: <actual SHA the branch or tag pointed to>
  - name: <name of registered fragment 2>
    git:
      url: <git repository location>
      ref:
        branch: <branch name> or
        tag: <tag name> or
        commit: <specific requested commit>
      subPath: <optional subpath inside the repo>
      commit: <actual SHA the branch or tag pointed to>
  - ...
options:
  - name: <option name>
    value: <option value>
  - name: <option name>
    value: <option value>
```

> **Note** Depending on the invocation scenario, some pieces of data might not be present.
