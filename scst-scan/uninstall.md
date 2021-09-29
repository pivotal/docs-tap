# Uninstalling the Scan Controller and Grype Scanner

This document describes how to uninstall.

## Remove the Scan Controller and CRDs
```bash
tanzu installed delete scan-controller
```

## Remove the Grype Scanner and ScanTemplates
```bash
tanzu installed delete grype-scanner
```
