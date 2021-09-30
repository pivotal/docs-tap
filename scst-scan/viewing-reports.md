# Viewing Vulnerability Reports

To view vulnerability reports, you must use the Metadata Store (see [Metadata Store Documentation](../scst-store/overview.md)), which is a postgres database that stores image, package, and vulnerability Metadata Store to save information about vulnerabilities and dependencies. You can query this vulnerability data using the Metadata Store `insight` CLI by providing the digest of the source or image scanned.

For example, to query Vulnerability data relating to an Image Scan:
```bash
# In another terminal (ensure the namespace is correct):
kubectl port-forward service/metadata-app-postgres 8080:8080 -n metadata-store

# Then back in the main terminal, check you are targeting the port-forwarded port:
insight config set-target http://localhost:8080

# Query for image scans:
kubectl get imagescans

# and grab the sha256 digest and replace in the following example query:
insight image get \
  --digest sha256:06ba459dc32475871646f22c980d5db4335021d76e1693c8a87bf02aed8c1a3e \
  --format json
```
