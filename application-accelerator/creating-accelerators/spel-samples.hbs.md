# SpEL samples

This document shows some common [Spring Expression Language](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#expressions)
(SpEL) use cases for the `accelerator.yaml` file.

## <a id="variables"></a>Variables

You can reference all the values added as options in the `accelerator` section from the YAML file as variables in the `engine` section. You can access the value using the syntax 
`#<option name>`:

```yaml
options:
  - name: foo
    dataType: string
    inputType: text
...
engine:
  - include: ["some/file.txt"]
    chain:
    - type: ReplaceText
      substitutions:
      - text: bar
        with: "#foo"
```

This sample replaces every occurrence of the text `bar` in the file `some/file.txt` 
with the contents of the `foo` option.

## <a id="implicit-variables"></a>Implicit variables

Some variables are made available to the model by the engine, including:

* `artifactId` is a built-in value derived from the `projectName` passed in from 
  the UI with spaces replaced by "_". If that value is empty, it is set to `app`.
* `files` is a helper object that currently exposes the `contentsOf(<path>)` method. 
  For more information, see [ReplaceText](transforms/replace-text.md).
* `camel2Kebab` and other variations of the form `xxx2Yyyy` are a series of
  helper functions for dealing with changing case of words. For more information, see [ReplaceText](transforms/replace-text.md).

## <a id="conditionals"></a>Conditionals

You can use Boolean options for conditionals in your transformations.

```yaml
options:
  - name: numbers
      inputType: select
      choices:
        first: First Option
        second: Second Option      
      defaultValue: first
...
engine:
  - include: ["some/file.txt"]
    condition: "#numbers == 'first'"
    chain:
    - type: ReplaceText
      substitutions:
      - text: bar
        with: "#foo"
```

This replaces the text only if the selected option is the first one.

## <a id="rewrite-path-concatentation"></a>Rewrite path concatenation

```yaml
options:
  - name: renameTo
    dataType: string
    inputType: text
...
engine:
  - include: ["some/file.txt"]    
    chain:
    - type: RewritePath
      rewriteTo: "'somewhere/' + #renameTo + '.txt'"
```

## <a id="regular-expressions"></a>Regular expressions
 
Regular expressions allow you to use patterns as a matcher for strings. Here is a small
example of what you can do with them:

```yaml
options:
  - name: foo
    dataType: string
    inputType: text
    defaultValue: abcZ123
...
engine:
  - include: ["some/file.txt"]
    condition: "#foo matches '[a-z]+Z\\d+'"
    chain:
    - type: ReplaceText
      substitutions:
      - text: bar
        with: "#foo"
```

This example uses RegEx to match a string of letters that ends with a capital Z and any number of digits. If this condition is fulfilled, the text is replaced in the file, `file.txt`.
