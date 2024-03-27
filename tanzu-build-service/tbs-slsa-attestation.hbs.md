# Generate Supply-chain Levels for Software Artifacts attestations with Tanzu Build Service

This topic tells you how to configure Tanzu Build Service to generate Supply-chain Levels for Software
Artifacts (SLSA) attestations for image resources. It also describes how you can view the attestation
and verify the signature.

## <a id="security-levels"></a> About SLSA security levels in Tanzu Build Service

Tanzu Build Service supports generating [SLSA v1 attestations](https://slsa.dev/spec/v1.0/).
Tanzu Build Service can achieve [SLSA security levels](https://slsa.dev/spec/v1.0/levels)
up to `L3` depending on how the installation and workload is configured.
This section documents how Tanzu Build Service adheres to each SLSA security level.

For more technical details about how kpack handles SLSA, see the
[kpack documentation](https://github.com/buildpacks-community/kpack/blob/main/docs/slsa.md) in GitHub.

### <a id="L0"></a> Build L0

**Specification:** [Build L0: No guarantees](https://slsa.dev/spec/v1.0/levels#build-l0-no-guarantees)

This is the default level in Tanzu Build Service and Tanzu Application Platform because attestations
are not generated unless configured for your installation.

### <a id="L1"></a> Build L1

**Specification:** [Build L1: Provenance exists](https://slsa.dev/spec/v1.0/levels#build-l1-provenance-exists)

This is the level Tanzu Build Service and Tanzu Application Platform achieve if SLSA generation is
enabled.

- The build process is consistent. You can see an example app with expected output in
  [Deploy an app on Tanzu Application Platform](../getting-started/deploy-first-app.hbs.md).
- The provenance generated is complete, but it is unsigned.
- To view the generated provenance, see [View the attestation](#view-attestation)
  later in this topic.

### <a id="L2"></a> Build L2

**Specification:** [Build L2: Hosted build platform](https://slsa.dev/spec/v1.0/levels#build-l2-hosted-build-platform)

This is the level Tanzu Build Service and Tanzu Application Platform achieve if SLSA generation is
enabled and a signing key is attached to the service account of the workload.

- All builds executed by Tanzu Build Service occur on a dedicated Kubernetes cluster,
  not the user's workstation.
- To verify the attestation signature, see [Verify the attestation signature](#verify-signature).

### <a id="L3"></a> Build L3

Specification: [Build L3: Hardened builds](https://slsa.dev/spec/v1.0/levels#build-l3-hardened-builds)

This is the level Tanzu Build Service and Tanzu Application Platform achieve if SLSA generation is
enabled and a signing key is attached to the service account of the workload.

- Builds are isolated from each other by using a different Kubernetes pod per build process.
- Signing keys are only readable by Tanzu Build Service system resources. No user defined build
  steps, such as custom Buildpacks, custom Stacks, and custom Builders, can access the signing keys.
- You can use Kubernetes Role-Based Access Control (RBAC) to secure the signing keys at the cluster
  level.

## <a id="prereqs"></a> Prerequisites

Before you can configure Tanzu Build Service to sign your image builds, you must:

- [Install Tanzu Application Platform](../install-intro.hbs.md).

- If you did not install Tanzu Application Platform by using the Full, Iterate, or Build profile,
  install the Tanzu Build Service package. See [Installing Tanzu Build Service](install-tbs.md).

- Install jq. For instructions, see the [jq documentation](https://jqlang.github.io/jq).

- To view and verify signed attestations, install Cosign. For instructions, see the
  [Cosign documentation](https://github.com/sigstore/cosign#installation).

- To view unsigned attestations, install Crane. For instructions, see the
  [Crane documentation](https://github.com/google/go-containerregistry/blob/main/cmd/crane/README.md).

- Ensure that you have access to the `base64` and `awk` commands. These commands are pre-installed on every
  macOS and Linux machine.

- Have a Builder or ClusterBuilder resource configured. For instructions, see
  [Manage builders for Tanzu Build Service](https://docs.vmware.com/en/Tanzu-Build-Service/1.13/vmware-tanzu-build-service/managing-builders.html).

## <a id="enable-slsa"></a> Enable SLSA attestation

Tanzu Build Service does not generate SLSA attestation by default. To enable this behavior:

1. Set the `generate_slsa_attestation` key to `true` in your `tap-values.yaml`:

    ```yaml
    buildservice:
        generate_slsa_attestation: true
    ```

1. Apply the updated configuration by running:

    ```console
    tanzu package installed update tap \
      --package tap.tanzu.vmware.com \
      --version TAP-VERSION \
      --namespace tap-install \
      --values-file tap-values.yaml
    ```

    Where `TAP-VERSION` is the version of Tanzu Application Platform installed.

## <a id="unsigned-attestation"></a> Create unsigned attestations (SLSA L0)

If Tanzu Build Service has SLSA attestation enabled, every app image built by Tanzu Build Service generates a second
image where the attestation is stored.

### <a id="build-image-l0"></a> Build the image

No action is required to configure the Image or Workload resource. To learn how to create an app, see
[Configure Tanzu Build Service properties on a workload](tbs-workload-config.hbs.md).

### <a id="view-attestation"></a> View the attestation

To view the attestation, run:

```console
crane export ATTESTATION-TAG | jq --raw-output '.payload' | base64 --decode | jq
```

Where `ATTESTATION-TAG` is the tag derived from the app image's digest.
For more information, see [Location of the attestation](#attestation-location) later in this topic.

For more information about the attestation, see the [kpack documentation](https://github.com/buildpacks-community/kpack/blob/main/docs/slsa_build.md).

For an example of expected output, see the [kpack documentation](https://github.com/buildpacks-community/kpack/blob/main/docs/slsa_build.md#examples).

## <a id="signed-attestation"></a> Create signed attestations (SLSA L3)

If the service account of the workload has a secret with a signing key attached, Tanzu Build Service
automatically signs the generated attestation.

### <a id="configure-signing-key"></a> Generate and save the signing key

To generate and save the signing key:

1. Use the cosign CLI to generate the Kubernetes secret:

    ```console
    cosign generate-key-pair k8s://NAMESPACE/COSIGN-KEYPAIR-NAME
    ```

    Where:

    - `NAMESPACE` is the namespace to store the Kubernetes secret in.
    - `COSIGN-KEYPAIR-NAME` is the name of the Kubernetes secret.

    You will see a `cosign.pub` file in your current directory. Keep this file as you need it to verify
    the signature of the images that are built.

1. Annotate the secret to use it for signing SLSA attestations by running:

   ```console
   kubectl annotate secret COSIGN-KEYPAIR-NAME 'kpack.io/slsa='
   ```

   Tanzu Build Service only considers secrets with the annotation `kpack.io/slsa: ""` for signing.

1. Attach the secret to the service account by running:

    ```console
    kubectl patch serviceaccount SERVICE-ACCOUNT-NAME -p '{"secrets":[{"name":"COSIGN-KEYPAIR-NAME"}]}'
    ```

    Where `SERVICE-ACCOUNT-NAME` is the name of the service account that the workload will use.

### <a id="build-image-l3"></a> Build the image

No action is required to configure the Image or Workload resources. To learn how to create an app, see
[Configure Tanzu Build Service properties on a workload](tbs-workload-config.md).

### <a id="verify-signature"></a> Verify the attestation signature

Because Cosign operates on the tag-based discovery, you can only view the latest attestation for a
reproducible build.
For more information, see [Reproducible builds](#reproducible-builds) later in this topic.

1. To verify the signature of the attestation, run:

    ```console
    cosign verify-attestation \
      --insecure-ignore-tlog=true \
      --key PUBLIC-KEY \
      --type=slsaprovenance1 APP-IMAGE-DIGEST > /dev/null
    ```

    Where:

    - `PUBLIC-KEY` is either `k8s://NAMESPACE/COSIGN-KEYPAIR-NAME` from
      [Generate and save the signing key](#configure-signing-key) earlier or the path to the `cosign.pub`
      that was generated.
    - `APP-IMAGE-DIGEST` is digest of the image that the workload built.

    Example output:

    ```console
    Verification for index.docker.io/your-project/app@sha256:1234... --
    The following checks were performed on each of these signatures:
      - The cosign claims were validated
      - The signatures were verified against the specified public key
    ```

1. (Optional) To view the generated attestation, run:

    ```console
    cosign verify-attestation \
      --insecure-ignore-tlog=true \
      --key PUBLIC-KEY \
      --type=slsaprovenance1 APP-IMAGE-DIGEST | jq \
      --raw-output '.payload' | base64 --decode | jq
    ```

    Where:

    - `PUBLIC-KEY` is either `k8s://NAMESPACE/COSIGN-KEYPAIR-NAME` from
      [Generate and save the signing key](#configure-signing-key) earlier or the path to the `cosign.pub`
      that was generated.
    - `APP-IMAGE-DIGEST` is the digest of the image that the workload built.

    For more information about the attestation, see the [kpack documentation](https://github.com/buildpacks-community/kpack/blob/main/docs/slsa_build.md).

    For an example of expected output, see the [kpack documentation](https://github.com/buildpacks-community/kpack/blob/main/docs/slsa_build.md#examples).

## <a id="attestation-location"></a> Location of the attestation

The tag of the attestation image is predictable from the digest of the app image.

If the digest of your app image is `index.docker.io/your-project/app@sha256:1234`, the tag
of your attestation image is `index.docker.io/your-project/app:sha256-1234.att`.

### <a id="reproducible-builds"></a> Reproducible builds

Tanzu Build Service supports reproducible builds. This means that it's possible for a build to
generate the exact same bit-for-bit image as a previous run.
This is most likely to occur if a build is manually re-triggered, but might also automatically occur
as part of a dependency upgrade.

In these cases, because the image is bit-for-bit identical and has the same digest as the previous image,
the tag of the attestation image overlaps.
In this scenario, the newer attestation overwrites the older attestation.

To view the older attestation, the digest of the attestation image is exposed in the status of the
Build resource under the key `.status.latestAttestationImage`. You can retrieve this by running:

```console
kubectl get builds.kpack.io BUILD-NAME -o yaml
```

Where `BUILD-NAME` is the name of the Build resource. It is usually in the format `IMAGE-NAME-build-N`.

Expected output:

```yaml
apiVersion: kpack.io/v1alpha2
kind: Build
...
status:
  ...
  latestAttestationImage: index.docker.io/your-project/app@sha256:1234
```
