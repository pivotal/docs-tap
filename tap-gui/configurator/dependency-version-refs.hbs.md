# Dependency version reference

When using any external dependencies with Tanzu Developer Portal, you must verify that the versions
are compatible. The following are references for some external dependencies that you might want to use.

## <a id='external-tdp-plugins'></a> External Tanzu Developer Portal plug-ins compatibility

The following are Tanzu Developer Portal plug-ins that are not included by default. To use these
with Configurator, you must choose a compatible version based on your version of
Tanzu Application Platform.

Tanzu Application Platform versions earlier than v1.7 do not support any external plug-ins.

Tanzu Application Platform v1.7.0 offers the following support:

| Plug-in package name                                            | Compatible npm version |
|-----------------------------------------------------------------|------------------------|
| `@vmware-tanzu/tdp-plugin-auth-backend`                         | 1.0.0                  |
| `@vmware-tanzu/tdp-plugin-backstage-grafana`                    | 0.0.2                  |
| `@vmware-tanzu/tdp-plugin-backstage-jira`                       | 0.0.2                  |
| `@vmware-tanzu/tdp-plugin-backstage-sonarqube`                  | 0.0.2                  |
| `@vmware-tanzu/tdp-plugin-backstage-sonarqube-backend`          | 0.0.3                  |
| `@vmware-tanzu/tdp-plugin-custom-logger`                        | 1.0.0                  |
| `@vmware-tanzu/tdp-plugin-github-actions`                       | 0.0.2                  |
| `@vmware-tanzu/tdp-plugin-home`                                 | 0.0.2                  |
| `@vmware-tanzu/tdp-plugin-ldap-backend`                         | 1.0.0                  |
| `@vmware-tanzu/tdp-plugin-login`                                | 1.0.0                  |
| `@vmware-tanzu/tdp-plugin-microsoft-graph-org-reader-processor` | 1.0.0                  |
| `@vmware-tanzu/tdp-plugin-permission-backend`                   | 1.0.0                  |
| `@vmware-tanzu/tdp-plugin-prometheus`                           | 0.0.2                  |
| `@vmware-tanzu/tdp-plugin-snyk`                                 | 0.0.2                  |
| `@vmware-tanzu/tdp-plugin-stack-overflow`                       | 0.0.2                  |
| `@vmware-tanzu/tdp-plugin-techinsights`                         | 0.0.2                  |
| `@vmware-tanzu/tdp-plugin-techinsights-backend`                 | 0.0.2                  |

## <a id='tdp-libraries'></a> Tanzu Developer Portal plug-in libraries compatibility

The following are libraries used to create Tanzu Developer Portal plug-ins.
When using these libraries, you must choose a compatible version based on your version of
Tanzu Application Platform.

Tanzu Application Platform versions earlier than v1.7 do not support creating your own
Tanzu Developer Portal plug-ins.

Tanzu Application Platform v1.7.0 offers the following support:

| Library package name          | Compatible npm version |
|-------------------------------|------------------------|
| `@vmware-tanzu/core-backend`  | 1.0.0                  |
| `@vmware-tanzu/core-common`   | 1.0.0                  |
| `@vmware-tanzu/core-frontend` | 1.0.0                  |

## <a id='bs-ver-table'></a> Backstage version compatibility

The following Backstage Version Compatibility table shows which versions of Tanzu Application Platform
versions are compatible with which Backstage versions. This is crucial information for plug-in
development.

Use this table to:

- Verify that a dependency used by Backstage is compatible with your current Tanzu Application Platform
  installation
- See how Tanzu Application Platform upgrades might affect this compatibility

Each dependencies manifest entry links to the respective Backstage dependencies manifest file.

| Tanzu Application Platform version | Backstage version | Dependencies manifest                                                             |
|------------------------------------|-------------------|-----------------------------------------------------------------------------------|
| 1.6.x                              | v1.13             | [Manifest file](https://github.com/backstage/backstage/blob/v1.13.0/package.json) |
| 1.7.x                              | v1.15             | [Manifest file](https://github.com/backstage/backstage/blob/v1.15.0/package.json) |
