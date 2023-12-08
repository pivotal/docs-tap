# Glossary

This topic gives you definitions of terms used in the Tanzu Application Platform documentation.

## <a id="a"></a> A

Terms beginning with "A".

<table>
  <thead>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>API Auto Registration</td>
        <td>This Tanzu Application Platform component automates registering API specifications defined
        in a workload's configuration.</td>
    </tr>
    <tr>
        <td>API portal</td>
        <td>This Tanzu Application Platform component enables API consumers to find APIs they can use
        in their own applications.</td>
    </tr>
    <tr>
        <td>API Scoring and Validation</td>
        <td>This Tanzu Application Platform component focuses on scanning and validating OpenAPI specifications.
        It ensures your APIs are secure and robust by providing feedback and recommendations early on
        in the software development life cycle.</td>
    </tr>
    <tr>
        <td>Application Accelerator</td>
        <td>This Tanzu Application Platform component provides a method to create and use application
        project templates that codify best practices and ensure that important configurations and
        structures are in place. Application developers use Application Accelerator to quickly
        bootstrap applications.</td>
    </tr>
    <tr>
        <td>Application Accelerator Engine</td>
        <td>The component that will perform the file transformations specified in an accelerator's `accelerator.yaml` file.</td>
    </tr>
    <tr>
        <td>Application Configuration Service</td>
        <td>This Tanzu Application Platform component provides a Kubernetes-native experience to
        enable the runtime configuration of existing Spring applications that were previously
        leveraged by using Spring Cloud Config Server.</td>
    </tr>
    <tr>
        <td>Application Live View</td>
        <td>A set of Tanzu Application Platform components that provide insight and troubleshooting
        capability that helps application developers and application operators look inside running
        applications.</td>
    </tr>
    <tr>
        <td>Application Live View APIServer</td>
        <td>This Tanzu Application Platform component is the part of Application Live View that
        generates a unique token when a user receives access validation to a pod.
        The Application Live View connector component verifies the token against the
        Application Live View APIServer before proxying the actuator data from the application.
        This ensures that the actuator data is secured and only the user who has valid access to view
        the live information for the pod can retrieve the data.</td>
    </tr>
    <tr>
        <td>Application Live View back end</td>
        <td>This Tanzu Application Platform component is the central server for Application Live View
        that contains a list of registered apps.
        It is responsible for proxying the request to fetch the actuator information related to the app.</td>
    </tr>
    <tr>
        <td>Application Live View connector</td>
        <td>This Tanzu Application Platform component is the part of Application Live View that is
        responsible for discovering the app pods running on the Kubernetes cluster and registering
        the instances to the Application Live View back end for it to be observed.
        The Application Live View connector is also responsible for proxying the actuator queries to
        the app pods running in the Kubernetes cluster.</td>
    </tr>
    <tr>
        <td>Application Live View convention server</td>
        <td>This Tanzu Application Platform component is the part of Application Live View that
        provides a webhook handler for the Tanzu convention controller.
        The webhook handler is registered with Tanzu convention controller. The webhook handler detects
        supply-chain workloads running a Spring Boot. Such workloads are annotated automatically to
        enable Application Live View to monitor them.</td>
    </tr>
    <tr>
        <td>Application Single Sign-On (AppSSO)</td>
        <td>This Tanzu Application Platform component provides APIs for curating and consuming a
            “Single Sign-On as a service” offering on Tanzu Application Platform.</td>
    </tr>
    <tr>
        <td>Aria Operations for Applications dashboard</td>
        <td>This Tanzu Application Platform component, powered by Aria Operations for Applications
        (formerly Tanzu Observability), helps you monitor the health of a cluster by showing
        whether the deployed Tanzu Application Platform components are behaving as expected.</td>
    </tr>
    <tr>
        <td>Artifact Metadata Repository (AMR)</td>
        <td>AMR Observer is a set of managed controllers that watches for relevant updates
        on resources of interest. When relevant events are observed, a CloudEvent is
        generated and sent to AMR CloudEvent Handler.</td>
    </tr>
        <tr>
        <td>Artifact Metadata Repository (AMR) CloudEvent Handler</td>
        <td>AMR CloudEvent Handler receives CloudEvents and stores relevant information in 
        the Artifact Metadata Repository or Metadata Store.</td>
    </tr>
    <tr>
        <td>Artifact Metadata Repository (AMR) Observer</td>
        <td>A set of managed controllers that watches for relevant updates on
        resources of interest. When relevant events are observed, a CloudEvent is generated and sent
        to AMR CloudEvent Handler and relayed for storage in the metadata store.</td>
    </tr>
    <tr>
        <td>AWS Services</td>
        <td>This Tanzu Application Platform component provides integration with AWS. Through
        integration with Crossplane and Services Toolkit, you can offer services from AWS to apps
        teams to consume with only minimal setup and configuration required from ops teams.</td>
    </tr>
  </tbody>
