# Release notes

This topic contains release notes for Tanzu Application Platform v1.3

## <a id='1-3-8'></a> v1.3.8

**Release Date**: May 9, 2023

### <a id='1-3-8-security-fixes'></a> Security fixes 

This release has the following security fixes, listed by component and area. 

| Package Name | Vulnerabilities Resolved |
| ------------ | ------------------------ |
| carbonblack.scanning.apps.tanzu.vmware.com | <ul><li> GHSA-69cg-p879-7622</li><li>GHSA-vvpx-j8f3-3w6h</li><li>GHSA-69ch-w2m2-3vjp</li><li>GHSA-fxg5-wq6x-vr4w</li><li>CVE-2023-24827</li><li>GHSA-crp2-qrr5-8pq7</li><li>GHSA-c3xm-pvg7-gh7r</li><li>GHSA-f524-rf33-2jjr</li><li>GHSA-r48q-9g5r-8q2h </li></ul>|
| image-policy-webhook.signing.apps.tanzu.vmware.com | <ul><li> GHSA-vvpx-j8f3-3w6h</li><li>GHSA-fxg5-wq6x-vr4w </li></ul>|
| api-portal.tanzu.vmware.com | <ul><li> CVE-2023-20860</li><li>GHSA-493p-pfq6-5258 </li></ul>|
| buildservice.tanzu.vmware.com | <ul><li> CVE-2023-20860</li><li>CVE-2023-0461</li><li>CVE-2023-0179 </li></ul>|
| grype.scanning.apps.tanzu.vmware.com | <ul><li> CVE-2023-24329 </li></ul>|
| learningcenter.tanzu.vmware.com | <ul><li> CVE-2023-26114</li><li>GHSA-frjg-g767-7363</li><li>CVE-2021-27478</li><li>CVE-2021-27482</li><li>CVE-2021-27498</li><li>CVE-2021-27500</li><li>CVE-2022-43604</li><li>CVE-2022-43605</li><li>CVE-2022-43606</li><li>GHSA-hc6q-2mpp-qw7j </li></ul>|
| workshops.learningcenter.tanzu.vmware.com | <ul><li> CVE-2023-26114</li><li>GHSA-frjg-g767-7363</li><li>CVE-2021-27478</li><li>CVE-2021-27482</li><li>CVE-2021-27498</li><li>CVE-2021-27500</li><li>CVE-2022-43604</li><li>CVE-2022-43605</li><li>CVE-2022-43606 </li></ul>|
| snyk.scanning.apps.tanzu.vmware.com | <ul><li> CVE-2023-23918</li><li>CVE-2023-23919 </li></ul>|
| ootb-templates.tanzu.vmware.com | <ul><li> GHSA-vpvm-3wq2-2wvm </li></ul>|
| sso.apps.tanzu.vmware.com | <ul><li> CVE-2023-0465</li><li>CVE-2023-0466</li><li>CVE-2022-4899 </li></ul>|
| tap-gui.tanzu.vmware.com | <ul><li> CVE-2023-0465</li><li>CVE-2023-0466</li><li>CVE-2022-4899 </li></ul>|

---

## <a id='1-3-7'></a> v1.3.7

**Release Date**: April 11, 2023

### <a id='1-3-7-security-fixes'></a> Security fixes

This release has the following security fixes, listed by package name and
vulnerabilities.

<table>
  <tr>
  <th>Package name</th>
  <th>Vulnerabilities resolved</th>
  </tr>
  <tr>
  <td>buildservice.tanzu.vmware.com</td>
  <td><ul><li> GHSA-fxg5-wq6x-vr4w </li></ul></td>
  </tr>
  <tr>
  <td>developer-conventions.tanzu.vmware.com</td>
  <td><ul><li> GHSA-69cg-p879-7622</li><li>GHSA-69ch-w2m2-3vjp</li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0286">CVE-2023-0286</a></li><li>GHSA-cg3q-j54f-5p7p</li><li>GHSA-ppp9-7jff-5vj2 </li></ul></td>
  </tr>
  <tr>
  <td>eventing.tanzu.vmware.com</td>
  <td><ul><li> GHSA-69cg-p879-7622</li><li>GHSA-69ch-w2m2-3vjp </li></ul></td>
  </tr>
  <tr>
  <td>image-policy-webhook.signing.apps.tanzu.vmware.com</td>
  <td><ul><li> GHSA-8c26-wmh5-6g9v</li><li>GHSA-69cg-p879-7622</li><li>GHSA-69ch-w2m2-3vjp </li></ul></td>
  </tr>
  <tr>
  <td>learningcenter.tanzu.vmware.com</td>
  <td><ul><li> GHSA-69ch-w2m2-3vjp</li><li>GHSA-fxg5-wq6x-vr4w</li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0461">CVE-2023-0461</a></li><li>GHSA-83g2-8m93-v3w7</li><li>GHSA-ppp9-7jff-5vj2</li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24329">CVE-2023-24329</a></li><li>GHSA-3vm4-22fp-5rfm</li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23919">CVE-2023-23919</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-42919">CVE-2022-42919</a></li></ul></td>
  </tr>
  <tr>
  <td>policy.apps.tanzu.vmware.com</td>
  <td><ul><li> GHSA-fxg5-wq6x-vr4w </li></ul></td>
  </tr>
  <tr>
  <td>services-toolkit.tanzu.vmware.com</td>
  <td><ul><li> GHSA-gwc9-m7rh-j2ww </li></ul></td>
  </tr>
  <tr>
  <td>snyk.scanning.apps.tanzu.vmware.com</td>
  <td><ul><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24329">CVE-2023-24329</a></li></ul></td>
  </tr>
  <tr>
  <td>workshops.learningcenter.tanzu.vmware.com</td>
  <td><ul><li> GHSA-69ch-w2m2-3vjp</li><li>GHSA-fxg5-wq6x-vr4w</li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-0461">CVE-2023-0461</a></li><li>GHSA-83g2-8m93-v3w7</li><li>GHSA-ppp9-7jff-5vj2</li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-24329">CVE-2023-24329</a></li><li>GHSA-3vm4-22fp-5rfm</li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2023-23919">CVE-2023-23919</a></li><li><a href="https://nvd.nist.gov/vuln/detail/CVE-2022-42919">CVE-2022-42919</a></li></ul></td>
  </tr>
</table>

---

### <a id='1-3-7-resolved-issues'></a> Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id='1-3-7-grype-scanner-ri'></a> Source Controller

- Updated imgpkg API to v0.36.0 to fix file permissions after extracting the source tarball.
  File permissions were stripped from source files while using IMGPKG v0.25.0.
  This issue is fixed in IMGPKG v0.29.0 and later.

---

### <a id='1-3-7-known-issues'></a> Known issues

This release has the following known issues, listed by component and area.

#### <a id='1-3-7-tbs-ki'></a> Tanzu Build Service

