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

### <a id="variables"></a>Variables

At the point of invocation, all currently defined variables are made visible
to the invoked fragment. Therefore, if it was `import`-ed in the most straightforward
manner, a fragment defining an option `myOption` is defining an option named
`myOption` at the accelerator level, and the value provided by the user is visible at the time of invocation.

To override a value, or if an imported option has been exposed under a different name,
or not at all, you can use a `let` construct when using `InvokeFragment`.
This behaves as the [`Let`](let.md) transform: for the duration of the fragment
invocation, the variables defined by `let` now have their newly defined values.
Outside the scope of the invocation, the regular model applies.


### <a id="files"></a/>Files
The set of files coming from the invoking accelerator and made visible to
the fragment is the set of files that "reach" the point of invocation.
For example, in the following case:

```yaml
include: ["somedir/**"]
chain:
  - type: InvokeFragment
    reference: my-fragment
```

All files that the fragment invocation "sees" are files in the `somedir/` subdirectory.
If the `my-fragment` has not been written accordingly, this can be problematic.
Chances are that this re-usable fragment expects files to be present at the root of
the project tree and work on them.

To better cope with this typical situation, the `InvokeFragment` transform
exposes the optional `anchor` configuration property. Continuing with the earlier example,
by using `anchor: somedir`, then all files coming from the current accelerator
are exposed as if their `path` had the `somedir/` prefix removed. When it comes
to gathering the result of the invocation though, all resulting files are re-introduced
with a prefix prepended to their `path` (this applies to **all** files produced by
the fragment, not just the ones originating from the accelerator).

**Note:** the value of the `anchor` property must not start nor end with a slash (`/`) character.

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

Then users will be presented with two options: `someOption` and `indentationLevel`,
as if `indentationLevel` was defined in the host accelerator.

Moreover, the behavior of the calling accelerator is exactly as if the body
of the fragment transform was inserted in-place of `InvokeFragment`:

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

Now you can imagine some scenarios to better clarify all configuration properties.

You can pretend, for some reason, that you don't want to use the value
entered in the `indentationLevel` option for the fragment, but twice the value
provided for `someOption`. The `InvokeFragment` block can be rewritten such as this:

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

Then there is absolutely zero visible effect, because this is
forwarding only `README.md` files to the fragment and the fragment is itself
using a filter on `*.xml` files.

## See also

- [Let](let.md)
- [RewritePath](rewrite-path.md)   
