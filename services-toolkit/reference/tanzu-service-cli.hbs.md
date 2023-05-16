# Tanzu Service CLI plug-in

This topic provides reference information about the `tanzu service` CLI plug-in for Services Toolkit.
The main use for the plug-in is for
[application operators](../reference/terminology-and-user-roles.hbs.md#ao) and
[application developers](../reference/terminology-and-user-roles.hbs.md#ad) to create claims.
It aims to offer you a service experience that is consistent with other Tanzu CLI commands.

The reference material in this topic is split by sub-command.

## <a id="stk-cli-class"></a> tanzu service class

Classes, sometimes called instance classes or service instance classes, are a means to discover and describe
groupings of similar service instances.
They are analogous to the concept of storage classes in Kubernetes.

You can discover the range of services on offer by listing the available classes on a cluster.
See `tanzu service class list -h`.

You can create a claim for a service instance of a particular class by running the
`tanzu service class-claim create` command.

When you get a class, you can see more detailed information about the it, including,
where available, a list of parameters that you can pass to the `tanzu service class-claim create`
command using the `--parameter` flag.

### <a id="stk-cli-class-list"></a> tanzu service class list

This command lists the available classes.

```console
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

This command gets detailed information for a class.

The output includes more detailed information about the class, including,
where available, a list of parameters that you can pass to the `tanzu service class-claim create`
command using the `--parameter` flag.

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

Class claims allow you to create claims by only referring to a class.

Class claims are an alternative approach to resource claims, which require you to refer to a specific
resource by name, namespace, kind and API group/version.

VMware recommends that you work with class claims wherever possible because they are easier to create
and are considered more portable across multiple clusters.

### <a id="stk-cli-class-claim-create"></a> tanzu service class-claim create

This command creates a claim by referring to a class.

You can bind claims for service instances to application workloads.

Claims are mutually exclusive, meaning that after a service instance has been claimed,
no other claim can claim it. This prevents unauthorized application workloads from accessing a
service instance that your application workloads are using.

You can pass parameters with the `--parameter key.subKey=value` flag.
You can provide this flag multiple times.
The value must be valid YAML.
You can find available parameters for a class by running `tanzu services class get CLASS-NAME`.

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

This command gets detailed information for a class claim.

The output includes the name of the class the claim was created for and the claim ref.
Pass claim refs to the `--service-ref` flag of the `tanzu apps workload create` command to
bind workloads to claimed service instances.

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

This command deletes a class claim.

You will be prompted to confirm the deletion unless you pass the `--yes` flag.
Before you delete a claim, you must be aware of the consequences of doing so.

When you create a claim, it signals a that you want a service instance.
You usually create a service instance to bind it to one or more application workload.
If you delete a claim, it signals that you no longer need the claimed service instance.
At this point, other claims created by other users can claim the service instance you previously claimed.

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

This command lists class claims in a namespace or across all namespaces.

If you run this command with the `-o wide` flag, claim refs for each of the claims are printed.
Pass claim refs to the `--service-ref` flag of the `tanzu apps workload create` command to
bind workloads to claimed service instances.

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

Resource claims enable you to create claims by referring to a specific resource by name, namespace,
kind, and API group or version.

Resource claims are an alternative approach to class claims, which only require you to refer to a class.

VMware recommends that you work with [class claims](#stk-cli-class-claim) wherever possible because
they are easier to create and are more portable across multiple clusters.

### <a id="stk-cli-resource-claim-create"></a>tanzu service resource-claim create

This command creates a claim for a specific resource.

It is common to create claims for resources that you can bind to application workloads using the claim.

This approach to creating claims differs to that of class claims, in which the system ultimately
finds and supplies a claimable resource for you.
You only have to work with resource claims if you want full control over which resource is claimed.
If not, it is simpler and more convenient to work with class claims.
See `tanzu service class-claim --help`.

Claims are mutually exclusive, meaning that after a service instance has been claimed,
no other claim can claim it. This prevents unauthorized application workloads from accessing a
resource that your application workloads are using.

To find resources you can create resource claims for, run the `tanzu service claimable list` command.

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

This command gets detailed information for a resource claim.

The output includes the name of claimed resource and the claim ref.
Pass claim refs to the `--service-ref` flag of the `tanzu apps workload create` command to
bind workloads to claimed service instances.

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

This command deletes a resource claim.

You will be prompted to confirm the deletion unless you pass the `--yes` flag.
Before you delete a claim, you must be aware of the consequences of doing so.

When you create a claim, it signals a that you want a resource.
You usually create a resource to bind it to one or more application workload.
If you delete a claim, it signals that you no longer need the claimed resource.
At this point, other claims created by other users can claim the resource you previously claimed.

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

This command lists resource claims in a namespace or across all namespaces.

If you run this command with the `-o wide` flag, claim refs for each of the claims are printed.
Pass claim refs to the `--service-ref` flag of the `tanzu apps workload create` command to
bind workloads to claimed service instances.

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

Searches for resources that are available to claim.

### <a id="stk-cli-claimable-list"></a>tanzu service claimable list

This command lists resources for a class that you can claim directly using the
`tanzu service resource-claim create` command.

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
