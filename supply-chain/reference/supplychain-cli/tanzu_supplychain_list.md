## tanzu supplychain list

Lists all supplychains

### Synopsis

Lists all supplychains
		
list configuration options include:
- Output the list for all namespaces
- Output the list for a specific namespace
- Output the list formatted

```
tanzu supplychain list [flags]
```

### Examples

```
tanzu supplychain list
  tanzu supplychain list --all-namespaces
```

### Options

```
  -A, --all-namespaces   use all kubernetes namespaces
  -g, --group string     list all supplychains from a specific group
  -h, --help             help for list
  -n, --namespace name   kubernetes namespace (defaulted from kube config)
  -o, --output string    output the supplychains formatted. Supported formats: "json", "yaml", "yml"
  -w, --wide             output the supplychain list with additional information
```

### Options inherited from parent commands

```
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
      --no-color          deactivate color, bold, animations, and emoji output
  -v, --verbose int32     number for the log level verbosity (default 1)
```

### SEE ALSO

* [tanzu supplychain](tanzu_supplychain.md)	 - supplychain management

