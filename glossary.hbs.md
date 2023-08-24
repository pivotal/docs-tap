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
        <td>Application Live View is a Tanzu Application Platform component that provides insight and
        troubleshooting functionality to help application developers and application operators look
        inside running applications.</td>
    </tr>
    <tr>
        <td>Application Live View APIServer</td>
        <td>Application Live View APIServer generates a unique token when a user receives access
        validation to a pod. The Application Live View connector component verifies the token against
        the Application Live View APIServer before proxying the actuator data from the application.
        This ensures that the actuator data is secured and only the user who has valid access to view
        the live information for the pod can retrieve the data.</td>
    </tr>
    <tr>
      <td>Application Live View back end</td>
      <td></td>
    </tr>
    <tr>
        <td>Application Live View connector</td>
        <td>This component is responsible for discovering the app pods running on the Kubernetes
        cluster and registering the instances to the Application Live View server for it to be observed.
        The Application Live View connector is also responsible for proxying the actuator queries to
        the app pods running in the Kubernetes cluster.</td>
    </tr>
    <tr>
        <td>Application Live View convention server</td>
        <td>This component provides a webhook handler for the Tanzu convention controller.
        The webhook handler is registered with Tanzu convention controller. The webhook handler detects
        supply-chain workloads running a Spring Boot. Such workloads are annotated automatically to
        enable Application Live View to monitor them.</td>
    </tr>
    <tr>
        <td>Application Live View server</td>
        <td>Application Live View server is the central server component for Application Live View
        that contains a list of registered apps.
        It is responsible for proxying the request to fetch the actuator information related to the app.</td>
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
        <th>Term</th>
        <th>Definition</th>
    </tr>
    <tr>
        <td>Bitnami Services</td>
        <td>Bitnami Services is a Tanzu Application Platform component that provides a set of services for
        backed by corresponding Bitnami Helm Charts. Through integration with Crossplane and Services Toolkit,
        these Bitnami Services are immediately ready for apps teams to consume, with no additional setup or
        configuration required from ops teams.</td>
    </tr>
    <tr>
        <td>Build Cluster</td>
        <td>A Build Cluster is a cluster with network access to your run clusters that controls
        the deployment on all the run clusters.</td>
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
        <td>Claim</td>
        <td>A claim is a mechanism in which requests for service instances can be declared and fulfilled
        without requiring detailed knowledge of the service instances themselves.</td>
    </tr>
    <tr>
        <td>Claimable service instance</td>
        <td>A claimable service instance is any service instance that you can claim using a resource claim
        from a namespace.</td>
    </tr>
    <tr>
        <td>Class</td>
        <td></td>
    </tr>
    <tr>
        <td>Class claim</td>
        <td>A class claim refers to a class from which a service instance is either selected (pool-based)
        or provisioned (provisioner-based).</td>
    </tr>
    <tr>
        <td>Cloud Native Runtimes</td>
        <td>Cloud Native Runtimes is a Tanzu Application Platform component that is a serverless application runtime for Kubernetes. It is based on Knative and runs on a single Kubernetes cluster.</td>
    </tr>
    <tr>
        <td>Convention controller</td>
        <td>The convention controller provides the metadata to the convention server and executes the updates to a PodTemplateSpec in accordance with convention server's requests.</td>
    </tr>
    <tr>
        <td>Convention server</td>
        <td>The convention server receives and evaluates metadata associated with a workload and requests
        updates to the PodTemplateSpec associated with that workload.
        You can have one or more convention servers for a single controller instance.</td>
    </tr>    
</table>

## <a id="d"></a> D

<table>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
    <tr>
        <td>Dynamic provisioning</td>
        <td>Dynamic provisioning is a capability of Services Toolkit in which class claims that refer
        to provisioner-based classes are fulfilled automatically through the provisioning of new service
        instances.</td>
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
        <td>Iterate Cluster</td>
        <td>A Iterate Cluster is for “inner loop” development iteration. Developers connect to the
        Iterate Cluster by using their IDE to rapidly iterate on new software features. </td>
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

## <a id="m"></a> M

<table>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
    <tr>
        <td>Multicluster</td>
        <td></td>
    </tr>
</table>

## <a id="p"></a> P

<table>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
    <tr>
        <td>Package</td>
        <td></td>
    </tr>
    <tr>
        <td>Pool-based class</td>
        <td></td>
    </tr>
    <tr>
        <td>Profile</td>
        <td></td>
    </tr>
    <tr>
        <td>Provisioned service</td>
        <td>A provisioned service is any service resource that defines a <code>.status.binding.name</code>
        which points to a secret in the same namespace that contains credentials and connectivity
        information for the resource.</td>
    </tr>
    <tr>
        <td>Provisioner-based class</td>
        <td></td>
    </tr>
</table>

## <a id="r"></a> R

