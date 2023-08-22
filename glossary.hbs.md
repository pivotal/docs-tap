# Glossary

## <a id="a"></a> A

<table>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
    <tr>
        <td>Accelerator Engine</td>
        <td></td>
    </tr>
    <tr>
        <td>Accelerator Server</td>
        <td></td>
    </tr>
        <tr>
        <td>AMR Observer</td>
        <td>AMR Observer is a set of managed controllers that watches for relevant updates on resources of interest. When relevant events are observed, a CloudEvent is generated and sent to AMR CloudEvent-Handler and relayed for storage in the Metadata Store.</td>
    </tr>
    <tr>
        <td>API Auto Registration</td>
        <td>API Auto Registration is a Tanzu Application Platform component that automates registering API specifications defined in a workload's configuration.</td>
    </tr>
    <tr>
        <td>API portal</td>
        <td>This component enables API consumers to find APIs they can use in their own applications. </td>
    </tr>
    <tr>
        <td>API Scoring and Validation</td>
        <td>This component focuses on scanning and validating OpenAPI specifications.
            It ensures your APIs are secure and robust by providing feedback and
            recommendations early on in the software development life cycle.</td>
    </tr>
    <tr>
        <td>Application Accelerator</td>
        <td></td>
    </tr>
    <tr>
        <td>Application Configuration Service</td>
        <td>This component provides a Kubernetes-native experience to enable the runtime configuration
            of existing Spring applications that were previously leveraged by using Spring Cloud Config
            Server.</td>
    </tr>
    <tr>
        <td>Application Live View</td>
        <td></td>
    </tr>
    <tr>
        <td>Application Live View connector</td>
        <td></td>
    </tr>
    <tr>
        <td>Application Live View server</td>
        <td></td>
    </tr>
    <tr>
        <td>Application Single Sign-On (AppSSO)</td>
        <td>This component provides APIs for curating and consuming a
            “Single Sign-On as a service” offering on Tanzu Application Platform.</td>
    </tr>
    <tr>
        <td>Artifact Metadata Repository (AMR)</td>
        <td></td>
    </tr>
</table>

## <a id="b"></a> B

<table>
    <tr>
        <th>Build Cluster</th>
        <th>A build cluster is a cluster with network access to your run clusters that controls the deployment on all the run clusters.
    </th>
    </tr>
    <tr>
        <td>Build profile</td>
        <td>This profile is intended for the transformation of source revisions to workload revisions. 
        Specifically, hosting workloads and Supply Chains.</td>
    </tr>
</table>

## <a id="c"></a> C

<table>
    <tr>
        <td>Cartographer Conventions</td>
        <td>Cartographer Conventions is a Tanzu Application Platform component that supports defining and applying conventions to pods. It applies these conventions to developer workloads as they are deployed to the platform.</td>
    </tr>
    <tr>
        <td>Cloud Native Runtimes</td>
        <td>Cloud Native Runtimes is a Tanzu Application Platform component that is a serverless application runtime for Kubernetes. It is based on Knative and runs on a single Kubernetes cluster.</td>
    </tr>
    <tr>
        <td>Convention Controller</td>
        <td>The convention controller provides the metadata to the convention server and executes the updates to a PodTemplateSpec in accordance with convention server's requests.</td>
    </tr>
</table>

## <a id="f"></a> F

<table>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
    <tr>
        <td>Full profile</td>
        <td>This profile contains all of the Tanzu Application Platform packages, 
        including the necessary defaults for the meta-package, or parent 
        Tanzu Application Platform package, subordinate packages, or individual child packages.</td>
    </tr>
</table>

## <a id="i"></a> I

<table>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
    <tr>
        <td>Iterate profile</td>
        <td>This profile is intended for iterative application development.</td>
    </tr>
</table>

## <a id="l"></a> L

<table>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
    <tr>
        <td>Local Source Proxy (LSP)</td>
        <td>This component serves as a proxy registry server with Open Container Initiative (OCI)
            compatibility. Its main purpose is to handle image push requests by forwarding them to an
            external registry server, which is configured through <code>tap-values.yaml</code>.</td>
    </tr>
