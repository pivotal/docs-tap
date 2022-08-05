# UseEncoding transform

When considering files in textual form, for example, when doing text replacement with the [ReplaceText transform](replace-text.md),
the engine must decide which [encoding](https://en.wikipedia.org/wiki/Character_encoding) to use.

By default, `UTF-8` is assumed. If any files must be handled differently,
use the `UseEncoding` transform to annotate them with an explicit encoding.

>**Note:** `UseEncoding` returns an error if you apply encoding to files that have already been explicitly configured with a particular encoding.

## <a id="syntax-ref"></a>Syntax reference

```yaml
type: UseEncoding
encoding: <encoding>    # As recognized by the java java.nio.charset.Charset class
condition: <SpEL expression>
```

Supported encoding names include, for example, `UTF-8`, `US-ASCII`, and `ISO-8859-1`.

## <a id="example-usage"></a>Example use

`UseEncoding` is typically used as an upfront transform to, for example, [ReplaceText](replace-text.md)
in a chain:

```yaml
type: Chain   # Or using "Combo"
transformations:
  - type: UseEncoding
    encoding: ISO-8859-1
  - type: ReplaceText
    substitutions:
      - text: "hello"
        with: "#howToSayHello" 
```

## See also

* [ReplaceText](replace-text.md)