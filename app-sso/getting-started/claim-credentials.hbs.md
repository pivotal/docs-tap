# Claim Credentials

Now that you have an `AppSSO` service offering, the next step is to create a `ClassClaim`.

This creates consumable credentials for your workload, and will allow your workload to connect to the Login service
offering using those credentials.

![Diagram of the Connection between your Workload, the ClassClaim, and AppSSO.](../../images/app-sso/appsso-flow.png)

Choose your Login offering out of the options available at 

```bash
tanzu services classes list
```

If there aren't any available, [you can set one up.](./provision-auth-server.hbs.md)

```bash
tanzu services class-claims create my-workload \
  --class my-login \
  --parameter workloadRef.name=appsso-starter-java \
  --parameter redirectPaths='["/login/oauth2/code/appsso-starter-java"]'
```

>**Note:** The redirect path you need to provide is referring to the login redirect within your application. In our case,
we will be deploying a minimal Spring application, so we will use the Spring Security path.

Check the status of your ClassClaim with

```bash
tanzu services class-claims list
```
