# Troubleshooting Rego Files (Scan Policy)

This page is a continuation of [Enforce compliance policy using Open Policy Agent](./policies.hbs.md) and provides instruction on troubleshooting the Rego file in the Scan Policy custom resource.

- See [Open Policy Agent documentation](https://www.openpolicyagent.org/docs/latest/policy-language/) on how to write Rego.

## <a id="rego-playground"></a> Using the Rego Playground

Using the [Rego Playground](https://play.openpolicyagent.org/), you can evaluate your Rego file against an input (in this case, the output of an image or source scan custom resource).

Below is a modified sample scan custom resource output (in the form of CycloneDX's XML structure re-encoded as json) that contains CVEs at low, medium, high, and critical severities for you to evaluate your Rego file against. Paste your Rego file and the below sample into the Rego Playground, evaluate, and confirm that the output is as expected. Here is an [example](https://play.openpolicyagent.org/p/wwkyrYbHAv).

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