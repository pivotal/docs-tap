# Tanzu Application Platform GUI

- Git repository for the Tanzu Application Platform GUI's software catalogs, along with a token allowing read access.
  Supported Git infrastructure includes:
    - GitHub
    - GitLab
    - Azure DevOps
- Tanzu Application Platform GUI Blank Catalog from the Tanzu Application section of Tanzu Network
  - To install, navigate to [Tanzu Network](https://network.tanzu.vmware.com/products/tanzu-application-platform/). Under the list of available files to download, there is a folder titled `tap-gui-catalogs-latest`. Inside that folder is a compressed archive titled `Tanzu Application Platform GUI Blank Catalog`. You must extract that catalog to the preceding Git repository of choice. This serves as the configuration location for your Organization's Catalog inside Tanzu Application Platform GUI.
- The Tanzu Application Platform GUI catalog allows for two approaches towards storing catalog information:
    - The default option uses an in-memory database and is suitable for test and development scenarios.
          This reads the catalog data from Git URLs that you specify in the `tap-values.yml` file.
          This data is temporary, and any operations that cause the `server` pod in the `tap-gui` namespace to be re-created
          also cause this data to be rebuilt from the Git location.
          This can cause issues when you manually register entities through the UI because
          they only exist in the database and are lost when that in-memory database gets rebuilt.
    - For production use-cases, use a PostgreSQL database that exists outside the
          Tanzu Application Platform packaging.
          The PostgreSQL database stores all the catalog data persistently both from the Git locations
          and the UI manual entity registrations. For more information, see
          [Configuring the Tanzu Application Platform GUI database](tap-gui/database.md)
