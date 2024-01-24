# Version matrix for Bitnami Services

This topic provides you with a version matrix for Tanzu Application Platform (commonly known as TAP),
the Bitnami Services package, and its open source components.

This includes:

- Tanzu Application Platform
- The Bitnami Services package (`bitnami.services.tanzu.vmware.com`)
- The default Helm chart versions for each of the Bitnami services. You can overwrite Helm chart
  versions by configuring package values.

> **Note** Tanzu Application Platform patch releases are only added to the table when there
> is a change to one or more of the other versions in the table. Otherwise, the corresponding
> versions remain the same for each Tanzu Application Platform patch release.

<table>
  <thead>
    <tr>
        <th>Tanzu Application Platform version</th>
        <th>Bitnami Services package version</th>
        <th>MySQL Chart version</th>
        <th>PostgreSQL Chart version</th>
        <th>RabbitMQ Chart version</th>
        <th>Redis Chart version</th>
        <th>MongoDB Chart version</th>
        <th>Kafka Chart version</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>1.5.0</td>
        <td>0.1.0</td>
        <td>9.5.0</td>
        <td>12.2.0</td>
        <td>11.10.0</td>
        <td>17.8.0</td>
        <td>not included</td>
        <td>not included</td>
    </tr>
    <tr>
        <td>1.6.0</td>
        <td>0.2.0</td>
        <td>9.5.0</td>
        <td>12.2.0</td>
        <td>11.10.0</td>
        <td>17.8.0</td>
        <td>13.13.1</td>
        <td>22.0.0</td>
    </tr>
    <tr>
        <td>1.7.0</td>
        <td>0.3.1</td>
        <td>9.5.0</td>
        <td>12.2.0</td>
        <td>11.10.0</td>
        <td>17.8.0</td>
        <td>13.13.1</td>
        <td>22.0.0</td>
    </tr>
    <tr>
        <td>1.8.0</td>
        <td>0.4.0</td>
        <td>9.5.0</td>
        <td>12.2.0</td>
        <td>11.10.0</td>
        <td>17.8.0</td>
        <td>13.13.1</td>
        <td>22.0.0</td>
    </tr>
  </tbody>
</table>
