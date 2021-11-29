# Supply Chain Security Tools - Sign Release Notes

This topic contains release notes for Supply Chain Security Tools - Sign.

## v1.0.0-beta.2

**Release Date**: November 29, 2021

### New features
* Added configuration for ResourceQuotas. See `quota.pod_number`
* Number of replicas can be configured via `replicas` value

### Known issues

* A grype scan has reported the following false positives:
  * CVE-2015-5237
  * CVE-2017-7297
* See [Troubleshooting and Known Issues](known_issues.md).

## v1.0.0-beta.1

**Release Date**: October 26, 2021

### Breaking Changes
* `warn_on_unmatched` value has been renamed to `allow_unmatched_images`.

### Known issues

See [Troubleshooting and Known Issues](known_issues.md).

## v1.0.0-beta.0

**Release Date**: September 24, 2021

### Known issues

See [Troubleshooting and Known Issues](known_issues.md).