# Artifact Metadata Repository architecture

This topic gives you an overview of the Artifact Metadata Repository (AMR) architecture.

![Diagram of Architecture for AMR Interaction shows the kubernetes resources that are part of the TAP resource in yellow](../images/amr-arch.png)

## <a id='amr-observer'></a> AMR Observer

The full, build, and run clusters include AMR Observer.
AMR Observer communicates with the Kubernetes API Server to obtain the cluster's 
location ID, which is the globally unique identifier (GUID) of the `kube-system` 
namespace. 
After AMR Observer retrieves the location ID, AMR Observer emits a CloudEvent to 
AMR CloudEvent Handler, including any operator-defined metadata. 
This CloudEvent registers the location, and subsequent CloudEvents from that 
cluster use the same location reference in the source field. 
This mechanism helps AMR track artifacts with their associated location.

### <a id='watched-resources'></a> Watched resources

AMR Observer consists of managed controllers that watch resources. In Tanzu
Application Platform v{{ vars.url_version }}, AMR Observer watches for:

<table>
  <thead>
    <tr>
      <th>AMR Observer Supported Resources</th>
      <th>-</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>ImageVulnerabilityScans</td>
      <td>app-scanning.apps.tanzu.vmware.com/v1alpha1</td>
    </tr>
    <tr>
      <td>Pods</td>
      <td>v1</td>
    </tr>
    <tr>
      <td>GitRepository</td>
      <td>source.toolkit.fluxcd.io/v1beta2</td>
    </tr>
    <tr>
      <td>OCIRepository</td>
      <td>source.toolkit.fluxcd.io/v1beta2</td>
    </tr>
    <tr>
      <td>ImageRepository</td>
      <td>source.apps.tanzu.vmware.com/v1alpha1</td>
    </tr>
    <tr>
      <td>MavenArtifacts</td>
      <td>source.apps.tanzu.vmware.com/v1alpha1</td>
    </tr>
    <tr>
      <td>Build</td>
      <td>kpack.io/v1alpha2</td>
    </tr>
    <tr>
      <td>TaskRun</td>
      <td>tekton.dev/v1beta1</td>
    </tr>
  </tbody>
</table>

#### <a id='imagevulnerabilityscans'></a> ImageVulnerabilityScans

AMR Observer watches the `ImageVulnerabilityScan` Custom Resources for
completed scans. When a scan finishes, AMR Observer uses the 
`registry secret` and the location information from the `ImageVulnerabilityScan` 
Custom Resources to fetch the SBOM report. 
After obtaining the Software Bill of Materials (SBOM) report, AMR Observer 
wraps it in a CloudEvent and emits it to the AMR CloudEvent Handler. The AMR 
CloudEvent Handler persists this event in the Metadata Store.

#### <a id='data-models'></a> Data Models

For more information about the data that AMR stores from the observed resources, 
see [Artifact Metadata Repository (AMR) data model and concepts](./data-model-and-concepts.hbs.md)
