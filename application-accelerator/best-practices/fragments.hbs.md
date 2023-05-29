# Best practices for using Fragments

This topic outlines the benefits, and design considerations for Fragments.

## Benefits of using Fragment

A fragment is a partial accelerator. It can do the same transformations as an accelerator, but
it cannot run on its own. It’s always part of the calling (host) accelerator.

Developing a fragment is useful in the following situations:

- When you must update a version of an element of a technology stack in multiple locations.
For example, when the Java Development Kit (JDK) version must be updated in the build tool
configuration, the buildpack configuration, and in the deployment options.
- To add a consistent cross-cutting concern to a set of accelerators. For example, logging, monitoring,
or support for a certain type of deployment or framework.
- To add integration with some technology to a generated application skeleton.
For example, certain database support, support for a messaging middleware, or
integration with an email provider.

## <a id="design-considerations"></a> Design considerations

Developing and maintaining a fragment is complex. The following is a list of design considerations:

- The fragment you develop must work with all possible syntax and format
variations. For example, dependency in a `Gradle` build.gradle.kts can have the following forms:

  - `implementation(‘org.springframework.boot:spring-boot-starter’)`
  - `implementation("org.springframework.boot:spring-boot-starter")`
  - `implementation(group = "org.springframework.boot”, name= “spring-boot-starter")`
  - `implementation(group = ‘org.springframework.boot’, name= ‘spring-boot-starter’)`
  - `implementation(name= “spring-boot-starter", group = "org.springframework.boot”)`

- The fragment can be used in multiple accelerator contexts and its behavior must result in a compilable
and deployable application skeleton.
- Testing a fragment in isolation is more difficult than testing an accelerator. Testing takes more
time because all the combinations must be tested from an accelerator perspective.
- When flexibly reusing fragments in different combinations, each fragment must cover a small,
cohesive function. Fragments must follow these two UNIX principles:

  - Small is beautiful.
  - Each fragment does one thing well.

- Keep the files the fragment changes to a minimum. Only change the files that are related to the same
technology stack for the same purpose.
- The design of both the accelerator and fragment is limited by the technology stack and the target
deployment technology chosen for the accelerator. For example, to create a fragment for
standardizing logging, you must create one fragment per base technology stack.

## <a id="housekeeping"></a> Housekeeping rules

Fragments are used by accelerator authors. VMware has found that the following guidelines keep
fragments understandable and reusable.

- Give fragments an intuitive name and short description that reflects their purpose. Do not include "fragment" in the name.
- Fragments must expose options to allow configuring the output of execution.
- Each fragment must contain a README file explaining the additional functions the fragment adds
to a generated application skeleton. List any options expected by this fragment.
Also describe how this fragment can be included in a host accelerator.  Be sure to state
any known limitations or use cases not covered. For
example, if the fragment supports Maven and Gradle as build tools but only Groovy DSL of Gradle is
supported, the README file must include this information.
- If a fragment must provide additional documentation to end users, it can either be added to a README-X
file of the generated application skeleton or append a section to the host’s README.
