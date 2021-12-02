# Tanzu Application Platform v0.4 (beta-4)

## <a id='overview'></a> Overview of Tanzu Application Platform

<p class="note warning">
<strong>Warning:</strong> Tanzu Application Platform is currently in beta (intended for evaluation and test purposes only).
</p>

Tanzu Application Platform is a packaged set of components that helps developers and operators build, deploy, and manage apps on Kubernetes.

Simplify workflows in both the *inner loop* and *outer loop* of Kubernetes-based app development with  Tanzu Application Platform.

* **Inner Loop**: 
    - The inner loop describes a developer’s development cycle of iterating on code. 
    - Inner loop activities include coding, testing, and debugging before making a commit.
    - On cloud-native or Kubernetes platforms, developers in the inner loop often build container images and connect their app to all necessary services, apps, and  APIs to deploy it to a development environment.

* **Outer Loop**: 
    - The outer loop describes how operators deploy apps to production and maintain them over time. 
    - On a cloud-native platform, outer loop activities include building container images, adding container security, and configuring continuous integration and continuous delivery (CI/CD)  pipelines.
    - Outer loop activities are challenging in a Kubernetes-based development environment due to app delivery platforms being constructed from various third-party and open source components with numerous configuration options.

Tanzu Application Platform provides a default set of components that automates pushing an app to staging and production on Kubernetes, solving pains for both inner and outer loops. In addition, operators can customize the platform by replacing Tanzu Application Platform components with other products.

Kubernetes deployment complexity is reduced for operators with better automation and standardization of the outer loop, giving developers more time to focus on code.

## <a id='profiles-and-packages'></a>  Installation profiles and profiles in Tanzu Application Platform v0.4

Tanzu Application Platform is available through pre-defined profiles or individual packages.

The following profiles are available in Tanzu Application Platform:

- **Light:**
  Contains packages that drive the Inner Loop personal developer experience of building and 
  iterating on applications. 

- **Full:**
  This profile contains all of the Tanzu Application Platform packages.

## <a id='install'></a> About installing the Tanzu Application Platform v0.4 (beta-4) 

To install the Tanzu Application Platform profiles, see [Installing Tanzu Application Platform](install-intro.md).

## <a id='telemetry-notice'></a> Notice of telemetry collection for Tanzu Application Platform

In order to improve the quality of our products, Tanzu Application Platform participates in VMware’s Customer Experience Improvement Program (“CEIP”).
As part of the CEIP, VMware collects technical information about your organization’s use of VMware products and services on a regular basis
in association with your organization’s VMware license key(s).
For additional information regarding the CEIP, please see the Trust & Assurance Center at http://www.vmware.com/trustvmware/ceip.html.
You may join or leave VMware’s CEIP at any time. 
The CEIP Standard Participation Level provides VMware with information that enables VMware to improve its products and services,
identify and fix problems and to advise you on how best to deploy and use our products.
For example, this information will enable a proactive product deployment discussion with your VMware account team or
VMware support team to help resolve your issues.
This information cannot directly identify any individual. 

You must acknowledge that you have read VMware’s CEIP policy in order to proceed with the installation.
Setting the `ceip-policy-disclosed` value to `true` indicates that you have read the policy.
For how to opt out of telemetry participation, see [Opting out of telemetry collection](opting-out-telemetry.md).
