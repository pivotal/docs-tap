# Using Custom Types

You can declare new `types` in `accelerator.yaml`. These can be used for options declaration,
in addition to the built-in types `string`, `number`, and `boolean`.

In `accelerator.yaml`, use the `types` entry (inside the top-level
`accelerator` section)  to define custom types.</br>

The name must be an initial capital letter.</br>

In the following example, the `struct` type definition is syntactically equivalent to a sequence
of option definitions:

```yaml
accelerator:
  options:
    ...
  types:
    - name: Task
      struct:
        - name: title
          dataType: string
          label: Title
          description: A sample title
        - name: details
          label: Task details
          description: Enter the task details
        - name: done
          dataType: boolean
          label: Done?
          defaultValue: false
```

This example creates a new _type_ that is available for the `dataType` property of any option.
For example,

```yaml
accelerator:
  options:
    - name: myTask
      dataType: Task
  types:
    ...
```

UIs would render something similar to the following:

![SimpleTask form is open with my first task sample title and task details.](../images/simple-task.png)

and associate the entered values to the `myTask` top-level name, resulting in the following example
values submission (here represented using JSON notation):

```json
{
  "myTask": { // Note the use of a nested object here
    "title": "Get job done!",
    "details": "Needs this asap",
    "done": false
  }
}
```

The type of the `myTask` value is `object` (in Javascript/JSON parlance)
and `Map<String, ?>` when seen from the Java engine side.

The earlier example is technically possible with the custom types feature,
but brings little benefit over having three options named to achieve the same end result,
 for example, `myTaskTitle`, `myTaskDetails`, and `myTaskDone`. The value of custom types is that
they can be used in sequence types, allowing you to enter an unbounded list of structured data:

```yaml
accelerator:
  options:
    - name: myTasks
      dataType: [Task]
  types:
    ...
```

Which might result in the following example submission (JSON):

```json
{
  "myTasks": [ // Note the use of JSON array
    {  // with elem 0 being an object
      "details": "something",
      "done": true,
      "title": "The Title"
    },
    {  // and elem 1 as well, etc
      "details": "something else",
      "done": false,
      "title": "The other Title"
    }
  ]
}
```

## Limitations

A `struct` custom type declaration is made of an ordered series of option definitions.
The support and semantics for individual text boxes of option-definition-like elements
when used in the type _declaration_ are stated in the following example.

When _referencing_ a custom type in an option definition, some previously
valid properties of an option definition might become irrelevant or unsupported.
This is stated in the following example:

```yaml
accelerator:
  types:
    - name: MyType
      struct:
        - name: someField   # the "option name" will become a 'property' of the newly created type
          dataType: string  # is the type of this single property. Typically, will be a simple
                            # scalar type like string or number
          defaultValue: foo # supported and is the default if not overridden at usage point by the option's defaultValue
          description: something # will become the description for the field's widget
          choices:               # supported
            - value: v
              text:  t
          validationRegex:       # validates that single property
          label:                 # will become the "title" of the widget
          inputType:             # supported
          required:              # supported
          dependsOn:             # supported against other properties of THIS struct
    .. other fields
  options:
    - name: anOptionThatUsesACustomType
      dataType: MyType
      defaultValue: # supported, should then be an object (or array thereof)
      description:  # supported, is the description of the whole option (as opposed to individual fields)
      label:        # supported, idem
      choices:      # NOT supported
        - value: v
          text:  t
      validationRegex: # NOT supported
      inputType:       # NOT supported
      required:        # technically supported, useless in practice
      dependsOn:       # OK to depend on another option
```

## Interaction with SpEL

Everywhere that SpEL is used in the engine syntax, accelerator authors
might use SpELs syntax for accessing properties or< array elements:

```console
  #myTasks[2]['done']
```

Array indexing should not be used (either with a literal number or a variable) as the purpose
of the list of the custom types feature is that you don't know the data length
in advance. See the section about the [Loop](transforms/loop.hbs.md) Transform to discover more
idiomatic use of repeated structured data.

## Interaction with Composition

Using composition alongside custom types has the following advantages/disadvantages:

- You might want to **leverage** types declared in an imported fragment
- There might be a type **name clash** between a host accelerator/fragment and an imported
  fragment, because the imported fragment author is unaware of how the fragment is to be used.

For more information about the syntax to customize the imported types names, see [composition](composition.hbs.md).
