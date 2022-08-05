# UniquePath transform

You can use the `UniquePath` transform to ensure there are no `path` conflicts between files transformed.
You can often use this at the tail of a [Chain](chain.md).

## <a id="syntax-ref"></a>Syntax reference

```yaml
type: UniquePath
strategy: <conflict resolution>
condition: <SpEL expression>
```

## <a id="examples"></a>Examples

The following example concatenates the file that was originally named `DEPLOYMENT.md`
to the file `README.md`:

```yaml
chain:
  - merge:
      - include: ['README.md']
      - include: ['DEPLOYMENT.md']
        chain:
          - type: RewritePath
            rewriteTo: "'README.md'"
  - type: UniquePath
    strategy: Append
```

## See also

- `UniquePath` uses a [Conflict Resolution](conflict-resolution.md) strategy to decide
what to do when several input files use the same `path`.
- [Combo](combo.md) implicitly embeds a `UniquePath` after the [Merge](merge.md) defined by 
its `merge` property.
