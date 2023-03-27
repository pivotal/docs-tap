# Provenance transform

The `Provenance` transform is a special transform used to generate a manifest
detailing the run of the accelerator engine, for later bookkeeping purposes.

## <a id="syntax-reference"></a>Syntax reference

``` console
type: Provenance
condition: <SpEL expression>
```

The `Provenance` transform should typically be added as a child to the top-most
transform (which is typically a `Merge` or a `Chain`, maybe via `Combo`).
 
## <a id="behavior"></a>Behavior
The `Provenance` transform is special in that it ignores its input and always outputs
a single resource named `accelerator-info.yaml` whose contents looks like this
(depending on invocation scenario, some pieces of data may not be present):

```
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
