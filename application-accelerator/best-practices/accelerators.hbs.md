# Accelerators - Best Practices and Useful Hints

## <a id="accelerator-benefits"></a> Benefits of using an accelerator

There are several reasons why it makes sense to spend time developing Accelerators:

- If you find that the same application architecture setup for new applications is copied repeatedly.
- If you want to enforce standardization of technology stacks and application setups throughout your organization.
- If you want to share best practices around application architecture, application, and test setup.

## <a id="design-considerations"></a> Design considerations

Each accelerator must have only one base technology stack (combined with related tooling) and one
target architecture. For example, if you use both Spring Boot and C# .NET Core applications in your
target environment you must set up two separate accelerators.
Mixing multiple technology stacks and multiple target architectures makes both the directory structure
and acceleratory.YAML unreadable.

Think about the scope of your Accelerator. The scope needs to be aligned with the different types of deployments you have. For example, back-end API, front-end UI, business service, and so on.

Choose OpenRewrite-based transformation over ReplaceText-based transformation when possible. OpenRewrite-based transformations understand the semantics of files they work on (e.g. Maven pom.xml or Java source file etc.) and they can provide more accurate and robust modifications. As a last resort, ReplaceText supports a regex mode which, when used with capturing groups in the replacement string, allows most modifications.

## <a id="housekeeping"></a> Housekeeping rules

VMware has found that the following rules keep our set of Accelerators clear and findable for our end users.

- Have an intuitive name and short description that reflects the accelerators purpose. The word ‘accelerator’
  must not be in the name.
- Have an appropriate and intuitive icon.
- Have tags that reflect language, framework, and type of service. For example,
database, messaging, and so on. This helps when searching for an accelerator by tags. Tag names must
use lowercase letters, consist of [a-z0-9+#] separated by [-], and not exceed 63
characters.
- Accelerators must expose options to allow configuring an accelerator for different use cases instead
  of creating multiple very similar accelerators.
- Options must be straightforward, having a description that states the role it plays in the
accelerator. Options must have the default value when appropriate.
- Options must be short so that they are easy to navigate. Options must be conditional on other options
if appropriate.
- Options that have limitations on their values must validate these
limitations with a regular expression-based validation. This validation ensures
early feedback on invalid user input.
- Generated application skeletons must have a detailed README file that describes the function and
structure of a generated application. It must provide detailed information about how developers
can build and deploy a generated application of the accelerator and how to use it.

## <a id="tests"></a> Tests

### Application Skeleton

Having an Accelerator that generates an Application Skeleton without having a good test suite for the different layers or slices of the Application is promoting bad behavior: one might have code running in production without testing.

It is a good habit to have tests for the Application Skeleton:

- You must test the application to confirm it comes online.
- A test per layer of the Application is needed. For example, presentation layer, business layer, or
data layer. These tests can be unit-tests leveraging stubbing or mocking frameworks.
- An integration test per layer of the Application is also needed. Especially the presentation
   or data layer. For example, one might provide an integration test with some database interaction
using [`test containers`](https://www.testcontainers.org/).
