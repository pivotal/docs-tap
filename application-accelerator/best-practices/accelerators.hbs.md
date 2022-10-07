# Accelerators - Best Practices and Useful Hints

## <a id="accelerator-benefits"></a> Benefits of using an accelerator

There are several reasons when it makes sense to spend time on developing Accelerators:

- If you find that the same application architecture setup for new applications is copied over and over again.
- If you want to enforce standardization of technology stacks and application setups throughout your organization.
- If you want to share best practices around application architecture, application, and test setup.

## <a id="design-considerations"></a> Design considerations

Choose for each Accelerator one base technology stack (combined with related tooling) and one target deployment architecture. For example, if you have both Spring Boot and C# .NET Core applications in your target environment, create one for Spring Boot and one for C# .NET Core and do not try to mix them, as it makes both the directory structure and acceleratory.yaml unreadable.

Think about the scope of your Accelerator. The scope needs to be aligned with the different types of deployments you have: back end API, front end UI, business service, and so on.

Choose OpenRewrite-based transformation over ReplaceText-based transformation when possible. OpenRewrite-based transformations understand semantics of files they work on (e.g. Maven pom.xml or Java source file etc) and they can provide more accurate and robust modifications. As a last resort, ReplaceText supports a regex mode which, when used with capturing groups in the replacement string, allows most modifications.

## <a id="housekeeping"></a> Housekeeping rules

VMware has found that the following rules keeps our set of Accelerators clear and findable for our end users.

- VMware recommends accelerators to have an intuitive name and short description that reflects its purpose. Do not include the word ‘accelerator’ in the name.
- VMware recommends Accelerators to have an appropriate and intuitive icon.
- VMware recommends Accelerators to have tags that reflect language, framework,and type of service. For example database, messaging, and so on. This helps in searching for an accelerator by tags. For tag names use lowercase letters. Tag values needs to consist of [a-z0-9+#] separated by [-] and at most 63 characters
- VMware recommends that accelerators expose options to allow configuring an accelerator for different use cases instead of creating multiple, yet very similar accelerators.
- VMware recommends options to be be straight forward, each having a description that states the role it plays in the accelerator. Options having the default value when appropriate.
- VMware recommends options to be designed in a way that they do not become too long making it difficult to navigate. Make options conditional on others where appropriate.
- Free text options which have certain limitations on their values must ensure that these limitations are met through providing a regular expression based validation. This ensures early feedback on an invalid user input.
- Generated application skeletons must have a detailed README that describes the function and structure of a generated application. It also must provide detailed information about how developers can build and deploy a generated application of the accelerator and how to use it.

## <a id="tests"></a> Tests

### Application Skeleton

Having an Accelerator that generates an Application Skeleton without having a good test suite for the different layers or slices of the Application is promoting bad behavior: one might have code running in production without testing.

It is a good habit to have tests for the Application Skeleton:

- An overall application [`smoke`](https://en.wikipedia.org/wiki/Smoke_testing_(software)) test that bootstraps the application and see if it comes online
- A test per layer: For example presentation layer, business layer or data layer. These tests can be unit-tests leveraging stubbing or mocking frameworks.
- An integration test per layer, especially the presentation layer or data layer. For example, one might provide an integration test with some database interaction using [`testcontainers`](https://www.testcontainers.org/).