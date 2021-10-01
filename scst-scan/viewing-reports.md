# Viewing Vulnerability Results

After completing the scans from the previous step, query the [SCST - Store](../scst-store/overview.md) to view your vulnerability results. The SCST - Store is a Tanzu component that stores image, package, and vulnerability metadata about your dependencies. Use the SCST - Store CLI, called `insight`, to query metadata that have been submitted to the store after the scan step.

For example, to query Vulnerability data relating to an Image Scan:
```bash
# Query for image scans:
kubectl get imagescans

# and grab the sha256 digest and replace in the following example query:
insight image get \
  --digest sha256:06ba459dc32475871646f22c980d5db4335021d76e1693c8a87bf02aed8c1a3e \
  --format json
```

**NOTE:** You must have the [SCST - Store prerequisites](../scst-store/using_metadata_store.md) in place for the above example to work.

For a complete guide on how to query the store, see [Querying SCST - Store](../scst-store/querying_the_metadata_store.md).