
# Composition
## <a id="composition-intro"></a> Introduction

Despite their benefits, writing and maintaining accelerators can become repetitive and
verbose as new accelerators are added: some create a project different from the next but
with similar aspects, which requires some form of copy-paste.

To alleviate this concern, Application Accelerators support a feature named _Composition_
that allows re-use of parts of an accelerator, named **Fragments**.


## <a id="introducting-fragments"></a> Introducing Fragments

A **Fragment** looks exactly the same as an accelerator:

- it is made of a set of files
- contains an `accelerator.yaml` descriptor, with options declarations and a root Transform.

The only differences reside in the way they are declared to the system — they are
filed as **Fragments** custom resources — and the way they deal with files: because
they deal with their own files and files from the accelerator using them,
they typically use dedicated conflict resolution [strategies](transforms/conflict-resolution.md)
(more on that later).

Fragments may be thought of as "functions" in programming languages: once defined and
referenced, they may be "called" at various points in the main accelerator.
The composition feature is designed with ease-of-use and "common use case first"
in mind, so these "functions" are typically called with as little noise as possible,
you can also call them with complex or different values.

Composition relies on two building blocks that play hand in hand:

- the `imports` section at the top of an accelerator manifest,
- and the, `InvokeFragment` Transform, to be used alongside any other Transform.

## <a id="imports-section-explained"></a>| The `imports` section explained

To be usable in composition, a fragment MUST be _imported_ in the dedicated
section of an accelerator manifest:
```yaml
accelerator:
  name: my-awesome-accelerator
  options:
    - name: flavor
      dataType: string
      defaultValue: Strawberry
  imports:
    - name: my-first-fragment
    - name: another-fragment
engine:
  ...
```

The effect of importing a fragment this way is twofold:

- it makes its files available to the engine (this is why importing a fragment is required),
- it exposes all of its options as options of the accelerator, as if they were defined
  by the accelerator itself.

So in the above, example, if the `my-first-fragment` fragment had the following `accelerator.yaml`
file
```yaml
accelerator
  name: my-first-fragment
  options:
    - name: optionFromFragment
      dataType: boolean
      description: this option comes from the fragment

...
```

then it is as if the `my-awesome-accelerator` accelerator defined it:
```yaml
accelerator:
  name: my-awesome-accelerator
  options:
    - name: flavor
      dataType: string
      defaultValue: Strawberry
    - name: optionFromFragment
      dataType: boolean
      description: this option comes from the fragment
  imports:
    - name: my-first-fragment
    - name: another-fragment
engine:
  ...
```

All of the metadata about options (type, default value, description, choices if applicable, _etc._)
is coming along when being imported.

As a consequence of this, users are prompted for a value for those options that come
from fragments, as if they were options of the accelerator.

## <a id="using-invokefragment-transform"></a> Using the `InvokeFragment` Transform

The second part at play in composition is the `InvokeFragment` Transform.

As with any other transform, it may be used anywhere in the `engine` tree and
receives files that are "visible" at that point. Those files, alongside those
that make up the fragment are made available to the fragment logic. If the fragment
wants to choose between two versions of a file for a path, two new
conflict resolution [strategies](transforms/conflict-resolution.md) are available: `FavorForeign` and `FavorOwn`.

The behavior of the `InvokeFragment` Transform is very straight forward: after having validated
options that the fragment expects (and maybe after having set default values for
options that support one), it executes the whole Transform of the fragment _as if
it was written in place of `InvokeFragment`_.

See the `InvokeFragment` [reference page](transforms/invoke-fragment.md) for more explanations, examples, and configuration options. This topic now focuses on additional features of the `imports` section that are seldom used but still
available to cover more complex use-cases.

## <a id="back-to-imports"></a> Back to the `imports` section

The complete definition of the `imports` section is as follows, with
features in increasing order of "complexity":
```yaml
accelerator:
  name: ...
  options:
    - name: ...
    ...
  imports:
    - name: some-fragment

    - name: another-fragment
      expose:
        - name: "*"

    - name: yet-another-fragment
      expose:
        - name: someOption

        - name: someOtherOption
          as: aDifferentName
engine:
  ...
```
As shown earlier, the `imports` section calls a list of fragments to import and by default
all of their options become options of the accelerator. Those options appear _after_
the options defined by the accelerator, in the order the fragments are imported in.

**Note:** It is even possible for a fragment to import another fragment, the semantics
being the same as when an accelerator imports a fragment. This is a way to
break apart a fragment even further if needed.

When importing a fragment, you may select which options of the fragment
to make available as options of the accelerator. **This feature should only be used
when a name clash arises in option names.**

The semantics of the `expose` block are as follows:

- for every `name`/`as` pair, don't use the original (`name`) of the
  option but instead use the alias (`as`). Other metadata about the option
  is left unchanged.
- if the special `name: "*"` (which is NOT a legit option name usually) appears,
 all imported option names that are not remapped (the index at which the
  `*` appears in the yaml list is irrelevant) may be exposed
  with their original name.
- The default value for `expose` is `[{name: "*"}]`, _i.e._ by default
  expose all options with their original name.
- As soon as a single remap rule appears, the default is overridden (_i.e._
  to override some names AND expose the others unchanged, the `*` must
  be explicitly re-added)

### <a id="using-dependsOn-in-imports"></a>| Using `dependsOn` in the `imports` section<
Lastly, as a convenience for conditional use of fragments, you can make an exposed imported option _depend on_ another option, as in the following example:

```yaml
  imports:
    - name: tap-initialize
      expose:
        - name: gitRepository
          as: gitRepository
          dependsOn:
            name: deploymentType
            value: workload
        - name: gitBranch
          as: gitBranch
          dependsOn:
            name: deploymentType
            value: workload
```

This plays well with the use of `condition`, as in the following expample:

```yaml
...
engine:
  ...
    type: InvokeFragment
    condition: "#deploymentType == 'workload'"
    reference: tap-initialize```
```
