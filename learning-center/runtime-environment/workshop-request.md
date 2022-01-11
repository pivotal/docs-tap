# WorkshopRequest resource

The `WorkshopRequest` custom resource defines a workshop request.

## <a id="specify-workshop-env"></a> Specifying workshop environment

The `WorkshopRequest` custom resource is used only to request a workshop instance.
It does not specify actual details needed to perform the deployment of the workshop instance.
That information is instead sourced by the Learning Center Operator from the `WorkshopEnvironment`
and `Workshop` custom resources.

The minimum required information in the workshop request is therefore just the name of the workshop
environment. You supply this by setting the `environment.name` field.

For example:

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: WorkshopRequest
metadata:
  name: lab-markdown-sample
spec:
  environment:
    name: lab-markdown-sample
```

A request is successful only if the ability to request a workshop instance for a workshop environment
is enabled for that workshop. Enabling of requests must be specified in the `WorkshopEnvironment`
custom resource for the workshop environment.

If multiple workshop requests, whether for the same workshop environment or different ones, are
created in the same namespace, the `name` defined in the `metadata` for the workshop request must be
different for each. The value of this name is not important and is not used in the naming of workshop
instances. A user must remember it to delete the workshop instance, which is done by deleting the
workshop request.

## <a id="specify-workshop-env"></a> Specifying required access token

If a workshop environment was configured to require an access token when making a workshop request
against that environment, you can specify the token by setting the `environment.token` field.

For example:

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: WorkshopRequest
metadata:
  name: lab-markdown-sample
spec:
  environment:
    name: lab-markdown-sample
    token: lab-markdown-sample
```

Even with the token, the request still fails if the following is true:

* The workshop environment has restricted the namespaces from which a workshop request was made
* The workshop request was not created in one of the permitted namespaces
