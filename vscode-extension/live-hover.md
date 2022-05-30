# Live Hover integration with Spring Boot Tools (Experimental)

## <a id="prerequisites"></a> Prerequisites

- A Tanzu Spring Boot application, such as [tanzu-java-web-app](https://github.com/sample-accelerators/tanzu-java-web-app)
- Spring Boot Tools [extension](https://marketplace.visualstudio.com/items?itemName=Pivotal.vscode-spring-boot) version `1.33` or later.

## <a id="activating-feature"></a> Activating Live Hover

In order to activate live hover, you need to start your vscode instance with `TAP_LIVER_HOVER=true`, eg.
`> TAP_LIVE_HOVER=true code /path/to/project`

Once you have a workload deployed, you should see the live hovers.
