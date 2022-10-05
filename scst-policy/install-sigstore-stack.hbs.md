# Install Sigstore Stack

[Sigstore/scaffolding](https://github.com/sigstore/scaffolding) will be used for
bringing up the Sigstore Stack.

The Sigstore Stack consists of:
- [Trillian](https://github.com/google/trillian)
- [Rekor](https://github.com/sigstore/rekor)
- [Fulcio](https://github.com/sigstore/fulcio)
- [Certificate Transparency Log (CTLog)](https://github.com/google/certificate-transparency-go)
- [TheUpdateFramework (TUF)](https://theupdateframework.io/)

For more information on air-gapped installation, see [Install Tanzu Application Platform in an air-gapped environment](../install-air-gap.hbs.md)

If a Sigstore Stack TUF is already deployed and accessible in the air-gapped environment, proceed to [Update Policy Controller with TUF Mirror and Root](#sigstore-update-policy-controller).

## <a id='sigstore-release-files'></a> Download Stack Release Files

In an air-gapped environment, `v0.4.8` is the minimum version of `Sigstore/scaffolding` currently supported.
This is due to an issue in previous versions that caused the `Fulcio` deployment to crashloop due to the `CGO` package.

Download the release files of all the Sigstore Stack components from `Sigstore/scaffolding`:
```bash
RELEASE_VERSION="v0.4.8"

TRILLIAN_URL="https://github.com/sigstore/scaffolding/releases/download/${RELEASE_VERSION}/release-trillian.yaml"
REKOR_URL="https://github.com/sigstore/scaffolding/releases/download/${RELEASE_VERSION}/release-rekor.yaml"
FULCIO_URL="https://github.com/sigstore/scaffolding/releases/download/${RELEASE_VERSION}/release-fulcio.yaml"
CTLOG_URL="https://github.com/sigstore/scaffolding/releases/download/${RELEASE_VERSION}/release-ctlog.yaml"
TUF_URL="https://github.com/sigstore/scaffolding/releases/download/${RELEASE_VERSION}/release-tuf.yaml"

curl -sL "${TRILLIAN_URL}" -o "release-trillian.yaml"
curl -sL "${REKOR_URL}" -o "release-rekor.yaml"
curl -sL "${FULCIO_URL}" -o "release-fulcio.yaml"
curl -sL "${CTLOG_URL}" -o "release-ctlog.yaml"
curl -sL "${TUF_URL}" -o "release-tuf.yaml"
```

## <a id='sigstore-migrate-images'></a> Migrate Images onto Internal Registry

For air-gapped environments, the images from the `release-*.yaml` will need to be migrated to the internal air-gapped registry and the corresponding image references updated.

A sample script that does this would be:
```bash
TARGET_REGISTRY=<TARGET REGISTRY REGISTRY>

# Use yq to find all "image" keys from the release-*.yaml downloaded
found_images=($(yq eval '.. | select(has("image")) | .image' release-*.yaml | grep --invert-match  -- '---'))

# Loop through each found image
# Pull, retag, push the images
# Update the found image references in all the release-*.yaml
for image in "${found_images[@]}"; do
  if echo "${image}" | grep -q '@'; then
    # If image is a digest reference
    image_ref=$(echo "${image}" | cut -d'@' -f1)
    image_sha=$(echo "${image}" | cut -d'@' -f2)
    image_path=$(echo "${image_ref}" | cut -d'/' -f2-)

    docker pull "${image}"
    docker tag "${image}" "${TARGET_REGISTRY}/${image_path}"
    # Obtain the new sha256 from the `docker push` output
    new_sha=$(docker push "${TARGET_REGISTRY}/${image_path}" | tail -n1 | cut -d' ' -f3)

    new_reference="${TARGET_REGISTRY}/${image_path}@${new_sha}"
  else
    # If image is a tag reference
    image_path=$(echo ${image} | cut -d'/' -f2-)

    docker pull ${image}
    docker tag ${image} ${TARGET_REGISTRY}/${image_path}
    docker push ${TARGET_REGISTRY}/${image_path}

    new_reference="${TARGET_REGISTRY}/${image_path}"
  fi

  # Replace the image reference with the new reference in all the release-*.yaml
  sed -i.bak -E "s#image: ${image}#image: ${new_reference}#" release-*.yaml
done
```

## <a id='sigstore-copy-files'></a> Copy Release Files to Cluster Accessible Machine

With the images migrated and accessible, the next step is to copy the `release-*.yaml` files onto the machine that will be installing the Sigstore Stack with Kubernetes cluster access.

## <a id='sigstore-patch-release'></a> Patch Release Files

The default `release-fulcio.yaml` will have a `fulcio-config` resource. This config specifies the `OIDCIssuer`.
By default, there are issuers for:
- `Kubernetes API ServiceAccount token`
- `Google Accounts`
- `Sigstore OAuth2`
- `Github Action Token`

Other OIDC Issuers can be added by configuring `fulcio-config` further.

Apart from `Kubernetes API ServiceAccount token`, the other `OIDC Issuers` require external internet access.
In an air-gapped environment, these `OIDC Issuers` need to be removed.

This can be done by manually editing `release-fulcio.yaml` or running the following sample commands:

```bash
config_json='{
  "OIDCIssuers": {
    "https://kubernetes.default.svc.cluster.local": {
      "IssuerURL": "https://kubernetes.default.svc.cluster.local",
      "ClientID": "sigstore",
      "Type": "kubernetes"
    }
  },
  "MetaIssuers": {
    "https://kubernetes.*.svc": {
      "ClientID": "sigstore",
      "Type": "kubernetes"
    }
  }
}'

# Use `yq` to find the correct fulcio-config resource
# Update the `data.config.json` property with the new config JSON string
config_json="${config_json}" \
  yq e '. |
    select(.metadata.name == "fulcio-config") as $config |
    select(.metadata.name != "fulcio-config") as $other |
    $config.data["config.json"] = strenv(config_json) |
    ($other, $config)' -i release-fulcio.yaml
```

Another update to the `release-fulcio.yaml` that may be required is that the `OIDCIssuer` for `Kuberenetes API Token`.
The host URL is different for versions older than Kubernetes `1.23.x`. In Kubernetes versions less than `1.23.x`, the URL is `https://kubernetes.default.svc`.


A sample update to the `release-fulcio.yaml` can be done with:
```bash
K8S_SERVER_VERSION=$(kubectl version -o json | yq '.serverVersion.minor' -)
if [ "${K8S_SERVER_VERSION}" == "21" ] || [ "${K8S_SERVER_VERSION}" == "22" ]; then
  sed -i.bak 's#https://kubernetes.default.svc.cluster.local#https://kubernetes.default.svc#' release-fulcio.yaml
fi
```

## <a id='sigstore-patch-knative-serving'></a> Patch Knative-Serving

Knative Serving should be deployed already during the first attempt of installing TAP. This component needs to be present for continuation of deploying the Sigstore Stack.

With the Sigstore Stack deployment, Knative Serving's `configmap/config-features` needs to be updated to enable some required features.


This can be done with the following command:
```bash
kubectl patch configmap/config-features \
  --namespace knative-serving \
  --type merge \
  --patch '{"data":{"kubernetes.podspec-fieldref":"enabled", "kubernetes.podspec-volumes-emptydir":"enabled", "multicontainer":"enabled"}}'
```

## <a id='sigstore-oidc-reviewer'></a> Create OIDC Reviewer Binding

To be able to fetch public keys and validate the JWT tokens from the `Discovery Document`, we have to allow unauthenticated requests.

```bash
kubectl create clusterrolebinding oidc-reviewer \
  --clusterrole=system:service-account-issuer-discovery \
  --group=system:unauthenticated
```
For more information, see the Kubernetes documenation on [Service Account Issuer Discovery](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#service-account-issuer-discovery).

## <a id='sigstore-install-trillian'></a> Install Trillian

To install Trillian:
- `kubectl apply` the `release-trillian.yaml`
- Wait for the jobs and services to be `Complete` or be `Ready`.

```bash
echo 'Install Trillian'
kubectl apply -f "release-trillian.yaml"

echo 'Wait for Trillian ready'
kubectl wait --timeout 2m -n trillian-system --for=condition=Ready ksvc log-server
kubectl wait --timeout 2m -n trillian-system --for=condition=Ready ksvc log-signer
```

## <a id='sigstore-install-rekor'></a> Install Rekor

To install Rekor:
- `kubectl apply` the `release-rekor.yaml`
- Wait for the jobs and services to be `Complete` or be `Ready`.

```bash
echo 'Install Rekor'
kubectl apply -f "release-rekor.yaml"

echo 'Wait for Rekor ready'
kubectl wait --timeout 5m -n rekor-system --for=condition=Complete jobs --all
kubectl wait --timeout 2m -n rekor-system --for=condition=Ready ksvc rekor
```

## <a id='sigstore-install-fulcio'></a> Install Fulcio

To install Fulcio:
- `kubectl apply` the `release-fulcio.yaml`
- Wait for the jobs and services to be `Complete` or be `Ready`.

The Sigstore Scaffolding `release-fulcio.yaml` downloaded may have an empty YAML document at the end of the file separated by `---` and following by no elements. This will result in:
```
error: error validating "release-fulcio.yaml": error validating data: [apiVersion not set, kind not set]; if you choose to ignore these errors, turn validation off with --validate=false
```
This is a known issue and can be ignored.

```bash
echo 'Install Fulcio'
kubectl apply -f "release-fulcio.yaml"

echo 'Wait for Fulcio ready'
kubectl wait --timeout 5m -n fulcio-system --for=condition=Complete jobs --all
kubectl wait --timeout 5m -n fulcio-system --for=condition=Ready ksvc fulcio
```

## <a id='sigstore-install-ctlog'></a> Install Certificate Transparency Log (CTLog)

To install CTLog:
- `kubectl apply` the `release-ctlog.yaml`
- Wait for the jobs and services to be `Complete` or be `Ready`.

```bash
echo 'Install CTLog'
kubectl apply -f "release-ctlog.yaml"

echo 'Wait for CTLog ready'
kubectl wait --timeout 5m -n ctlog-system --for=condition=Complete jobs --all
kubectl wait --timeout 2m -n ctlog-system --for=condition=Ready ksvc ctlog
```

## <a id='sigstore-install-tuf'></a> Install TUF

To install TUF:
- `kubectl apply` the `release-tuf.yaml`
- Copy the public keys from the previous deployment of CTLog, Fulcio, and Rekor to the TUF namespace
- Wait for the jobs and services to be `Complete` or be `Ready`.

```bash
echo 'Install TUF'
kubectl apply -f "release-tuf.yaml"

# Then copy the secrets (even though it's all public stuff, certs, public keys)
# to the tuf-system namespace so that we can construct a tuf root out of it.
kubectl -n ctlog-system get secrets ctlog-public-key -oyaml | sed 's/namespace: .*/namespace: tuf-system/' | kubectl apply -f -
kubectl -n fulcio-system get secrets fulcio-pub-key -oyaml | sed 's/namespace: .*/namespace: tuf-system/' | kubectl apply -f -
kubectl -n rekor-system get secrets rekor-pub-key -oyaml | sed 's/namespace: .*/namespace: tuf-system/' | kubectl apply -f -

echo 'Wait for TUF ready'
kubectl wait --timeout 4m -n tuf-system --for=condition=Complete jobs --all
kubectl wait --timeout 2m -n tuf-system --for=condition=Ready ksvc tuf
```

## <a id='sigstore-update-policy-controller'></a> Update Policy Controller with TUF Mirror and Root

Obtain the `root.json` file from the `tuf-system` namespace with the following command:
```bash
kubectl -n tuf-system get secrets tuf-root -o jsonpath='{.data.root}' | base64 -d > root.json
```

Update the `tap-values` that will be used for installation of Tanzu Application Platform.

If the internally deployed TUF will be used, `tuf_mirror` should be `http://tuf.tuf-system.svc`.
If the mirror is hosted elsewhere, provide the correct mirror URL. The default public TUF instance mirror URL is `https://sigstore-tuf-root.storage.googleapis.com`.

The `tuf_root` is the contents of the obtained `root.json` from the `tuf-root` secret in the `tuf-system` namspace. The public TUF instance's [`root.json`](https://sigstore-tuf-root.storage.googleapis.com/root.json).

If Policy Controller was installed through Tanzu Application Profiles, update the values file with:
```yaml
policy:
  tuf_mirror: http://tuf.tuf-system.svc
  tuf_root: |
    <Multi-line string content of root.json>
```

When updating the current Tanzu Application Platform installed through profiles with the updated values file, it is possible that the previously failing TAP `PackageInstall` will error with the following:

```bash
tanzu package installed update --install tap --values-file tap-values-updated.yaml -n tap-install
 Updating installed package 'tap'
 Getting package install for 'tap'
 Getting package metadata for 'tap.tanzu.vmware.com'
 Updating secret 'tap-tap-install-values'
 Updating package install for 'tap'
 Waiting for 'PackageInstall' reconciliation for 'tap'


Error: resource reconciliation failed: kapp: Error: waiting on reconcile packageinstall/policy-controller (packaging.carvel.dev/v1alpha1) namespace: tap-install:
  Finished unsuccessfully (Reconcile failed:  (message: Error (see .status.usefulErrorMessage for details))). Reconcile failed: Error (see .status.usefulErrorMessage for details)
Error: exit status 1
```

Although the command fails, the values file is still updated in the installation secrets. During the next reconciliation cycle, the package will attempt to reconcile and sync with the expected configuration. At that point, Policy Controller will update and reconcile with the latest values.

If Policy Controller was installed standalone or being updated manually, update the values file with:

```yaml
tuf_mirror: http://tuf.tuf-system.svc
tuf_root: |
  <Multi-line string content of root.json>
```

Run the following command with the values file configured for Policy Controller only:

```bash
tanzu package installed update policy-controller --values-file tap-values-standalone.yaml -n tap-install
 Updating installed package 'policy-controller'
 Getting package install for 'policy-controller'
 Getting package metadata for 'policy.apps.tanzu.vmware.com'
 Creating secret 'policy-controller-tap-install-values'
 Updating package install for 'policy-controller'
 Waiting for 'PackageInstall' reconciliation for 'policy-controller'
 'PackageInstall' resource install status: Reconciling
 'PackageInstall' resource install status: ReconcileSucceeded
 'PackageInstall' resource successfully reconciled
Updated installed package 'policy-controller' in namespace 'tap-install'
```

This will update the policy-controller only. It is important that if Policy Controller was installed through the TAP package with profiles, the update command to update the TAP installation is still required as it updated the values file. If only the Policy Controller package is updated with new values and not the TAP package's values, the TAP package's values will overwrite the Policy Controller's values.

For more information on profiles, see [Package Profiles](../about-package-profiles.hbs.md).
For more information on Policy Controller, see [Install Supply Chain Security Tools - Policy Controller](./install-scst-policy.hbs.md) documentation.
