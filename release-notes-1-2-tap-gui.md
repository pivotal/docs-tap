# Release notes

{{#unless vars.hide_content}}
This Handlebars condition is used to hide content.
In release notes, this condition hides content that describes an unreleased patch for a released minor.
{{/unless}}
This topic contains release notes for Tanzu Application Platform v1.3


## <a id='1-3-0'></a> v1.2.0

#### <a id="tap-gui-known-issues"></a>Tanzu Application Platform GUI

- When accessing the Runtime Resources tab from the Component view, the following warning is displayed: `Access error when querying cluster 'host' for resource '/apis/source.apps.tanzu.vmware.com/v1alpha1/mavenartifacts' (status: 403). Contact your administrator.` This issue is resolved in v1.2.1. In v1.2.0 the user may choose to override this issue by following the instruction [here](./tap-gui/troubleshooting.md#maven-artifact-error).