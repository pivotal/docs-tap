# Accelerators - best practices and useful hints

## <a id="accelerator-benefits"></a> Benefits of using an accelerator

There are several reasons why it makes sense to spend time developing Accelerators:

- When the same application architecture setup for new applications is copied repeatedly.
- To enforce standardization of technology stacks and application setups throughout your
organization.
- To share best practices around application architecture, application, and test setup.

## <a id="design-considerations"></a> Design considerations

Each accelerator must have only one base technology stack (combined with related tooling) and one
target architecture. For example, if you use both Spring Boot and C# .NET Core applications in your
target environment you will need to set up two separate accelerators.
Mixing multiple technology stacks and multiple target architectures makes both the directory structure
and acceleratory.YAML unreadable.

The scope of your accelerator must align with your different types of deployments. For example,
back-end API, front-end UI, business service, and so on.

Choose OpenRewrite-based transformation over ReplaceText-based transformation when possible.
OpenRewrite-based transformations understand the semantics of the files they work on (for example, Maven
pom.xml or Java source file etc.) and provide more accurate robust modifications. As a
last resort, ReplaceText supports a regex mode. When used with capturing groups in the
replacement the string allows most modifications.

## <a id="housekeeping"></a> Housekeeping rules

VMware has found that the following rules keep the set of accelerators clear and findable for
end users:

- Have an intuitive name and short description that reflects the accelerators purpose. The word ‘accelerator’
  must not be in the name.
- Have an appropriate and intuitive icon.
- Have tags that reflect language, framework, and type of service. For example,
database, messaging, and so on. This helps when searching for an accelerator by tags. Tag names must
use lowercase letters, consist of [a-z0-9+#] separated by [-], and not exceed 63
characters.
- Accelerators must expose options to allow configuring an accelerator for different use cases instead
  of creating multiple very similar accelerators.
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

### Application skeleton

Having an accelerator that generates an application skeleton without having a good test suite for
the different layers or slices of the application promotes bad behavior. One might have code
running in production without testing.

It is a good habit to have tests for the application skeleton:

- You need to have an overall application test that bootstraps the application and sees if it comes
  online such as the application [`smoke`](https://en.wikipedia.org/wiki/Smoke_testing_(software)).
- A test per layer of the Application is needed. For example, presentation layer, business layer, or
data layer. These tests may be unit-tests leveraging stubbing or mocking frameworks.
- An integration test per layer of the Application is also needed. Especially the presentation
   or data layer. For example, one might provide an integration test with some database interaction
using [`test containers`](https://www.testcontainers.org/).
