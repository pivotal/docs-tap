# Application Accelerator sample accelerator.yaml file

This topic provides you with a sample accelerator file to get you started
writing your own accelerators in Tanzu Application Platform (commonly known as TAP).

```yaml
accelerator:
  # The `accelerator` section serves to document how an accelerator is presented to the
  # user in the accelerator web UI.

  # displayName: a descriptive human-readable name. Make this short so as to look nice
  #              in a list of many accelerators shown to a user.
  displayName: Hello Spring Boot

  # description: a more detailed description that a user can see if they took a closer
  #              look at a particular accelerator.
  description: Simple Hello World Rest Service based on Spring Boot

  # iconUrl: Optional, a nice colorful, icon for your accelerator to make it stand out visually.
  iconUrl: https://raw.githubusercontent.com/vmware-tanzu/application-accelerator-samples/main/icons/icon-cloud.png

  # tags: A list of classification tags. The UI allows users to search for accelerators based on tags
  tags:
    - Java
    - Spring
    - Function

  # options are parameters that can affect how the accelerator behaves.
  # The purpose of the options section is
  #   - to list all applicable options
  #   - describe each option in enough detail so that the UI can create
  #     a suitable input widget for it.
  options: # a list of options
    # a first option
    - name:
        greeting
        # name: each option must have a name.
        # This must be
        #   - camelCase
        #   - unique (i.e. no two options can have the same name)
        # This is like a variable used by the accelerator to refer to
        # and use the value during its execution.
        # This name is internal to your accelerator and is not shown to
        # the user.
      label:
        Greeting Message
        # A human readable version of the `name`. This is used to identify an
        # option to the user in the UI.
        # This should be short (so as not to look ugly in a ui with limited
        # space available for labeling the input widgets).
        # There are no limits on what characters can be used in the label (so spaces
        # are allowed).
      description:
        Greeting message displayed by the Hello World app.
        # An optional more detailed description / explanation that can be shown to
        # to the user in the UI when the short label alone might not be enough to understand
        # its purpose.
      dataType:
        string
        # type of data the accelerator expects during execution (this is
        # like the type of the 'variable'.
        # possible dataTypes are string, boolean, number or [string] (the latter meaning a
        # list of strings
      inputType:
        text
        # Related to the dataType but somewhat independent, this identifies the type
        # of widget shown in the ui. Available types are:
        # - text - the default
        # - toggle (boolean on/off control)
        # - textarea (single text value with larger input that allows linebreaks)
        # - checkbox - multivalue selection from choices
        # - select - single value selection from choices
        # - radio - alternative single value selection from choices
        # - tag - multivalue input ui for entering single-word tags
      required: true
      defaultValue: Hello Accelerator
    # second option:
    - name: packageName
      label: "Package Name"
      description: Name of Java package
      dataType: string
      inputType: text
      defaultValue: somepackage
    # another option:
    - name: buildType
      label: Build Type
      description: Choose whether to use Maven or Gradle to build the project.
      dataType: string
      inputType: select
      choices:
        - value: Maven
          text: Maven (pom.xml)
        - value: Gradle
          text: Gradle (build.gradle)

# The 'engine' section describes how to take the files from the accelerator
# repo root folder and 'transform' them into the contents of a generated project / zip.
# transformation operate on the files as a set and can do things like:
# - filtering the set of files (i.e. removing / keeping only files that match certain criteria)
# - changing the contents of a file (e.g. replacing some strings in them)
# - renaming or moving files (changing the paths of the files)
engine:
  # this is the 'global' transformation node. It produces the final set of
  # files to be zipped and returned from the accelerator.
  # As input it receives all the files from the accelerator repo root.

  # The properties in this node dictate how this set of files is
  # transformed into a final set of files to zip up as the accelerator
  # result.

  include:
    ["**/*.md", "**/*.xml", "**/*.gradle", "**/*.java"]
    # This globally defined `include` filters the set of files
    # retaining only those matching a given list of path patterns.
    # This can ensure that only files in the repo matching the list of
    # patterns will be seen / considered by the accelerator.

  exclude:
    ["**/secret/**"]
    # This globally defined `exclude` further restricts what files are considered.
    # This example ensures files in any directory called `secret` are never considered.

  # Under 'let' you can define additional variables and assign them values
  # These 'derived symbols' function much like options, but instead of
  # being supplied from a UI widget, they are computed by the accelerator itself.
  let:
    - name: includePoms # name of a symbol, must be camelCase
      expression:
        "#buildType == 'Maven'" # <- SpEL expression given as a string. You must take care to use
        # proper quotes to avoid yaml treating '#' as starting a comment.
    - name: includeGradle
      expression: "#buildType == 'Gradle'"
  merge: # This merge section executes each of its children 'in parallel'.
    # Each child receives a copy of the current set of input files.
    # (i.e. the files that are remaining after considering the `include` and `exclude`.
    # Each of the children thus produces a set of files.
    # Merge then combines all the files from all the children, as if by overlaying them on top of each other
    # in the same directory. If more than one child produces a file with the same path,
    # this 'conflict' is resolved by dropping the file contents from the earlier child
    # and keeping only the later one.
    # merge child 1: this child node wants to contribute 'gradle' files to the final result
    - condition:
        "#includeGradle" # this child is deactivated if the Gradle option was not selected by the user
        # A deactivated child doesn't contribute anything to the final result.
      include: ["*.gradle"] # this child only focusses on gradle files (ignoring all other files)
    # merge child 2: this child wants to contribute 'pom' files to the final result
    - condition: "#includePoms"
      include: ["pom.xml"]
    # merge child 3: this child wants to contribute Java code and README.md to the final result
    - include: ["**/*.java", "README.md"]
      # Using: chain you can specify additional transformations to be applied to the set
      # of files produced by this child (i.e. the `ReplaceText` below is only applied to .java files and README.md)
      chain:
        - type: ReplaceText
          substitutions:
            - text: "Hello World!"
              with: "#greeting"
  chain:
    # Globally specified chain, works like the one `from merge child 3`. But because it is global, it
    # applies transformation to all files globally.
    #
    # The chain has a list of child transformations. These transformation are applied after everything else
    # in the same node (here we are in the 'global node').
    #
    # The children in a chain are applied sequentially.
    - type: RewritePath
      regex: (.*)simpleboot(.*)
      rewriteTo: "#g1 + #packageName + #g2" # SpEL expression. You can use '#g1' and '#g2' to reference 'match groups'
    - type: ReplaceText
      substitutions:
        - text: simpleboot
          with: "#packageName"
  onConflict:
    Fail # other values are `UseFirst`, `UseLast`, or `Append`
    # when merging (or really any operation) produces multiple files at the same path
    # this defines how that conflict is handled.
    # Fail: raise an error when conflict happens
    # UseFirst: keep the contents of the first file
    # UseLast: keep the contents of the last file
    # Append: keep both as by using `cat <first-file> <second-file>`).
```
