# Scan Types for Supply Chain Security Tools - Scan

This topic tells you what scan types you can use with SCST - Scan. The out-of-box test and scan supply chain supports the Source and Image scan types.

## Source Scan

The source scan step in the test and scan supply chain performs a Software Composition Analysis (SCA) scan to inspect the open source dependencies of an application for vulnerabilities.  This is typically performed by inspecting the file that the language uses for dependency declaration.  For example:

| Language | Dependency File |
| ---- | ---- |
| Spring | pom.xml |
| .Net | deps.json |
| Node.JS | packages.json |
| Python | requirements.txt| 

Rather than declare specific dependency versions, some languages such as Spring, Java, and .Net resolve dependency versions at build time. For these languages, performing a SCA scan on the declaration file stored in the source code does not produce meaningful results, often creating false positives or false negatives.

Due to this, in Tanzu Application Platform 1.6, the source scan step is moved to an opt-in step in the supply chain. To add source scan to the supply chain, follow the steps below.

### Adding Source Scan to a Supply Chain

There are two methods for adding source scan to a supply chain. 

#### Creating a Custom Supply Chain from the existing test + scan supply chain

Steps TBD

#### Applying an overlay in the install values.yaml

Steps TBD
