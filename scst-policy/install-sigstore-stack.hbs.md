# Install Sigstore Stack

[Sigstore/scaffolding](https://github.com/sigstore/scaffolding) is used for
bringing up the Sigstore Stack.

The Sigstore Stack consists of:

- [Trillian](https://github.com/google/trillian)
- [Rekor](https://github.com/sigstore/rekor)
- [Fulcio](https://github.com/sigstore/fulcio)
- [Certificate Transparency Log (CTLog)](https://github.com/google/certificate-transparency-go)
- [TheUpdateFramework (TUF)](https://theupdateframework.io/)

For information about air-gapped installation, see [Install Tanzu Application
Platform in an air-gapped environment](../install-air-gap.hbs.md)\.

If a Sigstore Stack TUF is already deployed and accessible in the air-gapped
environment, proceed to [Update Policy Controller with TUF Mirror and
Root](#sigstore-update-policy-controller).

## <a id='sigstore-release-files'></a> Download Stack Release Files

For Sigstore Stack, VMware recommends deploying `v0.4.8` of
`Sigstore/scaffolding`. This is due to an issue in previous versions
that caused the `Fulcio` deployment to crashloop because of the `CGO` package.
Later versions can also cause a known issue with invalid TUF key due to a
breaking change with the current Policy Controller packaged in Tanzu Application
Platform v1.3.0 and later. For information about this breaking change, see
[Known Issues](./known-issues.hbs.md).

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

For air-gapped environments, you must migrate the images from the
`release-*.yaml` to the internal air-gapped registry and update the
corresponding image references.

The following is a sample script that does this:

```bash
TARGET_REGISTRY=TARGET-REGISTRY

Where `TARGET-REGISTRY` is the name of the registry you want to migrate to.

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

During Sigstore Stack deployment, a sidecar image such as `queue-proxy`,
can require additional credentials. You can achieve this by adding a `secretgen`
annotated placeholder secret to the target namespace and patching the
corresponding service account. The placeholder imports the `tap-registry` secret to
the targeted namespace.

```bash
# <SERVICE> includes "trillian", "rekor", "fulcio", "ctlog", and "tuf"
echo "Create tap-registry secret import"
cat <<EOF | kubectl apply -f -
---
apiVersion: v1
kind: Secret
metadata:
  name: tap-registry
  namespace: SERVICE-system
  annotations:
    secretgen.carvel.dev/image-pull-secret: ""
stringData:
  .dockerconfigjson: "{}"
type: kubernetes.io/dockerconfigjson
EOF

echo "Patch SERVICE service account"
kubectl -n SERVICE-system patch serviceaccount SERVICE -p '{"imagePullSecrets": [{"name": "tap-registry"}]}'
```

Where `SERVICE` is the name of the service you want to configure with your target namespace.

## <a id='sigstore-copy-files'></a> Copy Release Files to Cluster Accessible Machine

With the images migrated and accessible, copy the `release-*.yaml` files onto
the cluster accessible machine that is installing the Sigstore Stack with
Kubernetes cluster access.

## <a id='sigstore-prepare-fulcio-patch'></a> Prepare Patching Fulcio Release File

The default `release-fulcio.yaml` has a `fulcio-config` resource. This config specifies the `OIDCIssuer`.
By default, there are issuers for:

- `Kubernetes API ServiceAccount token`
- `Google Accounts`
- `Sigstore OAuth2`
- `Github Action Token`

To add other OIDC Issuers, configure `fulcio-config` further.

Apart from `Kubernetes API ServiceAccount token`, the other `OIDCIssuers`
require access to external services. Your cluster must have an OIDC issuer
enabled to configure `OIDCIssuers` correctly. If you don't need keyless
signatures, you can remove the `OIDCIssuers` entry. In an air-gapped
environment, you must remove these `OIDCIssuers`.

You can add the correct [MetaIssuers](#sigstore-metaissuers) for your IaaS environment.

A `config_json` will be constructed and then applied to the `release-fulcio.yaml`.

### <a id='sigstore-oidcissuer'></a> OIDCIssuer

A `config_json` containing the `Kubernetes API ServiceAccount token` issuer:

```bash
config_json='{
  "OIDCIssuers": {
    "https://kubernetes.default.svc": {
      "IssuerURL": "https://kubernetes.default.svc",
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
```

Set the `IssuerURL` to the OIDC issuer configured in your cluster. You can discover
the URL by using `kubectl proxy -p 8001` and running:

```bash
curl localhost:8001/.well-known/openid-configuration | jq .issuer
```

Then set the `OIDCIssuer` to the value returned in the last command.

Other sample `OIDCIssuers`:

```bash
config_json='{
  "OIDCIssuers": {
    "https://accounts.google.com": {
      "IssuerURL": "https://accounts.google.com",
      "ClientID": "sigstore",
      "Type": "email"
    },
    "https://allow.pub": {
      "IssuerURL": "https://allow.pub",
      "ClientID": "sigstore",
      "Type": "spiffe",
      "SPIFFETrustDomain": "allow.pub"
    },
    "https://oauth2.sigstore.dev/auth": {
      "IssuerURL": "https://oauth2.sigstore.dev/auth",
      "ClientID": "sigstore",
      "Type": "email",
      "IssuerClaim": "$.federated_claims.connector_id"
    },
    "https://token.actions.githubusercontent.com": {
      "IssuerURL": "https://token.actions.githubusercontent.com",
      "ClientID": "sigstore",
      "Type": "github-workflow"
    }
  }
}'
```

### <a id='sigstore-metaissuers'></a> MetaIssuers

If installing on EKS, update the `config_json` to include this `MetaIssuer`:

```bash
config_json='{
  "MetaIssuers": {
    ...

    "https://oidc.eks.*.amazonaws.com/id/*": {
      "ClientID": "sigstore",
      "Type": "kubernetes"
    }
  }
}'
```

If installing on GCP, update the `config_json` to include this `MetaIssuer`:

```bash
config_json='{
  "MetaIssuers": {
    ...

    "https://container.googleapis.com/v1/projects/*/locations/*/clusters/*": {
      "ClientID": "sigstore",
      "Type": "kubernetes"
    }
  }
}'
```

If installing on AKS, update the `config_json` to include this `MetaIssuer`:

```bash
config_json='{
  "MetaIssuers": {
    ...

    "https://oidc.prod-aks.azure.com/*": {
      "ClientID": "sigstore",
      "Type": "kubernetes"
    }
  }
}'
```

### <a id='sigstore-applying-fulcio-patch'></a> Applying the patch for Fulcio release file

After configuring the required `config_json`, you can apply it by manually
editing the `release-fulcio.yaml` file or by running:

```bash
# Use `yq` to find the correct fulcio-config resource
# Update the `data.config.json` property with the new config JSON string
config_json="${config_json}" \
  yq e '. |
    select(.metadata.name == "fulcio-config") as $config |
    select(.metadata.name != "fulcio-config") as $other |
    $config.data["config.json"] = strenv(config_json) |
    ($other, $config)' -i release-fulcio.yaml
```

## <a id='sigstore-patch-knative-serving'></a> Patch Knative-Serving

Knative Serving might already be deployed, depending on the selected profile,
during the first attempt of installing Tanzu Application Platform. Knative
Serving is required to continue deploying the Sigstore Stack. If Knative is not
present, install it. See [Install Cloud Native
Runtimes](../cloud-native-runtimes/install-cnrt.hbs.md).

With the Sigstore Stack deployment, you must update Knative Serving's
`configmap/config-features` to enable required features.
Run:

```bash
kubectl patch configmap/config-features \
  --namespace knative-serving \
  --type merge \
  --patch '{"data":{"kubernetes.podspec-fieldref":"enabled", "kubernetes.podspec-volumes-emptydir":"enabled", "multicontainer":"enabled"}}'
```

## <a id='sigstore-oidc-reviewer'></a> Create OIDC Reviewer Binding

To fetch public keys and validate the JWT tokens from the `Discovery Document`,
you must allow unauthenticated requests.

```bash
kubectl create clusterrolebinding oidc-reviewer \
  --clusterrole=system:service-account-issuer-discovery \
  --group=system:unauthenticated
```

For more information, see [Service Account Issuer
Discovery](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#service-account-issuer-discovery)
in the Kubernetes documentation.

## <a id='sigstore-install-trillian'></a> Install Trillian

To install Trillian:

1. `kubectl apply` the `release-trillian.yaml`.
2. Add the `secretgen` placeholder for `secretgen` to import `tap-registry` secret to the namespace for `queue-proxy`.
3. Patch the service account to use the imported `tap-registry` secret.
4. Wait for the jobs and services to be `Complete` or be `Ready`.

```bash
echo 'Install Trillian'
kubectl apply -f "release-trillian.yaml"

echo "Create tap-registry secret import"
cat <<EOF | kubectl apply -f -
---
apiVersion: v1
kind: Secret
metadata:
  name: tap-registry
  namespace: trillian-system
  annotations:
    secretgen.carvel.dev/image-pull-secret: ""
stringData:
  .dockerconfigjson: "{}"
type: kubernetes.io/dockerconfigjson
EOF

echo "Patch trillian service account"
kubectl -n trillian-system patch serviceaccount trillian -p '{"imagePullSecrets": [{"name": "tap-registry"}]}'

echo 'Restart trillian deployment if tap-registry secret was required'
kubectl -n trillian-system rollout restart deployment/log-server-00001-deployment
kubectl -n trillian-system rollout restart deployment/log-signer-00001-deployment

echo 'Wait for Trillian ready'
kubectl wait --timeout 2m -n trillian-system --for=condition=Ready ksvc log-server
kubectl wait --timeout 2m -n trillian-system --for=condition=Ready ksvc log-signer
```

## <a id='sigstore-install-rekor'></a> Install Rekor

To install Rekor:

1. `kubectl apply` the `release-rekor.yaml`.
2. Add the `secretgen` placeholder for `secretgen` to import `tap-registry` secret to the namespace for `queue-proxy`.
3. Patch the service account to use the imported `tap-registry` secret.
4. Wait for the jobs and services to be `Complete` or be `Ready`.

```bash
echo 'Install Rekor'
kubectl apply -f "release-rekor.yaml"

echo "Create tap-registry secret import"
cat <<EOF | kubectl apply -f -
---
apiVersion: v1
kind: Secret
metadata:
  name: tap-registry
  namespace: rekor-system
  annotations:
    secretgen.carvel.dev/image-pull-secret: ""
stringData:
  .dockerconfigjson: "{}"
type: kubernetes.io/dockerconfigjson
EOF

echo "Patch rekor service account"
kubectl -n rekor-system patch serviceaccount rekor -p '{"imagePullSecrets": [{"name": "tap-registry"}]}'

echo 'Restart rekor deployment if tap-registry secret was required'
kubectl -n rekor-system rollout restart deployment/rekor-00001-deployment

echo 'Wait for Rekor ready'
kubectl wait --timeout 5m -n rekor-system --for=condition=Complete jobs --all
kubectl wait --timeout 2m -n rekor-system --for=condition=Ready ksvc rekor
```

## <a id='sigstore-install-fulcio'></a> Install Fulcio

To install Fulcio:

1. `kubectl apply` the `release-fulcio.yaml`.
2. Add the `secretgen` placeholder for `secretgen` to import `tap-registry` secret to the namespace for `queue-proxy`.
3. Patch the service account to use the imported `tap-registry` secret.
4. Wait for the jobs and services to be `Complete` or be `Ready`.

The Sigstore Scaffolding `release-fulcio.yaml` downloaded can have an empty YAML document at the end of the file separated by `---` and followed by no elements. This results in:

```console
error: error validating "release-fulcio.yaml": error validating data: [apiVersion not set, kind not set]; if you choose to ignore these errors, turn validation off with --validate=false

```

This is a known issue and you can ignore it.

```bash
echo 'Install Fulcio'
kubectl apply -f "release-fulcio.yaml"

echo "Create tap-registry secret import"
cat <<EOF | kubectl apply -f -
---
apiVersion: v1
kind: Secret
metadata:
  name: tap-registry
  namespace: fulcio-system
  annotations:
    secretgen.carvel.dev/image-pull-secret: ""
stringData:
  .dockerconfigjson: "{}"
type: kubernetes.io/dockerconfigjson
EOF

echo "Patch fulcio service account"
kubectl -n fulcio-system patch serviceaccount fulcio -p '{"imagePullSecrets": [{"name": "tap-registry"}]}'

echo 'Restart fulcio deployment if tap-registry secret was required'
kubectl -n fulcio-system rollout restart deployment/fulcio-00001-deployment

echo 'Wait for Fulcio ready'
kubectl wait --timeout 5m -n fulcio-system --for=condition=Complete jobs --all
kubectl wait --timeout 5m -n fulcio-system --for=condition=Ready ksvc fulcio
```

## <a id='sigstore-install-ctlog'></a> Install Certificate Transparency Log (CTLog)

To install CTLog:

1. `kubectl apply` the `release-ctlog.yaml`.
2. Add the `secretgen` placeholder for `secretgen` to import `tap-registry` secret to the namespace for `queue-proxy`.
3. Patch the service account to use the imported `tap-registry` secret.
4. Wait for the jobs and services to be `Complete` or be `Ready`.

```bash
echo 'Install CTLog'
kubectl apply -f "release-ctlog.yaml"

echo "Create tap-registry secret import"
cat <<EOF | kubectl apply -f -
---
apiVersion: v1
kind: Secret
metadata:
  name: tap-registry
  namespace: ctlog-system
  annotations:
    secretgen.carvel.dev/image-pull-secret: ""
stringData:
  .dockerconfigjson: "{}"
type: kubernetes.io/dockerconfigjson
EOF

echo "Patch ctlog service account"
kubectl -n ctlog-system patch serviceaccount ctlog -p '{"imagePullSecrets": [{"name": "tap-registry"}]}'

echo 'Restart ctlog deployment if tap-registry secret was required'
kubectl -n ctlog-system rollout restart deployment/ctlog-00001-deployment

echo 'Wait for CTLog ready'
kubectl wait --timeout 5m -n ctlog-system --for=condition=Complete jobs --all
kubectl wait --timeout 2m -n ctlog-system --for=condition=Ready ksvc ctlog
```

## <a id='sigstore-install-tuf'></a> Install TUF

To install TUF:

1. If you are using OpenShift, add a `RoleBinding`.
2. `kubectl apply` the `release-tuf.yaml`.
3. Add the `secretgen` placeholder for `secretgen` to import `tap-registry` secret to the namespace for `queue-proxy`.
4. Patch the service account to use the imported `tap-registry` secret.
5. Copy the public keys from the previous deployment of CTLog, Fulcio, and Rekor to the TUF namespace.
6. Wait for the jobs and services to be `Complete` or be `Ready`.

If you are using OpenShift, you must set the correct Security Context Constraints so the TUF server
can write to the root file system. This is done by adding the `anyuid` Security Context Constraint
through a `RoleBinding`:

```bash
cat <<EOF >> release-tuf.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name:  tuf-os-scc-role-binding
  namespace: tuf-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:openshift:scc:anyuid
subjects:
  - kind: ServiceAccount
    namespace: tuf-system
    name: tuf
EOF
```

Now proceed to install TUF:

```bash
echo 'Install TUF'
kubectl apply -f "release-tuf.yaml"

echo "Create tap-registry secret import"
cat <<EOF | kubectl apply -f -
---
apiVersion: v1
kind: Secret
metadata:
  name: tap-registry
  namespace: tuf-system
  annotations:
    secretgen.carvel.dev/image-pull-secret: ""
stringData:
  .dockerconfigjson: "{}"
type: kubernetes.io/dockerconfigjson
EOF

echo "Patch tuf service account"
kubectl -n tuf-system patch serviceaccount tuf -p '{"imagePullSecrets": [{"name": "tap-registry"}]}'

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

Update the `tap-values` that are used for installation of Tanzu Application Platform.

If the internally deployed TUF is used, `tuf_mirror` is `http://tuf.tuf-system.svc`.
If the mirror is hosted elsewhere, provide the correct mirror URL. The default public TUF instance mirror URL is `https://sigstore-tuf-root.storage.googleapis.com`.

The `tuf_root` is the contents of the obtained `root.json` from the `tuf-root` secret in the `tuf-system` namspace. The public TUF instance's [root.json](https://sigstore-tuf-root.storage.googleapis.com/root.json).

If Policy Controller was installed through Tanzu Application Profiles, update the values file with:
```yaml
policy:
  tuf_mirror: http://tuf.tuf-system.svc
  tuf_root: |
    MULTI-LINE-ROOT-JSON
```

Where `MULTI-LINE-ROOT-JSON` is a multi-line string content of from your root.json file.

When updating the current Tanzu Application Platform installed through profiles with the updated values file, the previously failing Tanzu Application Platform `PackageInstall` has the following error:

```bash
tanzu package installed update tap --values-file tap-values-updated.yaml -n tap-install
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

Although the command fails, the values file is updated in the installation
secrets. During the next reconciliation cycle, the package attempts to reconcile
and sync with the expected configuration. At that point, Policy Controller
updates and reconciles with the latest values.

If Policy Controller was installed standalone or updated manually, update the values file with:

```yaml
tuf_mirror: http://tuf.tuf-system.svc
tuf_root: |
  MULTI-LINE-ROOT-JSON
```

Where `MULTI-LINE-ROOT-JSON` is a multi-line string content of from your root.json file.

Run with the values file configured for Policy Controller only:

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

This updates the policy-controller only. It is important that if Policy
Controller was installed through the Tanzu Application Platform package with
profiles, the `update` command to update the Tanzu Application Platform
installation is still required, as it updates the values file. If only the
Policy Controller package is updated with new values and not the Tanzu
Application Platform package's values, the Tanzu Application Platform package's
values overwrite the Policy Controller's values.

For more information about profiles, see [Package
Profiles](../about-package-profiles.hbs.md). For more information about Policy
Controller, see [Install Supply Chain Security Tools - Policy
Controller](./install-scst-policy.hbs.md) documentation.

## <a id='sigstore-uninstall'></a> Uninstall Sigstore Stack

To uninstall Sigstore Stack, run:

```bash
kubectl delete -f "release-tuf.yaml"
kubectl delete -f "release-ctlog.yaml"
kubectl delete -f "release-fulcio.yaml"
kubectl delete -f "release-rekor.yaml"
kubectl delete -f "release-trillian.yaml"
```