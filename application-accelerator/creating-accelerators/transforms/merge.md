# Merge transform

The `Merge` transform feeds a copy of its input to several other transforms and
_merges_ the results together using set union.

A `Merge` of **T1**, **T2**, and **T3** applied to input **I** results in **T1(I) ∪ T2(I) ∪ T3(I)**.

An empty merge produces nothing (∅).

## <a id="syntax-reference"></a>Syntax reference

```
type: Merge
sources:
  - <transform>
  - <transform>
  - <transform>
  - ...
condition: <SpEL expression>
```

## See also

* [Combo](combo.md) is often used to express a `Merge` **and** other transformations in a
shorthand syntax.