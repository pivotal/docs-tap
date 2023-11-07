# Overview of Tanzu Developer Portal plug-ins

This topic gives you an overview of the different plug-in types that Tanzu Developer Portal
supports. Some plug-ins are already integrated with Tanzu Developer Portal. Other plug-ins require
you to use Configurator to integrate them.

## <a id='tdp-plug-ins'></a> Tanzu Developer Portal plug-ins

A Tanzu Developer Portal plug-in is a Backstage plug-in inside a wrapper. The wrapper makes it
possible to dynamically integrate a Backstage plug-in into Tanzu Developer Portal. The wrapper
defines integration points with the underlying Backstage instance to remove the need to manually
update source code when adding a Backstage plug-in.

<!-- To learn more about how this works, see [Create a Tanzu Developer Portal plug-in](../configurator/create-plug-in-wrapper.hbs.md). -->

## <a id='tap-plug-ins'></a> Tanzu Application Platform plug-ins

Tanzu Application Platform comes with some pre-built Tanzu Developer plug-ins. These
Tanzu Application Platform plug-ins are already integrated with Tanzu Developer Portal. You don't
need to configure these plug-ins. To use a Tanzu Application Platform plug-in, you must install the
relevant Tanzu Application Platform component.

Tanzu Application Platform has the following Tanzu Developer Portal plug-ins:

- Runtime Resources Visibility
- Application Live View
- Application Accelerator
- API Documentation
- Supply Chain Choreographer
- Security Analysis
- DORA Metrics

## <a id='backstage-plug-ins'></a> Backstage plug-ins

Backstage plug-ins are developed by Backstage and are in the `@backstage` namespace.

## <a id='community-plug-ins'></a> Community plug-ins

Community plug-ins are not developed by Backstage or VMware. These plug-ins are not in the
`@backstage` namespace.

## <a id='valid-plug-ins'></a> Validated plug-ins

Validated plug-ins are Backstage plug-ins or community plug-ins that VMware has validated for use
with Tanzu Developer Portal. You don't need to create custom wrappers to integrate these plug-ins
with Tanzu Developer Portal.

For more information, see the [validated community plug-ins section](valid-plugins/about.hbs.md).

## <a id='ext-plug-ins'></a> External plug-ins

External plug-ins (also referred to as custom plug-ins) are plug-ins that are not in
Tanzu Developer Portal Configurator.

These plug-ins are typically published to npmjs.org or a similar npm registry alternative. If you
want to integrate an external plug-in that is not validated for use with Tanzu Developer Portal, you
must write a custom wrapper for it.