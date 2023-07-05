# Configure an ImageVulnerabilityScan for Prisma

This topic tells you how to configure an ImageVulnerabilityScan for Prisma.

Install the following dependencies into the scanner image:
  - [podman](https://podman.io/docs/installation)
  - [twistcli](https://docs.paloaltonetworks.com/prisma/prisma-cloud/prisma-cloud-admin-compute/tools/twistcli)

Use the following ImageVulnerabilityScan configuration:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: prisma-auth
stringData:
  username: USERNAME
  password: PASSWORD
  address: ADDRESS
---
apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
kind: ImageVulnerabilityScan
metadata:
  name: prisma-ivs
spec:
  image: nginx@sha256:... # The image to be scanned. Digest must be specified.
  scanResults:
    location: registry/project/scan-results
  serviceAccountNames:
    publisher: publisher
    scanner: scanner
  steps:
  - name: prisma
    image: PRISMA-SCANNER-IMAGE
    imagePullPolicy: IfNotPresent
    workingDir: /workspace
    script: |
      #!/bin/bash
      podman pull $IMAGE
      twistcli images scan --podman-path /usr/bin/podman --address $ADDRESS --user $USER_NAME --password $PASSWORD $IMAGE --output-file ./scan-results/twist-scan.json --containerized
    env:
    - name: USER_NAME
      valueFrom:
        secretKeyRef:
          key: username
          name: prisma-auth
          optional: false
    - name: PASSWORD
      valueFrom:
        secretKeyRef:
          key: password
          name: prisma-auth
          optional: false
    - name: ADDRESS
      valueFrom:
        secretKeyRef:
          key: address
          name: prisma-auth
          optional: false
    - name: IMAGE
      value: $(params.image)
  workspace: {}
```

Where:

- `USERNAME` is the access Key from the Prisma Cloud account.
- `PASSWORD` is the secret Key from the Prisma Cloud account.
- `ADDRESS` is the URL for Console from the Prisma Cloud account.
- `PRISMA-SCANNER-IMAGE` is the Prisma scanner image with twistcli and podman.

**Note** For information about using the CLI, see the Prisma twistcli [docs](https://docs.paloaltonetworks.com/prisma/prisma-cloud/prisma-cloud-admin-compute/tools/twistcli_scan_images).