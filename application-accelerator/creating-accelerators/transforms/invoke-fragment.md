# InvokeFragment transform

The `InvokeFragment` performs transformations defined in an imported *Fragment*,
allowing re-use across accelerators.


## <a id="syntax-ref"></a>Syntax reference

```yaml
type: InvokeFragment
reference: <imported-fragment>
let:  # See Let
  - name: <string>
    expression: <SpEL expression>
  ...
anchor: [<file path>]
```

## <a id="behavior"></a>Behavior

Assuming some fragment `my-fragment` has been imported in the accelerator
(thus exposing the options it defines as options of the current accelerator),
the following construct invokes `my-fragment`:
```yaml
type: InvokeFragment
reference: my-fragment
```

This passes all input files (depending where this invocation sits in the "tree") to
the invoked fragment, which can then manipulate them alongside its own files. The
result of the invocation becomes the result of this transform.

### Variables
At the point of invocation, all currently defined variables are made visible
to the invoked fragment. Thus, if it was `import`-ed in the most straightforward
manner, a fragment defining an option `myOption` ends up defining an option named
`myOption` at the accelerator level, and the value provided by the user ends up
being visible at the time of invocation.

To override a value, or if an imported option has been exposed under a different name,
or not at all, it is possible to use a `let` construct when using `InvokeFragment`.
This behaves as the [`Let`](let.md) transform: for the duration of the fragment
invocation, the variables defined by `let` will have their newly defined values.
Outside the scope of the invocation, the regular model applies.

### Files
The set of files coming from the invoking accelerator and made visible to
the fragment is the set of files that "reach" the point of invocation. 
For example, in the following case
```yaml
include: ["somedir/**"]
chain:
  - type: InvokeFragment
    reference: my-fragment 
```
all files that the fragment invocation "sees" are files in the `somedir/` sub-directory.
If the `my-fragment` has not been written accordingly, this may be problematic.
Chances are that this re-usable fragment expects files to be present at the root of
the project tree and work on them.

To better cope with this typical situation, the `InvokeFragment` transform
exposes the optional `anchor` configuration property. Continuing with the example
above, by using `anchor: somedir`, then all files coming from the current accelerator
will be exposed as if their `path` had the `somedir/` prefix removed. When it comes
to gathering the result of the invocation though, all resulting files are re-introduced
with a prefix prepended to their `path` (this applies to **all** files produced by
the fragment, not just the ones originating from the accelerator).

**Note:** the value of the `anchor` property should neither start nor end with a slash (`/`) character.

## <a id="examples"></a>Examples

Let's start with a full-featured example showcasing the interaction between
the `imports` section and `InvokeFragment`

```yaml
accelerator:
  name: my-accelerator
  options:
    - name: someOption
      dataType: number
  imports:
    - name: my-fragment
      
engine:
  merge:
    - include: ["..."]
    - ...
    - chain:
        - include: ["**/pom.xml"]
        - type: InvokeFragment
          reference: my-fragment
```

Assuming `my-fragment` is defined like so
```yaml
accelerator:
  name: my-fragment
  options:
    - name: indentationLevel
      dataType: number
      defaultValue: 2
transform:
  chain:
    - include: ["**/*.xml"]
    - type: SomeTransform
      ...
```

then users would be presented with two options: `someOption` and `indentationLevel`,
as if `indentationLevel` had been defined in the host accelerator.

Moreover, the behavior of the calling accelerator is exactly as if the body
of the fragment transform had been inserted in-place of `InvokeFragment`:
```yaml
accelerator:
  name: my-accelerator
  options:
    - name: someOption
      dataType: number
    - name: indentationLevel
      dataType: number
      defaultValue: 2
      
engine:
  merge:
    - include: ["..."]
    - ...
    - chain:
        - include: ["**/pom.xml"]
        - chain:
          - include: ["**/*.xml"]
          - type: SomeTransform
            ...

```

Now let's imagine some scenarios to better clarify all configuration properties.

Let's pretend, for some reason, that we don't want to use the value 
entered in the `indentationLevel` option for the fragment, but twice the value
provided for `someOption`. The `InvokeFragment` block could be rewritten like this:
```yaml
    type: InvokeFragment
    reference: my-fragment
    let:
      - name: indentationLevel
        value: '2 * #someOption'
```

Now for some other crazy example to better explain the interactions. If the invocation
in the accelerator looked like this:
```yaml
engine:
  merge:
    - include: ["..."]
    - ...
    - chain:
        - include: ["**/README.md"]
        - type: InvokeFragment
          reference: my-fragment

```

then of course this would have absolutely zero visible effect, since this is
forwarding only `README.md` files to the fragment and the fragment is itself
using a filter on `*.xml` files.

## See also

* [Let](let.md)
* [RewritePath](rewrite-path.md)   
