# tanzu insight triage update

Use this command to create or update a vulnerability analysis.

## <a id='synopsis'></a>Synopsis

Create or update a vulnerability impact analysis. For impact analysis, you must
target a specific OS and application package, vulnerability, and image or source
belonging to a specific Artifact Group. This tool follows CycloneDX's VEX specification
for impact analysis, that includes flag options for each of the CycloneDX's
VEX fields, and support for only their predefined values. Here is a
description of the fields and their supported options:

## Impact Analysis States \-\-state

Declares the current state of an occurrence of a vulnerability, after automated
or manual analysis.

- resolved = the vulnerability is remediated.
- resolved_with_pedigree = the vulnerability is remediated and evidence of
  the changes are provided in the affected components pedigree containing
  verifiable commit history or diffs.
- exploitable = the vulnerability might be directly or indirectly exploitable.
- in_triage = the vulnerability is being investigated.
- false_positive = the vulnerability is not specific to the component or service
  and was falsely identified or associated.
- not_affected = the component or service is not affected by the vulnerability.  

## Impact Analysis Justifications \-\-justification

The rationale of why the impact analysis state was asserted

- code_not_present = the code is removed or tree-shaked.
- code_not_reachable = the vulnerable code is not invoked at runtime.
- requires_configuration = exploitability requires a configurable option to be
  set or unset.
- requires_dependency = exploitability requires a dependency that is not present.
- requires_environment = exploitability requires a certain environment that is
  not present.
- protected_by_compiler = exploitability requires a compiler flag to be
  set or unset.
- protected_at_runtime = exploits are prevented at runtime.
- protected_at_perimeter = attacks are blocked at physical, logical, or network
  perimeter.
- protected_by_mitigating_control = preventative measures have been implemented
  that reduce the likelihood or impact of the vulnerability.

> **Note** `--justification` is required when `--state` is set to `not_affected`

## Impact Analysis Responses \-\-response

A response to the vulnerability by the manufacturer, supplier, or project
responsible for the affected component or service.  More than one response is allowed. Responses are strongly encouraged for vulnerabilities where the
analysis state is exploitable

- can_not_fix
- will_not_fix
- update
- rollback
- workaround_available

> **Note** `--response` is highly encouraged when `--state` is set to `exploitable`; however, CycloneDX specification does not require this.

## Free form comments \-\-comment

Example:

```console
tanzu insight triage update --cveid CVE-ID --pkg-name PKG-NAME --pkg-version PKG-VERSION --img-digest DIGEST --artifact-group-uid UID [--state <state>] [--justification JUSTIFICATION] [--response RESPONSE1, RESPONSE2] [--comment COMMENT] [flags]
```

## <a id='examples'></a>Examples

The following section shows more examples:

```console
insight triage update --cveid CVE-2022-5089 --pkg-name google.golang.org/protobuf --pkg-version 1.23.2 --img-digest sha256:192369123812 --artifact-group-uid AG-00001 --state false_positive
insight triage update --cveid CVE-2022-5089 --pkg-name google.golang.org/protobuf --pkg-version 1.23.2 --img-digest sha256:192369123812 --img-registry internal-hub.docker.io --artifact-group-uid AG-00001 --state not_affected --justification code_not_reachable --comment "The code can't be reached by external users"
insight triage update --cveid CVE-2020-1034 --pkg-name libssl --pkg-version 1.3.0-dev.35 --src-commit 5025112c8b1 --artifact-group-uid AG-00002
insight triage update --cveid CVE-2020-1034 --pkg-name libssl --pkg-version 1.3.0-dev.35 --src-commit 5025112c8b1 --artifact-group-uid AG-00002 --state exploitable --response will_not_fix,update
```

For more information, see the [NIST](https://nvd.nist.gov/) website. 

## <a id='options'></a>Options

The following section shows options:

```console
  -a, --artifact-group-uid string   Artifact group uid
  -t, --comment string              Analysis comment
  -v, --cveid string                CVE id
  -h, --help                        help for update
  -d, --img-digest string           Image digest
      --img-registry string         Image registry
  -j, --justification string        Analysis justification
  -n, --pkg-name string             Package name
  -p, --pkg-version string          Package version
  -r, --response strings            Analysis response
  -c, --src-commit string           Source commit
      --src-org string              Source organization
      --src-repo string             Source repository
  -s, --state string                Analysis state (default "in_triage")
  -y, --yes                         Force update
```

## <a id='options'></a>Options inherited from parent commands

The following section shows options inherited from parent commands:

```console
      --output-format string   specify the response's format, options=[text, api-json] (default "text")
```

## <a id='see-also'></a>See also

* [tanzu insight triage](tanzu_insight_triage.hbs.md)	 - Vulnerability analysis commands