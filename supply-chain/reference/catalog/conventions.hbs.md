# Conventions Component

## Description

This topic describes the Conventions component for Tanzu Supply Chain.

The Conventions component is a way to invoke the Convention Controller in a Tanzu Supply Chain.

The Conventions Controller is a sub component of Cartographer Conventions.

The Cartographer Conventions system is cmposed of the Convention Controller itself and any number of Convention servers.
For more information, see [Overview of Cartographer Conventions](../../../cartographer-conventions/about.hbs.md).

**Note** Conventions Controller is bundled with the Cartographer Conventions package for Tanzu Application Platform v1.8
but it will be in a dedicated package for Tanzu Application Platform v1.9.

## API

Component Input: `image`

Configuration Input: `spec.env` may contain an optional array of objects. Each object is a pair of keys: `name`
and either `value` or `valueFrom`. The Conventions component will translate these values into environment variables
in the output object. See below for more details.

Example:

```console
spec:
  source: TEST
  env:
  - name: TEST_KEY_1
    value: TEST_VALUE_1
  - name: TEST_KEY_2
    value: TEST_VALUE_2
  - name: TEST_KEY_3
    valueFrom:
      configMapKeyRef:
        name: "my_kubernetes_secret"
        key: "a_key_in_that_secret"

```

Component Output: `conventions`

OCI Output: An artifact in the OCI store. This artifact contains one file, `app-config.yaml`, with
a pod template spec.

## Dependencies

- Supply Chain
- Supply Chain Catalog
- Managed Resource Controller
- Tekton
- Conventions Controller

## Input Description

The Conventions component takes an `image` input from an earlier component in the supply chain. The component expects
the image to be provided as a reference to a runnable artifact in an OCI registry (i.e.: some image intended to be run
as a container in a pod), e.g.: `my.registry/my.project/my.image@sha256:digest`. The Conventions component passes this
image reference to the conventions controller to analyze.

## Output Description

The Conventions component produces a `conventions` output stored in an OCI registry referenced by the shared `oci-store`
`Secret`.  A reference to this image will be passed to subsequent components in the supply chain.

The output image contains a single file, `app-config.yaml`.  This file contains a Kubernetes Pod
Template Spec under a `template` field in YAML.  For example:

```yaml
template:
  spec:
    containers:
    - env:
      - name: TEST_KEY_1
        value: TEST_VALUE_1
      - name: TEST_KEY_2
        value: TEST_VALUE_2
      - name: TEST_KEY_3
        valueFrom:
          configMapKeyRef:
            name: "my_kubernetes_secret"
            key: "a_key_in_that_secret"
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

The Conventions controller passes the image reference to any conventions servers installed on the
cluster. Each server has the opportunity to further decorate the Pod template spec.

__Optional:__ In addition to the image field, the Conventions component can also copy the settings in the
configuration's `spec.env` into the Pod template's `env` field.  The `spec.env` field, if present, is expected to
contain an array of `name` and either `value` or `valueFrom` pairs.  You can use this feature to set environment
variables in any pods produced by the supply chain.

The format of the `value` and `valueFrom` matches that of the [Kubernetes Pod Template
Specification](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#environment-variables-1).

Here is an example supply chain instance with three environment variables.  Two variables are set literally with `value`
fields and the third comes from a `ConfigMap`:

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
  - name: TEST_KEY_3
    valueFrom:
      configMapKeyRef:
        name: "my_kubernetes_configuration"
        key: "a_key_in_that_configmap"
```

The Conventions component also provides a default security context and service account.

