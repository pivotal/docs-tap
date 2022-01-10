# WorkshopSession Resource

The ``WorkshopSession`` custom resource defines a workshop session.

## Specifying the session identity

When running training for multiple people, it is more typical to use the ``TrainingPortal`` custom resource to set up a training environment. Alternatively you set up a workshop environment using the ``WorkshopEnvironment`` custom resource, then create requests for workshop instances using the ``WorkshopRequest`` custom resource. If you are creating requests for workshop instances and you need more control over how the workshop instances are set up, you can use ``WorkshopSession`` custom resource instead of ``WorkshopRequest``.

To specify the workshop environment the workshop instance is created against, set the ``environment.name`` field of the specification for the workshop session. At the same time, you must specify the session ID for the workshop instance.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: WorkshopSession
metadata:
  name: lab-markdown-sample-user1
spec:
  environment:
    name: lab-markdown-sample
  session:
    id: user1
```

The ``name`` of the workshop specified in the ``metadata`` of the training environment needs to be globally unique for the workshop instance being created. You need to create a separate ``WorkshopSession`` custom resource for each workshop instance you want.

The session ID needs to be unique within the workshop environment the workshop instance is being created against.

## Specifying the login credentials

Access to each workshop instance can be controlled through login credentials. This is so that a workshop attendee cannot interfere with another.

If you want to set login credentials for a workshop instance, you can set the ``session.username`` and ``session.password`` fields.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: WorkshopSession
metadata:
  name: lab-markdown-sample
spec:
  environment:
    name: lab-markdown-sample-user1
  session:
    username: learningcenter
    password: lab-markdown-sample
```

If you do not specify login credentials, the workshop instance has no access controls and anyone can access it.

## Specifying the ingress domain

To be able to access the workshop instance using a public URL, you need to specify an ingress domain. If an ingress domain isn't specified, use the default ingress domain that the Learning Center Operator has been configured with.

When setting a custom domain, DNS must have been configured with a wildcard domain to forward all requests for sub-domains of the custom domain to the ingress router of the Kubernetes cluster.

To provide the ingress domain, you can set the ``session.ingress.domain`` field.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: WorkshopSession
metadata:
  name: lab-markdown-sample
spec:
  environment:
    name: lab-markdown-sample-user1
  session:
    ingress:
      domain: training.learningcenter.tanzu.vmware.com
```

You can create a full hostname for the session by prefixing the ingress domain with a hostname constructed from the name of the workshop environment and the session ID.

If overriding the domain, by default, the workshop session is exposed using a HTTP connection. If you require a secure HTTPS connection, you need to have access to a wildcard SSL certificate for the domain. 

A secret of type ``tls`` must be created for the certificate in the ``learningcenter`` namespace or the namespace where Learning Center Operator is deployed. The name of that secret must then be set in the ``session.ingress.secret`` field.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: WorkshopSession
metadata:
  name: lab-markdown-sample
spec:
  environment:
    name: lab-markdown-sample-user1
  session:
    ingress:
      domain: training.learningcenter.tanzu.vmware.com
      secret: training.learningcenter.tanzu.vmware.com-tls
```

If HTTPS connections are being terminated using an external load balancer and not by specifying a secret for ingresses managed by the Kubernetes ingress controller, then routing traffice into the Kubernetes cluster as HTTP connections, you can override the ingress protocol without specifying an ingress secret by setting the ``session.ingress.protocol`` field.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: WorkshopSession
metadata:
  name: lab-markdown-sample
spec:
  environment:
    name: lab-markdown-sample-user1
  session:
    ingress:
      domain: training.learningcenter.tanzu.vmware.com
      protocol: https
```

If you need to override or set the ingress class, which dictates which ingress router is used when more than one option is available, you can add ``session.ingress.class``.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: WorkshopSession
metadata:
  name: lab-markdown-sample
spec:
  environment:
    name: lab-markdown-sample-user1
  session:
    ingress:
      domain: training.learningcenter.tanzu.vmware.com
      secret: training.learningcenter.tanzu.vmware.com-tls
      class: nginx
```

## Setting the environment variables

If you want to set the environment variables for the workshop instance, you can provide the environment variables in the ``session.env`` field.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: WorkshopSession
metadata:
  name: lab-markdown-sample
spec:
  environment:
    name: lab-markdown-sample
  session:
    id: user1
    env:
    - name: REPOSITORY_URL
      value: PREPLACE WITH YOUR OWN GIT URL LOCATION FOR lab-markdown-sample
```

Values of fields in the list of resource objects can reference a number of pre-defined parameters. The available parameters are:

- ``session_id`` - A unique ID for the workshop instance within the workshop environment.
- ``session_namespace`` - The namespace created for and bound to the workshop instance. This is the namespace unique to the session and where a workshop can create their own resources.
- ``environment_name`` - The name of the workshop environment. For now this is the same as the name of the namespace for the workshop environment. Don't rely on them being the same, and use the most appropriate to cope with any future change.
- ``workshop_namespace`` - The namespace for the workshop environment. This is the namespace where all deployments of the workshop instances are created, and where the service account that the workshop instance runs as exists.
- ``service_account`` - The name of the service account the workshop instance runs as, and which has access to the namespace created for that workshop instance.
- ``ingress_domain`` - The host domain under which hostnames can be created when creating ingress routes.
- ``ingress_protocol`` - The protocol (http/https) that is used for ingress routes which are created for workshops.

The syntax for referencing one of the parameters is ``$(parameter_name)``.

If the workshop environment had specified a set of extra environment variables to be set for workshop instances, it is up to you to incorporate those in the set of environment variables you list under ``session.env``. That is, anything listed in ``session.env`` of the ``WorkshopEnvironment`` custom resource of the workshop environment is ignored.
