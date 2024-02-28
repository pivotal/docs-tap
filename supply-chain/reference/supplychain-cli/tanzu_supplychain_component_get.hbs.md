# tanzu supplychain component get

Get details of a component

## Synopsis

Get the details of the specified component within a namespace.

component get configuration options include:
- Specify the namespace of the component
- Output the component formatted
- Show more details of the component

```console
tanzu supplychain component get <NAME> [flags]
```

## Examples

```console
tanzu supplychain component get NAME
  tanzu supplychain component get NAME --namespace default
  tanzu supplychain component get NAME --namespace default --show-details
```

## Options

```console
  -h, --help             help for get
  -n, --namespace name   kubernetes namespace (defaulted from kube config)
  -o, --output string    output the component details formatted. Supported formats: "json", "yaml", "yml"
      --show-details     show more details of the component
```

## Options inherited from parent commands

```console
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
      --no-color          deactivate color, bold, animations, and emoji output
  -v, --verbose int32     number for the log level verbosity (default 1)
```

## SEE ALSO

* [tanzu supplychain component](tanzu_supplychain_component.md)	 - Interacting with supplychain components

