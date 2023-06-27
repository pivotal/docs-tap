# Best practices for using Accelerators

This topic tells you about the benefits, and design considerations for accelerators.

## <a id="accelerator-benefits"></a> Benefits of using an accelerator

There are several good reasons to develop accelerators:

- If you're repeatedly using the same application architecture for new applications.
- To enforce standardization of technology stacks and application setups throughout your organization.
- To share best practices around application architecture, application, and test setup.

## <a id="design-considerations"></a> Design considerations

Each accelerator must have only one base technology stack, combined with related tooling, and one
target architecture. For example, if you use both Spring Boot and C# .NET Core applications in your
target environment you must set up two separate accelerators.
Mixing multiple technology stacks and multiple target architectures makes both the directory structure
and acceleratory.YAML unreadable.

Think about the scope of your Accelerator. The scope needs to be aligned with the different types of deployments you have. For example, back-end API, front-end UI, business service, and so on.

Choose OpenRewrite-based transformation over ReplaceText-based transformation when possible.
OpenRewrite-based transformations understand the semantics of the files they work on, for example, Maven
pom.xml or Java source files.
OpenRewrite-based transformations also provide more accurate and robust modifications.
As a last resort, ReplaceText supports a regex mode. When used with capturing groups in the
replacement string, ReplaceText allows most modifications.

## <a id="housekeeping"></a> Housekeeping rules

VMware has found that the following rules keep our set of Accelerators clear and findable for our end users.

- Use an intuitive name and short description that reflects the accelerators purpose. The word ‘accelerator’
  must not be in the name.
- Use an appropriate and intuitive icon.
- Use tags that reflect language, framework, and type of service. For example,
database, messaging, and so on. This helps when searching for an accelerator by tags. Tag names must
use lowercase letters, consist of [a-z0-9+#] separated by [-], and not exceed 63
characters.
- Accelerators must expose options to allow configuring an accelerator for different use cases instead
  of creating multiple similar accelerators.
- Options must be straightforward, the description of each clearly stating the role it plays in the
accelerator. Options must have default values when appropriate.
- Options must be short so that they are easy to navigate. Make options conditional on other options
as appropriate.
- Free text options that have limitations on their values must ensure these
limitations are met by a regular expression-based validation. This validation ensures
early feedback on invalid user input.
- Generated application skeletons must have a detailed README file that describes the function and
structure of a generated application. It must provide detailed information about how developers
can build and deploy a generated application of the accelerator and how to use it.

## <a id="tests"></a> Tests

### Application Skeleton

An accelerator that generates an application skeleton without a good test suite for
the different layers of the application promotes bad behavior. It could result in code
running in production without testing.

Tests you could use for the application skeleton:

- An overall application test that bootstraps the application to see if it comes online.
- A test per layer of the application. For example, presentation layer, business layer, and
data layer. These tests can be unit tests that leverage stubbing or mocking frameworks.
- An integration test per layer of the application, especially the presentation
   and data layer. For example, you can provide an integration test with some database interaction
by using [test containers](https://www.testcontainers.org/).
