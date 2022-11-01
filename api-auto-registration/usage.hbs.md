# Use API Auto Registration

This topic describes how to use API Auto Registration.

>**Note:** The run profile requires you to [update the install values](#update-values) before proceeding with the next steps.
> For iterate and full profiles, the default values work but you might prefer to update them anyway.
> For more information about profiles, see [About Tanzu Application Platform profiles](../about-package-profiles.md#profiles-and-packages).

API Auto Registration requires that the following is present:

1. A location exposing a dynamic or static API specification.

2. An APIDescriptor CR with that location created in the cluster.
You might additionally need to set up different install values for api-auto-registration package or CORS for OpenAPI specifications.

How to configure:

   - [different cluster name, Tanzu Application Platform GUI url or CA Cert values for api-auto-registration](#update-values)

   - [CORS for viewing OpenAPI Spec in TAP GUI](#cors)

How to generate OpenAPI Spec:

   - [by skaffolding a new project using App Accelerator Template](#using-app-accelerator-template)

   - [in an existing Spring Boot project using springdoc](https://springdoc.org/#getting-started)

How to create APIDescriptor CR:

   - [using Out Of The Box Supply Chains](#using-ootb-supply-chain)

   - [using Custom Supply Chains](#using-custom-supply-chain)

   - [using other GitOps processes or Manually](#using-gitops-manually)

## <a id='update-values'></a>Update install values for api-auto-registration package

1. Create `api-auto-registration-values.yaml`:

   If you would like to overwrite the default values, create, or update your `api-auto-registration-values.yaml` file that has the following text boxes:

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

2. Update the package using the Tanzu CLI:

    ```console
    tanzu package installed update api-auto-registration
    --package-name apis.apps.tanzu.vmware.com
    --namespace tap-install
    --version $VERSION
    --values-file api-auto-registration-values.yaml
    ```

## <a id='using-app-accelerator-template'></a>Using App Accelerator Template

If you are creating a new application exposing an API, you might use the ["java-rest-service"](https://github.com/vmware-tanzu/application-accelerator-samples/tree/main/java-rest-service)
App Accelerator template to get an pre-built app that includes an already written workload.yaml with a basic REST API.
From your Tanzu Application Platform GUIs Accelerators tab, you can search for the accelerator and scaffold it according to your needs.

## <a id='using-ootb-supply-chain'></a>Using Out Of The Box (OOTB) Supply Chains

All the Out-Of-The-Box (OOTB) supply chains are modified so that they can use API Auto Registration. If you want your Workload to be auto registered, you must make a couple of modifications to your workload YAML as described in later steps.

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

## <a id='using-custom-supply-chain'></a>Using Custom Supply Chains

If you are creating custom supply chains, you can still use API Auto Registration. To write your own Supply Chain pipeline,
you can use `ClusterConfigTemplate` by the name of `config-template` in your pipeline. To write your own custom task,
you can verify how the template is written to read parameters, interpret baseURL from Knative Services and construct APIDescriptor CRs.

In the Delivery pipeline, you must directly create an APIDescriptor custom resource. You must grant some permissions to create the CR from the Delivery pipeline.
For more information on APIDescriptors, see [Key Concepts](key-concepts.md).

## <a id='using-gitops-manually'></a>Using other GitOps processes or Manually

Using your GitOps process (or manually), you must stamp out an APIDescriptor CR and apply it in the cluster you choose.
The APIDescriptor needs all the required text boxes to reconcile.

For more information on APIDescriptors, see [Key Concepts](key-concepts.md).

## <a id='cors'></a>Setting up CORS for OpenAPI specifications

The agent, usually a browser, uses the [CORS](https://fetch.spec.whatwg.org/#http-cors-protocol) protocol to verify whether the current origin uses an API.
To use the Try it out feature for OpenAPI specifications from the API Documentation plug-in, you must configure CORS to allow successful requests.
Your API must be configured to allow CORS Requests from Tanzu Application Platform GUI. How you accomplish this varies based on the programming language and framework you are using.
If you are using Spring you can get more information [here](https://spring.io/blog/2015/06/08/cors-support-in-spring-framework).

At a high level, the Tanzu Application Platform GUI domain must be accepted as valid cross-origin by your API.
Verify the following:

- **Origins allowed** (header: `Access-Control-Allow-Origin`): a list of comma-separated values. This list must include your Tanzu Application Platform GUI host.
- **Methods allowed** (header: `Access-Control-Allow-Method`): must allow the method used by your API. Also confirm that your API supports preflight requests (a valid response to the OPTIONS HTTP method).
- **Headers allowed** (header: `Access-Control-Allow-Headers`): if the API requires any header, you must include it in the API configuration or your authorization server.
