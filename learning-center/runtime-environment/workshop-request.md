# WorkshopRequest resource

The ``WorkshopRequest`` custom resource defines a workshop request.

## Specifying workshop environment

The ``WorkshopRequest`` custom resource is used only to request a workshop instance. It does not specify actual details needed to perform the deployment of the workshop instance. That information is instead sourced by the Learning Center Operator from the ``WorkshopEnvironment`` and ``Workshop`` custom resources.

The minimum required information in the workshop request is therefore just the name of the workshop environment. This is supplied by setting the ``environment.name`` field.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: WorkshopRequest
metadata:
  name: lab-markdown-sample
spec:
  environment:
    name: lab-markdown-sample
```

A request is successful only if the ability to request a workshop instance for a workshop environment has been enabled for that workshop. Enabling of requests needs to have been specified in the ``WorkshopEnvironment`` custom resource for the workshop environment.

If multiple workshop requests, whether for the same workshop environment or different ones, are created in the same namespace, the ``name`` defined in the ``metadata`` for the workshop request must be different for each. The value of this name is not important and is not used in naming of workshop instances. A user must remember it in order to delete the workshop instance, which is done by deleting the workshop request.

## Specifying required access token

Where a workshop environment has been configured to require an access token when making workshop request against that environment, you can specify it by setting the ``environment.token`` field.

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

Even with the token, if the workshop environment has restricted the namespaces from which a workshop request has been made and the workshop request was not created in one of the white listed namespaces, the request will fail.
