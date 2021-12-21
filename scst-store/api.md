


# API details

See [API walkthrough](api_walkthrough.md) for a walkthrough and example.

## Information

### Version

0.0.1

## Content negotiation

### URI Schemes
* http
* https

### Consumes
* application/json

### Produces
* application/json

## All endpoints

###  images

| Method  | URI     | Name   | Summary |
|---------|---------|--------|---------|
| POST | /api/imageReport | [create image report](#create-image-report) | Create a new image report. Related packages and vulnerabilities are also created. |
| GET | /api/images | [get images](#get-images) | Search image by id or digest. |
| GET | /api/packages/{IDorName}/images | [get package images](#get-package-images) | List the images that contain the given package. |
| GET | /api/vulnerabilities/{CVEID}/images | [get vulnerability images](#get-vulnerability-images) | List the images that contain the given vulnerability. |



###  Operations

| Method  | URI     | Name   | Summary |
|---------|---------|--------|---------|
| GET | /api/health | [health check](#health-check) |  |



###  Packages

| Method  | URI     | Name   | Summary |
|---------|---------|--------|---------|
| GET | /api/images/{IDorDigest}/packages | [get image packages](#get-image-packages) | List the packages in an image. |
| GET | /api/packages | [get packages](#get-packages) | Search packages by id, name and/or version. |
| GET | /api/sources/{IDorRepoorSha}/packages | [get source packages](#get-source-packages) |  |
| GET | /api/sources/packages | [get source packages query](#get-source-packages-query) | List packages of the given source. |
| GET | /api/vulnerabilities/{CVEID}/packages | [get vulnerability packages](#get-vulnerability-packages) | List packages that contain the given CVE id. |



###  Sources

| Method  | URI     | Name   | Summary |
|---------|---------|--------|---------|
| POST | /api/sourceReport | [create source report](#create-source-report) | Create a new source report. Related packages and vulnerabilities are also created. |
| GET | /api/packages/{IDorName}/sources | [get package sources](#get-package-sources) | List the sources containing the given package. |
| GET | /api/sources | [get sourcs](#get-sourcs) | Search for sources by ID, repository, commit sha and/or organization. |
| GET | /api/vulnerabiltities/{CVEID}/sources | [get vulnerability sources](#get-vulnerability-sources) | List sources that contain the given vulnerability. |



###  Vulnerabilities

| Method  | URI     | Name   | Summary |
|---------|---------|--------|---------|
| GET | /api/images/{IDorDigest}/vulnerabilities | [get image vulnerabilities](#get-image-vulnerabilities) | List vulnerabilities from the given image. |
| GET | /api/packages/{IDorName}/vulnerabilities | [get package vulnerabilities](#get-package-vulnerabilities) | List vulnerabilities from the given package. |
| GET | /api/sources/{IDorRepoorSha}/vulnerabilitites | [get source vulnerabilities](#get-source-vulnerabilities) |  |
| GET | /api/sources/vulnerabilitites | [get source vulnerabilities query](#get-source-vulnerabilities-query) | List vulnerabilities of the given source. |
| GET | /api/vulnerabilities | [get vulnerabilities](#get-vulnerabilities) | Search for vulnerabilities by CVE id. |



## Paths

### <span id="create-image-report"></span> Create a new image report. Related packages and vulnerabilities are also created. (*CreateImageReport*)

```
POST /api/imageReport
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| Image | `body` | [Image](#image) | `models.Image` | | ✓ | |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#create-image-report-200) | OK | Image |  | [schema](#create-image-report-200-schema) |
| [default](#create-image-report-default) | | ErrorMessage |  | [schema](#create-image-report-default-schema) |

#### Responses


##### <span id="create-image-report-200"></span> 200 - Image
Status: OK

###### <span id="create-image-report-200-schema"></span> Schema



[Image](#image)

##### <span id="create-image-report-default"></span> Default Response
ErrorMessage

###### <span id="create-image-report-default-schema"></span> Schema



[ErrorMessage](#error-message)

### <span id="create-source-report"></span> Create a new source report. Related packages and vulnerabilities are also created. (*CreateSourceReport*)

```
POST /api/sourceReport
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| Image | `body` | [Source](#source) | `models.Source` | | ✓ | |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#create-source-report-200) | OK | Source |  | [schema](#create-source-report-200-schema) |
| [default](#create-source-report-default) | | ErrorMessage |  | [schema](#create-source-report-default-schema) |

#### Responses


##### <span id="create-source-report-200"></span> 200 - Source
Status: OK

###### <span id="create-source-report-200-schema"></span> Schema



[Source](#source)

##### <span id="create-source-report-default"></span> Default Response
ErrorMessage

###### <span id="create-source-report-default-schema"></span> Schema



[ErrorMessage](#error-message)

### <span id="get-image-packages"></span> List the packages in an image. (*GetImagePackages*)

```
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



[][Package](#package)

##### <span id="get-image-packages-default"></span> Default Response
ErrorMessage

###### <span id="get-image-packages-default-schema"></span> Schema



[ErrorMessage](#error-message)

### <span id="get-image-vulnerabilities"></span> List vulnerabilities from the given image. (*GetImageVulnerabilities*)

```
GET /api/images/{IDorDigest}/vulnerabilities
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| IDorDigest | `path` | string | `string` |  | ✓ |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-image-vulnerabilities-200) | OK | Vulnerability |  | [schema](#get-image-vulnerabilities-200-schema) |
| [default](#get-image-vulnerabilities-default) | | ErrorMessage |  | [schema](#get-image-vulnerabilities-default-schema) |

#### Responses


##### <span id="get-image-vulnerabilities-200"></span> 200 - Vulnerability
Status: OK

###### <span id="get-image-vulnerabilities-200-schema"></span> Schema



[][Vulnerability](#vulnerability)

##### <span id="get-image-vulnerabilities-default"></span> Default Response
ErrorMessage

###### <span id="get-image-vulnerabilities-default-schema"></span> Schema



[ErrorMessage](#error-message)

### <span id="get-images"></span> Search image by id or digest. (*GetImages*)

```
GET /api/images
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| digest | `query` | string | `string` |  |  |  |  |
| id | `query` | int64 (formatted integer) | `int64` |  |  |  |  |

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

### <span id="get-package-images"></span> List the images that contain the given package. (*GetPackageImages*)

```
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



[][Image](#image)

##### <span id="get-package-images-default"></span> Default Response
ErrorMessage

###### <span id="get-package-images-default-schema"></span> Schema



[ErrorMessage](#error-message)

### <span id="get-package-sources"></span> List the sources containing the given package. (*GetPackageSources*)

```
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



[][Source](#source)

##### <span id="get-package-sources-default"></span> Default Response
ErrorMessage

###### <span id="get-package-sources-default-schema"></span> Schema



[ErrorMessage](#error-message)

### <span id="get-package-vulnerabilities"></span> List vulnerabilities from the given package. (*GetPackageVulnerabilities*)

```
GET /api/packages/{IDorName}/vulnerabilities
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| IDorName | `path` | string | `string` |  | ✓ |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-package-vulnerabilities-200) | OK | Vulnerability |  | [schema](#get-package-vulnerabilities-200-schema) |
| [default](#get-package-vulnerabilities-default) | | ErrorMessage |  | [schema](#get-package-vulnerabilities-default-schema) |

#### Responses


##### <span id="get-package-vulnerabilities-200"></span> 200 - Vulnerability
Status: OK

###### <span id="get-package-vulnerabilities-200-schema"></span> Schema



[][Vulnerability](#vulnerability)

##### <span id="get-package-vulnerabilities-default"></span> Default Response
ErrorMessage

###### <span id="get-package-vulnerabilities-default-schema"></span> Schema



[ErrorMessage](#error-message)

### <span id="get-packages"></span> Search packages by id, name and/or version. (*GetPackages*)

```
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



[][Package](#package)

##### <span id="get-packages-default"></span> Default Response
ErrorMessage

###### <span id="get-packages-default-schema"></span> Schema



[ErrorMessage](#error-message)

### <span id="get-source-packages"></span> get source packages (*GetSourcePackages*)

```
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



[][Package](#package)

##### <span id="get-source-packages-default"></span> Default Response
ErrorMessage

###### <span id="get-source-packages-default-schema"></span> Schema



[ErrorMessage](#error-message)

### <span id="get-source-packages-query"></span> List packages of the given source. (*GetSourcePackagesQuery*)

```
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



[][Package](#package)

##### <span id="get-source-packages-query-default"></span> Default Response
ErrorMessage

###### <span id="get-source-packages-query-default-schema"></span> Schema



[ErrorMessage](#error-message)

### <span id="get-source-vulnerabilities"></span> get source vulnerabilities (*GetSourceVulnerabilities*)

```
GET /api/sources/{IDorRepoorSha}/vulnerabilitites
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



[][Vulnerability](#vulnerability)

##### <span id="get-source-vulnerabilities-default"></span> Default Response
ErrorMessage

###### <span id="get-source-vulnerabilities-default-schema"></span> Schema



[ErrorMessage](#error-message)

### <span id="get-source-vulnerabilities-query"></span> List vulnerabilities of the given source. (*GetSourceVulnerabilitiesQuery*)

```
GET /api/sources/vulnerabilitites
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
| [200](#get-source-vulnerabilities-query-200) | OK | Vulnerability |  | [schema](#get-source-vulnerabilities-query-200-schema) |
| [default](#get-source-vulnerabilities-query-default) | | ErrorMessage |  | [schema](#get-source-vulnerabilities-query-default-schema) |

#### Responses


##### <span id="get-source-vulnerabilities-query-200"></span> 200 - Vulnerability
Status: OK

###### <span id="get-source-vulnerabilities-query-200-schema"></span> Schema



[][Vulnerability](#vulnerability)

##### <span id="get-source-vulnerabilities-query-default"></span> Default Response
ErrorMessage

###### <span id="get-source-vulnerabilities-query-default-schema"></span> Schema



[ErrorMessage](#error-message)

### <span id="get-sourcs"></span> Search for sources by ID, repository, commit sha and/or organization. (*GetSourcs*)

```
GET /api/sources
```

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-sourcs-200) | OK | Source |  | [schema](#get-sourcs-200-schema) |
| [default](#get-sourcs-default) | | ErrorMessage |  | [schema](#get-sourcs-default-schema) |

#### Responses


##### <span id="get-sourcs-200"></span> 200 - Source
Status: OK

###### <span id="get-sourcs-200-schema"></span> Schema



[][Source](#source)

##### <span id="get-sourcs-default"></span> Default Response
ErrorMessage

###### <span id="get-sourcs-default-schema"></span> Schema



[ErrorMessage](#error-message)

### <span id="get-vulnerabilities"></span> Search for vulnerabilities by CVE id. (*GetVulnerabilities*)

```
GET /api/vulnerabilities
```

#### Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| CVEID | `query` | string | `string` |  | ✓ |  |  |

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-vulnerabilities-200) | OK | Vulnerability |  | [schema](#get-vulnerabilities-200-schema) |
| [default](#get-vulnerabilities-default) | | ErrorMessage |  | [schema](#get-vulnerabilities-default-schema) |

#### Responses


##### <span id="get-vulnerabilities-200"></span> 200 - Vulnerability
Status: OK

###### <span id="get-vulnerabilities-200-schema"></span> Schema



[][Vulnerability](#vulnerability)

##### <span id="get-vulnerabilities-default"></span> Default Response
ErrorMessage

###### <span id="get-vulnerabilities-default-schema"></span> Schema



[ErrorMessage](#error-message)

### <span id="get-vulnerability-images"></span> List the images that contain the given vulnerability. (*GetVulnerabilityImages*)

```
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



[][Image](#image)

##### <span id="get-vulnerability-images-default"></span> Default Response
ErrorMessage

###### <span id="get-vulnerability-images-default-schema"></span> Schema



[ErrorMessage](#error-message)

### <span id="get-vulnerability-packages"></span> List packages that contain the given CVE id. (*GetVulnerabilityPackages*)

```
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



[][Package](#package)

##### <span id="get-vulnerability-packages-default"></span> Default Response
ErrorMessage

###### <span id="get-vulnerability-packages-default-schema"></span> Schema



[ErrorMessage](#error-message)

### <span id="get-vulnerability-sources"></span> List sources that contain the given vulnerability. (*GetVulnerabilitySources*)

```
GET /api/vulnerabiltities/{CVEID}/sources
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



[][Source](#source)

##### <span id="get-vulnerability-sources-default"></span> Default Response
ErrorMessage

###### <span id="get-vulnerability-sources-default-schema"></span> Schema



[ErrorMessage](#error-message)

### <span id="health-check"></span> health check (*HealthCheck*)

```
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

## Models

### <span id="deleted-at"></span> DeletedAt





* composed type [NullTime](#null-time)

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
| Packages | [][Package](#package)| `[]*Package` |  | |  |  |
| Registry | string| `string` | ✓ | |  | `docker.io` |
| Sources | [][Source](#source)| `[]*Source` |  | |  |  |



### <span id="method-type"></span> MethodType






**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| CreatedAt | date-time (formatted string)| `strfmt.DateTime` |  | |  |  |
| DeletedAt | [DeletedAt](#deleted-at)| `DeletedAt` |  | |  |  |
| ID | uint64 (formatted integer)| `uint64` |  | |  |  |
| Name | string| `string` |  | |  |  |
| Rating | [][Rating](#rating)| `[]*Rating` |  | |  |  |
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
| Images | [][Image](#image)| `[]*Image` |  | |  |  |
| Name | string| `string` |  | |  |  |
| PackageManager | string| `string` |  | |  |  |
| Sources | [][Source](#source)| `[]*Source` |  | |  |  |
| Version | string| `string` |  | |  |  |
| Vulnerabilities | [][Vulnerability](#vulnerability)| `[]*Vulnerability` |  | |  |  |



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



### <span id="source"></span> Source






**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| DeletedAt | [DeletedAt](#deleted-at)| `DeletedAt` |  | |  |  |
| Host | string| `string` |  | |  | `gitlab.com` |
| ID | uint64 (formatted integer)| `uint64` |  | |  |  |
| Images | [][Image](#image)| `[]*Image` |  | |  |  |
| Organization | string| `string` |  | |  | `vmware` |
| Packages | [][Package](#package)| `[]*Package` |  | |  |  |
| Repository | string| `string` | ✓ | |  | `myproject` |
| Sha | string| `string` | ✓ | |  | `0eb5fcd1` |



### <span id="string-array"></span> StringArray




[]string

### <span id="vulnerability"></span> Vulnerability






**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| CNA | string| `string` |  | |  |  |
| CVEID | string| `string` | ✓ | |  | `CVE-7467-2020` |
| Description | string| `string` |  | |  |  |
| ID | uint64 (formatted integer)| `uint64` |  | |  |  |
| Packages | [][Package](#package)| `[]*Package` |  | |  |  |
| Ratings | [][Rating](#rating)| `[]*Rating` |  | |  |  |
| References | [StringArray](#string-array)| `StringArray` |  | |  |  |
| URL | string| `string` |  | |  |  |

