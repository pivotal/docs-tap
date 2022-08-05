# ReplaceText transform

The `ReplaceText` transform allows replacing one or several text tokens in files as
they are being copied to their destination. The replacement values are the result
of dynamic evaluation of [SpEL expressions](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#expressions).

This transform is text-oriented and requires knowledge of how to interpret the stream of bytes that make up the file contents into text.
All files are assumed to use `UTF-8` encoding by default, but you can use the [UseEncoding](use-encoding.md) transform upfront to specify a different charset to use on some files.

You can use `ReplaceText` transform in one of two ways:

- To replace several literal text tokens.
- To define the replacement behavior using a single regular expression, in which case the replacement SpEL expression can leverage the regex capturing group syntax.

## <a id="syntax-ref"></a>Syntax reference

Syntax reference for replacing several literal text tokens:

```
type: ReplaceText
substitutions:
  - text: STRING
    with: SPEL-EXPRESSION
  - text: STRING
    with: SPEL-EXPRESSION
  - ..
condition: SPEL-EXPRESSION
```

Syntax reference for defining the replacement behavior using a _single_ regular expression: 

  >**Note:** Regex is used to match the entire document. To match on a per line basis, enable multiline mode by including `(?m)` in the regex.

```yaml
type: ReplaceText
regex:
  pattern: REGULAR-EXPRESSION
  with: SPEL-EXPRESSION
condition: SPEL-EXPRESSION
```

In both cases, the SpEL expression can use the special `#files` helper object.
This enables the replacement string to consist of the contents of an accelerator file.  
See the following [example](#examples).

Another set of helper objects are functions of the form `xxx2Yyyy()` where `xxx` and `yyy` can take
the value `camel`, `kebab`, `pascal`, or `snake`.
For example, `camel2Snake()` enables changing from camelCase to snake_case.

## <a id="examples"></a>Examples

Replacing the hardcoded string `"hello-world-app"` with the value of variable `#artifactId`
in all `.md`, `.xml`, and `.yaml` files.

```
include: ['**/*.md', '**/*.xml', '**/*.yaml']
chain:
  - type: ReplaceText
    substitutions:
      - text: "hello-world-app"
        with: "#artifactId"
```

Doing the same in the `README-fr.md` and `README-de.md` files, which are encoded using
the `ISO-8859-1` charset:

```
include: ['README-fr.md', 'README-de.md']
chain:
  - type: UseEncoding
    encoding: 'ISO-8859-1'
  - type: ReplaceText
    substitutions:
      - text: "hello-world-app"
        with: "#artifactId"
```

Similar to the preceding example, but making sure the value appears as kebab case,
while the entered `#artifactId` is using camel case:

```
include: ['**/*.md', '**/*.xml', '**/*.yaml']
chain:
  - type: ReplaceText
    substitutions:
      - text: "hello-world-app"
        with: "#camel2Kebab(#artifactId)"
```

Replacing the hardcoded string `"REPLACE-ME"` with the contents of
file named after the value of the `#platform` option in `README.md`:

```
include: ['README.md']
chain:
  - type: ReplaceText
    substitutions:
      - text: "REPLACE-ME"
        with: "#files.contentsOf('snippets/install-' + #platform + '.md')"
```

## See also

- [UseEncoding](use-encoding.md)
