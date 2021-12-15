# Supply Chain Security Tools - Sign release notes

This topic contains release notes for Supply Chain Security Tools - Sign.


## v1.0.0-beta.3

**Release Date**: December 14, 2021

### New features

* Upgraded API version to v1beta1.

### Known issues

* A Grype scan has reported the following false positive:
    * [CVE-2015-5237](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-5237) is on the C implementation of Protocol Buffers. Supply Chain Security Tools - Sign uses the golang version.


## v1.0.0-beta.2

**Release Date**: November 29, 2021

### New features

* Added configuration for ResourceQuotas. See `quota.pod_number`
* Number of replicas can be configured via `replicas` value

### Known issues

* A Grype scan has reported the following false positives:
    * [CVE-2015-5237](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-5237) is on the C implementation of Protocol Buffers. Supply Chain Security Tools - Sign uses the golang version.
    * [CVE-2017-7297](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-7297) is on Rancher Server. Supply Chain Security Tools - Sign does not have this dependency.


## v1.0.0-beta.1

**Release Date**: October 26, 2021

### Breaking changes

* `warn_on_unmatched` value has been renamed to `allow_unmatched_images`.

### Known issues

See [Troubleshooting and Known Issues](known_issues.md).


## v1.0.0-beta.0

**Release Date**: September 24, 2021

### Known issues

See [Troubleshooting and Known Issues](known_issues.md).
