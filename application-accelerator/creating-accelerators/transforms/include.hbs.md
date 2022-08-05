# Include transform

The `Include` transform retains files based on their `path`, letting in _only_ those files
whose path matches at least one of the configured `patterns`.
The contents of files, and any of their other characteristics, are unaffected.

`Include` is a basic building block seldom used as is, which
makes sense if composed inside a [Chain](chain.md) or a [Merge](merge.md).
It is often more convenient to leverage the shorthand notation offered
by [Combo](combo.md).

## <a id="syntax-ref"></a>Syntax reference

```
type: Include
patterns: [<ant pattern>]
condition: <SpEL expression>
```

## <a id="examples"></a>Examples

```
type: Chain
transformations:
  - type: Include
    patterns: ["**/*.yaml"]
  - type: # At this point, only yaml files are affected
```

## See also

* [Exclude](exclude.md)
* [Combo](combo.md)   
