# Accelerators - Best Practices and Useful Hints

## <a id="accelerator-benefits"></a> Benefits of using an accelerator

There are several reasons why it makes sense to spend time developing Accelerators:

- The same application architecture setup for new applications is copied repeatedly.
- To enforce standardization of technology stacks and application setups throughout your
organization.
- To share best practices around application architecture, application, and test setup.

## <a id="design-considerations"></a> Design considerations

Choose one base technology stack (combined with related tooling) and one target
deployment architecture for each Accelerator. If you have both Spring Boot and C# .NET
Core applications in your target environment, create one for Spring Boot and one for C# .NET Core.
Do not mix them, it makes both the directory structure and acceleratory.YAML unreadable.

Think about the scope of your Accelerator. The scope must align with your different types
of deployments. For example, back-end API, front-end UI, business service, and so on.

Choose OpenRewrite-based transformation over ReplaceText-based transformation when possible.
OpenRewrite-based transformations understand the semantics of files they work on (for example, Maven
pom.xml or Java source file etc.) and they provide more accurate and robust modifications. As a
last resort, ReplaceText supports a regex mode. When used with capturing groups in the
replacement the string allows most modifications.

## <a id="housekeeping"></a> Housekeeping rules

VMware has found that the following rules keep the set of Accelerators clear and findable for
end users.

- Have an intuitive name and short description that reflects the Accelerators purpose. Do not
include the word ‘accelerator’ in the name.
- Have an appropriate and intuitive icon.
- Have tags that reflect language, framework, and type of service. For example,
database, messaging, and so on. This helps when searching for an accelerator by tags. Tag names must
use lowercase letters. Tag values must consist of [a-z0-9+#] separated by [-] and not exceed 63
characters.
- Accelerators expose options to allow configuring an accelerator for different use cases instead of
creating multiple very similar accelerators.
- Options must be straightforward having a description that states the role it plays in the
accelerator. Options must have the default value when appropriate.
- Options must be designed so that they are not too long which makes it difficult to navigate.
Make options conditional on others where appropriate.
- Free text options that have certain limitations on their values must ensure that these
limitations are met by providing a regular expression-based validation. This ensures early feedback
on invalid user input.
- Generated application skeletons must have a detailed README file that describes the function and
structure of a generated application. It must provide detailed information about how developers
can build and deploy a generated application of the accelerator and how to use it.

## <a id="tests"></a> Tests

### Application Skeleton

Having an Accelerator that generates an Application Skeleton without having a good test suite for
the different layers or slices of the Application promotes bad behavior. One might have code
running in production without testing.

It is a good habit to have tests for the Application Skeleton:

- An overall application test that bootstraps the application and sees if it comes online such as
the application [`smoke`](https://en.wikipedia.org/wiki/Smoke_testing_(software)).
- A test per layer of the Application. For example, presentation layer, business layer, or
data layer. These tests may be unit-tests leveraging stubbing or mocking frameworks.
- An integration test per layer of the Application. Especially the presentation layer or data layer.
For example, one might provide an integration test with some database interaction
using [`test containers`](https://www.testcontainers.org/).
