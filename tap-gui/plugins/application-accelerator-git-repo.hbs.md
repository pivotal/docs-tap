# Application Accelerator Git Repository Creation in Tanzu Application Platform GUI

This topic describes how to enable and use Git repository creation in the Application Accelerator
plug-in.

## <a id="overview"></a> Overview

The Application Accelerator plug-in uses Backstage git providers integration and the authentication
mechanism to retrieve an access token and interact with the provider API to create git repositories.

## <a id="supported-providers"></a> Supported Providers

In TAP version 1.3 the supported git providers are Github, Gitlab and BitBucket

## <a id="configuration"></a> Configuration

There are two ways to enable git repository creation:

- Add an [auth](https://backstage.io/docs/auth/) property from a git provider with its respective
  integration
- Add an [integration](https://backstage.io/docs/integrations/) from a git provider with a PAT

### With auth configuration

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

3. Go to Tanzu Application Platform GUI, access the Accelerators section, and then select an
   accelerator.
   You should see in the accelerator form a second step called `Git repository`

4. Fill the accelerator options and click **Next**.

5. In the next step select the **create git repo?** checkbox, it should display the owner, repository
   name, and branch fields. Fill these inputs.

   ![Git Repo Creation fields](images/git-repo-fields.png)

6. After filling the repository name a modal should pop up requesting the GitHub credentials, log in,
   and then click **Next**.

   ![OAuth modal](images/application-accelerator-git-repo-oauth-modal.png)

7. Click **GENERATE ACCELERATOR**.

8. At the end of the execution it should display a link with the repository location.

   ![Task Output](images/application-accelerator-task-output.png)

### With PAT

1. Create a PAT with the `repo` scope. For instructions, see the
   [GitHub documentation](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

2. Add a GitHub integration in your configuration. For example:

   ```yaml
   integrations:
     github:
       - host: github.com
         token: YOUR-GITHUB-PAT
   ```

   For more information about GitHub integration, see the
   [Backstage documentation](https://backstage.io/docs/integrations/github/locations).

3. After these config values has been added, go to TAP GUI, access the accelerators sections, choose
   an accelerator, you should see in the accelerator form a second step called `Git repository`

4. Fill in the accelerator options and then click **Next**.

5. Select the **create git repo?** checkbox.

6. Fill in the **owner**, **repository name**, and **branch** text boxes.

   ![Git Repo Creation fields](images/git-repo-fields.png)

7. Click **GENERATE ACCELERATOR**. After generation, a link to the repository location appears.

   ![Task Output](images/application-accelerator-task-output.png)

### Caveats

In the case that the `app-config.yaml` has an `auth` config and a `token`, the log-in modal appears
and it takes priority over the PAT.
