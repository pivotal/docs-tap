# Tanzu Service CLI Plug-In

The `tanzu service` CLI plug-in is primarily intended for use by application operators and application developers.
It aims to offer a services experience that is consistent with the other Tanzu CLI commands.
Its main application is for the creation of claims.

The reference material in this topic is split by sub-command.

## <a id="stk-cli-class"></a> tanzu service class

Classes (sometimes referred to as "instance classes" or "service instance classes") are a means to discover and describe
groupings of similar service instances. In that regard they can be<!--฿ Consider switching to active voice. ฿--> considered analogous to the concept of storage
classes in Kubernetes.

By listing the available classes on a cluster (see 'tanzu service class list -h'), you can discover the range of
services on offer.

You can create a claim for a service instance of a particular class using the 'tanzu<!--฿ The brand is |Tanzu|. ฿--> service class-claim create'<!--฿ Double quotation marks are preferred in US English. ฿-->
command.

Getting a class allows you to see more detailed information about the class, including, where available, a list of
parameters which can be<!--฿ Consider switching to active voice. ฿--> passed via<!--฿ |through|, |using| and |by means of| are preferred. ฿--> the '--parameter'<!--฿ Double quotation marks are preferred in US English. ฿--> flag to the 'tanzu<!--฿ The brand is |Tanzu|. ฿--> service class-claim create'<!--฿ Double quotation marks are preferred in US English. ฿--> command.

### <a id="stk-cli-class-list"></a> tanzu service class list

List the available classes.

```console
List the available classes

Usage:
  tanzu services classes list [flags]

Examples:
  tanzu services classes list

Flags:
  -h, --help   help for list

Global Flags:
      --context string      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig string   kubeconfig file (default is /home/eking/.kube/config)
      --no-color            turn off color output in terminals
```

### <a id="stk-cli-get"></a> tanzu service class get

Get detailed information for a class.

The output includes more detailed information about the class, including, where available, a list of
parameters which can be<!--฿ Consider switching to active voice. ฿--> passed via<!--฿ |through|, |using| and |by means of| are preferred. ฿--> the '--parameter'<!--฿ Double quotation marks are preferred in US English. ฿--> flag to the 'tanzu<!--฿ The brand is |Tanzu|. ฿--> service class-claim create'<!--฿ Double quotation marks are preferred in US English. ฿--> command.

```console
Usage:
  tanzu services classes get [name] [flags]

Examples:
  tanzu services classes get rmq-small

Flags:
  -h, --help   help for get

Global Flags:
      --context string      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig string   kubeconfig file (default is /home/eking/.kube/config)
      --no-color            turn off color output in terminals
```

## <a id="stk-cli-class-claim"></a> tanzu service class-claim

Class claims allow you to create claims by simply<!--฿ Avoid suggesting an instruction is |simple| or |easy|. ฿--> referring to a class.

As such, they can be<!--฿ Consider switching to active voice. ฿--> considered an alternative approach to resource claims, which require you to refer to<!--฿ If telling the reader to read something else, use |see|. ฿--> a specific
resource by name, namespace, kind and API group/version.

Generally it is advisable to work with class claims wherever possible as they are easier to create and are considered
more portable across multiple clusters.

### <a id="stk-cli-class-claim-create"></a> tanzu service class-claim create

Create a claim by referring to a class.

Claims for service instances can be<!--฿ Consider switching to active voice. ฿--> bound to application workloads.

Note that<!--฿ If this is really a note, use note formatting. ฿--> claims are mutually exclusive, meaning that once a service instance has been<!--฿ Consider changing to |is| or |has| or rewrite for active voice. ฿--> successfully<!--฿ Redundant word? ฿--> claimed,
no other claim can then claim it. This prevents unauthorised application workloads from accessing a service instance
that your application workload(s)<!--฿ Do not combine a singular and a plural. Maybe write |one or more| instead. ฿--> are using.

