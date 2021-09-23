# Relocating Images to Another Registry
For more information, refer to the [Carvel imgpkg Air-Gapped Workflow](https://carvel.dev/imgpkg/docs/latest/air-gapped-workflow/) page.

## With Intermediate Tarball

### Step 1: Save the Bundles to Tarballs
```bash
imgpkg copy \
  -b harbor-repo.vmware.com/supply_chain_security_tools/scan-controller:v1.0.0-alpha.1 \
  --to-tar /tmp/scan-controller.tar

imgpkg copy \
  -b harbor-repo.vmware.com/supply_chain_security_tools/grype-templates:v1.0.0-alpha.1 \
  --to-tar /tmp/grype-templates.tar
```

### Step 2: Authenticate with the Destination Registry
```bash
read -p "Server: " REGISTRY_SERVER
read -p "Project: " REGISTRY_PROJECT
read -p "Username: " REGISTRY_USERNAME
read -p "Password: " -s REGISTRY_PASSWORD
```

### Step 3: Import the Bundles from the Tarballs to the Destination Registry
```bash
imgpkg copy \
  --tar /tmp/scan-controller.tar \
  --to-repo ${REGISTRY_SERVER}/${REGISTRY_PROJECT}/scan-controller:v1.0.0-alpha.1

imgpkg copy \
  --tar /tmp/grype-templates.tar \
  --to-repo ${REGISTRY_SERVER}/${REGISTRY_PROJECT}/grype-templates:v1.0.0-alpha.1
```

### Step 4: Pull the Bundles from the Destination Registry
```bash
imgpkg pull \
  -b ${REGISTRY_SERVER}/${REGISTRY_PROJECT}/scan-controller:v1.0.0-alpha.1 \
  -o /tmp/scan-controller

imgpkg pull \
  -b ${REGISTRY_SERVER}/${REGISTRY_PROJECT}/grype-templates:v1.0.0-alpha.1 \
  -o /tmp/grype-templates
```
