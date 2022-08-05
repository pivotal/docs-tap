# WorkshopRequest resource

The `WorkshopRequest` custom resource defines a workshop request.

## <a id="specify-workshop-env"></a> Specifying workshop environment

The `WorkshopRequest` custom resource is used to request a workshop instance.
It does not provide details needed to perform the deployment of the workshop instance.
That information is sourced by the Learning Center Operator from the `WorkshopEnvironment`
and `Workshop` custom resources.

The minimum required information in the workshop request is the name of the workshop
environment. You supply this by setting the `environment.name` field.

For example:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: WorkshopRequest
metadata:
  name: lab-markdown-sample
spec:
  environment:
    name: lab-markdown-sample
```

A request is successful only if requesting a workshop instance for a workshop environment
is enabled for that workshop. You can enable requests in the `WorkshopEnvironment`
custom resource for the workshop environment.

If multiple workshop requests, for the same workshop environment or different ones, are
created in the same namespace, the `name` defined in the `metadata` for the workshop request must be
different for each. The value of this name is not used to name workshop
instances. You need the `name` value to delete the workshop instance, which is done by deleting the
workshop request.

## <a id="specify-req-access-token"></a> Specifying required access token

If a workshop environment is configured to require an access token when making a workshop request
against that environment, you can specify decide the token by setting the `environment.token` field.

For example:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: WorkshopRequest
metadata:
  name: lab-markdown-sample
spec:
  environment:
    name: lab-markdown-sample
    token: lab-markdown-sample
```

Even with the token, the request fails if the following is true:

* The workshop environment has restricted the namespaces from which a workshop request was made
* The workshop request was not created in one of the permitted namespaces
