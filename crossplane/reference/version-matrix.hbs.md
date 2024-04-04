# Version matrix for Crossplane

This topic provides you with a version matrix for Tanzu Application Platform (commonly known as TAP),
the Crossplane package, and its open source components.

This includes:

- The Crossplane package (`crossplane.tanzu.vmware.com`)
- Universal Crossplane (UXP)
- The version of Upbound Crossplane used in UXP
- provider-helm
- provider-kubernetes

The following table provides component versions for the Crossplane package in Tanzu Application Platform
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
      <td>Crossplane package</td>
      <td>0.5.0</td>
    </tr>
    <tr>
      <td>UXP</td>
      <td>1.15.0-up.1</td>
    </tr>
    <tr>
      <td>Upbound Crossplane</td>
      <td>1.15.0-up.1</td>
    </tr>
    <tr>
      <td>provider-helm</td>
      <td>0.15.0</td>
    </tr>
    <tr>
      <td>provider-kubernetes</td>
      <td>0.12.1</td>
    </tr>
  </tbody>
</table>

> **Note** Tanzu Application Platform patch releases are only added to the table when there
> is a change to one or more of the other versions in the table. Otherwise, the corresponding
> versions remain the same for each Tanzu Application Platform patch release.
