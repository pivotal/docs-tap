# API details

See [API walkthrough](api-walkthrough.md) for a walkthrough and example.

## <a id='info'></a>Information

### <a id='methods'></a>Version

0.0.1

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
| GET | /api/images | [get images](#get-images) | Search image by id or digest. |
| GET | /api/packages/{IDorName}/images | [get package images](#gpi) | List the images that contain the given package. |
| GET | /api/vulnerabilities/{CVEID}/images | [get vulnerability images](#gvi) | List the images that contain the given vulnerability. |



###  <a id='operations'></a>Operations

| Method  | URI     | Name   | Summary |
|---------|---------|--------|---------|
| GET | /api/health | [health check](#health-check) |  |



###  <a id='packages'></a>Packages

| Method  | URI     | Name   | Summary |
|---------|---------|--------|---------|
| GET | /api/images/{IDorDigest}/packages | [get image packages](#gip) | List the packages in an image. |
| GET | /api/packages | [get packages](#gp) | Search packages by id, name and/or version. |
| GET | /api/sources/{IDorRepoorSha}/packages | [get source packages](#gsp) |  |
| GET | /api/sources/packages | [get source packages query](#gspq) | List packages of the given source. |
| GET | /api/vulnerabilities/{CVEID}/packages | [get vulnerability packages](#gvp) | List packages that contain the given CVE id. |



###  <a id='sources'></a>Sources

| Method  | URI     | Name   | Summary |
|---------|---------|--------|---------|
| POST | /api/sourceReport | [create source report](#create-sr) | Create a new source report. Related packages and vulnerabilities are also created. |
| GET | /api/packages/{IDorName}/sources | [get package sources](#gps) | List the sources containing the given package. |
| GET | /api/sources | [get sources](#get-sources) | Search for sources by ID, repository, commit sha and/or organization. |
| GET | /api/vulnerabilities/{CVEID}/sources | [get vulnerability sources](#gvs) | List sources that contain the given vulnerability. |



###  <a id='vulnerabilities'></a>Vulnerabilities

| Method  | URI     | Name   | Summary |
|---------|---------|--------|---------|
| GET | /api/images/{IDorDigest}/vulnerabilities | [get image vulnerabilities](#giv) | List vulnerabilities from the given image. |
| GET | /api/packages/{IDorName}/vulnerabilities | [get package vulnerabilities](#gpv) | List vulnerabilities from the given package. |
| GET | /api/sources/{IDorRepoorSha}/vulnerabilities | [get source vulnerabilities](#gsv) |  |
| GET | /api/sources/vulnerabilities | [get source vulnerabilities query](#gsvq) | List vulnerabilities of the given source. |
| GET | /api/vulnerabilities | [get vulnerabilities](#gv) | Search for vulnerabilities by CVE id. |



## <a id='paths'></a>Paths

### <a id="cir"></a> Create a new image report. Related packages and vulnerabilities are also created. (*CreateImageReport*)

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
| [200](#create-im-rpt-200) | OK | Image |  | [schema](#create-im-rpt-200-schema) |
| [default](#create-im-rpt-default) | | ErrorMessage |  | [schema](#create-im-rpt-default-schema) |

#### <a id='responses-cir'></a>Responses


##### <a id="create-im-rpt-200"></a> 200 - Image
Status: OK

###### <a id="create-im-rpt-200-schema"></a> Schema



[Image](#image)

##### <a id="create-im-rpt-default"></a> Default Response
ErrorMessage

###### <a id="create-im-rpt-def-schema"></a> Schema



[ErrorMessage](#error-message)

### <a id="create-sr"></a> Create a new source report. Related packages and vulnerabilities are also created. (*CreateSourceReport*)

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
| [200](#create-srce-rpt-200) | OK | Source |  | [schema](#create-srce-rpt-200-schema) |
| [default](#create-srce-rpt-def) | | ErrorMessage |  | [schema](#create-srce-rpt-def-schema) |

#### <a id='responses-csr'></a>Responses


##### <a id="create-srce-rpt-200"></a> 200 - Source
Status: OK

###### <a id="create-srce-rpt-200-schem"></a> Schema



[Source](#source)

##### <a id="cr-source-rpt-def"></a> Default Response
ErrorMessage

###### <a id="cr-source-rpt-def-schema"></a> Schema



[ErrorMessage](#error-message)

### <a id="gip"></a> List the packages in an image. (*GetImagePackages*)

```console
GET /api/images/{IDorDigest}/packages
```

#### <a id='parameters-gip'></a>Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| IDorDigest | `path` | string | `string` |  | ✓ |  |  |

#### <a id='all-responses-gip'></a>All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-im-packages-200) | OK | Package |  | [schema](#get-im-packages-200-schema) |
| [default](#get-im-packages-def) | | ErrorMessage |  | [schema](#get-im-packages-def-schema) |

#### <a id='responses-gip'></a>Responses


##### <a id="get-im-packages-200"></a> 200 - Package
Status: OK

###### <a id="get-im-pckgs-200-schema"></a> Schema



[][Package](#package)

##### <a id="get-im-pckgs-def"></a> Default Response
ErrorMessage

###### <a id="get-ime-pckgs-def-schema"></a> Schema



[ErrorMessage](#error-message)

### <a id="giv"></a> List vulnerabilities from the given image. (*GetImageVulnerabilities*)

```console
GET /api/images/{IDorDigest}/vulnerabilities
```

#### <a id='parameters-giv'></a>Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| IDorDigest | `path` | string | `string` |  | ✓ |  |  |

#### <a id='all-responses-giv'></a>All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-image-vul-200) | OK | Vulnerability |  | [schema](#get-image-vul-200-schema) |
| [default](#get-image-vul-def) | | ErrorMessage |  | [schema](#get-image-vul-def-schema) |

#### <a id='responses-giv'></a>Responses


##### <a id="get-image-vul-200"></a> 200 - Vulnerability
Status: OK

###### <a id="get-image-vul-200-schema"></a> Schema



[][Vulnerability](#vulnerability)

##### <a id="get-image-vul-def"></a> Default Response
ErrorMessage

###### <a id="get-im-vul-def-schema"></a> Schema



[ErrorMessage](#error-message)

### <a id="get-images"></a> Search image by id or digest. (*GetImages*)

```console
GET /api/images
```

#### <a id='parameters-gi'></a>Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| digest | `query` | string | `string` |  |  |  |  |
| id | `query` | int64 (formatted integer) | `int64` |  |  |  |  |

#### <a id='all-responses-GI'></a> responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-images-200) | OK | Image |  | [schema](#get-images-200-schema) |
| [default](#get-images-default) | | ErrorMessage |  | [schema](#get-images-default-schema) |

#### <a id='responses-gi'></a>Responses


##### <a id="get-images-200"></a> 200 - Image
Status: OK

###### <a id="get-images-200-schema"></a> Schema



[Image](#image)

##### <a id="get-images-default"></a> Default Response
ErrorMessage

###### <a id="get-images-default-schema"></a> Schema



[ErrorMessage](#error-message)

### <a id="gpi"></a> List the images that contain the given package. (*GetPackageImages*)

```console
GET /api/packages/{IDorName}/images
```

#### <a id='parameters-gpi'></a>Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| IDorName | `path` | string | `string` |  | ✓ |  |  |

#### <a id='all-responses5'></a>All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-pckg-im-200) | OK | Image |  | [schema](#get-pckg-im-200-schema) |
| [default](#get-pckg-im-def) | | ErrorMessage |  | [schema](#get-pckg-im-def-schema) |

#### <a id='responses-gpi'></a>Responses


##### <a id="get-pckg-im-200"></a> 200 - Image
Status: OK

###### <a id="get-pckg-im-200-schema"></a> Schema



[][Image](#image)

##### <a id="get-pckg-im-def"></a> Default Response
ErrorMessage

###### <a id="get-pckg-im-def-schema"></a> Schema



[ErrorMessage](#error-message)

### <a id="gps"></a> List the sources containing the given package. (*GetPackageSources*)

```console
GET /api/packages/{IDorName}/sources
```

#### <a id='parameters-gps'></a>Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| IDorName | `path` | string | `string` |  | ✓ |  |  |

#### <a id='all-responses-gps'></a>All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-pckg-sources-200) | OK | Source |  | [schema](#get-pckg-sources-200-schema) |
| [default](#get-pckg-sources-def) | | ErrorMessage |  | [schema](#get-pckg-sources-def-schema) |

#### <a id='responses-gps'></a>Responses


##### <a id="get-pckg-sources-200"></a> 200 - Source
Status: OK

###### <a id="get-pckg-srce-200-schema"></a> Schema



[][Source](#source)

##### <a id="get-pckg-srce-def"></a> Default Response
ErrorMessage

###### <a id="get-pckg-srce-def-schema"></a> Schema



[ErrorMessage](#error-message)

### <a id="gpv"></a> List vulnerabilities from the given package. (*GetPackageVulnerabilities*)

```console
GET /api/packages/{IDorName}/vulnerabilities
```

#### <a id='parameters-gpv'></a>Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| IDorName | `path` | string | `string` |  | ✓ |  |  |

#### <a id='all-responses-gpv'></a>All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-pckg-vul-200) | OK | Vulnerability |  | [schema](#get-pckg-vul-200-schema) |
| [default](#get-pckg-vul-default) | | ErrorMessage |  | [schema](#get-pckg-vul-def-schema) |

#### <a id='responses-gpv'></a>Responses


##### <a id="get-pckg-vul-200"></a> 200 - Vulnerability
Status: OK

###### <a id="get-pckg-v-200-schema"></a> Schema



[][Vulnerability](#vulnerability)

##### <a id="get-pckg-vul-default"></a> Default Response
ErrorMessage

###### <a id="get-pckg-vul-def-schema"></a> Schema



[ErrorMessage](#error-message)

### <a id="gp"></a> Search packages by id, name and/or version. (*GetPackages*)

```console
GET /api/packages
```

#### <a id='parameters-gp'></a>Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| id | `query` | int64 (formatted integer) | `int64` |  |  |  | Any of id or name must be provided |
| name | `query` | string | `string` |  |  |  | Any of id or name must be provided |
| version | `query` | string | `string` |  |  |  |  |

#### <a id='all-responses-gp'></a>All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-pckg-200) | OK | Package |  | [schema](#get-pckg-200-schema) |
| [default](#get-pckg-default) | | ErrorMessage |  | [schema](#get-pckg-default-schema) |

#### <a id='responses-gp'></a>Responses


##### <a id="get-pckg-200"></a> 200 - Package
Status: OK

###### <a id="get-pckg-200-schema"></a> Schema



[][Package](#package)

##### <a id="get-packages-default"></a> Default Response
ErrorMessage

###### <a id="get-pckg-default-schema"></a> Schema



[ErrorMessage](#error-message)

### <a id="gsp"></a> get source packages (*GetSourcePackages*)

```console
GET /api/sources/{IDorRepoorSha}/packages
```

#### <a id='parameters-gsp'></a>Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| IDorRepoorSha | `path` | string | `string` |  | ✓ |  |  |

#### <a id='all-responses-gsp'></a>All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-srce-pckg-200) | OK | Package |  | [schema](#get-srce-pckg-200-schema) |
| [default](#get-srce-pckg-def) | | ErrorMessage |  | [schema](#get-srce-pckg-def-schema) |

#### <a id='responses-gsp'></a>Responses


##### <a id="get-srce-pckg-200"></a> 200 - Package
Status: OK

###### <a id="get-srce-pckg-200-schema"></a> Schema



[][Package](#package)

##### <a id="get-srce-pckg-def"></a> Default Response
ErrorMessage

###### <a id="get-srce-pckg-def-schema"></a> Schema



[ErrorMessage](#error-message)

### <a id="gspq"></a> List packages of the given source. (*GetSourcePackagesQuery*)

```console
GET /api/sources/packages
```

#### <a id='parameters-gspq'></a>Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| id | `query` | uint64 (formatted integer) | `uint64` |  |  |  |  |
| repo | `query` | string | `string` |  |  |  |  |
| sha | `query` | string | `string` |  |  |  |  |

#### <a id='all-responses-gspq'></a>All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-srce-pckg-que-200) | OK | Package |  | [schema](#getsrcepckgque-200-schema) |
| [default](#get-srce-pckg-que-def) | | ErrorMessage |  | [schema](#getsrcepckgque-def-schema) |

#### <a id='responses-gspq'></a>Responses


##### <a id="get-srce-pckg-que-200"></a> 200 - Package
Status: OK

###### <a id="getsrcepckgque-200-schema"></a> Schema



[][Package](#package)

##### <a id="get-srce-pckg-que-def"></a> Default Response
ErrorMessage

###### <a id="getsrcepckgque-def-schema"></a> Schema



[ErrorMessage](#error-message)

### <a id="gsv"></a> get source vulnerabilities (*GetSourceVulnerabilities*)

```console
GET /api/sources/{IDorRepoorSha}/vulnerabilities
```

#### <a id='parameters-gsv'></a>Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| IDorRepoorSha | `path` | string | `string` |  | ✓ |  |  |

#### <a id='all-responses-gsv'></a>All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-srce-vul-200) | OK | Vulnerability |  | [schema](#get-srce-vul-200-schema) |
| [default](#get-srce-vul-def) | | ErrorMessage |  | [schema](#get-srce-vul-def-schema) |

#### <a id='responses-gsv'></a>Responses


##### <a id="get-srce-vul-200"></a> 200 - Vulnerability
Status: OK

###### <a id="get-srce-vul-200-schema"></a> Schema



[][Vulnerability](#vulnerability)

##### <a id="get-srce-vul-def"></a> Default Response
ErrorMessage

###### <a id="get-srce-vul-def-schema"></a> Schema



[ErrorMessage](#error-message)

### <a id="gsvq"></a> List vulnerabilities of the given source. (*GetSourceVulnerabilitiesQuery*)

```console
GET /api/sources/vulnerabilities
```

#### <a id='parameters-gsvq'></a>Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| id | `query` | uint64 (formatted integer) | `uint64` |  |  |  |  |
| repo | `query` | string | `string` |  |  |  |  |
| sha | `query` | string | `string` |  |  |  |  |

#### <a id='all-responses-gsvq'></a>All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-source-vulnerabilities-query-200) | OK | Vulnerability |  | [schema](#get-source-vulnerabilities-query-200-schema) |
| [default](#get-source-vulnerabilities-query-default) | | ErrorMessage |  | [schema](#get-source-vulnerabilities-query-default-schema) |

#### <a id='responses-gsvq'></a>Responses


##### <a id="get-srce-vul-query-200"></a> 200 - Vulnerability
Status: OK

###### <a id="getsrcevulque-200-schema"></a> Schema



[][Vulnerability](#vulnerability)

##### <a id="get-srce-vul-que-def"></a> Default Response
ErrorMessage

###### <a id="getsrcevulque-def-schema"></a> Schema



[ErrorMessage](#error-message)

### <a id="get-sourcs"></a> Search for sources by ID, repository, commit sha and/or organization. (*GetSourcs*)

```console
GET /api/sources
```

#### All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-sourcs-200) | OK | Source |  | [schema](#get-sourcs-200-schema) |
| [default](#get-sourcs-default) | | ErrorMessage |  | [schema](#get-sourcs-default-schema) |

#### Responses


##### <a id="get-sourcs-200"></a> 200 - Source
Status: OK

###### <a id="get-sourcs-200-schema"></a> Schema



[][Source](#source)

##### <a id="get-sourcs-default"></a> Default Response
ErrorMessage

###### <a id="get-sourcs-default-schema"></a> Schema



[ErrorMessage](#error-message)

### <a id="gv"></a> Search for vulnerabilities by CVE id. (*GetVulnerabilities*)

```console
GET /api/vulnerabilities
```

#### <a id='parameters-gv'></a>Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| CVEID | `query` | string | `string` |  | ✓ |  |  |

#### <a id='all-responses-gv'></a>All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-vulnerabilities-200) | OK | Vulnerability |  | [schema](#get-vulnerabilities-200-schema) |
| [default](#get-vulnerabilities-default) | | ErrorMessage |  | [schema](#get-vulnerabilities-default-schema) |

#### <a id='responses-gv'></a>Responses


##### <a id="get-vul-200"></a> 200 - Vulnerability
Status: OK

###### <a id="get-vul-200-schema"></a> Schema



[][Vulnerability](#vulnerability)

##### <a id="get-vul-def"></a> Default Response
ErrorMessage

###### <a id="get-vul-def-schema"></a> Schema



[ErrorMessage](#error-message)

### <a id="gvi"></a> List the images that contain the given vulnerability. (*GetVulnerabilityImages*)

```console
GET /api/vulnerabilities/{CVEID}/images
```

#### <a id='parameters-gvi'></a>Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| CVEID | `path` | string | `string` |  | ✓ |  |  |

#### <a id='all-responses-gvi'></a>All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-vulnerability-images-200) | OK | Image |  | [schema](#get-vulnerability-images-200-schema) |
| [default](#get-vulnerability-images-default) | | ErrorMessage |  | [schema](#get-vulnerability-images-default-schema) |

#### <a id='responses-gvi'></a>Responses


##### <a id="get-vul-images-200"></a> 200 - Image
Status: OK

###### <a id="get-vul-images-200-schema"></a> Schema



[][Image](#image)

##### <a id="get-vul-images-def"></a> Default Response
ErrorMessage

###### <a id="get-vul-images-def-schema"></a> Schema



[ErrorMessage](#error-message)

### <a id="gvp"></a> List packages that contain the given CVE id. (*GetVulnerabilityPackages*)

```console
GET /api/vulnerabilities/{CVEID}/packages
```

#### <a id='parameters-gvp'></a>Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| CVEID | `path` | string | `string` |  | ✓ |  |  |

#### <a id='all-responses-gvp'></a>All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-vulnerability-packages-200) | OK | Package |  | [schema](#get-vulnerability-packages-200-schema) |
| [default](#get-vulnerability-packages-default) | | ErrorMessage |  | [schema](#get-vulnerability-packages-default-schema) |

#### <a id='responses-gvp'></a>Responses


##### <a id="get-vul-pckg-200"></a> 200 - Package
Status: OK

###### <a id="get-vul-pckg-200-schema"></a> Schema



[][Package](#package)

##### <a id="get-vul-pckg-def"></a> Default Response
ErrorMessage

###### <a id="get-vul-pckg-def-schema"></a> Schema



[ErrorMessage](#error-message)

### <a id="gvs"></a> List sources that contain the given vulnerability. (*GetVulnerabilitySources*)

```console
GET /api/vulnerabilities/{CVEID}/sources
```

#### <a id='parameters-gvs'></a>Parameters

| Name | Source | Type | Go type | Separator | Required | Default | Description |
|------|--------|------|---------|-----------| :------: |---------|-------------|
| CVEID | `path` | string | `string` |  | ✓ |  |  |

#### <a id='all-responses-gvs'></a>All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#get-vulnerability-sources-200) | OK | Source |  | [schema](#get-vulnerability-sources-200-schema) |
| [default](#get-vulnerability-sources-default) | | ErrorMessage |  | [schema](#get-vulnerability-sources-default-schema) |

#### <a id='responses-gvs'></a>Responses


##### <a id="get-vul-srce-200"></a> 200 - Source
Status: OK

###### <a id="get-vul-srce-200-schema"></a> Schema



[][Source](#source)

##### <a id="get-vul-srce-def"></a> Default Response
ErrorMessage

###### <a id="get-vul-srce-def-schema"></a> Schema



[ErrorMessage](#error-message)

### <a id="health-check"></a> health check (*HealthCheck*)

```console
GET /api/health
```

#### <a id='all-responses-hc'></a>All responses
| Code | Status | Description | Has headers | Schema |
|------|--------|-------------|:-----------:|--------|
| [200](#health-check-200) | OK |  |  | [schema](#health-check-200-schema) |
| [default](#health-check-default) | | ErrorMessage |  | [schema](#health-check-default-schema) |

#### <a id='parameters-hc'></a>Responses


##### <a id="hlth-chck-200"></a> 200
Status: OK

###### <a id="hlth-chck-200-schema"></a> Schema

##### <a id="hlth-chck-def"></a> Default Response
ErrorMessage

###### <a id="hlth-chck-def-schema"></a> Schema



[ErrorMessage](#error-message)

## Models

### <a id="deleted-at"></a> DeletedAt





* composed type [NullTime](#null-time)

### <a id="error-message"></a> ErrorMessage


> ErrorMessage wraps an error message in a struct so responses are properly
marshalled as a JSON object.






**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| Message | string| `string` |  | | in: body | `something went wrong` |



### <a id="image"></a> Image






**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| Digest | string| `string` | ✓ | |  | `9n38274ods897fmay487gsdyfga678wr82` |
| ID | uint64 (formatted integer)| `uint64` |  | |  |  |
| Name | string| `string` | ✓ | |  | `myorg/application` |
| Packages | [][Package](#package)| `[]*Package` |  | |  |  |
| Registry | string| `string` | ✓ | |  | `docker.io` |
| Sources | [][Source](#source)| `[]*Source` |  | |  |  |



### <a id="method-type"></a> MethodType






**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| CreatedAt | date-time (formatted string)| `strfmt.DateTime` |  | |  |  |
| DeletedAt | [DeletedAt](#deleted-at)| `DeletedAt` |  | |  |  |
| ID | uint64 (formatted integer)| `uint64` |  | |  |  |
| Name | string| `string` |  | |  |  |
| Rating | [][Rating](#rating)| `[]*Rating` |  | |  |  |
| UpdatedAt | date-time (formatted string)| `strfmt.DateTime` |  | |  |  |



### <a id="model"></a> Model


> Model a basic GoLang struct which includes the following fields: ID, CreatedAt, UpdatedAt, DeletedAt
It may be embedded into your model, or you may build your model without it
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



### <a id="null-time"></a> NullTime


> NullTime implements the Scanner interface to be used as a scan destination, similar to NullString.






**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| Time | date-time (formatted string)| `strfmt.DateTime` |  | |  |  |
| Valid | boolean| `bool` |  | |  |  |



### <a id="package"></a> Package






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



### <a id="rating"></a> Rating






**Properties**

| Name | Type | Go type | Required | Default | Description | Example |
|------|------|---------|:--------:| ------- |-------------|---------|
| ID | uint64 (formatted integer)| `uint64` |  | |  |  |
| MethodType | [MethodType](#method-type)| `MethodType` |  | |  |  |
| MethodTypeID | uint64 (formatted integer)| `uint64` |  | |  |  |
| Score | double (formatted number)| `float64` |  | |  |  |
| Severity | string| `string` |  | |  |  |
| Vector | string| `string` |  | |  |  |



### <a id="source"></a> Source






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



### <a id="string-array"></a> StringArray




[]string

### <a id="vulnerability"></a> Vulnerability






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
