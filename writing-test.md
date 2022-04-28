# Writing test

# WorkshopSession Resource

The WorkshopSession custom resource defines a workshop session.

## Specifying the session identity

When running training for multiple people, it would be more typical to use the TrainingPortal custom resource to setup a training environment. Alternatively you would set up a workshop environment using the WorkshopEnvironment custom resource, then create requests for workshop instances using the WorkshopRequest custom resource. If doing the latter and you need more control over how the workshop instances are setup, you can use WorkshopSession custom resource instead of WorkshopRequest.

Note that to specify the workshop environment the workshop instance is created against, set the environment.name field of the specification for the workshop session. At the same time, you must specify the session ID for the workshop instance.

```yaml
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

The name of the workshop specified in the metadata of the training environment needs to be globally unique for the workshop instance being created. You would need to create a separate WorkshopSession custom resource for each workshop instance you want.

The session ID needs to be unique within the workshop environment the workshop instance is being created against.

## Specifying the login credentials

Access to each workshop instance can be controlled through login credentials. This is so that a workshop attendee cannot interfere with another.

If you want to set login credentials for a workshop instance, you can set the session.username and session.password fields.

```yaml
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


If you do not specify login credentials, there will not be any access controls on the workshop instance and anyone will be able to access it.

## Specifying the ingress domain

In order to be able to access the workshop instance using a public URL, you will need to specify an ingress domain. If an ingress domain isn't specified, the default ingress domain that the Learning Center Operator has been configured with will be used.

When setting a custom domain, DNS must have been configured with a wildcard domain to forward all requests for sub domains of the custom domain, to the ingress router of the Kubernetes cluster.

To provide the ingress domain, you can set the session.ingress.domain field.

```yaml
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

A full hostname for the session will be created by prefixing the ingress domain with a hostname constructed from the name of the workshop environment and the session ID.

If overriding the domain, by default, the workshop session will be exposed using a HTTP connection. If you require a secure HTTPS connection, you will need to have access to a wildcard SSL certificate for the domain. A secret of type tls should be created for the certificate in the learningcenter namespace or the namespace where Learning Center Operator is deployed. The name of that secret should then be set in the session.ingress.secret field.

```yaml
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

If HTTPS connections are being terminated using an external load balancer and not by specificying a secret for ingresses managed by the Kubernetes ingress controller, with traffic then routed into the Kubernetes cluster as HTTP connections, you can override the ingress protocol without specifying an ingress secret by setting the session.ingress.protocol field.
