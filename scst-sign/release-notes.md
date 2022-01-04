# Supply Chain Security Tools - Sign release notes

This topic contains release notes for Supply Chain Security Tools - Sign.

## v1.0.0-beta.4

**Release Date**: December 21, 2021

### Breaking changes

* `ClusterImagePolicy` group has been renamed to `signing.apps.tanzu.vmware.com`
*  API version v1alpha1 is no longer supported. Use v1beta1.

### Known issues

* A Grype scan has reported the following false positive result:
    * [CVE-2015-5237](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-5237) is on the C
    implementation of Protocol Buffers. Supply Chain Security Tools - Sign uses the golang version.


## v1.0.0-beta.3

**Release Date**: December 14, 2021

### New feature

The API version is upgraded to v1beta1.

### Known issues

* A Grype scan has reported the following false positive result:
    * [CVE-2015-5237](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-5237) is on the C
    implementation of Protocol Buffers. Supply Chain Security Tools - Sign uses the golang version.


## v1.0.0-beta.2

**Release Date**: November 29, 2021

### New features

* Added configuration for ResourceQuotas. See `quota.pod_number`.
* The number of replicas can be configured through the `replicas` value.

### Known issues

* A Grype scan has reported the following false positive results:
    * [CVE-2015-5237](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-5237) is on the C implementation of Protocol Buffers. Supply Chain Security Tools - Sign uses the golang version.
    * [CVE-2017-7297](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2017-7297) is on Rancher Server. Supply Chain Security Tools - Sign does not have this dependency.


## v1.0.0-beta.1

**Release Date**: October 26, 2021

### Breaking change

The `warn_on_unmatched` value is renamed as `allow_unmatched_images`.

### Known issues

See [Supply Chain Security Tools - Sign known issues](known_issues.md).


## v1.0.0-beta.0

**Release Date**: September 24, 2021

### Known issues

See [Supply Chain Security Tools - Sign known issues](known_issues.md).
