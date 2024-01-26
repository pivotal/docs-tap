# Dependency version reference

When using any external dependencies with Tanzu Developer Portal, you must verify that the versions
are compatible. The following are references for some external dependencies that you might want to use.

## <a id='external-tdp-plugins'></a> External Tanzu Developer Portal plug-ins compatibility

The following are Tanzu Developer Portal plug-ins that are not included by default. To use these
with Configurator, you must choose a compatible version based on your version of
Tanzu Application Platform.

Tanzu Application Platform v1.8 offers the following support:

| Plug-in package name                                            | Compatible npm version |
| --------------------------------------------------------------- | ---------------------- |
| `@vmware-tanzu/tdp-plugin-auth-backend`                         | 2.0.0                  |
| `@vmware-tanzu/tdp-plugin-backstage-grafana`                    | 2.0.0                  |
| `@vmware-tanzu/tdp-plugin-backstage-jira`                       | 2.0.0                  |
| `@vmware-tanzu/tdp-plugin-backstage-sonarqube`                  | 2.0.0                  |
| `@vmware-tanzu/tdp-plugin-backstage-sonarqube-backend`          | 2.0.0                  |
| `@vmware-tanzu/tdp-plugin-custom-logger`                        | 2.0.0                  |
| `@vmware-tanzu/tdp-plugin-github-actions`                       | 2.0.0                  |
| `@vmware-tanzu/tdp-plugin-home`                                 | 2.0.0                  |
| `@vmware-tanzu/tdp-plugin-ldap-backend`                         | 2.0.0                  |
| `@vmware-tanzu/tdp-plugin-login`                                | 2.0.0                  |
| `@vmware-tanzu/tdp-plugin-microsoft-graph-org-reader-processor` | 2.0.0                  |
| `@vmware-tanzu/tdp-plugin-permission-backend`                   | 2.0.0                  |
| `@vmware-tanzu/tdp-plugin-prometheus`                           | 2.0.0                  |
| `@vmware-tanzu/tdp-plugin-rbac`                                 | 2.0.0                  |
| `@vmware-tanzu/tdp-plugin-rbac-backend`                         | 2.0.0                  |
| `@vmware-tanzu/tdp-plugin-snyk`                                 | 2.0.0                  |
| `@vmware-tanzu/tdp-plugin-stack-overflow`                       | 2.0.0                  |
| `@vmware-tanzu/tdp-plugin-techinsights`                         | 2.0.0                  |
| `@vmware-tanzu/tdp-plugin-techinsights-backend`                 | 2.0.1                  |

## <a id='tdp-libraries'></a> Tanzu Developer Portal plug-in libraries compatibility

The following are libraries used to create Tanzu Developer Portal plug-ins.

When using these libraries, you must choose a compatible version based on your version of
Tanzu Application Platform.

Tanzu Application Platform v1.8 offers the following support:

| Library package name          | Compatible npm version |
| ----------------------------- | ---------------------- |
| `@vmware-tanzu/core-backend`  | 2.0.1                  |
| `@vmware-tanzu/core-common`   | 2.0.0                  |
| `@vmware-tanzu/core-frontend` | 2.0.0                  |

## <a id='bs-ver-table'></a> Backstage version compatibility

Tanzu Application Platform v1.8 is compatible with the following Backstage version. Developers must verify that a dependency used by Backstage is compatible with your current Tanzu Application Platform installation. Care should also be taken to see how Tanzu Application Platform upgrades might affect this compatibility.

| Tanzu Application Platform version | Backstage version | Dependencies manifest                                                             |
| ---------------------------------- | ----------------- | --------------------------------------------------------------------------------- |
| 1.8.x                              | v1.20             | [Manifest file](https://github.com/backstage/backstage/blob/v1.20.3/package.json) |
