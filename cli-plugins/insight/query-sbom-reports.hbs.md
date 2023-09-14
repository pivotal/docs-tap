# Query Software Bill of Materials Reports

This topic tells you how to query the database to retrieve a Software Bill
of Materials (commonly known as SBoM) report for a particular image. The information returned is similar
to the SBoM returned by [querying for packages and CVE's a specific image contains](query-data.hbs.md#a-idexample1aexample-1-what-packages-and-cves-does-a-specific-image-contain)
with one significant difference: While querying for images returns all Common Vulnerabilities and Exposures (commonly known as CVE) and packages
linked to an image found in the database, querying for an SBoM report includes similar information but at a specific point in time with a specific
vulnerability scan tool.


## <a id='sup-usecase'></a>Supported use cases

The following are use cases supported by the CLI:
- What SBoM reports exist for a particular image?
- Fetching a specific SBoM report.

## <a id='query-insight'></a> Query using the Tanzu Insight CLI plug-in

[Install the Tanzu Insight CLI plug-in](cli-installation.hbs.md) if you have not already done so.

There are two commands for querying SBoM reports:

- `list` - Query for a list of existing SBoM reports associated with an image
- `get` - Query for a specific SBoM report


## <a id='example1'></a>Example #1: What SBoM reports exist for a specific image?

Run:

```console
tanzu insight report list --digest DIGEST
```

Where:

- `DIGEST` is the component version or image digest.

For example:

```console
$ tanzu insight report list --digest sha256:20521f76ff3d27f436e03dc666cc97a511bbe71e8e8495f851d0f4bf57b0bab6
1. 	UID:       	b84bd3e8-8d71-4012-a7fa-310d4406658c
	Entity Type:  	image
	Entity UID:  	sha256:20521f76ff3d27f436e03dc666cc97a511bbe71e8e8495f851d0f4bf57b0bab6
	Generated At:  	2022-08-01T15:55:56Z
	Tool:
		Name:    trivy
		Version: 0.45.0
		Vendor:  anchore
2. 	UID:       	b6bed111-24eb-4814-9cbd-bbc26dd76d7f
	Entity Type:  	image
	Entity UID:  	sha256:20521f76ff3d27f436e03dc666cc97a511bbe71e8e8495f851d0f4bf57b0bab6
	Generated At:  	2022-07-15T09:01:56Z
	Tool:
		Name:    grype
		Version: 0.38.0
		Vendor:  anchore
3. 	UID:       	510de185-3000-405e-a734-c420f64b1b94
	Entity Type:  	image
	Entity UID:  	sha256:20521f76ff3d27f436e03dc666cc97a511bbe71e8e8495f851d0f4bf57b0bab6
	Generated At:  	2022-07-01T13:18:56Z
	Tool:
		Name:    trivy
		Version: 0.45.0
		Vendor:  anchore
4. 	UID:       	a007bb9b-877c-485b-9ffc-d359586c5bfc
	Entity Type:  	image
	Entity UID:  	sha256:20521f76ff3d27f436e03dc666cc97a511bbe71e8e8495f851d0f4bf57b0bab6
	Generated At:  	2022-06-01T19:28:56Z
	Tool:
		Name:    grype
		Version: 0.38.0
		Vendor:  anchore
```

## <a id='example2'></a>Example #2: What packages and CVEs were found in a specific scan report?

### Determining the SBoM report unique identifier

To fetch a specific SBoM report, you first need to determine the report's unique identifier (commonly known as UID). Find it by
querying for the list of all reports associated with the image as shown in example 1.

In this example, the report UID for the image on July 17, 2022, is `b6bed111-24eb-4814-9cbd-bbc26dd76d7f`.
Use this UID to fetch the report.

### Fetching the specific SBoM report

Run:

```console
tanzu insight report get --uid UID
```

Where:

- `UID` specifies the SBoM report unique identifier

For example:

```console
$ tanzu insight report get --uid b6bed111-24eb-4814-9cbd-bbc26dd76d7f
UID:               b6bed111-24eb-4814-9cbd-bbc26dd76d7f
Generated At:      2022-07-15T09:01:56Z
Tool:
	Name:    grype
	Version: 0.38.0
	Vendor:  anchore
Entity:
	Type:     image
	Name:     checkr/flagr:1.1.12
	Digest:   sha256:20521f76ff3d27f436e03dc666cc97a511bbe71e8e8495f851d0f4bf57b0bab6
	Registry:
	Packages:
		1. alpine-baselayout@3.1.2-r0
		2. alpine-keys@2.1-r2
		3. apk-tools@2.10.4-r2
		CVEs:
			1. CVE-2021-30139 (High)
			2. CVE-2021-36159 (Critical)
		4. busybox@1.30.1-r3
		CVEs:
			1. CVE-2021-28831 (High)
			2. CVE-2021-42374 (Medium)
			3. CVE-2021-42376 (Medium)
			4. CVE-2021-42378 (High)
			5. CVE-2021-42379 (High)
			6. CVE-2021-42380 (High)
			7. CVE-2021-42381 (High)
			8. CVE-2021-42382 (High)
			9. CVE-2021-42384 (High)
			10. CVE-2021-42385 (High)
			11. CVE-2021-42386 (High)
			12. CVE-2022-28391 (Critical)
		5. ca-certificates@20191127-r2
		6. ca-certificates-cacert@20190108-r0
		7. cloud.google.com/go@v0.37.4
		8. curl@7.66.0-r1
...
```

This SBoM report only includes packages and vulnerabilities found on this image during this specific date and time and the vulnerability scan tool version.
