# Uninstalling Vulnerability Scanning Enablement

This document describes how to uninstall.

## Remove the Scan Controller and CRDs
```bash
kapp delete -a canal
```

## Remove the Grype Scanner and ScanTemplates
```bash
kapp delete -a grype-templates
```
