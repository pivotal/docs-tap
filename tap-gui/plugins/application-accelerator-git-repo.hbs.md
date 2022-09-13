# Application Accelerator Git Repository Creation in Tanzu Application Platform GUI

This topic describes how to enable and use Git repository creation in the application accelerator plugin.

## <a id="overview"></a> Overview

The application accelerator plugin uses backstage git providers integration and the authentication mechanism
to retrieve an access token and interact with the provider API to create git repositories.

## <a id="configuration"></a> Configuration

There are two ways to enable the git repository creation:
- add an [auth](https://backstage.io/docs/auth/) property from a git provider with its respective integration
- add an [integration](https://backstage.io/docs/integrations/) from a git provider with a PAT

Up next, the document will give an example using Github

## Github example

### With auth configuration

1. Create an [OAuth App](https://docs.github.com/en/developers/apps/building-oauth-apps/creating-an-oauth-app)
 in github based on the configuration described [here](https://backstage.io/docs/auth/github/provider), these
 values should be in your `app-config.yaml` or `app-config.local.yaml` for local development, I.E.
```yaml
auth:
  environment: development
  providers:
    github:
      development:
        clientId: <GITHUB_CLIENT_ID>
        clientSecret: <GITHUB_CLIENT_SECRET>
```
2. Add a github [integration](https://backstage.io/docs/integrations/github/locations) in you configuration, I.E.
```yaml
integrations:
  github:
    - host: github.com
```
3. Once these config values has been added, go to TAP GUI, access the accelerators sections,
choose an accelerator, you should see in the accelerator form a second step called `Git repository`
4. Fill the accelerator options and click `next`
5. In the next step click on the `create git repo?` checkbox, it should display the owner, repository name and branch fields.
fill these inputs.

![Git Repo Creation fields](images/git-repo-fields.png)

6. After filling the repository name a modal should pop up requesting the github credentials, login and then click in `next`.

![OAuth modal](images/application-accelerator-git-repo-oauth-modal.png)

7. Click `GENERATE ACCELERATOR`
8. At the end of the execution it should display a link with the repository location.

![Task Output](images/application-accelerator-task-output.png)

### With PAT

1. Create a [PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
    with the `repo` scope
2. Add a github [integration](https://backstage.io/docs/integrations/github/locations) in you configuration, I.E.
```yaml
integrations:
  github:
    - host: github.com
      token: <GITHUB_PAT>
```
3. Once these config values has been added, go to TAP GUI, access the accelerators sections,
choose an accelerator, you should see in the accelerator form a second step called `Git repository`
4. Fill the accelerator options and click `next`
5. In the next step click on the `create git repo?` checkbox, it should display the owner, repository name and branch fields.
fill these inputs.

![Git Repo Creation fields](images/git-repo-fields.png)

6. Click `GENERATE ACCELERATOR`
7. At the end of the execution it should display a link with the repository location.

![Task Output](images/application-accelerator-task-output.png)


### Caveats
In the case that the `app-config.yaml` has an `auth` config and a `token`, the login
modal will pop up and it will take priority over the PAT
