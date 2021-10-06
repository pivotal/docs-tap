# Running a Sample Private Source Scan

## Define the Resources
Create `private-source-example.yaml` and ensure you enter a valid private ssh key value in the secret:
```yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: secret-ssh-auth
type: kubernetes.io/ssh-auth
stringData:
  ssh-privatekey: # insert your PEM-encoded ssh private key

---
apiVersion: scanning.apps.tanzu.vmware.com/v1alpha1
kind: SourceScan
metadata:
  name: private-source-example
spec:
  git:
    url: "gitlab.eng.vmware.com:vulnerability-scanning-enablement/private-test-target.git"
    revision: ""
    # ssh-keyscan $HOST
    knownHosts: |
      gitlab.eng.vmware.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIW3CobFtjtaGAbNvW1w7Z1+nOV131I2GQ4T/v6elt8caUxo+NK8w4R0ywLc5FiIa3RQ6CuyHfkO6cnJGQm3n3Q=
      gitlab.eng.vmware.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4784G+YRcwc+pK2pmPJdADBmU0ji10OQu80mbwmNUxneeSuMFq95YyX31d+yfbRBp1JMlf9nunZ66ijUf9lH4nLlDxmzZC8ZZOV/vF7b6+MR8MjU2IucryDEfbHwIvemKv3miva297Ilbb4dIOOK2OmzZWG5VHUW5UCA2ELDn/DDGzgq1Jns5f8jIR/KIr7FJfKysohGMgSAFBTLEUSl25rRYQxppmhpYhaamk0d3jJfbXDAVXp1CMgb5GFWUGA2e7YGXUNxbqTLvGqbRXYKTxnBBnmZMAByGNMMCtXLKkdZdPuWyI3b7zKH8nKXVLvmdwAJuqHgF1L6I2WcMw17j
      gitlab.eng.vmware.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICCmpTsIB79xM9b3a3gDRk8zgdkOkoSJeiDYUzG+TWTt
  scanTemplate: private-source-scan-template
```

## (Optional) Set Up a Watch
Before deploying, set up a watch in another terminal to see things process which will be quick.
```bash
watch kubectl get scantemplates,scanpolicies,sourcescans,imagescans,pods,jobs
```

For more information, refer to [Observing and Troubleshooting](../observing.md).

## Deploy the Resources
```bash
kubectl apply -f private-source-example.yaml
```

## View the Scan Status
Once the scan has completed, perform:
```bash
kubectl describe sourcescan private-source-example
```
and notice the `Status.Conditions` includes a `Reason: JobFinished` and `Message: The scan job finished`.

For more information, refer to [Viewing and Understanding Scan Status Conditions](../results.md).

## Clean Up
```bash
kubectl delete -f private-source-example.yaml
```

## View Vulnerability Reports
See [Viewing Vulnerability Reports](../viewing-reports.md) section