Parameters can be<!--฿ Consider switching to active voice. ฿--> passed in with the '--parameter key.subKey=value'<!--฿ Double quotation marks are preferred in US English. ฿--> flag. This flag can be<!--฿ Consider switching to active voice. ฿--> provided multiple times.
The value must be valid yaml<!--฿ |YAML| is preferred. ฿-->. Available parameters for a class can be<!--฿ Consider switching to active voice. ฿--> found with 'tanzu<!--฿ The brand is |Tanzu|. ฿--> services class get <class-name>'<!--฿ Double quotation marks are preferred in US English. ฿-->.

```console
Usage:
  tanzu services class-claim create [name] [flags]

Examples:
  tanzu services class-claim create psql-claim-1 --class postgres
  tanzu services class-claim create rmq-claim-1 --class rmq --parameter durable=true --parameter replicas=3

Flags:
      --class string            the name of a class to claim an instance of
  -h, --help                    help for create
  -n, --namespace name          kubernetes namespace (defaulted from kube config)
  -p, --parameter stringArray   claim parameters

Global Flags:
      --context string      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig string   kubeconfig file (default is /home/eking/.kube/config)
      --no-color            turn off color output in terminals
```

### <a id="stk-cli-class-claim get"></a> tanzu service class-claim get

Get detailed information for a class claim.

The output includes the name of the class the claim was created for as well as<!--฿ |and| is preferred. ฿--> the claim ref. Claim refs can be<!--฿ Consider switching to active voice. ฿--> passed
to the '--service-ref'<!--฿ Double quotation marks are preferred in US English. ฿--> flag of the 'tanzu<!--฿ The brand is |Tanzu|. ฿--> apps workload create'<!--฿ Double quotation marks are preferred in US English. ฿--> command in order to<!--฿ |to| is preferred. ฿--> bind workloads to claimed service
instances.

```console
Usage:
  tanzu services class-claim get [flags]

Examples:
  tanzu services class-claim get psql-claim-1
  tanzu services class-claim get psql-claim-1 --namespace app-ns-1

Flags:
  -h, --help             help for get
  -n, --namespace name   kubernetes namespace (defaulted from kube config)

Global Flags:
      --context string      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig string   kubeconfig file (default is /home/eking/.kube/config)
      --no-color            turn off color output in terminals
```

### <a id="stk-cli-class-claim-delete"></a> tanzu service class-claim delete

Delete a class claim.

You will<!--฿ Avoid |will|: present tense is preferred. ฿--> be prompted to confirm the deletion unless the --yes flag is passed.

Before deleting a claim it is important to<!--฿ Maybe re-phrase as an imperative. ฿--> be aware<!--฿ To avoid anthropomorphism, use |detects|. ฿--> of the consequences of doing so. The act of<!--฿ Redundant? ฿--> creating a claim
signals a desire<!--฿ |want| is preferred. ฿--> for a service instance, which is usually done for the purpose of binding it to one or more
application workloads. Deleting a claim signals that you no longer need the claimed service instance, at which point
it may<!--฿ |can| usually works better. Use |might| to convey possibility. ฿--> be possible for other claims created by other actors to claim the service instance you once claimed.

```console
Usage:
  tanzu services class-claim delete [flags]

Examples:
  tanzu services class-claim delete psql-claim-1
  tanzu services class-claim delete psql-claim-1 --yes
  tanzu services class-claim delete psql-claim-1 --namespace app-ns-1

Flags:
  -h, --help             help for delete
  -n, --namespace name   kubernetes namespace (defaulted from kube config)
  -y, --yes              skip the confirmation of the deletion

Global Flags:
      --context string      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig string   kubeconfig file (default is /home/eking/.kube/config)
      --no-color            turn off color output in terminals
```

### <a id="stk-cli-class-claim-list"></a>tanzu service class-claim list

List class claims in a namespace or across all namespaces.

If run with the '-o wide'<!--฿ Double quotation marks are preferred in US English. ฿--> flag then claim refs for each of the claims are printed. Claim refs can be<!--฿ Consider switching to active voice. ฿--> passed to the
'--service-ref'<!--฿ Double quotation marks are preferred in US English. ฿--> flag of the 'tanzu<!--฿ The brand is |Tanzu|. ฿--> apps workload create'<!--฿ Double quotation marks are preferred in US English. ฿--> command in order to<!--฿ |to| is preferred. ฿--> bind workloads to claimed service
instances.