</table>

## <a id="b"></a> B

Terms beginning with "B".

<table>
  <thead>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Bitnami Services</td>
        <td>This Tanzu Application Platform component provides a set of services
        backed by corresponding Bitnami Helm Charts. Through integration with Crossplane and
        Services Toolkit, these Bitnami Services are immediately ready for apps teams to consume,
        with no additional setup or configuration required from ops teams.</td>
    </tr>
    <tr>
        <td>Build Cluster</td>
        <td>A cluster with network access to your run clusters that controls the deployment on all
        the run clusters.</td>
    </tr>
    <tr>
        <td>Build profile</td>
        <td>This Tanzu Application Platform profile is intended for the transformation of source
        revisions to workload revisions. Specifically, hosting workloads and Supply Chains.</td>
    </tr>
  </tbody>
</table>

## <a id="c"></a> C

Terms beginning with "C".

<table>
  <thead>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Cartographer Conventions</td>
        <td>This Tanzu Application Platform component supports defining and applying conventions to pods.
        It applies these conventions to developer workloads as they are deployed to the platform.</td>
    </tr>
    <tr>
        <td>Claim</td>
        <td>A mechanism in which requests for service instances can be declared and fulfilled
        without requiring detailed knowledge of the service instances themselves.</td>
    </tr>
    <tr>
        <td>Claimable service instance</td>
        <td>Any service instance that you can claim using a resource claim from a namespace.</td>
    </tr>
    <tr>
        <td>Class</td>
        <td>The common name for a <a href="#s">service instance class</a>.</td>
    </tr>
    <tr>
        <td>Class claim</td>
        <td>A type of claim that references a class from which a service instance is either selected
        (pool-based) or provisioned (provisioner-based).</td>
    </tr>
    <tr>
        <td>Cloud Native Runtimes</td>
        <td>This Tanzu Application Platform component that is a serverless application runtime for Kubernetes. It is based on Knative and runs on a single Kubernetes cluster.</td>
    </tr>
        <tr>
        <td>Component</td>
        <td>A distinct unit or module within Tanzu Application Platform that performs a specific
        function or set of functions. Components can be software-based, such as services, APIs, or
        libraries, or they can be configuration-based, such as profiles or settings.
        Each component is interoperable and plays a role in the overall functionality and extensibility
        of Tanzu Application Platform.</td>
    </tr>
    <tr>
        <td>Convention controller</td>
        <td>The convention controller provides the metadata to the convention server and executes the
        updates to a PodTemplateSpec in accordance with convention server's requests.</td>
    </tr>
    <tr>
        <td>Convention server</td>
        <td>The convention server receives and evaluates metadata associated with a workload and requests
        updates to the PodTemplateSpec associated with that workload.
        You can have one or more convention servers for a single controller instance.</td>
    </tr>
  </tbody>
</table>

## <a id="d"></a> D

Terms beginning with "D".

