# Options specification

This section describes the parts of an accelerator manifest file that are
relevant for the processing of an accelerator. That is, the metadata that affects
the behavior at runtime of the engine. Other parts of the file can be
used to alter the presentation, including the presentation of user
input widgets in some UIs. Those parts are out of the scope of this
document.

## <a id="metadata-for-options"></a> Metadata for options

A sample annotated manifest is shown in the following example:

```
accelerator: # the first 3 properties are out of scope of this spec
  name: new-demo
  description: Create a new demo project
  tags:
    - java
    - spring
    - cloud
    - function
    - serverless
  options: # some properties of options are also ignored by this spec
    - name: buildTool
      description: The build tool to use for the project
      dataType: string
      defaultValue: maven
      inputType: select
      choices:
      - value: maven
        text: Apache Maven
      - value: gradle
        text: Gradle
    - name: configureCI
      description: Whether to add Continuous Integration config files
      dataType: boolean
      defaultValue: true

engine:
  # transformation
```

Options are defined by their `name`, `dataType` and optional `defaultValue`.
All other fields are out of scope of this specification and are silently
ignored by the _engine_.

`accelerator.options` is a _list_ of sub objects defined in the following sections. In the rest of this
specification, the notation `somekey[*]` refers to a multivalued property.


### <a name="accelerator.options.name"></a>`accelerator.options[*].name`

Denotes the name of a top-level entry in the __model__ at runtime.
Name must use [_lower camelCase_](https://en.wikipedia.org/wiki/Camel_case)
and no two options can be declared with the same name.

UIs are free to turn the camelCase name into some other label for presentation.
For example, `projectName -> Project Name` or `projectName -> --project-name`.
However, the technical key to pass the value must use the camelCase name.

The `name` field is required.

### <a name="accelerator.options.dataType"></a> `accelerator.options[*].dataType`

Describes the type of the acceptable values for this option.
The only supported types are the equivalent of JSON types
`string`, `number`, `boolean`, and one-dimensional arrays of the earlier sections.
`null` is a supported value and conforms to all types.


The value of the `dataType` field, if set, must be either:

- A `string` with value of either `"string"`, `"number"`, or `"boolean"`.
  This denotes that the required type of the option is the corresponding type.
- A one-dimension, single element array of `string` whose sole element is one
  of the earlier `dataType` fields. This denotes that the type of the option is an array of
  said type. That is, `["number"]` enforces an option whose type is a
  one-dimension array of numbers.

The `dataType` field is optional. Its implied default value is `"string"`.

### <a name="accelerator.options.defaultValue"></a>`accelerator.options[*].defaultValue`

Describes the default value that the engine assumes if clients
don't provide an explicit value. The way UIs present those values
is implementation specific, but in the absence of explicit user-provided
value, clients can use the default value by leaving out the option or explicitly send the default value.

The value of the `defaultValue` field must be an instance of a JSON/YAML
value that conforms to the `dataType` declared or implied for the option.

The `defaultValue` field is optional and has no default value, meaning that an option
with no `defaultValue` is __required__.
