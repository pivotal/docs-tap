# RewritePath transform

The `RewritePath` transform allows you to change the name and path of files without affecting their content.

## <a id="syntax-ref"></a>Syntax reference

```
type: RewritePath
regex: <string>
rewriteTo: <SpEL expression>
matchOrFail: <boolean>
```

For each input file, `RewritePath` attempts to match its `path` by using
the regular expression (regex) defined by the `regex` property.
If the regex matches, `RewritePath` changes the `path` of the file to the evaluation result of `rewriteTo`.

`rewriteTo` is an expression that has access to the overall
engine model and to variables defined by capturing groups of the regular
expression. Both _named capturing groups_ `(?<example>[a-z]*)` and regular
_index-based_ capturing groups are supported.
`g0` contains the whole match, `g1` contains the first capturing group, and so on.

If the regex doesn't match, the behavior depends on the `matchOrFail` property:

- If set to `false`, which is the default, the file is left untouched.
- If set to `true`, an error occurs. This prevents misconfiguration if you
  expect all files coming in to match the regex. For more information about
  typical interactions between `RewritePath` and `Chain + Include`,
  see the following section, [Interaction with Chain and Include](#interaction-chain-include).
  
The default value for `regex` is the following regular expression,
which provides convenient access to some named capturing groups:

```
^(?<folder>.*/)?(?<filename>([^/]+?|)(?=(?<ext>\.[^/.]*)?)$)
```

Using `some/deep/nested/file.xml` as an example,
the preceding regular expression captures:

- **folder:** The full folder path the file is in. In this example, `some/deep/nested/`.
- **filename:** The full name of the file, including extension _if present_. In this example, `file.xml`.
- **ext:** The last dot and extension in the filename, _if present_. In this example, `.xml`.

The default value for `rewriteTo` is the expression `#folder + #filename`,
which doesn't rewrite paths.

## <a id="examples"></a>Examples

The following moves all files from `src/main/java` to `sub-module/src/main/java`:

```
type: RewritePath
regex: src/main/java/(.*)
rewriteTo: "'sub-module/src/main/java' + #g1"   # 'sub-module/' + #g0 works too
```

The following flattens all files found inside the `sub-path` directory and its subdirectories,
and puts them into the `flattened` folder:

```
type: RewritePath
regex: sub-path/(.*/)*(?<filename>[^/]+)
rewriteTo: "'flattened' + #filename"   # 'flattened' + #g2 would work too
```

The following turns all paths into lowercase:

```
type: RewritePath
rewriteTo: "#g0.toLowerCase()" 
```

## <a id='interaction-chain-include'></a>Interaction with Chain and Include

It's common to define pipelines that perform a `Chain` of transformations
on a subset of files, typically selected by `Include/Exclude`:

```
- include: "**/*.java"
- chain:
    - # do something here
    - # and then here
```

If one of the transformations in the chain is a `RewritePath` operation,
chances are you want the rewrite to apply to _all_ files matched by the `Include`.
For those typical configurations, you can set the `matchOrFail` guard to `true` to
ensure the `regex` you provide indeed matches all files coming in.

## See also

- Use [UniquePath](unique-path.md) to ensure rewritten paths don't clash with
  other files, or to decide which path to select if they do clash.
