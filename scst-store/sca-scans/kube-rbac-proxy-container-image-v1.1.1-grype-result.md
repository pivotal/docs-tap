# Kube RBAC Proxy Container Image v1.1.1 CycloneDX file content

The following XML content is from a CycloneDX file related to
[SCA scanning results](sca-scanning-results.md).

```xml
<?xml version="1.0" encoding="UTF-8"?>
<bom xmlns="http://cyclonedx.org/schema/bom/1.2" xmlns:v="http://cyclonedx.org/schema/ext/vulnerability/1.0" version="1" serialNumber="urn:uuid:9e6ab601-25f1-4e17-823e-52fb18102809">
  <metadata>
    <timestamp>2022-03-22T14:43:16-04:00</timestamp>
    <tools>
      <tool>
        <vendor>anchore</vendor>
        <name>grype</name>
        <version>0.33.1</version>
      </tool>
    </tools>
    <component type="container">
      <name>dev.registry.tanzu.vmware.com/supply-chain-security-tools/insight-metadata-store-bundle@sha256:a4f6c39b17f2ba68366c6d4e139ed18ede2ad9f3f9d5bf7477bdcbef73b43e54</name>
      <version>sha256:914d8ae017125655bb8b98822d4c4fd1f64e25a2ed0433cd0cc222ea95872d5e</version>
    </component>
  </metadata>
  <components>
    <component type="library">
      <name>base-files</name>
      <version>10.3+deb10u10</version>
      <licenses>
        <license>
          <name>GPL</name>
        </license>
      </licenses>
    </component>
    <component type="library">
      <name>github.com/PuerkitoBio/purell</name>
      <version>v1.1.1</version>
    </component>
    <component type="library">
      <name>github.com/PuerkitoBio/urlesc</name>
      <version>v0.0.0-20170810143723-de5bf2ad4578</version>
    </component>
    <component type="library">
      <name>github.com/beorn7/perks</name>
      <version>v1.0.1</version>
    </component>
    <component type="library">
      <name>github.com/blang/semver</name>
      <version>v3.5.0+incompatible</version>
    </component>
    <component type="library">
      <name>github.com/cespare/xxhash/v2</name>
      <version>v2.1.1</version>
    </component>
    <component type="library">
      <name>github.com/coreos/go-oidc</name>
      <version>v2.1.0+incompatible</version>
    </component>
    <component type="library">
      <name>github.com/davecgh/go-spew</name>
      <version>v1.1.1</version>
    </component>
    <component type="library">
      <name>github.com/ghodss/yaml</name>
      <version>v1.0.0</version>
    </component>
    <component type="library">
      <name>github.com/go-logr/logr</name>
      <version>v0.2.0</version>
    </component>
    <component type="library">
      <name>github.com/go-openapi/jsonpointer</name>
      <version>v0.19.3</version>
    </component>
    <component type="library">
      <name>github.com/go-openapi/jsonreference</name>
      <version>v0.19.3</version>
    </component>
    <component type="library">
      <name>github.com/go-openapi/spec</name>
      <version>v0.19.3</version>
    </component>
    <component type="library">
      <name>github.com/go-openapi/swag</name>
      <version>v0.19.5</version>
    </component>
    <component type="library">
      <name>github.com/gogo/protobuf</name>
      <version>v1.3.1</version>
    </component>
    <component type="library">
      <name>github.com/golang/groupcache</name>
      <version>v0.0.0-20191227052852-215e87163ea7</version>
    </component>
    <component type="library">
      <name>github.com/golang/protobuf</name>
      <version>v1.4.2</version>
    </component>
    <component type="library">
      <name>github.com/google/go-cmp</name>
      <version>v0.5.4</version>
    </component>
    <component type="library">
      <name>github.com/google/gofuzz</name>
      <version>v1.1.0</version>
    </component>
    <component type="library">
      <name>github.com/google/uuid</name>
      <version>v1.1.1</version>
    </component>
    <component type="library">
      <name>github.com/googleapis/gnostic</name>
      <version>v0.4.1</version>
    </component>
    <component type="library">
      <name>github.com/hashicorp/golang-lru</name>
      <version>v0.5.1</version>
    </component>
    <component type="library">
      <name>github.com/imdario/mergo</name>
      <version>v0.3.5</version>
    </component>
    <component type="library">
      <name>github.com/json-iterator/go</name>
      <version>v1.1.10</version>
    </component>
    <component type="library">
      <name>github.com/mailru/easyjson</name>
      <version>v0.7.0</version>
    </component>
    <component type="library">
      <name>github.com/matttproud/golang_protobuf_extensions</name>
      <version>v1.0.2-0.20181231171920-c182affec369</version>
    </component>
    <component type="library">
      <name>github.com/modern-go/concurrent</name>
      <version>v0.0.0-20180306012644-bacd9c7ef1dd</version>
    </component>
    <component type="library">
      <name>github.com/modern-go/reflect2</name>
      <version>v1.0.1</version>
    </component>
    <component type="library">
      <name>github.com/oklog/run</name>
      <version>v1.0.0</version>
    </component>
    <component type="library">
      <name>github.com/pquerna/cachecontrol</name>
      <version>v0.0.0-20171018203845-0dec1b30a021</version>
    </component>
    <component type="library">
      <name>github.com/prometheus/client_golang</name>
      <version>v1.7.1</version>
      <v:vulnerabilities>
        <v:vulnerability ref="urn:uuid:0df14134-aa04-46f5-a999-e85994540ac3">
          <v:id>CVE-2022-21698</v:id>
          <v:source name="nvd">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-21698</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>High</v:severity>
            </v:rating>
            <v:rating>
              <v:score>
                <v:base>5</v:base>
                <v:impact>2.9</v:impact>
                <v:exploitability>10</v:exploitability>
              </v:score>
              <v:method>CVSSv2</v:method>
              <v:vector>AV:N/AC:L/Au:N/C:N/I:N/A:P</v:vector>
            </v:rating>
            <v:rating>
              <v:score>
                <v:base>7.5</v:base>
                <v:impact>3.6</v:impact>
                <v:exploitability>3.9</v:exploitability>
              </v:score>
              <v:method>CVSSv3</v:method>
              <v:vector>CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H</v:vector>
            </v:rating>
          </v:ratings>
          <v:description>client_golang is the instrumentation library for Go applications in Prometheus, and the promhttp package in client_golang provides tooling around HTTP servers and clients. In client_golang prior to version 1.11.1, HTTP server is susceptible to a Denial of Service through unbounded cardinality, and potential memory exhaustion, when handling requests with non-standard HTTP methods. In order to be affected, an instrumented software must use any of `promhttp.InstrumentHandler*` middleware except `RequestsInFlight`; not filter any specific methods (e.g GET) before middleware; pass metric with `method` label name to our middleware; and not have any firewall/LB/proxy that filters away requests with unknown `method`. client_golang version 1.11.1 contains a patch for this issue. Several workarounds are available, including removing the `method` label name from counter/gauge used in the InstrumentHandler; turning off affected promhttp handlers; adding custom middleware before promhttp handler that will sanitize the request method given by Go http.Request; and using a reverse proxy or web application firewall, configured to only allow a limited set of methods.</v:description>
          <v:advisories>
            <v:advisory>https://github.com/prometheus/client_golang/pull/962</v:advisory>
            <v:advisory>https://github.com/prometheus/client_golang/releases/tag/v1.11.1</v:advisory>
            <v:advisory>https://github.com/prometheus/client_golang/security/advisories/GHSA-cg3q-j54f-5p7p</v:advisory>
            <v:advisory>https://github.com/prometheus/client_golang/pull/987</v:advisory>
          </v:advisories>
        </v:vulnerability>
      </v:vulnerabilities>
    </component>
    <component type="library">
      <name>github.com/prometheus/client_model</name>
      <version>v0.2.0</version>
    </component>
    <component type="library">
      <name>github.com/prometheus/common</name>
      <version>v0.10.0</version>
    </component>
    <component type="library">
      <name>github.com/prometheus/procfs</name>
      <version>v0.1.3</version>
    </component>
    <component type="library">
      <name>github.com/spf13/pflag</name>
      <version>v1.0.5</version>
    </component>
    <component type="library">
      <name>golang.org/x/crypto</name>
      <version>v0.0.0-20200622213623-75b288015ac9</version>
    </component>
    <component type="library">
      <name>golang.org/x/net</name>
      <version>v0.0.0-20200707034311-ab3426394381</version>
    </component>
    <component type="library">
      <name>golang.org/x/oauth2</name>
      <version>v0.0.0-20191202225959-858c2ad4c8b6</version>
    </component>
    <component type="library">
      <name>golang.org/x/sync</name>
      <version>v0.0.0-20190911185100-cd5d95a43a6e</version>
    </component>
    <component type="library">
      <name>golang.org/x/sys</name>
      <version>v0.0.0-20200622214017-ed371f2e16b4</version>
    </component>
    <component type="library">
      <name>golang.org/x/text</name>
      <version>v0.3.3</version>
    </component>
    <component type="library">
      <name>golang.org/x/time</name>
      <version>v0.0.0-20191024005414-555d28b269f0</version>
    </component>
    <component type="library">
      <name>google.golang.org/genproto</name>
      <version>v0.0.0-20200526211855-cb27e3aa2013</version>
    </component>
    <component type="library">
      <name>google.golang.org/grpc</name>
      <version>v1.27.0</version>
    </component>
    <component type="library">
      <name>google.golang.org/protobuf</name>
      <version>v1.24.0</version>
      <v:vulnerabilities>
        <v:vulnerability ref="urn:uuid:8629b7fa-db55-4754-92ee-e295f6131017">
          <v:id>CVE-2015-5237</v:id>
          <v:source name="nvd">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-5237</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>High</v:severity>
            </v:rating>
            <v:rating>
              <v:score>
                <v:base>6.5</v:base>
                <v:impact>6.4</v:impact>
                <v:exploitability>8</v:exploitability>
              </v:score>
              <v:method>CVSSv2</v:method>
              <v:vector>AV:N/AC:L/Au:S/C:P/I:P/A:P</v:vector>
            </v:rating>
            <v:rating>
              <v:score>
                <v:base>8.8</v:base>
                <v:impact>5.9</v:impact>
                <v:exploitability>2.8</v:exploitability>
              </v:score>
              <v:method>CVSSv3</v:method>
              <v:vector>CVSS:3.1/AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H</v:vector>
            </v:rating>
          </v:ratings>
          <v:description>protobuf allows remote authenticated attackers to cause a heap-based buffer overflow.</v:description>
          <v:advisories>
            <v:advisory>https://github.com/google/protobuf/issues/760</v:advisory>
            <v:advisory>https://bugzilla.redhat.com/show_bug.cgi?id=1256426</v:advisory>
            <v:advisory>http://www.openwall.com/lists/oss-security/2015/08/27/2</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/b0656d359c7d40ec9f39c8cc61bca66802ef9a2a12ee199f5b0c1442@%3Cdev.drill.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/519eb0fd45642dcecd9ff74cb3e71c20a4753f7d82e2f07864b5108f@%3Cdev.drill.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/ra28fed69eef3a71e5fe5daea001d0456b05b102044237330ec5c7c82@%3Ccommits.pulsar.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/f9bc3e55f4e28d1dcd1a69aae6d53e609a758e34d2869b4d798e13cc@%3Cissues.drill.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/r17dc6f394429f6bffb5e4c66555d93c2e9923cbbdc5a93db9a56c1c7@%3Ccommits.pulsar.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/r42e47994734cd1980ef3e204a40555336e10cc80096927aca2f37d90@%3Ccommits.pulsar.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/re6d04a214424a97ea59c62190d79316edf311a0a6346524dfef3b940@%3Ccommits.pulsar.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/r1263fa5b51e4ec3cb8f09ff40e4747428c71198e9bee93349ec96a3c@%3Ccommits.pulsar.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/r42ef6acfb0d86a2df0c2390702ecbe97d2104a331560f2790d17ca69@%3Ccommits.pulsar.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/rb71dac1d9dd4e8a8ae3dbc033aeae514eda9be1263c1df3b42a530a2@%3Ccommits.pulsar.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/r320dc858da88846ba00bb077bcca2cdf75b7dde0f6eb3a3d60dba6a1@%3Ccommits.pulsar.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/r85c9a764b573c786224688cc906c27e28343e18f5b33387f94cae90f@%3Ccommits.pulsar.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/r02e39d7beb32eebcdbb4b516e95f67d71c90d5d462b26f4078d21eeb@%3Cuser.flink.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/r02e39d7beb32eebcdbb4b516e95f67d71c90d5d462b26f4078d21eeb@%3Cdev.flink.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/r5e52caf41dc49df55b4ee80758356fe1ff2a88179ff24c685de7c28d@%3Ccommits.pulsar.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/rf7539287c90be979bac94af9aaba34118fbf968864944b4871af48dd@%3Ccommits.pulsar.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/r1d274d647b3c2060df9be21eade4ce56d3a59998cf19ac72662dd994@%3Ccommits.pulsar.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/r4886108206d4c535db9b20c813fe4723d4fe6a91b9278382af8b9d08@%3Cissues.spark.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/rb40dc9d63a5331bce8e80865b7fa3af9dd31e16555affd697b6f3526@%3Cissues.spark.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/r5741f4dbdd129dbb9885f5fb170dc1b24a06b9313bedef5e67fded94@%3Cissues.spark.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/r14fa8d38d5757254f1a2e112270c996711d514de2e3b01c93d397ab4@%3Cissues.spark.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/r2ea33ce5591a9cb9ed52750b6ab42ab658f529a7028c3166ba93c7d5@%3Ccommon-issues.hadoop.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/r00d9ab1fc0f1daf14cd4386564dd84f7889404438d81462c86dfa836@%3Ccommon-dev.hadoop.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/r764fc66435ee4d185d359c28c0887d3e5866d7292a8d5598d9e7cbc4@%3Ccommon-issues.hadoop.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/r0ca83171c4898dc92b86fa6f484a7be1dc96206765f4d01dce0f1b28@%3Ccommon-issues.hadoop.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/r00097d0b5b6164ea428554007121d5dc1f88ba2af7b9e977a10572cd@%3Cdev.hbase.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/rd64381fb8f92d640c1975dc50dcdf1b8512e02a2a7b20292d3565cae@%3Cissues.hbase.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/r4ef574a5621b0e670a3ce641e9922543e34f22bf4c9ee9584aa67fcf@%3Cissues.hbase.apache.org%3E</v:advisory>
            <v:advisory>https://lists.apache.org/thread.html/r7fed8dd9bee494094e7011cf3c2ab75bd8754ea314c6734688c42932@%3Ccommon-issues.hadoop.apache.org%3E</v:advisory>
          </v:advisories>
        </v:vulnerability>
        <v:vulnerability ref="urn:uuid:93fb4bdb-96cc-41ec-b024-9e258b8da7c7">
          <v:id>CVE-2021-22570</v:id>
          <v:source name="nvd">
            <v:url>http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-22570</v:url>
          </v:source>
          <v:ratings>
            <v:rating>
              <v:severity>High</v:severity>
            </v:rating>
            <v:rating>
              <v:score>
                <v:base>5</v:base>
                <v:impact>2.9</v:impact>
                <v:exploitability>10</v:exploitability>
              </v:score>
              <v:method>CVSSv2</v:method>
              <v:vector>AV:N/AC:L/Au:N/C:N/I:N/A:P</v:vector>
            </v:rating>
            <v:rating>
              <v:score>
                <v:base>7.5</v:base>
                <v:impact>3.6</v:impact>
                <v:exploitability>3.9</v:exploitability>
              </v:score>
              <v:method>CVSSv3</v:method>
              <v:vector>CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:H</v:vector>
            </v:rating>
          </v:ratings>
          <v:description>Nullptr dereference when a null char is present in a proto symbol. The symbol is parsed incorrectly, leading to an unchecked call into the proto file&#39;s name during generation of the resulting error message. Since the symbol is incorrectly parsed, the file is nullptr. We recommend upgrading to version 3.15.0 or greater.</v:description>
          <v:advisories>
            <v:advisory>https://github.com/protocolbuffers/protobuf/releases/tag/v3.15.0</v:advisory>
            <v:advisory>https://lists.fedoraproject.org/archives/list/package-announce@lists.fedoraproject.org/message/IFX6KPNOFHYD6L4XES5PCM3QNSKZBOTQ/</v:advisory>
            <v:advisory>https://lists.fedoraproject.org/archives/list/package-announce@lists.fedoraproject.org/message/3DVUZPALAQ34TQP6KFNLM4IZS6B32XSA/</v:advisory>
            <v:advisory>https://lists.fedoraproject.org/archives/list/package-announce@lists.fedoraproject.org/message/BTRGBRC5KGCA4SK5MUNLPYJRAGXMBIYY/</v:advisory>
            <v:advisory>https://lists.fedoraproject.org/archives/list/package-announce@lists.fedoraproject.org/message/NVTWVQRB5OCCTMKEQFY5MYED3DXDVSLP/</v:advisory>
            <v:advisory>https://lists.fedoraproject.org/archives/list/package-announce@lists.fedoraproject.org/message/5PAGL5M2KGYPN3VEQCRJJE6NA7D5YG5X/</v:advisory>
            <v:advisory>https://lists.fedoraproject.org/archives/list/package-announce@lists.fedoraproject.org/message/KQJB6ZPRLKV6WCMX2PRRRQBFAOXFBK6B/</v:advisory>
          </v:advisories>
        </v:vulnerability>
      </v:vulnerabilities>
    </component>
    <component type="library">
      <name>gopkg.in/inf.v0</name>
      <version>v0.9.1</version>
    </component>
    <component type="library">
      <name>gopkg.in/square/go-jose.v2</name>
      <version>v2.2.2</version>
    </component>
    <component type="library">
      <name>gopkg.in/yaml.v2</name>
      <version>v2.2.8</version>
    </component>
    <component type="library">
      <name>k8s.io/api</name>
      <version>v0.19.2</version>
    </component>
    <component type="library">
      <name>k8s.io/apimachinery</name>
      <version>v0.19.2</version>
    </component>
    <component type="library">
      <name>k8s.io/apiserver</name>
      <version>v0.19.2</version>
    </component>
    <component type="library">
      <name>k8s.io/client-go</name>
      <version>v0.19.2</version>
    </component>
    <component type="library">
      <name>k8s.io/component-base</name>
      <version>v0.19.2</version>
    </component>
    <component type="library">
      <name>k8s.io/klog/v2</name>
      <version>v2.3.0</version>
    </component>
    <component type="library">
      <name>k8s.io/kube-openapi</name>
      <version>v0.0.0-20200805222855-6aeccd4b50c6</version>
    </component>
    <component type="library">
      <name>k8s.io/utils</name>
      <version>v0.0.0-20200729134348-d5654de09c73</version>
    </component>
    <component type="library">
      <name>netbase</name>
      <version>5.6</version>
      <licenses>
        <license>
          <name>GPL-2</name>
        </license>
      </licenses>
    </component>
    <component type="library">
      <name>sigs.k8s.io/apiserver-network-proxy/konnectivity-client</name>
      <version>v0.0.9</version>
    </component>
    <component type="library">
      <name>sigs.k8s.io/structured-merge-diff/v4</name>
      <version>v4.0.1</version>
    </component>
    <component type="library">
      <name>sigs.k8s.io/yaml</name>
      <version>v1.2.0</version>
    </component>
    <component type="library">
      <name>tzdata</name>
      <version>2021a-0+deb10u1</version>
    </component>
  </components>
</bom>
```