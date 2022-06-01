# Introduction to transforms

When the accelerator engine executes the accelerator, it produces
a ZIP file containing a set of files. The purpose of the `engine` section is to describe
precisely how the contents of that ZIP file is created.

  ```yaml
  accelerator:
    ...
  engine:
    <transform-definition>
  ```

## <a id="why-transforms"></a>Why transforms?

When you run an accelerator, the contents of the accelerator produce the result.
It is made up of subsets of the files taken from the accelerator `<root>` directory and
its subdirectories. You can copy the files as is, or transform them in a number of ways before
adding them to the result.

As such, the YAML notation in the `engine` section defines a transformation that takes as
input a set of files (in the `<root>` directory of the accelerator) and produces
as output another set of files, which are put into the ZIP file.

Every transform has a `type`. Different types of transform have different behaviors and
different YAML properties that control precisely what they do.

In the following example, a transform of type `Include` is a filter.
It takes as input a set of files and produces as output a subset of those files, retaining only
those files whose path matches any one of a list of `patterns`.

If the accelerator has something like this:

  ```yaml
  engine:
    type: Include
    patterns: ['**/*.java']
  ```

This accelerator produces a ZIP file containing all the `.java` files from the accelerator
`<root>` or its subdirectories but nothing else.

Transforms can also operate on the contents of a file, instead of merely selecting it for inclusion.

For example:

  ```yaml
  type: ReplaceText
  substitutions:
  - text: hello-fun
    with: "#artifactId"
  ```

This transform looks for all instances of a string `hello-fun` in all its
input files and replaces them with an `artifactId`, which is the result of
evaluating a SpEL expression.

## <a id="combine-transforms"></a>Combining transforms

From the preceding examples, you can see that transforms such as `ReplaceText`
and `Include` are too "primitive" to be useful by themselves. They are meant to be the building blocks of more complex accelerators.

To combine transforms, provide two operators called `Chain` and `Merge`. These operators
are recursive in the sense that they compose a number of child transforms to create
a more complex transform. This allows building arbitrarily deep and complex trees of
nested transform definitions.

The following example shows what each of these two operators does and how they are used together.

### <a id="chain"></a>Chain

Because transforms are functions whose input and output are of the same type (a set of files),
you can take the output of one function and feed it as input to another. This is what `Chain` does.
In mathematical terms, `Chain` is _function composition_.

You might, for example, want to do this with the `ReplaceText` transform.
Used by itself, it replaces text strings in *all* the accelerator input files. What if
you wanted to apply this replacement to only a subset of the files? You can use an `Include`
filter to select only a subset of files of interest and chain that subset into `ReplaceText`.

For example:

  ```yaml
  type: Chain
  transformations:
  - type: Include
    patterns: ['**/pom.xml']
  - type: ReplaceText
    substitutions:
    - text: hello-fun
      with: "#artifactId"
  ```

### <a id="merge"></a>Merge

Chaining `Include` into `ReplaceText` limits the scope of `ReplaceText` to a subset of the input files.
Unfortunately, it also eliminates all other files from the result.

For example:

  ```yaml
  engine:
    type: Chain
    transformations:
    - type: Include
      patterns: ['**/pom.xml']
    - type: ReplaceText
      substitutions:
      - text: hello-fun
        with: "#artifactId"
  ```

The preceding accelerator produces a ZIP file that only contains `pom.xml` files and nothing else.

What if you also wanted other files in that ZIP? Perhaps you want to include some Java files as well,
but don't want to apply the same text replacement to them.

You might be tempted to write something such as:

  ```yaml
  engine:
    type: Chain
    transformations:
    - type: Include
      patterns: ['**/pom.xml']
    - type: ReplaceText
      ...
    - type: Include  
      patterns: ['**/*.java']
  ```

However, that doesn't work. If you chain non-overlapping includes together like this,
the result is an empty result set. The reason is that the first include retains only `pom.xml` files. These files
are fed to the next transform in the chain. The second include only retains `.java` files, but because there are
only `pom.xml` files left in the input, the result is an empty set.

This is where `Merge` comes in. A `Merge` takes the outputs of several transforms executed independently
on the same input sourceset and combines or merges them together into a single sourceset.

For example:

  ```yaml
  engine:
    type: Merge
    sources:
    - type: Chain
      - type: Include
        patterns: ['**/pom.xml']
      - type: ReplaceText
        ...
    - type: Include
      patterns: ['**/*.java']
  ```

The preceding accelerator produces a result that includes both:

- The `pom.xml` files with some text replacements applied to them.
- Verbatim copies of all the `.java` files.

## <a id="short-notation"></a>Shortened notation

It becomes cumbersome and verbose to combine transforms such as `Include`, `Exclude`,
and `ReplaceText` with explicit `Chain` and `Merge` operators. Also, there is
a common composition pattern to using them. Specifically, select an interesting subset using includes/excludes, apply a chain of additional transformations
to the subset, and merge the result with the results of other transforms.

