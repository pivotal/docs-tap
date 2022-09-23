# Use API Auto Registration 

## <a id='usage'></a>Using App Accelerator template

If you are creating a new application exposing an API, you might use the ["java-rest-service"](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/java-rest-service)
App Accelerator template to get an out-of-the-box app that includes an already written workload.yaml with a basic REST API.
From your Tanzu Application Platform GUIs Accelerators tab, you can search for the accelerator and scaffold it according to your needs.

## <a id='with-ootb-supply-chain'></a>Using Out Of The Box Supply Chains

All the Out-Of-The-Box supply chains are modified so that they can use API Auto Registration. If you want your Workload to be auto registered, you must make a couple of modifications to your workload YAML as described later.

1. Add the label `apis.apps.tanzu.vmware.com/register-api: "true"`.
2. Add a parameter of `type api_descriptor`:

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

The default supply chains use knative to deploy your applications. In this event the only location information you must send is the path to the API documentation. The controller can figure out the base URL for you.

Another option is you can hardcode the URL using the baseURL property.  The controller uses a combination of this baseURL and your path to retrieve the YAML.

Example workload that exposes a knative service:

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: petclinic-knative
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
          path: "/v3/api-docs"
        system: pet-clinics  
        owner: team-petclinic
        description: "A set of API endpoints to manage the resources within the petclinic app."

```

Example of a workload with a hardcoded URL to the API documentation

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

After the supply chain runs it creates an `APIDescriptor` custom resource. This resource is what Tanzu Application Platform uses to auto register your API. See [APIDescriptor explained](#api-descriptor)

## <a id='without-supply-chain'></a>Without the OOTB Supply Chains
 If you are not using supply chains, or are creating custom supply chains you can still use API Auto Registration. You must directly create an APIDescriptor custom resource.  See the examples later for further details.

## <a id='api-descriptor'></a>APIDescriptor explained

For API Auto Registration to take place a custom resource of type `APIDescriptor` must be created. If you use the OOTB supply chains and have set the required text boxes on your workload one is automatically be created for you, otherwise you must make one yourself.
Following are the details of this custom resource.

### <a id='absolute-url'></a>With an absolute URL

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

### <a id='with-ref'></a>With a ref

You can also use an object reference instead of hard coding the URL. See the following example for more details.

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

### <a id='troubleshooting'></a>Troubleshooting

Here are some handy commands for debugging or troubleshooting the APIDescriptor CR.

1. Find the status of the APIDescriptor CR.
    ```console
    kubectl get apidescriptor <api-apidescriptor-name> -o jsonpath='{.status.conditions}'
    ```
2. Read logs from the `api-auto-registration` controller.
    ```console
    kubectl -n api-auo-registration logs deployment.apps/api-auto-registration-controller
    ```
3. Patch a APIDescriptor that is stuck in Deleting mode.
   This might happen if the controller package is uninstalled before you clean up the APIDescriptor resources. 
   You can reinstall the package and delete all the APIDescriptor resources first, or run the following command for each stuck APIDescriptor resource.
    ```console
    kubectl patch apidescriptor <api-apidescriptor-name> -p '{"metadata":{"finalizers":null}}' --type=merge
    ```
   >**Note:** If you manually remove the finalizers from the APIDescriptor resources, you might have stale API entities within Tanzu Application Platform GUI that you must manually deregister.

## <a id='cors'></a>Setting up CORS for OpenAPI specs

The agent, usually a browser, uses the [CORS](https://fetch.spec.whatwg.org/#http-cors-protocol) protocol to verify whether the current origin uses an API. 
To use the Try it out feature for OpenAPI specifications from the API Docs plug-in<, you must configure CORS to allow successful requests. 
Your API must be configured to allow CORS Requests from Tanzu Application Platform GUI. How you accomplish this varies based on the programming language and framework you are using. 
If you are using Spring you can get more information [here](https://spring.io/blog/2015/06/08/cors-support-in-spring-framework).

At a high level, the Tanzu Application Platform GUI domain must be accepted as valid cross-origin by your API. 
Verify the following:

- **Origins allowed** (header: `Access-Control-Allow-Origin`): a list of comma-separated values. This list must include your Tanzu Application Platform GUI host.
- **Methods allowed** (header: `Access-Control-Allow-Method`): must allow the method used by your API. Also confirm that your API supports preflight requests (a valid response to the OPTIONS HTTP method).
- **Headers allowed** (header: `Access-Control-Allow-Headers`): if the API requires any header, you must include it in the API configuration or your authorization server.