<table>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
    <tr>
        <td>Resource claim</td>
        <td>A resource claim refers to a specific service instance.</td>
    </tr>
    <tr>
        <td>Run Cluster</td>
        <td>Run Clusters serve as your deployment environments. They can either be Tanzu Application Platform clusters, or regular Kubernetes clusters, but they must have kapp-controller and Contour installed.</td>
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
        <th>Term</th>
        <th>Definition</th>
    </tr>
    <tr>
        <td>Service</td>
        <td>Service is broad, high-level term that describes something used in either the development of,
        or running of application workloads. It is often, but not exclusively, synonymous with the concept
        of a backing service as defined by the Twelve Factor App.</td>
    </tr>
    <tr>
        <td>Service binding</td>
        <td>A service binding is a mechanism in which service instance credentials and other related
        connectivity information are automatically communicated to application workloads.</td>
    </tr>
    <tr>
        <td>Service cluster</td>
        <td>A service cluster is applicable within the context of Service API Projection and
        Service Resource Replication.
        It is a Kubernetes cluster that has Service Resource Lifecycle APIs installed and a corresponding
        controller managing their life cycle.</td>
    </tr>
    <tr>
        <td>Service instance</td>
        <td>A service instance is an abstraction over one, or a group, of interrelated service resources
        that together provide the functions for a particular service.

        One of the service resources that make up an instance must either adhere to the definition of
        provisioned service, or be a secret conforming to the service binding specification for Kubernetes.
        This guarantees that you can claim a service and subsequently bind service instances to
        application workloads.

        You make service instances discoverable through service instance classes.</td>
    </tr>
    <tr>
        <td>Service instance class</td>
        <td></td>
    </tr>
    <tr>
        <td>Service resource</td>
        <td>A service resource is a Kubernetes resource that provides some of the functions related to
        a Service.</td>
    </tr>
    <tr>
        <td>Service resource life cycle API</td>
        <td>A service resource life cycle API is any Kubernetes API that you can use to manage the
        life cycle&mdash;create, read, update and delete (CRUD)&mdash;of a service resource.</td>
    </tr>
    <tr>
        <td>Services Toolkit</td>
        <td>Services Toolkit is a Tanzu Application Platform component that provides backing for service
        capabilities. This includes the integration of an extensive list of cloud-based and on-prem services,
        through to the offering and discovery of those services, and finally to the claiming and binding
        of service instances to application workloads.</td>
    </tr>
    <tr>
        <td>Supply Chain Choreographer</td>
        <td>Supply Chain Choreographer is a Tanzu Application Platform component based on open source Cartographer. It allows App Operators to create pre-approved paths to production by integrating Kubernetes resources with the elements of their existing toolchains, for example, Jenkins.</td>
    </tr>
    <tr>
        <td>Supply Chain Security Tools - Policy</td>
        <td>Supply Chain Security Tools - Policy Controller is a Tanzu Application Platform component that helps you ensure that the container images in your registry are not tampered with.</td>
    </tr>
    <tr>
        <td>Supply Chain Security Tools - Scan</td>
        <td>Supply Chain Security Tools - Scan is a Tanzu Application Platform component that lets you build and deploy secure, trusted software that complies with your corporate security requirements by using scanning and gatekeeping capabilities.</td>
    </tr>
    <tr>
        <td>Supply Chain Security Tools - Store</td>
        <td>Supply Chain Security Tools - Store is a Tanzu Application Platform component that saves software bills of materials (SBoMs) to a database and allows you to query for image, source code, package, and vulnerability relationships.</td>
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
    <tr>
        <td>Tanzu Service CLI plug-in</td>
        <td>A plug-in for the Tanzu CLI used by application operators and application developers to
        create claims for service instances.</td>
    </tr>
</table>

## <a id="u"></a> U

<table>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
    <tr>
        <td>Unmanaged service</td>
        <td>The services available in the Bitnami Services package where the resulting service instances
        run on the cluster, that is, they are not a managed service running in the cloud.</td>
    </tr>
</table>

## <a id="v"></a> V

<table>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
    <tr>
        <td>VMware Application Catalog</td>
        <td>VMware Application Catalog is a customizable selection of trusted, pre-packaged
        application components that are continuously maintained and verifiably tested for use in
        production environments.</td>
    </tr>
    <tr>
        <td>View Cluster</td>
        <td>A View Cluster runs the web applications for Tanzu Application Platform.</td>
    </tr>
    <tr>
        <td>View profile</td>
        <td>This profile is intended for instances of applications related to
        centralized developer experiences. Specifically, Tanzu Developer Portal and Metadata Store.</td>
    </tr>
</table>

## <a id="w"></a> W

<table>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
    <tr>
        <td>Workload cluster</td>
        <td>A workload cluster is applicable within the context of Service API Projection and
        Service Resource Replication.
        It is a Kubernetes cluster that has developer-created applications running on it.</td>
    </tr>
</table>
