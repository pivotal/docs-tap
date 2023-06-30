# Supply chains on Tanzu Application Platform

This topic describes the key concepts you need to know about supply chains and
Continuous Integration/Continuous Delivery (CI/CD) on Tanzu Application Platform (commonly known as TAP).

Supply chains provide a way of codifying all of the steps of your path to production, more commonly
known as CI/CD.
CI/CD is a method to frequently deliver applications by introducing automation into the stages of
application development.
The main concepts attributed to CI/CD are continuous integration, continuous delivery, and continuous
deployment.

CI/CD is the method used by supply chains to deliver applications through automation.
Tanzu Application Platform supply chains allow you to use CI/CD and add any other steps necessary for
an application to reach production or a different environment, such as staging.

![A simple path to production: CI to Security Scan to Build Image to Image Scan to CAB Approval to Deployment.](../images/path-to-production-new.png)

## <a id="path-to-prod"></a>A path to production

A path to production allows users to create a unified access point for all of the tools required
for their applications to reach a customer-facing environment.
Instead of having four tools that are loosely coupled to each other, a path to production defines
all four tools in a single, unified layer of abstraction. The path to production can be automated and
repeatable between teams for applications at scale.

Typically tools cannot integrate with one another without scripting or webhooks.
Whereas with a path to production, there is a unified automation tool to codify all the interactions
between each of the tools.
Supply chains that are used to codify the path to production for an organization are configurable.
This allows their authors to add all of the steps of the path to production for their applications.

## <a id="avail-supply-chains"></a>Available Supply Chains

The Tanzu Application Platform provides three out of the box (OOTB) supply chains to
work with the Tanzu Application Platform components. They include:

-  OOTB Supply Chain Basic (default)
-  OOTB Supply Chain with Testing (optional)
-  OOTB Supply Chain with Testing+Scanning (optional)

## <a id="OOTB-basic-sc-default"></a>1: **OOTB Basic (default)**

The default **OOTB Basic** supply chain and its dependencies were installed on your cluster during the Tanzu Application Platform install.
The following table and diagrams provide descriptions for each of the supply chains and dependencies provided with the Tanzu Application Platform.

![The Source-to-URL chain: Watch Repo (Flux) to Build Image (TBS) to Apply Conventions to Deploy to Cluster (CNR).](../images/source-to-url-chain-new.png)

<table>
  <tr>
   <td><strong>Name</strong>
   </td>
   <td><strong>Package Name</strong>
   </td>
   <td><strong>Description</strong>
   </td>
   <td><strong>Dependencies</strong>
   </td>
  </tr>
  <tr>
   <td><strong>Out of the Box Basic (Default - Installed during Installing Part 2)</strong>
   </td>
   <td><code>ootb-supply-chain-basic.tanzu.vmware.com</code>
   </td>
   <td>This supply chain monitors a repository that is identified in the developer’s `workload.yaml` file. When any new commits are made to the application, the supply chain:
<ul>

<li>Creates a new image.

<li>Applies any predefined conventions.

<li>Deploys the application to the cluster.
</li>
</ul>
   </td>
   <td>
<ul>

<li>Flux/Source Controller

<li>Tanzu Build Service

<li>Convention Service

<li>Tekton

<li>Cloud Native Runtimes
<li>If using Service References:
   </li>
<ul>
<li>Service Bindings
<li>Services Toolkit
   </li>
   </ul>
</ul>
   </td>
  </tr>
</table>

## <a id="OOTB-testing"></a>2: **OOTB Testing**

**OOTB Testing** supply chain runs a Tekton pipeline within the supply chain.

![The Source-and-Test-to-URL chain: Watch Repo (Flux) to Test Code (Tekton) to Build Image (TBS) to Apply Conventions to Deploy to Cluster (CNR).](../images/source-and-test-to-url-chain-new.png)

<table>
  <tr>
   <td><strong>Name</strong>
   </td>
   <td><strong>Package Name</strong>
   </td>
   <td><strong>Description</strong>
   </td>
   <td><strong>Dependencies</strong>
   </td>
  </tr>
  <tr>
   <td><strong>Out of the Box Testing</strong>
   </td>
   <td><code>ootb-supply-chain-testing.tanzu.vmware.com</code>
   </td>
   <td>Out of the Box Testing contains all of the same elements as the Source to URL. It allows developers to specify a Tekton pipeline that runs as part of the CI step of the supply chain.
<ul>

<li>The application tests using the Tekton pipeline.

<li>A new image is created.

<li>Any predefined conventions are applied.

<li>The application is deployed to the cluster.
</li>
</ul>
   </td>
   <td>All of the Source to URL dependencies
<ul>

</ul>
   </td>
  </tr>
</table>

## <a id="OOTB-test-and-scan"></a>3: **OOTB Testing+Scanning**

**OOTB Testing+Scanning** supply chain includes integrations for secure scanning tools.

![The Source-and-Test-to-URL chain: Watch Repo (Flux) to Test Code (Tekton) to Build Image (TBS) to Apply Conventions to Deploy to Cluster (CNR).](../images/source-test-scan-to-url-new.png)

<table>
  <tr>
   <td><strong>Name</strong>
   </td>
   <td><strong>Package Name</strong>
   </td>
   <td><strong>Description</strong>
   </td>
   <td><strong>Dependencies</strong>
   </td>
  </tr>
  <tr>
   <td><strong>Out of the Box Testing and Scanning</strong>
   </td>
   <td><code>ootb-supply-chain-testing-scanning.tanzu.vmware.com</code>
   </td>
   <td>Out of the Box Testing and Scanning contains all of the same elements as the Out of the Box Testing supply chain, and it also includes integrations with the secure scanning components of Tanzu Application Platform.
<ul>

<li>The application is tested using the provided Tekton pipeline.
<li>(Optional) The application source code is scanned for vulnerabilities.  See [here](../scst-scan/scan-types.hbs.md#adding-source-scan-to-the-test-and-scan-supply-chain) to opt-in.

<li>A new image is created.
<li>The image is scanned for vulnerabilities.

<li>Any predefined conventions are applied.

<li>The application deploys to the cluster.
</li>
</ul>
   </td>
   <td>All of the Source to URL dependencies, and:
<ul>

<li>The secure scanning components included with Tanzu Application Platform
</li>
</ul>
   </td>
  </tr>
</table>

## Next steps

Apply what you have learned:

- [Add testing and scanning to your application](add-test-and-security.md)

Or learn about:

- [Vulnerability scanning and metadata storage for your supply chain](about-vulnerability-scan-store.md)