```console
Usage:
  tanzu services class-claim list [flags]

Examples:
  tanzu services class-claim list
  tanzu services class-claim list --class postgres
  tanzu services class-claim list -o wide
  tanzu services class-claim list -n app-ns-1 -o wide

Flags:
  -A, --all-namespaces   list class claims across all namespaces
  -c, --class string     list class claims referencing this class
  -h, --help             help for list
  -n, --namespace name   kubernetes namespace (defaulted from kube config)
  -o, --output string    output format (currently the only available option is 'wide')

Global Flags:
      --context string      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig string   kubeconfig file (default is /home/eking/.kube/config)
      --no-color            turn off color output in terminals
```

## <a id="stk-cli-resource-claim"></a> tanzu service resource-claim

Resource claims allow you to create claims by referring to a specific resource by name, namespace, kind and API
group/version.

As such, they can be<!--฿ Consider switching to active voice. ฿--> considered an alternative approach to class claims, which simply<!--฿ Avoid suggesting an instruction is |simple| or |easy|. ฿--> require you to refer to<!--฿ If telling the reader to read something else, use |see|. ฿--> a class.

Generally it is advisable to work with class claims wherever possible as they are easier to create and are considered
more portable across multiple clusters.

### <a id="stk-cli-resource-claim-create"></a>tanzu service resource-claim create

Create a claim for a specific resource.

It is common to create claims for resources which can then be bound to application workloads via<!--฿ |through|, |using| and |by means of| are preferred. ฿--> the claim.

This approach to creating claims differs to that of class claims, in which the system ultimately finds and supplies a
claimable resource for you. With this in mind, you only really need to<!--฿ |must| is preferred or, better, rephrase as an imperative. ฿--> work with resource claims if you want full
control over which resource gets<!--฿ There is likely a more precise and formal word to use here than |gets|. ฿--> claimed. If not, it is simpler and more convenient to work with class claims
(see 'tanzu service class-claim --help').

Note that<!--฿ If this is really a note, use note formatting. ฿--> claims are mutually exclusive by nature, meaning that once a resource has been<!--฿ Consider changing to |is| or |has| or rewrite for active voice. ฿--> successfully<!--฿ Redundant word? ฿--> claimed,
no other claim can then claim it. This prevents unauthorised application workloads from accessing a resource
that your workload(s)<!--฿ Do not combine a singular and a plural. Maybe write |one or more| instead. ฿--> are using.

Use the 'tanzu<!--฿ The brand is |Tanzu|. ฿--> service claimable list'<!--฿ Double quotation marks are preferred in US English. ฿--> command to find resources you can then create resource claims for.

```console
Usage:
  tanzu services resource-claims create [name] [flags]

Examples:
  tanzu services resource-claim create psql-claim-1 --resource-name psql-instance-1 --resource-kind Postgres --resource-api-version sql.example.com/v1
  tanzu services resource-claim create psql-claim-1 --resource-name psql-instance-1 --resource-kind Postgres --resource-api-version sql.example.com/v1 --resource-namespace service-instances-1
  tanzu services resource-claim create psql-claim-1 --resource-name secret-1 --resource-kind Secret --resource-api-version v1

Flags:
  -h, --help                          help for create
  -n, --namespace name                kubernetes namespace (defaulted from kube config)
      --resource-api-version string   API group and version of the resource to claim (in the form '<GROUP>/<VERSION>')
      --resource-kind string          kind of the resource to claim
      --resource-name string          name of the resource to claim
      --resource-namespace string     namespace of the resource to claim

Global Flags:
      --context string      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig string   kubeconfig file (default is /home/eking/.kube/config)
      --no-color            turn off color output in terminals
```

### <a id="stk-cli-resource-claim-get"></a> tanzu service resource-claim get

Get detailed information for a resource claim.

The output includes the name of claimed resource as well as<!--฿ |and| is preferred. ฿--> the claim ref. Claim refs can be<!--฿ Consider switching to active voice. ฿--> passed to the
'--service-ref'<!--฿ Double quotation marks are preferred in US English. ฿--> flag of the 'tanzu<!--฿ The brand is |Tanzu|. ฿--> apps workload create'<!--฿ Double quotation marks are preferred in US English. ฿--> command in order to<!--฿ |to| is preferred. ฿--> bind workloads to claimed service
instances.