</table>

## <a id="r"></a> R

<table>
    <tr>
        <th>Run Cluster</th>
        <th>Run clusters serve as your deployment environments. They can either be Tanzu Application Platform clusters, or regular Kubernetes clusters, but they must have kapp-controller and Contour installed.</th>
    </tr>
    <tr>
        <td>Run profile</td>
        <td>This profile is intended for the transformation of workload revisions to running pods. 
        Specifically, hosting deliveries and deliverables.</td>
    </tr>
</table>

## <a id="s"></a> S

<table>
    <tr>
        <th>Supply Chain Choreographer</th>
        <th>Supply Chain Choreographer is a Tanzu Application Platform component based on open source Cartographer. It allows App Operators to create pre-approved paths to production by integrating Kubernetes resources with the elements of their existing toolchains, for example, Jenkins.</th>
    </tr>
    <tr>
        <th>Supply Chain Security Tools - Policy</th>
        <th>Supply Chain Security Tools - Policy Controller is a Tanzu Application Platform component that helps you ensure that the container images in your registry are not tampered with.</th>
    </tr>
    <tr>
        <th>Supply Chain Security Tools - Scan</th>
        <th>Supply Chain Security Tools - Scan is a Tanzu Application Platform component that lets you build and deploy secure, trusted software that complies with your corporate security requirements by using scanning and gatekeeping capabilities.</th>
    </tr>
    <tr>
        <th>Supply Chain Security Tools - Store</th>
        <th>Supply Chain Security Tools - Store is a Tanzu Application Platform component that saves software bills of materials (SBoMs) to a database and allows you to query for image, source code, package, and vulnerability relationships.</th>
    </tr>
</table>

## <a id="t"></a> T

<table>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
    <tr>
        <td>Tanzu Application Platform Telemetry</td>
        <td>This is a set of objects that collect data about the usage of Tanzu Application Platform
        and send it back to VMware for product improvements.</td>
    </tr>
    <tr>
        <td>Tanzu Developer Portal</td>
        <td>This component enables developers to view apps and services running for an organization,
            including dependencies, relationships, technical documentation, and the service status.</td>
    </tr>
    <tr>
        <td>Tanzu Developer Portal Configurator</td>
        <td>This tool is used for customizing Tanzu Developer Portal with Backstage plug-ins.</td>
    </tr>
    <tr>
        <td>Tanzu Developer Portal Configurator Foundation</td>
        <td>This is the image that contains everything necessary to build a customized version of
            Tanzu Developer Portal.</td>
    </tr>
    <tr>
        <td>Tanzu Developer Tools for IntelliJ</td>
        <td>This extension for IntelliJ IDEA helps you develop with Tanzu Application Platform and
            enables you to rapidly iterate on your workloads on supported Kubernetes clusters that
            have Tanzu Application Platform installed.</td>
    </tr>
    <tr>
        <td>Tanzu Developer Tools for Visual Studio</td>
        <td>This extension for Visual Studio helps you develop with Tanzu Application Platform and
            enables you to rapidly iterate on your workloads on supported Kubernetes clusters that
            have Tanzu Application Platform installed.</td>
    </tr>
    <tr>
        <td>Tanzu Developer Tools for VS Code</td>
        <td>This extension for Visual Studio Code helps you develop with Tanzu Application Platform
            and enables you to rapidly iterate on your workloads on supported Kubernetes clusters that
            have Tanzu Application Platform installed.</td>
    </tr>
    <tr>
        <td>Tanzu GitOps Reference Implementation (RI)</td>
        <td>This is built upon Carvel, which shares the same packaging APIs as the Tanzu Application Platform. 
        Carvel packaging APIs support all the GitOps features and enables a native GitOps flow.</td>
    </tr>
</table>

## <a id="v"></a> V

<table>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
    <tr>
        <td>View profile</td>
        <td>This profile is intended for instances of applications related to 
        centralized developer experiences. Specifically, Tanzu Developer Portal and Metadata Store.</td>
    </tr>
</table>
