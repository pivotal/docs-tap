# Viewing vulnerability results

After completing the scans, query the [Supply Chain Security Tools - Store](../scst-store/overview.md) to view your vulnerability results. The Supply Chain Security Tools - Store is a Tanzu component that stores image, package, and vulnerability metadata about your dependencies. Use the Supply Chain Security Tools - Store CLI, called `insight`, to query metadata that is submitted to the store.

For example, to query Vulnerability data relating to an Source Scan, run:
```bash
# Query for source scans:
kubectl get sourcescans

# Create a query:
insight source get \
  --repo <repository> \
  --commit <commit> \
  --org <organization> \
  --format <format>

# For example:
insight source get \
  --repo hound \
  --commit 5805c6502976c10f5529e7f7aeb0af0c370c0354 \
  --org houndci \
  --format json
```

Where:

* `repository` is the repository extracted from the `SCANNEDREPOSITORY` column
* `commit` is the commit hash from the `SCANNEDREVISION` column
* `organization` is the code repository project/organization extracted from the `SCANNEDREPOSITORY` column
* `format` is the format, such as `json`

For example, to query Vulnerability data relating to an Image Scan, run:
```bash
# Query for image scans:
kubectl get imagescans

# Create the query:
insight image get \
  --digest sha256:<digest> \
  --format <format>

# and grab the sha256 digest and replace in the following example query:
insight image get \
  --digest sha256:d20aa6d1cae56fd17cd458f4807e0de462caf2336f0b70b5eeb69fcaaf30dd9c \
  --format json
```

Where:

* `digest` is the sha256 digest extracted from the `SCANNEDIMAGE` column
* `format` is the format, such as `json`

> **NOTE:** You must have the Supply Chain Security Tools - Store prerequisites for the example to
run successfully. For more information, see
[Install Supply Chain Security Tools - Store](../install-components.md#install-scst-store).

For a complete guide on how to query the store, see [Querying Supply Chain Security Tools - Store](../scst-store/querying_the_metadata_store.md).
