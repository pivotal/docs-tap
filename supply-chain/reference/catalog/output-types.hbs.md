# Output types for catalog components

This section describes the common types established in Tanzu Supply Chain Components, their purpose
and their structure. Use this as a guide to consuming or emitting types from your own custom Components.

{{> 'partials/supply-chain/beta-banner' }}
## conventions

**URL**: OCI image containing the `app-config.yaml` file.<br/>
**Digest**: OCI image digest<br/>

This output image contains a single file: `app-config.yaml`. The `template` field in this file contains a Kubernetes
Pod Template Spec, decorated by the Conventions controller. The Conventions component can also copy the settings in the
configurations `spec.env` into the Pod template's `env` field.

## git

**URL**: The source code Git repository URL.</br>
**Digest**: The source code git commit sha.</br>

## git-pr

**URL**: URL of the pull request.</br>
**Digest**: SHA digest of the pull request commit.</br>

Output for a Git pull request.

## image
**URL**: OCI image URL for the image built with kpack.<br/>
**Digest**: OCI image digest<br/>

An OCI image containing the app built with kpack.

## oci-yaml-files

**URL**: An OCI image containing Kubernetes resource(s) as YAML files.</br>
**Digest**: OCI image digest.</br>

The resources in this OCI image can be applied to a cluster with no modifications.

The purpose of this OCI image type is to provide the raw Kubernetes resources required to deploy an application onto a cluster.

## oci-ytt-files

**URL**: An OCI image containing files written in the [ytt](https://carvel.dev/ytt) templating language.</br>
**Digest**: OCI image digest</br>
 
The files in this OCI image cannot be applied to a cluster, and are intended to be combined with Kubernetes resources from oci-yaml-files.

The purpose of this OCI image type is to provide the ytt Values Schema and Overlays that make a Carvel Package configurable.
Separating the ytt files from the raw Kubernetes resources makes the app-config-* components more generally useful.
If a Supply Chain author wanted to create a Supply Chain that simply deploys the raw Kubernetes YAML files created by the app-config-* components, instead of putting them into a Carvel Package, they could write a component that takes the input oci-yaml-files, and not the input oci-ytt-files.

## package
 
**URL**: An OCI image containing a Carvel Package, PackageInstall, and Values YAML file.</br>
**Digest**: OCI image digest.</br>

The resources in this OCI image can either be deployed to a cluster, or written to a Git repository for use in a GitOps workflow.

The purpose of this OCI image type is to contain a single version of an application as a Carvel Package, as well as the PackageInstall and Values YAML necessary to deploy the Package.

## source

**URL**: OCI image containing the Git repository source code.</br>
**Digest**: OCI image digest.</br>

An OCI image containing the source code retrieved from a Git repository.
