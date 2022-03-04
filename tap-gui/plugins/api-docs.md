# API documentation plug-in in Tanzu Application Platform GUI

This section provides a general overview of the API documentation plug-in of the Tanzu Application Platform GUI. For additional information, please refer to the [Getting started with API documentation plug-in](api-docs-getting-started.md).

## <a id="overview"></a> Overview

The API documentation plug-in provides a standalone list of APIs that can be connected to Components and Systems of Tanzu Application Platform GUI's Software Catalog. Each API entity can reflect the Components that provide that API, as well as the list of Components that are consumers of that API. Also, an API entity can be associated to Systems and show up on the System's diagram. To show such dependency, `spec.providesApis:` and `spec.consumesApis:` sections of the Component definition files should reference the name of the API entity.

Here's a sample of how `providesApis` and `consumesApis` can be added to an existing Component's catalog definition, linking them together.
```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: example-component
  description: Example Component
spec:
  type: service
  lifecycle: experimental
  owner: team-a
  system: example-system
  providesApis: # list of APIs provided by the Component
    - example-api-1
  consumesApis: # list of APIs consumed by the Component
    - example-api-2
```

For more information on the structure of the definition file for an API entity, please refer to [Backstage Kind: API](https://backstage.io/docs/features/software-catalog/descriptor-format#kind-api). For more information on the API documentation plug-in, please refer to [Backstage API documentation](https://github.com/backstage/backstage/blob/master/plugins/api-docs/README.md).

## <a id='utilizing'></a>Utilizing the API documentation plug-in

The API documentation plug-in is part of Tanzu Application Platform GUI.

The first way to use the API documentation plug-in is API-first. Click **APIs** in the left-hand navigation sidebar of Tanzu Application Platform GUI. This opens the **API catalog page**.

![Screenshot of API catalog page](./tap-gui/images/../../../images/api-plugin-1.png)

On that page, you can view all the APIs already registered in the catalog regardless if they are associated with Components or Systems.

The second way to utilize the API documentation plug-in is through Components and Systems of the Software Catalog, listed on the Home page of Tanzu Application Platform GUI. If there is an API entity associated with the selected Component or System, the **VIEW API** icon shall be active.

![Screenshot of Component page](./tap-gui/images/../../../images/api-plugin-2.png)

The **VIEW API** tab demonstrates which APIs are being consumed by a Component and which APIs are being provided by the Component.

![Screenshot of VIEW API page](./tap-gui/images/../../../images/api-plugin-3.png)

Clicking on the API itself takes you to the Catalog entry for the API (denoted by the Kind type listed in the upper-left corner). Every API entity has a title and short description, including reference to the team that owns the definition of that API and the Software Catalog objects that are connected to it.

![Screenshot of API page - Overview](./tap-gui/images/../../../images/api-plugin-4.png)

By choosing the **Definition** tab on the top of the API page, you can see the definition of that API in human-readable and machine-readable format.

![Screenshot of API page - Definition](./tap-gui/images/../../../images/api-plugin-5.png)

The API documentation plug-in supports the following API formats
* OpenAPI 2 & 3
* AsyncAPI
* GraphQL
* Plain (to support any other format)

## <a id='create-project'></a>Creating a new API entry

To create a new API entity, you must follow the same steps as if you were registering any other Software Catalog entity.

1. Navigate to the home page of Tanzu Application Platform GUI by clicking on the **Home** icon, located on the left-side navigation bar. Click **REGISTER ENTITY**.

    ![REGISTER button on the right side of the header](../images/../../images/getting-started-tap-gui-5.png)

2. **Register an existing component** prompts you to type a repository URL. Paste the link to the `catalog-info.yaml` file of your choice that contains the defintion of your API entity. For example, you can copy the text below and save it as `catalog-info.yaml` on a Git repository of your choice.

    ```
    apiVersion: backstage.io/v1alpha1
    kind: API
    metadata:
      name: demo-api
      description: The demo API for Tanzu Application Platform GUI
      links:
        - url: https://api.agify.io
          title: API Definition
          icon: docs
    spec:
      type: openapi
      lifecycle: experimental
      owner: demo-team
      system: demo-app # Or specify system name of your choice
      definition: |
        openapi: 3.0.1
        info:
          title: defaultTitle
          description: defaultDescription
          version: '0.1'
        servers:
          - url: https://api.agify.io
        paths:
          /:
            get:
              description: Auto generated using Swagger Inspector
              parameters:
                - name: name
                  in: query
                  schema:
                    type: string
                  example: type_any_name
              responses:
                '200':
                  description: Auto generated using Swagger Inspector
                  content:
                    application/json; charset=utf-8:
                      schema:
                        type: string
                      examples: {}        
    ```

3. Click **ANALYZE**, review the catalog entities to be added and click **IMPORT**.

    ![Review the entities to be added to the catalog](./tap-gui/images/../../../images/api-plugin-6.png)

4. Navigate to the API page by clicking **APIs** on the left-hand side navigation panel. The catalog changes and entries are visible for further inspection.
