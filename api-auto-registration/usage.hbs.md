In order to auto register your api with tap gui you just need to make a couple of modifications to your workload yaml.

1. Add the label `apis.apps.tanzu.vmware.com/register-api: "true"`
1. Add a param of `type api_descriptor`

```yaml
  params:
    - name: api_descriptor
      value:
        type: openapi   # One of openapi, aysnc, graphql, gRPC
        location: 
          path: "/v3/api-docs"  # The path to the api documentation
        owner: team-petclinic   # The team that owns this
        description: "A set of API endpoints to manage the resources within the petclinic app."
```

There are 2 different options for the location. 

The default supply chains use knative to deploy your applications. In this event the only location information you need to send is the path to the api documentation. The controller can figure out the base url for you.

Another option is you can hard code the url using the baseURL property.  The controller will use a combination of this baseURL and your path to retrieve the yaml

Example workload:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: petclinic-knative-02
  labels:
    apps.tanzu.vmware.com/workload-type: web
    apps.kubernetes.io/name: spring-petclinic
    apps.tanzu.vmware.com/has-tests: "true"
    app.kubernetes.io/part-of: spring-petclinic
    apis.apps.tanzu.vmware.com/register-api: "true" 
spec:
  source:
    git:
      url: https://github.com/LittleBaiBai/spring-petclinic.git
      ref:
        branch: accelerator
  params:
    - name: api_descriptor
      value:
        type: openapi
        location: 
          path: "/v3/api-docs"
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
    apps.tanzu.vmware.com/workload-type: web
    apps.kubernetes.io/name: spring-petclinic
    apps.tanzu.vmware.com/has-tests: "true"
    app.kubernetes.io/part-of: spring-petclinic
    apis.apps.tanzu.vmware.com/register-api: "true"
spec:
  source:
    git:
      url: https://github.com/LittleBaiBai/spring-petclinic.git
      ref:
        branch: accelerator
  params:
    - name: api_descriptor
      value:
        type: openapi
        location: 
          baseURL: http://petclinic-hard-coded.my-apps.shruti-tap.tapdemo.vmware.com/    
          path: "/v3/api-docs"
        owner: team-petclinic
        description: "A set of API endpoints to manage the resources within the petclinic app."
```