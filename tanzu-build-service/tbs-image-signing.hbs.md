# Create a signed container image with Tanzu Build Service

This topic tells you how to create a Tanzu Build Service image
resource that builds a container image from source code signed with
Cosign.

## <a id="prereqs"></a> Prerequisites

Before you can configure Tanzu Build Service to sign your image builds, you must:

- Install Tanzu Build Service. The Full, Iterate, and Build profiles include Tanzu Build Service by default.
If you have not installed Tanzu Application Platform with one of these profiles,
see [Installing Tanzu Build Service](install-tbs.md).

- Install Cosign. For instructions, see the [Cosign documentation](https://docs.sigstore.dev/cosign/installation/).

- Have a [Builder or ClusterBuilder](https://docs.vmware.com/en/Tanzu-Build-Service/1.9/vmware-tanzu-build-service/managing-builders.html)
resource configured.

- Have an [image](https://docs.vmware.com/en/Tanzu-Build-Service/1.9/vmware-tanzu-build-service/managing-images.html)
resource configured.

- Review the [kpack tutorial](https://github.com/pivotal/kpack/blob/main/docs/tutorial.md). This topic builds upon the steps in this tutorial.

## <a id="sign-image-builds"></a> Configure Tanzu Build Service to sign your image builds

To configure Tanzu Build Service to sign your image builds:

1. Ensure that you are in a Kubernetes context where you are authenticated and authorized to
create and edit secret and service account resources.

1. Generate a Cosign keypair and store it as a Kubernetes secret by running:

    ```console
    cosign generate-key-pair k8s://NAMESPACE/COSIGN-KEYPAIR-NAME
    ```

    Where:

    - `NAMESPACE` is the namespace to store the Kubernetes secret in.
    - `COSIGN-KEYPAIR-NAME` is the name of the Kubernetes secret.

    For example:

    ```console
    cosign generate-key-pair k8s://default/tutorial-cosign-key-pair
    ```

1. Enter a password for the private key. Enter any password you want.
After the command has completed, you will see the following output:

    ```console
    Successfully created secret tutorial-cosign-key-pair in namespace default
    Public key written to cosign.pub
    ```

    You will also see a `cosign.pub` file in your current directory.
    Keep this file as you will need it to verify the signature of the images that are built.

1. If you are using [Docker Hub](https://hub.docker.com/) or a registry that does not support OCI
media types, add the annotation `kpack.io/cosign.docker-media-types: "1"` to the Cosign secret as follows:

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

    For more information about configuring Cosign key pairs, see the
    [Tanzu Build Service documentation](https://docs.vmware.com/en/Tanzu-Build-Service/1.9/vmware-tanzu-build-service/managing-images.html#image-signing-with-cosign).

1. To enable Cosign signing, create or edit the service account resource that is
referenced in the image resource so that it includes the Cosign keypair secret created earlier. The
service account is in the same namespace as the image resource and is directly referenced by the
image or default if there isn't one. The default is the default service account in the workload namespace.

    ```yaml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: SERVICE-ACCOUNT-NAME
      namespace: default
    secrets:
    - name: REGISTRY-CREDENTIALS
    - name: COSIGN-KEYPAIR-NAME
    imagePullSecrets:
    - name: REGISTRY-CREDENTIALS
    ```

    Where:

    - `SERVICE-ACCOUNT-NAME` is the name of your service account resource.
    For example, `tutorial-cosign-service-account`.
    - `COSIGN-KEYPAIR-NAME` is the name of the Cosign keypair secret generated earlier.
    For example, `tutorial-cosign-key-pair`.
    - `REGISTRY-CREDENTIALS` is the secret that provides credentials for the
    container registry where application container images are pushed to.

1. Apply the service account resource to the cluster by running:

    ```console
    kubectl apply -f cosign-service-account.yaml
    ```

1. Create an image resource file named `image-cosign.yaml`. For example:

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

    Where:

    - `IMAGE-REGISTRY` with a writable repository in your registry.
    The secret referenced in the service account is a secret providing credentials
    for the registry where application container images are pushed to. For example:
      - Harbor has the form `"my-harbor.io/my-project/my-repo"`
      - Docker Hub has the form `"my-dockerhub-user/my-repo"` or `"index.docker.io/my-user/my-repo"`
      - Google Cloud Registry has the form `"gcr.io/my-project/my-repo"`

1. If you are using Out of the Box Supply Chains, edit the respective `ClusterImageTemplate`
to enable signing in your supply chain. For more information, see [Authoring supply chains](../scc/authoring-supply-chains.md).

    > **Important** VMware discourages referencing the service account using the `service_account` value
    > when installing the Out of the Box Supply Chain.
    > This is because it gives your run cluster access to the private signing key.

1. Apply the image resource to the cluster by running:

    ```console
    kubectl apply -f image-cosign.yaml
    ```

1. After the image resource finishes building, you can get the fully resolved and built OCI image by running:

    ```console
    kubectl -n default get image tutorial-cosign-image
    ```

    Example output:

    ```console
    NAME                  LATESTIMAGE                                        READY
    tutorial-cosign-image index.docker.io/your-project/app@sha256:6744b...   True
    ```

1. Verify image signature by running:

    ```console
    cosign verify --key cosign.pub LATEST-IMAGE-WITH-DIGEST
    ```

    Where `LATEST-IMAGE-WITH-DIGEST` is the value of `LATESTIMAGE` you retrieved in
    the previous step. For example: `index.docker.io/your-project/app@sha256:6744b...`

    The expected output is similar to the following:

    ```console
    Verification for index.docker.io/your-project/app@sha256:6744b... --
    The following checks were performed on each of these signatures:
    - The cosign claims were validated
    - The signatures were verified against the specified public key
    - Any certificates were verified against the Fulcio roots.
    ```

1. Configure Supply Chain Security Tools for VMware Tanzu - Policy Controller
to ensure that only signed images are allowed in your cluster.
For more information, see the [Supply Chain Security Tools for VMware Tanzu - Policy Controller](../scst-policy/overview.md) documentation.