- [CVE-2022-41723](https://nvd.nist.gov/vuln/detail/CVE-2022-41723) might appear in scans, but is not
  exploitable in buildpacks. The CVE impacts HTTP servers and manifests as a denial of service attack.
  None of the buildpacks run an HTTP server at any point and therefore are not exploitable.

---

## <a id='1-3-6'></a> v1.3.6

**Release Date**: March 6, 2023

### <a id='1-3-6-security-fix'></a> Security fixes

This release has the following security fixes, listed by package name and
vulnerabilities.

- **api-portal.tanzu.vmware.com**: [CVE-2023-0286](https://nvd.nist.gov/vuln/detail/CVE-2023-0286)
- **apis.apps.tanzu.vmware.com**: [CVE-2023-0286](https://nvd.nist.gov/vuln/detail/CVE-2023-0286)
- **cartographer.tanzu.vmware.com**: GHSA-8c26-wmh5-6g9v, GHSA-69cg-p879-7622,
  GHSA-69ch-w2m2-3vjp, [CVE-2023-0286](https://nvd.nist.gov/vuln/detail/CVE-2023-0286), and GHSA-fxg5-wq6x-vr4w
- **cert-manager.tanzu.vmware.com**: [CVE-2023-0286](https://nvd.nist.gov/vuln/detail/CVE-2023-0286), [CVE-2022-2509](https://nvd.nist.gov/vuln/detail/CVE-2022-2509),
  [CVE-2022-4450](https://nvd.nist.gov/vuln/detail/CVE-2022-4450), and [CVE-2023-0215](https://nvd.nist.gov/vuln/detail/CVE-2023-0215)
- **cnrs.tanzu.vmware.com**: GHSA-8c26-wmh5-6g9v, GHSA-69cg-p879-7622,
  GHSA-69ch-w2m2-3vjp, and [CVE-2023-0286](https://nvd.nist.gov/vuln/detail/CVE-2023-0286)
- **controller.conventions.apps.tanzu.vmware.com**: [CVE-2023-0286](https://nvd.nist.gov/vuln/detail/CVE-2023-0286)
- **controller.source.apps.tanzu.vmware.com**: GHSA-69cg-p879-7622,
  GHSA-69ch-w2m2-3vjp, [CVE-2023-0286](https://nvd.nist.gov/vuln/detail/CVE-2023-0286), and GHSA-fxg5-wq6x-vr4w
- **eventing.tanzu.vmware.com**: [CVE-2023-0286](https://nvd.nist.gov/vuln/detail/CVE-2023-0286)
- **fluxcd.source.controller.tanzu.vmware.com**: GHSA-69cg-p879-7622 and [CVE-2023-0286](https://nvd.nist.gov/vuln/detail/CVE-2023-0286)
- **metadata-store.apps.tanzu.vmware.com**: GHSA-8c26-wmh5-6g9v,
  GHSA-69cg-p879-7622,
  GHSA-69ch-w2m2-3vjp, [CVE-2023-0286](https://nvd.nist.gov/vuln/detail/CVE-2023-0286), GHSA-fxg5-wq6x-vr4w, GHSA-r48q-9g5r-8q2h,
  and [CVE-2022-3515](https://nvd.nist.gov/vuln/detail/CVE-2022-3515)
- **ootb-templates.tanzu.vmware.com**: GHSA-8c26-wmh5-6g9v, GHSA-gwc9-m7rh-j2ww,
  GHSA-69cg-p879-7622, GHSA-69ch-w2m2-3vjp, [CVE-2023-0286](https://nvd.nist.gov/vuln/detail/CVE-2023-0286), GHSA-fxg5-wq6x-vr4w,
  GHSA-83g2-8m93-v3w7, GHSA-ppp9-7jff-5vj2, and GHSA-3vm4-22fp-5rfm
- **policy.apps.tanzu.vmware.com**: [CVE-2023-0286](https://nvd.nist.gov/vuln/detail/CVE-2023-0286)
- **services-toolkit.tanzu.vmware.com**: GHSA-69cg-p879-7622
- **sso.apps.tanzu.vmware.com**: [CVE-2023-0286](https://nvd.nist.gov/vuln/detail/CVE-2023-0286), [CVE-2022-40152](https://nvd.nist.gov/vuln/detail/CVE-2022-40152), [CVE-2022-4450](https://nvd.nist.gov/vuln/detail/CVE-2022-4450),
  [CVE-2023-0215](https://nvd.nist.gov/vuln/detail/CVE-2023-0215), and [CVE-2022-42916](https://nvd.nist.gov/vuln/detail/CVE-2022-42916)
- **tekton.tanzu.vmware.com**: [CVE-2023-0286](https://nvd.nist.gov/vuln/detail/CVE-2023-0286), [CVE-2018-25032](https://nvd.nist.gov/vuln/detail/CVE-2018-25032), [CVE-2021-28861](https://nvd.nist.gov/vuln/detail/CVE-2021-28861),
  [CVE-2020-10735](https://nvd.nist.gov/vuln/detail/CVE-2020-10735), [CVE-2022-45061](https://nvd.nist.gov/vuln/detail/CVE-2022-45061), GHSA-cjjc-xp8v-855w, and GHSA-ffhg-7mh4-33c4

---

### <a id='1-3-6-resolved-issues'></a> Resolved issues

The following issues, listed by area and component, are resolved in this
release.

#### <a id='1-3-6-tbs-ri'></a> Tanzu Build Service

- Fixed an issue that prevented the Cloud Native Buildpacks lifecycle component from
  upgrading with Tanzu Build Service.
  - Outdated lifecycle components can be built with older versions of Golang
    containing CVEs in the standard library.
  - Upgrading to Tanzu Application Platform v1.3.6 will ensure the lifecycle component is updated to
    the latest version.

### <a id='1-3-6-ki'></a> Known Issues

This release has the following known issues, listed by component and area.

#### <a id='1-3-6-grype-ki'></a> Grype scanner

**Scanning Java source code that uses Gradle package manager might not reveal vulnerabilities:**

For most languages, Source Code Scanning only scans files present in the source code repository.
Except for support added for Java projects using Maven, no network calls are made to fetch
dependencies. For languages using dependency lock files, such as Golang and Node.js, Grype uses the
lock files to check the dependencies for vulnerabilities.

For Java using Gradle, dependency lock files are not guaranteed, so Grype uses the dependencies
present in the built binaries (`.jar` or `.war` files) instead.

Because VMware does not encourage committing binaries to source code repositories, Grype fails to
find vulnerabilities during a source scan.
The vulnerabilities are still found during the image scan after the binaries are built and packaged
as images.

---

## <a id='1-3-5'></a> v1.3.5

**Release Date**: February 16, 2023

### <a id='1-3-5-security-fix'></a> Security fixes

This release has the following security fixes, listed by component and area.

#### <a id='1-3-5-contour-resolved-issues'></a> Contour

- Updated to [Contour v1.22.3](https://github.com/projectcontour/contour/releases/tag/v1.22.3).
Includes an update to [go v1.19.4](https://go.dev/doc/devel/release#go1.19.minor),
which contains security fixes to the `net/http` and `os` packages.

---
### <a id='1-3-5-breaking-changes'></a> Breaking changes

This release includes the following changes, listed by component and area.

#### <a id='scc-breaking-changes'></a> Supply Chain Choreographer

- Out of the Box Supply Chain Templates: In a multicluster setup, when a deliverable is created on a Build profile cluster, the ConfigMap it's in is renamed from `WORKLOAD-NAME` to `WORKLOAD-NAME`-deliverable. Any automation that depends on obtaining the deliverable content by using the former name must be updated with the new name. For more information, see [Multicluster Tanzu Application Platform overview](multicluster/about.hbs.md).

---

### <a id='1-3-5-resolved-issues'></a> Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id='1-3-5-sc-resolved-issues'></a> Source Controller

- Fixed an issue that caused some registries, including DockerHub, to incur higher than expected pulls because all HTTP GET calls are considered to be pulls. With this fix, HTTP requests use HEAD operations instead of GET operations, which reduces the number of pulls while checking updated image versions.

#### <a id='1-3-5-scc-resolved-issues'></a> Supply Chain Choreographer

- Out of the Box Supply Chain Templates
  - Fixed deliverable content written into ConfigMaps in multicluster setup.
  - Renamed ConfigMap to avoid conflict with `config-template`.
  - Labels to attribute the deliverable content with the supply chain and template are now added to be consistent with the delivery on a non-Build profile cluster.
  - Tanzu Application Platform GUI Supply Chain plug-in displays deliverables on run clusters with workloads from build clusters.
  - For more information, see [Multicluster Tanzu Application Platform overview](multicluster/about.hbs.md).

---

### <a id='1-3-5-known-issues'></a> Known Issues

This release includes the following known issues, listed by component and area.

#### <a id='1-3-5-grype-ki'></a> Grype scanner

**Scanning Java source code that uses Gradle package manager might not reveal vulnerabilities:**

For most languages, Source Code Scanning only scans files present in the source code repository.
Except for support added for Java projects using Maven, no network calls are made to fetch
dependencies. For languages using dependency lock files, such as Golang and Node.js, Grype uses the
lock files to check the dependencies for vulnerabilities.

For Java using Gradle, dependency lock files are not guaranteed, so Grype uses the dependencies
present in the built binaries (`.jar` or `.war` files) instead.

Because VMware does not encourage committing binaries to source code repositories, Grype fails to
find vulnerabilities during a source scan.
The vulnerabilities are still found during the image scan after the binaries are built and packaged
as images.

#### <a id="1-3-tbs-known-issues"></a> Tanzu Build Service

- Migrating from the `buildservice.kp_default_repository` key to the `shared.image_registry` key can
cause existing workloads to fail. After upgrading to v1.3, if you use the
`shared.image_registry` key and workloads fail with a `spec.tag` immutability error from the
`image.kpack.io`, delete the `image.kpack.io` associated with the failing workloads. The workloads can then be
recreated with the correct tags.

---

## <a id='1-3-4'></a> v1.3.4

**Release Date**: December 20, 2022

### <a id='1-3-4-security-fix'></a> Security fixes

The following security issues are resolved in this release.

#### <a id="1-3-4-tap-gui-resolved"></a> Tanzu Application Platform GUI

Fixed the following vulnerabilities:

* [CVE-2022-32215](https://nvd.nist.gov/vuln/detail/CVE-2022-32215): Updates the version of Node used to run Tanzu Application Platform GUI from v14.20.0 to v14.20.1.

* GHSA-hrpp-h998-j3pp: Updates the versions of express and qs.

---

### <a id='1-3-4-known-issues'></a> Known Issues

This release includes the following known issues, listed by component and area.

#### <a id='1-3-4-grype-ki'></a> Grype scanner

**Scanning Java source code that uses Gradle package manager might not reveal vulnerabilities:**

For most languages, Source Code Scanning only scans files present in the source code repository.
Except for support added for Java projects using Maven, no network calls are made to fetch
dependencies. For languages using dependency lock files, such as Golang and Node.js, Grype uses the
lock files to check the dependencies for vulnerabilities.

For Java using Gradle, dependency lock files are not guaranteed, so Grype uses the dependencies
present in the built binaries (`.jar` or `.war` files) instead.

Because VMware does not encourage committing binaries to source code repositories, Grype fails to
find vulnerabilities during a source scan.
The vulnerabilities are still found during the image scan after the binaries are built and packaged
as images.

---

## <a id='1-3-3'></a> v1.3.3

**Release Date**: December 13, 2022

### <a id='1-3-3-new-features'></a> Resolved issues

#### <a id="1-3-3-scc-plugin-resolved"></a> Supply Chain Choreographer plug-in

- The UI now shows the same message as the CLI, `Builder default is not ready`, when the Image Builder
  is not available or not configured.
- The `Scan Template` link in the **Overview** section for a scanning stage is now deactivated.

#### <a id="1-3-3-tap-gui-plug-ri"></a> Tanzu Application Platform GUI plug-ins

- Supply Chain plug-in
  - Fixed an issue where the Source Scanner stage was showing a non-functioning link to the Scan
    Template used.
  - Improved error-handling when the builder is failing.

---

### <a id='1-3-3-known-issues'></a> Known issues

This release has the following known issues, listed by component and area.

#### <a id="1-3-3-grype-scan-known-issues"></a>Grype scanner

**Scanning Java source code that uses Gradle package manager might not reveal vulnerabilities:**

For most languages, Source Code Scanning only scans files present in the source code repository.
Except for support added for Java projects using Maven, no network calls are made to fetch
dependencies. For languages using dependency lock files, such as Golang and Node.js, Grype uses the
lock files to check dependencies for vulnerabilities.

For Java using Gradle, dependency lock files are not guaranteed, so Grype uses dependencies
present in the built binaries, such as `.jar` or `.war` files.

Because VMware does not recommend committing binaries to source code repositories, Grype fails to
find vulnerabilities during a source scan.
The vulnerabilities are still found during the image scan after the binaries are built and packaged
as images.

#### <a id="1-3-3-ootb-ki"></a>Out of the Box Supply Chains

This release does not support configuring trusted CA certificates for an internal GitOps server.

---

## <a id='1-3-2'></a> v1.3.2

**Release Date**: November 16, 2022

### <a id='1-3-2-security-fixes'></a> Security fixes

This release has the following security fixes, listed by component and area.

#### <a id='1-3-2-stk-sec-fix'></a> Services Toolkit

- `libssl3` was updated to `3.0.2-0ubuntu1.7` to resolve [CVE-2022-3786](https://nvd.nist.gov/vuln/detail/CVE-2022-3786).
- `libssl3` was updated to `3.0.2-0ubuntu1.7` to resolve [CVE-2022-3602](https://nvd.nist.gov/vuln/detail/CVE-2022-3602).

#### <a id='1-3-2-scst-grype-fixes'></a> Supply Chain Security Tools - Grype

- `glib` is updated to `2.58.0-9.ph3`.
- `glibc` is updated to `2.28-22.ph3`.
- `expat` is updated to `2.2.9-10.ph3`.
- `opa` is updated to `v0.44.0`.

#### <a id='1-3-2-scst-scan-fixes'></a> Supply Chain Security Tools - Scan

- `opa` is updated to `v0.44.0`.

#### <a id='1-3-2-scst-store-fixes'></a> Supply Chain Security Tools - Store

- Updated the `postgres-bionic-13` image. This fixes
[CVE-2020-16156](https://nvd.nist.gov/vuln/detail/CVE-2020-16156) and
[CVE-2022-29458](https://nvd.nist.gov/vuln/detail/CVE-2022-29458).

#### <a id='1-3-2-scst-snyk-fixes'></a> Supply Chain Security Tools - Snyk

- `glib` is updated to `2.58.0-9.ph3`.
- `glibc` is updated to `2.28-22.ph3`.
- `expat` is updated to `2.2.9-10.ph3`.
- `opa` is updated to `v0.44.0`.


---

### <a id='1-3-2-resolved-issues'></a> Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id="1-3-2-supplychain-resolved"></a>Supply Chain Choreographer

- On a Build profile cluster, a `ConfigMap` containing the `Deliverable` is now produced. Previously a `Deliverable` was
  created directly on the cluster.
  For more information, see [Getting started with multicluster Tanzu Application Platform](multicluster/getting-started.hbs.md)

#### <a id="1-3-2-supplychainplugin-resolved"></a>Supply Chain Choreographer plug-in

- Updating a supply chain no longer causes an error (`Can not create edge...`) when an existing
workload is clicked in the Workloads table and that supply chain is no longer present.
- The Image Scan timestamp no longer fails to show the latest scan time.

#### <a id="1-3-2-intellij-resolved"></a> Tanzu Developer Tools for IntelliJ

- The extension can now Live Update when the workload type is `server` or `worker`.
- The extension no longer stops other debug sessions when stopping one debug session.

#### <a id="1-3-2-vs-code-resolved"></a> Tanzu Developer Tools for VS Code

- The extension no longer shows a warning notification when the user cancels an action.
- The extension can now generate a snippet on a `Tiltfile` when the user has a Tilt extension installed.
- The extension can now Live Update when the workload type is `server` or `worker`.

#### <a id="1-3-2-cnr-resolved"></a> Cloud Native Runtimes

- Deploying workloads on a `run` cluster in multicluster setup on Openshift no longer fails with Forbidden errors.

#### <a id="1-3-2-policy-controller-resolved"></a>Supply Chain Security Tools - Policy Controller

- Fixed issue where initialization fails because of `go-tuf` when using the Official Sigstore TUF root. For more information, see [Supply Chain Security Tools Policy Controller - Known Issues](./scst-policy/known-issues.hbs.md).

---

### <a id='1-3-2-known-issues'></a> Known issues

This release has the following known issues, listed by component and area.

#### <a id="1-3-2-grype-scan-known-issues"></a>Grype scanner

**Scanning Java source code that uses Gradle package manager might not reveal vulnerabilities:**

For most languages, Source Code Scanning only scans files present in the source code repository.
Except for support added for Java projects using Maven, no network calls are made to fetch
dependencies. For languages using dependency lock files, such as Golang and Node.js, Grype uses the
lock files to check dependencies for vulnerabilities.

For Java using Gradle, dependency lock files are not guaranteed, so Grype uses dependencies
present in the built binaries, such as `.jar` or `.war` files.

Because VMware does not recommend committing binaries to source code repositories, Grype fails to
find vulnerabilities during a source scan.
The vulnerabilities are found during the image scan after the binaries are built and packaged
as images.

#### <a id="policy-controller-known-issues"></a>Supply Chain Security Tools - Policy Controller

- Issue where initialization fails because of `go-tuf` when using the Official Sigstore TUF root. For more information, see [Supply Chain Security Tools - Policy Controller Known Issues](./scst-policy/known-issues.hbs.md). VMware resolved this issue with Policy Controller `v1.1.3` in TAP 1.3.2.

#### <a id="1-3-2-tap-gui-plugin-ki"></a> Tanzu Application Platform GUI

Known security vulnerability

  - Tanzu Application Platform GUI is vulnerable to [CVE-39353](https://nvd.nist.gov/vuln/detail/CVE-2022-39353)/[GHSA-crh6-fp67-6883](https://github.com/xmldom/xmldom/security/advisories/GHSA-crh6-fp67-6883). For a Tanzu Application Platform GUI deployment to be vulnerable to this exploit, you must use the SAML authentication provider as indicated by an `auth.saml` block in your Tanzu Application Platform GUI configuration file. Currently, SAML is not a documented or supported authentication provider for Tanzu Application Platform GUI.

    >**Caution** Until the underlying vulnerability is fixed, VMware advises _not_ to use SAML authentication with Tanzu Application Platform GUI. For customers currently leveraging SAML authentication, VMware advises switching to a different authentication mechanism or disabling Tanzu Application Platform GUI in the cluster until a patch version is released that remediates this exploit.

#### <a id="1-3-2-tap-gui-plugin-ki"></a> Tanzu Application Platform GUI Plug-ins

- **Supply Chain Choreographer Plug-in**

  - The UI shows the error message `Unable to retrieve details from Image Provider Stage` when the
    Builder is not available or configured. However, the CLI shows the correct error message
    `Builder default is not ready`.
  - Clicking on the `Scan Template` link in the **Overview** section for a scanning stage causes a
    blank page to open in the browser.
  - The image provider stage is not correctly reporting status failures. It is incorrectly showing
    a green status instead. This does, however, stop the supply chain execution.
  - Image Provider logs are not appearing in the Stage Details section when a build fails.
    The logs are, however, available through the CLI.

- **K8s logging backend  plug-in**

  - Fixes a bug where pod logs did not have OIDC support.

- **App Accelerator Scaffolder plug-in**

  - The kebab-menu in the Accelerators page is not visible when using light-mode theme.

- **Supply Chain plug-in**

  - Fixes an error where changing the supply chain of a workload resulted in UI errors.
  - Fixes an error with the timestamp not being updated in the scanning stages (source scanning and image scanning).
  - Fixes an error in the tables where the filters were being hidden when sorting columns.
  - Fixes an error in the "image provider" step when the user attempts to view a workload that was created using a pre-built image.

- **Kubernetes orm**

  - Fixes an error in the "image provider" step when the user attempts to view a workload that was created using a pre-built image.

- **Backend**

  - Override the catalog url for accelerator templates.

#### <a id='1-3-2-scc'></a> Supply Chain Choreographer

- In a Build profile cluster, deliverables are created with the labels to associate them with their Workload missing. As a workaround, they will have to be manually injected.  For more information, see [Multicluster Tanzu Application Platform overview](multicluster/about.hbs.md).
- These Deliverables are now rendered inside a ConfigMap. This resource was not renamed, and will cause Cartographer to overwrite one deliverable with the other depending on the timing of events in your cluster. VMware recommends upgrade to v1.3.5 to avoid unpredictable results.

---

## <a id='1-3-0'></a> v1.3.0

**Release Date**: October 11, 2022

### <a id='1-3-new-features'></a> New features

This release includes the following changes to Tanzu Application Platform and its components:

#### <a id="tap-features"></a> Tanzu Application Platform

- Tanzu Application Platform now supports:
  - OpenShift Red Hat OpenShift Container Platform v4.10
        - vSphere
        - Baremetal
  - Kubernetes v1.24
- Tanzu Application Platform components are installed the same way on OpenShift v4.10 as on any other supported Kubernetes distributions with minor configuration changes that are opaque to users.
- Tanzu Application Platform workloads are built and deployed the same way on OpenShift v4.10 as on any other supported Kubernetes distributions.

#### <a id="api-auto-registration-features"></a> API Auto Registration

- API Auto Registration is a new package that supports dynamic registration of API from workloads into Tanzu Application Platform GUI.
- Supports Async API, GraphQL, gRPC, and OpenAPI.
- Enhanced support for OpenAPI 3 to validate the specification and update the servers URL section.
- Custom Certificate Authority (CA) certificates are supported.

#### <a id="app-acc-features"></a> Application Accelerator

- Packaging
  - Out-of-the-box samples are now distributed as OCI images.
  - GitOps model support for publishing accelerator to facilitate governance around publishing accelerators.
- Controller
  - Added source-image support for fragments and Fragment CRD.
- Engine
  - OpenRewriteRecipe: More recipes are now supported in addition to Java.
    This includes XML, Properties, Maven, and JSON.
  - New ConflictResolution Strategy : `NWayDiff` merges files modified in different places, as long as they don't conflict. Similar to the Git diff3 algorithm.
  - Enforces the validity of `inputType`: Accepts only valid values: `text`, `textarea`, `checkbox`, `select`, and `radio`.
- Server
  - Added configmap to store accelerator invocation counts.
  - Added separate downloaded endpoint for downloads telemetry.
- Jobs
  - No changes.
- Samples
  - Samples are moved to https://github.com/vmware-tanzu/application-accelerator-samples.
  - Release includes samples marked with the `tap-1.3` tag.

#### <a id="alv-features"></a>Application Live View

- Application Live View supports Steeltoe/.NET applications.
- Supports Custom Certificate Authority (CA) certificates.

#### <a id="app-sso-features"></a>Application Single Sign-On

- TLS Auto-configured: TLS-enabled Ingress is auto-configured for AuthServer.
- Custom Certificate Authority (CA) certificates support.
- Improved error handling and audit logs for:
  - `TOKEN_REQUEST_REJECTED` events.
  - Identity providers are incorrectly set up.
- Enabled `/userinfo` endpoint to retrieve user information.
- Security: Complies with the restricted Pod Security Standard and gives the least privilege to the controller.
- Service-Operator cluster role: Aggregate RBAC for managing AuthServer.
- Controller updates:
  - The controller restarts when its configuration is updated.
  - The controller configuration is kept in a Secret.
  - All existing AuthServers are updated and rolled out when the controller’s configuration changes significantly.

#### <a id="carbon-black-scanner-features"></a> Carbon Black Cloud Scanner integration (beta)

Carbon Black Cloud Scanner image scanning integration (beta) is available for
[Supply Chain Security Tools - Scan](scst-scan/overview.hbs.md).
For instructions about using Carbon Black Cloud Scanner with Tanzu Application Platform Supply Chains, see [Prerequisites for Carbon Black Scanner (beta)](scst-scan/install-carbonblack-integration.hbs.md)

#### <a id="default-roles-features"></a>Default roles for Tanzu Application Platform

- Added new default role `service-operator`.

#### <a id="apps-plugin"></a> Tanzu CLI - Apps plug-in

- `tanzu apps *` improvements:
  - auto-complete now works for all sub-command names and their positional argument values, flag names, and flag values.
- `tanzu apps workload create/apply` improvements:
  - Apps plug-in users can now pass in registry flags to override the default registry options configured on the platform.
    - These flags can be leveraged when an application developer, iterating on  code on their file system, needs to push their code to a private registry. For example, this may be required when developing an application in an air-gapped environment.
    - To mitigate the risk of exposing sensitive information in the terminal, each registry flag/value can be specified by environment variables.
    - Refer to [workload apply > registry flags](./cli-plugins/apps/command-reference/commands-details/workload_create_update_apply.hbs.md#---registry-ca-cert) for a more detailed explanation about these flags and how to use them.
  - Provided first-class support for creating workloads from Maven artifacts through Maven flags. Previously, this could only be achieved by passing the desired values through the `--complex-param` flag.
    - Refer to [workload apply > maven source flags](./cli-plugins/apps/command-reference/commands-details/workload_create_update_apply.hbs.md#---maven-artifact) for a more detailed explanation about these flags and how to use them.
- `tanzu apps workload get` improvements:
  - Optimized the routines triggered when engaged in iterative development on the local file system.
    - Running `tanzu apps workload apply my-app --local-path . ...` only uploads the contents of the project directory when source code changes are detected.
  - Added an OUTPUT column to the resource table in the Supply Chain section to provide visibility to the resource that's stamped out by each supply chain step.
    - The stamped out resource can be helpful when troubleshooting supply chain issues for a workload. For example, the OUTPUT value can be copied and pasted into a `kubectl describe [output-value]` to view the resource's state/status/messages/etc... in more detail).
  - Added a Delivery section that provides visibility to the delivery steps and the health, status, and stamped out resource associated with each delivery step.
    - The Delivery section content might be conditionally displayed depending on whether the targeted environment includes the Deliverable object. Delivery is present on environments created using the Iterate and Build installation profiles.
  - Added a `Healthy` column to the Supply Chain resources table.
    - The column values are color coded to indicate the health of each resource at a glance.
  - Added an Overview section to show workload name and type.
  - Added Emojis to, and indentation under, each section header in the command output to better distinguish each section.
  - Updated the STATUS column in the table within the Pods section so that it displays the `Init` status when there are init containers, instead of displaying a less helpful/accurate `pending` value.
    - All column values in the Pods table have been updated so the output is equivalent to the output from `kubectl get pod/pod-name`.
- Updated Go to its latest version (v1.19).

#### <a id="src-cont-features"></a>Source Controller

- Added support for pulling artifacts with `LATEST` and `SNAPSHOT` versions.
- Optimized 'MavenArtifact' artifact download during interval sync.
  - Only after the SHA on the Maven Repository has changed can the source controller download the artifact. Otherwise, the download is skipped.
- Added routine to reset `ImageRepository` condition status between reconciles.

#### <a id="snyk-scanner"></a> Snyk Scanner (beta)

- Snyk CLI is updated to v1.994.0.

#### <a id="scst-policy-features"></a>Supply Chain Security Tools - Policy Controller

- Updated Policy Controller version from v0.2.0 to v0.3.0.
- Added ClusterImagePolicy [`warn` and `enforce` mode](./scst-policy/configuring.hbs.md#cip-mode).
- Added ClusterImagePolicy [authority static actions](./scst-policy/configuring.hbs.md#cip-static-action).

#### <a id="tap-gui-features"></a>Tanzu Application Platform GUI

- Users are no longer required to set the following values when using ingress: `app.baseUrl`,
  `backend.baseUrl`, `backend.cors.origin`.
  These values can be inferred by the value derived from `ingressDomain` or through the top-level
  key `ingress_domain`.
- Tanzu Application Platform GUI reads from a Kubernetes metrics server and displays these values in
  the Runtime Resources Visibility tab when available.
  By default, Tanzu Application Platform GUI does not try to fetch metrics.
  To enable metrics for a cluster, follow the
  [Runtime Resources Visibility documentation](tap-gui/plugins/runtime-resource-visibility.hbs.md#metrics-server).
- Tanzu Application Platform GUI reports logs in newline-delimited JSON format.
- Users can now edit the Kubernetes deployment parameters by using the `deployment` key.
- Upgraded the version of backstage on which Tanzu Application Platform GUI runs to backstage v1.1.1.
- Supports a new endpoint from which external components can push updates to catalog entities.
  The `api-auto-registration` package must be configured to push catalog entities to
  Tanzu Application Platform GUI.
- Application Accelerator plug-in:
  - Added metric to see how many executions an accelerator has in the accelerator list.
  - Added ability to create Git repositories based on the provided configuration.
- Runtime Resources plug-in:
  - Pods, ReplicaSets, and Deployments now display configured memory and CPU limits. On clusters
    configured with `skipMetricsLookup` set to `false`, realtime memory and CPU use are also displayed.
  - Supports new Kubernetes resources (Jobs, CronJobs, StatefulSets, and DaemonSets).
  - Warning and error banners can now be dismissed.
  - Log viewer improvements:
    - Log viewer now streams messages in real time.
    - Log entries can be soft-wrapped.
    - Log contents can be exported.
    - The log level can be changed for pods supporting Application Live View.
- Supply Chain Choreographer plug-in:
  - Improved error handling when a scan policy is misconfigured.
    There are now links to documentation to properly configure scan policies, which replace the
    `No policy has been configured` message.
  - Added cluster validation to avoid data collisions in the supply chain visualization when a
    workload with the same name and namespace exist on different clusters.
  - Beta: VMware Carbon Black scanning is now supported.
  - Keyboard navigation improvements.
  - Updated headers on the Supply Chain graph to better display the name of the supply chain used and
    the workload in the supply chain.
  - Added direct links to **Package Details** and **CVE Details** pages from within scan results to
    support a new Security Analysis plug-in.
- New [Security Analysis plug-in](tap-gui/plugins/sa-tap-gui.hbs.md):
  - View vulnerabilities across all workloads and clusters in a single location.
  - View CVE details and package details page. See the Supply Chain Choreographer plug-in's
    Vulnerabilities table.

#### <a id="dev-tls-vsc-features"></a>Tanzu Developer Tools for VS Code

- Now runs on Windows OS.
- You can run multiple Debug and Live Update sessions for apps with multiple microservices,
  both in monorepo-based apps and apps with each microservice in its own repository.
- Tanzu context menu actions are now available when you right-click on any file in the project, not
  just `workload.yaml` or a tiltfile.
- Added **Tanzu Problems** panel to show workload status errors inside the IDE.
- Debug and Live Update is enabled by default with `workload apply`, which makes the Live Update
  experience faster in VS Code.

#### <a id="dev-tls-intellij-features"></a>Tanzu Developer Tools for IntelliJ

- Now runs on Windows OS.
- You can run multiple Debug and Live Update sessions for apps with multiple microservices, both
  in monorepo-based apps and apps with each microservice in its own repository.
- The **Tanzu Workload** panel has been added to IntelliJ. The panel shows the current status of each
  workload, namespace, and cluster. It also shows whether Live Update and Debug are running, stopped,
  or disabled.

#### <a id="functions-features"></a> Functions (beta)

- Functions Java and Python buildpack are included in Tanzu Application Platform 1.3.
- Node JS Functions accelerator now available in Tanzu Application Platform GUI.

#### <a id="tbs-features"></a> Tanzu Build Service

- **Tanzu Build Service now includes support for Jammy Stacks:**
You can opt-in to building workloads with the Jammy stacks by following the instructions in
[Use Jammy stacks for a workload](tanzu-build-service/dependencies.md#using-jammy).

#### <a id="srvc-toolkit-features"></a> Services Toolkit

- Created documentation and reference Service Instance Packages for new Cloud Service Provider integrations:
  - [Azure Flexible Server (Postgres) by using the Azure Service Operator](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_azure_flexibleserver_psql_with_azure_operator.html).
  - [Azure Flexible Server (Postgres) by using Crossplane](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_azure_database_with_crossplane.html).
  - [Google Cloud SQL (Postgres) by using Config Connector](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_gcp_sql_with_config_connector.html).
  - [Google Cloud SQL (Postgres) by using Crossplane](https://docs.vmware.com/en/Services-Toolkit-for-VMware-Tanzu-Application-Platform/0.8/svc-tlk/GUID-usecases-consuming_gcp_sql_with_crossplane.html).
- Formally defined the Service Operator user role (see [Role descriptions](./authn-authz/role-descriptions.hbs.md)).
- **`tanzu services` CLI plug-in:** Improved information messages for deprecated commands.


---

### <a id='1-3-breaking-changes'></a> Breaking changes

This release has the following breaking changes, listed by component and area.

#### <a id="scst-scan-changes"></a> Supply Chain Security Tools - Scan

- Alpha version scan CRDs are removed.
- A deprecated path is invoked when `ScanTemplates` ships with versions earlier than
  Supply Chain Security Tools - Scan v1.2.0 are used.
  It now logs a message directing users to update the scanner integration to the latest version.
  The migration path uses `ScanTemplates` shipped with Supply Chain Security Tools - Scan v1.3.0.

#### <a id="app-sso-changes"></a> Application Single Sign-On

- `AuthServer.spec.identityProviders.internalUser.users.password` is in plain text instead of _bcrypt_
  -hashed.
- When an authorization server fails to obtain a token from an OpenID identity provider, it records
  an `INVALID_IDENTITY_PROVIDER_CONFIGURATION` audit event instead of `INVALID_UPSTREAM_PROVIDER_CONFIGURATION`.
- Package configuration `webhooks_disabled` is removed and `extra` is renamed to `internal`.
- The `KEYS COUNT` print column is replaced with the more insightful `STATUS` for `AuthServer`.
- The `sub` claim in `id_token`s and `access_token`s follow the `<providerId>_<userId>` pattern,
  instead of `<providerId>/<userId>`. See [Misconfigured `sub` claim](app-sso/troubleshoot.md#sub-claim) for more information.

---

### <a id='1-3-resolved-issues'></a> Resolved issues

The following issues, listed by component and area, are resolved in this release.

#### <a id="1-3-upgrade-issues"></a>Upgrading Tanzu Application Platform

- Adding new Tanzu Application Platform repository bundle in addition to another repository bundle no longer causes a failure.

#### <a id="app-acc-resolved"></a> Application Accelerator

- Controller
  - Importing a non-ready fragment propagates non-readyness.
  - DependsOn from fragments are no longer "lost" when imported.
- Engine
  - OpenRewriteRecipe updates: Unrecognized Recipe properties now trigger an explicit error.

#### <a id="app-sso-resolved"></a> Application Single Sign-On

- Emit the audit `TOKEN_REQUEST_REJECTED` event when the `refresh_token` grant fails.
- The service binding `Secret` is updated when a `ClientRegistration` changes significantly.

#### <a id="scst-scan-resolved"></a>Supply Chain Security Tools - Policy Controller

- Pods deployed through `kubectl run` in non-default namespace can now build the necessary keychain for registry access during validation.

#### <a id="apps-plugin-resolved"></a> Tanzu CLI - Apps plug-in

- Flag `azure-container-registry-config` that was shown in help output but was not part of apps plug-in flags, is not shown anymore.
- `workload list --output` was not showing all workloads in namespace. This was fixed, and now all workloads are listed.
- When creating a workload from local source in Windows, the image was created with unstructured directories and flattened all file names. This is now fixed with an `imgpkg` upgrade.
- When uploading a source image, if the namespace provided is not valid or doesn't exist, the image isn't uploaded and the workload isn't created.
- Due to a Tanzu Framework upgrade, the autocompletion for flag names in all commands is now working.

#### <a id="source-controller-resolved"></a> Source Controller

- Added checks to ensure that SNAPSHOT has versioning enabled.
- Fixed resource status conditions when metadata or metadata element is not found.

#### <a id="tap-gui-resolved"></a>Tanzu Application Platform GUI

- Supply Chain plug-in

  - Deliverable link in Runtime Resources no longer takes a user to a blank page instead of to the
    supply chain delivery.
  - Results for the wrong workload are no longer shown if the same `part-of label` is used across
    workloads with the same name.


---

### <a id='1-3-known-issues'></a> Known issues

This release has the following known issues, listed by component and area.

#### <a id="tap-known-issues"></a>Tanzu Application Platform

- New default Contour configuration causes ingress on Kind cluster on Mac to break. The config value `contour.envoy.service.type` now defaults to `LoadBalancer`. For more information, see [Troubleshooting Install Guide](troubleshooting-tap/troubleshoot-install-tap.hbs.md#contour-error-kind).
- The key shared.image_registry.project_path, which takes input as "SERVER-NAME/REPO-NAME", cannot take "/" at the end. For more information, see [Troubleshoot using Tanzu Application Platform](troubleshooting-tap/troubleshoot-using-tap.hbs.md#invalid-repo-paths).

#### <a id="tanzu-cli-known-issues"></a>Tanzu CLI/plug-ins

**Failure to connect to AWS EKS clusters:**

When connecting to AWS EKS clusters, an error might appear with the text:

  - `Error: Unable to connect: connection refused. Confirm kubeconfig details and try again` or
  - `invalid apiVersion "client.authentication.k8s.io/v1alpha1"`.

This occurs if the version of the `aws-cli` is less than the supported version, v`2.7.35`.

 For information about resolving this issue, see [Troubleshoot using Tanzu Application Platform](troubleshooting-tap/troubleshoot-using-tap.hbs.md#connect-aws-eks-clusters).

#### <a id="api-auto-registration-known-issues"></a>API Auto Registration

**Valid OpenAPI v2 specifications that use `schema.$ref` fail validation:**

If using an OpenAPI v2 specification with this field, consider converting to OpenAPI v3.
For more information, see [Troubleshooting](api-auto-registration/troubleshooting.hbs.md).
All other specification types and OpenAPI v3 specifications are unaffected.

#### <a id="app-acc-known-issues"></a>Application Accelerator

**Generation of new project from an accelerator times out:**

Generation of a new project from an accelerator might time out for more complex accelerators.
For more information, see [Configure ingress timeouts](application-accelerator/configuration.hbs.md#configure-timeouts).

#### <a id="alv-known-issues"></a>Application Live View

**Unable to find CertificateRequests in App Live View Convention:**

When creating a Tanzu Application Platform workload, an error might appear with the text:

```console
failed to authenticate: unable to find valid certificaterequests for certificate "app-live-view-conventions/appliveview-webhook-cert"
```

This occurs because the certificate request is missing for the corresponding certificate `appliveview-webhook-cert`.
For more information, see [Troubleshooting](app-live-view/troubleshooting.hbs.md#missing-cert-requests).

#### <a id="alv-ca-known-issues"></a>Application Single Sign-On

**Redirect URIs change to http instead of https:**

AppSSO makes requests to external identity providers with `http` rather than `https`.
For more information, see [Redirect URIs change to http instead of https](app-sso/known-issues/index.md#cidr-ranges).

#### <a id="cnrs-issues"></a> Cloud Native Runtimes

**Failure to deploy workloads on `run` cluster in multicluster setup on Openshift:**

When creating a workload from a Deliverable resource, it may not create and instead result in the following error:

```
pods "<pod name>" is forbidden: unable to validate against any security context constraint:
[provider "anyuid": Forbidden: not usable by user or serviceaccount, spec.containers[0].securityContext.runAsUser:
Invalid value: 1000: must be in the ranges: [1000740000, 1000749999]
```

This can be due to ServiceAccounts or users bound to overly restrictive SecurityContextConstraints.

For information about resolving this issue, see the Cloud Native Runtimes [troubleshooting documentation](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/2.0/tanzu-cloud-native-runtimes/GUID-troubleshooting.html).

#### <a id="eventing-issues"></a> Eventing

**Eventing package fails during a profile-based Tanzu Application Platform installation**

For information about resolving this issue, see the known issue in the [Cloud Native Runtimes documentation](https://docs.vmware.com/en/Cloud-Native-Runtimes-for-VMware-Tanzu/2.0/tanzu-cloud-native-runtimes/GUID-upgrade.html#known-issue-eventing-profile-based).

#### <a id="grype-scan-known-issues"></a>Grype scanner

**Scanning Java source code that uses Gradle package manager might not reveal vulnerabilities:**

For most languages, Source Code Scanning only scans files present in the source code repository.
Except for support added for Java projects using Maven, no network calls are made to fetch
dependencies. For languages using dependency lock files, such as Golang and Node.js, Grype uses the
lock files to check the dependencies for vulnerabilities.

For Java using Gradle, dependency lock files are not guaranteed, so Grype uses the dependencies
present in the built binaries (`.jar` or `.war` files) instead.

Because VMware does not encourage committing binaries to source code repositories, Grype fails to
find vulnerabilities during a source scan.
The vulnerabilities are still found during the image scan after the binaries are built and packaged
as images.

#### <a id="tap-gui-known-issues"></a>Tanzu Application Platform GUI

**Tanzu Application Platform GUI doesn't work in Safari:**

Tanzu Application Platform GUI does not work in the Safari web browser.

#### <a id="tap-gui-plug-in-known-issues"></a>Tanzu Application Platform GUI Plug-ins

- **Supply Chain Plug-in:**

  - The Target Cluster column in the Workloads table shows the incorrect cluster when two workloads
    of the same name, `part-of label`, namespace, and same supply-chain name are used on different
    clusters.
  - Updating a supply chain results in an error (`Can not create edge...`) when an existing workload
    is clicked in the Workloads table and that supply chain is no longer present.
    For information about resolving this issue, see [Troubleshooting](tap-gui/troubleshooting.hbs.md#update-sc-err).
  - API Descriptors/Service Bindings stages show an `Unknown` status (grey question mark in the graph)
    even if successful.
  - Users see the error `An error occurred while loading data from the Metadata Store` when
    Tanzu Application Platform GUI is not fully configured. For more information, see
    [Troubleshooting](tap-gui/troubleshooting.hbs.md#err-load-metadata-store).

- **Back-end Kubernetes plug-in reporting failure in multicluster environments:**

  In a multicluster environment when one request to a Kubernetes cluster fails,
  `backstage-kubernetes-backend` reports a failure to the front end.
  This is a known issue with upstream Backstage and it applies to all released versions of
  Tanzu Application Platform GUI. For more information, see
  [this Backstage code in GitHub](https://github.com/backstage/backstage/blob/c7f88d041b671185dc7a01e716f80dca0709e2a1/plugins/kubernetes-backend/src/service/KubernetesFanOutHandler.ts#L250-L271).
  This behavior arises from the API at the Backstage level. There are currently no known workarounds.
  There are plans for upstream commits to Backstage to resolve this issue.

#### <a id="vscode-ext-known-issues"></a>VS Code Extension

- **Unable to view workloads on the panel when connected to GKE cluster:**

  When connecting to Google's GKE clusters, an error might appear with the text
  `WARNING: the gcp auth plug-in is deprecated in v1.22+, unavailable in v1.25+; use gcloud instead.`
  To fix this, see [Troubleshooting](vscode-extension/troubleshooting.hbs.md#cannot-view-workloads).

- **Warning notification when canceling an action:**

  A warning notification can appear when running `Tanzu: Debug Start`, `Tanzu: Live Update Start`,
  or `Tanzu: Apply`, which says that no workloads or Tiltfiles were found.
  For more information, see [Troubleshooting](vscode-extension/troubleshooting.hbs.md#cancel-action-warning).

- **Live update might not work when using server or worker Workload types:**

  When using `server` or `worker` as
  [workload type](workloads/workload-types.hbs.md#-available-workload-types),
  live update might not work.
  For more information, see
  [Troubleshooting](vscode-extension/troubleshooting.hbs.md#lu-not-working-wl-types).

#### <a id="intelj-ext-known-issues"></a>IntelliJ Extension

- **Unable to view workloads on the panel when connected to GKE cluster:**

  When connecting to Google's GKE clusters, an error might appear with the text
  `WARNING: the gcp auth plug-in is deprecated in v1.22+, unavailable in v1.25+; use gcloud instead.`
  To fix this, see [Troubleshooting](intellij-extension/troubleshooting.hbs.md#cannot-view-workloads).

- **Starting debug and live update sessions is synchronous:**

  When a user runs or debugs a launch configuration, IntelliJ deactivates the launch controls to prevent
  other launch configurations from being launched at the same time.
  These controls are reactivated when the launch configuration is started.
  As such, starting multiple Tanzu debug and live update sessions is a synchronous activity.

- **Live update not working when using server or worker Workload types:**

  When using `server` or `worker` as
  [workload type](workloads/workload-types.hbs.md#-available-workload-types),
  live update might not work.
  For more information, see
  [Troubleshooting](intellij-extension/troubleshooting.hbs.md#lu-not-working-wl-types).

- Live Update does not work when using the Jammy `ClusterBuilder`.

#### <a id="contour-known-issues"></a>Contour

- Incorrect output for command `tanzu package available get contour.tanzu.vmware.com/1.22.0+tap.3 --values-schema -n tap-install`.
  The default values displayed for the following keys are incorrect in the values-schema of the Contour package in Tanzu Application Platform v1.3.0:
    - Key `envoy.hostPorts.enable` has a default value of `false`, but it is displayed as `true`.
    - Key `envoy.hostPorts.enable` has a default value of `LoadBalancer`, but it is displayed as `NodePort`.

#### <a id="scc-known-issues"></a>Supply Chain Choreographer

- **Misleading DeliveryNotFound error message on Build profile clusters**

  Deliverables incorrectly show a DeliveryNotFound error on build profile clusters even though the
  workload is working correctly. The message is typically:
  `No delivery found where full selector is satisfied by labels:`.

---

## <a id='1-3-deprecations'></a> Deprecations

The following features, listed by component, are deprecated.
Deprecated features will remain on this list until they are retired from Tanzu Application Platform.

#### <a id="1-3-app-sso-deprecations"></a> Application Single Sign-On

  - `AuthServer.spec.issuerURI` is deprecated and marked for removal in the next release. You can migrate
    to `AuthServer.spec.tls` by following instructions in [AppSSO migration guides](app-sso/upgrades/index.md#migration-guides).
  - `AuthServer.status.deployments.authserver.LastParentGenerationWithRestart` is deprecated and marked
   for removal in the next release.

#### <a id="1-3-scst-sign-deprecations"></a> Supply Chain Security Tools - Sign

- [Supply Chain Security Tools - Sign](scst-sign/overview.md) is deprecated. For migration information, see [Migration From Supply Chain Security Tools - Sign](./scst-policy/migration.hbs.md).

#### <a id="1-3-tbs-deprecations"></a> Tanzu Build Service

- The Ubuntu Bionic stack is deprecated:
Ubuntu Bionic stops receiving support in April 2023.
VMware recommends you migrate builds to Jammy stacks in advance.
For how to migrate builds, see [Use Jammy stacks for a workload](tanzu-build-service/dependencies.md#using-jammy).
- The Cloud Native Buildpack Bill of Materials (CNB BOM) format is deprecated.
It is still activated by default in Tanzu Application Platform v1.3 and v1.4.
VMware plans to deactivate this format by default in Tanzu Application Platform v1.5
and remove support in Tanzu Application Platform v1.6.
To manually deactivate legacy CNB BOM support, see [Deactivate the CNB BOM format](tanzu-build-service/install-tbs.md#deactivate-cnb-bom).

##### <a id="1-3-apps-plugin-deprecations"></a> Tanzu CLI Apps plug-in

- The `tanzu apps workload update` command is deprecated in the `apps` CLI plug-in. Please use `tanzu apps workload apply` instead.
  - `update` is deprecated in two Tanzu Application Platform releases (in Tanzu Application Platform v1.5.0) or in one year (on Oct 11, 2023), whichever is later.
