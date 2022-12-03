# Fragments - best practices and useful hints

A fragment is a partial accelerator and can do the same transformations that an accelerator can do.
It cannot run on its own. It’s always part of the calling (host) accelerator.

Developing a fragment is useful in the following situations:

- When you must update a version of an element of a technology stack in multiple locations.
For example, when the Java Development Kit (JDK) version must be updated in the build tool
configuration, the buildpack configuration, and in the deployment options.
- For adding a consistent cross-cutting concern to a set of Accelerators. Such as logging, monitoring,
or support for a certain type of deployment or framework.
- For adding integration with some technology to a generated application skeleton.
Such as certain database support, support for a certain messaging middleware, or an
integration with an email provider.

## <a id="design-considerations"></a> Design considerations

Developing and maintaining a Fragment is complex. The following is a list of design considerations:

- The fragment you develop must be ready to work with all possible syntax and format
variations. For example, dependency in a `Gradle` build.gradle.kts can have the following forms:

  - `implementation(‘org.springframework.boot:spring-boot-starter’)`
  - `implementation("org.springframework.boot:spring-boot-starter")`
  - `implementation(group = "org.springframework.boot”, name= “spring-boot-starter")`
  - `implementation(group = ‘org.springframework.boot’, name= ‘spring-boot-starter’)`
  - `implementation(name= “spring-boot-starter", group = "org.springframework.boot”)`

- When the fragment is used in multiple accelerator contexts and the behavior still causes a compiled
and deployable application skeleton.
- Testing a fragment in isolation is more difficult than testing an accelerator. Testing takes more
time as all the combinations must be tested from an accelerator perspective.
- When flexibly reusing fragments in different combinations each fragment must cover a small,
cohesive function. Fragments must follow these two UNIX principles:

  - Small is beautiful.
  - Each fragment does one thing well.

- Keep the files the fragment changes to a minimum. Only change the files that are related to the same
technology stack for the same purpose.
- The design of both the accelerators and fragments are limited by the technology stack and the target
deployment technology that is chosen for the accelerator. For example, to create a fragment for
standardizing logging, you must create one fragment per base technology stack.

## <a id="housekeeping"></a> Housekeeping rules

Fragments are used by accelerator authors. VMware has found that the following guidelines keeps
fragments understandable and reusable.

- Fragments must have an intuitive name and short description that reflects their purpose. The name
must not include the word ‘fragment’.
- Fragments must expose options to allow configuring the output of execution.
- Each fragment must contain a README file explaining what additional functions the fragment adds
to a generated application skeleton. It must also include what options are expected in the fragment.
It must contain a description of how this fragment is to be used in a host accelerator. If there are
any known limitations or use cases not covered, they must be clearly stated in the README file. For
example, if the fragment supports Maven and Gradle as build tools but only Groovy DSL of Gradle is
supported, the README file must include this information.
- If a fragment must provide additional documentation to end users, it can either be added to a README-X
file of the generated application skeleton or append a section to the host’s README.
