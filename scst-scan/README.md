# Vulnerability Scanning Enablement


## Clean Up
```bash
kubectl delete -f policy-enforcement-example.yaml
```

TODO: Add Image Scan

## Viewing Vulnerability Reports
TODO: Rework narrative with Metadata Store
The Scan Controller supports integration with the Metadata Store to save information about vulnerabilities and dependencies. You can query this vulnerability data using the Metadata Store `insight` CLI by providing the digest of the source or image scanned.

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

For more information, refer to [Using the Metadata Store](https://gitlab.eng.vmware.com/source-insight-tooling/insight-metadata-store/-/blob/alpha/README.md#using-the-metadata-store).

## Incorporating into CI/CD Pipelines
The Scan Controller is developed to be included within with your CI/CD pipelines, providing you information and reliability about the security of your Image or Source Code before promoting it further in your supply chain. You can use any tool for CI/CD pipelines, just ensure the following are included inside the template to trigger a new scan:
* Source Scans: the repository url and commit digest, or the path to the compressed file with the latest source code
* Image Scans: the image name and digest

After you update and apply the scan CR to your cluster, then the next step should be looking at the CR description to get feedback from the Status field (see [Viewing and Understanding Scan Status Conditions](results.md)) and from there, make the decision if promoting your Image or Source Code further or just fail the pipeline.

## Next Steps and Further Information
* [Running More Samples](samples/README.md)
* [Configuring Code Repositories and Image Artifacts to be Scanned](scan-crs.md)
* [Configuring Policy Enforcement using Open Policy Agent (OPA)](policies.md)
* [Viewing and Understanding Scan Status Conditions](results.md)
* [Observing and Troubleshooting](observing.md)

## Contact Us
Need help or want to cover something that is not mentioned?
Find us on [#tap-assist](https://app.slack.com/client/T024JFTN4/C02D60T1ZDJ) as `@sct-vse` or email us at [sct-vse@groups.vmware.com](mailto:sct-vse@groups.vmware.com).
