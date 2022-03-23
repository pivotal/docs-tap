# API Backend Container Image v1.1.1 CycloneDX file content

The following XML content is from a CycloneDX file related to
[SCA scanning results](sca-scanning-results.md).

```xml
<?xml version="1.0" encoding="UTF-8"?>
<bom xmlns="http://cyclonedx.org/schema/bom/1.2" xmlns:v="http://cyclonedx.org/schema/ext/vulnerability/1.0" version="1" serialNumber="urn:uuid:e7e3714a-60c5-4950-b406-b1dc67d25f2c">
  <metadata>
    <timestamp>2022-03-22T14:37:24-04:00</timestamp>
    <tools>
      <tool>
        <vendor>anchore</vendor>
        <name>grype</name>
        <version>0.33.1</version>
      </tool>
    </tools>
    <component type="container">
      <name>dev.registry.tanzu.vmware.com/supply-chain-security-tools/insight-metadata-store-bundle@sha256:da871ec05889df3b016a082596aa128f1c0d4da619f348c7cbf9ac7b9429912a</name>
      <version>sha256:4487f1a762659f6825bbaaa7d6be3fc96186f23da362070a97a6dad149ff5bc4</version>
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
        <v:vulnerability ref="urn:uuid:1b0b14a0-50da-4847-b262-59d00b3bf5fc">
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
        <v:vulnerability ref="urn:uuid:77b41082-9018-4734-ac3b-dffda7d8895b">
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
        <v:vulnerability ref="urn:uuid:3a5aa7a4-1be1-43e4-8341-b460ff993aee">
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
        <v:vulnerability ref="urn:uuid:f95930f5-00ab-4588-85f5-458b4af55e62">
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
        <v:vulnerability ref="urn:uuid:0480b0cd-4523-4901-b4da-f9720429e0ee">
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
        <v:vulnerability ref="urn:uuid:9ab620db-3e7e-49d4-90f8-ebfe252c9c8d">
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
        <v:vulnerability ref="urn:uuid:c02327cf-d247-4f82-b634-27348c42ea9f">
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
        <v:vulnerability ref="urn:uuid:51445aad-5998-44c1-971a-36d91e48a697">
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
        <v:vulnerability ref="urn:uuid:55caf56d-dcd1-4aa4-a89f-b131e7439d43">
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
        <v:vulnerability ref="urn:uuid:41d2b95f-2970-4ccf-a7d1-7d691d3ce3d0">
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
        <v:vulnerability ref="urn:uuid:aa1a2b0b-dbfc-486e-802f-c1a6163bb8e2">
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
        <v:vulnerability ref="urn:uuid:4db54c26-2fa0-4f3c-92fe-b230d461c6ad">
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
        <v:vulnerability ref="urn:uuid:e6954f04-f9dc-4ba8-819c-912a8ca32153">
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
      <v:vulnerabilities>
        <v:vulnerability ref="urn:uuid:c0518913-7282-40cc-9147-ae2daf0abf7b">
          <v:id>CVE-2022-0778</v:id>
          <v:source name="ubuntu:18.04">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-0778</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>High</v:severity>
            </v:rating>
          </v:ratings>
          <v:advisories>
            <v:advisory>http://people.ubuntu.com/~ubuntu-security/cve/CVE-2022-0778</v:advisory>
          </v:advisories>
        </v:vulnerability>
      </v:vulnerabilities>
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
      <v:vulnerabilities>
        <v:vulnerability ref="urn:uuid:5d99aa11-4d7d-4eab-b61e-979914010229">
          <v:id>CVE-2022-0778</v:id>
          <v:source name="ubuntu:18.04">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-0778</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>High</v:severity>
            </v:rating>
          </v:ratings>
          <v:advisories>
            <v:advisory>http://people.ubuntu.com/~ubuntu-security/cve/CVE-2022-0778</v:advisory>
          </v:advisories>
        </v:vulnerability>
      </v:vulnerabilities>
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