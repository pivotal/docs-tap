# Engine specification

This section describes the behavior of the _engine_ at runtime and how
it is influenced by elements of the manifest, combined with input 
a client provides by using the concept of _option values_.

This document only covers the general contract of accelerator rendering
and does not cover the details of invocation and passing of options, nor
does it cover the way the result of invocation can be delivered / retrieved.

For details about invocation over http, see
[HTTP endpoint specification](endpoint-spec.md). Other implementations, 
for example, local invocation by using a CLI, can exist, and the concepts here
remain applicable.

## <a id="invocation-lifecycle"></a>Invocation lifecycle

At a high level, the invocation of a single accelerator consists of the following
phases:

1. __Pre-validation__: To the best extent possible, the contents of the accelerator 
files are parsed and understood by the engine. This means that *errors in the 
configuration of the accelerator are reported early.

    *Errors in the contents of the `accelerator.yaml` manifest.

    For any state of the contents of a accelerator, that phase is cacheable. 
    In other words, the same files produce the same outcome.

2. __Model Population with Option Values__: The model is initially populated 
with all the values provided for invocation. Clients must provide values for 
all options defined in the [Options specification](options-spec.md) 
section of the manifest that are not configured with a 
[`defaultValue`](options-spec.md#defaultValue).
   
3. __Model Population with Option Values Defaults__: The options defined 
in the manifest with a `defaultValue` and that haven't already been set are 
given their default value.

    The populated model is then validated against the accelerator manifest:

    1. All passed-in options MUST have a valid [`name`](options-spec.md#name).
    2. All known options MUST be present. That is, the set of names declared must be a subset of the ones present.
    3. All known options MUST be of a type that conforms to their declared [`dataType`](options-spec.md#dataType).

    Failure to validate stops processing and causes an error being reported.

4. __Addition of *Standard Variables*__: The model is further populated with 
additional values that the engine always computes, including values that 
might depend on the contents of an existing target directory.
   
    The exact set of standard variables is out of the scope of this specification,
    but the engine never overwrites a user-provided option with a standard variable.
    That is, authors can always provide the option to override a standard variable.
   
    Errors can happen while computing the value of a standard variable, in
    which case processing stops and an error is reported.
   
5. __Rendering__: All files that make up the contents of the accelerator 
(except the manifest file itself), and the option values and derived symbols are provided to 
a transformation process that takes them as input and produces a transformed set of files.
