---
title: Release Notes for Tanzu Dev Tools for VSCode
subtitle: Release Notes for Tanzu Dev Tools for VSCode
weight: 2
---

# Release notes

This topic contains release notes for the VMWare Tanzu Developer Tools for Visual Studio Code extension.

## <a id='0.5.0'></a> v0.5.0

**Release Date**: January 11, 2022

### Bug Fixes
- Fixed issue where the Tanzu Dev Tools extension could not support projects with multi-document YAML files
- Modified debug to remove any leftover port-forwards from past runs

## <a id='0.4.0'></a> v0.4.0

**Release Date**: December 13, 2021

### Features
- Bumped support for Tilt to 0.23.2 by removing the reference to the running image in the Tiltfile and requiring `container_selector` argument
- Added Code Snippets to help users create config files to enable existing projects to be deployable on TAP. Helps user generate workload.yaml, Tiltfile, and catalog-info.yaml files.
- Improved error handling & messaging for the following cases:
    - Tilt is not installed on the developer's machine
    - The incorrect version of Tilt is installed
    - Missing source image in Tanzu settings

### Bug Fixes
- Added a "wait" service which prevents user from using the live update & debug capabilities until the deployment is up & running on the cluster. Fixes known issue from TAP 0.2.0 & 0.3.0.

## <a id='0.3.0'></a> v0.3.0

**Release Date**: November 8, 2021

### Features
- Improved landing page of extension

### Bug Fixes
- Bug fix in the Tanzu: Live Update Stop command that was not properly calling the stop task

## <a id='0.2.0'></a> v0.2.0

**Release Date**: September 24, 2021

Initial release.

### Features
- Enable developers to see their code live update on the cluster
- Enable developers to debug their code on the cluster