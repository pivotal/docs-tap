# tanzu supplychain generate

Generate a supplychain scaffold

## Synopsis

Generate a supplychain scaffold
		
Generate configuration options include:
- Kind, component list and the description

```console
tanzu supplychain generate [flags]
```

## Examples

```console
tanzu supplychain generate --kind ServerAppV1 --description DESCRIPTION
```

## Options

```console
  -c, --component strings    add a component to the supplychain scaffold. This flag can be specified multiple times and the order on the command-line will be reflected on the generated scaffold output
  -d, --description string   description of the supplychain
  -h, --help                 help for generate
  -k, --kind string          kind to use as the developer interface
```

## Options inherited from parent commands

```console
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
      --no-color          deactivate color, bold, animations, and emoji output
  -v, --verbose int32     number for the log level verbosity (default 1)
```

## SEE ALSO

* [tanzu supplychain](tanzu_supplychain.md)	 - supplychain management

