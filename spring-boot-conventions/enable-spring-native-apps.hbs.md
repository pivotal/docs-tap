# Enable Spring Native apps for Application Live View

This topic tells you how to run Spring Native workloads within Tanzu Application Platform
(commonly known as TAP).

This topic describes how the Spring Boot convention server enhances Tanzu `PodIntents` with
metadata. This metadata can include labels, annotations, or properties required to run native
workloads in Tanzu Application Platform.

The metadata enables Application Live View to discover and register the app instances so that
Application Live View can access the actuator data from those workloads.

<!-- The below partial is in the docs-tap/partials directory -->

{{> 'partials/app-live-view/enable-spring-native-apps' }}
