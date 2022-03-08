# API Backend Container Image v1.1.0 CycloneDX file content

The following XML content is from a CycloneDX file related to
[SCA scanning results](sca-scanning-results.md).

```xml
<?xml version="1.0" encoding="UTF-8"?>
<bom xmlns="http://cyclonedx.org/schema/bom/1.2" xmlns:v="http://cyclonedx.org/schema/ext/vulnerability/1.0" version="1" serialNumber="urn:uuid:6ade1fa2-020f-45af-9ee8-a36c94283298">
  <metadata>
    <timestamp>2022-03-07T14:27:08-05:00</timestamp>
    <tools>
      <tool>
        <vendor>anchore</vendor>
        <name>grype</name>
        <version>0.33.1</version>
      </tool>
    </tools>
    <component type="container">
      <name>harbor-repo.vmware.com/source_insight_tooling/insight-metadata-store-bundle@sha256:d2890a446279e8271b1b565e670bdddb78b511c7157630fabb3d0eed984b98d9</name>
      <version>sha256:d2890a446279e8271b1b565e670bdddb78b511c7157630fabb3d0eed984b98d9</version>
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
      <version>2.27-3ubuntu1.4</version>
      <licenses>
        <license>
          <name>GPL-2</name>
        </license>
        <license>
          <name>LGPL-2.1</name>
        </license>
      </licenses>
      <v:vulnerabilities>
        <v:vulnerability ref="urn:uuid:2b5075a6-370a-4271-bbbe-49d26107432b">
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
        <v:vulnerability ref="urn:uuid:6f2cd64f-8c22-45af-9946-63f2f9815222">
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
        <v:vulnerability ref="urn:uuid:64306359-dcd0-46dc-80e4-89f3521111f7">
          <v:id>CVE-2016-10228</v:id>
          <v:source name="ubuntu:18.04">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2016-10228</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>Low</v:severity>
            </v:rating>
          </v:ratings>
          <v:advisories>
            <v:advisory>http://people.ubuntu.com/~ubuntu-security/cve/CVE-2016-10228</v:advisory>
          </v:advisories>
        </v:vulnerability>
        <v:vulnerability ref="urn:uuid:e085cf31-e74c-4a23-ab0b-85e1ffda2504">
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
        <v:vulnerability ref="urn:uuid:270d4b0c-04e3-4f3e-9ba5-72796c19d927">
          <v:id>CVE-2019-25013</v:id>
          <v:source name="ubuntu:18.04">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2019-25013</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>Low</v:severity>
            </v:rating>
          </v:ratings>
          <v:advisories>
            <v:advisory>http://people.ubuntu.com/~ubuntu-security/cve/CVE-2019-25013</v:advisory>
          </v:advisories>
        </v:vulnerability>
        <v:vulnerability ref="urn:uuid:3c6a4ab6-c9ea-45d2-a045-18e8dda0f032">
          <v:id>CVE-2020-27618</v:id>
          <v:source name="ubuntu:18.04">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2020-27618</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>Low</v:severity>
            </v:rating>
          </v:ratings>
          <v:advisories>
            <v:advisory>http://people.ubuntu.com/~ubuntu-security/cve/CVE-2020-27618</v:advisory>
          </v:advisories>
        </v:vulnerability>
        <v:vulnerability ref="urn:uuid:5d4b7c7e-8ca8-4d11-91df-59b5862f88e9">
          <v:id>CVE-2020-29562</v:id>
          <v:source name="ubuntu:18.04">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2020-29562</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>Low</v:severity>
            </v:rating>
          </v:ratings>
          <v:advisories>
            <v:advisory>http://people.ubuntu.com/~ubuntu-security/cve/CVE-2020-29562</v:advisory>
          </v:advisories>
        </v:vulnerability>
        <v:vulnerability ref="urn:uuid:94d9bf98-55a5-403c-b47c-006fd9b566b6">
          <v:id>CVE-2020-6096</v:id>
          <v:source name="ubuntu:18.04">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2020-6096</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>Low</v:severity>
            </v:rating>
          </v:ratings>
          <v:advisories>
            <v:advisory>http://people.ubuntu.com/~ubuntu-security/cve/CVE-2020-6096</v:advisory>
          </v:advisories>
        </v:vulnerability>
        <v:vulnerability ref="urn:uuid:5c352c7e-97f8-4168-94e1-606a05ac0594">
          <v:id>CVE-2021-3326</v:id>
          <v:source name="ubuntu:18.04">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-3326</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>Low</v:severity>
            </v:rating>
          </v:ratings>
          <v:advisories>
            <v:advisory>http://people.ubuntu.com/~ubuntu-security/cve/CVE-2021-3326</v:advisory>
          </v:advisories>
        </v:vulnerability>
        <v:vulnerability ref="urn:uuid:778e162e-6e2b-4a2e-bd87-beddf729c55c">
          <v:id>CVE-2021-35942</v:id>
          <v:source name="ubuntu:18.04">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-35942</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>Low</v:severity>
            </v:rating>
          </v:ratings>
          <v:advisories>
            <v:advisory>http://people.ubuntu.com/~ubuntu-security/cve/CVE-2021-35942</v:advisory>
          </v:advisories>
        </v:vulnerability>
        <v:vulnerability ref="urn:uuid:aa8715a6-d2d9-45b0-a34a-f4610c710124">
          <v:id>CVE-2021-3999</v:id>
          <v:source name="ubuntu:18.04">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-3999</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>Medium</v:severity>
            </v:rating>
          </v:ratings>
          <v:advisories>
            <v:advisory>http://people.ubuntu.com/~ubuntu-security/cve/CVE-2021-3999</v:advisory>
          </v:advisories>
        </v:vulnerability>
        <v:vulnerability ref="urn:uuid:5f907049-0ad9-406a-b4af-e91e391d1d6a">
          <v:id>CVE-2022-23218</v:id>
          <v:source name="ubuntu:18.04">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-23218</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>Low</v:severity>
            </v:rating>
          </v:ratings>
          <v:advisories>
            <v:advisory>http://people.ubuntu.com/~ubuntu-security/cve/CVE-2022-23218</v:advisory>
          </v:advisories>
        </v:vulnerability>
        <v:vulnerability ref="urn:uuid:2a5f547c-7634-4f4a-8996-c8e56f9b50fa">
          <v:id>CVE-2022-23219</v:id>
          <v:source name="ubuntu:18.04">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-23219</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>Low</v:severity>
            </v:rating>
          </v:ratings>
          <v:advisories>
            <v:advisory>http://people.ubuntu.com/~ubuntu-security/cve/CVE-2022-23219</v:advisory>
          </v:advisories>
        </v:vulnerability>
      </v:vulnerabilities>
    </component>
    <component type="library">
      <name>libssl1.1</name>
      <version>1.1.1-1ubuntu2.1~18.04.13</version>
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
      <version>1.1.1-1ubuntu2.1~18.04.13</version>
    </component>
    <component type="library">
      <name>tzdata</name>
      <version>2021a-2ubuntu0.18.04</version>
    </component>
    <component type="library">
      <name>zlib1g</name>
      <version>1:1.2.11.dfsg-0ubuntu2</version>
    </component>
  </components>
</bom>
```
