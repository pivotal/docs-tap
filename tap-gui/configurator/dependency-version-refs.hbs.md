# Dependency version reference

When using any external dependencies with Tanzu Developer Portal, you will need to verify that the versions are
compatible.
The following are references for some external dependencies you might want to use.

## <a id='external-tdp-plugins'></a> External Tanzu Developer Portal plug-ins compatibility

The following are Tanzu Developer Portal plug-ins that are not included by default.
In order to use these with the Configurator, you must choose a compatible version based on your version of TAP.

### TAP version 1.6.x

TAP version 1.6 does not support any external plug-ins.

### TAP version 1.7.0

| Plug-in Package Name                                          | Compatible NPM Version |
|---------------------------------------------------------------|------------------------|
| @vmware-tanzu/tdp-plugin-auth-backend                         | 1.0.0                  |
| @vmware-tanzu/tdp-plugin-backstage-grafana                    | 0.0.2                  |
| @vmware-tanzu/tdp-plugin-backstage-jira                       | 0.0.2                  |
| @vmware-tanzu/tdp-plugin-backstage-sonarqube                  | 0.0.2                  |
| @vmware-tanzu/tdp-plugin-backstage-sonarqube-backend          | 0.0.3                  |
| @vmware-tanzu/tdp-plugin-custom-logger                        | 1.0.0                  |
| @vmware-tanzu/tdp-plugin-github-actions                       | 0.0.2                  |
| @vmware-tanzu/tdp-plugin-home                                 | 0.0.2                  |
| @vmware-tanzu/tdp-plugin-ldap-backend                         | 1.0.0                  |
| @vmware-tanzu/tdp-plugin-login                                | 1.0.0                  |
| @vmware-tanzu/tdp-plugin-microsoft-graph-org-reader-processor | 1.0.0                  |
| @vmware-tanzu/tdp-plugin-permission-backend                   | 1.0.0                  |
| @vmware-tanzu/tdp-plugin-prometheus                           | 0.0.2                  |
| @vmware-tanzu/tdp-plugin-snyk                                 | 0.0.2                  |
| @vmware-tanzu/tdp-plugin-stack-overflow                       | 0.0.2                  |
| @vmware-tanzu/tdp-plugin-techinsights                         | 0.0.2                  |
| @vmware-tanzu/tdp-plugin-techinsights-backend                 | 0.0.2                  |

## <a id='tdp-libraries'></a> Tanzu Developer Portal plug-in libraries compatibility

The following are libraries used to create Tanzu Developer Portal plug-ins.
When using these libraries, you must choose a compatible version based on your version of TAP.

### TAP version 1.6.x

TAP version 1.6 does not support creating your own Tanzu Developer Portal plug-ins.

### TAP version 1.7.0

| Library Package Name        | Compatible NPM Version |
|-----------------------------|------------------------|
| @vmware-tanzu/core-backend  | 1.0.0                  |
| @vmware-tanzu/core-common   | 1.0.0                  |
| @vmware-tanzu/core-frontend | 1.0.0                  |

## <a id='bs-ver-table'></a> Backstage version compatibility

The following Backstage Version Compatibility table shows which versions of Tanzu Application Platform
versions are compatible with which Backstage versions. This is crucial information for plug-in
development.

Use this table to verify that a dependency used by Backstage is compatible with your current Tanzu
Application Platform installation and see how Tanzu Application Platform upgrades
might affect this compatibility.

Each dependencies manifest entry links to the respective Backstage dependencies manifest file.

| TAP Version | Backstage Version | Dependencies manifest                                                             |
|-------------| ----------------- | --------------------------------------------------------------------------------- |
| 1.6.x       | v1.13             | [Manifest file](https://github.com/backstage/backstage/blob/v1.13.0/package.json) |
| 1.7.x       | v1.15             | [Manifest file](https://github.com/backstage/backstage/blob/v1.15.0/package.json) |
