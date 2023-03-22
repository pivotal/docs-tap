# Supported Scanner Matrix for Supply Chain Security Tools - Scan

This topic contains limits observed with scanners which are provided with Tanzu
Application Platform Supply Chain Security Tools. There might be more limits
which are not mentioned in the following table.

| Grype |  | |
|--------|-----------|---|
|  .Net | Source Scans for .Net workloads don't show any results in the TAPGUI or the CLI because Grype uses `.deps.json` for finding dependencies. This file is created after compilation of a `.Net` project, making source scanning unable to find dependencies. | Vulnerabilities are still found during the image scan step because the application is already compiled and shipped into an image. You can also [Modify an Out of the Box Supply Chain](../scc/authoring-supply-chains.hbs.md#modify-sc) to skip the SourceScan step, or [Implement your own scanner](create-scan-template.hbs.md) to use a different one that supports `.Net` for source scans. |
| Java | No network calls are performed to fetch dependencies. For Java using Gradle, dependency lock files are not guaranteed, so Grype uses dependencies present in the built binaries, such as `.jar` or `.war` files. Grype fails to find vulnerabilities during a source scan because VMware discourages committing binaries to source code repositories. | Vulnerabilities are still found during the image scan step because the application is already compiled and shipped into an image. You can also [Modifying an Out of the Box Supply Chain](../scc/authoring-supply-chains.hbs.md#modify-sc) to skip the SourceScan step, or [Implement your own scanner](create-scan-template.hbs.md) to use a different one that supports Java for source scans. |
