# Output Types

{{> 'partials/supply-chain/beta-banner' }}

This section describes the common types established in Tanzu Supply Chain Components, their purpose and their
structure. Use this as a guide to consuming or emitting types from your own custom Components.

## Config

...description...

* Name: config
* URL: what the url points to
* Digest: what the digest is based on

### Structure (optional)

...detail about the content found at the url...

## Conventions

This output image contains a single file: `app-config.yaml`. The `template` field in this file contains a Kubernetes
Pod Template Spec, decorated by the Conventions controller. The Conventions component can also copy the settings in the
configurations `spec.env` into the Pod template's `env` field.

* Name: conventions
* URL: OCI image URL containing the `app-config.yaml` file
* Digest: OCI image digest containing the `app-config.yaml` file

## Git PR

Output for a Git pull request.

* Name: git-pr
* URL: url of the pull request
* Digest: sha digest of the pull request commit

## Image

## OCI YAML Files

An OCI image containing Kubernetes resource(s) as YAML files.

The resources in this OCI image can be applied to a cluster with no modifications.

The purpose of this OCI image type is to provide the raw Kubernetes resources required to deploy an application onto a cluster.

* Name: oci-yaml-files
* URL: OCI image URL
* Digest: OCI image digest

## OCI ytt files

An OCI image containing files written in the [ytt](https://carvel.dev/ytt) templating language.

The files in this OCI image cannot be applied to a cluster, and are intended to be combined with Kubernetes resources from oci-yaml-files.

The purpose of this OCI image type is to provide the ytt Values Schema and Overlays that make a Carvel Package configurable. Separating the ytt files from the raw Kubernetes resources makes the app-config-* components more generally useful. If a Supply Chain author wanted to create a Supply Chain that simply deploys the raw Kubernetes YAML files created by the app-config-* components, instead of putting them into a Carvel Package, they could write a component that takes the input oci-yaml-files, and not the input oci-ytt-files.

* Name: oci-yaml-files
* URL: OCI image URL
* Digest: OCI image digest

## Package

An OCI image containing a Carvel Package, PackageInstall, and Values YAML file.

The resources in this OCI image can either be deployed to a cluster, or written to a git repository for use in a GitOps workflow.

The purpose of this OCI image type is to contain a single version of an application as a Carvel Package, as well as the PackageInstall and Values YAML necessary to deploy the Package.

* Name: package
* URL: OCI image URL
* Digest: OCI image digest

## Source

An OCI image containing the source code retrieved from a git repository.

* Name: source
* URL: OCI image URL for the git repository source code
* Digest: OCI image digest for the git repository source code

* Name: git
* URL: The source code git repository URL
* Digest: The source code git commit sha
