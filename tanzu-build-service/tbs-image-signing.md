# Tanzu Build Service with image signing

<!-- where should this page be in the TOC? -->

This topic describes how to create a Tanzu Build Service
[Image](https://docs.vmware.com/en/Tanzu-Build-Service/1.6/vmware-tanzu-build-service/GUID-managing-images.html)
resource to build a container image from source that is signed with
[Cosign](https://github.com/sigstore/cosign).
After completing these steps, you can configure
[Supply Chain Security Tools for VMware Tanzu - Policy Controller](../scst-policy/overview.md)
to ensure that only signed images are allowed in your cluster. <!-- is this an expected goal for users? -->

This topic builds upon the steps in the
[kpack Tutorial](https://github.com/pivotal/kpack/blob/main/docs/tutorial.md).

## <a id="prereqs"></a> Prerequisites

Before you can configure Tanzu Build Service to sign your image builds, you must:

- Install Tanzu Build Service. The Full, Iterate, and Build profiles include Tanzu Build Service.
If you have not installed Tanzu Application Platform with one of these profiles,
see [Installing Tanzu Build Service](install-tbs.md).

- Install Cosign. For instructions, see the [Cosign documentation](https://docs.sigstore.dev/cosign/installation/).

- Have a [Builder or ClusterBuilder](https://docs.vmware.com/en/Tanzu-Build-Service/1.6/vmware-tanzu-build-service/GUID-managing-builders.html)
resource configured.

- Have an [Image](https://docs.vmware.com/en/Tanzu-Build-Service/1.6/vmware-tanzu-build-service/GUID-managing-images.html)
resource configured.

## <a id="sign-image-builds"></a> Configure Tanzu Build Service to sign your image builds

To configure Tanzu Build Service to sign your image builds:

1. Ensure your in a Kubernetes context where you are authenticated and authorized to
create and edit the secret and service account resources.

1. Generate a cosign keypair and store it as a Kubernetes secret by running:

    ```bash
    cosign generate-key-pair k8s://NAMESPACE/SECRET-NAME
    ```

    Where:

    - `NAMESPACE` is the namespace to store the Kubernetes secret in.
    - `SECRET-NAME` is the name of the Kubernetes secret.

    For example:

    ```bash
    cosign generate-key-pair k8s://default/tutorial-cosign-key-pair
    ```

1. Enter a password for the private key. Enter any password you want.
After the command has completed successfully, you will see the following output:

    ```bash
    Successfully created secret tutorial-cosign-key-pair in namespace default
    Public key written to cosign.pub
    ```

    You will also see a `cosign.pub` file in your current directory.
    Keep this file as you will need it to verify the signature of the images built in this tutorial.

1. If you are using [Docker Hub](https://hub.docker.com/) or a registry that does not support OCI
media types, add the annotation `kpack.io/cosign.docker-media-types: "1"` to the cosign as follows:

    ```yaml
    apiVersion: v1
    kind: Secret
    type: Opaque
    metadata:
      name: tutorial-cosign-key-pair
      namespace: default
      annotations:
        kpack.io/cosign.docker-media-types: "1"
    data:
      cosign.key: PRIVATE-KEY-DATA
      cosign.password: COSIGN-PASSWORD
      cosign.pub: PUBLIC-KEY-DATA
    ```

    >**Note:** For more information about configuring Cosign keypairs, see the
    >[Tanzu Build Service documentation](https://docs.vmware.com/en/Tanzu-Build-Service/1.6/vmware-tanzu-build-service/GUID-managing-images.html#image-signing-with-cosign).

1. Create or modify the service account that is referenced in the Image resource
so that it includes the cosign keypair secret created earlier.

    Adding a Cosign secret to the service account that is referenced in an Image resource enables Cosign signing.

    ```yaml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: tutorial-cosign-service-account
      namespace: default
    secrets:
    - name: registry-credentials
    - name: tutorial-cosign-key-pair
    imagePullSecrets:
    - name: registry-credentials
    ```

1. Apply the service account to the cluster by running:

    ```bash
    kubectl apply -f cosign-service-account.yaml
    ```

1. Create an Image resource file named `image-cosign.yaml`:

    Note that this Image has references to `tutorial-cosign-service-account`.

    ```yaml
    apiVersion: kpack.io/v1alpha2
    kind: Image
    metadata:
      name: tutorial-cosign-image
      namespace: default
    spec:
      tag: IMAGE-REGISTRY
      serviceAccountName: tutorial-cosign-service-account
      builder:
        name: my-builder
        kind: Builder
      source:
        git:
          url: https://github.com/spring-projects/spring-petclinic
          revision: 82cb521d636b282340378d80a6307a08e3d4a4c4
    ```
    <!-- get a list of all placeholders in this snippet -->

    Where:

    - `IMAGE-REGISTRY` with a writable repository in your registry.
    The secret `registry-credentials` referenced in the ServiceAccount is a secret providing credentials
    for the registry where application container images are pushed to. For example:
      - Harbor has the form `"my-harbor.io/my-project/my-repo"`
      - Docker Hub has the form `"my-dockerhub-user/my-repo"` or `"index.docker.io/my-user/my-repo"`
      - Google Cloud Registry has the form `"gcr.io/my-project/my-repo"`

    - If you are using Out of the Box Supply Chains, you will [need to modify the respective](../scc/authoring-supply-chains.md) `ClusterImageTemplate` to enable signing in your supply chain.
    Referencing the service account using the `service_account` value when installing the
    Out of the Box Supply Chain is not recommended<!-- |VMware discourages| is preferred for closed source. |Cloud Foundry discourages| for open source. --> because that would<!-- Re-phrase for present tense if possible. --> give your run cluster access
    to the private signing key.

1. Apply the Image resource to the cluster by running:

    ```bash
    kubectl apply -f image-cosign.yaml
    ```

1. After the Image resource finishes building you can get the fully resolved built OCI image by running:

    ```bash
    kubectl -n default get image tutorial-cosign-image
    ```

    Example output:

    ```bash
    NAME                  LATESTIMAGE                                        READY
    tutorial-cosign-image index.docker.io/your-project/app@sha256:6744b...   True
    ```

1. Verify image signature by running:

    ```bash
    cosign verify --key cosign.pub <latest-image-with-digest>
    ```

    <!-- is <latest-image-with-digest> a placeholder? -->
    The image built will have been signed. Example output:

    ```bash
    Verification for <latest-image-with-digest> --
    The following checks were performed on each of these signatures:
    - The cosign claims were validated
    - The signatures were verified against the specified public key
    - Any certificates were verified against the Fulcio roots.
    ```

1. Configure [Supply Chain Security Tools for VMware Tanzu - Policy Controller](../scst-policy/overview.md)
to ensure that only signed images are allowed in your cluster.
