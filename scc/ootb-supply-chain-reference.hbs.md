# Supply Chains

TAP ships with a number of supply chains packages,
each of which installs two supply chains.
Only one supply chain package may be installed at one time.

## Source-to-URL

### Purpose

- Fetches application source code,
- builds it into an image,
- writes the Kubernetes configuration necessary to deploy the application,
- and commits that configuration to either a git repository or an image registry.

### Resources (steps)

- source-provider
- image-provider
- config-provider
- app-config
- service-bindings
- api-descriptors
- config-writer
- deliverable

### Package

[Out of the Box Supply Chain Basic](ootb-supply-chain-basic.hbs.md)

## Basic-Image-to-URL

- Fetches a prebuilt image,
- writes the Kubernetes configuration necessary to deploy the application,
- and commits that configuration to either a git repository or an image registry.

### Resources (steps)

- image-provider
- config-provider
- app-config
- service-bindings
- api-descriptors
- config-writer
- deliverable

### Package

[Out of the Box Supply Chain Basic](ootb-supply-chain-basic.hbs.md)

## Source-Test-to-URL

- Fetches application source code,
- runs user defined tests against the code,
- builds the code into an image,
- writes the Kubernetes configuration necessary to deploy the application,
- and commits that configuration to either a git repository or an image registry.

### Resources (steps)

- source-provider
- source-tester
- image-provider
- config-provider
- app-config
- service-bindings
- api-descriptors
- config-writer
- deliverable

### Package

[Out of the Box Supply Chain Testing](ootb-supply-chain-testing.hbs.md)

## Testing-Image-to-URL

- Fetches a prebuilt image,
- writes the Kubernetes configuration necessary to deploy the application,
- and commits that configuration to either a git repository or an image registry.

### Resources (steps)

- image-provider
- config-provider
- app-config
- service-bindings
- api-descriptors
- config-writer
- deliverable

### Package

[Out of the Box Supply Chain Testing](ootb-supply-chain-testing.hbs.md)

## Source-Test-Scan-to-URL

- Fetches application source code,
- runs user defined tests against the code,
- scans the code for vulnerabilities
- builds the code into an image,
- scans the image for vulnerabilities,
- writes the Kubernetes configuration necessary to deploy the application,
- and commits that configuration to either a git repository or an image registry.

### Resources (steps)

- source-provider
- source-tester
- source-scanner
- image-provider
- image-scanner
- config-provider
- app-config
- service-bindings
- api-descriptors
- config-writer
- deliverable

### Package

[Out of the Box Supply Chain Testing Scanning](ootb-supply-chain-testing-scanning.hbs.md)

## Scanning-Image-Scan-to-URL

- Fetches a prebuilt image,
- scans the image for vulnerabilities,
- writes the Kubernetes configuration necessary to deploy the application,
- and commits that configuration to either a git repository or an image registry.

### Resources (steps)

- source-provider
- source-tester
- source-scanner
- image-provider
- image-scanner
- config-provider
- app-config
- service-bindings
- api-descriptors
- config-writer
- deliverable

### Package

[Out of the Box Supply Chain Testing Scanning](ootb-supply-chain-testing-scanning.hbs.md)
