# Let transform

The `Let` transform wraps another transform, creating a new scope
that extends the existing scope.

SpEL expressions inside the `Let` can access variables
from both the existing scope and the new scope.

>**Note:** Variables defined by the `Let` should not shadow existing variables. If they do,
those existing variables won't be accessible.

## <a id="syntax-reference"></a>Syntax reference

```
type: Let
symbols:
- name: <string>
  expression: <SpEL expression>
- ...
in: <transform> # <- new symbols are visible in here
```

## <a id="execution"></a>Execution

The `Let` adds variables to the new scope by computation of  
[SpEL expressions](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#expressions).

```
engine:
  let:
  - name: <string>
    expression: <SpEL expression>
  - ...
```

Both a `name` and an `expression` must define each symbol where:

- `name` must be a camelCase string name. If a let _symbol_ happens to have the same name as a symbol already defined in the surrounding scope, then the local symbol shadows the symbol from the surrounding scope. This makes the variable from the surrounding scope inaccessible in the remainder of the `Let` but doesn't alter its original value.

- `expression` must be a valid SpEL expression expressed as a YAML string.
Be careful when using the `#` symbol for variable evaluation, because this is the comment
marker in YAML. So SpEL expressions in YAML must enclose strings
in quotes or rely on block style. For more information about block style, see [Block Style Productions](https://yaml.org/spec/1.2.2/#chapter-8-block-style-productions).

Symbols defined in the `Let` are evaluated in the new scope in the order they are defined. 
This means that symbols lower in the list can make use of the variables defined higher in the 
list but not the other way around.

## See also

- [Combo](combo.md) provides a way to declare a `Let` scope and other transforms in a short syntax.
