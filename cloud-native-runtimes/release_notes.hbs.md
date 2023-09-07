# Cloud Native Runtimes Release Notes

This topic contains release notes for Cloud Native Runtimes (CNR) for Tanzu v2.4.

## <a id="2-4-0"></a> v2.4.0

**Release Date:** TBD

### Breaking Changes

Breaking changes in this release:

-

### New Features

New features in this release:

- **New config option `resource_management`**: Allows configuration of cpu and memory resources (follows [Kubernetes requests and limits](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)) for all Knative Serving deployments in the `knative-serving` namespace. For example, to configure the cpu and memory requirements for the `activator` deployment:
    ```
    resource_management:
      - name: "activator"
        requests:
          memory: "100Mi"
          cpu: "100m"
        limits:
          memory: "1000Mi"
          cpu: "1"
    ```

- **Knative Serving v1.11**: Knative Serving v1.11 is available in Cloud Native Runtimes. See the [Knative v1.11 release notes](https://knative.dev/blog/releases/announcing-knative-v1-11-release/) for more details.

### Resolved Issues

This release has the following fixes:

-

### Known Issues

This release has the following known issues:

-

### Components

Cloud Native Runtimes v2.4.0 uses the following component versions:

<table class="component-versions">
    <tr>
        <th>Release</th>
        <th>Details</th>
    </tr>
    <tr>
        <td>Version</td>
        <td>2.4.0</td>
    </tr>
    <tr>
        <td>Release date</td>
        <td>TBD</td>
    </tr>
    <tr>
        <th>Component</th>
        <th>Version</th>
    </tr>
    <tr>
        <td>Knative Serving</td>
        <td>TBD</td>
    </tr>
    <tr>
        <td>Knative cert-manager Integration</td>
        <td>TBD</td>
    </tr>
    <tr>
        <td>Knative Serving Contour Integration</td>
        <td>TBD</td>
    </tr>
</table>