<table>
  <thead>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Developer Conventions</td>
        <td>This Tanzu Application Platform component enables you to configure your workloads to support
        live updates and debug operations.</td>
    </tr>
    <tr>
        <td>Dynamic provisioning</td>
        <td>A capability of Services Toolkit in which class claims that reference provisioner-based
        classes are fulfilled automatically through the provisioning of new service instances.</td>
    </tr>
  </tbody>
</table>

## <a id="f"></a> F

Terms beginning with "F".

<table>
  <thead>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Full profile</td>
        <td>This profile contains most Tanzu Application Platform packages.
        This includes the necessary defaults for the meta-package, or parent
        Tanzu Application Platform package, subordinate packages, or individual child packages.</td>
    </tr>
  </tbody>
</table>

## <a id="i"></a> I

Terms beginning with "I".

<table>
  <thead>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Iterate cluster</td>
        <td>A cluster for “inner loop” development iteration. Developers connect to the
        Iterate cluster by using their IDE to rapidly iterate on new software features. </td>
    </tr>
    <tr>
        <td>Iterate profile</td>
        <td>This Tanzu Application Platform profile is intended for iterative application development.</td>
    </tr>
  </tbody>
</table>

## <a id="l"></a> L

Terms beginning with "L".

<table>
  <thead>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Local Source Proxy (LSP)</td>
        <td>This Tanzu Application Platform component serves as a proxy registry server with
        Open Container Initiative (OCI) compatibility.
        Its main purpose is to handle image push requests by forwarding them to an
        external registry server, which is configured through <code>tap-values.yaml</code>.</td>
    </tr>
  </tbody>
</table>

## <a id="l"></a> M

Terms beginning with "M".

<table>
  <thead>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Multicluster</td>
        <td>A setup or architecture where multiple Kubernetes clusters are used either for geographical
        distribution, high availability, scalability, or separation of workloads.
        In Tanzu Application Platform, multicluster capabilities ensure that you can deploy, manage,
        and operate applications and platform services across these multiple clusters seamlessly.</td>
    </tr>
  </tbody>
</table>

## <a id="l"></a> N

Terms beginning with "N".

<table>
  <thead>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Namespace Provisioner</td>
        <td>This Tanzu Application Platform component provides an automated way for you to provision
        namespaces with the resources and namespace-level privileges required for your workloads to
        function as intended in Tanzu Application Platform.</td>
    </tr>
  </tbody>
</table>

## <a id="p"></a> P

Terms beginning with "P".

<table>
  <thead>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Package</td>
        <td>A package contains the resources needed to install the components needed by the cluster.</td>
    </tr>
        <tr>
        <td>Package Repository</td>
        <td>A centralized store or registry containing packages that users can access, retrieve,
        and deploy. A package repository ensures that you have a consistent and curated set of
        software components, which are versioned and that you can fetch to deploy on your
        Tanzu Application Platform installation.</td>
    </tr>
    <tr>
        <td>Pool-based class</td>
        <td>A type of service instance class for which claims are fulfilled by selecting a
        service instance from a pool.</td>
    </tr>
    <tr>
        <td>Profile</td>
        <td>A predefined group of Tanzu Application Platform packages that you can deploy.
        You can deploy the full profile, which includes most Tanzu Application Platform packages,
        or you can deploy a profile that includes a subset of packages intended to suit a certain
        use case by deploying the iterate, build, run, or view profiles.
        The profiles allow Tanzu Application Platform to scale across an organization's multicluster,
        multi-cloud, or hybrid cloud infrastructure.</td>
    </tr>
    <tr>
        <td>Provisioned service</td>
        <td>Any service resource that defines a <code>.status.binding.name</code> that points to a
        secret in the same namespace that contains credentials and connectivity information for the
        resource.</td>
    </tr>
    <tr>
        <td>Provisioner-based class</td>
        <td>A type of service instance class for which claims are fulfilled by provisioning new
        service instances.</td>
    </tr>
