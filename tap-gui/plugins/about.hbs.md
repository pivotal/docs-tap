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

## Backstage Plug-ins

Backstage plug-ins are plug-ins which are developed by Backstage and are in the `@backstage` namespace.

## Community Plug-ins

Community plug-ins are plug-ins which are not developed by Backstage or VMware. These plug-ins are not under the `@backstage` namespace.

## Validated Plug-ins

Validated plug-ins are both backstage and community plug-ins that are validated and do not require any preparation work by a user to integrate into Tanzu Developer Portal. This simple mechanism for integrating these plug-ins into the developer portal do not require a customer to create any custom wrappers.

Tanzu Developer Portal currently supports the following nine validated plug-ins:

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

External plug-ins (also referred to as custom plug-ins) are plug-ins that are not included in the Tanzu Developer Portal configurator.  These are generally plug-ins which are published to npmjs.org or a similar npm registry alternative. If a user would like to integrate with an external plug-in that is not already validated, the user will be required to write a custom wrapper in order to integrate it with Tanzu Developer Portal.