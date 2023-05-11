# API reference for Supply Chain Security Tools - Store

This topic contains API reference information for Supply Chain Security Tools - Store.
See [API walkthrough](api-walkthrough.md) for an SCST - Store example.

## <a id='info'></a>Information

### <a id='methods'></a>Version

1.4.1

## <a id='con-nego'></a>Content negotiation

### <a id='uri-schemes'></a>URI Schemes
  * http
  * https

### <a id='consumes'></a>Consumes
  * application/json

### <a id='produce'></a>Produces
  * application/json

## <a id='all-endpoints'></a>All endpoints

###  <a id='images'></a>images

| Method  | URI     | Name   | Summary |
|---------|---------|--------|---------|
| POST | /api/imageReport | [create image report](#create-image-report) | Create a new image report. Related packages and vulnerabilities are also created. |
| GET | /api/images | [get images](#get-images) | Search image by id, name or digest . |
| GET | /api/packages/{IDorName}/images | [get package images](#get-package-images) | List the images that contain the given package. |
| GET | /api/vulnerabilities/{CVEID}/images | [get vulnerability images](#get-vulnerability-images) | List the images that contain the given vulnerability. |
  


###  <a id='operations'></a>Operations

| Method  | URI     | Name   | Summary |
|---------|---------|--------|---------|
| GET | /api/health | [health check](#health-check) |  |
  


###  <a id='packages'></a>Packages

| Method  | URI     | Name   | Summary |
|---------|---------|--------|---------|
| GET | /api/images/{IDorDigest}/packages | [get image packages](#get-image-packages) | List the packages in an image. |
| GET | /api/images/packages | [get image packages query](#get-image-packages-query) | List packages of the given image. |
| GET | /api/packages | [get packages](#get-packages) | Search packages by id, name and/or version. |
| GET | /api/sources/{IDorRepoorSha}/packages | [get source packages](#get-source-packages) |  |
| GET | /api/sources/packages | [get source packages query](#get-source-packages-query) | List packages of the given source. |
| GET | /api/vulnerabilities/{CVEID}/packages | [get vulnerability packages](#get-vulnerability-packages) | List packages that contain the given CVE id. |
  


###  <a id='sources'></a>Sources

| Method  | URI     | Name   | Summary |
|---------|---------|--------|---------|
| POST | /api/sourceReport | [create source report](#create-source-report) | Create a new source report. Related packages and vulnerabilities are also created. |
| GET | /api/packages/{IDorName}/sources | [get package sources](#get-package-sources) | List the sources containing the given package. |
| GET | /api/sources | [get sources](#get-sources) | Search for sources by ID, repository, commit sha and/or organization. |
| GET | /api/vulnerabilities/{CVEID}/sources | [get vulnerability sources](#get-vulnerability-sources) | List sources that contain the given vulnerability. |
  


###  <a id='v1artifact_groups'></a>v1artifact_groups 

| Method  | URI     | Name   | Summary |
|---------|---------|--------|---------|
| POST | /api/v1/artifact-groups | [create artifact group](#create-artifact-group) | Create an artifact group with specified labels and entity |
| POST | /api/v1/artifact-groups/_search | [search artifact groups](#search-artifact-groups) | Query for a list of artifact group that contains image(s) with specified digests, and or source(s) with specified shas. At least one image digest or source sha must be provided. This query can be further refined by matching images and sources with a specific combination of package name and/or cve id. |
| POST | /api/v1/artifact-groups/vulnerabilities/_reach | [search artifact groups vuln reach](#search-artifact-groups-vuln-reach) | Search for how many artifact groups are affected by vulnerabilities associated with the specified image(s) digests, and/or source(s) shas. At least one image digest or source sha must be provided. |
| POST | /api/v1/artifact-groups/vulnerabilities/_search | [search artifact groups vulnerabilities](#search-artifact-groups-vulnerabilities) | Search for all vulnerabilities associated with an artifact group that contains image(s) with specified digests, and/or source(s) with specified shas. At least one image digest or source sha must be provided. |
  


###  <a id='v1images'></a>v1images

| Method  | URI     | Name   | Summary |
|---------|---------|--------|---------|
| GET | /api/v1/images/{ID} | [get image by ID](#get-image-by-id) | Search image by ID |
| GET | /api/v1/images | [v1 get images](#v1-get-images) | Query for images. If no parameters are given, this endpoint will return all images. |
  


###  <a id='v1packages'></a>v1packages

| Method  | URI     | Name   | Summary |
|---------|---------|--------|---------|
| GET | /api/v1/packages/{ID} | [get package by ID](#get-package-by-id) | Search package by ID |
| GET | /api/v1/images/packages | [v1 get images packages](#v1-get-images-packages) | Query for packages with images parameters. If no parameters are given, this endpoint will return all packages related to images. |
| GET | /api/v1/packages | [v1 get packages](#v1-get-packages) | Query for packages. If no parameters are given, this endpoint will return all packages. |
| GET | /api/v1/sources/packages | [v1 get sources packages](#v1-get-sources-packages) | Query for packages with source parameters. If no parameters are given, this endpoint will return all packages related to sources. |
  


###  <a id='v1sources'></a>v1sources

| Method  | URI     | Name   | Summary |
|---------|---------|--------|---------|
| GET | /api/v1/sources/{ID} | [get source by ID](#get-source-by-id) | Search source by ID |
| GET | /api/v1/sources | [v1 get sources](#v1-get-sources) | Query for sources. If no parameters are given, this endpoint will return all sources. |
| GET | /api/v1/sources/vulnerabilities | [v1 get sources vulnerabilities](#v1-get-sources-vulnerabilities) | Query for vulnerabilities with source parameters. If no parameters are given, this endpoint will return all vulnerabilities. |
  


###  <a id='v1vulnerabilities'></a>v1vulnerabilities

| Method  | URI     | Name   | Summary |
|---------|---------|--------|---------|
| GET | /api/v1/vulnerabilities/{ID} | [get vulnerability by ID](#get-vulnerability-by-id) | Search vulnerability by ID |
| GET | /api/v1/images/vulnerabilities | [v1 get images vulnerabilities](#v1-get-images-vulnerabilities) | Query for vulnerabilities with image parameters. If no parameters are give, this endpoint will return all vulnerabilities. |
  


###  <a id='vulnerabilities'></a>vulnerabilities

| Method  | URI     | Name   | Summary |
|---------|---------|--------|---------|
| GET | /api/images/{IDorDigest}/vulnerabilities | [get image vulnerabilities](#get-image-vulnerabilities) | List vulnerabilities from the given image. |
| GET | /api/packages/{IDorName}/vulnerabilities | [get package vulnerabilities](#get-package-vulnerabilities) | List vulnerabilities from the given package. |
| GET | /api/sources/{IDorRepoorSha}/vulnerabilities | [get source vulnerabilities](#get-source-vulnerabilities) |  |
| GET | /api/sources/vulnerabilities | [get source vulnerabilities query](#get-source-vulnerabilities-query) | List vulnerabilities of the given source. |
| GET | /api/vulnerabilities | [get vulnerabilities](#get-vulnerabilities) | Search for vulnerabilities by CVE id. |
  


## <a id='paths'></a>Paths

### <span id="create-artifact-group"></span> Create an artifact group with specified labels and entity (*CreateArtifactGroup*)

```console
POST /api/v1/artifact-groups
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| ArtifactGroupPostRequest | `body` | [ArtifactGroupPostRequest](#artifact-group-post-request) | `models.ArtifactGroupPostRequest` | | ✓ | |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [201](#create-artifact-group-201) | Created | ArtifactGroupPostResponse |  | [schema](#create-artifact-group-201-schema) |
| [400](#create-artifact-group-400) | Bad Request | ErrorMessage |  | [schema](#create-artifact-group-400-schema) |
| [default](#create-artifact-group-default) | | ErrorMessage |  | [schema](#create-artifact-group-default-schema) |

#### Responses


##### <span id="create-artifact-group-201"></span> 201 - ArtifactGroupPostResponse
Status: Created

###### <span id="create-artifact-group-201-schema"></span> Schema
   
  

[ArtifactGroupPostResponse](#artifact-group-post-response)

##### <span id="create-artifact-group-400"></span> 400 - ErrorMessage
Status: Bad Request

###### <span id="create-artifact-group-400-schema"></span> Schema
   
  

[ErrorMessage](#error-message)

##### <span id="create-artifact-group-default"></span> Default Response
ErrorMessage

###### <span id="create-artifact-group-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="create-image-report"></span> Create a new image report. Related packages and vulnerabilities are also created. (*CreateImageReport*)

```console
POST /api/imageReport
```

#### <a id='parameters-cir'></a>Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| Image | `body` | [Image](#image) | `models.Image` | | ✓ | |  |

#### <a id='all-responses-cir'></a>All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#create-image-report-200) | OK | Image |  | [schema](#create-image-report-200-schema) |
| [default](#create-image-report-default) | | ErrorMessage |  | [schema](#create-image-report-default-schema) |

#### <a id='responses-cir'></a>Responses


##### <span id="create-image-report-200"></span> 200 - Image
Status: OK

###### <span id="create-image-report-200-schema"></span> Schema
   
  

[Image](#image)

##### <span id="create-image-report-default"></span> Default Response
ErrorMessage

###### <span id="create-image-report-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="create-source-report"></span> Create a new source report. Related packages and vulnerabilities are also created. (*CreateSourceReport*)

```console
POST /api/sourceReport
```

#### <a id='parameters-csr'></a>Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| Image | `body` | [Source](#source) | `models.Source` | | ✓ | |  |

#### <a id='all-responses-csr'></a>All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#create-source-report-200) | OK | Source |  | [schema](#create-source-report-200-schema) |
| [default](#create-source-report-default) | | ErrorMessage |  | [schema](#create-source-report-default-schema) |

#### <a id='responses-csr'></a>Responses


##### <span id="create-source-report-200"></span> 200 - Source
Status: OK

###### <span id="create-source-report-200-schema"></span> Schema
   
  

[Source](#source)

##### <span id="create-source-report-default"></span> Default Response
ErrorMessage

###### <span id="create-source-report-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="get-image-by-id"></span> Search image by ID (*GetImageByID*)

```console
GET /api/v1/images/{ID}
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| ID | `path` | uint64 (formatted integer) | `uint64` |  | ✓ |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-image-by-id-200) | OK | Image |  | [schema](#get-image-by-id-200-schema) |
| [404](#get-image-by-id-404) | Not Found | ErrorMessage |  | [schema](#get-image-by-id-404-schema) |
| [default](#get-image-by-id-default) | | ErrorMessage |  | [schema](#get-image-by-id-default-schema) |

#### Responses


##### <span id="get-image-by-id-200"></span> 200 - Image
Status: OK

###### <span id="get-image-by-id-200-schema"></span> Schema
   
  

[Image](#image)

##### <span id="get-image-by-id-404"></span> 404 - ErrorMessage
Status: Not Found

###### <span id="get-image-by-id-404-schema"></span> Schema
   
  

[ErrorMessage](#error-message)

##### <span id="get-image-by-id-default"></span> Default Response
ErrorMessage

###### <span id="get-image-by-id-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="get-image-packages"></span> List the packages in an image. (*GetImagePackages*)

```console
GET /api/images/{IDorDigest}/packages
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| IDorDigest | `path` | string | `string` |  | ✓ |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-image-packages-200) | OK | Package |  | [schema](#get-image-packages-200-schema) |
| [default](#get-image-packages-default) | | ErrorMessage |  | [schema](#get-image-packages-default-schema) |

#### Responses


##### <span id="get-image-packages-200"></span> 200 - Package
Status: OK

###### <span id="get-image-packages-200-schema"></span> Schema
   
  

[[]Package](#package)

##### <span id="get-image-packages-default"></span> Default Response
ErrorMessage

###### <span id="get-image-packages-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="get-image-packages-query"></span> List packages of the given image. (*GetImagePackagesQuery*)

```console
GET /api/images/packages
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| digest | `query` | string | `string` |  |  |  |  |
| id | `query` | int64 (formatted integer) | `int64` |  |  |  |  |
| name | `query` | string | `string` |  |  |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-image-packages-query-200) | OK | Package |  | [schema](#get-image-packages-query-200-schema) |
| [default](#get-image-packages-query-default) | | ErrorMessage |  | [schema](#get-image-packages-query-default-schema) |

#### Responses


##### <span id="get-image-packages-query-200"></span> 200 - Package
Status: OK

###### <span id="get-image-packages-query-200-schema"></span> Schema
   
  

[[]Package](#package)

##### <span id="get-image-packages-query-default"></span> Default Response
ErrorMessage

###### <span id="get-image-packages-query-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="get-image-vulnerabilities"></span> List vulnerabilities from the given image. (*GetImageVulnerabilities*)

```console
GET /api/images/{IDorDigest}/vulnerabilities
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| IDorDigest | `path` | string | `string` |  | ✓ |  |  |
| Severity | `query` | string | `string` |  |  |  | Case insensitive vulnerabilities severity filter. Possible values are: low, medium, high, critical, unknown. |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-image-vulnerabilities-200) | OK | Vulnerability |  | [schema](#get-image-vulnerabilities-200-schema) |
| [default](#get-image-vulnerabilities-default) | | ErrorMessage |  | [schema](#get-image-vulnerabilities-default-schema) |

#### Responses


##### <span id="get-image-vulnerabilities-200"></span> 200 - Vulnerability
Status: OK

###### <span id="get-image-vulnerabilities-200-schema"></span> Schema
   
  

[[]Vulnerability](#vulnerability)

##### <span id="get-image-vulnerabilities-default"></span> Default Response
ErrorMessage

###### <span id="get-image-vulnerabilities-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="get-images"></span> Search image by id, name or digest . (*GetImages*)

```console
GET /api/images
```

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-images-200) | OK | Image |  | [schema](#get-images-200-schema) |
| [default](#get-images-default) | | ErrorMessage |  | [schema](#get-images-default-schema) |

#### Responses


##### <span id="get-images-200"></span> 200 - Image
Status: OK

###### <span id="get-images-200-schema"></span> Schema
   
  

[Image](#image)

##### <span id="get-images-default"></span> Default Response
ErrorMessage

###### <span id="get-images-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="get-package-by-id"></span> Search package by ID (*GetPackageByID*)

```console
GET /api/v1/packages/{ID}
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| ID | `path` | uint64 (formatted integer) | `uint64` |  | ✓ |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-package-by-id-200) | OK | Package |  | [schema](#get-package-by-id-200-schema) |
| [404](#get-package-by-id-404) | Not Found | ErrorMessage |  | [schema](#get-package-by-id-404-schema) |
| [default](#get-package-by-id-default) | | ErrorMessage |  | [schema](#get-package-by-id-default-schema) |

#### Responses


##### <span id="get-package-by-id-200"></span> 200 - Package
Status: OK

###### <span id="get-package-by-id-200-schema"></span> Schema
   
  

[Package](#package)

##### <span id="get-package-by-id-404"></span> 404 - ErrorMessage
Status: Not Found

###### <span id="get-package-by-id-404-schema"></span> Schema
   
  

[ErrorMessage](#error-message)

##### <span id="get-package-by-id-default"></span> Default Response
ErrorMessage

###### <span id="get-package-by-id-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="get-package-images"></span> List the images that contain the given package. (*GetPackageImages*)

```console
GET /api/packages/{IDorName}/images
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| IDorName | `path` | string | `string` |  | ✓ |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-package-images-200) | OK | Image |  | [schema](#get-package-images-200-schema) |
| [default](#get-package-images-default) | | ErrorMessage |  | [schema](#get-package-images-default-schema) |

#### Responses


##### <span id="get-package-images-200"></span> 200 - Image
Status: OK

###### <span id="get-package-images-200-schema"></span> Schema
   
  

[[]Image](#image)

##### <span id="get-package-images-default"></span> Default Response
ErrorMessage

###### <span id="get-package-images-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="get-package-sources"></span> List the sources containing the given package. (*GetPackageSources*)

```console
GET /api/packages/{IDorName}/sources
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| IDorName | `path` | string | `string` |  | ✓ |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-package-sources-200) | OK | Source |  | [schema](#get-package-sources-200-schema) |
| [default](#get-package-sources-default) | | ErrorMessage |  | [schema](#get-package-sources-default-schema) |

#### Responses


##### <span id="get-package-sources-200"></span> 200 - Source
Status: OK

###### <span id="get-package-sources-200-schema"></span> Schema
   
  

[[]Source](#source)

##### <span id="get-package-sources-default"></span> Default Response
ErrorMessage

###### <span id="get-package-sources-default-schema"></span> Schema

  

[[]ErrorMessage](#error-message)

### <span id="get-package-vulnerabilities"></span> List vulnerabilities from the given package. (*GetPackageVulnerabilities*)

```console
GET /api/packages/{IDorName}/vulnerabilities
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| IDorName | `path` | string | `string` |  | ✓ |  |  |
| Severity | `query` | string | `string` |  |  |  | Case insensitive vulnerabilities severity filter. Possible values are: low, medium, high, critical, unknown. |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-package-vulnerabilities-200) | OK | Vulnerability |  | [schema](#get-package-vulnerabilities-200-schema) |
| [default](#get-package-vulnerabilities-default) | | ErrorMessage |  | [schema](#get-package-vulnerabilities-default-schema) |

#### Responses


##### <span id="get-package-vulnerabilities-200"></span> 200 - Vulnerability
Status: OK

###### <span id="get-package-vulnerabilities-200-schema"></span> Schema
   
  

[[]Vulnerability](#vulnerability)

##### <span id="get-package-vulnerabilities-default"></span> Default Response
ErrorMessage

###### <span id="get-package-vulnerabilities-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="get-packages"></span> Search packages by id, name and/or version. (*GetPackages*)

```console
GET /api/packages
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| id | `query` | int64 (formatted integer) | `int64` |  |  |  | Any of id or name must be provided |
| name | `query` | string | `string` |  |  |  | Any of id or name must be provided |
| version | `query` | string | `string` |  |  |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-packages-200) | OK | Package |  | [schema](#get-packages-200-schema) |
| [default](#get-packages-default) | | ErrorMessage |  | [schema](#get-packages-default-schema) |

#### Responses


##### <span id="get-packages-200"></span> 200 - Package
Status: OK

###### <span id="get-packages-200-schema"></span> Schema
   
  

[[]Package](#package)

##### <span id="get-packages-default"></span> Default Response
ErrorMessage

###### <span id="get-packages-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="get-source-by-id"></span> Search source by ID (*GetSourceByID*)

```console
GET /api/v1/sources/{ID}
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| ID | `path` | uint64 (formatted integer) | `uint64` |  | ✓ |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-source-by-id-200) | OK | Source |  | [schema](#get-source-by-id-200-schema) |
| [404](#get-source-by-id-404) | Not Found | ErrorMessage |  | [schema](#get-source-by-id-404-schema) |
| [default](#get-source-by-id-default) | | ErrorMessage |  | [schema](#get-source-by-id-default-schema) |

#### Responses


##### <span id="get-source-by-id-200"></span> 200 - Source
Status: OK

###### <span id="get-source-by-id-200-schema"></span> Schema
   
  

[Source](#source)

##### <span id="get-source-by-id-404"></span> 404 - ErrorMessage
Status: Not Found

###### <span id="get-source-by-id-404-schema"></span> Schema
   
  

[ErrorMessage](#error-message)

##### <span id="get-source-by-id-default"></span> Default Response
ErrorMessage

###### <span id="get-source-by-id-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="get-source-packages"></span> get source packages (*GetSourcePackages*)

```console
GET /api/sources/{IDorRepoorSha}/packages
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| IDorRepoorSha | `path` | string | `string` |  | ✓ |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-source-packages-200) | OK | Package |  | [schema](#get-source-packages-200-schema) |
| [default](#get-source-packages-default) | | ErrorMessage |  | [schema](#get-source-packages-default-schema) |

#### Responses


##### <span id="get-source-packages-200"></span> 200 - Package
Status: OK

###### <span id="get-source-packages-200-schema"></span> Schema
   
  

[[]Package](#package)

##### <span id="get-source-packages-default"></span> Default Response
ErrorMessage

###### <span id="get-source-packages-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="get-source-packages-query"></span> List packages of the given source. (*GetSourcePackagesQuery*)

```console
GET /api/sources/packages
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| id | `query` | uint64 (formatted integer) | `uint64` |  |  |  |  |
| repo | `query` | string | `string` |  |  |  |  |
| sha | `query` | string | `string` |  |  |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-source-packages-query-200) | OK | Package |  | [schema](#get-source-packages-query-200-schema) |
| [default](#get-source-packages-query-default) | | ErrorMessage |  | [schema](#get-source-packages-query-default-schema) |

#### Responses


##### <span id="get-source-packages-query-200"></span> 200 - Package
Status: OK

###### <span id="get-source-packages-query-200-schema"></span> Schema
   
  

[[]Package](#package)

##### <span id="get-source-packages-query-default"></span> Default Response
ErrorMessage

###### <span id="get-source-packages-query-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="get-source-vulnerabilities"></span> get source vulnerabilities (*GetSourceVulnerabilities*)

```console
GET /api/sources/{IDorRepoorSha}/vulnerabilities
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| IDorRepoorSha | `path` | string | `string` |  | ✓ |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-source-vulnerabilities-200) | OK | Vulnerability |  | [schema](#get-source-vulnerabilities-200-schema) |
| [default](#get-source-vulnerabilities-default) | | ErrorMessage |  | [schema](#get-source-vulnerabilities-default-schema) |

#### Responses


##### <span id="get-source-vulnerabilities-200"></span> 200 - Vulnerability
Status: OK

###### <span id="get-source-vulnerabilities-200-schema"></span> Schema
   
  

[[]Vulnerability](#vulnerability)

##### <span id="get-source-vulnerabilities-default"></span> Default Response
ErrorMessage

###### <span id="get-source-vulnerabilities-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="get-source-vulnerabilities-query"></span> List vulnerabilities of the given source. (*GetSourceVulnerabilitiesQuery*)

```console
GET /api/sources/vulnerabilities
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| Severity | `query` | string | `string` |  |  |  | Case insensitive vulnerabilities severity filter. Possible values are: low, medium, high, critical, unknown. |
| id | `query` | uint64 (formatted integer) | `uint64` |  |  |  |  |
| repo | `query` | string | `string` |  |  |  |  |
| sha | `query` | string | `string` |  |  |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-source-vulnerabilities-query-200) | OK | Vulnerability |  | [schema](#get-source-vulnerabilities-query-200-schema) |
| [default](#get-source-vulnerabilities-query-default) | | ErrorMessage |  | [schema](#get-source-vulnerabilities-query-default-schema) |

#### Responses


##### <span id="get-source-vulnerabilities-query-200"></span> 200 - Vulnerability
Status: OK

###### <span id="get-source-vulnerabilities-query-200-schema"></span> Schema
   
  

[[]Vulnerability](#vulnerability)

##### <span id="get-source-vulnerabilities-query-default"></span> Default Response
ErrorMessage

###### <span id="get-source-vulnerabilities-query-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="get-sources"></span> Search for sources by ID, repository, commit sha and/or organization. (*GetSources*)

```console
GET /api/sources
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| id | `query` | int64 (formatted integer) | `int64` |  |  |  |  |
| org | `query` | string | `string` |  |  |  |  |
| repo | `query` | string | `string` |  |  |  |  |
| sha | `query` | string | `string` |  |  |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-sources-200) | OK | Source |  | [schema](#get-sources-200-schema) |
| [default](#get-sources-default) | | ErrorMessage |  | [schema](#get-sources-default-schema) |

#### Responses


##### <span id="get-sources-200"></span> 200 - Source
Status: OK

###### <span id="get-sources-200-schema"></span> Schema
   
  

[[]Source](#source)

##### <span id="get-sources-default"></span> Default Response
ErrorMessage

###### <span id="get-sources-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="get-vulnerabilities"></span> Search for vulnerabilities by CVE id. (*GetVulnerabilities*)

```console
GET /api/vulnerabilities
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| CVEID | `query` | string | `string` |  | ✓ |  |  |
| Severity | `query` | string | `string` |  |  |  | Case insensitive vulnerabilities severity filter. Possible values are: low, medium, high, critical, unknown. |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-vulnerabilities-200) | OK | Vulnerability |  | [schema](#get-vulnerabilities-200-schema) |
| [default](#get-vulnerabilities-default) | | ErrorMessage |  | [schema](#get-vulnerabilities-default-schema) |

#### Responses


##### <span id="get-vulnerabilities-200"></span> 200 - Vulnerability
Status: OK

###### <span id="get-vulnerabilities-200-schema"></span> Schema
   
  

[[]Vulnerability](#vulnerability)

##### <span id="get-vulnerabilities-default"></span> Default Response
ErrorMessage

###### <span id="get-vulnerabilities-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="get-vulnerability-by-id"></span> Search vulnerability by ID (*GetVulnerabilityByID*)

```console
GET /api/v1/vulnerabilities/{ID}
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| ID | `path` | uint64 (formatted integer) | `uint64` |  | ✓ |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-vulnerability-by-id-200) | OK | Vulnerability |  | [schema](#get-vulnerability-by-id-200-schema) |
| [404](#get-vulnerability-by-id-404) | Not Found | ErrorMessage |  | [schema](#get-vulnerability-by-id-404-schema) |
| [default](#get-vulnerability-by-id-default) | | ErrorMessage |  | [schema](#get-vulnerability-by-id-default-schema) |

#### Responses


##### <span id="get-vulnerability-by-id-200"></span> 200 - Vulnerability
Status: OK

###### <span id="get-vulnerability-by-id-200-schema"></span> Schema
   
  

[Vulnerability](#vulnerability)

##### <span id="get-vulnerability-by-id-404"></span> 404 - ErrorMessage
Status: Not Found

###### <span id="get-vulnerability-by-id-404-schema"></span> Schema
   
  

[ErrorMessage](#error-message)

##### <span id="get-vulnerability-by-id-default"></span> Default Response
ErrorMessage

###### <span id="get-vulnerability-by-id-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="get-vulnerability-images"></span> List the images that contain the given vulnerability. (*GetVulnerabilityImages*)

```console
GET /api/vulnerabilities/{CVEID}/images
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| CVEID | `path` | string | `string` |  | ✓ |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-vulnerability-images-200) | OK | Image |  | [schema](#get-vulnerability-images-200-schema) |
| [default](#get-vulnerability-images-default) | | ErrorMessage |  | [schema](#get-vulnerability-images-default-schema) |

#### Responses


##### <span id="get-vulnerability-images-200"></span> 200 - Image
Status: OK

###### <span id="get-vulnerability-images-200-schema"></span> Schema
   
  

[[]Image](#image)

##### <span id="get-vulnerability-images-default"></span> Default Response
ErrorMessage

###### <span id="get-vulnerability-images-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="get-vulnerability-packages"></span> List packages that contain the given CVE id. (*GetVulnerabilityPackages*)

```console
GET /api/vulnerabilities/{CVEID}/packages
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| CVEID | `path` | string | `string` |  | ✓ |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-vulnerability-packages-200) | OK | Package |  | [schema](#get-vulnerability-packages-200-schema) |
| [default](#get-vulnerability-packages-default) | | ErrorMessage |  | [schema](#get-vulnerability-packages-default-schema) |

#### Responses


##### <span id="get-vulnerability-packages-200"></span> 200 - Package
Status: OK

###### <span id="get-vulnerability-packages-200-schema"></span> Schema
   
  

[[]Package](#package)

##### <span id="get-vulnerability-packages-default"></span> Default Response
ErrorMessage

###### <span id="get-vulnerability-packages-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="get-vulnerability-sources"></span> List sources that contain the given vulnerability. (*GetVulnerabilitySources*)

```console
GET /api/vulnerabilities/{CVEID}/sources
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| CVEID | `path` | string | `string` |  | ✓ |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-vulnerability-sources-200) | OK | Source |  | [schema](#get-vulnerability-sources-200-schema) |
| [default](#get-vulnerability-sources-default) | | ErrorMessage |  | [schema](#get-vulnerability-sources-default-schema) |

#### Responses


##### <span id="get-vulnerability-sources-200"></span> 200 - Source
Status: OK

###### <span id="get-vulnerability-sources-200-schema"></span> Schema
   
  

[[]Source](#source)

##### <span id="get-vulnerability-sources-default"></span> Default Response
ErrorMessage

###### <span id="get-vulnerability-sources-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="health-check"></span> health check (*HealthCheck*)

```console
GET /api/health
```

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#health-check-200) | OK |  |  | [schema](#health-check-200-schema) |
| [default](#health-check-default) | | ErrorMessage |  | [schema](#health-check-default-schema) |

#### Responses


##### <span id="health-check-200"></span> 200
Status: OK

###### <span id="health-check-200-schema"></span> Schema

##### <span id="health-check-default"></span> Default Response
ErrorMessage

###### <span id="health-check-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="search-artifact-groups"></span> Query for a list of artifact group that contains image(s) with specified digests, and or source(s) with specified shas. At least one image digest or source sha must be provided. This query can be further refined by matching images and sources with a specific combination of package name and/or cve id. (*SearchArtifactGroups*)

```console
POST /api/v1/artifact-groups/_search
```

Query for a list of artifact group that contains image(s) with specified digests, and or source(s) with specified shas.

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| ArtifactGroupFiltersPostRequest | `body` | [ArtifactGroupSearchFilters](#artifact-group-search-filters) | `models.ArtifactGroupSearchFilters` | | ✓ | |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#search-artifact-groups-200) | OK | PaginatedArtifactGroupResponse |  | [schema](#search-artifact-groups-200-schema) |
| [400](#search-artifact-groups-400) | Bad Request | ErrorMessage |  | [schema](#search-artifact-groups-400-schema) |
| [default](#search-artifact-groups-default) | | ErrorMessage |  | [schema](#search-artifact-groups-default-schema) |

#### Responses


##### <span id="search-artifact-groups-200"></span> 200 - PaginatedArtifactGroupResponse
Status: OK

###### <span id="search-artifact-groups-200-schema"></span> Schema
   
  

[PaginatedArtifactGroupResponse](#paginated-artifact-group-response)

##### <span id="search-artifact-groups-400"></span> 400 - ErrorMessage
Status: Bad Request

###### <span id="search-artifact-groups-400-schema"></span> Schema
   
  

[ErrorMessage](#error-message)

##### <span id="search-artifact-groups-default"></span> Default Response
ErrorMessage

###### <span id="search-artifact-groups-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="search-artifact-groups-vuln-reach"></span> Search for how many artifact groups are affected by vulnerabilities associated with the specified image(s) digests, and/or source(s) shas. At least one image digest or source sha must be provided. (*SearchArtifactGroupsVulnReach*)

```console
POST /api/v1/artifact-groups/vulnerabilities/_reach
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| ArtifactGroupVulnReachFiltersPostRequest | `body` | [ArtifactGroupVulnReachFiltersPostRequest](#artifact-group-vuln-reach-filters-post-request) | `models.ArtifactGroupVulnReachFiltersPostRequest` | | ✓ | |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#search-artifact-groups-vuln-reach-200) | OK | PaginatedArtifactGroupVulnReachResponse |  | [schema](#search-artifact-groups-vuln-reach-200-schema) |
| [400](#search-artifact-groups-vuln-reach-400) | Bad Request | ErrorMessage |  | [schema](#search-artifact-groups-vuln-reach-400-schema) |
| [default](#search-artifact-groups-vuln-reach-default) | | ErrorMessage |  | [schema](#search-artifact-groups-vuln-reach-default-schema) |

#### Responses


##### <span id="search-artifact-groups-vuln-reach-200"></span> 200 - PaginatedArtifactGroupVulnReachResponse
Status: OK

###### <span id="search-artifact-groups-vuln-reach-200-schema"></span> Schema
   
  

[PaginatedArtifactGroupVulnReachResponse](#paginated-artifact-group-vuln-reach-response)

##### <span id="search-artifact-groups-vuln-reach-400"></span> 400 - ErrorMessage
Status: Bad Request

###### <span id="search-artifact-groups-vuln-reach-400-schema"></span> Schema
   
  

[ErrorMessage](#error-message)

##### <span id="search-artifact-groups-vuln-reach-default"></span> Default Response
ErrorMessage

###### <span id="search-artifact-groups-vuln-reach-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="search-artifact-groups-vulnerabilities"></span> Search for all vulnerabilities associated with an artifact group that contains image(s) with specified digests, and/or source(s) with specified shas. At least one image digest or source sha must be provided. (*SearchArtifactGroupsVulnerabilities*)

```console
POST /api/v1/artifact-groups/vulnerabilities/_search
```

The result can be further refined by matching the images and sources with a package name and/or an artifact group UID

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| ArtifactGroupVulnSearchFiltersPostRequest | `body` | [ArtifactGroupVulnSearchFilters](#artifact-group-vuln-search-filters) | `models.ArtifactGroupVulnSearchFilters` | | ✓ | |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#search-artifact-groups-vulnerabilities-200) | OK | PaginatedArtifactGroupVulnerabilityResponse |  | [schema](#search-artifact-groups-vulnerabilities-200-schema) |
| [400](#search-artifact-groups-vulnerabilities-400) | Bad Request | ErrorMessage |  | [schema](#search-artifact-groups-vulnerabilities-400-schema) |
| [default](#search-artifact-groups-vulnerabilities-default) | | ErrorMessage |  | [schema](#search-artifact-groups-vulnerabilities-default-schema) |

#### Responses


##### <span id="search-artifact-groups-vulnerabilities-200"></span> 200 - PaginatedArtifactGroupVulnerabilityResponse
Status: OK

###### <span id="search-artifact-groups-vulnerabilities-200-schema"></span> Schema
   
  

[PaginatedArtifactGroupVulnerabilityResponse](#paginated-artifact-group-vulnerability-response)

##### <span id="search-artifact-groups-vulnerabilities-400"></span> 400 - ErrorMessage
Status: Bad Request

###### <span id="search-artifact-groups-vulnerabilities-400-schema"></span> Schema
   
  

[ErrorMessage](#error-message)

##### <span id="search-artifact-groups-vulnerabilities-default"></span> Default Response
ErrorMessage

###### <span id="search-artifact-groups-vulnerabilities-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="v1-get-images"></span> Query for images. If no parameters are given, this endpoint will return all images. (*V1GetImages*)

```console
GET /api/v1/images
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| all | `query` | boolean | `bool` |  |  |  | If no pagination parameters are provided, defaults to true and returns all available results. |
| digest | `query` | string | `string` |  |  |  |  |
| name | `query` | string | `string` |  |  |  |  |
| page | `query` | int64 (formatted integer) | `int64` |  |  | `1` |  |
| page_size | `query` | int64 (formatted integer) | `int64` |  |  | `20` |  |
| registry | `query` | string | `string` |  |  |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#v1-get-images-200) | OK | PaginatedImageResponse |  | [schema](#v1-get-images-200-schema) |
| [404](#v1-get-images-404) | Not Found | ErrorMessage |  | [schema](#v1-get-images-404-schema) |
| [default](#v1-get-images-default) | | ErrorMessage |  | [schema](#v1-get-images-default-schema) |

#### Responses


##### <span id="v1-get-images-200"></span> 200 - PaginatedImageResponse
Status: OK

###### <span id="v1-get-images-200-schema"></span> Schema
   
  

[PaginatedImageResponse](#paginated-image-response)

##### <span id="v1-get-images-404"></span> 404 - ErrorMessage
Status: Not Found

###### <span id="v1-get-images-404-schema"></span> Schema
   
  

[ErrorMessage](#error-message)

##### <span id="v1-get-images-default"></span> Default Response
ErrorMessage

###### <span id="v1-get-images-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="v1-get-images-packages"></span> Query for packages with images parameters. If no parameters are given, this endpoint will return all packages related to images. (*V1GetImagesPackages*)

```console
GET /api/v1/images/packages
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| all | `query` | boolean | `bool` |  |  |  | If no pagination parameters are provided, defaults to true and returns all available results. |
| digest | `query` | string | `string` |  |  |  |  |
| name | `query` | string | `string` |  |  |  |  |
| package_name | `query` | string | `string` |  |  |  | Substring package name filter. For example, setting `name=cur` would match `curl` and `libcurl`. |
| page | `query` | int64 (formatted integer) | `int64` |  |  | `1` |  |
| page_size | `query` | int64 (formatted integer) | `int64` |  |  | `20` |  |
| registry | `query` | string | `string` |  |  |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#v1-get-images-packages-200) | OK | PaginatedPackageResponse |  | [schema](#v1-get-images-packages-200-schema) |
| [404](#v1-get-images-packages-404) | Not Found | ErrorMessage |  | [schema](#v1-get-images-packages-404-schema) |
| [default](#v1-get-images-packages-default) | | ErrorMessage |  | [schema](#v1-get-images-packages-default-schema) |

#### Responses


##### <span id="v1-get-images-packages-200"></span> 200 - PaginatedPackageResponse
Status: OK

###### <span id="v1-get-images-packages-200-schema"></span> Schema
   
  

[PaginatedPackageResponse](#paginated-package-response)

##### <span id="v1-get-images-packages-404"></span> 404 - ErrorMessage
Status: Not Found

###### <span id="v1-get-images-packages-404-schema"></span> Schema
   
  

[ErrorMessage](#error-message)

##### <span id="v1-get-images-packages-default"></span> Default Response
ErrorMessage

###### <span id="v1-get-images-packages-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="v1-get-images-vulnerabilities"></span> Query for vulnerabilities with image parameters. If no parameters are give, this endpoint will return all vulnerabilities. (*V1GetImagesVulnerabilities*)

```console
GET /api/v1/images/vulnerabilities
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| Severity | `query` | string | `string` |  |  |  | Case insensitive vulnerabilities severity filter. Possible values are: low, medium, high, critical, unknown. |
| all | `query` | boolean | `bool` |  |  |  | If no pagination parameters are provided, defaults to true and returns all available results. |
| digest | `query` | string | `string` |  |  |  |  |
| name | `query` | string | `string` |  |  |  |  |
| page | `query` | int64 (formatted integer) | `int64` |  |  | `1` |  |
| page_size | `query` | int64 (formatted integer) | `int64` |  |  | `20` |  |
| registry | `query` | string | `string` |  |  |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#v1-get-images-vulnerabilities-200) | OK | PaginatedVulnerabilityResponse |  | [schema](#v1-get-images-vulnerabilities-200-schema) |
| [404](#v1-get-images-vulnerabilities-404) | Not Found | ErrorMessage |  | [schema](#v1-get-images-vulnerabilities-404-schema) |
| [default](#v1-get-images-vulnerabilities-default) | | ErrorMessage |  | [schema](#v1-get-images-vulnerabilities-default-schema) |

#### Responses


##### <span id="v1-get-images-vulnerabilities-200"></span> 200 - PaginatedVulnerabilityResponse
Status: OK

###### <span id="v1-get-images-vulnerabilities-200-schema"></span> Schema
   
  

[PaginatedVulnerabilityResponse](#paginated-vulnerability-response)

##### <span id="v1-get-images-vulnerabilities-404"></span> 404 - ErrorMessage
Status: Not Found

###### <span id="v1-get-images-vulnerabilities-404-schema"></span> Schema
   
  

[ErrorMessage](#error-message)

##### <span id="v1-get-images-vulnerabilities-default"></span> Default Response
ErrorMessage

###### <span id="v1-get-images-vulnerabilities-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="v1-get-packages"></span> Query for packages. If no parameters are given, this endpoint will return all packages. (*V1GetPackages*)

```console
GET /api/v1/packages
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| all | `query` | boolean | `bool` |  |  |  | If no pagination parameters are provided, defaults to true and returns all available results. |
| name | `query` | string | `string` |  |  |  | Name filter works as a substring match on the package name. For example, setting `name=cur` would match `curl` and `libcurl`. |
| package_manager | `query` | string | `string` |  |  |  |  |
| page | `query` | int64 (formatted integer) | `int64` |  |  | `1` |  |
| page_size | `query` | int64 (formatted integer) | `int64` |  |  | `20` |  |
| version | `query` | string | `string` |  |  |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#v1-get-packages-200) | OK | PaginatedPackageResponse |  | [schema](#v1-get-packages-200-schema) |
| [404](#v1-get-packages-404) | Not Found | ErrorMessage |  | [schema](#v1-get-packages-404-schema) |
| [default](#v1-get-packages-default) | | ErrorMessage |  | [schema](#v1-get-packages-default-schema) |

#### Responses


##### <span id="v1-get-packages-200"></span> 200 - PaginatedPackageResponse
Status: OK

###### <span id="v1-get-packages-200-schema"></span> Schema
   
  

[PaginatedPackageResponse](#paginated-package-response)

##### <span id="v1-get-packages-404"></span> 404 - ErrorMessage
Status: Not Found

###### <span id="v1-get-packages-404-schema"></span> Schema
   
  

[ErrorMessage](#error-message)

##### <span id="v1-get-packages-default"></span> Default Response
ErrorMessage

###### <span id="v1-get-packages-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="v1-get-sources"></span> Query for sources. If no parameters are given, this endpoint will return all sources. (*V1GetSources*)

```console
GET /api/v1/sources
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| all | `query` | boolean | `bool` |  |  |  | If no pagination parameters are provided, defaults to true and returns all available results. |
| org | `query` | string | `string` |  |  |  |  |
| page | `query` | int64 (formatted integer) | `int64` |  |  | `1` |  |
| page_size | `query` | int64 (formatted integer) | `int64` |  |  | `20` |  |
| repo | `query` | string | `string` |  |  |  |  |
| sha | `query` | string | `string` |  |  |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#v1-get-sources-200) | OK | PaginatedSourceResponse |  | [schema](#v1-get-sources-200-schema) |
| [404](#v1-get-sources-404) | Not Found | ErrorMessage |  | [schema](#v1-get-sources-404-schema) |
| [default](#v1-get-sources-default) | | ErrorMessage |  | [schema](#v1-get-sources-default-schema) |

#### Responses


##### <span id="v1-get-sources-200"></span> 200 - PaginatedSourceResponse
Status: OK

###### <span id="v1-get-sources-200-schema"></span> Schema
   
  

[PaginatedSourceResponse](#paginated-source-response)

##### <span id="v1-get-sources-404"></span> 404 - ErrorMessage
Status: Not Found

###### <span id="v1-get-sources-404-schema"></span> Schema
   
  

[ErrorMessage](#error-message)

##### <span id="v1-get-sources-default"></span> Default Response
ErrorMessage

###### <span id="v1-get-sources-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="v1-get-sources-packages"></span> Query for packages with source parameters. If no parameters are given, this endpoint will return all packages related to sources. (*V1GetSourcesPackages*)

```console
GET /api/v1/sources/packages
```

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#v1-get-sources-packages-200) | OK | PaginatedPackageResponse |  | [schema](#v1-get-sources-packages-200-schema) |
| [404](#v1-get-sources-packages-404) | Not Found | ErrorMessage |  | [schema](#v1-get-sources-packages-404-schema) |
| [default](#v1-get-sources-packages-default) | | ErrorMessage |  | [schema](#v1-get-sources-packages-default-schema) |

#### Responses


##### <span id="v1-get-sources-packages-200"></span> 200 - PaginatedPackageResponse
Status: OK

###### <span id="v1-get-sources-packages-200-schema"></span> Schema
   
  

[PaginatedPackageResponse](#paginated-package-response)

##### <span id="v1-get-sources-packages-404"></span> 404 - ErrorMessage
Status: Not Found

###### <span id="v1-get-sources-packages-404-schema"></span> Schema
   
  

[ErrorMessage](#error-message)

##### <span id="v1-get-sources-packages-default"></span> Default Response
ErrorMessage

###### <span id="v1-get-sources-packages-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

### <span id="v1-get-sources-vulnerabilities"></span> Query for vulnerabilities with source parameters. If no parameters are given, this endpoint will return all vulnerabilities. (*V1GetSourcesVulnerabilities*)

```console
GET /api/v1/sources/vulnerabilities
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| Severity | `query` | string | `string` |  |  |  | Case insensitive vulnerabilities severity filter. Possible values are: low, medium, high, critical, unknown. |
| all | `query` | boolean | `bool` |  |  |  | If no pagination parameters are provided, defaults to true and returns all available results. |
| org | `query` | string | `string` |  |  |  |  |
| page | `query` | int64 (formatted integer) | `int64` |  |  | `1` |  |
| page_size | `query` | int64 (formatted integer) | `int64` |  |  | `20` |  |
| repo | `query` | string | `string` |  |  |  |  |
| sha | `query` | string | `string` |  |  |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#v1-get-sources-vulnerabilities-200) | OK | PaginatedVulnerabilityResponse |  | [schema](#v1-get-sources-vulnerabilities-200-schema) |
| [404](#v1-get-sources-vulnerabilities-404) | Not Found | ErrorMessage |  | [schema](#v1-get-sources-vulnerabilities-404-schema) |
| [default](#v1-get-sources-vulnerabilities-default) | | ErrorMessage |  | [schema](#v1-get-sources-vulnerabilities-default-schema) |

#### Responses


##### <span id="v1-get-sources-vulnerabilities-200"></span> 200 - PaginatedVulnerabilityResponse
Status: OK

###### <span id="v1-get-sources-vulnerabilities-200-schema"></span> Schema
   
  

[PaginatedVulnerabilityResponse](#paginated-vulnerability-response)

##### <span id="v1-get-sources-vulnerabilities-404"></span> 404 - ErrorMessage
Status: Not Found

###### <span id="v1-get-sources-vulnerabilities-404-schema"></span> Schema
   
  

[ErrorMessage](#error-message)

##### <span id="v1-get-sources-vulnerabilities-default"></span> Default Response
ErrorMessage

###### <span id="v1-get-sources-vulnerabilities-default-schema"></span> Schema

  

[ErrorMessage](#error-message)

## Models

### <span id="artifact-group-post-request"></span> ArtifactGroupPostRequest


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| EntityID | uint64 (formatted integer)| `uint64` |  | | The database ID of the source or image being associated with this artifact group | `24` |
| Labels | map of string| `map[string]string` |  | | Key-Value pair of labels associated with the Artifact Group | `{"env":"production","namespace":"default"}` |
| Type | string| `string` |  | | The entity type being associated with this artifact group. Allowable values: image, source | `image` |
| UID | string| `string` | ✓ | | Unique identifier for the Artifact Group such as workload UID | `8b1cc5da-fabe-45a6-ab8c-49260bbeef99` |



### <span id="artifact-group-response"></span> ArtifactGroupResponse


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| Entities | [[]Entity](#entity)| `[]*Entity` |  | | Entities associated with the Artifact Group |  |
| Labels | map of string| `map[string]string` |  | | Key-Value pair of labels associated with the Artifact Group | `{"env":"production","namespace":"default"}` |
| UID | string| `string` |  | | Unique identifier for the Artifact Group such as workload UID | `8b1cc5da-fabe-45a6-ab8c-49260bbeef99` |



### <span id="artifact-group-search-filters"></span> ArtifactGroupSearchFilters


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| All | boolean| `bool` |  | | If no pagination parameters are provided, defaults to true and returns all available results. |  |
| CVEID | string| `string` |  | | An optional CVE ID that the image and source must contain. Only packages, and their images and sources, with this CVE ID will be returned. If both package name and CVE ID are provided, then only the images and sources with the specified package name and CVE ID will be returned. | `CVE-7467-2020` |
| Digests | []string| `[]string` |  | | A list of image digests. At least one image digest or source sha must be provided. | `["9n38274ods897fmay487gsdyfga678wr82","7n38274ods897fmay487gsdyfga678wr82"]` |
| PackageName | string| `string` |  | | An optional package name that the image and source must contain. Only packages, and their images and sources, with this name will be returned. If both package name and CVE ID are provided, then only the images and sources with the specified package name and CVE ID will be returned. | `package1` |
| Page | int64 (formatted integer)| `int64` |  | `1`|  |  |
| PageSize | int64 (formatted integer)| `int64` |  | `20`|  |  |
| Shas | []string| `[]string` |  | | A list of source shas. At least one image digest or source sha must be provided. | `["sha256:2c11624a8d9c9071996a886a4acaf09939ef3386e4c07735c6a2532f02eed4ea","sha256:04bafe0d8df23ec342edb72acc3fb02f61c418bc6e8d7093149956a9aad2d12a"]` |



### <span id="artifact-group-vuln-reach-filters-post-request"></span> ArtifactGroupVulnReachFiltersPostRequest


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| All | boolean| `bool` |  | | If no pagination parameters are provided, defaults to true and returns all available results. |  |
| Digests | []string| `[]string` |  | | A list of image digests. | `["sha256:2c11624a8d9c9071996a886a4acaf09939ef3386e4c07735c6a2532f02eed4ea","sha256:04bafe0d8df23ec342edb72acc3fb02f61c418bc6e8d7093149956a9aad2d12a"]` |
| Page | int64 (formatted integer)| `int64` |  | `1`|  |  |
| PageSize | int64 (formatted integer)| `int64` |  | `20`|  |  |
| Shas | []string| `[]string` |  | | A list of source shas. | `["9n38274ods897fmay487gsdyfga678wr82","7n38274ods897fmay487gsdyfga678wr82"]` |



### <span id="artifact-group-vuln-reach-post-response"></span> ArtifactGroupVulnReachPostResponse


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| AgCount | uint64 (formatted integer)| `uint64` |  | | Number of artifact groups affected by the vulnerability | `5` |
| Vulnerability | [VulnResponse](#vuln-response)| `VulnResponse` |  | |  |  |



### <span id="artifact-group-vuln-search-filters"></span> ArtifactGroupVulnSearchFilters


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| All | boolean| `bool` |  | | If no pagination parameters are provided, defaults to true and returns all available results. |  |
| ArtifactGroupUID | string| `string` |  | | An optional artifact group UID that the image and source must contain. Only artifact groups, and their images and sources, with this artifact group UID will be returned. If both package name and artifact group UID are provided, then only the images and sources with the specified package name and artifact group UID will be returned. | `9aa3548e-5fae-11ed-9b6a-0242ac120002` |
| Digests | []string| `[]string` |  | | A list of image digests. At least one image digest or source sha must be provided. | `["9n38274ods897fmay487gsdyfga678wr82","7n38274ods897fmay487gsdyfga678wr82"]` |
| PackageName | string| `string` |  | | An optional package name that the image and source must contain. Only packages, and their images and sources, with this name will be returned. If both package name and artifact group UID are provided, then only the images and sources with the specified package name and artifact group UID will be returned. | `package1` |
| Page | int64 (formatted integer)| `int64` |  | `1`|  |  |
| PageSize | int64 (formatted integer)| `int64` |  | `20`|  |  |
| Shas | []string| `[]string` |  | | A list of source shas. At least one image digest or source sha must be provided. | `["sha256:2c11624a8d9c9071996a886a4acaf09939ef3386e4c07735c6a2532f02eed4ea","sha256:04bafe0d8df23ec342edb72acc3fb02f61c418bc6e8d7093149956a9aad2d12a"]` |



### <span id="deleted-at"></span> DeletedAt


  


* composed type [NullTime](#null-time)

### <span id="entity"></span> Entity


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| Digest | string| `string` |  | | The digest of the image entity. Only visible if the entity is of image type | `sha256:f7de1564f13da1ef7e5720ebce14006793242c0d8d7d60c343632bcf3bc5306d` |
| Host | string| `string` |  | | The dns name where the source entity is hosted on. Only visible if the entity type is of source type | `gitlab.com` |
| ID | uint64 (formatted integer)| `uint64` | ✓ | | The database ID of the source or image | `24` |
| Name | string| `string` |  | | The name of the image entity. Only visible if the entity is of image type. | `checkr/flagr` |
| Org | string| `string` |  | | The organization name of the source entity. Only visible if the entity type is of source type | `my-organization` |
| Packages | [[]Package](#package)| `[]*Package` |  | |  |  |
| Registry | string| `string` |  | | The DNS name of the registry that stores the image entity. Only visible if the entity is of image type | `docker.io` |
| Repo | string| `string` |  | | The repository name of the source entity. Only visible if the entity type is of source type | `my-sample-repo` |
| Sha | string| `string` |  | | The commit sha of the source entity. Only visible if the entity type is of source type | `d6cd1e2bd19e03a81132a23b2025920577f84e37` |
| Type | string| `string` | ✓ | | The entity Type of scan that is stored. This is set to either "image" or "source". | `image` |



### <span id="error-message"></span> ErrorMessage


> ErrorMessage wraps an error message in a struct so responses are properly
marshalled as a JSON object.
  





**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| Message | string| `string` |  | | in: body | `something went wrong` |



### <span id="image"></span> Image


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| Digest | string| `string` | ✓ | |  | `9n38274ods897fmay487gsdyfga678wr82` |
| ID | uint64 (formatted integer)| `uint64` |  | |  |  |
| Name | string| `string` | ✓ | |  | `myorg/application` |
| Packages | [[]Package](#package)| `[]*Package` |  | |  |  |
| Registry | string| `string` | ✓ | |  | `docker.io` |
| Sources | [[]Source](#source)| `[]*Source` |  | |  |  |



### <span id="method-type"></span> MethodType


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| CreatedAt | date-time (formatted string)| `strfmt.DateTime` |  | |  |  |
| DeletedAt | [DeletedAt](#deleted-at)| `DeletedAt` |  | |  |  |
| ID | uint64 (formatted integer)| `uint64` |  | |  |  |
| Name | string| `string` |  | |  |  |
| Rating | [[]Rating](#rating)| `[]*Rating` |  | |  |  |
| UpdatedAt | date-time (formatted string)| `strfmt.DateTime` |  | |  |  |



### <span id="model"></span> Model


> Model a basic GoLang struct which includes the following fields: ID, CreatedAt, UpdatedAt, DeletedAt
It may be embedded into your model or you may build your own model without it
type User struct {
gorm.Model
}
  





**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| CreatedAt | date-time (formatted string)| `strfmt.DateTime` |  | |  |  |
| DeletedAt | [DeletedAt](#deleted-at)| `DeletedAt` |  | |  |  |
| ID | uint64 (formatted integer)| `uint64` |  | |  |  |
| UpdatedAt | date-time (formatted string)| `strfmt.DateTime` |  | |  |  |



### <span id="null-time"></span> NullTime


> NullTime implements the Scanner interface so
it can be used as a scan destination, similar to NullString.
  





**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| Time | date-time (formatted string)| `strfmt.DateTime` |  | |  |  |
| Valid | boolean| `bool` |  | |  |  |



### <span id="package"></span> Package


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| Homepage | string| `string` |  | |  |  |
| ID | uint64 (formatted integer)| `uint64` |  | |  |  |
| Images | [[]Image](#image)| `[]*Image` |  | |  |  |
| Name | string| `string` |  | |  |  |
| PackageManager | string| `string` |  | |  |  |
| Sources | [[]Source](#source)| `[]*Source` |  | |  |  |
| Version | string| `string` |  | |  |  |
| Vulnerabilities | [[]Vulnerability](#vulnerability)| `[]*Vulnerability` |  | |  |  |



### <span id="paginated-artifact-group-vuln-reach-response"></span> PaginatedArtifactGroupVulnReachResponse


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| Count | int64 (formatted integer)| `int64` |  | |  | `10` |
| CurrentPage | int64 (formatted integer)| `int64` |  | |  | `1` |
| LastPage | int64 (formatted integer)| `int64` |  | |  | `2` |
| PageSize | int64 (formatted integer)| `int64` |  | |  | `20` |
| Results | [[]ArtifactGroupVulnReachPostResponse](#artifact-group-vuln-reach-post-response)| `[]*ArtifactGroupVulnReachPostResponse` |  | |  |  |



### <span id="paginated-response"></span> PaginatedResponse


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| Count | int64 (formatted integer)| `int64` |  | |  | `10` |
| CurrentPage | int64 (formatted integer)| `int64` |  | |  | `1` |
| LastPage | int64 (formatted integer)| `int64` |  | |  | `2` |
| PageSize | int64 (formatted integer)| `int64` |  | |  | `20` |
| Results | [[]interface{}](#interface)| `[]interface{}` |  | |  |  |



### <span id="rating"></span> Rating


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| ID | uint64 (formatted integer)| `uint64` |  | |  |  |
| MethodType | [MethodType](#method-type)| `MethodType` |  | |  |  |
| MethodTypeID | uint64 (formatted integer)| `uint64` |  | |  |  |
| Score | double (formatted number)| `float64` |  | |  |  |
| Severity | string| `string` |  | |  |  |
| Vector | string| `string` |  | |  |  |



### <span id="rating-response"></span> RatingResponse


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| ID | uint64 (formatted integer)| `uint64` |  | | Rating ID | `3` |
| Score | double (formatted number)| `float64` |  | | CVSS score | `9.7` |
| Severity | string| `string` |  | | Threat level of vulnerability | `High` |
| Vector | string| `string` |  | | CVSS score in vector format | `AV:L/AC:L/Au:N/C:C/I:C/A:C` |



### <span id="source"></span> Source


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| DeletedAt | [DeletedAt](#deleted-at)| `DeletedAt` |  | |  |  |
| Host | string| `string` |  | |  | `gitlab.com` |
| ID | uint64 (formatted integer)| `uint64` |  | |  |  |
| Images | [[]Image](#image)| `[]*Image` |  | |  |  |
| Organization | string| `string` |  | |  | `vmware` |
| Packages | [[]Package](#package)| `[]*Package` |  | |  |  |
| Repository | string| `string` | ✓ | |  | `myproject` |
| Sha | string| `string` | ✓ | |  | `0eb5fcd1` |



### <span id="string-array"></span> StringArray


  

[]string

### <span id="vuln-response"></span> VulnResponse


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| CNA | string| `string` |  | | CVE Numbering Authority | `GitHub, Inc.` |
| CVEID | string| `string` |  | | CVE ID of the vulnerability | `CVE-7467-2020` |
| Description | string| `string` |  | | Description of the vulnerability | `IBM Datapower Gateway 10.0.2.0 through 10.0.4.0, 10.0.1.0 through 10.0.1.5, and 2018.4.1.0 through 2018.4.1.18 could allow unauthorized viewing of logs and files due to insufficient authorization checks. IBM X-Force ID: 218856.` |
| ID | uint64 (formatted integer)| `uint64` |  | | Vulnerability ID | `12` |
| Ratings | [[]RatingResponse](#rating-response)| `[]*RatingResponse` |  | | Rating information |  |
| References | []string| `[]string` |  | | Additional external links | `https://github.com/example/repo/issues/11` |
| URL | string| `string` |  | | Related url to the vulnerability | `https://nvd.nist.gov/vuln/detail/CVE-7467-2020` |



### <span id="vulnerability"></span> Vulnerability


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| CNA | string| `string` |  | |  | `GitHub, Inc.` |
| CVEID | string| `string` | ✓ | |  | `CVE-7467-2020` |
| Description | string| `string` |  | |  | `A description of CVE-7467-2020` |
| ID | uint64 (formatted integer)| `uint64` |  | |  |  |
| Packages | [[]Package](#package)| `[]*Package` |  | |  |  |
| Ratings | [[]Rating](#rating)| `[]*Rating` |  | |  |  |
| References | [StringArray](#string-array)| `StringArray` |  | |  |  |
| URL | string| `string` |  | |  | `https://nvd.nist.gov/vuln/detail/CVE-7467-2020` |



### <span id="artifact-group-post-entity"></span> artifactGroupPostEntity


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| ID | uint64 (formatted integer)| `uint64` | ✓ | | The database ID of the source or image | `24` |
| Type | string| `string` | ✓ | | The entity Type of scan that is stored. This is set to either "image" or "source". | `image` |



### <span id="artifact-group-post-response"></span> artifactGroupPostResponse


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| Entities | [[]ArtifactGroupPostEntity](#artifact-group-post-entity)| `[]*ArtifactGroupPostEntity` |  | | Entities associated with the Artifact Group |  |
| Labels | map of string| `map[string]string` |  | | Key-Value pair of labels associated with the Artifact Group | `{"env":"production","namespace":"default"}` |
| UID | string| `string` |  | | Unique identifier for the Artifact Group such as workload UID | `8b1cc5da-fabe-45a6-ab8c-49260bbeef99` |



### <span id="artifact-group-vuln-artifact-group"></span> artifactGroupVulnArtifactGroup


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| Entities | [[]ArtifactGroupVulnEntity](#artifact-group-vuln-entity)| `[]*ArtifactGroupVulnEntity` |  | | Entities associated with the Artifact Group |  |
| Labels | map of string| `map[string]string` |  | | Key-Value pair of labels associated with the Artifact Group | `{"env":"production","namespace":"default"}` |
| UID | string| `string` |  | | Unique identifier for the Artifact Group such as workload UID | `8b1cc5da-fabe-45a6-ab8c-49260bbeef99` |



### <span id="artifact-group-vuln-entity"></span> artifactGroupVulnEntity


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| Digest | string| `string` |  | | The digest of the image entity. Only visible if the entity is of image type | `sha256:f7de1564f13da1ef7e5720ebce14006793242c0d8d7d60c343632bcf3bc5306d` |
| Host | string| `string` |  | | The dns name where the source entity is hosted on. Only visible if the entity type is of source type | `gitlab.com` |
| ID | uint64 (formatted integer)| `uint64` | ✓ | | The database ID of the source or image | `24` |
| Name | string| `string` |  | | The name of the image entity. Only visible if the entity is of image type. | `checkr/flagr` |
| Org | string| `string` |  | | The organization name of the source entity. Only visible if the entity type is of source type | `my-organization` |
| Registry | string| `string` |  | | The DNS name of the registry that stores the image entity. Only visible if the entity is of image type | `docker.io` |
| Repo | string| `string` |  | | The repository name of the source entity. Only visible if the entity type is of source type | `my-sample-repo` |
| Sha | string| `string` |  | | The commit sha of the source entity. Only visible if the entity type is of source type | `d6cd1e2bd19e03a81132a23b2025920577f84e37` |
| Type | string| `string` | ✓ | | The entity Type of scan that is stored. This is set to either "image" or "source". | `image` |



### <span id="artifact-group-vuln-package"></span> artifactGroupVulnPackage


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| Homepage | string| `string` |  | |  |  |
| ID | uint64 (formatted integer)| `uint64` |  | |  |  |
| Images | [[]Image](#image)| `[]*Image` |  | | This field will always be empty | `[]` |
| Name | string| `string` |  | |  |  |
| PackageManager | string| `string` |  | |  |  |
| Sources | [[]Source](#source)| `[]*Source` |  | | This field will always be empty | `[]` |
| Version | string| `string` |  | |  |  |
| Vulnerabilities | [[]Vulnerability](#vulnerability)| `[]*Vulnerability` |  | | This field will always be empty | `[]` |



### <span id="artifact-group-vuln-result"></span> artifactGroupVulnResult


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| ArtifactGroups | [[]ArtifactGroupVulnArtifactGroup](#artifact-group-vuln-artifact-group)| `[]*ArtifactGroupVulnArtifactGroup` |  | |  |  |
| CNA | string| `string` |  | |  | `GitHub, Inc.` |
| CVEID | string| `string` | ✓ | |  | `CVE-7467-2020` |
| Description | string| `string` |  | |  | `A description of CVE-7467-2020` |
| ID | uint64 (formatted integer)| `uint64` |  | |  |  |
| Packages | [[]ArtifactGroupVulnPackage](#artifact-group-vuln-package)| `[]*ArtifactGroupVulnPackage` |  | |  |  |
| Ratings | [[]Rating](#rating)| `[]*Rating` |  | |  |  |
| References | [StringArray](#string-array)| `StringArray` |  | |  |  |
| URL | string| `string` |  | |  | `https://nvd.nist.gov/vuln/detail/CVE-7467-2020` |



### <span id="paginated-artifact-group-response"></span> paginatedArtifactGroupResponse


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| Count | int64 (formatted integer)| `int64` |  | |  | `10` |
| CurrentPage | int64 (formatted integer)| `int64` |  | |  | `1` |
| LastPage | int64 (formatted integer)| `int64` |  | |  | `2` |
| PageSize | int64 (formatted integer)| `int64` |  | |  | `20` |
| Results | [[]ArtifactGroupResponse](#artifact-group-response)| `[]*ArtifactGroupResponse` |  | |  |  |



### <span id="paginated-artifact-group-vulnerability-response"></span> paginatedArtifactGroupVulnerabilityResponse


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| Count | int64 (formatted integer)| `int64` |  | |  | `10` |
| CurrentPage | int64 (formatted integer)| `int64` |  | |  | `1` |
| LastPage | int64 (formatted integer)| `int64` |  | |  | `2` |
| PageSize | int64 (formatted integer)| `int64` |  | |  | `20` |
| Results | [[]ArtifactGroupVulnResult](#artifact-group-vuln-result)| `[]*ArtifactGroupVulnResult` |  | |  |  |



### <span id="paginated-image-response"></span> paginatedImageResponse


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| Count | int64 (formatted integer)| `int64` |  | |  | `10` |
| CurrentPage | int64 (formatted integer)| `int64` |  | |  | `1` |
| LastPage | int64 (formatted integer)| `int64` |  | |  | `2` |
| PageSize | int64 (formatted integer)| `int64` |  | |  | `20` |
| Results | [[]ResponseImage](#response-image)| `[]*ResponseImage` |  | |  |  |



### <span id="paginated-package-response"></span> paginatedPackageResponse


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| Count | int64 (formatted integer)| `int64` |  | |  | `10` |
| CurrentPage | int64 (formatted integer)| `int64` |  | |  | `1` |
| LastPage | int64 (formatted integer)| `int64` |  | |  | `2` |
| PageSize | int64 (formatted integer)| `int64` |  | |  | `20` |
| Results | [[]ResponsePackage](#response-package)| `[]*ResponsePackage` |  | |  |  |



### <span id="paginated-source-response"></span> paginatedSourceResponse


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| Count | int64 (formatted integer)| `int64` |  | |  | `10` |
| CurrentPage | int64 (formatted integer)| `int64` |  | |  | `1` |
| LastPage | int64 (formatted integer)| `int64` |  | |  | `2` |
| PageSize | int64 (formatted integer)| `int64` |  | |  | `20` |
| Results | [[]ResponseSource](#response-source)| `[]*ResponseSource` |  | |  |  |



### <span id="paginated-vulnerability-response"></span> paginatedVulnerabilityResponse


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| Count | int64 (formatted integer)| `int64` |  | |  | `10` |
| CurrentPage | int64 (formatted integer)| `int64` |  | |  | `1` |
| LastPage | int64 (formatted integer)| `int64` |  | |  | `2` |
| PageSize | int64 (formatted integer)| `int64` |  | |  | `20` |
| Results | [[]ResponseVulnerability](#response-vulnerability)| `[]*ResponseVulnerability` |  | |  |  |



### <span id="response-image"></span> responseImage


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| CreatedAt | date-time (formatted string)| `strfmt.DateTime` |  | |  |  |
| Digest | string| `string` | ✓ | |  | `9n38274ods897fmay487gsdyfga678wr82` |
| ID | uint64 (formatted integer)| `uint64` |  | |  |  |
| Name | string| `string` | ✓ | |  | `myorg/application` |
| Packages | [[]Package](#package)| `[]*Package` |  | |  |  |
| Registry | string| `string` | ✓ | |  | `docker.io` |
| Sources | [[]Source](#source)| `[]*Source` |  | |  |  |
| UpdatedAt | date-time (formatted string)| `strfmt.DateTime` |  | |  |  |



### <span id="response-package"></span> responsePackage


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| CreatedAt | date-time (formatted string)| `strfmt.DateTime` |  | |  |  |
| Homepage | string| `string` |  | |  |  |
| ID | uint64 (formatted integer)| `uint64` |  | |  |  |
| Images | [[]Image](#image)| `[]*Image` |  | |  |  |
| Name | string| `string` |  | |  |  |
| PackageManager | string| `string` |  | |  |  |
| Sources | [[]Source](#source)| `[]*Source` |  | |  |  |
| UpdatedAt | date-time (formatted string)| `strfmt.DateTime` |  | |  |  |
| Version | string| `string` |  | |  |  |
| Vulnerabilities | [[]Vulnerability](#vulnerability)| `[]*Vulnerability` |  | |  |  |



### <span id="response-source"></span> responseSource


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| CreatedAt | date-time (formatted string)| `strfmt.DateTime` |  | |  |  |
| DeletedAt | [DeletedAt](#deleted-at)| `DeletedAt` |  | |  |  |
| Host | string| `string` |  | |  | `gitlab.com` |
| ID | uint64 (formatted integer)| `uint64` |  | |  |  |
| Images | [[]Image](#image)| `[]*Image` |  | |  |  |
| Organization | string| `string` |  | |  | `vmware` |
| Packages | [[]Package](#package)| `[]*Package` |  | |  |  |
| Repository | string| `string` | ✓ | |  | `myproject` |
| Sha | string| `string` | ✓ | |  | `0eb5fcd1` |
| UpdatedAt | date-time (formatted string)| `strfmt.DateTime` |  | |  |  |



### <span id="response-vulnerability"></span> responseVulnerability


  



**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| CNA | string| `string` |  | |  | `GitHub, Inc.` |
| CVEID | string| `string` | ✓ | |  | `CVE-7467-2020` |
| CreatedAt | date-time (formatted string)| `strfmt.DateTime` |  | |  |  |
| Description | string| `string` |  | |  | `A description of CVE-7467-2020` |
| ID | uint64 (formatted integer)| `uint64` |  | |  |  |
| Packages | [[]Package](#package)| `[]*Package` |  | |  |  |
| Ratings | [[]Rating](#rating)| `[]*Rating` |  | |  |  |
| References | [StringArray](#string-array)| `StringArray` |  | |  |  |
| URL | string| `string` |  | |  | `https://nvd.nist.gov/vuln/detail/CVE-7467-2020` |
| UpdatedAt | date-time (formatted string)| `strfmt.DateTime` |  | |  |  |