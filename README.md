# Documentation Repository for Tanzu Application Platform (TAP)

## Overview

This repo contains the content for Tanzu Application Platform docs.

## Branches

|Branch|Staging|Production|
|------|-------|----------|
|main| [Staging](https://docs-staging.vmware.com/en/draft/VMware-Tanzu-Application-Platform/1.5/tap/overview.html) (Pre-release v1.5 docs)|n/a|
|1-4-2| [Staging](https://docs-staging.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/overview.html) | [Production](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/overview.html) |
|1-4-1|Not in use. Do not PR to this branch.|Not in use. Do not PR to this branch.|
|1-4-0|Not in use. Do not PR to this branch.|Not in use. Do not PR to this branch.|
|1-3-6| [Staging](https://docs-staging.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-overview.html) | [Production](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-overview.html) |
|1-3-5|Not in use. Do not PR to this branch.|Not in use. Do not PR to this branch.|
|1-3-4|Not in use. Do not PR to this branch.|Not in use. Do not PR to this branch.|
|1-3-3|Not in use. Do not PR to this branch.|Not in use. Do not PR to this branch.|
|1-3-2|Not in use. Do not PR to this branch.|Not in use. Do not PR to this branch.|
|1-3-1|Not in use. Do not PR to this branch.|Not in use. Do not PR to this branch.|
|1-3-0|No longer in use. Do not PR to this branch.|No longer in use. Do not PR to this branch.|
|1-2-2| [Staging](https://docs-staging.vmware.com/en/VMware-Tanzu-Application-Platform/1.2/tap/GUID-overview.html) | [Production](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.2/tap/GUID-overview.html) |
|1-2-1|No longer in use. Do not PR to this branch.|No longer in use. Do not PR to this branch.|
|1-2-0|No longer in use. Do not PR to this branch.|No longer in use. Do not PR to this branch.|
|1-2|No longer in use. Do not PR to this branch.|No longer in use. Do not PR to this branch.|
|1-1| [Staging](https://docs-staging.vmware.com/en/VMware-Tanzu-Application-Platform/1.1/tap/GUID-overview.html) | [Production](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.1/tap/GUID-overview.html) |
|1-0| [Staging](https://docs-staging.vmware.com/en/VMware-Tanzu-Application-Platform/1.0/tap/GUID-overview.html) | [Production](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.0/tap/GUID-overview.html) |

## Components with their own repositories

Some components have docs that introduce them in this repository, but the rest of their docs are
stored in dedicated repositories.

| Component | Repo |
|-----------|------|
| API Auto Registration | https://gitlab.eng.vmware.com/tap-api-first/api-auto-registration |
| API portal | https://github.com/pivotal-cf/docs-api-portal |
| Application Configuration Service | https://github.com/pivotal-cf/docs-application-configuration-service |
| Carvel | https://github.com/vmware-tanzu/carvel/tree/develop/site/content |
| Cloud Native Runtimes | https://gitlab.eng.vmware.com/daisy/cloud-native-runtimes-for-vmware-tanzu |
| Services Toolkit | https://gitlab.eng.vmware.com/services-control-plane/documentation |
| Spring Cloud Gateway | https://github.com/pivotal-cf/docs-scg-k8s |
| Tanzu Build Service | https://github.com/pivotal-cf/docs-build-service/tree/v1.5 |

## Component name list

|Full Name|Short Name|
|---------|-----------|
|API Auto Registration|API Auto Registration|
|API portal for VMware Tanzu|API portal|
|API Scoring and Validation|API Scoring and Validation|
|Application Accelerator for VMware Tanzu|Application Accelerator|
|Application Configuration Service for VMware Tanzu|Application Configuration Service|
|Application Live View|Application Live View|
|Application Single Sign-On for VMware Tanzu|Application Single Sign-On|
|Cartographer Conventions|Cartographer Conventions|
|cert-manager|cert-manager|
|Cloud Native Runtimes for VMware Tanzu|Cloud Native Runtimes|
|Contour|Contour|
|Convention Service for VMware Tanzu|Convention Service|
|Developer Conventions|Developer Conventions|
|Eventing|Eventing|
|FluxCD Source Controller|FluxCD Source Controller|
|Tanzu Learning Center|Learning Center|
|Namespace Provisioner|Namespace Provisioner|
|Service Bindings|Service Bindings|
|Services Toolkit for VMware Tanzu Application Platform|Services Toolkit|
|Source Controller|Source Controller|
|Spring Boot conventions|Spring Boot conventions|
|Spring Cloud Gateway for Kubernetes|Spring Cloud Gateway|
|Supply Chain Choreographer|Supply Chain Choreographer|
|Supply Chain Security Tools for VMware Tanzu - Policy Controller|Supply Chain Security Tools - Policy Controller (SCST - Policy Controller)|
|Supply Chain Security Tools for VMware Tanzu - Scan|Supply Chain Security Tools - Scan (SCST - Tools)|
|Supply Chain Security Tools for VMware Tanzu - Sign|Supply Chain Security Tools - Sign (SCST - Sign)|
|Supply Chain Security Tools for VMware Tanzu - Store|Supply Chain Security Tools - Store (SCST - Store)|
|Tanzu Application Platform GUI|Tanzu Application Platform GUI|
|Tanzu Application Platform Telemetry|Tanzu Application Platform Telemetry|
|Tanzu Build Service|Tanzu Build Service|
|VMware Tanzu Developer Tools for IntelliJ|Tanzu Developer Tools for IntelliJ|
|VMware Tanzu Developer Tools for Visual Studio|Tanzu Developer Tools for Visual Studio|
|VMware Tanzu Developer Tools for Visual Studio Code|Tanzu Developer Tools for VS Code|
|VMware Tanzu Application Platform Pipeline service with Tekton|Tekton Pipelines|

### Using names for components other than Supply Chain Security Tools

- Use the short component name in the Table of Contents, Release Notes headers, and Components page
  headers.
- Use full name where one exists on the first occurrence in the component page description,
  and the first occurrence in the actual component doc, and then use the short name elsewhere.

### Using names for the Supply Chain Security Tools components

- Use the short name in the Table of Contents, Release Notes headings, and Components page headers.
- Use the short name on the first occurrence in the component page description, and the first
  occurrence in the actual component doc, and then use the initialism after this.

## Word List

Use this table to keep a running list of terms used and how they should be defined.

| Word or phrase | Explanation |
|----------------|-------------|
| components | The individual products available in the TAP SKU. For example, Cloud Native Runtimes is a component of TAP: it's not an add-on or a capability.|
| convention controller | Lowercase; this is one of the minor components that make up Convention Service |
| convention server | Lowercase; this is one of the minor components that make up Convention Service |
| Default Supply Chain | singular |
| kubectl| First use in a topic: Kubernetes command-line tool (kubectl). Subsequent uses: kubectl. |
| Tanzu Insight | This CLI plug-in is named simply Insight in the v1.0 documentation because it is separate from the Tanzu CLI |
| packageRepository | Is a definition. Variations found in original doc (Package repository, PackageRepository, packagerepository) but standardize on the one shown. 2021.08.26 |
| PackageRepositories | Don't use. There is really only one packageRepository of interest for this page. |
| packageRepository custom resource | Because we don't use CR in other Kubernetes docs, spell out custom resource here too. An example of the packageRepository custom resource is given in the YAML file named `tap-package-repo.yaml`.|
| packageRepository pull | Just means pulling the packages from the repository|
| Tanzu Kubernetes Grid | Never use TKGm or TKG in customer-facing documentation. |
| TAP repo bundle | Decided on lowercase and not "TAP Repo Bundle".|
| TAP packages | Right now there are three packages: one for each component. The three packages make up the bundle. The bundle is stored in the the TAP package repository. Although "Tanzu Application Platform packages" is in the original Google doc, let's use "TAP packages" for consistency.|
| TAP package repository |  How is this different from the other package repositories? (Are there non-TAP package repositories discussed on this page?) Changed from TAP to Tanzu Application Platform, Sept 24, 2021.|
| .yaml and YAML file | Standardize on using the "a", not `.yml` |

## Other style stuff

Top tips:

- Keep line lengths short, around 110 chars.
- Start each sentence on its own line. Markdown only creates new paragraphs after a blank line.
- Writer headers in sentence case, not title case.
- UI elements are bolded and the widget type not mentioned.
  For example, Click **NEXT STEPS**.
- Outside of code, Kubernetes API objects are written in lowercase and the words are separated by
  spaces, like for other common nouns. This is in contrast to the Kubernetes docs, where upper camel
  case is sometimes used and sometimes not.

## Autogenerated Docs

If a doc file is autogenerated, any direct edits are overwritten at the next autogeneration event.
The files in these folders are autogenerated:

- scst-store/cli_docs

### Prepare Markdown Files

- Markdown files live in this repo.
- Each page requires an entry in [toc.md](docs/toc.md) for the table of contents.
- Place images in an `images` directory at the same level. Use relative links for images in the docs.

## Troubleshooting Markdown

| Problem | List displays as a paragraph |
|---------|-----------|
| Symptom| Bulleted or numbered lists look fine on GitHub but display as a single paragraph in HTML.|
| Solution| Add a blank line after the stem sentence and before the first item in the list.|

| Problem | List numbering is broken: every item is `1.` |
|---------|-----------|
| Symptom| Each numbered item in a list is a `1.` instead of `1.`, `2.`, `3.`, etc|
| Solution| Try removing any blank newlines within each step.|

## Creating a Pull Request

To create a pull request, see [Creating pull requests and merge requests](https://confluence.eng.vmware.com/display/MIX/Creating+pull+requests+and+merge+requests)
in Confluence.

## Publishing Docs

The writers publish the docs, and they use:

- [DocWorks](https://docworks.vmware.com/), which is the main tool for managing docs.
- [Docs Dashboard](https://docsdash.vmware.com/), which is a deployment UI for promoting docs from
  staging to pre-prod to production.

### Landing Page and Publications

General information about landing pages:

- Every product has a landing page
- The landing page is a container for all the publications for a product.
- Some products, such as
  [Tanzu Kubernetes Grid](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/index.html),
  publish separate release notes publications for each point release.
  For comparison see https://docs.vmware.com/en/VMware-Tanzu-Application-Catalog/index.html

## Partials

For information about how we use partials, see our
[Working with partials Confluence page](https://confluence.eng.vmware.com/display/MIX/Working+with+TAP+partials).
