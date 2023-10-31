# Overview of Tanzu Developer Portal plug-ins

Tanzu Developer Portal can integrate with many plug-ins. Some of these plug-ins are pre-integrated into the developer portal and some can be integrated via the configurator. This section gives an overview of the different plug-in types that are supported in Tanzu Developer Portal.

## Tanzu Application Platform Plug-ins

Tanzu Application Platform plug-ins are pre-integrated plug-ins. You need not configure the plug-ins.
To use a plug-in, you must install the relevant Tanzu Application Platform component.

Tanzu Application Platform has the following Tanzu Application Platform GUI plug-ins:

- Runtime Resources Visibility
- Application Live View
- Application Accelerator
- API Documentation
- Supply Chain Choreographer
- Security Analysis
- DORA Metrics

## Validated Plug-ins

Validated plug-ins are community plug-ins that are validated and do not require any preparation work by a user to integrate into Tanzu Developer Portal. This simple mechanism for integrating these plug-ins into the developer portal do not require a customer to create any custom wrappers.

Tanzu Developer Portal currently supports the following nine community plug-ins:

- GitHub Actions
- Grafana
- Home Page
- Jira
- Prometheus
- Snyk
- SonarQube
- Stack Overflow
- TechInsights

## External Plug-ins

External plug-ins are plug-ins that are not validated and not pre-integrated into Tanzu Developer Portal. External plug-ins allows users to integrate any external plug-in and require a user to write a custom wrapper for their external plug-in.