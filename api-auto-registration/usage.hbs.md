# API Auto Registration Usage

## <a id='prereqs'></a>Using Supply Chains

In order to auto register your api with tap gui you just need to make a couple of modifications to your workload yaml.

1. Add the label `apis.apps.tanzu.vmware.com/register-api: "true"`
1. Add a param of `type api_descriptor`

```yaml
  params:
    - name: api_descriptor
      value:
        type: openapi   # We currently support any of openapi, aysncapi, graphql, grpc
        location: 
          path: "/v3/api-docs"  # The path to the api documentation
        owner: team-petclinic   # The team that owns this
        description: "A set of API endpoints to manage the resources within the petclinic app."
```

There are 2 different options for the location. 

The default supply chains use knative to deploy your applications. In this event the only location information you need to send is the path to the api documentation. The controller can figure out the base url for you.

Another option is you can hard code the url using the baseURL property.  The controller will use a combination of this baseURL and your path to retrieve the yaml

Example workload that exposes a knative service:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: petclinic-knative
  labels:
    apps.tanzu.vmware.com/workload-type: web
    apps.kubernetes.io/name: spring-petclinic
    apps.tanzu.vmware.com/has-tests: "true"
    app.kubernetes.io/part-of: spring-petclinic
    apis.apps.tanzu.vmware.com/register-api: "true" 
spec:
  source:
    ...
  params:
    - name: api_descriptor
      value:
        type: openapi
        location: 
          path: "/v3/api-docs"
        system: pet-clinics  
        owner: team-petclinic
        description: "A set of API endpoints to manage the resources within the petclinic app."

```

Example of a workload with a hard coded url to the api documentation
```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: petclinic-hard-coded
  labels:
    ...
    apis.apps.tanzu.vmware.com/register-api: "true"
spec:
  source:
    ...
  params:
    - name: api_descriptor
      value:
        type: openapi
        location: 
          baseURL: http://petclinic-hard-coded.my-apps.tapdemo.vmware.com/    
          path: "/v3/api-docs"
        owner: team-petclinic
        system: pet-clinics
        description: "A set of API endpoints to manage the resources within the petclinic app."
```

## <a id='without-supply-chain'></a>Without the OOTB Supply Chains
You can also utilize API Auto Registration if you are not using supply chains. You can do this by directly creating an APIDescriptor custom resource.

### <a id='prereqs'></a>With an Absolute URL

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

### <a id='prereqs'></a>With a Ref

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

```