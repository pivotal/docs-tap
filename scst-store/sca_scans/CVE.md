# SCA Scanning Results

## Scan Type:
Software Composition Analysis scanning

## Source of Scan:

* Black Duck Binary Analysis (BDBA)
* Grype

## Version of Source:

* BDBA version SDL 4.2
* Grype version 0.25.1

## CVEs
### BDBA
No vulnerabilities found in both the binaries of metadata-store and CLI.

Links to the reports on appcheck:
* [metadata-store report](store-bdba-scan-2021-11-26.pdf)
* [CLI report](cli-bdba-scan-2021-11-26.pdf)

### Grype
No vulnerabilities found through scanning the sources of metadata-store, client lib, and CLI

The following CVEs were found through scanning the metadata-store image:
```
NAME   INSTALLED        FIXED-IN  VULNERABILITY   SEVERITY   
libc6  2.27-3ubuntu1.4            CVE-2015-8985   Negligible  
libc6  2.27-3ubuntu1.4            CVE-2016-10739  Low         
libc6  2.27-3ubuntu1.4            CVE-2020-6096   Low         
libc6  2.27-3ubuntu1.4            CVE-2021-3326   Low         
libc6  2.27-3ubuntu1.4            CVE-2020-27618  Low         
libc6  2.27-3ubuntu1.4            CVE-2019-25013  Low         
libc6  2.27-3ubuntu1.4            CVE-2021-35942  Medium      
libc6  2.27-3ubuntu1.4            CVE-2021-33574  Low         
libc6  2.27-3ubuntu1.4            CVE-2021-38604  Medium      
libc6  2.27-3ubuntu1.4            CVE-2016-10228  Negligible  
libc6  2.27-3ubuntu1.4            CVE-2009-5155   Negligible  
```
No `high` or `critical` CVEs present.
