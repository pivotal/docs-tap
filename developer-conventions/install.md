---
title: Install
subtitle: How to install the Developer Conventions
weight: 2
---

This topic explains how to install the Developer Conventions.

## Prerequisites

This relies on the Convention Controller v0.3.0. The developer conventions currently only works for Java apps that have the spring-boot-devtools installed.

---

## Installing from Tanzu Package Install

Developer Conventions is released as a Tanzu Package. Please follow the instructions [here](../install.md).

## Installing from imgpkg bundle
You can also install as a imgpkg bundle. 

Download the release tarball from the [releases page](https://github.com/vmware-tanzu-private/developer-conventions/releases)  
and extract the yaml needed for deployment by relocating via a registry. 
```
export REGISTRY=<your-registry-here>
imgpkg copy --tar <path-to-tarball> --to-repo "${REGISTRY}/developer-conventions"
mkdir -p developer-conventions
imgpkg pull -b "${REGISTRY}/developer-conventions" -o developer-conventions
```

Skip this step if images are accessible from the Kubernetes Cluster. If the images are relocated to a private registry then
developer conventions ships with a placeholder secret called 'reg-creds' allowing you to create a real secret and secretexport 
as per these [instructions](https://carvel.dev/kapp-controller/docs/latest/private-registry-auth/#bringing-it-all-together).

Deploy the developer conventions server.
```
kapp deploy -a developer-conventions -n kube-system \
-f <(kbld -f developer-conventions/config/developer-conventions.yaml -f developer-conventions/.imgpkg/images.yml) -y
```

## Installing from source
You can also install directly from [source](https://github.com/vmware-tanzu-private/developer-conventions).
