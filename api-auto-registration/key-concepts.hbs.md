# Key Concepts

## <a id='api-descriptor'></a>APIDescriptor Custom Resource Explained

For API Auto Registration to take place, a custom resource of type `APIDescriptor` needs to be created. 
The information from this CR is then used to construct an API entity in TAP GUI. 
Here are all the fields exposed by this custom resource.

```yaml
apiVersion: apis.apps.tanzu.vmware.com/v1alpha1
kind: APIDescriptor
metadata:
  name:                  # name of your APIDescriptor
  namespace:             # optional namespace of your APIDescriptor
spec:
  type:                  # type of the API spec. oneOf(openapi, grpc, asyncapi, graphql)
  description:           # description for the API exposed
  system:                # system that the API is part of
  owner:                 # person/team that owns the API
  location:
    path:                # sub-path where the API spec is available 
    baseURL:             # base URL object where the API spec is available. oneOf(url, ref)
      url:               # static absolute base URL
      ref:               # object ref to oneOf(HTTPProxy, Knative Service, Ingress)
        apiVersion:
        kind:
        name:
        namespace:
```

Many of the above fields will result in specific behavior within TAP GUI.
- The system and owner are copied to the API entity created. You may have to separately create and add to the catalog the [System](https://backstage.io/docs/features/software-catalog/descriptor-format#kind-system) and [Group](https://backstage.io/docs/features/software-catalog/descriptor-format#kind-group) kind. 
- The namespace where the APIDescriptor CR is applied gets used as the namespace for API entity in TAP GUI. This results in the API entity's name, system and owner to all be under that namespace.
- To explicitly use a system or owner in a different namespace, you can specify that in the respective field `system my-namespace/my-other system` or `owner: my-namespace/my-other-team`.

### <a id='absolute-url'></a>With an Absolute URL

To create an APIDescriptor with a static `baseURL.url`, you need to apply the following yaml to your cluster.

```yaml
apiVersion: apis.apps.tanzu.vmware.com/v1alpha1
kind: APIDescriptor
metadata:
  name: sample-absolute-url
spec:
  type: openapi
  description: A set of API endpoints to manage the resources within the petclinic app.
  system: spring-petclinic
  owner: team-petclinic
  location:
    path: "/v3/api-docs.yaml"
    baseURL:
      url: https://myservice.com
```

### <a id='with-ref'></a>With an Object Ref

You can also use an object reference instead of hard coding the url. This can point to a HTTPProxy, Knative Service, or Ingress.

Below is an example yaml that points to an HTTPProxy from which our controller extracts the `.spec.virtualhost.fqdn` as the baseURL.

```yaml
apiVersion: apis.apps.tanzu.vmware.com/v1alpha1
kind: APIDescriptor
metadata:
  name: sample-contour-ref
spec:
  type: openapi
  description: A set of API endpoints to manage the resources within the petclinic app.
  system: spring-petclinic
  owner: team-petclinic
  location:
    path: "/test/openapi"
    baseURL:
      ref:
        apiVersion: projectcontour.io/v1
        kind: HTTPProxy
        name: my-httpproxy
        namespace: my-namespace # optional
```

If you want to use a Knative Service instead, here is an example from which our controller reads the `status.url` as the baseURL

```yaml
# all other fields similar to the above example
    baseURL:
      ref:
        apiVersion: serving.knative.dev/v1
        kind: Service
        name: my-knative-service
        namespace: my-namespace # optional
```

Lastly, if you want to use an Ingress instead, here is an example from which our controller reads the URL from the jsonPath specified. When jsonPath is left empty, our controller will read the `"{.spec.rules[0].host}"` as the URL

```yaml
# all other fields similar to the above example
    baseURL:
      ref:
        apiVersion: networking.k8s.io/v1
        kind: Ingress
        name: my-ingress
        jsonPath: "{.spec.rules[1].host}"
        namespace: my-namespace # optional
```