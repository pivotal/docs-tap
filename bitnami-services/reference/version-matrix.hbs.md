# Version matrix for Bitnami Services

This topic provides you with a version matrix for Tanzu Application Platform (commonly known as TAP),
the Bitnami Services package, and its open source components.

This includes:

- The Bitnami Services package (`bitnami.services.tanzu.vmware.com`)
- The default Helm chart versions for each of the Bitnami services. You can overwrite Helm chart
  versions by configuring package values.

The following table provides component versions for the Bitnami Services package in Tanzu Application Platform
v{{ vars.url_version }}.
To view this information for another Tanzu Application Platform version, select the version from the drop-down menu at
the top of this page.

<!-- add patch updates in a new column -->

<table>
  <thead>
    <tr>
      <th>Component</th>
      <th>Version</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Bitnami Services package</td>
      <td>0.4.0</td>
    </tr>
    <tr>
      <td>MySQL Chart</td>
      <td>9.5.0</td>
    </tr>
    <tr>
      <td>PostgreSQL Chart</td>
      <td>12.2.0</td>
    </tr>
    <tr>
      <td>RabbitMQ Chart</td>
      <td>11.10.0</td>
    </tr>
    <tr>
      <td>Redis Chart</td>
      <td>17.8.0</td>
    </tr>
    <tr>
      <td>MongoDB Chart</td>
      <td>13.13.1</td>
    </tr>
    <tr>
      <td>Kafka Chart</td>
      <td>22.0.0</td>
    </tr>
  </tbody>
</table>

> **Note** Tanzu Application Platform patch releases are only added to the table when there
> is a change to one or more of the other versions in the table. Otherwise, the corresponding
> versions remain the same for each Tanzu Application Platform patch release.
