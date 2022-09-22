# TAP developer namespace setup example

> ✅ Applies to TAP v{{ vars.tap_version }}

The following is an example setup of a TAP developer namespace (for use with Workloads) as per
[**TAP v{{ vars.tap_version }}** guidelines](../../set-up-namespaces.md).
You may use this document as a reference guide to expedite the process of creating the necessary space to [deploy your
workloads](../app-operators/tutorials/securing-first-workload.md).

## Installing the namespace configuration

### Add container image registry credentials

```shell
# The namespace in which your workloads will be applied to
export WORKLOADS_NAMESPACE="workloads"

# The container image registry to which your workloads will be published to. This example uses Google Container Registry.
export CONTAINER_IMAGE_REGISTRY="https://gcr.io"
export CONTAINER_IMAGE_REGISTRY_USERNAME="<username>"
export CONTAINER_IMAGE_REGISTRY_PASSWORD="<password>"

# Apply registry credentials for access to container image registry
tanzu secret registry add registry-credentials \
   --server "${CONTAINER_IMAGE_REGISTRY}" \
   --username "${CONTAINER_IMAGE_REGISTRY_USERNAME}" \
   --password "${CONTAINER_IMAGE_REGISTRY_PASSWORD}" \
   --namespace "${WORKLOADS_NAMESPACE}"
```

To verify secret creation, run:

```shell
tanzu secret registry list -n ${WORKLOADS_NAMESPACE}
```

Output will be similar to:

```text
NAME                  REGISTRY        EXPORTED      AGE
registry-credentials  https://gcr.io  not exported  20s
```

### Apply namespace configurations

👉 Save [ytt-templated yaml configuration for workloads namespace here](#developer-namespace-configuration-ytt-template)
(found on this page below) -- select all and save to local filesystem. In the example below, the file is saved to the
default MacOS `Downloads` folder.

Apply the namespace configurations using `kapp`:

```shell
# The namespace in which your workloads will be applied to
export WORKLOADS_NAMESPACE="workloads"

# The Git repository hostname (without https prefix) where your workload source code lives. This example uses GitHub.
export GIT_REPOSITORY_HOSTNAME="github.com"

# Private/public key pair that allows read/write access to GIT_REPOSITORY_HOSTNAME
export GIT_REPOSITORY_SSH_PRIVATE_KEY="<private-key-string>"
export GIT_REPOSITORY_SSH_PUBLIC_KEY="<public-key-string>"

# Set known hosts string
export GIT_REPOSITORY_KNOWN_HOSTS="$(ssh-keyscan github.com)"

# Deploy kapp as per namespace spec yaml
ytt \
   --data-value-file=git_repository_hostname=<(echo "${GIT_REPOSITORY_HOSTNAME}") \
   --data-value-file=ssh_private_key=<(echo "${GIT_REPOSITORY_SSH_PRIVATE_KEY}") \
   --data-value-file=ssh_public_key=<(echo "${GIT_REPOSITORY_SSH_PUBLIC_KEY}") \
   --data-value-file=known_hosts=<(echo "${GIT_REPOSITORY_KNOWN_HOSTS}") \
   --data-value=namespace="${WORKLOADS_NAMESPACE}" \
   --file ~/Downloads/tap-dev-ns-setup.yaml |
   kapp deploy \
     --namespace ${WORKLOADS_NAMESPACE} \
     --app workload-prerequisites \
     --wait \
     --wait-timeout=120s \
     --diff-changes \
     --yes \
     --file -
```

By deploying with `kapp`, you have the power to _cleanly_ uninstall the configuration once you are done with the
demonstration or if there is an issue with the configuration.

✅ Your cluster is now ready to host Workloads.

## Uninstalling namespace configurations

To uninstall the above configurations, run:

```shell
# The namespace in which your workloads will be applied to
export WORKLOADS_NAMESPACE="workloads"

tanzu secret registry delete registry-credentials \
    --namespace "${WORKLOADS_NAMESPACE}" \
    --yes
kapp delete \
    --namespace ${WORKLOADS_NAMESPACE} \
    --app "workload-prerequisites" \
    --yes \
    --diff-changes
```

---

## Developer namespace configuration ytt template

```yaml
#@ load("@ytt:data", "data")
---
apiVersion: v1
kind: Namespace
metadata:
  name: #@ data.values.namespace
---
#! see: https://fluxcd.io/docs/components/source/gitrepositories/#ssh-authentication
apiVersion: v1
kind: Secret
metadata:
  name: git-ssh
  namespace: #@ data.values.namespace
  annotations:
    tekton.dev/git-0: #@ data.values.git_repository_hostname
type: kubernetes.io/ssh-auth
stringData:
  ssh-privatekey: #@ data.values.ssh_private_key
  identity: #@ data.values.ssh_private_key
  identity.pub: #@ data.values.ssh_public_key
  known_hosts: #@ data.values.known_hosts
---
apiVersion: v1
kind: Secret
metadata:
  name: tap-registry
  namespace: #@ data.values.namespace
  annotations:
    secretgen.carvel.dev/image-pull-secret: ""
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: e30K
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: default
  namespace: #@ data.values.namespace
  annotations:
    kapp.k14s.io/create-strategy: fallback-on-update
secrets:
  - name: git-ssh
  - name: registry-credentials
imagePullSecrets:
  - name: registry-credentials
  - name: tap-registry
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: default-permit-deliverable
  namespace: #@ data.values.namespace
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: deliverable
subjects:
  - kind: ServiceAccount
    name: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: default-permit-workload
  namespace: #@ data.values.namespace
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: workload
subjects:
  - kind: ServiceAccount
    name: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: dev-permit-app-editor
  namespace: #@ data.values.namespace
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: app-editor
subjects:
  - kind: Group
    name: "namespace-developers"
    apiGroup: rbac.authorization.k8s.io
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: namespace-dev-permit-app-editor
  namespace: #@ data.values.namespace
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: app-editor-cluster-access
subjects:
  - kind: Group
    name: "namespace-developers"
    apiGroup: rbac.authorization.k8s.io
```
