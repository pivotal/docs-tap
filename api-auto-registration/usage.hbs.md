# API Auto Registration Usage

On a high level, API Auto Registration requires users to perform two steps: 1. generate API spec 2. create APIDescriptor CR.
You may additionally need to setup different install values for api-auto-registration package or CORS for OpenAPI spec.

How to generate OpenAPI Spec
   - [by skaffolding a new project using App Accelerator Template](#using-app-accelerator-template)
   - [in an existing Spring Boot project using springdoc](https://springdoc.org/#getting-started)

How to create APIDescriptor CR
   - [using Out Of The Box Supply Chains](#using-ootb-supply-chain)
   - [using Custom Supply Chains](#using-custom-supply-chain)
   - [using other GitOps processes or Manually](#using-gitops-manually)

How to configure
   - [different cluster name, TAP GUI url or CA Cert values for api-auto-registration](#update-values)
   - [CORS for OpenAPI Spec](#cors)

## <a id='using-app-accelerator-template'></a>Using App Accelerator Template

If you are creating a new application exposing an API, you may use the ["java-rest-service"](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/java-rest-service)
App Accelerator template to get an out-of-the-box app that comes with already written workload.yaml along with a basic REST API.
From your TAP GUI's Accelerators tab, you can search for the accelerator and scaffold it according to your needs.

## <a id='using-ootb-supply-chain'></a>Using Out Of The Box (OOTB) Supply Chains

All the Out-Of-The-Box (OOTB) supply chains have been modified so that they can utilize API Auto Registration. If you want your Workload to be auto registered, you need to make a couple of modifications to your workload yaml as described below

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

Another option is you can hardcode the url using the baseURL property.  The controller will use a combination of this baseURL and your path to retrieve the yaml

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

Example of a workload with a hardcoded url to the api documentation

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

Once the supply chain runs it will create an `APIDescriptor` custom resource. This resource is what TAP uses to auto register your API. See below
for more details.

## <a id='using-custom-supply-chain'></a>Using Custom Supply Chains
If you are creating custom supply chains, you can still utilize API Auto Registration. To write your own Supply Chain pipeline, 
you can use `ClusterConfigTemplate` by the name of `config-template` in your pipeline. To write your own custom task, 
you can check how the template is written to read params, interpret baseURL from Knative Services and construct APIDescriptor CRs.

In the Delivery pipeline, you will need to directly create an APIDescriptor custom resource. You may need to grant some permissions to create the CR from the Delivery pipeline. 
For more info on APIDescriptors, check out the [Key Concepts section](key-concepts.md)

## <a id='using-gitops-manually'></a>Using other GitOps processes or Manually
Using your GitOps process (or manually), you will need to stamp out an APIDescriptor CR and apply it in the desired cluster. 
The APIDescriptor will need all the required fields to successfully reconcile.

For more info on APIDescriptors, check out the [Key Concepts section](key-concepts.md)

## <a id='update-values'></a>Update install values for api-auto-registration package
1. Create `api-auto-registration-values.yaml`

    If you'd like to overwrite the default values, create or update your `api-auto-registration-values.yaml` file that has the following fields:

    ```yaml
    tap_gui_url: https://tap-gui.view-cluster.com
    cluster_name: staging-us-east
    ca_cert_data:  |
        -----BEGIN CERTIFICATE-----
        MIICpTCCAYUCBgkqhkiG9w0BBQ0wMzAbBgkqhkiG9w0BBQwwDgQIYg9x6gkCAggA
        ...
        9TlA7A4FFpQqbhAuAVH6KQ8WMZIrVxJSQ03c9lKVkI62wQ==
        -----END CERTIFICATE-----
    ```

2. Update the package using the Tanzu CLI

    ```console
    tanzu package installed update api-auto-registration 
    --package-name apis.apps.tanzu.vmware.com
    --namespace tap-install
    --version $VERSION
    --values-file api-auto-registration-values.yaml

## <a id='cors'></a>Setting up CORS for OpenAPI Specs

The [CORS](https://fetch.spec.whatwg.org/#http-cors-protocol) protocol is used by the agent (usually a browser) to verify whether an API is used by the current origin. 
If you want to use the "Try it out" feature for OpenAPI specs from the API Docs plugin, you will need to setup CORS to allow successful requests. 
Your API must be configured to allow CORS Requests from TAP GUI. How you accomplish this varies based on the programming language and framework you are using. 
If you are using Spring you can get more information [here](https://spring.io/blog/2015/06/08/cors-support-in-spring-framework). If you are using something else please refer to it's documentation.

At a high level, the TAP GUI domain must be accepted as valid cross-origin by your API. Verify the following:

- **Origins allowed** (header: `Access-Control-Allow-Origin`): a list of comma-separated values. This list must include your TAP GUI host.
- **Methods allowed** (header: `Access-Control-Allow-Method`): must allow the method used by your API. Also confirm that your API supports preflight requests (a valid response to the OPTIONS HTTP method).
- **Headers allowed** (header: `Access-Control-Allow-Headers`): if the API requires any header, you must include it in the API configuration or your authorization server.
