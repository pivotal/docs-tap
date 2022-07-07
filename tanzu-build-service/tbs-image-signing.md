# Tanzu Build Service with image signing
This section will walk through creating a Tanzu Build Service [Image](https://docs.vmware.com/en/Tanzu-Build-Service/1.5/vmware-tanzu-build-service/GUID-managing-images.html) resource to build a container image from source that is signed with [cosign](https://github.com/sigstore/cosign). This article builds upon the steps in the [kpack Tutorial](https://github.com/pivotal/kpack/blob/main/docs/tutorial.md).

###  Prerequisites
1. Tanzu Build Service is installed and available.

    > Refer to [installing Tanzu Build Service](install-tbs.md) section.
    The Full, Iterate, and Build profiles include Tanzu Build Service.

2. Cosign
    > Follow the official docs to [install cosign](https://docs.sigstore.dev/cosign/installation/)

3. A [Builder or ClusterBuilder](https://docs.vmware.com/en/Tanzu-Build-Service/1.5/vmware-tanzu-build-service/GUID-managing-builders.html) and [Image](https://docs.vmware.com/en/Tanzu-Build-Service/1.5/vmware-tanzu-build-service/GUID-managing-images.html) resource configured.


### Configure Tanzu Build Service to sign your image builds

1. Generate a cosign key pair

   The `cosign generate-key-pair k8s://<secret-name>` command generates a key-pair for you and stores it as a kubernetes secret with name `tutorial-cosign-key-pair` in the `default` namespace.

   ```bash
   cosign generate-key-pair k8s://default/tutorial-cosign-key-pair
   ```

   The command will ask you to enter a password for the private key. Enter any password you want. After the command has completed successfully, you should see the following output:

   ```
   Successfully created secret tutorial-cosign-key-pair in namespace default
   Public key written to cosign.pub
   ```

   You should see a `cosign.pub` file in your current folder. Keep this file as it will be needed to verify the signature of the images built in this tutorial.


   If you are using [dockerhub](https://hub.docker.com/) or a registry that does not support OCI media types, you need to add the annotation `kpack.io/cosign.docker-media-types: "1"` to the cosign secret. The secret `tutorial-cosign-key-pair` should look something like this:

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
     cosign.key: <PRIVATE KEY DATA>
     cosign.password: <COSIGN PASSWORD>
     cosign.pub: <PUBLIC KEY DATA>
   ```

    > Note: Learn more about configuring cosign key pairs with the [Tanzu Build Service Image documentation](https://docs.vmware.com/en/Tanzu-Build-Service/1.5/vmware-tanzu-build-service/GUID-managing-images.html#image-signing-with-cosign)


2. Create or modify the service account that is referenced in the Image resource so it includes the cosign key pair secret created in the previous step.

   Just by adding a cosign secret to the service account that is referenced in an Image resource enables cosign signing.

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

   Apply that service account to the cluster

   ```bash
   kubectl apply -f cosign-service-account.yaml
   ```

3. Create an Image resource:

   Note that this Image has a references `tutorial-cosign-service-account`.

   ```yaml
   apiVersion: kpack.io/v1alpha2
   kind: Image
   metadata:
     name: tutorial-cosign-image
     namespace: default
   spec:
     tag: <IMAGE-REGISTRY>
     serviceAccountName: tutorial-cosign-service-account
     builder:
       name: my-builder
       kind: Builder
     source:
       git:
         url: https://github.com/spring-projects/spring-petclinic
         revision: 82cb521d636b282340378d80a6307a08e3d4a4c4
   ```

   - Replace `<IMAGE-REGISTRY>` with a writable repository in your registry. The secret `registry-credentials` referenced in the ServiceAccount is a secret providing credentials for the registry where application container images are pushed to.
      * Harbor has the form `"my-harbor.io/my-project/my-repo"`
      * Dockerhub has the form `"my-dockerhub-user/my-repo"` or `"index.docker.io/my-user/my-repo"`
      * Google Cloud Registry has the form `"gcr.io/my-project/my-repo"`

   - If you are using Out of the Box Supply Chains, you will [need to modify the respective](../scc/authoring-supply-chains.md) `ClusterImageTemplate` to enable signing in your supply chain.
   Referencing the service account using the `service_account` value when installing the
   Out of the Box Supply Chain is not recommended because that would give your run cluster access
   to the private signing key.

   Apply that Image resource to the cluster

   ```bash
   kubectl apply -f image-cosign.yaml
   ```

   Once the Image resource finishes building you can get the fully resolved built OCI image with `kubectl get`

   ```
   kubectl -n default get image tutorial-cosign-image
   ```

   The output should look something like this:
   ```
   NAME                  LATESTIMAGE                                        READY
   tutorial-cosign-image index.docker.io/your-project/app@sha256:6744b...   True
   ```

4. Verify image signature

   The image that was built in the previous step should have been signed. Here we use the `cosign.pub` public key file that was generated in the first step.
   ```bash
   cosign verify --key cosign.pub <latest-image-with-digest>
   ```

   You should see an output similar to this:
   ```
   Verification for <latest-image-with-digest> --
   The following checks were performed on each of these signatures:
    - The cosign claims were validated
    - The signatures were verified against the specified public key
    - Any certificates were verified against the Fulcio roots.
   ```

5. Now you can configure [Supply Chain Security Tools for VMware Tanzu - Policy Controller](../scst-policy/overview.md) to
ensure that only signed images are allowed in your cluster.