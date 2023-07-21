# Deploy an application with Application Single Sign-On

This topic tells you how to deploy a minimal Kubernetes application that is protected
by Application Single Sign-On (commonly called AppSSO) by using the credentials
that [tanzu services class-claims](claim-credentials.hbs.md) creates.

![Diagram of AppSSO's components and how they interact with End-Users and Client applications](../../images/app-sso/appsso-concepts.png)

[//]: # (^ diagram is produced from https://miro.com/app/board/uXjVMUY5O0I=/)

For more information about how a Client application uses an AuthServer to
authenticate an end user, see the [Overview of AppSSO](./appsso-overview.md).

## Prerequisites

- You must complete the steps described in [Get started with Application Single Sign-On](./appsso-overview.hbs.md).
If not, see [claim credentials](claim-credentials.hbs.md).

## Deploy a minimal application

You are going to deploy a minimal Spring Boot application. When you run 

```bash
tanzu accelerator list
```

You should be able to see one named `appsso-starter-java`. This is the accelerator we want to use. 

Create a project using the following command:

```bash
tanzu accelerator generate appsso-starter-java --server-url <YOUR TAP SERVER URI> --options '{"appssoOfferingName": "my-login"}'
```

This will give you a zip file, that you can unzip with

```bash
unzip appsso-starter-java.zip
```

Take a look at `config/workload.yaml`. 

We need to make 2 changes here:

1. The reference to the `serviceClaims` should be to the `ServiceClaim` we generated in the previous step. For this,
replace `appsso-starter-java` within the `serviceClaims` section (2 times) with `my-workload`.
1. You will see that there is a reference to a remote version of your repository.
You can push this repo to your preferred git repository and refer to it here. Once that is done, apply the workload via

The following piece is the one responsible for claiming the ServiceClaim from your app: 

```yaml
---
spec:
  serviceClaims:
    - name: <Your service claim>
      ref:
        apiVersion: services.apps.tanzu.vmware.com/v1alpha1
        kind: ClassClaim
        name: <Your service claim>
```

  ```bash
  kubectl apply -f config/workload.yaml
  ```

This will deploy your workload for you. Thanks to the ServiceClaim, your application will automatically connect to the
`AppSSO AuthServer`.

That's it! You can check the Workload section of the TAP Portal to find the URL for your workload at https://tap-gui.<your tap cluster domain>.
