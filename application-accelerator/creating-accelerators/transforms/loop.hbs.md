# Loop transform

The `Loop` transform iterates over elements in a list and applies the provided transform for every element in the list.

When `doAsMerge` is used, a copy of the `Loop` transform's input will be passed to each transform and the outputs from
each transform will be merged together using set union.

When `doAsChain` is used, each transform will be executed sequentially, receiving as input the output of the previous
transform. The first transform will receive as input the `Loop` transform's input.

## <a id="syntax-reference"></a>Syntax reference

```
type: Loop
on: <SpEL expression>
var: <string>
index: <string>
doAsChain: <transform>
doAsMerge: <transform>
```

- `on` must be a SpEL expression that evaluates to a list. This will be the list of elements that will be iterated over.
- `var` is the name of the variable that will be assigned the current element on each iteration. (optional)
- `index` is the name of the variable that will be assigned the index of the current element on each iteration. (optional)
- `doAsMerge` is the transform that will be executed for every element in the list, on a copy of the `Loop` transform's
  input.
- `doAsChain` is the transform that will be executed for every element in the list, passing the output of the transform
  as input to the next transform.

Both `var` and `index` are optional.

Only one of `doAsMerge` or `doAsChain` may be used in a `Loop` transform.

## <a id="behavior"></a>Behavior

Consider the following when choosing which of `doAsMerge` or `doAsChain` is appropriate for your use case.

`doAsMerge` executes the transform on the same input files for every iteration and merges the resulting outputs. It is
best suited when a transform should be executed multiple times on the same input and the outputs will not conflict.

`doAsChain` executes the transform on the initial input files once and then passes the resulting output to the second
iteration and so on. It is best suited when a transform needs to be aware of any changes that occurred in the previous
iteration.

## <a id="examples"></a>Examples

Create a new directory for every module in `modules` (a list of strings) based on the contents of the "template" directory.

```
type: Loop
on: "#modules"
var: m
doAsMerge:
  type: RewritePath
  regex: "template/(.*)"
  rewriteTo: "#m + '/' + #g1"
```

Add every artifactId in `artifacts` (a list of strings) as a Spring plugin.

```
type: Loop
on: "#artifacts"
var: a
doAsChain:
  type: OpenRewriteRecipe
  recipe: org.openrewrite.maven.AddPlugin
  options:
    groupId: "'org.springframework'"
    artifactId: "#a"
    version: "'5.7.1'"
```