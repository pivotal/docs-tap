# Workshop instructions

Individual module files making up the workshop instructions can use either [Markdown](https://github.github.com/gfm/) or [AsciiDoc](http://asciidoc.org/) markup formats. The extension used on the file should be `.md` or `.adoc`, corresponding to which formatting markup style you use.

## <a id="annotation-of-executable"></a>Annotation of executable commands

In conjunction with the standard Markdown and AsciiDoc, you can apply additional annotations to code blocks. The annotations indicate that a user can click the code block and have it copied to the terminal and executed.

If using Markdown, to annotate a code block so it is copied to the terminal and executed, use:

~~~
```execute
echo "Execute command."
```
~~~

When the user clicks the code block, the command is executed in the first terminal of the workshop dashboard.

If using AsciiDoc, you can instead use the `role` annotation in an existing code block:

```text
[source,bash,role=execute]
----
echo "Execute command."
----
```

When the workshop dashboard is configured to display multiple terminals, you can qualify which terminal the command must be executed in by adding a suffix to the `execute` annotation. For the first terminal, use `execute-1`, for the second terminal `execute-2`, and so on:

~~~
```execute-1
echo "Execute command."
```

```execute-2
echo "Execute command."
```
~~~

To execute a command in all terminal sessions on the terminals tab of the dashboard, you can use `execute-all`:

~~~
```execute-all
clear
```
~~~

In most cases, a command the user executes completes immediately. To run a command that never returns, with the user needing to interrupt it to stop it, you can use the special string `<ctrl+c>` in a subsequent code block.

~~~
```execute
<ctrl+c>
```
~~~

When the user clicks on this code block, the command running in the corresponding terminal is interrupted.

>**Note** Using the special string `<ctrl+c>` is deprecated, and you must use the `terminal:interrupt` clickable action instead.

## <a id="annotation-of-text"></a>Annotation of text to be copied

To copy the content of the code block into the paste buffer instead of running the command, you can use:

~~~
```copy
echo "Text to copy."
```
~~~

After the user clicks this code block, they can then paste the content into another window.

If you have a situation where the text being copied must be modified before use, you can denote this special case by using `copy-and-edit` instead of `copy`. The text is still copied to the paste buffer, but is displayed in the browser in a way to highlight that it must be changed before use.

~~~
```copy-and-edit
echo "Text to copy and edit."
```
~~~

For AsciiDoc, similar to `execute`, you can add the `role` of `copy` or `copy-and-edit`:

```text
[source,bash,role=copy]
----
echo "Text to copy."
----

[source,bash,role=copy-and-edit]
----
echo "Text to copy and edit."
----
```

For `copy` only, to mark an inline code section within a paragraph of text as copyable when clicked, you can append the special data variable reference `\{{copy}}` immediately after the inline code block:

```
Text to `copy`\{{copy}}.
```

## <a id="extensible-click-actions"></a>Extensible clickable actions

The preceding means to annotate code blocks were the original methods used to indicate code blocks to be executed or copied when clicked. To support a growing number of clickable actions with different customizable purposes, annotation names are now name-spaced. The preceding annotations are still supported, but the following are now recommended, with additional options available to customize the way the actions are presented.

For code execution, instead of:

~~~
```execute
echo "Execute command."
```
~~~

you can use:

~~~
```terminal:execute
command: echo "Execute command."
```
~~~

The contents of the code block is YAML. The executable command must be set as the `command` property. By default when the user clicks the command, it is executed in terminal session 1. To select a different terminal session, you can set the `session` property.

~~~
```terminal:execute
command: echo "Execute command."
session: 1
```
~~~

To define a command the user clicks that executes in all terminal sessions on the terminals tab of the dashboard, you can also use:

~~~
```terminal:execute-all
command: echo "Execute command."
```
~~~

For `terminal:execute` or `terminal:execute-all`, to clear the terminal before the command is executed, set the `clear` property to `true`:

~~~
```terminal:execute
command: echo "Execute command."
clear: true
```
~~~

This clears the full terminal buffer and not just the displayed portion of the buffer.

With the new clickable actions, to indicate that a running command in a terminal session must be interrupted, use:

~~~
```terminal:interrupt
session: 1
```
~~~

(Optional) Set the `session` property within the code block to indicate an alternate terminal session to session 1.

To allow the user to send an interrupt to all terminals sessions on the terminals tab of the dashboard, use:

~~~
```terminal:interrupt-all
```
~~~

Where you want the user to enter input into a terminal rather than a command, such as when a running command prompts for a password, use:

~~~
```terminal:input
text: password
```
~~~

To allow the user to run commands or interrupt a command, set the `session` property to indicate a specific terminal to send it to if you don't want to send it to terminal session 1:

~~~
```terminal:input
text: password
session: 1
```
~~~

When providing terminal input in this way, the text by default still has a newline appended to the end, making it behave the same as using `terminal:execute`. If you do not want a newline appended, set the `endl` property to `false`.

~~~
```terminal:input
text: input
endl: false
```
~~~

To allow the user to clear all terminal sessions on the terminals tab of the dashboard, use:

~~~
```terminal:clear-all
```
~~~

This clears the full terminal buffer and not just the displayed portion of the terminal buffer. It does not have any effect when an application is running in the terminal using visual mode. To clear only the displayed portion of the terminal buffer when a command dialog box is displayed, use `terminal:execute` and run the `clear` command.

To allow the user to copy content to the paste buffer, use:

~~~
```workshop:copy
text: echo "Text to copy."
```
~~~

or:

~~~
```workshop:copy-and-edit
text: echo "Text to copy and edit."
```
~~~

A benefit of using these over the original methods is that by using the appropriate YAML syntax, you can control whether:

- A multiline string value is concatenated into one line.
- Line breaks are preserved.
- Initial or terminating new lines are included.

In the original methods, the string was always trimmed before use. By using the different forms as appropriate, you can annotate the displayed code block with a different message letting the user know what will happen.

The method for using AsciiDoc is similar, using the `role` for the name of the annotation and YAML as the content:

```text
[source,bash,role=terminal:execute]
----
command: echo "Execute command."
----
```

## <a id="supported-editor"></a>Supported workshop editor

Learning Center currently **only** supports the code-server v4.4.0 of VS Code as an editor in workshops.

## <a id="click-actions-dashboard"></a>Clickable actions for the dashboard

In addition to the clickable actions related to the terminal and copying of text to the paste buffer, other actions are available for controlling the dashboard and opening URL links.

To allow the user to click in the workshop content to open a URL in a new browser, use:

~~~
```dashboard:open-url
url: https://www.example.com/
```
~~~

To allow the user to click in the workshop content to display a specific dashboard tab if hidden, use:

~~~
```dashboard:open-dashboard
name: Terminal
```
~~~

To allow the user to click in the workshop content to display the console tab, use:

~~~
```dashboard:open-dashboard
name: Console
```
~~~

To allow the user to click in the workshop content to display a specific view within the Kubernetes web console by using a clickable action block, rather than requiring the user to find the correct view, use:

~~~
```dashboard:reload-dashboard
name: Console
prefix: Console
title: List pods in namespace \{{session_namespace}}
url: \{{ingress_protocol}}://\{{session_namespace}}-console.\{{ingress_domain}}/#/pod?namespace=\{{session_namespace}}
description: ""
```
~~~

To allow the user to create a new dashboard tab with a specific URL, use:

~~~
```dashboard:create-dashboard
name: Example
url: https://www.example.com/
```
~~~

To allow the user to create a new dashboard tab with a new terminal session, use:

~~~
```dashboard:create-dashboard
name: Example
url: terminal:example
```
~~~

The value must be of the form `terminal:<session>`, where `<session>` is replaced with the name you want to give the terminal session. The terminal session name must be restricted to lowercase letters, numbers, and ‘-‘. You must avoid using numeric terminal session names such as "1", "2", and "3", because these are used for the default terminal sessions.

To allow the user to reload an existing dashboard, using the URL it is currently targeting, use:

~~~
```dashboard:reload-dashboard
name: Example
```
~~~

If the dashboard is for a terminal session, there is no effect unless the terminal session was disconnected, in which case it is reconnected.

To allow the user to change the URL target of an existing dashboard by entering the new URL when reloading a dashboard, use:

~~~
```dashboard:reload-dashboard
name: Example
url: https://www.example.com/
```
~~~

The user cannot change the target of a dashboard that includes a terminal session.

To allow the user to delete a dashboard, use:

~~~
```dashboard:delete-dashboard
name: Example
```
~~~

The user cannot delete dashboards corresponding to builtin applications provided by the workshop environment, such as the default terminals, console, editor, or slides.

Deleting a custom dashboard including a terminal session does not destroy the underlying terminal session, and the user can reconnect it by creating a new custom dashboard for the same terminal session name.

## <a id="clickable-actions-editor"></a>Clickable actions for the editor

If the embedded editor is enabled, special actions are available that control the editor.

To allow the user to open an existing file you can use:

~~~
```editor:open-file
file: ~/exercises/sample.txt
```
~~~

You can use `~/` prefix to indicate the path relative to the home directory of the session. When the user opens the file, if you want the insertion point left on a specific line, provide the `line` property. Lines numbers start at `1`.

~~~
```editor:open-file
file: ~/exercises/sample.txt
line: 1
```
~~~

To allow the user to highlight certain lines of a file based on an exact string match, use:

~~~
```editor:select-matching-text
file: ~/exercises/sample.txt
text: "int main()"
```
~~~

The region of the match is highlighted by default. To allow the user to highlight any number of lines before or after the line with the match, you can set the `before` and `after` properties:

~~~
```editor:select-matching-text
file: ~/exercises/sample.txt
text: "int main()"
before: 1
after: 1
```
~~~

Setting both `before` and `after` to `0` causes the complete line that matched to be highlighted instead of a region within the line.

To match based on a regular expression, rather than an exact match, set `isRegex` to `true`:

~~~
```editor:select-matching-text
file: ~/exercises/sample.txt
text: "image: (.*)"
isRegex: true
```
~~~

When a regular expression is used, and subgroups are specified within the pattern, you can indicate which subgroup is selected:

~~~
```editor:select-matching-text
file: ~/exercises/sample.txt
text: "image: (.*)"
isRegex: true
group: 1
```
~~~

Where there are multiple possible matches in a file, and the one you want to match is not the first, you can set a range of lines to search:

~~~
```editor:select-matching-text
file: ~/exercises/sample.txt
text: "image: (.*)"
isRegex: true
start: 8
stop: 12
```
~~~

Absence of `start` means start at the beginning of the file. Absence of `stop` means stop at the end of the file. The line number given by `stop` is not included in the search.

For both an exact match and regular expression, the text to be matched must all be on one line. It is not possible to match text that spans across lines.

To allow the user to replace text within the file, first match it exactly or use a regular expression so it is marked as selected, then use:

~~~
```editor:replace-text-selection
file: ~/exercises/sample.txt
text: nginx:latest
```
~~~

To allow the user to append lines to the end of a file, use:

~~~
```editor:append-lines-to-file
file: ~/exercises/sample.txt
text: |
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed
    do eiusmod tempor incididunt ut labore et dolore magna aliqua.
```
~~~

If the user runs the action `editor:append-lines-to-file` and the file doesn't exist, it is created. You can use this to create new files for the user.

To allow the user to insert lines before a specified line in the file, use:

~~~
```editor:insert-lines-before-line
file: ~/exercises/sample.txt
line: 8
text: |
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed
    do eiusmod tempor incididunt ut labore et dolore magna aliqua.
```
~~~

To allow the user to insert lines after matching a line containing a specified string, use:

~~~
```editor:append-lines-after-match
file: ~/exercises/sample.txt
match: Lorem ipsum
text: |
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed
    do eiusmod tempor incididunt ut labore et dolore magna aliqua.
```
~~~

Where the file contains YAML, to allow the user to insert a new YAML value into an existing structure, use:

~~~
```editor:insert-value-into-yaml
file: ~/exercises/deployment.yaml
path: spec.template.spec.containers
value:
- name: nginx
  image: nginx:latest
```
~~~

To allow the user to execute a registered VS code command, use:

~~~
```editor:execute-command
command: spring.initializr.maven-project
args:
- language: Java
  dependencies: [ "actuator", "webflux" ]
  artifactId: demo
  groupId: com.example
```
~~~

## <a id="click-actions-file-dl"></a>Clickable actions for file download

If file downloads are enabled for the workshop, you can use the `files:download-file` clickable action:

~~~
```files:download-file
path: .kube/config
```
~~~

The action triggers saving the file to the user's local computer, and the file is not displayed in the user's web browser.

## <a id="click-actions-examiner"></a>Clickable actions for the examiner

If the test examiner is enabled, special actions are available to run verification checks to verify whether a workshop user has performed a required step. You can trigger these verification checks by clicking on the action, or you can configure them to start running when the page loads.

For a single verification check that the user must click to run, use:

~~~
```examiner:execute-test
name: test-that-pod-exists
title: Verify that pod named "one" exists.
args:
- one
```
~~~

The `title` field is displayed as the title of the clickable action and must describe the nature of the test. If required, you can provide a `description` field for a longer explanation of the test. This is displayed in the body of the clickable action but is shown as preformatted text.

There must be an executable program (script or compiled application) in the `workshop/examiner/tests` directory with name matching the value of the `name` field.

The list of program arguments against the `args` field is passed to the test program.

The executable program for the test must exit with a status of 0 if the test is successful and nonzero if the test is a failure. The test should aim to return as quickly as possible and should not be a persistent program.

```console
#!/bin/bash

kubectl get pods --field-selector=status.phase=Running -o name | egrep -e "^pod/$1$"

if [ "$?" != "0" ]; then
    exit 1
fi

exit 0
```

By default, the program for a test is stopped after a timeout of 15 seconds, and the test is deemed to have failed. To adjust the timeout, you can set the `timeout` value, which is in seconds. A value of 0 causes the default 15 seconds timeout to be applied. It is not possible to deactivate stopping the test program after running for the default or a specified `timeout` value.

~~~
```examiner:execute-test
name: test-that-pod-exists
title: Verify that pod named "one" exists
args:
- one
timeout: 5
```
~~~

To apply the test multiple times, you can enable the retry when a failure occurs. For this you must set the number of times to retry and the delay between retries. The value for the delay is in seconds.

~~~
```examiner:execute-test
name: test-that-pod-exists
title: Verify that pod named "one" exists
args:
- one
timeout: 5
retries: 10
delay: 1
```
~~~

When you use retries, the testing stops as soon as the test program returns that it was successful.

To have retries continue for as long as the page of the workshop instructions displays, set `retries` to the special YAML value of `.INF`:

~~~
```examiner:execute-test
name: test-that-pod-exists
title: Verify that pod named "one" exists
args:
- one
timeout: 5
retries: .INF
delay: 1
```
~~~

Rather than require a workshop user to click the action to run the test, you can have the test start as soon as the page is loaded, or when a section the page is contained in is expanded. Do this by setting `autostart` to `true`:

~~~
```examiner:execute-test
name: test-that-pod-exists
title: Verify that pod named "one" exists
args:
- one
timeout: 5
retries: .INF
delay: 1
autostart: true
```
~~~

When a test succeeds, to immediately start the next test in the same page, set `cascade` to `true`.

~~~
```examiner:execute-test
name: test-that-pod-exists
title: Verify that pod named "one" exists
args:
- one
timeout: 5
retries: .INF
delay: 1
autostart: true
cascade: true
```

```examiner:execute-test
name: test-that-pod-does-not-exist
title: Verify that pod named "one" does not exist
args:
- one
retries: .INF
delay: 1
```
~~~

## <a id="click-actions-sections"></a>Clickable actions for sections

For optional instructions, or instructions you want to hide until the workshop user is ready for them, you can designate sections to be hidden. When the user clicks the appropriate action, the section expands to show its content. You can use this for examples that initially hide a set of questions or a test at the end of each workshop page.

In order to designate a section of content as hidden, you must use two separate action code blocks marking the beginning and end of the section:

~~~
```section:begin
title: Questions
```

To show you understand ...

```section:end
```
~~~

The `title` must be set to the text you want to include in the banner for the clickable action.

A clickable action is only shown for the beginning of the section, and the action for the end is always hidden. Clicking the action for the beginning expands the section. The user can collapse the section again by clicking the action.

To create nested sections, you must name the action blocks for the beginning and end so they are correctly matched:

~~~
```section:begin
name: questions
title: Questions
```

To show you understand ...

```section:begin
name: question-1
prefix: Question
title: 1
```

...

```section:end
name: question-1
```

```section:end
name: questions
```
~~~

The `prefix` attribute allows you to override the default `Section` prefix used on the title for the action.

If a collapsible section includes an examiner action block set to automatically run, it only starts when the user expands the collapsible section.

In case you want a section header showing in the same style as other clickable actions, you can use:

~~~
```section:heading
title: Questions
```
~~~

When the user clicks on this, the action is still marked as completed, but it does not trigger any other action.

## <a id="override-title-desc"></a>Overriding title and description

Clickable action blocks default to use a title with the prefix dictated by what the action block does. The body of the action block also defaults to use a value commensurate with the action.

Especially for complicated scenarios involving editing of files, the defaults might not be the most appropriate and be confusing, so you can override them. To override these defaults, set the `prefix`, `title`, and `description` fields of a clickable action block:

~~~
```action:name
prefix: Prefix
title: Title
description: Description
```
~~~

The banner of the action block in this example displays "Prefix: Title", with the body showing "Description".

>**Note** The description is always displayed as pre-formatted text within the rendered page.

## <a id="escape-code-block-content"></a>Escaping of code block content

Because the [Liquid](https://www.npmjs.com/package/liquidjs) template engine is applied to workshop content, you must escape content in code blocks that conflict with the syntactic elements of the Liquid template engine. To escape such elements, you can suspend processing by the template engine for that section of workshop content to ensure it is rendered correctly. Do this by using a Liquid `{% raw %}...{% endraw %}` block.

~~~
{% raw %}
```execute
echo "Execute command."
```
{% endraw %}
~~~

This has the side effect of preventing interpolation of data variables, so restrict it to only the required scope.

## <a id="interpolate-data-vars"></a>Interpolation of data variables

When creating page content, you can reference a number of predefined data variables. The values of the data variables are substituted into the page when rendered in the user's browser.

The workshop environment provides the following built-in data variables:

* `workshop_name`: The name of the workshop.
* `workshop_namespace`: The name of the namespace used for the workshop environment.
* `session_namespace`: The name of the namespace the workshop instance is linked to and into which any deployed applications run.
* `training_portal`: The name of the training portal the workshop is hosted by.
* `ingress_domain`: The host domain must be used in the any generated host name of ingress routes for exposing applications.
* `ingress_protocol`: The protocol (http/https) used for ingress routes created for workshops.

To use a data variable within the page content, surround it by matching pairs of brackets:

```text
\{{ session_namespace }}
```

Do this inside of code blocks, including clickable actions, as well as in URLs:

```text
http://myapp-\{{ session_namespace }}.\{{ ingress_domain }}
```

When the workshop environment is hosted in Kubernetes and provides access to the underlying cluster, the following data variables are also available.

* `kubernetes_token`: The Kubernetes access token of the service account the workshop session is running as.
* `kubernetes_ca_crt`: The contents of the public certificate required when accessing the Kubernetes API URL.
* `kubernetes_api_url`: The URL for accessing the Kubernetes API. This is only valid when used from the workshop terminal.

>**Note** An older version of the rendering engine required that data variables be surrounded on each side with the character `%`. This is still supported for backwards compatibility, but VMware recommends you use matched pairs of brackets instead.

## <a id="add-custom-data-variables"></a>Adding custom data variables

You can introduce your own data variables by listing them in the `workshop/modules.yaml` file. A data variable is defined as having a default value, but the value is overridden if an environment variable of the same name is defined.

The field under which the data variables must be specified is `config.vars`:

```yaml
config:
    vars:
    - name: LANGUAGE
      value: undefined
```

To use a name for a data variable that is different from the environment variable name, add a list of `aliases`:

```yaml
config:
    vars:
    - name: LANGUAGE
      value: undefined
      aliases:
      - PROGRAMMING_LANGUAGE
```

The environment variables with names in the list of aliases are checked first, then the environment variable with the same name as the data variable. If no environment variables with those names are set, the default value is used.

You can override the default value for a data variable for a specific workshop by setting it in the corresponding workshop file. For example, `workshop/workshop-python.yaml` might contain:

```yaml
vars:
  LANGUAGE: python
```

For more control over setting the values of data variables, you can provide the file `workshop/config.js`. The form of this file is:

```javascript
function initialize(workshop) {
    workshop.load_workshop();

    if (process.env['WORKSHOP_FILE'] == 'workshop-python.yaml') {
        workshop.data_variable('LANGUAGE', 'python');
    }
}

exports.default = initialize;

module.exports = exports.default;
```

This JavaScript code is loaded and the `initialize()` function called to set up the workshop configuration. You can then use the `workshop.data_variable()` function to set up any data variables.

Because it is JavaScript, you can write any code to query process environment variables and set data variables based on those. This might include creating composite values constructed from multiple environment variables. You can even download data variables from a remote host.

## <a id="pass-env-vars"></a>Passing environment variables

You can pass environment variables, including remapping of variable names, by setting your own custom data variables. If you don't need to set default values or remap the name of an environment variable, you can instead reference the name of the environment variable directly. You must prefix the name with `ENV_` when using it.

For example, to display the value of the `KUBECTL_VERSION` environment variable in the workshop content, use `ENV_KUBECTL_VERSION`, as in:

```text
\{{ ENV_KUBECTL_VERSION }}
```

## <a id="handling-embedded-url"></a>Handling embedded URL links

You can include URLs in workshop content. This can be the literal URL, or the Markdown or AsciiDoc syntax for including and labelling a URL. What happens when a user clicks on a URL depends on the specific URL.

In the case of the URL being an external website, when the URL is clicked, the URL opens in a new browser tab or window. When the URL is a relative page referring to another page that is part of the workshop content, the page replaces the current workshop page.

You can define a URL where components of the URL are provided by data variables. Data variables useful for this are `session_namespace` and `ingress_domain`, because they can be used to create a URL to an application deployed from a workshop:

```text
https://myapp-\{{ session_namespace }}.\{{ ingress_domain }}
```

## <a id="cond-rendering-content"></a>Conditional rendering of content

Rendering pages is in part handled by the [Liquid](https://www.npmjs.com/package/liquidjs) template engine. So you can use any constructs the template engine supports for conditional content:

```text
{% if LANGUAGE == 'java' %}
....
{% endif %}
{% if LANGUAGE == 'python' %}
....
{% endif %}
```

## <a id="embed-custom-html"></a>Embedding custom HTML content

Custom HTML can be embedded in the workshop content by using the appropriate mechanism provided by the content rendering engine used.

If using Markdown, HTML can be embedded directly without being marked as HTML:

```html
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin justo.

<div>
<table style="width:100%">
  <tr>
    <th>Firstname</th>
    <th>Lastname</th>
    <th>Age</th>
  </tr>
  <tr>
    <td>Jill</td>
    <td>Smith</td>
    <td>50</td>
  </tr>
  <tr>
    <td>Eve</td>
    <td>Jackson</td>
    <td>94</td>
  </tr>
</table>
</div>

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin justo.
```

If using AsciiDoc, HTML can be embedded by using a passthrough block:

```html
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin justo.

++++
<div>
<table style="width:100%">
  <tr>
    <th>Firstname</th>
    <th>Lastname</th>
    <th>Age</th>
  </tr>
  <tr>
    <td>Jill</td>
    <td>Smith</td>
    <td>50</td>
  </tr>
  <tr>
    <td>Eve</td>
    <td>Jackson</td>
    <td>94</td>
  </tr>
</table>
</div>
++++

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin justo.
```

In both cases, VMware recommends that the HTML consist of only a single HTML element. If you have more than one, include them all in a `div` element. The latter is necessary if any of the HTML elements are marked as hidden and the embedded HTML is a part of a collapsible section. If you don't ensure the hidden HTML element is placed under the single top-level `div` element, the hidden HTML element is visible when the collapsible section is expanded.

In addition to visual HTML elements, you can also include elements for embedded scripts or style sheets.

If you have HTML markup that must be added to multiple pages, extract it into a separate file and use the include file mechanism of the Liquid template engine. You can also use the partial render mechanism of Liquid as a macro mechanism for expanding HTML content with supplied values.
