# Conventions Component

## Description

This document describes the Conventions Component for Tanzu Supply Chains.  The Conventions Component is a way to invoke
the Conventions Controller in a Tanzu Supply Chain.  Please see the [Conventions Controller](../../cartographer-conventions/about.hbs.md)
documentation itself for more details on the Conventions Controller service itself.

## API

_Component Input_: `image`

_Workload Input_: `spec.env` may contain an optional array of objects. Each object is a pair of keys: `name` and `value`.
The Conventions Component will translate these values into environment variables in the output object.

spec:
  source: TEST
  env:
  - name: TEST_KEY_1
    value: TEST_VALUE_1
  - name: TEST_KEY_2
    value: TEST_VALUE_2

_Component Output_: `conventions`

_OCI Output_: An artifact in the OCI store. This artifact contains one file, `app-config.yaml`, with a pod template spec.

## Dependencies

* Supply Chain
* Supply Chain Catalog
* Managed Resource Controller
* Tekton
* Conventions Controller

__Note__ that the Conventions Controller application is bundled with the "Cartographer" package for TAP 1.8.  The
Conventions Controller application will be bundled in its own package for TAP 1.9.

## Input Description

The Conventions Component takes an `image` input from some earlier component in the supply chain. The component expects
the image to be provided as a reference to a runnable artifact in an OCI registry (i.e.: some image intended to be run
as a container in a pod), e.g.: `my.registry/my.project/my.image@sha256:digest`.  The Conventions Component will pass this
image reference to the Conventions Controller to analyze.

## Output Description

The Conventions Component produces a `conventions` output stored in an OCI registry referenced by the shared `oci-store`
`Secret`.  A reference to this image will be passed to subsequent components in the supply chain.

The output image contains a single file, `app-config.yaml`.  This file contains a Kubernetes Pod Template Spec under a
`template` field in YAML.  For example:

```yaml
template:
  spec:
    containers:
    - env:
      - name: TEST_KEY_1
        value: TEST_VALUE_1
      - name: TEST_KEY_2
        value: TEST_VALUE_2
      image: my-image@sha256:digest
      name: workload
      resources: {}
      securityContext:
        allowPrivilegeEscalation: false
        capabilities:
          drop:
          - ALL
        runAsNonRoot: true
        runAsUser: 1001
        seccompProfile:
          type: RuntimeDefault
    serviceAccountName: default
```

The `image` from the component input is echoed in the `template.spec.containers[0].image` field.

The Conventions Controller passes the image reference to any Conventions servers installed on the cluster.  Each server has
the opportunity to further decorate the Pod template spec.  Installing and configuring the Conventions Controller and
Conventions servers is beyond the scope of this document.  Please refer to the documentation for the
[Conventions Controller](../../cartographer-conventions/about.hbs.md) and the various Conventions servers themselves.

__Optional:__ In addition to the image field, the Conventions Component can also add the settings in the Workload's
`spec.env` into the Pod template's `env` field.  The `spec.env` field, if present, is expected to contain an array of
`name`/`value` pairs.  You can use this feature to set environment variables in any pods produced by the supply chain.

Example workload with two environment variables:

```yaml
apiVersion: widget.com/v1alpha1
kind: conventiontest
metadata:
  name: my-app
  namespace: conventions-component
spec:
  source: TEST
  env:
  - name: TEST_KEY_1
    value: TEST_VALUE_1
  - name: TEST_KEY_2
    value: TEST_VALUE_2
```

The Conventions Component also provides a default security context and service account.

