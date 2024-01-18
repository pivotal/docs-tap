# Supply-chain Levels for Software Artifacts (SLSA) with Tanzu Build Service

This topic tells you how to configure Tanzu Build Service to generate SLSA attestations for image resources and how you
can view the attestation and verify the signature.

Tanzu Build Service supports generating [SLSA v1 attestations](https://slsa.dev/spec/v1.0/). Tanzu Build Service can
achieve [SLSA security levels](https://slsa.dev/spec/v1.0/levels) up to `L3` depending on how the installation and
workload is configured. For more information, see the [SLSA security levels section](#security-levels).

For more technical information and details on specifics of how kpack handles SLSA, see the
[open source documentation](https://github.com/buildpacks-community/kpack/blob/main/docs/slsa.md).

## <a id="enable-slsa"></a> Enabling SLSA attestation

Tanzu Build Service does not generate SLSA attestation be default. To enable this behaviour, set the
`generate_slsa_attestation` key to `true` in your `tap-values.yaml`:

```yaml
buildservice:
    generate_slsa_attestation: true
```

## <a id="security-levels"></a> SLSA security levels in Tanzu Build Service

This section documents how Tanzu Build Service adheres to each SLSA security level.

### <a id="L0"></a> Build L0

Specification: https://slsa.dev/spec/v1.0/levels#build-l0-no-guarantees

This is the default level in Tanzu Build Service and Tanzu Application Platform because attestations are not generated
unless configured [during installation](#enable-slsa).

### <a id="L1"></a> Build L1

Specification: https://slsa.dev/spec/v1.0/levels#build-l1-provenance-exists

This is the level Tanzu Build Service and Tanzu Application Platform achieves if SLSA generation is enabled.
- The build process is consistent and an example app with expected output can be found in the [How-to guides for
  developers](../getting-started/deploy-first-app.md).
- Steps for viewing the generated provenance can be found below.
- The provenance generated is complete, it is just unsigned.

### <a id="L2"></a> Build L2

Specification: https://slsa.dev/spec/v1.0/levels#build-l2-hosted-build-platform

This is the level Tanzu Build Service and Tanzu Application Platform achieves if SLSA generation is enabled and a
signing key is attached to the Service Account of the workload.
- All builds executed by Tanzu Build Service occurs on a dedicated Kubernetes cluster, not an individual's workstation.
- Verifying the attestation signature is documented in the [section below](#verfiy-signature)

### <a id="L3"></a> Build L3

Specification: https://slsa.dev/spec/v1.0/levels#build-l3-hardened-builds

This is the level Tanzu Build Service and Tanzu Application Platform achieves if SLSA generation is enabled and a
signing key is attached to the Service Account of the workload.
- Builds are isolated from each other by using a different Kubernetes pod per build process.
- Signing keys are only readable by Tanzu Build Service system resources and can not be accessed in any user defined
  build steps (including custom Buildpacks, custom Stacks, and custom Builders).
- Additional Kubernetes Role Based Access Control (RBAC) can be used to secure the signing keys at the cluster level.

## <a id="prereqs"></a> Prerequisites

Before you can configure Tanzu Build Service to sign your image builds, you must:

- Install Tanzu Application Platform with either the Full, Iterate, or Build profile with [SLSA attestation enabled](#enable-slsa).
If you have not installed Tanzu Application Platform, see [Installing Tanzu Build Service](install-tbs.md).

- Install jq. For instructions, see the [jq documentation](https://jqlang.github.io/jq)

- To view and verify signed attestations, install Cosign. For instructions, see the
[Cosign documentation](https://github.com/sigstore/cosign#installation).

- To view unsigned attestations, install Crane. For instructions, see the
[Crane documentation](https://github.com/google/go-containerregistry/blob/main/cmd/crane/README.md).

- Ensure you have access to the `base64` and `awk` commands, these should come pre-installed on every macOS and linux machine.

- Have a [Builder or ClusterBuilder](https://docs.vmware.com/en/Tanzu-Build-Service/1.12/vmware-tanzu-build-service/managing-builders.html)
  resource configured.

## <a id="attestation-location"></a> Location of the attestation

The tag of the attestation image is predictable from the digest of the app (aka attested) image.

If the digest of your app (attested) image is `index.docker.io/your-project/app@sha256:1234`, the tag of your
attestation image is `index.docker.io/your-project/app:sha256-1234.att`.

### <a id="reproducible-builds"></a> Reproducible builds

Tanzu Build Service supports reproducible builds, this means that it is possible for a build to generate the exact same
bit-for-bit image as a previous run. This is most likely to occur if a build is manually retriggered, but may also
automatically occur as part of a dependency bump.

In these cases, because the image is bit-for-bit identical (i.e. the same digest) as the previous image, the tag of the
attestation image will overlap. In this scenario, the newer attestation will overwrite the older attestation. To view the
older attestation, the digest of the attestation image is exposed in the status of the Build resource under the key
`.status.latestAttestationImage`. You can retrieve this by running:

```console
kubectl get builds.kpack.io BUILD-NAME -o yaml
```

Where:

- `BUILD-NAME` is the name of the Build. It is usually in the form `IMAGE-NAME-build-N`.

The expected output is similar to the following:

```yaml
apiVersion: kpack.io/v1alpha2
kind: Build
...
status:
  ...
  latestAttestationImage: index.docker.io/your-project/app@sha256:1234
```


## <a id="unsigned-attestation"></a> Creating unsigned attestations (SLSA L0)

If Tanzu Build Service was installed with [SLSA attestation enabled](#enable-slsa), every app image built by TBS will
generate a second image where the attestation is stored.

### <a id="build-image"></a> Building the image

No action is required to configure the Image or Workload resource. To learn how to create an app, see the
[Workload configuration documentation](tbs-workload-config.md)

### <a id="view-attestation"></a> Viewing the attestation

```console
crane export ATTESTATION-TAG | jq --raw-output '.payload' | base64 --decode | jq
```

Where:

- `ATTESTATION-TAG` is the tag [derived from the app image's digest.](#attestation-location)

For more documentation on the details of the attestation, see https://github.com/buildpacks-community/kpack/blob/main/docs/slsa_build.md.

For an example of expected output, see https://github.com/buildpacks-community/kpack/blob/main/docs/slsa_build.md#examples

## <a id="signed-attestation"></a> Creating signed attestations (SLSA L3)

If the ServiceAccount of the Workload has a Secret with a signing key attached, Tanzu Build Service will automatically
sign the generated attestation.

### <a id="configure-signing-key"></a> Generating and saving the signing key

1. Use the cosign CLI to generate the Kubernetes Secret:

    ```console
    cosign generate-key-pair k8s://NAMESPACE/COSIGN-KEYPAIR-NAME
    ```

    Where:

    - `NAMESPACE` is the namespace to store the Kubernetes secret in.
    - `COSIGN-KEYPAIR-NAME` is the name of the Kubernetes secret.

    You will also see a `cosign.pub` file in your current directory. Keep this file as you will need it to verify the
    signature of the images that are built.

1. Annotate the Secret to use it for signing SLSA attestations. Tanzu Build Service will only consider secrets with the
   annotation `kpack.io/slsa: ""` for signing:

   ```console
   kubectl annotate secret COSIGN-KEYPAIR-NAME 'kpack.io/slsa='
   ```

1. Attach the Secret to the ServiceAccount:

    ```console
    kubectl patch serviceaccount SERVICE-ACCOUNT-NAME -p '{"secrets":[{"name":"COSIGN-KEYPAIR-NAME"}]}'
    ```

    Where:

    - `SERVICE-ACCOUNT-NAME` is the name of the Service Account that will be used by the Workload.

### <a id="build-image"></a> Building the image

No action is required to configure the Image or Workload resource. To learn how to create an app, see the
[Workload configuration documentation](tbs-workload-config.md)

### <a id="verify-signature"></a> Verifying the attestation signature

Because Cosign operates on the tag-based discovery, only the latest attestation for a reproducible build may be viewed.
For more information, see the [section on reproducible builds](#reproducible-builds)

1. To verify the signature of the attestation:

    ```console
    cosign verify-attestation --insecure-ignore-tlog=true --key PUBLIC-KEY --type=slsaprovenance1 APP_IMAGE_DIGEST 2> /dev/null
    ```

    Where:

    - `PUBLIC-KEY` is either k8s://NAMESPACE/COSIGN-KEYPAIR-NAME from [configuring the signing key](#configure-signing-key),
    or the path to the cosign.pub that was generated.
    - `APP_IMAGE_DIGEST` is digest of the image built by the Workload.

    The expected output is similar to the following:

    ```console
    Verification for index.docker.io/your-project/app@sha256:1234... --
    The following checks were performed on each of these signatures:
      - The cosign claims were validated
      - The signatures were verified against the specified public key
    ```

1. (Optional) To view the generated attestation:

    ```console
    cosign verify-attestation --insecure-ignore-tlog=true --key PUBLIC-KEY --type=slsaprovenance1 APP_IMAGE_DIGEST | jq --raw-output '.payload' | base64 --decode | jq
    ```

    For more documentation on the details of the attestation, see https://github.com/buildpacks-community/kpack/blob/main/docs/slsa_build.md.

    For an example of expected output, see https://github.com/buildpacks-community/kpack/blob/main/docs/slsa_build.md#examples
