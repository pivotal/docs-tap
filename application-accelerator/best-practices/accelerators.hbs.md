# Accelerators - Best Practices and Useful Hints

## <a id="accelerator-benefits"></a> Benefits of using an accelerator
There are several reasons when it makes sense to spend time on developing Accelerators:
* If you find that the same application architecture setup for new applications is copied over and over again.
* If you would like to enforce standardization of technology stacks and application setups throughout your organization.
* If you would like to share best practices around application architecture, application and test setup.

## <a id="design-considerations"></a> Design considerations
Choose per Accelerator one base technology stack (combined with related tooling) and one target deployment architecture. For example, if you have both Spring Boot and C# .NET Core applications in your target environment, create one for Spring Boot and one for C# .NET Core and do not try to mix them, as it will make both the directory structure and acceleratory.yaml unreadable.

Think about the scope of your Accelerator. The scope should be aligned with the different types of deployments you have: backend API, frontend UI, business service, etc.

Choose OpenRewrite-based transformation over ReplaceText-based transformation when possible. OpenRewrite-based transformations understand semantics of files they work on (e.g. Maven pom.xml or Java source file etc) and they are able to provide more accurate and robust modifications. As a last resort, ReplaceText supports a regex mode which, when used with capturing groups in the replacement string, allows just about any modification.

## <a id="housekeeping"></a> Housekeeping rules
We have found that the following simple rules keeps our set of Accelerators clear and findable for our end users.
* Accelerators should have an intuitive name and short description that reflects its purpose. The name should not include the word ‘accelerator’.
* Accelerators should have an appropriate and intuitive icon. 
* Accelerators should have tags that reflect language, framework, type of service e.g. database, messaging, etc. that would help in searching for an accelerator easily by tags. Tag names should use lowercase letters. Tag values should consist of [a-z0-9+#] separated by [-] and can be at most 63 characters 
* Accelerators should expose options to allow configuring an accelerator for different use cases/scenarios instead of creating multiple, yet very similar accelerators.
* Options should be easy to follow, each having a description that clearly states the role it plays in the accelerator. Options should have default value when appropriate.
* Options should be designed in a way that they do not become too long making it difficult to navigate. Make options conditional on others where appropriate.
* Free text options which have certain limitations on their values should ensure that these limitations are met through providing a regular expression based validation. This ensures early feedback on an invalid user input.
* Generated application skeletons should have a detailed README that describes the functionality and structure of a generated application. It also should provide detailed information on how developers can build and deploy a generated application of the accelerator and how to use it.

## <a id="tests"></a> Tests
### Application Skeleton
Having an Accelerator that generates an Application Skeleton without having a good test suite for the different layers or slices of the Application is promoting bad behavior: one could have code running in production without testing.

It is a good habit to have tests for the Application Skeleton:
* An overall application [`smoke`](https://en.wikipedia.org/wiki/Smoke_testing_(software)) test that bootstraps the application and see if it comes online
* A test per layer: e.g presentation layer, business layer and/or data layer. These tests can be unit-tests leveraging stubbing and/or mocking frameworks.
* An integration test per layer, especially the presentation layer and/or data layer. For example one could provide an integration test with some database interaction using [`testcontainers`](https://www.testcontainers.org/).