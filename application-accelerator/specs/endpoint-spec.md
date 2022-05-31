# HTTP endpoint specification

This document specifies the contract for running an accelerator in the context of
a client-server interaction, where the "http endpoint" is typically running inside
a Kubernetes cluster alongside a web UI that allows triggering it.

## <a id="invocation"></a>Context of invocation

In most cases, the endpoint is invoked because a user browsing an Application Accelerator UI fills in values for
available accelerator options and clicks **Generate**. The user then
is served the result of the processing as a ZIP file or receives an error report.
The accelerator engine endpoint is either:

- Provided with a pointer to the accelerator
sources ("pull approach"), typically coming from a Git repository as a TAR file.
- Given the accelerator files as a TAR file directly ("push approach") and the
set of values the user chose for the accelerator options.

## <a id="endpoint-contract"></a>Endpoint contract

Request to run an accelerator is performed by POSTing to the `/invocations` endpoint.
The mode of operation (push _vs._ pull) is negotiated based on the `Content-Type` of the request.

### <a id="pull-based"></a>Pull-based approach

When using the pull-based approach, the request must be sent with a 
JSON (`Content-Type: application/json`) formatted payload of the following form:

  ```
  {
    "steps": [
      {
        "sources": {
          "archive": "http://<host>/gitrepository/default/podinfo/363a6a8fe6a7f13e05d34c163b0ef02a777da20a.tar.gz",
          "location": "file:///some/local/exploded/path",
          "subpath": "/my-sub-folder"
        }, 
        "options": {
          "optionOne": true,
          "optionTwo": "a string",
          "optionThree": ["an", "array", "of", "strings"],
          "optionFour": 9999
        }
      }
    ]
  }
  ```

The following is a lightweight specification for that payload:

- The payload MUST be a JSON object with a top-level `steps` property, itself 
  being a one-element array of JSON objects.
- That inner object MUST have both of the `sources` and `options` properties, 
  even if empty.
- The `sources` property is an object that MUST contain exactly one of the
  mutually exclusive properties, `archive` or `location`. The former is typical in
  the context of regular use and points to a TAR archive of a repository's contents, for example,
  from the Flux Git repository. That location MUST be accessible by the 
  accelerator engine with the host correctly qualified. The only supported protocol is
  http(s). The latter (`location`) is used for development purposes only. Do not 
  consider it a feature in the long run. It points to a directory on the local
  file system.
- Additionally, the `sources` object might contain a `subpath` property you can consider to be a subfolder inside the contents of the sources to locate the
  root of the accelerator. That is, the location of `<ROOT>` where the `<ROOT>/accelerator.yaml`
  resides. The default value is the empty string. That is, the root of the TAR file
  contents is to be considered the root of the accelerator. Any other value
  must be a forward-slash segmented string to be resolved relative to the
  actual TAR file contents (with no leading slash).
- The `options` property is a JSON object containing the values entered by the user,
  in accordance with the accelerator manifest:

  - All keys of that object must be camelCase words.
    - Default values do not need to be resolved before invocation, because they are resolved server-side.
    - Values must be resolved to their correct JSON type.
    - Given the specification of the accelerator manifest, in practice, the only possible types for values are:
      - JSON Boolean for values whose `dataType` is `boolean`.
      - JSON string for values whose `dataType` is `string`.
      - JSON number for values whose `dataType` is `number`.
      - JSON arrays of the preceding.

### <a id="push-based"></a>Push-based approach

When using the push-based approach, the request MUST be sent with a regular http
multipart form (`Content-Type: form/multipart`) payload where:

* Field named `0.File` contains the TAR archive contents of the accelerator files. 
  Notice the capital F in `0.File`, which distinguishes this filename from
  the ones used for options (see below).
* Fields named `0.<optionName>` where `<optionName>` is the camel case name
  of an option contain the string representation of an option value (similar
  to any regular http POST operation).

### <a id="endpoint-response"></a>Endpoint response

Irrespective of the pull _vs._ push approach used by the request, the response to an invocation is either:

- A byte stream, with http status 200 and `Content-Type: application/zip` in case
  of successful invocation, containing the resulting files encoded in a ZIP file.
  The ZIP file can have an additional top-level directory named after the `projectName` option. That is,
  an accelerator index.html at the root of the accelerator is at `<projectName>/index.html` 
  in the resulting ZIP file.
- An error report, with http status 4xx or 5xx and `Content-Type: application/json` containing
  a description of what went wrong, with the following format:

      ```
      {
        "title": "...",
        "status": 500,
        "detail": "...",
        "reportString": "...",
        "report": {...}
      }
      ```

      Where:

      - `title` is a short description of the error.
      - `status` has the same semantics as an http error code.
      - `detail` provides a longer description of the error.
      - `reportString` and `report` might both contain the execution log of the accelerator if invocation went that far. The former is an ASCII art rendering of it, while the latter is a JSON object with the same information.
        
