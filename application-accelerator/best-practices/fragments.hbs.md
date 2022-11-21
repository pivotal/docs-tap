# Fragments - Best Practices and Useful Hints

A Fragment is a partial Accelerator and can do the same transformations that an Accelerator can do.
It cannot run on its own. It’s always part of the calling (host) Accelerator.

Developing a Fragment is useful in the following situations:

- When you must update a version of an element of a technology stack in multiple locations.
For example, when the Java Development Kit (JDK) version must be updated in the build tool
configuration, the buildpack configuration, and in the deployment options.
- For adding a consistent cross-cutting concern to a set of Accelerators. Such as logging, monitoring,
or support for a certain type of deployment or framework.
- To add integration with some technology to a generated application skeleton.
Such as  certain database support, support for a certain messaging middleware, or an
integration with an email provider.

## <a id="design-considerations"></a> Design considerations

Developing and maintaining a Fragment is complex:

- As a Fragment author you don’t know what kind of formatting rules or syntax variation is used in a
host Accelerator. A Fragment you develop must be ready to work with all possible syntax and format
variations. For example, dependency in a `Gradle` build.gradle.kts can have the following forms:

    - `implementation(‘org.springframework.boot:spring-boot-starter’)`
    - `implementation("org.springframework.boot:spring-boot-starter")`
    - `implementation(group = "org.springframework.boot”, name= “spring-boot-starter")`
    - `implementation(group = ‘org.springframework.boot’, name= ‘spring-boot-starter’)`
    - `implementation(name= “spring-boot-starter", group = "org.springframework.boot”)`

- When the fragment is used in multiple accelerator contexts and the behavior still causes a compiled
and deployable application skeleton.
- Testing a fragment in isolation is more difficult than testing an accelerator.Testing takes more
time as all the combinations must be tested from an accelerator perspective.
- When flexibly reusing fragments in different combinations each fragment must cover a small,
cohesive function. Fragments must follow these two UNIX principles:

  - Small is beautiful.
  - Each Fragment does one thing well.

- Keep the files it changes to a minimum. Only change the files that are related to the same
technology stack for the same purpose.
- Be mindful that the design of both the Accelerator and the Fragment is limited by the
technology stack and the target deployment technology that is chosen for the Accelerator.
For example, to create a Fragment for standardizing logging, you must create one Fragment per base
technology stack.

## <a id="housekeeping"></a> Housekeeping rules

Fragments are used by Accelerator Authors. VMware has found that the following guidelines keep our Fragments understandable and able to be reused.

- Fragments must have an intuitive name and short description that reflects their purpose. The name must not include the word ‘fragment’.
- Fragments must expose options to allow configuring the output of execution.
- As the main and only users of fragments are accelerator authors, each fragment must contain a
README file explaining what additional functions the fragment adds to a generated application skeleton.
It must also include what options are expected in this fragment. It must contain a
description of how this fragment is to be used in a host accelerator. If there are any known
limitations or not covered use cases, they must be clearly stated in the README file (such as,
fragment supports Maven and Gradle as build tools but only Groovy DSL of Gradle is supported).
- If a fragment must provide any additional documentation to end users it can either add a README-X
file to the generated application skeleton or append a section to the host’s README.
