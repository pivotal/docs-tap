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

- [Events are now emitted](scc/events.hbs.md) when resources are being applied, or their output or health status changed.
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

### <a id='1-4-0-breaking-changes'></a> Breaking changes
This release has the following breaking changes, listed by area and component.

#### <a id="1-4-0-vscode-bc"></a> Tanzu Developer Tools for Visual Studio Code

- `Tanzu Debug` no longer port forwards the application port (8080).

#### <a id="1-4-0-scst-scan-bc"></a> Supply Chain Security Tools - Scan
- Removed deprecated ScanTemplates:
  - Deprecated Grype ScanTemplates shipped with versions prior to TAP 1.2.0 have been removed and are no longer supported. Please ensure you are using Grype ScanTemplates v1.2+ moving forward.
- Deprecation notice:
  - `docker` field and related sub-fields by Supply Chain Security Tools - Scan are deprecated and marked for removal in TAP 1.7.0.
  - The deprecation will impact the following components: Scan Controller, Grype Scanner and Snyk Scanner.
  - See [troubleshooting](/scst-scan/observing.hbs.md#unable-to-pull-scanner-controller-images) documentation for the migration path.

#### <a id="1-4-0-ipw-bc"></a> Supply Chain Security Tools - Image Policy Webhook

The Image Policy Webhook component is removed in TAP 1.4 after being deprecated
in favor of the [Policy Controller](./scst-policy/overview.hbs.md)

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
