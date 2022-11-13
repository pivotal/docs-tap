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

#### <a id="1-4-0-tap-gui-plugin-nf"></a> Tanzu Application Platform GUI Plug-ins

#### <a id='scc-plug-in-new-features'></a>Supply Chain Choreographer Plug-in

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

### <a id='1-4-0-security-fixes'></a> Security fixes

This release has the following security fixes, listed by area and component.

### <a id='1-4-0-resolved-issues'></a> Resolved issues

The following issues, listed by area and component, are resolved in this release.

#### <a id="1-4-0-tap-gui-plugin-ri"></a> Tanzu Application Platform GUI Plug-ins

#### <a id="supply-chain-plugin-ri"></a> Supply Chain Choreographer Plug-In

- The UI no longer shows the error `Unable to retrieve details from Image Provider Stage` when the
  Builder is not available or configured. It now correctly shows the same error as the CLI,
  `Builder default is not ready`.

### <a id='1-4-0-known-issues'></a> Known issues

This release has the following known issues, listed by area and component.
