# Configure an ImageVulnerabilityScan for Prisma

This topic gives you an example of how to configure a secret and ImageVulnerabilityScan (IVS) for Prisma.

## <a id="secret-example"></a> Example Secret
This section contains a sample secret containing the Prisma Cloud account access key, secret key, and console URL which are used to authenticate
your Prisma account. You must apply this once to your developer namespace.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: prisma-auth
stringData:
  username: USERNAME
  password: PASSWORD
  address: ADDRESS
```
Where:

- `USERNAME` is the access Key from the Prisma Cloud account.
- `PASSWORD` is the secret Key from the Prisma Cloud account.
- `ADDRESS` is the URL for Console from the Prisma Cloud account.

## <a id="example"></a> Example ImageVulnerabilityScan

This section contains a sample IVS that uses Prisma to scan a targeted image and push the results to
the specified registry location.
For information about the IVS specification, see [Configuration Options](ivs-create-your-own.hbs.md#img-vuln-config-options).

```yaml
apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
kind: ImageVulnerabilityScan
metadata:
  name: prisma-ivs
spec:
  image: TARGET-IMAGE
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
    securityContext:
      privileged: true
      allowPrivilegeEscalation: true
      seccompProfile:
        type: RuntimeDefault
      capabilities:
        drop:
          - ALL
    script: |
      #!/bin/bash
      # Alternative method of making twistcli available in the container
      curl --output ./twistcli --write-out "%{http_code}" -s -L -k -u $USER_NAME:$PASSWORD $ADDRESS/api/v1/util/twistcli
      chmod +x /workspace/twistcli

      if [[ ! -e /cred-helper/config.json ]]; then
      echo "{}" > /cred-helper/config.json
      fi

      podman pull $IMAGE
      twistcli images scan --podman-path /usr/bin/podman --address $ADDRESS --user $USER_NAME --password $PASSWORD $IMAGE --output-file ./twist-scan.json --containerized

      # Input commands used for your Prisma summary report conversion. See below for more detail.
      twistoutput=./twist-scan.json
      twistversion=$(./twistcli -v | sed "s/twistcli version //")
      IMAGE_NAME=$(echo $IMAGE | cut -d'@' -f1)
      IMAGE_DIGEST=$(echo $IMAGE | cut -d'@' -f2)
      /prismaconverter image $twistversion $twistoutput "./" "./scan-results/twist-scan-cdx.json" $IMAGE_NAME $IMAGE_DIGEST
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

- `TARGET-IMAGE` is the image to be scanned. You must specify the digest.
- `PRISMA-SCANNER-IMAGE` is the image containing the Prisma Cloud [twistcli](https://docs.paloaltonetworks.com/prisma/prisma-cloud/prisma-cloud-admin-compute/tools/twistcli), [podman](https://podman.io/docs/installation), and a utility to convert the Prisma summary report (JSON format) to a CycloneDX SBOM in XML format. The Prisma scanner produces a proprietary output instead of community standard CycloneDX or SPDX. Because of this, the scan report summary produced by Prisma cannot be used as is and must be converted.  Please contact your account team if you wish to use Prisma and need this utility.
- The `securityContext` grants root access as Prisma requires root access to run. If permission is not given, you may encounter a "cannot clone: Operation not permitted" error message. For details on the `securityContext`, see [Customize an ImageVulnerabilityScan](./ivs-create-your-own.hbs.md#customize-an-imagevulnerabilityscan). Due to needing root access, Prisma scans are not able to be run in clusters with restricted Pod Security Standards.

**Note** For information about using the CLI, see the Prisma twistcli [docs](https://docs.paloaltonetworks.com/prisma/prisma-cloud/prisma-cloud-admin-compute/tools/twistcli_scan_images).

### <a id="disclaimer"></a> Disclaimer

For the publicly available Prisma scanner CLI image, CLI commands and parameters used are accurate at
the time of documentation.
