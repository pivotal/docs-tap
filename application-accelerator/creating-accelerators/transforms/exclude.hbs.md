# Exclude transform

This topic tells you about the Application Accelerator `Exclude` transform in Tanzu Application Platform (commonly known as TAP).

The `Exclude` transform retains files based on their `path`, allowing all files except ones with a path that matches at least one of the configured `patterns`. The contents of files, and any of their other characteristics are unaffected.

`Exclude` is a basic building block seldom used _as is_, which makes sense
if composed inside a [Chain](chain.md) or a [Merge](merge.md).
It is often more convenient to leverage the shorthand notation offered
by [Combo](combo.md).

## <a id="syntax-reference"></a>Syntax reference

```
type: Exclude
patterns: [<ant pattern>]
condition: <SpEL expression>
```

## <a id="examples"></a>Examples

```
type: Chain
transformations:
  - type: Exclude
    patterns: ["**/secret/**"]
  - type: # At this point, no file matching **/secret/** is affected.
```

## See also

* [Include](include.md)
* [Combo](combo.md)
