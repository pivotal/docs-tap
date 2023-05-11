# Application Live View

Application Live View is a lightweight insights and troubleshooting tool for app developers and
app operators that helps you to look inside running applications.
It is based on the concept of Spring Boot Actuators.

The application provides information from inside the running processes using endpoints,
in this case, HTTP endpoints.
Application Live View uses those endpoints to get and interact with the data from apps.

## <a id="value-proposition"></a>Value proposition

Application Live View is a diagnostic tool for developers to manage and analyze
runtime characteristics of containerized apps.
In addition, it provides a Kubernetes-native feel for developers to manage
their apps in a Kubernetes environment more effectively.

## <a id="intended-audience"></a>Intended audience

This documentation is intended for developers and operators to visualize the actuator
information of their running apps on Application Live View for VMware Tanzu.
This documentation helps developers to monitor and troubleshoot apps
in development, staging, and production environments.
It is also intended to help app operators to deploy and administer
containerized apps in a Kubernetes environment.

## <a id="supported-app-platforms"></a>Supported application platforms

You can extend Application Live View to support multiple app platforms, including,
but not limited to, Spring Boot, Spring Cloud Gateway, and Steeltoe.

## <a id="multicloud-compatibility"></a> Multicloud compatibility

Using Tanzu platform, you can integrate Application Live View to monitor apps
running across on-premises, public clouds, and edge.
The platform provides a centralized view to manage apps across cloud environments,
which accelerates developer productivity and reduces time-to-market.

## <a id="deployment"></a> Deployment

Use a connector as the mode of deployment for registering apps with the Application Live View running on a Kubernetes cluster. A connector is a component responsible for discovering multiple apps running on a Kubernetes cluster and is installed as a DaemonSet by default.
