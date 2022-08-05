# CycloneDX file content

The following XML content is from a CycloneDX file related to
[SCA scanning results](sca-scanning-results.md).

```xml
<?xml version="1.0" encoding="UTF-8"?>
<bom xmlns="http://cyclonedx.org/schema/bom/1.2" xmlns:v="http://cyclonedx.org/schema/ext/vulnerability/1.0" version="1" serialNumber="urn:uuid:31586811-1212-41f4-9593-7d460ec9d7a4">
  <metadata>
    <timestamp>2022-02-02T16:11:13-05:00</timestamp>
    <tools>
      <tool>
        <vendor>anchore</vendor>
        <name>grype</name>
        <version>0.32.0</version>
      </tool>
    </tools>
    <component type="container">
      <name>harbor-repo.vmware.com/source_insight_tooling/insight-metadata-store:v1.0.2</name>
      <version>sha256:34e1bf649f2699634776b43f082983a8e422a010f1d6482aaf42498783cf6117</version>
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
        <v:vulnerability ref="urn:uuid:318cda01-d363-47da-a2fa-af66fe2c24ed">
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
        <v:vulnerability ref="urn:uuid:0e57dce9-c468-42d0-9905-a79d33e44501">
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
        <v:vulnerability ref="urn:uuid:643ef296-f156-44cf-9e39-84d836d5db11">
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
        <v:vulnerability ref="urn:uuid:07299826-34ff-479a-88e1-ead1f99ec26c">
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
        <v:vulnerability ref="urn:uuid:928cb95e-8c23-45ff-a658-3adafea65fcf">
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
        <v:vulnerability ref="urn:uuid:e6029b4d-ba61-490f-a142-22fc2e503c44">
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
        <v:vulnerability ref="urn:uuid:c9313503-6ad7-48e5-a482-25bb85e68a73">
          <v:id>CVE-2021-33574</v:id>
          <v:source name="ubuntu:18.04">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-33574</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>Low</v:severity>
            </v:rating>
          </v:ratings>
          <v:advisories>
            <v:advisory>http://people.ubuntu.com/~ubuntu-security/cve/CVE-2021-33574</v:advisory>
          </v:advisories>
        </v:vulnerability>
        <v:vulnerability ref="urn:uuid:7c1d0cbe-5664-4ded-bf72-357a8da02813">
          <v:id>CVE-2021-38604</v:id>
          <v:source name="ubuntu:18.04">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-38604</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>Medium</v:severity>
            </v:rating>
          </v:ratings>
          <v:advisories>
            <v:advisory>http://people.ubuntu.com/~ubuntu-security/cve/CVE-2021-38604</v:advisory>
          </v:advisories>
        </v:vulnerability>
        <v:vulnerability ref="urn:uuid:ca1ca2dd-9b60-4758-8da5-ca13d3562083">
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
        <v:vulnerability ref="urn:uuid:1076fae1-4bf2-46ef-a926-aa80030aa485">
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
        <v:vulnerability ref="urn:uuid:2a3baba5-bb57-44d2-a5ca-daa3293a298c">
          <v:id>CVE-2022-23218</v:id>
          <v:source name="ubuntu:18.04">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-23218</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>Medium</v:severity>
            </v:rating>
          </v:ratings>
          <v:advisories>
            <v:advisory>http://people.ubuntu.com/~ubuntu-security/cve/CVE-2022-23218</v:advisory>
          </v:advisories>
        </v:vulnerability>
        <v:vulnerability ref="urn:uuid:efaa6c3e-6006-464c-9771-7d5803e63409">
          <v:id>CVE-2022-23219</v:id>
          <v:source name="ubuntu:18.04">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-23219</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>Medium</v:severity>
            </v:rating>
          </v:ratings>
          <v:advisories>
            <v:advisory>http://people.ubuntu.com/~ubuntu-security/cve/CVE-2022-23219</v:advisory>
          </v:advisories>
        </v:vulnerability>
        <v:vulnerability ref="urn:uuid:7dd0b444-da87-4ec2-b1a7-bf1d3c59cab4">
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
        <v:vulnerability ref="urn:uuid:a5e7cbe3-b969-42aa-89fb-cf3acb87067e">
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
        <v:vulnerability ref="urn:uuid:26f8704c-a43b-4e41-bd6a-e6cdce3e122e">
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
