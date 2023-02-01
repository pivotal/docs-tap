# Supported Scanner Matrix for Supply Chain Security Tools - Scan

This page contains limitations observed with scanners which are provided with TAP Supply Chain Security Tools. There could be more limitations which are not mentioned in the table below.


|  | Grype |
|--------|-----------|
|  .Net |  Grype uses .deps.json for finding dependencies. This file is created after compilation of a .Net project making source scanning unable to find dependencies. However the vulnerabilities are still found during the image scan after the compilation, when the application is packaged as images. |
| Java | No network calls are performed to fetch dependencies. For Java using Gradle, dependency lock files are not guaranteed, so Grype uses dependencies present in the built binaries, such as .jar or .war files. Because VMware discourages committing binaries to source code repositories, Grype fails to find vulnerabilities during a source scan. The vulnerabilities are still found during the image scan after the binaries are built and packaged as images. |
