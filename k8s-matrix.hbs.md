# Kubernetes version support for Tanzu Application Platform

The following is a matrix table providing details of the compatible Kubernetes 
cluster versions for Tanzu Application Platform v{{ vars.url_version }}.

<table>
<thead>
  <tr>
    <th>Kubernetes Cluster</th>
    <th>Support Information</th>
    <th>Notes</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>Kubernetes</td>
    <td>v1.23, v1.24, v1.25</td>
    <td></td>
  </tr>
  <tr>
    <td>VMware Tanzu Kubernetes Grid</td>
    <td>v1.6</td>
    <td></td>
  </tr>
  <tr>
    <td>Tanzu Kubernetes releases (vSphere with Tanzu)</td>
    <td>TKr v1.25.7 for vSphere v8.x, <br>TKr v1.24.9 for vSphere v8.x,<br>TKr v1.23.8 for vSphere v7.x (Photon)</td>
    <td>Support for TKr v1.25.7 begins with TAP Tanzu Application Platform v1.4.8<br><br>Support for TKr v1.24.9 begins with TAP Tanzu Application Platform v1.4.4<br></td>
  </tr>
  <tr>
    <td>OpenShift</td>
    <td>v4.10, v4.11</td>
    <td>OpenShift v4.10 reached its end of life on September 10, 2023, which means it no longer receives support for Tanzu Application Platform v1.4.9, and v1.4.10</td>
  </tr>
  <tr>
    <td>Azure Kubernetes Service</td>
    <td>Supported</td>
    <td></td>
  </tr>
  <tr>
    <td>Elastic Kubernetes Service</td>
    <td>Supported</td>
    <td></td>
  </tr>
  <tr>
    <td>Google Kubernetes Engine</td>
    <td>Supported</td>
    <td></td>
  </tr>
</tbody>
</table>