That is why there is a swiss army knife transform (known the `Combo` transform)
that combines `Include`, `Exclude`, `Merge`, and `Chain`.

For example:

  ```yaml
  type: Combo
  include: ['**/*.txt', '**/*.md']
  exclude: ['**/secret/*']
  merge:
  - <transform-definition>
  - ...
  chain:
  - <transform-definition>
  - ...
  ```

Each of the properties in this `Combo` transform is optional if you specify
at least one.

Notice how each of the properties `include`, `exclude`, `merge`, and `chain` corresponds
to the name of a type of transform, only spelled with lowercase letters.

If you specify only one of the properties, the `Combo` transform
behaves exactly as if you used that type of transformation by itself.

For example:

  ```yaml
  merge: ...
  ```

Behaves the same as:

  ```yaml
  type: Merge
  sources: ...
  ```

When you do specify multiple properties at the same time, the `Combo` transform
composes them together in a "logical way" combining `Merge` and `Chain` under
the hood.

For example:

  ```yaml
  include: ['**/*.txt', '**.md']
  chain:
  - type: ReplaceText
    ...
  ```

Is the same as:

  ```yaml
  type: Chain
  transformations:
  - type: Include
    patterns: ['**/*.txt', '**.md']
  - type: Chain
    trasformations:
    - type: ReplaceText
      ...
  ```

When you use all of the properties of `Combo` at once:

  ```yaml
  include: I
  exclude: E
  merge:
  - S1
  - S2
  chain:
  - T1
  - T2
  ```

This is equivalent to:

  ```yaml
  type: Chain
  transformations:
  - type: Include
    patterns: I
  - type: Exclude
    patterns: E
  - type: Merge
    sources:
    - S1
    - S2
  - T1
  - T2
  ```

