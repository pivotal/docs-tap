# WorkshopSession resource

The `WorkshopSession` custom resource defines a workshop session.

## <a id="specify-session-id"></a> Specifying the session identity

When running training for multiple people, typically you'll use the `TrainingPortal` custom
resource to set up a training environment. Alternatively, you can set up a workshop environment by using the
`WorkshopEnvironment` custom resource, and then create requests for workshop instances by using the
`WorkshopRequest` custom resource. If you're creating requests for workshop instances, and you need
more control over how the workshop instances are set up, you can use `WorkshopSession` custom
resource instead of `WorkshopRequest`.

To specify the workshop environment the workshop instance is created against, set the
`environment.name` field of the specification for the workshop session.
You must also specify the session ID for the workshop instance. For example:

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

The `name` of the workshop specified in the `metadata` of the training environment must be
globally unique for the workshop instance you're creating. You must create a separate
`WorkshopSession` custom resource for each workshop instance.

The session ID must be unique within the workshop environment that you're creating the workshop instance against.

## <a id="specify-login-creds"></a> Specifying the login credentials

You can control access to each workshop instance using login credentials.
This ensures one workshop attendee cannot interfere with another.

To set login credentials for a workshop instance, set the `session.username` and `session.password`
fields. For example:

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

If you do not specify login credentials, the workshop instance has no access controls and anyone can
access it.

## <a id="specify-ingress-domain"></a> Specifying the ingress domain

To access the workshop instance by using a public URL, you must specify an ingress domain.
If an ingress domain isn't specified, use the default ingress domain that the Learning Center operator
was configured with.

When setting a custom domain, configure DNS with a wildcard domain to forward all
requests for sub-domains of the custom domain to the ingress router of the Kubernetes cluster.

To provide the ingress domain, you can set the `session.ingress.domain` field. For example:

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

You can create a full host name for the session by prefixing the ingress domain with a host name
constructed from the name of the workshop environment and the session ID.

If overriding the domain, by default, the workshop session is exposed by using a HTTP connection.
If you require a secure HTTPS connection, you must have access to a wildcard SSL certificate for
the domain.

You must create a secret of type `tls` for the certificate in the `learningcenter` namespace or in the
namespace where the Learning Center operator is deployed.
You must then set the name of that secret in the `session.ingress.secret` field. For example:

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

You can terminate HTTPS connections by using an external load balancer rather than by specifying a
secret for ingresses managed by the Kubernetes ingress controller. When routing traffic into the Kubernetes cluster as HTTP connections,
you can override the ingress protocol without specifying an
ingress secret by setting the `session.ingress.protocol` field.

For example:

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
      protocol: https
```

To override or set the ingress class, add `session.ingress.class`. This dictates which
ingress router is used when more than one option is available.

For example:

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
      class: nginx
```

## <a id="set-env-var"></a> Setting the environment variables

To set the environment variables for the workshop instance, provide the environment variables in the
`session.env` field.

```yaml
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
    - name: REPOSITORY-URL
      value: YOUR-GIT-URL-FOR-LAB-MARKDOWN-SAMPLE
```

Where `YOUR-GIT-URL-FOR-LAB-MARKDOWN-SAMPLE` is the Git repository URL for `lab-markdown-sample`. For example, `{YOUR-GIT-REPO-URL}/lab-markdown-sample`.

Values of fields in the list of resource objects can reference a number of predefined parameters.
Available parameters are:

- `session_id` is a unique ID for the workshop instance within the workshop environment.
- `session_namespace` is the namespace created for and bound to the workshop instance.
This is the namespace unique to the session and where a workshop can create their own resources.
- `environment_name` is the name of the workshop environment. For now this is the same as the name
of the namespace for the workshop environment.
Don't rely on them being the same, and use the most appropriate to cope with any future change.
- `workshop_namespace` is the namespace for the workshop environment.
This is the namespace where all deployments of the workshop instances are created, and where the
service account that the workshop instance runs as exists.
- `service_account` is the name of the service account the workshop instance runs as, and which has
access to the namespace created for that workshop instance.
- `ingress_domain` is the host domain under which host names can be created when creating ingress
routes.
- `ingress_protocol` is the protocol (http/https) used for ingress routes created for workshops.

The syntax for referencing one of the parameters is `$(parameter_name)`.

If the workshop environment had specified a set of extra environment variables to be set for workshop
instances, it is up to you to incorporate those in the set of environment variables you list under
`session.env`. That is, anything listed in `session.env` of the `WorkshopEnvironment` custom
resource of the workshop environment is ignored.
