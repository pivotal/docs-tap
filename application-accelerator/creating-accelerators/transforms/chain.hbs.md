# Chain transform

The `Chain` transform uses function composition to produce its final output.

## <a id="syntax-reference"></a>Syntax reference

``` console
type: Chain
transformations:
  - <transform>
  - <transform>
  - <transform>
  - ...
applyTo: [<ant pattern>]
condition: <SpEL expression>
```

## <a id="behavior"></a>Behavior

A chain of **T1** then **T2** then **T3** first applies transform **T1**.
It then applies **T2** to the output of **T1**, and finally applies **T3** to
the output of that.  In other words, **T3** o **T2** o **T1**.

An empty chain acts as function identity.

If the optional `applyTo` property is set, then the chained transformations are only
applied to files with paths that match the `applyTo` patterns. Files with paths that don't match
are left untouched and merged back with the other results to form the final result of the
`Chain` transform.
