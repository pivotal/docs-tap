# API Docs plugin in Tanzu Application Platform GUI

## <a id="overview"></a> Overview

(Overview section - in the context of Software catalog; API that it might consume or expose)

## <a id='entry-point'></a>Entry points to API Docs plugin

The API Docs plugin is part of Tanzu Application Platform GUI. 

The first entry point to the API Docs plugin, click **APIs** in the left-hand navigation bar of Tanzu Application Platform GUI. This opens the **API catalog page**.

![Screenshot of API catalog page](./images/aa1_firstpage.png)

On that page, you can view APIs already registered with the system. Developers can add new API entries and link them to Components and Systems in the Software Catalog by registering them as new entities of the Software Catalog.

The second entry point to the API Docs plugin is though Components and Systems of the Software Catalog, listed on the Home page of Tanzu Application Platform GUI. If there is an API entity associated with the selected Component or System, the **VIEW API** icon shall be active

![Screenshot of Component page](./images/aa1_firstpage.png)

Every API entry provides a title and short description, including reference to the team that owns the definition of that API and the Software Catalog objects that are connected to it.

![Screenshot of API page - Overview](./images/aa1_firstpage.png)

By choosing the **Definition** tab on the top of the API page, you can see the definition of that API in human-readable and machine-readable format.

![Screenshot of API page - Definition](./images/aa1_firstpage.png)

API Docs plugin supports the following API formats
* OpenAPI 2 & 3
* AsyncAPI
* GraphQL
* Plain (to support any other format)

## <a id='create-project'></a>Creating a new API entry

To create a new API entry, you must follow the same steps as if you were registering any other Software Catalog entity.

1. Navigate to the home page of Tanzu Application Platform GUI by clicking on the **Home** icon, located on the left-side navigation bar. Click **REGISTER ENTITY**.

    ![REGISTER button on the right side of the header](images/getting-started-tap-gui-5.png)

2. **Register an existing component** prompts you to type a repository URL. Paste the link to the `catalog-info.yaml` file of your choice that contains the defintion of your API entity.
`DEMO LINK TO BE ADDED`.

1. Click **ANALYZE**, review the catalog entities to be added and click **IMPORT**.

    ![Review the entities to be added to the catalog](images/getting-started-tap-gui-7.png)

3. Navigate to the API page by clicking the **APIs** button on the left-hand side navigation panel. The catalog changes and entries are visible for further inspection.

---



**GUID-tap-gui-about.html**

**about.md**

* **Tanzu Application Platform GUI plugins:**
  These plugins expose capabilities regarding specific Tanzu Application Platform tools.
  Initially the included plugins are:
  * Runtime Resources Visibility
  * Application Live View
  * Application Accelerator
  * API Docs


# Tanzu Application Platform GUI plugins

## <a id="overview"></a> Overview

The Tanzu Application Platform GUI has many pre-integrated plugins.
You do not need to configure the plugins. To use the plugin,
you must install the Tanzu Application Platform component.

Tanzu Application Platform includes the following GUI plugins:

- [Runtime Resources Visibility](runtime-resource-visibility.md)
- [Application Live View](app-live-view.md)
- [Application Accelerator](application-accelerator.md)
- [API Docs](LINK-TO-FILE.md)

---

**Getting started documentation**

## <a id="dev-first-app"></a>Section X: Add your API entry to the Tanzu Application Platform GUI Software Catalog

In this section, you are going to:

  - Learn about API entities of the Software Catalog
  - Add a demo API entity to Tanzu Application Platform GUI Software Catalog
  - Update your demo API entry

### <a id="about-app-accs"></a>About API entities

The list of API entities is visible on the left-hand side navigation panel of Tanzu Application Platform GUI and on the overview page of specific components on the Home page. APIs are a definition of the interface between components. Their definition is provided in machine-readable ("raw")  and human-readable formats. For more details, see [API plugin documentation](#TO-BE-ADDED).


### <a id="deploy-your-app"></a>Add a demo API entity to Tanzu Application Platform GUI Software Catalog

To add a demo API entity, you must follow the same steps as if you were registering any other Software Catalog entity.

1. Navigate to the home page of Tanzu Application Platform GUI and click **Home**, located on the left-side navigation bar.
   Click **REGISTER ENTITY**.

    ![REGISTER button on the right side of the header](images/getting-started-tap-gui-5.png)

2. **Register an existing component** prompts you to type a repository URL.
Type the link to the `catalog-info.yaml` file of your choice or use demo link here:
`DEMO LINK TO BE ADDED`.

1. Click **ANALYZE**.

    ![Select URL](images/getting-started-tap-gui-6.png)

2. Review the catalog entities to be added and click **IMPORT**.

    ![Review the entities to be added to the catalog](images/getting-started-tap-gui-7.png)

3. Navigate to the API page by clicking the **APIs** button on the left-hand side navigation panel. The catalog changes and entries are visible for further inspection.

### <a id="deploy-your-app"></a>Update your demo API entry

To update your demo API entity, you can select it from the list of available APIs in your Software Catalog and press the Edit icon 

    ![Highlighted Edit icon](images/getting-started-tap-gui-7.png)

That would open the source `catalog-info.yaml` file that you can edit. After your edits have been made, Tanzu Application Platform GUI shall re-render the API entry with the next refresh cycle

---

 
---

**Installing the Tanzu Application Platform Package and Profiles**

- no changes