```console
Usage:
  tanzu services resource-claims get [name] [flags]

Examples:
  tanzu services resource-claim get psql-claim-1
  tanzu services resource-claim get psql-claim-1 --namespace app-ns-1

Flags:
  -h, --help             help for get
  -n, --namespace name   kubernetes namespace (defaulted from kube config)

Global Flags:
      --context string      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig string   kubeconfig file (default is /home/eking/.kube/config)
      --no-color            turn off color output in terminals
```

### <a id="stk-cli-resource-claim-delete"></a> tanzu service resource-claim delete

Delete a resource claim.

You will<!--฿ Avoid |will|: present tense is preferred. ฿--> be prompted to confirm the deletion unless the --yes flag is passed.

Before deleting a claim it is important to<!--฿ Maybe re-phrase as an imperative. ฿--> be aware<!--฿ To avoid anthropomorphism, use |detects|. ฿--> of the consequences of doing so. The act of<!--฿ Redundant? ฿--> creating a claim
signals a desire<!--฿ |want| is preferred. ฿--> for a resource, which is usually done for the purpose of binding it to one or more application
workloads. Deleting a claim signals that you no longer need the claimed resource, at which point it may<!--฿ |can| usually works better. Use |might| to convey possibility. ฿--> be possible for
other claims created by other actors to claim the resource you once claimed.

```console
Usage:
  tanzu services resource-claims delete [name] [flags]

Examples:
  tanzu services resource-claim delete psql-claim-1
  tanzu services resource-claim delete psql-claim-1 --yes
  tanzu services resource-claim delete psql-claim-1 --namespace app-ns-1

Flags:
  -h, --help             help for delete
  -n, --namespace name   kubernetes namespace (defaulted from kube config)
  -y, --yes              skip the confirmation of the deletion

Global Flags:
      --context string      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig string   kubeconfig file (default is /home/eking/.kube/config)
      --no-color            turn off color output in terminals
```

### <a id="stk-cli-resource-claim-list"></a> tanzu service resource-claim list

List resource claims in a namespace or across all namespaces.

If run with the '-o wide'<!--฿ Double quotation marks are preferred in US English. ฿--> flag then claim refs for each of the claims are printed. Claim refs can be<!--฿ Consider switching to active voice. ฿--> passed to the
'--service-ref'<!--฿ Double quotation marks are preferred in US English. ฿--> flag of the 'tanzu<!--฿ The brand is |Tanzu|. ฿--> apps workload create'<!--฿ Double quotation marks are preferred in US English. ฿--> command in order to<!--฿ |to| is preferred. ฿--> bind workloads to claimed service
instances.

```console
Usage:
  tanzu services resource-claims list [flags]

Examples:
  tanzu services resource-claim list
  tanzu services resource-claim list -o wide
  tanzu services resource-claim list -n app-ns-1 -o wide

Flags:
  -A, --all-namespaces   list resource claims across all namespaces
  -h, --help             help for list
  -n, --namespace name   kubernetes namespace (defaulted from kube config)
  -o, --output string    output format (currently the only available option is 'wide')

Global Flags:
      --context string      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig string   kubeconfig file (default is /home/eking/.kube/config)
      --no-color            turn off color output in terminals
```

## <a id="stk-cli-claimable"></a> tanzu service claimable

Search for resources that to claim.

### <a id="stk-cli-claimable-list"></a>tanzu service claimable list

This command lists resources for a class which can then be claimed directly using the
'tanzu<!--฿ The brand is |Tanzu|. ฿--> service resource-claim create'<!--฿ Double quotation marks are preferred in US English. ฿--> command.

```console
Usage:
  tanzu services claimable list [flags]

Examples:
  tanzu services claimable list --class postgres
  tanzu services claimable list --class postgres --namespace app-ns-1

Flags:
      --class string     name of the class to list claimable resources for
  -h, --help             help for list
  -n, --namespace name   kubernetes namespace (defaulted from kube config)

Global Flags:
      --context string      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig string   kubeconfig file (default is /home/eking/.kube/config)
      --no-color            turn off color output in terminals
```
