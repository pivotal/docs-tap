# Application Accelerator Git Repository Creation in Tanzu Application Platform GUI

This topic describes how to enable and use Git repository creation in the Application Accelerator
plug-in.

## <a id="overview"></a> Overview

The Application Accelerator plug-in uses Backstage git providers integration and the authentication
mechanism to retrieve an access token and interact with the provider API to create git repositories.

## <a id="supported-providers"></a> Supported Providers

In TAP version 1.3 the supported git providers are Github and Gitlab

## <a id="configuration"></a> Configuration

Up next, an example configuration using GitHub will be explained:

1. Create an OAuth App in GitHub based on the configuration described in this
   [Backstage documentation](https://backstage.io/docs/auth/github/provider).
   For more information about creating an OAuth app, see the
   [GitHub documentation](https://docs.github.com/en/developers/apps/building-oauth-apps/creating-an-oauth-app).

   these values appear in your `app-config.yaml` or `app-config.local.yaml` for local development.
   For example:

   ```yaml
   auth:
     environment: development
     providers:
       github:
         development:
           clientId: GITHUB-CLIENT-ID
           clientSecret: GITHUB-CLIENT-SECRET
   ```

2. Add a GitHub integration in your configuration. For example:

   ```yaml
   integrations:
     github:
       - host: github.com
   ```

   For more information, see the
   [Backstage documentation](https://backstage.io/docs/integrations/github/locations).

## <a id="creating-project"></a> Creating a Project

1. Go to Tanzu Application Platform GUI, access the Accelerators section, and then select an
   accelerator.
   You should see in the accelerator form a second step called `Git repository`


2. Fill the accelerator options and click **Next**.

3. In the next step select the **create git repo?** checkbox, it should display the owner, repository
   name, and branch fields. Fill these inputs.

   ![Git Repo Creation fields](images/git-repo-fields.png)

4. After filling the repository name a modal should pop up requesting the GitHub credentials, log in,
   and then click **Next**.

   ![OAuth modal](images/application-accelerator-git-repo-oauth-modal.png)

   ![Github login](images/github-login.png)

5. Click **GENERATE ACCELERATOR**.

6. At the end of the execution it should display a link with the repository location.

   ![Task Output](images/application-accelerator-task-output.png)
