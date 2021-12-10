# Configuring and understanding logs

This topic covers how to configure the Supply Chain Security Tools - Store to output detailed log information and interpret them.

## Log levels

There are six log levels that the Supply Chain Security Tools - Store supports. 

| Level   |            Description                      |
| ------- | ------------------------------------------- |
| Trace   | Output extended debugging logs              |
| Debug   | Output standard debugging log               |
| More    | Output more verbose informational logs      |
| Default | Output standard informational logs          |
| Less    | Outputs less verbose informational logs     |
| Minimum | Outputs a minimal set of informational logs |

When the Store is deployed at a specific log level, all logs of that level and lower will be outputted to the console. For example, setting the log level to `More` will output logs from `Minimal` to `More`, while `Debug` and `Trace` logs will be muted.

Currently, the application logs output at these levels:

* Minimum - Does not output any logs.
* Less - Outputs a single log line indicating the current log level the Metadata Store is configured to when the application starts.
* Default - Outputs API endpoint access information.
* Debug - Outputs API endpoint payload information, both for requests and responses.

Other log levels do not output any additional log information and are present for future extensibility.

If no log level is specified when the Store is installed, the log level is set to `default`.

## API endpoint log output

When an API endpoint handles a request, the Store generates two and five log lines. They are:

1. When the endpoint receives a request, it outputs a `Processing request` line. This log line is shown at the `default` log level.
1. If the endpoint includes query or path parameters, it outputs a `Request parameters` line. This line logs the parameters passed in the request. This line is shown at the `default` log level.
1. If the endpoint takes in a request body, it outputs a `Request body` line. This line outputs the entire request body as a string. This line is shown at the `debug` log level.
1. When the endpoint returns a response, it outputs a `Request response` line. This line is shown at the `default` log level.
1. If the endpoint returns a response body, it outputs a second `Request response` line with an extra key `payload`, and its value is set to the entire response body. This line is shown at the `debug` log level.

### Format
When the Store handles a request, it outputs some API endpoint access information in the following format:
```
I1122 20:30:21.869528       1 images.go:26] MetadataStore "msg"="Processing request" "endpoint"="/api/images?digest=sha256%3A20521f76ff3d27f436e03dc666cc97a511bbe71e8e8495f851d0f4bf57b0bab6" "hostname"="metadata-store-app-564f8995c8-r8d6n" "method"="GET"
```

The log is broken down into three sections: The header, name, and key/value pairs.

#### Log header
`I1122 20:30:21.869528       1 images.go:26]` is the logging header. The [Logging header formats](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-instrumentation/logging.md#logging-header-formats) section explains each part in more detail.

#### Name
The string that follows the header is a name that helps identify what produced the log line. For the case of the Store, the name is always `MetadataStore`.

#### Key/Value pairs
Key/value pairs compose the rest of the log output. The tables below list each key and the meaning of their value.

##### Common to all logs
The following key/value pairs are common for all logs.

| Key | Type | Log Level | Description |
| --- | ---- | ----------| ------------|
| msg | string | default | A short description of the logged event. In the error log line, these will also include the error message. |
| endpoint | string | default | The API endpoint the Metadata Store is attempting to handle the request. This also includes any query and path parameters passed in. |
| hostname | string | default | The Kubernetes hostname of the pod handling the request. This helps identify the specific instance of the Store when multiple instances are deployed on a cluster. |
| function | string | debug | The function name that handles the request. |
| method | string | default |The HTTP verb used to access the endpoint. For example, "GET" or "POST." |
| code | integer | default | The HTTP response code. |
| response | string | default | The HTTP response in human-readable format. For example, "OK", "Bad Request", or "Internal Server Error." |

##### Logging query and path parameter values

Those endpoints that use query or path parameters are logged on the `Request parameters` log line as key/value pairs. Afterward, they are appended to all other log lines of the same request as key/value pairs.

The key names are the query or path parameter's name, while the value is set to the value of those parameters in string format.

For example, the following log line:
```
I1122 20:30:21.869791       1 images.go:34] MetadataStore "msg"="Request parameters" "endpoint"="/api/images?digest=sha256%3A20521f76ff3d27f436e03dc666cc97a511bbe71e8e8495f851d0f4bf57b0bab6" "hostname"="metadata-store-app-564f8995c8-r8d6n" "method"="GET" "digest"="sha256:20521f76ff3d27f436e03dc666cc97a511bbe71e8e8495f851d0f4bf57b0bab6" "id"=0
```
contains the `digest` and `id` key, which represents the respective `digest` and `id` query parameters, as well as their values. 

These key/value pairs show up in all subsequent log lines of the same call. For example:
```
I1122 20:30:21.878749       1 images.go:56] MetadataStore "msg"="Request response" "digest"="sha256:20521f76ff3d27f436e03dc666cc97a511bbe71e8e8495f851d0f4bf57b0bab6" "endpoint"="/api/images?digest=sha256%3A20521f76ff3d27f436e03dc666cc97a511bbe71e8e8495f851d0f4bf57b0bab6" "hostname"="metadata-store-app-564f8995c8-r8d6n" "id"=0 "method"="GET" "code"=200 "response"="OK"
```

This is done to ensure two things:

1. The application interprets the values of the query or path parameters correctly.
2. Help figure out which log lines are associated with a particular API request. Since there can be several simultaneous endpoint calls, this is a first attempt at trying to group logs by specific calls.

##### API payload log output
As mentioned at the start of this section, by setting the log level to `debug`, the Store logs the body payload data for both the request and response of an API call.

Using `debug` log level, instead of `default`, to display this information was done for the following two reasons:

* Body payloads can be huge, containing full CycloneDX and SBOM information. Moving the payload information at this level helps keep the production log output to a reasonable size.
* Some information in these payloads may be sensitive, and the user may not want them exposed in production environment logs.
