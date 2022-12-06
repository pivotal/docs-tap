# Release notes

{{#unless vars.hide_content}}
This Handlebars condition is used to hide content.
In release notes, this condition hides content that describes an unreleased patch for a released minor.
{{/unless}}

This topic contains release notes for Tanzu Application Platform v1.4.

## <a id='1-4-0'></a> v1.4.0

**Release Date**: January 10, 2023

### <a id='1-4-0-new-features'></a> New features

This release includes the following changes, listed by component and area.

#### <a id="1-4-0-tap-new-features"></a> TAP

TAP is introducing a [shared ingress issuer](security-and-compliance/ingress-certificates.hbs.md) for secure ingress communication by
default. [CNRs](cloud-native-runtimes/about.hbs.md), [AppSSO](app-sso/about.hbs.md), and [TAP GUI](tap-gui/about.hbs.md)
are using this issuer to secure ingress. In upcoming releases all components will support it eventually.

#### <a id="1-4-0-tap-gui-plugin-nf"></a> Tanzu Application Platform GUI Plug-ins

#### <a id='scc-plug-in-new-features'></a>Supply Chain Choreographer Plug-in

- Events are now emitted when resources are applied and when their output or health status changes. See [Events reference](scc/events.hbs.md).
- Source Tester stage now includes a link to the Jenkins job when Jenkins is configured for use
  in the supply chain.
- `spec.source.git.url` is added to the Overview section of the Source Provider stage in the
  supply chain.
- Added support to include current and historical Kaniko build logs in the Stage Details section of
  the supply chain when Kaniko is used as the build service in the Image Provider stage.
- Scanning stages now include a `Show Unique CVEs` filter so that the scan results show one CVE
  per ID as opposed to each CVE per package.
  This allows better alignment between the data in the Supply Chain Choreographer plug-in and the
  Security Analysis plug-in.
- **View Approvals** is relocated to the `Config Writer` stage, instead of being a stage by itself.
- Added an **Impacted Workloads** column to the **Stage Details** section of scanning stages, so that
  it is now easier to see how many workloads are impacted by the CVE that the scan detected.

#### <a id="1-4-0-scst-scan-new-features"></a> Supply Chain Security Tools - Scan
- Users no longer need to create a package overlay to enable Grype in offline and air-gapped environments. Refer to our updated [instructions](./partials/scst-scan/_offline-airgap.hbs.md).

### <a id='1-4-0-breaking-changes'></a> Breaking changes
This release has the following breaking changes, listed by area and component.

#### <a id="1-4-0-vscode-bc"></a> Tanzu Developer Tools for Visual Studio Code

- `Tanzu Debug` no longer port forwards the application port (8080).

#### <a id="1-4-0-scst-scan-bc"></a> Supply Chain Security Tools - Scan

- Removed deprecated ScanTemplates:
  - Deprecated Grype ScanTemplates shipped with versions earlier than Tanzu Application Platform v1.2.0 were removed and are no longer supported. Please ensure you are using Grype ScanTemplates v1.2+ moving forward.
- Deprecation notice:
  - The `docker` field and related sub-fields by Supply Chain Security Tools - Scan are deprecated and marked for removal in Tanzu Application Platform v1.7.0.
  - The deprecation will impact the following components: Scan Controller, Grype Scanner, and Snyk Scanner.
  - For the migration path, see [Troubleshooting](scst-scan/observing.hbs.md#unable-to-pull-scanner-controller-images).
  - Carbon Black Scanner is not impacted.

#### <a id="1-4-0-ipw-bc"></a> Supply Chain Security Tools - Image Policy Webhook

The Image Policy Webhook component is removed in Tanzu Application Platform v1.4. This component is deprecated
in favor of the [Policy Controller](./scst-policy/overview.hbs.md).

#### <a id="1-4-0-policy-controller-bc"></a> Supply Chain Security Tools - Policy Controller

Policy Controller no longer initializes TUF by default. TUF is required to
support the keyless authorities in `ClusterImagePolicy`. To continue to use
keyless authorities, provide the value `policy.tuf_enabled:
true` by using the `tap-values.yaml` while upgrading. By default,
the public Sigstore The Update Framework (TUF) server is used. To
target an alternative Sigstore stack, specify `policy.tuf_mirror` and
`policy.tuf_root`.

### <a id='1-4-0-security-fixes'></a> Security fixes

This release has the following security fixes, listed by area and component.

#### <a id='1-4-0-scst-grype-fixes'></a> Supply Chain Security Tools - Grype
- `python` has been updated to `3.7.5-22.ph3`

### <a id='1-4-0-resolved-issues'></a> Resolved issues

The following issues, listed by area and component, are resolved in this release.

#### <a id="1-4-0-api-auto-registration-ri"></a> API Auto Registration

- Now periodically checks the original API specification from the defined location to find changes, and registers any changes into the `API Descriptor`, triggering also the reconciliation into the Tanzu Application Platform GUI catalog. This synchronization period or frequency is configurable through the new value `sync_period`. The default value is 5 minutes.
- Base image updated to resolve [CVE-2022-3786](https://nvd.nist.gov/vuln/detail/CVE-2022-3786) and [CVE-2022-3602](https://nvd.nist.gov/vuln/detail/CVE-2022-3602).

#### <a id="1-4-0-tap-gui-plugin-ri"></a> Tanzu Application Platform GUI Plug-ins

- **Immediate entity provider backend Plug-in**

  - The entity provider (used mainly by API Auto Registration) now allows a body size of `5Mb` (increased from `100Kb`) to accept larger API specs.
  - Respecting the restriction of Backstage for [Entity Provider mutations](https://backstage.io/docs/features/software-catalog/external-integrations#provider-mutations), whenever an existing entity is intended for a mutation through this plugin, and its origin is a different entity provider, a `409 Conflict` error is returned.

#### <a id="supply-chain-plugin-ri"></a> Supply Chain Choreographer Plug-In

- The UI no longer shows the error `Unable to retrieve details from Image Provider Stage` when the
  Builder is not available or configured. It now correctly shows the same error as the CLI,
  `Builder default is not ready`.

### <a id='1-4-0-known-issues'></a> Known issues

This release has the following known issues, listed by area and component.

### <a id='1-4-0-deprecations'></a> Deprecations

The following features, listed by component, are deprecated.
Deprecated features will remain on this list until they are retired from Tanzu Application Platform.

#### <a id="1-3-app-sso-deprecations"></a> Application Single Sign-On

  - `AuthServer.spec.issuerURI` is deprecated and marked for removal in the next release. You can migrate
    to `AuthServer.spec.tls` by following instructions in [AppSSO migration guides](app-sso/upgrades/index.md#migration-guides).
  - `AuthServer.status.deployments.authserver.LastParentGenerationWithRestart` is deprecated and marked
   for removal in the next release.

#### <a id="1-4-0-ipw-bc"></a> Supply Chain Security Tools - Image Policy Webhook

The Image Policy Webhook component is removed in Tanzu Application Platform v1.4. This component is deprecated
in favor of the [Policy Controller](./scst-policy/overview.hbs.md).

#### <a id="1-4-0-scst-scan-deprecations"></a> Supply Chain Security Tools - Scan

- Removed deprecated ScanTemplates:
  - Deprecated Grype ScanTemplates shipped with versions prior to TAP 1.2.0 have been removed and are no longer supported. Please ensure you are using Grype ScanTemplates v1.2+ moving forward.
  - `docker` field and related sub-fields by Supply Chain Security Tools - Scan are deprecated and marked for removal in TAP 1.7.0.
    - The deprecation will impact the following components: Scan Controller, Grype Scanner and Snyk Scanner.
    - See [troubleshooting](scst-scan/observing.hbs.md#unable-to-pull-scanner-controller-images) documentation for the migration path.

#### <a id="1-3-scst-sign-deprecations"></a> Supply Chain Security Tools - Sign

- [Supply Chain Security Tools - Sign](scst-sign/overview.md) is deprecated. For migration information, see [Migration From Supply Chain Security Tools - Sign](./scst-policy/migration.hbs.md).

#### <a id="1-3-tbs-deprecations"></a> Tanzu Build Service

- The Ubuntu Bionic stack is deprecated:
Ubuntu Bionic stops receiving support in April 2023.
VMware recommends you migrate builds to Jammy stacks in advance.
For how to migrate builds, see [Use Jammy stacks for a workload](tanzu-build-service/dependencies.md#using-jammy).
- The Cloud Native Buildpack Bill of Materials (CNB BOM) format is deprecated:
It is still activated by default in Tanzu Application Platform v1.3 and v1.4.
VMware plans to deactivate this format by default in Tanzu Application Platform v1.5
and remove support in Tanzu Application Platform v1.6.
To manually deactivate legacy CNB BOM support, see [Deactivate the CNB BOM format](tanzu-build-service/install-tbs.md#deactivate-cnb-bom).

##### <a id="1-3-apps-plugin-deprecations"></a> Tanzu CLI Apps plug-in

- The `tanzu apps workload update` command is deprecated in the `apps` CLI plug-in. Please use `tanzu apps workload apply` instead.
  - `update` is deprecated in two Tanzu Application Platform releases (in Tanzu Application Platform v1.5.0) or in one year (on Oct 11, 2023), whichever is later.
