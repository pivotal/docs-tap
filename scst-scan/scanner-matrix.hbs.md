# Supported Scanner Matrix for Supply Chain Security Tools - Scan

This topic contains limits you observe with scanners which are provided for SCST - Scan. There might be more limits
which are not mentioned in the following table.

## Grype

<table>
    <tr>
        <th>Workload Type</th>
        <th>Impact </th>
        <th>Potential Workarounds </th>
    </tr>
    <tr>
        <td> .Net </td>
        <td> <p> <strong>Observation:</strong> <br> Source Scans for .Net workloads do not show any results in the Tanzu Developer Portal nor the CLI.  <br></br> If scanning a mono repository that includes additional types of packages, such as a front-end JavaScript package, source scans might report vulnerabilities. <br></br> <strong>Reason:</strong> <br> Grype requires a ".deps.json" file for identifying the dependencies for scanning. Given that this file is created after the .Net project is compiled (which happens after the source scan step), doing Grype  source scans on .Net workloads might not report any vulnerabilities. <br></br> Review the upstream issue <a href="https://github.com/anchore/syft/issues/1522">here</a>. </p> </td>
        <td> Grype image scans for .Net workloads function in most cases. <br> </br> If using an out-of-the-box Supply Chain with scanning, users can select one of the following options: <br></br><ol><li> Do nothing. Source scan might not report any vulnerabilities but image scan can. </li> <li> Edit the Supply Chain to use an <a href="https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.5/tap/scst-scan-install-scanners.html">alternative scanner</a>. </li> </ol></td>
    </tr>
    <tr>
        <td> Java </td>
        <td> <strong>Observation:</strong> <br> Source Scans for Java workloads do not show any results in the Tanzu Developer Portal nor the CLI. <br></br> <strong>Reason:</strong> <br>For Java using Gradle, dependency lock files are not guaranteed, so Grype uses dependencies present in the built binaries, such as `.jar` or `.war` files. Grype fails to find vulnerabilities during a source scan because VMware discourages committing binaries to source code repositories. <br></br> Review the upstream issue <a href="https://github.com/anchore/syft/issues/690">here</a>. </td>
        <td>Grype image scans for Java workloads function in most cases. <br></br> If using an out-of-the-box Supply Chain with scanning, users can select one of the following options: <br><ol><li> Do nothing. Source scan might not report any vulnerabilities but image scan can. </li><li> Edit the Supply Chain to use an <a href="https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.5/tap/scst-scan-install-scanners.html">alternative scanner</a> that supports Java for source scans. </li></ol></td>
    <tr>
