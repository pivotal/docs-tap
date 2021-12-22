# Tanzu Application Platform v0.4 (beta-4)

## <a id='overview'></a> Overview of Tanzu Application Platform

<p class="note warning">
<strong>Warning:</strong> Tanzu Application Platform is currently in beta (intended for evaluation and test purposes only).
</p>

VMware Tanzu Application Platform delivers a superior developer experience for enterprises building
and deploying cloud native applications on Kubernetes.
It enables application teams to get to production faster by automating source to production
pipelines.
It clearly defines the roles of developers and operators so they can work collaboratively and
integrate their efforts.

The Tanzu Application Platform includes elements that enable developers to quickly begin building
and testing applications regardless of their familiarity with Kubernetes.
Operations teams can create application scaffolding templates with built-in security and compliance
guardrails, making those considerations mostly invisible to developers.

Starting with the templates, developers turn source code into a container and get a URL to test
their app in minutes.
Once the container is built, updating it happens automatically every time there’s a new code commit
or dependency patch. And connecting to other applications and data, regardless of how they’re built
or what kind of infrastructure they run on, has never been easier, thanks to an internal API
management portal.

Customers can simplify workflows in both the inner loop and outer loop of Kubernetes-based app
development with Tanzu Application Platform while creating supply chains.

* **Inner Loop**:
    - The inner loop describes a developer’s development cycle of iterating on code.
    - Inner loop activities include coding, testing, and debugging before making a commit.
    - On cloud-native or Kubernetes platforms, developers in the inner loop often build container images and connect their apps to all necessary services and APIs to deploy them to a development environment.

* **Outer Loop**:
    - The outer loop describes how operators deploy apps to production and maintain them over time.
    - On a cloud-native platform, outer loop activities include building container images, adding container security, and configuring continuous integration and continuous delivery (CI/CD)  pipelines.
    - Outer loop activities are challenging in a Kubernetes-based development environment due to app delivery platforms being constructed from various third-party and open source components with numerous configuration options.

## <a id='profiles-and-packages'></a>  Installation profiles and profiles in Tanzu Application Platform v0.4

Tanzu Application Platform is available through pre-defined profiles or individual packages.

The following profiles are available in Tanzu Application Platform:

- **Dev:**
  Contains packages that drive the Inner Loop personal developer experience of building and
  iterating on applications.

- **Full:**
  This profile contains all of the Tanzu Application Platform packages.

## <a id='install'></a> About installing the Tanzu Application Platform v0.4 (beta-4)

To install the Tanzu Application Platform profiles, see [Installing Tanzu Application Platform](install-intro.md).

## <a id='telemetry-notice'></a> Notice of telemetry collection for Tanzu Application Platform

[//]: # (This following text came from legal. Do not edit it.)

Tanzu Application Platform participates in VMware’s Customer Experience Improvement Program (CEIP).
As part of CEIP, VMware collects technical information about your organization’s use of VMware products and services
in association with your organization’s VMware license keys.
For information about CEIP, see the [Trust & Assurance Center](http://www.vmware.com/trustvmware/ceip.html).
You may join or leave CEIP at any time.
The CEIP Standard Participation Level provides VMware with information to improve its products and services,
identify and fix problems, and advise you on how to best deploy and use VMware products.
For example, this information can enable a proactive product deployment discussion with your VMware account team or
VMware support team to help resolve your issues.
This information cannot directly identify any individual.

[//]: # (The text above came from legal. Do not edit it.)

You must acknowledge that you have read VMware’s CEIP policy before you can proceed with the installation.
For more information, see [Install a Tanzu Application Platform profile](install.md#install-profile) in
_Installing part II: profiles_.
To opt out of telemetry participation after installation, see [Opting out of telemetry collection](opting-out-telemetry.md).