</table>

## <a id="r"></a> R

Terms beginning with "R".

<table>
  <thead>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Resource claim</td>
        <td>A type of claim that references a specific service instance.</td>
    </tr>
    <tr>
        <td>Run Cluster</td>
        <td>The clusters that serve as your deployment environments. They can either be
        Tanzu Application Platform clusters, or regular Kubernetes clusters, but they must have
        kapp-controller and Contour installed.</td>
    </tr>
    <tr>
        <td>Run profile</td>
        <td>This Tanzu Application Platform profile is intended for the transformation of workload
        revisions to running pods. Specifically, hosting deliveries and deliverables.</td>
    </tr>
  </tbody>
</table>

## <a id="s"></a> S

Terms beginning with "S".

<table>
  <thead>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Service</td>
        <td>A broad, high-level term that describes something used in either the development of,
        or running of application workloads. It is often, but not exclusively, synonymous with the
        concept of a backing service as defined by the Twelve Factor App.</td>
    </tr>
    <tr>
        <td>Service binding</td>
        <td>A mechanism in which service instance credentials and other related connectivity
        information are automatically communicated to application workloads.</td>
    </tr>
    <tr>
        <td>Service Bindings</td>
        <td>This Tanzu Application Platform component specifies a Kubernetes-wide specification for
        communicating service secrets to workloads in an automated way. Service Bindings provides a
        proprietary package of the Service Binding for Kubernetes open source project.</td>
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
        that together provide the functions for a particular service.<br><br>
        One of the service resources that make up an instance must either adhere to the definition of
        provisioned service, or be a secret conforming to the service binding specification for Kubernetes.
        This guarantees that you can claim a service and subsequently bind service instances to
        application workloads.<br><br>
        You make service instances discoverable through service instance classes.
        </td>
    </tr>
    <tr>
        <td>Service instance class</td>
        <td>A service instance class is more commonly called a class.
        Service instance classes provide a way to describe categories of service instances.
        They enable service instances belonging to the class to be discovered.
        They come in one of two varieties: pool-based or provisioner-based.</td>
    </tr>
        <tr>
        <td>Service Registry</td>
        <td>This Tanzu Application Platform component provides on-demand Eureka servers for your Tanzu Application Platform
        (commonly known as TAP) clusters. With Service Registry, you can create Eureka servers in
        your namespaces and bind Spring Boot workloads to them.</td>
    </tr>
    <tr>
        <td>Service resource</td>
        <td>A Kubernetes resource that provides some of the functions related to
        a Service.</td>
    </tr>
    <tr>
        <td>Service resource life cycle API</td>
        <td>Any Kubernetes API that you can use to manage the life cycle&mdash;create, read, update,
        and delete (CRUD)&mdash;of a service resource.</td>
    </tr>
    <tr>
        <td>Services Toolkit</td>
        <td>This Tanzu Application Platform component provides backing for service
        capabilities. This includes the integration of an extensive list of cloud-based and on-prem services,
        through to the offering and discovery of those services, and finally to the claiming and binding
        of service instances to application workloads.</td>
    </tr>
    <tr>
        <td>Supply Chain Choreographer</td>
        <td>This Tanzu Application Platform component is based on open source Cartographer.
        It allows App Operators to create pre-approved paths to production by integrating Kubernetes
        resources with the elements of their existing toolchains, for example, Jenkins.</td>
    </tr>
    <tr>
        <td>Supply Chain Security Tools - Policy</td>
        <td>This Tanzu Application Platform component helps you ensure that the container images in
        your registry are not tampered with.</td>
    </tr>
    <tr>
        <td>Supply Chain Security Tools - Scan</td>
        <td>This Tanzu Application Platform component lets you build and deploy secure, trusted software
        that complies with your corporate security requirements by using scanning and gatekeeping
        capabilities.</td>
    </tr>
    <tr>
        <td>Supply Chain Security Tools - Store</td>
        <td>This Tanzu Application Platform component saves software bills of materials (SBoMs) to a
        database and allows you to query for image, source code, package, and vulnerability relationships.</td>
    </tr>
  </tbody>
