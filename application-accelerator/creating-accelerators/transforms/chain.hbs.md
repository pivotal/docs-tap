# Chain transform

The `Chain` transform uses function composition to produce its final output.

A chain of **T1** then **T2** then **T3** first applies transform **T1**.
It then applies **T2** to the output of **T1**, and finally applies **T3** to
the output of that.  In other words, **T3** o **T2** o **T1**.

An empty chain acts as function identity.

## <a id="syntax-reference"></a>Syntax reference

```
type: Chain
transformations:
  - <transform>
  - <transform>
  - <transform>
  - ...
condition: <SpEL expression>
```
