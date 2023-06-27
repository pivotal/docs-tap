# Loop transform

This topic tells you about the Application Accelerator `Loop` transform in Tanzu Application Platform (commonly known as TAP).

The `Loop` transform iterates over elements in a list and applies the provided transform for every
element in that list.

When `doAsMerge` is used, a copy of the `Loop` transform's input is passed to each transform and the
outputs from each transform are merged using a set union.

When `doAsChain` is used, each transform is executed sequentially, receiving the previous
transform's output as its input. The first transform is to receive the `Loop` transform's input as
its input.

## <a id="syntax-reference"></a>Syntax reference

``` console
type: Loop
on: <SpEL expression>
var: <string>
index: <string>
doAsChain: <transform>
doAsMerge: <transform>
```

- `on` must be a SpEL expression that evaluates a list. This is the list of elements to be
  iterated over.
- `var` is the name of the variable to be assigned to the current element on each iteration.
  (optional)
- `index` is the variable's name to be assigned to the index of the current element on
  each iteration. (optional)
- `doAsMerge` is the transform to be executed for every element in the list, on a copy of
  the `Loop` transform's input.
- `doAsChain` is the transform to be executed for every element in the list, passing the
  output of the transform as input to the next transform.

Both `var` and `index` are optional.

Only one of the `doAsMerge` or `doAsChain` variables is to be used in a `Loop` transform.

## <a id="behavior"></a>Behavior

Consider the following when choosing `doAsMerge` or `doAsChain`:

`doAsMerge` executes the transform on the same input files for every iteration and merges the
resulting outputs. It is best suited when a transform is executed multiple times on the
same input and does not have conflicts.

`doAsChain` executes the transform on the initial input files once and then passes the resulting
output to the second iteration and so on. It is best suited when a transform must detect any changes
that occurred in the previous iteration.

## <a id="examples"></a>Examples

Create a new directory for every module in `modules` (a list of strings) based on the contents of
the "template" directory.

``` console
type: Loop
on: "#modules"
var: m
doAsMerge:
  type: RewritePath
  regex: "template/(.*)"
  rewriteTo: "#m + '/' + #g1"
```

Add every artifactId in `artifacts` (a list of strings) as a Spring plug-in.

``` console
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

You can use `Loop` in combination with custom types, for example:

```yaml
accelerator:
  types:
    - name: MavenPlugin
      struct:
        - name: groupId
        - name: artifactId
        - name: version
  options:
    - name: pluginsToAdd
      dataType: [MavenPlugin] # End users will be able to enter a collection of GAV tuples
engine:
  include: [pom.xml]
  chain:
    - type: Loop
      on: pluginsToAdd # Iterate on the pluginsToAdd collection
      var: p           # The variable "p" will contain each tuple in turn
      doAsChain:       # Will apply the second execution to the result of the first, and so on...
        type: OpenRewriteRecipe
        recipe: org.openrewrite.maven.AddPlugin
        options:
          groupId:    "#p['groupId']"
          artifactId: "#p['artifactId']"
          version:    "#p['version']"
```

For more information, see [Using Custom Types](../custom-types.hbs.md).