</table>

## <a id="t"></a> T

Terms beginning with "T".

<table>
  <thead>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Tanzu Application Platform Telemetry</td>
        <td>This is a set of objects that collect data about the use of Tanzu Application Platform
        and send it back to VMware for product improvements.</td>
    </tr>
    <tr>
        <td>Tanzu Build Service</td>
        <td>This Tanzu Application Platform component enables you to automate container creation,
        management, and governance at an enterprise scale. Tanzu Build Service uses the open-source
        Cloud Native Buildpacks project to turn application source code into container images.</td>
    </tr>
    <tr>
        <td>Tanzu Buildpacks</td>
        <td>Buildpacks provide framework and runtime support for applications. Use Buildpacks to
        determine what dependencies are required for your applications to communicate with bound services.
        Tanzu Buildpacks provides a proprietary package of the Paketo Buildpacks open-source project.</td>
    </tr>
    <tr>
        <td>Tanzu CLI</td>
        <td>A command-line tool that connects you to Tanzu.</td>
    </tr>
     <tr>
        <td>Tanzu CLI plug-in</td>
        <td>Tanzu CLI has a pluggable architecture. Plug-ins extend the Tanzu CLI core with additional
        CLI commands. Each plug-in is an executable binary that packages a group of CLI commands.
    </tr>
     <tr>
        <td>Tanzu CLI plug-in group</td>
        <td>Tanzu CLI commands are organized into command groups. For each Tanzu Application Platform
        version, there is a Tanzu CLI plug-in group.</td>
    </tr>
    <tr>
        <td>Tanzu Developer Portal</td>
        <td>This Tanzu Application Platform component enables developers to view apps and services
        running for an organization, including dependencies, relationships, technical documentation,
        and the service status.</td>
    </tr>
    <tr>
        <td>Tanzu Developer Portal Configurator</td>
        <td>This tool is used for customizing Tanzu Developer Portal with Backstage plug-ins.</td>
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
        <td>This is built upon Carvel, which shares the same packaging APIs as Tanzu Application Platform.
        Carvel packaging APIs support all the GitOps features and enables a native GitOps flow.</td>
    </tr>
    <tr>
        <td>Tanzu Service CLI plug-in</td>
        <td>A plug-in for the Tanzu CLI used by application operators and application developers to
        create claims for service instances.</td>
    </tr>
  </td>
</table>

## <a id="u"></a> U

Terms beginning with "U".

<table>
  <thead>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Unmanaged service</td>
        <td>The services available in the Bitnami Services package where the resulting service instances
        run on the cluster, that is, they are not a managed service running in the cloud.</td>
    </tr>
  </tbody>
</table>

## <a id="v"></a> V

Terms beginning with "V".

<table>
  <thead>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>VMware Tanzu Application Catalog</td>
        <td>A customizable selection of trusted, pre-packaged application components that are
        continuously maintained and verifiably tested for use in production environments.</td>
    </tr>
    <tr>
        <td>View Cluster</td>
        <td>The cluster that runs the web applications for Tanzu Application Platform.</td>
    </tr>
    <tr>
        <td>View profile</td>
        <td>This Tanzu Application Platform profile is intended for instances of applications related
        to centralized developer experiences. Specifically, Tanzu Developer Portal and Metadata Store.</td>
    </tr>
  </tbody>
</table>

## <a id="w"></a> W

Terms beginning with "W".

<table>
  <thead>
    <tr>
        <th>Term</th>
        <th>Definition</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Workload cluster</td>
        <td>A cluster that has developer-created applications running on it.
        A workload cluster is applicable within the context of Service API Projection and
        Service Resource Replication.</td>
    </tr>
  </tbody>
</table>
