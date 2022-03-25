# API Backend Container Image v1.1.2 CycloneDX file content

The following XML content is from a CycloneDX file related to
[SCA scanning results](sca-scanning-results.md).

```xml
<?xml version="1.0" encoding="UTF-8"?>
<bom xmlns="http://cyclonedx.org/schema/bom/1.2" xmlns:v="http://cyclonedx.org/schema/ext/vulnerability/1.0" version="1" serialNumber="urn:uuid:c74a33f5-fd11-462a-9dc5-e1e7a8a409f6">
  <metadata>
    <timestamp>2022-03-25T10:55:13-04:00</timestamp>
    <tools>
      <tool>
        <vendor>anchore</vendor>
        <name>grype</name>
        <version>0.33.1</version>
      </tool>
    </tools>
    <component type="container">
      <name>dev.registry.tanzu.vmware.com/supply-chain-security-tools/insight-metadata-store-bundle@sha256:a9d3538f42dfb4db2d79dc46c9d0c622da6646778941a75606e62d879a4326f3</name>
      <version>sha256:be76fb50e5696118a088f22081d467085ed5c23bfe365272f414e7f8445ea557</version>
    </component>
  </metadata>
  <components>
    <component type="library">
      <name>base-files</name>
      <version>10.1ubuntu2.11</version>
      <licenses>
        <license>
          <name>GPL</name>
        </license>
      </licenses>
    </component>
    <component type="library">
      <name>ca-certificates</name>
      <version>20210119~18.04.2</version>
      <licenses>
        <license>
          <name>GPL-2</name>
        </license>
        <license>
          <name>GPL-2+</name>
        </license>
        <license>
          <name>MPL-2.0</name>
        </license>
      </licenses>
    </component>
    <component type="library">
      <name>github.com/caarlos0/env/v6</name>
      <version>v6.7.2</version>
    </component>
    <component type="library">
      <name>github.com/go-logr/logr</name>
      <version>v1.2.0</version>
    </component>
    <component type="library">
      <name>github.com/jackc/chunkreader/v2</name>
      <version>v2.0.1</version>
    </component>
    <component type="library">
      <name>github.com/jackc/pgconn</name>
      <version>v1.10.1</version>
    </component>
    <component type="library">
      <name>github.com/jackc/pgio</name>
      <version>v1.0.0</version>
    </component>
    <component type="library">
      <name>github.com/jackc/pgpassfile</name>
      <version>v1.0.0</version>
    </component>
    <component type="library">
      <name>github.com/jackc/pgproto3/v2</name>
      <version>v2.2.0</version>
    </component>
    <component type="library">
      <name>github.com/jackc/pgservicefile</name>
      <version>v0.0.0-20200714003250-2b9c44734f2b</version>
    </component>
    <component type="library">
      <name>github.com/jackc/pgtype</name>
      <version>v1.9.0</version>
    </component>
    <component type="library">
      <name>github.com/jackc/pgx/v4</name>
      <version>v4.14.0</version>
    </component>
    <component type="library">
      <name>github.com/jinzhu/inflection</name>
      <version>v1.0.0</version>
    </component>
    <component type="library">
      <name>github.com/jinzhu/now</name>
      <version>v1.1.3</version>
    </component>
    <component type="library">
      <name>github.com/labstack/echo/v4</name>
      <version>v4.6.1</version>
    </component>
    <component type="library">
      <name>github.com/labstack/gommon</name>
      <version>v0.3.1</version>
    </component>
    <component type="library">
      <name>github.com/lib/pq</name>
      <version>v1.10.4</version>
    </component>
    <component type="library">
      <name>github.com/mattn/go-colorable</name>
      <version>v0.1.12</version>
    </component>
    <component type="library">
      <name>github.com/mattn/go-isatty</name>
      <version>v0.0.14</version>
    </component>
    <component type="library">
      <name>github.com/valyala/bytebufferpool</name>
      <version>v1.0.0</version>
    </component>
    <component type="library">
      <name>github.com/valyala/fasttemplate</name>
      <version>v1.2.1</version>
    </component>
    <component type="library">
      <name>golang.org/x/crypto</name>
      <version>v0.0.0-20211117183948-ae814b36b871</version>
    </component>
    <component type="library">
      <name>golang.org/x/net</name>
      <version>v0.0.0-20211123203042-d83791d6bcd9</version>
    </component>
    <component type="library">
      <name>golang.org/x/sys</name>
      <version>v0.0.0-20211123173158-ef496fb156ab</version>
    </component>
    <component type="library">
      <name>golang.org/x/text</name>
      <version>v0.3.7</version>
    </component>
    <component type="library">
      <name>gorm.io/driver/postgres</name>
      <version>v1.2.2</version>
    </component>
    <component type="library">
      <name>gorm.io/gorm</name>
      <version>v1.22.3</version>
    </component>
    <component type="library">
      <name>k8s.io/klog/v2</name>
      <version>v2.30.0</version>
    </component>
    <component type="library">
      <name>libc6</name>
      <version>2.27-3ubuntu1.5</version>
      <licenses>
        <license>
          <name>GPL-2</name>
        </license>
        <license>
          <name>LGPL-2.1</name>
        </license>
      </licenses>
      <v:vulnerabilities>
        <v:vulnerability ref="urn:uuid:63bbe342-ed71-40b9-a1d8-21d4b1e1fc46">
          <v:id>CVE-2009-5155</v:id>
          <v:source name="ubuntu:18.04">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2009-5155</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>Low</v:severity>
            </v:rating>
          </v:ratings>
          <v:advisories>
            <v:advisory>http://people.ubuntu.com/~ubuntu-security/cve/CVE-2009-5155</v:advisory>
          </v:advisories>
        </v:vulnerability>
        <v:vulnerability ref="urn:uuid:d86a6ab4-5ffc-4482-98c1-c37379def2f5">
          <v:id>CVE-2015-8985</v:id>
          <v:source name="ubuntu:18.04">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-8985</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>Low</v:severity>
            </v:rating>
          </v:ratings>
          <v:advisories>
            <v:advisory>http://people.ubuntu.com/~ubuntu-security/cve/CVE-2015-8985</v:advisory>
          </v:advisories>
        </v:vulnerability>
        <v:vulnerability ref="urn:uuid:291fbcb3-247c-4773-8511-e3ae7bd0ffd1">
          <v:id>CVE-2016-10739</v:id>
          <v:source name="ubuntu:18.04">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2016-10739</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>Low</v:severity>
            </v:rating>
          </v:ratings>
          <v:advisories>
            <v:advisory>http://people.ubuntu.com/~ubuntu-security/cve/CVE-2016-10739</v:advisory>
          </v:advisories>
        </v:vulnerability>
      </v:vulnerabilities>
    </component>
    <component type="library">
      <name>libssl1.1</name>
      <version>1.1.1-1ubuntu2.1~18.04.15</version>
    </component>
    <component type="library">
      <name>netbase</name>
      <version>5.4</version>
      <licenses>
        <license>
          <name>GPL-2</name>
        </license>
      </licenses>
    </component>
    <component type="library">
      <name>openssl</name>
      <version>1.1.1-1ubuntu2.1~18.04.15</version>
    </component>
    <component type="library">
      <name>tzdata</name>
      <version>2021e-0ubuntu0.18.04</version>
    </component>
    <component type="library">
      <name>zlib1g</name>
      <version>1:1.2.11.dfsg-0ubuntu2</version>
    </component>
  </components>
</bom>
```