[//]: # (TODO: Add a boxes and arrows 'picture' of the above combo transform?)

### <a id="combo-of-one"></a>A Combo of one?

You can use the `Combo` as a convenient shorthand for a single
type of annotation.  However, though you *can* use it to combine multiple types,
and though that is its main purpose, that doesn't mean you *have* to.

For example:

  ```yaml
  include: ["**/*.java"]
  ```

This is a `Combo` transform (remember, `type: Combo` is optional), but rather than combining
multiple types of transforms, it only defines the `include` property. This makes it behaves exactly as an `Include` transform:

  ```yaml
  type: Include
  patterns: ["**/*.java"]
  ```

It is usually more convenient to use a `Combo` transform to denote a single `Include`,
`Exclude`, `Chain`, or `Merge` transform, because it is slightly shorter to write it as a `Combo`
than writing it with an explicit `type:` property.

## <a id="common-pattern"></a>A common pattern with merge transforms

It is a common and useful pattern to use merges with overlapping contents to apply a
transformation to a subset of files and then replace these changed files within a bigger context.

For example:

  ```yaml
  engine:
    merge:
    - include: ["**/*"]
    - include: ["**/pom.xml"]
      chain:
      - type: ReplaceText
          subsitutions: ...
  ```

The preceding accelerator copies all files from accelerator `<root>` while applying some
text replacements only to `pom.xml` files. Other files are copied verbatim. 

Here in more detail is how this works:

- **Transform A** is applied to the files from accelerator `<root>`. It selects all files, including `pom.xml` files.

- **Transform B** is *also* applied to the files from accelerator `<root>`. Again, `Merge` passes the
same input independently to each of its child transforms. Transform B selects `pom.xml` files
and replaces some text in them.

So both **Transform A** and **Transform B** output `pom.xml` files. The fact that both result sets contain the same file,
and with different contents in them in this case, is a conflict that has to be resolved.
By default, `Combo` follows a simple rule to resolve such conflicts: take the contents from the last child. 
Essentially, it behaves as if you overlaid both result sets one after another into the same location. The contents of
the latter overwrite any previous files placed there by the earlier.

In the preceding example, this means that while both **Transform A** and **Transform B** produce contents for `pom.xml`,
the contents from **Transform B** "wins." So you get the version of the `pom.xml` that has text replacements
applied to it rather than the verbatim copy from **Transform A**.

## <a id="conditional-transforms"></a>Conditional transforms

Every `<transform-definition>` can have a `condition` attribute.

  ```yaml
    - condition: "#k8sConfig == 'k8s-resource-simple'"
      include: [ "kubernetes/app/*.yaml" ]
      chain:
        - type: ReplaceText
          substitutions:
          - text: hello-fun
            with: "#artifactId"
  ```

When a transform's condition is `false`, that transform is "disabled."
This means it is replaced by a transform that "does nothing."
However, doing nothing can have different meanings depending on the context:

* When in the context of a `Merge`, a disabled transform behaves like something that
returns an empty set. A `Merge` adds things together using a kind
of union; adding an empty set to union essentially does nothing.

* When in the context of a `'Chain` however, a disabled transform behaves like
the `identity` function instead (that is, `lambda (x) => x`). When you chain
functions together, a value is passed through all functions in succession. So each
function in the chain has the chance to "do something" by returning a different modified value.
If you are a function in a chain, to do nothing means to return
the input you received unchanged as your output.

If this all sounds confusing, fortunately there is a basic rule of thumb
for understanding and predicting the effect of a disabled transform in
the context of your accelerator definition. Namely, if a transform's condition evaluates to false,
pretend it isn't there. In other words, your accelerator behaves as if you
deleted (or commented out) that transform's YAML text from the accelerator
definition file.

The following examples illustrate both cases.

### <a id="conditional-merge"></a>Conditional 'Merge' transform

This example, **transform A**, has a conditional transform in a `Merge` context:

  ```yaml
  merge:
    - condition: "#k8sConfig == 'k8s-resource-simple'"
      include: [ "kubernetes/app/*.yaml" ]
      chain:
        ...
    - include: [ "pom.xml" ]
      chain:
        ...
  ```

If the condition of **transform A** is `false`, it is replaced with an "empty set" because
it is used in a `Merge` context. This has the same effect as if the whole of **transform A** was deleted
or commented out:

  ```yaml
  merge:
    - include: [ "pom.xml" ]
      chain:
        ...
  ```

In this example, if the condition is `false`, only `pom.xml` file is in the result.

### <a id="conditional-chain-transforms"></a>Conditional 'Chain' transform

In the following example, some conditional transforms are used in a `Chain` context:

  ```yaml
  merge:
  - include: [ '**/*.json' ]
    chain:
    - type: ReplaceText
      condition: '#customizeJson'  
      substitutions: ...
    - type: JsonPrettyPrint
      condition: '#prettyJson'
      indent: '#jsonIndent'
  ```

The `JsonPrettyPrint` transform type is purely hypothetical. There *could* be such a
transform, but VMware doesn't currently provide it.

In the preceding example, both **transform A** and **transform B** are conditional and used in a `Chain` context.
**Transform A** is chained after the `include` transform. Whereas **transform B** is chained after
**transform A**. When either of these conditions is `false`, the corresponding transform behaves
like the identity function. Namely, whatever set of files it receives as input is exactly what it returns as output.

This behavior accords with our rule of thumb. For example, if **transform A**'s condtion is
`false`, it behaves as if **transform A** wasn't there. **Transform A** is chained after `include` so it
receives the `include`'s result, returns it unchanged, and this is passed to **transform B**. In other words,
the result of the `include` is passed as is to **transform B**. This is precisely what would happen were **transform A**
not there.

### <a id="using-conditionals-in-merge"></a>A small gotcha with using conditionals in merge transforms

As mentioned earlier, it is a useful pattern to use merges with overlapping contents. Yet you must be careful using this in combination with conditional transforms.

For example:

  ```yaml
  engine:
    merge:
    - include: ["**/*"]
    - include: ["**/pom.xml"]
      chain:
      - type: ReplaceText
        subsitutions: ...
  ```

Now add a little twist. Say you only wanted to include pom files if the user
selects a `useMaven` option. You might be tempted to add a 'condition' to **transform B** to disable it when that
option isn't selected:

  ```yaml
  engine:
    merge:
    - include: "**/*"
    - condition: '#useMaven'
      include: ["**/pom.xml"]
      chain:
      - type: ReplaceText
        subsitutions: ...
  ```

However, this doesn't do what you might expect. The final result _still_ contains
`pom.xml` files. To understand why, recall the rule of thumb for disabled transforms:
If a transform is disabled, pretend it isn't there. So when
`#useMaven` is `false`, the example reduces to:

  ```yaml
  engine:
    merge:
    - include: ["**/*"]
  ```

This accelerator copies all files from accelerator `<root>`, _including_ `pom.xml`.

There are several ways to avoid this pitfall. One is to ensure the `pom.xml` files
are not included in **transform A** by explicitly excluding them:

  ```yaml
    ...
    - include: ["**/*"]
      exclude: ["**/pom.xml"]
    ...
  ```

Another way is to apply the exclusion of pom.xml conditionally in a `Chain` after the main transform:

  ```yaml
  engine:
    merge:
    - include: ["**/*"]
    - include: ["**/pom.xml"]
      chain:
      - type: ReplaceText
          subsitutions: ...
    chain:
    - condition: '!#useMaven'
      exclude: ['**/pom.xml']
  ```

## <a id="merge-conflict"></a>Merge conflict

The representation of the set of files upon which transforms operate is "richer" than what you can physically store on a file system. A key difference is that in this case, the set of files allows for multiple files
with the same path to exist at the same time. When files are initially read from a
physical file system, or a ZIP file, this situation does not arise. However, as transforms are
applied to this input, it can produce results that have more than one file with
the same path and yet different contents.

Earlier examples illustrated this happening through a `merge`
operation. Again, for example:

  ```yaml
  merge:
  - include: ["**/*"]
  - include: ["**/pom.xml"]
    chain:
    - type: ReplaceText
      subsitutions: ...
  ```

The result of the preceding `merge` is two files with path `pom.xml`, assuming there was
a `pom.xml` file in the input. **Transform A** produces a `pom.xml` that is a verbatim copy of the
input file. **Transform B** produces a modified copy with some text replaced in it.

It is impossible to have two files on a disk with the same path. Therefore, this conflict
must be resolved before you can write the result to disk or pack it into a ZIP file.

As the example shows, merges are likely to give rise to these conflicts, so you
might call this a "merge conflict." However,
such conflicts can also arise from other operations. For example, `RewritePath`:

  ```yaml
  type: RewritePath
  regex: '.*.md'
  rewriteTo: "'docs/README.md'"
  ```

This example renames any `.md` file to `docs/README.md`. Assuming the input contains
more than one `.md` file, the output contains multiple files with path `docs/README.md`.
Again, this is a conflict, because there can only be one such file in a physical file system or
ZIP file.

### <a id="resolve-merge-conflicts"></a>Resolving "merge" conflicts

By default, when a conflict arises, the engine doesn't do anything with it. Our internal representation
for a set of files allows for multiple files with the same path. The engine carries on
manipulating the files as is. This isn't a problem until the files must be written
to disk or a ZIP file. If a conflict is still present at that time, an error is raised.

If your accelerator produces such conflicts, they must be resolved
before writing files to disk. To this end, VMware provides the [UniquePath](transforms/unique-path.md)
transform. This transform allows you to specify what to do when more than one file has the same
path. For example:

  ```yaml
  chain:
  - type: RewritePath
    regex: '.*.md'
    rewriteTo: "'docs/README.md'"
  - type: UniquePath
    strategy: Append
  ```

The result of the above transform is that all `.md` files are gathered up and concatenated into a
single file at path `docs/README.md`. Another possible resolution strategy is to keep
only the contents of one of the files. See [Conflict Resolution](transforms/conflict-resolution.md).

[Combo](transforms/combo.md) transform also comes with some convenient built-in support for
conflict resolution. It automatically selects the `UseLast` strategy if none is explicitly
supplied. So in practice, you rarely, if ever, need to explicitly
specify a conflict resolution strategy.

### <a id="file-ordering"></a>File ordering

As mentioned earlier, our set of files representation is richer than the files on a typical file system in that it allows for multiple files with the same path. Another way in which it is richer is that
the files in the set are "ordered." That is, a `FileSet` is more like an ordered list than an unordered set.

In most situations, the order of files in a `FileSet` doesn't matter. However, in conflict resolution
it *is* significant. If you look at the preceding `RewritePath` example again,
you might wonder about the order in which the various
`.md` files are appended to each other. This ordering is determined by the order of
the files in the input set.

So what is that order? In general, when files are read from disk to create a
`FileSet`, you cannot assume a specific order. Yes, the files are read and processed in a sequential order,
but the actual order is not well defined. It depends on implementation details of the underlying
file system. The accelerator engine therefore does not ensure a specific order in this case.
It only ensures that it *preserves* whatever ordering it receives from the file system, and processes files in
accord with that order.

As an accelerator author, better to avoid relying on the file order
produced from reading directly from a file system. So it's better to avoid doing something like the preceding `RewritePath` example, *unless* you do not care about the ordering
of the various sections of the produced `README.md` file.

If you do care and want to control the order explicitly, you use the fact
that `Merge` processes its children in order and reflects this order in the resulting output
set of files. For example:

  ```yaml
  chain:
    - merge:
        - include: ['README.md']
        - include: ['DEPLOYMENT.md']
          chain:
            - type: RewritePath
              rewriteTo: "'README.md'"
    - type: UniquePath
      strategy: Append
  ```

In this example, `README.md` from the first child of `merge` definitely comes
before `DEPLOYMENT.md` from the second child of `merge`. So you can control
the merge order directly by changing the order of the merge children.

## <a id="conclusion"></a>Next steps

This introduction focused on an intuitive
understanding of the `<transform-definition>` notation. This notation defines
precisely how the accelerator engine generates new project content from the files
in the accelerator root.

To learn more, read the following more detailed documents:

- An exhaustive [Reference](transforms/index.md) of all built-in transform types
- A sample, commented [accelerator.yaml](accelerator-yaml-sample.md) to learn from a concrete example
