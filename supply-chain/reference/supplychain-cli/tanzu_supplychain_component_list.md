## tanzu supplychain component list

Lists all supplychain components

### Synopsis

Lists all available supplychain components
		
component list configuration options include:
- Output the component list formatted

```console
tanzu supplychain component list [flags]
```

### Examples

```console
tanzu supplychain component list
  tanzu supplychain component list --output yaml
  tanzu supplychain component list --wide
```

### Options

```console
  -h, --help            help for list
  -o, --output string   output the supplychain component formatted. Supported formats: "json", "yaml", "yml"
  -w, --wide            output the supplychain component list with additional information
```

### Options inherited from parent commands

```console
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
      --no-color          deactivate color, bold, animations, and emoji output
  -v, --verbose int32     number for the log level verbosity (default 1)
```

### SEE ALSO

* [tanzu supplychain component](tanzu_supplychain_component.md)	 - Interacting with supplychain components

