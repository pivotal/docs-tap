# Troubleshoot Rego files with a scan policy for Supply Chain Security Tools - Scan

This topic describes how you can use an example output to troubleshoot your Rego file for SCST - Scan. You use a Rego file in a scan policy custom resource. See [Enforce compliance policy using Open Policy Agent](./policies.hbs.md).

For information about how to write Rego, see [Open Policy Agent documentation](https://www.openpolicyagent.org/docs/latest/policy-language/).

## <a id="rego-playground"></a> Using the Rego playground

Use the [Rego Playground](https://play.openpolicyagent.org/), to evaluate your Rego file against an input. In this example, use the example output of an image or source scan custom resource.

### <a id="sample-input-cyclonedx"></a> Sample input in CycloneDX's XML re-encoded as JSON format

The following is an example scan custom resource output in CycloneDX's XML structure re-encoded as JSON. This example output contains CVEs at low, medium, high, and critical severities. 

To troubleshoot using this example output:

1. Paste your Rego file and the example output into the [Rego Playground](https://play.openpolicyagent.org/).
2. Evaluate your Rego file against the example output and verify that your Rego file detects the intended CVEs. See this Rego [example](https://play.openpolicyagent.org/p/wwkyrYbHAv).

```json
{
    "bom": {
        "-serialNumber": "urn:uuid:123",
        "-v": "http://cyclonedx.org/schema/ext/vulnerability/1.0",
        "-version": "1",
        "-xmlns": "http://cyclonedx.org/schema/bom/1.2",
        "components": {
            "component": [
                {
                    "-type": "library",
                    "licenses": {
                        "license": {
                            "name": "GPL-2"
                        }
                    },
                    "name": "adduser",
                    "version": "3.118",
                    "vulnerabilities": {
                        "vulnerability": [
                            {
                                "-ref": "urn:uuid:3d7c61c6-9cfa-494c-858a-9668a318ff23",
                                "advisories": {
                                    "advisory": "https://security-tracker.debian.org/tracker/CVE-2011-3374"
                                },
                                "id": "CVE-2011-3374-a",
                                "ratings": {
                                    "rating": {
                                        "severity": "Low"
                                    }
                                },
                                "source": {
                                    "-name": "debian:10",
                                    "url": "http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-3374"
                                }
                            },
                            {
                                "-ref": "urn:uuid:ebabaa92-2bf9-4d33-8181-595b0fdf55bd",
                                "advisories": {
                                    "advisory": "https://security-tracker.debian.org/tracker/CVE-2020-27350"
                                },
                                "id": "CVE-2020-27350-a",
                                "ratings": {
                                    "rating": {
                                        "severity": "Medium"
                                    }
                                },
                                "source": {
                                    "-name": "debian:10",
                                    "url": "http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2020-27350"
                                }
                            },
                            {
                                "-ref": "urn:uuid:07c58c81-1e01-459d-9e9d-0e10456a9bf0",
                                "advisories": {
                                    "advisory": "https://security-tracker.debian.org/tracker/CVE-2020-3810"
                                },
                                "id": "CVE-2020-3810-a",
                                "ratings": {
                                    "rating": {
                                        "severity": "Medium"
                                    }
                                },
                                "source": {
                                    "-name": "debian:10",
                                    "url": "http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2020-3810"
                                }
                            }
                        ]
                    }
                },
                {
                    "-type": "library",
                    "licenses": {
                        "license": [
                            {
                                "name": "GPL-2"
                            },
                            {
                                "name": "GPLv2+"
                            }
                        ]
                    },
                    "name": "apt",
                    "version": "1.8.2",
                    "vulnerabilities": {
                        "vulnerability": [
                            {
                                "-ref": "urn:uuid:3d7c61c6-9cfa-494c-858a-9668a318ff23",
                                "advisories": {
                                    "advisory": "https://security-tracker.debian.org/tracker/CVE-2011-3374"
                                },
                                "id": "CVE-2011-3374",
                                "ratings": {
                                    "rating": {
                                        "severity": "Low"
                                    }
                                },
                                "source": {
                                    "-name": "debian:10",
                                    "url": "http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-3374"
                                }
                            },
                            {
                                "-ref": "urn:uuid:ebabaa92-2bf9-4d33-8181-595b0fdf55bd",
                                "advisories": {
                                    "advisory": "https://security-tracker.debian.org/tracker/CVE-2020-27350"
                                },
                                "id": "CVE-2020-27350",
                                "ratings": {
                                    "rating": {
                                        "severity": "High"
                                    }
                                },
                                "source": {
                                    "-name": "debian:10",
                                    "url": "http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2020-27350"
                                }
                            },
                            {
                                "-ref": "urn:uuid:07c58c81-1e01-459d-9e9d-0e10456a9bf0",
                                "advisories": {
                                    "advisory": "https://security-tracker.debian.org/tracker/CVE-2020-3810"
                                },
                                "id": "CVE-2020-3810",
                                "ratings": {
                                    "rating": {
                                        "severity": "Critical"
                                    }
                                },
                                "source": {
                                    "-name": "debian:10",
                                    "url": "http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2020-3810"
                                }
                            }
                        ]
                    }
                }
            ]
        },
        "metadata": {
            "component": {
                "-type": "container",
                "name": "nginx:1.16",
                "version": "sha256:123"
            },
            "timestamp": "2022-01-28T13:30:43-08:00",
            "tools": {
                "tool": {
                    "name": "grype",
                    "vendor": "anchore",
                    "version": "[not provided]"
                }
            }
        }
    }
}
```

### <a id="sample-input-spdx"></a> Example input in SPDX JSON format

The example in this section is a modified scan custom resource input, in  `.spdx.json`, that contains CVEs at low, medium, high, and critical severities. You can use this example input to evaluate your Rego file.

To troubleshoot using this example output:

1. Paste your Rego file and the example input into the [Rego Playground](https://play.openpolicyagent.org/).
2. Evaluate your Rego file against the output and verify that your Rego file detects the intended CVEs. See this Rego [example](https://play.openpolicyagent.org/p/gp0fUfaxOC). 

```json
{
  "id": "SPDXRef-docker-image|nginx",
  "specVersion": "SPDX-3.0",
  "creator": "Organization: Snyk Ltd",
  "created": "2023-03-01T16:10:08Z",
  "profile": [
    "base",
    "vulnerabilities"
  ],
  "description": "Snyk test result for project docker-image|nginx in SPDX SBOM format",
  "vulnerabilities": [
    {
      "id": "SNYK-DEBIAN10-APT-1049974",
      "name": "SNYK-DEBIAN10-APT-1049974",
      "summary": "Integer Overflow or Wraparound",
      "details": "## NVD Description\n**_Note:_** _Versions mentioned in the description apply only to the upstream `apt` package and not the `apt` package as distributed by `Debian:10`._\n_See `How to fix?` for `Debian:10` relevant fixed versions and status._\n\nAPT had several integer overflows and underflows while parsing .deb packages, aka GHSL-2020-168 GHSL-2020-169, in files apt-pkg/contrib/extracttar.cc, apt-pkg/deb/debfile.cc, and apt-pkg/contrib/arfile.cc. This issue affects: apt 1.2.32ubuntu0 versions prior to 1.2.32ubuntu0.2; 1.6.12ubuntu0 versions prior to 1.6.12ubuntu0.2; 2.0.2ubuntu0 versions prior to 2.0.2ubuntu0.2; 2.1.10ubuntu0 versions prior to 2.1.10ubuntu0.1;\n## Remediation\nUpgrade `Debian:10` `apt` to version 1.8.2.2 or higher.\n## References\n- [ADVISORY](https://security-tracker.debian.org/tracker/CVE-2020-27350)\n- [CONFIRM](https://bugs.launchpad.net/bugs/1899193)\n- [CONFIRM](https://security.netapp.com/advisory/ntap-20210108-0005/)\n- [DEBIAN](https://www.debian.org/security/2020/dsa-4808)\n- [UBUNTU](https://usn.ubuntu.com/usn/usn-4667-1)\n",
      "relationships": [
        {
          "affect": {
            "to": [
              "docker-image|nginx@1.16",
              "apt/libapt-pkg5.0@1.8.2"
            ],
            "type": "AFFECTS"
          },
          "foundBy": {
            "to": [
              ""
            ],
            "type": "FOUND_BY"
          },
          "suppliedBy": {
            "to": [
              ""
            ],
            "type": "SUPPLIED_BY"
          },
          "ratedBy": {
            "to": [
              ""
            ],
            "type": "RATED_BY",
            "cwes": [
              190
            ],
            "rating": [
              {
                "method": "CVSS_3",
                "score": [
                  {
                    "base": 5.7
                  }
                ],
                "severity": "Medium",
                "vector": "CVSS:3.1/AV:L/AC:L/PR:H/UI:N/S:C/C:L/I:L/A:L"
              }
            ]
          }
        }
      ],
      "externalReferences": [
        {
          "category": "ADVISORY",
          "locator": "https://security-tracker.debian.org/tracker/CVE-2020-27350"
        },
        {
          "category": "ADVISORY",
          "locator": "https://bugs.launchpad.net/bugs/1899193"
        },
        {
          "category": "ADVISORY",
          "locator": "https://security.netapp.com/advisory/ntap-20210108-0005/"
        },
        {
          "category": "ADVISORY",
          "locator": "https://www.debian.org/security/2020/dsa-4808"
        },
        {
          "category": "ADVISORY",
          "locator": "https://usn.ubuntu.com/usn/usn-4667-1"
        }
      ],
      "modified": "2022-10-29T13:11:02.438923Z",
      "published": "2020-12-10T03:10:23.901831Z"
    },
    {
      "id": "SNYK-DEBIAN10-APT-407502",
      "name": "SNYK-DEBIAN10-APT-407502",
      "summary": "Improper Verification of Cryptographic Signature",
      "details": "## NVD Description\n**_Note:_** _Versions mentioned in the description apply only to the upstream `apt` package and not the `apt` package as distributed by `Debian:10`._\n_See `How to fix?` for `Debian:10` relevant fixed versions and status._\n\nIt was found that apt-key in apt, all versions, do not correctly validate gpg keys with the primary keyring, leading to a potential man-in-the-middle attack.\n## Remediation\nThere is no fixed version for `Debian:10` `apt`.\n## References\n- [ADVISORY](https://security-tracker.debian.org/tracker/CVE-2011-3374)\n- [Debian Bug Report](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=642480)\n- [MISC](https://people.canonical.com/~ubuntu-security/cve/2011/CVE-2011-3374.html)\n- [MISC](https://seclists.org/fulldisclosure/2011/Sep/221)\n- [MISC](https://snyk.io/vuln/SNYK-LINUX-APT-116518)\n- [MISC](https://ubuntu.com/security/CVE-2011-3374)\n- [RedHat CVE Database](https://access.redhat.com/security/cve/cve-2011-3374)\n",
      "relationships": [
        {
          "affect": {
            "to": [
              "docker-image|nginx@1.16",
              "apt/libapt-pkg5.0@1.8.2"
            ],
            "type": "AFFECTS"
          },
          "foundBy": {
            "to": [
              ""
            ],
            "type": "FOUND_BY"
          },
          "suppliedBy": {
            "to": [
              ""
            ],
            "type": "SUPPLIED_BY"
          },
          "ratedBy": {
            "to": [
              ""
            ],
            "type": "RATED_BY",
            "cwes": [
              347
            ],
            "rating": [
              {
                "method": "CVSS_3",
                "score": [
                  {
                    "base": 3.7
                  }
                ],
                "severity": "Low",
                "vector": "CVSS:3.1/AV:N/AC:H/PR:N/UI:N/S:U/C:N/I:L/A:N"
              }
            ]
          }
        }
      ],
      "externalReferences": [
        {
          "category": "ADVISORY",
          "locator": "https://security-tracker.debian.org/tracker/CVE-2011-3374"
        },
        {
          "category": "ADVISORY",
          "locator": "https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=642480"
        },
        {
          "category": "ADVISORY",
          "locator": "https://people.canonical.com/~ubuntu-security/cve/2011/CVE-2011-3374.html"
        },
        {
          "category": "ADVISORY",
          "locator": "https://seclists.org/fulldisclosure/2011/Sep/221"
        },
        {
          "category": "ADVISORY",
          "locator": "https://snyk.io/vuln/SNYK-LINUX-APT-116518"
        },
        {
          "category": "ADVISORY",
          "locator": "https://ubuntu.com/security/CVE-2011-3374"
        },
        {
          "category": "ADVISORY",
          "locator": "https://access.redhat.com/security/cve/cve-2011-3374"
        }
      ],
      "modified": "2022-11-01T00:08:27.375895Z",
      "published": "2018-06-27T16:20:45.037549Z"
    },
    {
      "id": "SNYK-DEBIAN10-APT-568926",
      "name": "SNYK-DEBIAN10-APT-568926",
      "summary": "Improper Input Validation",
      "details": "## NVD Description\n**_Note:_** _Versions mentioned in the description apply only to the upstream `apt` package and not the `apt` package as distributed by `Debian:10`._\n_See `How to fix?` for `Debian:10` relevant fixed versions and status._\n\nMissing input validation in the ar/tar implementations of APT before version 2.1.2 could result in denial of service when processing specially crafted deb files.\n## Remediation\nUpgrade `Debian:10` `apt` to version 1.8.2.1 or higher.\n## References\n- [ADVISORY](https://security-tracker.debian.org/tracker/CVE-2020-3810)\n- [FEDORA](https://lists.fedoraproject.org/archives/list/package-announce@lists.fedoraproject.org/message/U4PEH357MZM2SUGKETMEHMSGQS652QHH/)\n- [GitHub Issue](https://github.com/Debian/apt/issues/111)\n- [MISC](https://bugs.launchpad.net/bugs/1878177)\n- [MISC](https://lists.debian.org/debian-security-announce/2020/msg00089.html)\n- [MISC](https://salsa.debian.org/apt-team/apt/-/commit/dceb1e49e4b8e4dadaf056be34088b415939cda6)\n- [MISC](https://tracker.debian.org/news/1144109/accepted-apt-212-source-into-unstable/)\n- [UBUNTU](https://usn.ubuntu.com/4359-2/)\n- [Ubuntu CVE Tracker](http://people.ubuntu.com/~ubuntu-security/cve/CVE-2020-3810)\n- [Ubuntu Security Advisory](https://usn.ubuntu.com/4359-1/)\n",
      "relationships": [
        {
          "affect": {
            "to": [
              "docker-image|nginx@1.16",
              "apt/libapt-pkg5.0@1.8.2"
            ],
            "type": "AFFECTS"
          },
          "foundBy": {
            "to": [
              ""
            ],
            "type": "FOUND_BY"
          },
          "suppliedBy": {
            "to": [
              ""
            ],
            "type": "SUPPLIED_BY"
          },
          "ratedBy": {
            "to": [
              ""
            ],
            "type": "RATED_BY",
            "cwes": [
              20
            ],
            "rating": [
              {
                "method": "CVSS_3",
                "score": [
                  {
                    "base": 5.5
                  }
                ],
                "severity": "Medium",
                "vector": "CVSS:3.1/AV:L/AC:L/PR:N/UI:R/S:U/C:N/I:N/A:H"
              }
            ]
          }
        }
      ],
      "externalReferences": [
        {
          "category": "ADVISORY",
          "locator": "https://security-tracker.debian.org/tracker/CVE-2020-3810"
        },
        {
          "category": "ADVISORY",
          "locator": "https://lists.fedoraproject.org/archives/list/package-announce@lists.fedoraproject.org/message/U4PEH357MZM2SUGKETMEHMSGQS652QHH/"
        },
        {
          "category": "ADVISORY",
          "locator": "https://github.com/Debian/apt/issues/111"
        },
        {
          "category": "ADVISORY",
          "locator": "https://bugs.launchpad.net/bugs/1878177"
        },
        {
          "category": "ADVISORY",
          "locator": "https://lists.debian.org/debian-security-announce/2020/msg00089.html"
        },
        {
          "category": "ADVISORY",
          "locator": "https://salsa.debian.org/apt-team/apt/-/commit/dceb1e49e4b8e4dadaf056be34088b415939cda6"
        },
        {
          "category": "ADVISORY",
          "locator": "https://tracker.debian.org/news/1144109/accepted-apt-212-source-into-unstable/"
        },
        {
          "category": "ADVISORY",
          "locator": "https://usn.ubuntu.com/4359-2/"
        },
        {
          "category": "ADVISORY",
          "locator": "http://people.ubuntu.com/~ubuntu-security/cve/CVE-2020-3810"
        },
        {
          "category": "ADVISORY",
          "locator": "https://usn.ubuntu.com/4359-1/"
        }
      ],
      "modified": "2022-11-01T00:08:51.907776Z",
      "published": "2020-05-12T14:19:01.052295Z"
    },
    {
      "id": "SNYK-DEBIAN10-APT-1049974",
      "name": "SNYK-DEBIAN10-APT-1049974",
      "summary": "Integer Overflow or Wraparound",
      "details": "## NVD Description\n**_Note:_** _Versions mentioned in the description apply only to the upstream `apt` package and not the `apt` package as distributed by `Debian:10`._\n_See `How to fix?` for `Debian:10` relevant fixed versions and status._\n\nAPT had several integer overflows and underflows while parsing .deb packages, aka GHSL-2020-168 GHSL-2020-169, in files apt-pkg/contrib/extracttar.cc, apt-pkg/deb/debfile.cc, and apt-pkg/contrib/arfile.cc. This issue affects: apt 1.2.32ubuntu0 versions prior to 1.2.32ubuntu0.2; 1.6.12ubuntu0 versions prior to 1.6.12ubuntu0.2; 2.0.2ubuntu0 versions prior to 2.0.2ubuntu0.2; 2.1.10ubuntu0 versions prior to 2.1.10ubuntu0.1;\n## Remediation\nUpgrade `Debian:10` `apt` to version 1.8.2.2 or higher.\n## References\n- [ADVISORY](https://security-tracker.debian.org/tracker/CVE-2020-27350)\n- [CONFIRM](https://bugs.launchpad.net/bugs/1899193)\n- [CONFIRM](https://security.netapp.com/advisory/ntap-20210108-0005/)\n- [DEBIAN](https://www.debian.org/security/2020/dsa-4808)\n- [UBUNTU](https://usn.ubuntu.com/usn/usn-4667-1)\n",
      "relationships": [
        {
          "affect": {
            "to": [
              "docker-image|nginx@1.16",
              "apt@1.8.2",
              "apt/libapt-pkg5.0@1.8.2"
            ],
            "type": "AFFECTS"
          },
          "foundBy": {
            "to": [
              ""
            ],
            "type": "FOUND_BY"
          },
          "suppliedBy": {
            "to": [
              ""
            ],
            "type": "SUPPLIED_BY"
          },
          "ratedBy": {
            "to": [
              ""
            ],
            "type": "RATED_BY",
            "cwes": [
              190
            ],
            "rating": [
              {
                "method": "CVSS_3",
                "score": [
                  {
                    "base": 5.7
                  }
                ],
                "severity": "Medium",
                "vector": "CVSS:3.1/AV:L/AC:L/PR:H/UI:N/S:C/C:L/I:L/A:L"
              }
            ]
          }
        }
      ],
      "externalReferences": [
        {
          "category": "ADVISORY",
          "locator": "https://security-tracker.debian.org/tracker/CVE-2020-27350"
        },
        {
          "category": "ADVISORY",
          "locator": "https://bugs.launchpad.net/bugs/1899193"
        },
        {
          "category": "ADVISORY",
          "locator": "https://security.netapp.com/advisory/ntap-20210108-0005/"
        },
        {
          "category": "ADVISORY",
          "locator": "https://www.debian.org/security/2020/dsa-4808"
        },
        {
          "category": "ADVISORY",
          "locator": "https://usn.ubuntu.com/usn/usn-4667-1"
        }
      ],
      "modified": "2022-10-29T13:11:02.438923Z",
      "published": "2020-12-10T03:10:23.901831Z"
    },
    {
      "id": "SNYK-DEBIAN10-APT-407502",
      "name": "SNYK-DEBIAN10-APT-407502",
      "summary": "Improper Verification of Cryptographic Signature",
      "details": "## NVD Description\n**_Note:_** _Versions mentioned in the description apply only to the upstream `apt` package and not the `apt` package as distributed by `Debian:10`._\n_See `How to fix?` for `Debian:10` relevant fixed versions and status._\n\nIt was found that apt-key in apt, all versions, do not correctly validate gpg keys with the primary keyring, leading to a potential man-in-the-middle attack.\n## Remediation\nThere is no fixed version for `Debian:10` `apt`.\n## References\n- [ADVISORY](https://security-tracker.debian.org/tracker/CVE-2011-3374)\n- [Debian Bug Report](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=642480)\n- [MISC](https://people.canonical.com/~ubuntu-security/cve/2011/CVE-2011-3374.html)\n- [MISC](https://seclists.org/fulldisclosure/2011/Sep/221)\n- [MISC](https://snyk.io/vuln/SNYK-LINUX-APT-116518)\n- [MISC](https://ubuntu.com/security/CVE-2011-3374)\n- [RedHat CVE Database](https://access.redhat.com/security/cve/cve-2011-3374)\n",
      "relationships": [
        {
          "affect": {
            "to": [
              "docker-image|nginx@1.16",
              "apt@1.8.2",
              "apt/libapt-pkg5.0@1.8.2"
            ],
            "type": "AFFECTS"
          },
          "foundBy": {
            "to": [
              ""
            ],
            "type": "FOUND_BY"
          },
          "suppliedBy": {
            "to": [
              ""
            ],
            "type": "SUPPLIED_BY"
          },
          "ratedBy": {
            "to": [
              ""
            ],
            "type": "RATED_BY",
            "cwes": [
              347
            ],
            "rating": [
              {
                "method": "CVSS_3",
                "score": [
                  {
                    "base": 3.7
                  }
                ],
                "severity": "Low",
                "vector": "CVSS:3.1/AV:N/AC:H/PR:N/UI:N/S:U/C:N/I:L/A:N"
              }
            ]
          }
        }
      ],
      "externalReferences": [
        {
          "category": "ADVISORY",
          "locator": "https://security-tracker.debian.org/tracker/CVE-2011-3374"
        },
        {
          "category": "ADVISORY",
          "locator": "https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=642480"
        },
        {
          "category": "ADVISORY",
          "locator": "https://people.canonical.com/~ubuntu-security/cve/2011/CVE-2011-3374.html"
        },
        {
          "category": "ADVISORY",
          "locator": "https://seclists.org/fulldisclosure/2011/Sep/221"
        },
        {
          "category": "ADVISORY",
          "locator": "https://snyk.io/vuln/SNYK-LINUX-APT-116518"
        },
        {
          "category": "ADVISORY",
          "locator": "https://ubuntu.com/security/CVE-2011-3374"
        },
        {
          "category": "ADVISORY",
          "locator": "https://access.redhat.com/security/cve/cve-2011-3374"
        }
      ],
      "modified": "2022-11-01T00:08:27.375895Z",
      "published": "2018-06-27T16:20:45.037549Z"
    },
    {
      "id": "SNYK-DEBIAN10-EXPAT-2329087",
      "name": "SNYK-DEBIAN10-EXPAT-2329087",
      "summary": "Incorrect Calculation",
      "details": "## NVD Description\n**_Note:_** _Versions mentioned in the description apply only to the upstream `expat` package and not the `expat` package as distributed by `Debian:10`._\n_See `How to fix?` for `Debian:10` relevant fixed versions and status._\n\nIn Expat (aka libexpat) before 2.4.3, a left shift by 29 (or more) places in the storeAtts function in xmlparse.c can lead to realloc misbehavior (e.g., allocating too few bytes, or only freeing memory).\n## Remediation\nUpgrade `Debian:10` `expat` to version 2.2.6-2+deb10u2 or higher.\n## References\n- [ADVISORY](https://security-tracker.debian.org/tracker/CVE-2021-45960)\n- [MISC](https://bugzilla.mozilla.org/show_bug.cgi?id=1217609)\n- [MISC](https://github.com/libexpat/libexpat/issues/531)\n- [MISC](https://github.com/libexpat/libexpat/pull/534)\n- [cve@mitre.org](http://www.openwall.com/lists/oss-security/2022/01/17/3)\n- [cve@mitre.org](https://security.netapp.com/advisory/ntap-20220121-0004/)\n- [cve@mitre.org](https://www.tenable.com/security/tns-2022-05)\n- [cve@mitre.org](https://www.debian.org/security/2022/dsa-5073)\n- [cve@mitre.org](https://cert-portal.siemens.com/productcert/pdf/ssa-484086.pdf)\n- [cve@mitre.org](https://security.gentoo.org/glsa/202209-24)\n",
      "relationships": [
        {
          "affect": {
            "to": [
              "docker-image|nginx@1.16",
              "nginx-module-image-filter@1.16.1-1~buster",
              "libgd2/libgd3@2.2.5-5.2",
              "fontconfig/libfontconfig1@2.13.1-2",
              "expat/libexpat1@2.2.6-2+deb10u1"
            ],
            "type": "AFFECTS"
          },
          "foundBy": {
            "to": [
              ""
            ],
            "type": "FOUND_BY"
          },
          "suppliedBy": {
            "to": [
              ""
            ],
            "type": "SUPPLIED_BY"
          },
          "ratedBy": {
            "to": [
              ""
            ],
            "type": "RATED_BY",
            "cwes": [
              682
            ],
            "rating": [
              {
                "method": "CVSS_3",
                "score": [
                  {
                    "base": 8.8
                  }
                ],
                "severity": "High",
                "vector": "CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H"
              }
            ]
          }
        }
      ],
      "externalReferences": [
        {
          "category": "ADVISORY",
          "locator": "https://security-tracker.debian.org/tracker/CVE-2021-45960"
        },
        {
          "category": "ADVISORY",
          "locator": "https://bugzilla.mozilla.org/show_bug.cgi?id=1217609"
        },
        {
          "category": "ADVISORY",
          "locator": "https://github.com/libexpat/libexpat/issues/531"
        },
        {
          "category": "ADVISORY",
          "locator": "https://github.com/libexpat/libexpat/pull/534"
        },
        {
          "category": "ADVISORY",
          "locator": "http://www.openwall.com/lists/oss-security/2022/01/17/3"
        },
        {
          "category": "ADVISORY",
          "locator": "https://security.netapp.com/advisory/ntap-20220121-0004/"
        },
        {
          "category": "ADVISORY",
          "locator": "https://www.tenable.com/security/tns-2022-05"
        },
        {
          "category": "ADVISORY",
          "locator": "https://www.debian.org/security/2022/dsa-5073"
        },
        {
          "category": "ADVISORY",
          "locator": "https://cert-portal.siemens.com/productcert/pdf/ssa-484086.pdf"
        },
        {
          "category": "ADVISORY",
          "locator": "https://security.gentoo.org/glsa/202209-24"
        }
      ],
      "modified": "2023-02-14T13:37:37.505975Z",
      "published": "2022-01-02T01:41:26.770663Z"
    },
    {
      "id": "SNYK-DEBIAN10-EXPAT-2331803",
      "name": "SNYK-DEBIAN10-EXPAT-2331803",
      "summary": "Integer Overflow or Wraparound",
      "details": "## NVD Description\n**_Note:_** _Versions mentioned in the description apply only to the upstream `expat` package and not the `expat` package as distributed by `Debian:10`._\n_See `How to fix?` for `Debian:10` relevant fixed versions and status._\n\ndefineAttribute in xmlparse.c in Expat (aka libexpat) before 2.4.3 has an integer overflow.\n## Remediation\nUpgrade `Debian:10` `expat` to version 2.2.6-2+deb10u2 or higher.\n## References\n- [ADVISORY](https://security-tracker.debian.org/tracker/CVE-2022-22824)\n- [cve@mitre.org](https://github.com/libexpat/libexpat/pull/539)\n- [cve@mitre.org](http://www.openwall.com/lists/oss-security/2022/01/17/3)\n- [cve@mitre.org](https://www.tenable.com/security/tns-2022-05)\n- [cve@mitre.org](https://www.debian.org/security/2022/dsa-5073)\n- [cve@mitre.org](https://cert-portal.siemens.com/productcert/pdf/ssa-484086.pdf)\n- [cve@mitre.org](https://security.gentoo.org/glsa/202209-24)\n",
      "relationships": [
        {
          "affect": {
            "to": [
              "docker-image|nginx@1.16",
              "nginx-module-image-filter@1.16.1-1~buster",
              "libgd2/libgd3@2.2.5-5.2",
              "fontconfig/libfontconfig1@2.13.1-2",
              "expat/libexpat1@2.2.6-2+deb10u1"
            ],
            "type": "AFFECTS"
          },
          "foundBy": {
            "to": [
              ""
            ],
            "type": "FOUND_BY"
          },
          "suppliedBy": {
            "to": [
              ""
            ],
            "type": "SUPPLIED_BY"
          },
          "ratedBy": {
            "to": [
              ""
            ],
            "type": "RATED_BY",
            "cwes": [
              190
            ],
            "rating": [
              {
                "method": "CVSS_3",
                "score": [
                  {
                    "base": 9.8
                  }
                ],
                "severity": "Critical",
                "vector": "CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H"
              }
            ]
          }
        }
      ],
      "externalReferences": [
        {
          "category": "ADVISORY",
          "locator": "https://security-tracker.debian.org/tracker/CVE-2022-22824"
        },
        {
          "category": "ADVISORY",
          "locator": "https://github.com/libexpat/libexpat/pull/539"
        },
        {
          "category": "ADVISORY",
          "locator": "http://www.openwall.com/lists/oss-security/2022/01/17/3"
        },
        {
          "category": "ADVISORY",
          "locator": "https://www.tenable.com/security/tns-2022-05"
        },
        {
          "category": "ADVISORY",
          "locator": "https://www.debian.org/security/2022/dsa-5073"
        },
        {
          "category": "ADVISORY",
          "locator": "https://cert-portal.siemens.com/productcert/pdf/ssa-484086.pdf"
        },
        {
          "category": "ADVISORY",
          "locator": "https://security.gentoo.org/glsa/202209-24"
        }
      ],
      "modified": "2023-02-14T13:39:18.516672Z",
      "published": "2022-01-08T13:52:14.479733Z"
    }
  ],
  "name": "docker-image|nginx-sha256:d20aa6d1cae56fd17cd458f4807e0de462caf2336f0b70b5eeb69fcaaf30dd9c",
  "dataLicense": "CC0-1.0",
  "documentNamespace": "spdx.org/spdxdocs/docker-image|nginx-feb02ce6-cd47-49c2-9a97-2b4833b4a1f0",
  "relationships": [
    {
      "from": "SPDXRef-docker-image|nginx",
      "to": [
        "SPDXRef-index.docker.io/library/nginx-sha256:d20aa6d1cae56fd17cd458f4807e0de462caf2336f0b70b5eeb69fcaaf30dd9c"
      ],
      "type": "DESCRIBES"
    }
  ],
  "packages": [
    {
      "SPDXID": "SPDXRef-index.docker.io/library/nginx-sha256:d20aa6d1cae56fd17cd458f4807e0de462caf2336f0b70b5eeb69fcaaf30dd9c",
      "versionInfo": "sha256:d20aa6d1cae56fd17cd458f4807e0de462caf2336f0b70b5eeb69fcaaf30dd9c",
      "id": "SPDXRef-index.docker.io/library/nginx-sha256:d20aa6d1cae56fd17cd458f4807e0de462caf2336f0b70b5eeb69fcaaf30dd9c",
      "name": "index.docker.io/library/nginx",
      "checksums": [
        {
          "algorithm": "SHA256",
          "checksumValue": "d20aa6d1cae56fd17cd458f4807e0de462caf2336f0b70b5eeb69fcaaf30dd9c"
        }
      ]
    }
  ]
}
```
