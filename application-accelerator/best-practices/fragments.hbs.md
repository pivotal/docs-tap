# Fragments - Best Practices and Useful Hints.

A Fragment is a partial Accelerator and can do the same transformations that an Accelerator can do. However, it cannot run on its own, it’s always part of the calling (host) Accelerator. 

Developing a Fragment is useful in the following situations:
* If you need to update a version of an element of a technology stack in multiple locations. (e.g. JDK version needs to be updated in the build tool configuration and in the buildpack configuration and in the deployment options)
* If you want to add consistent cross-cutting concern to a set of Accelerators, like: logging, monitoring or support for a certain type of deployment or support for a certain framework.
* If you want to add integration with some technology to a generated application skeleton. For example certain database support or support for a certain messaging middleware or an integration with an email provider.

## <a id="design-considerations"></a> Design considerations
Developing and maintaining a Fragment is complex:

* As a Fragment author you don’t know what kind of formatting rules or particular syntax variation is used in a host Accelerator. A Fragment you develop needs to be ready to work with all possible syntax and format variation. For example dependency in a Gradle build.gradle.kts can have following forms:
    * `implementation(‘org.springframework.boot:spring-boot-starter’)`
    * `implementation("org.springframework.boot:spring-boot-starter")`
    * `implementation(group = "org.springframework.boot”, name= “spring-boot-starter")`
    * `implementation(group = ‘org.springframework.boot’, name= ‘spring-boot-starter’)`
    * `implementation(name= “spring-boot-starter", group = "org.springframework.boot”)`
* The Fragment will be used in multiple Accelerator contexts and behavior should still result in a compilable and deployable Application Skeleton
* As testing a Fragment in isolation is more difficult than testing an Accelerator, testing takes more time as all the combinations need to be tested from Accelerator perspective.

Some considerations:
* To be able to be reused flexibly and in different combinations each fragment should cover a small, cohesive piece of functionality. In other words fragments should follow these two Unix principles:
    * Small is Beautiful
    * Each Program(Fragment) Does One Thing Well
* Keep the files it will change to a minimum: only change the files that are related to the same technology stack for the same purpose.
* Be mindful that the design of both Accelerator and the Fragment is naturally limited by the technology stack and target deployment technology that is being chosen for the Accelerator. For example, if you would like to create a Fragment for standardizing logging, create one per base technology stack.

## <a id="housekeeping"></a> Housekeeping rules
Fragments are used by Accelerator Authors. We have found that the following guidelines keep our Fragments easy to understand and to reuse.

* Fragments should have an intuitive name and short description that reflects its purpose. The name should not include the word ‘fragment’.
* Fragments should expose options to allow configuring output of an execution.
* As the main and the only users of fragments are accelerator authors, each fragment should contain a README explaining what additional functionality this fragment can add to a generated application skeleton and what options are expected by this fragment. It also should contain a description how this fragment can be included in a host accelerator. If there are any known limitations or not covered use cases they should be clearly stated in the README (e.g. fragment supports Maven and Gradle as build tools but only Groovy DSL of Gradle is supported).
* If a fragment needs to provide any additional documentation to end users it may either add an additional README-X file to the generated application skeleton or append a section to the host’s README.
