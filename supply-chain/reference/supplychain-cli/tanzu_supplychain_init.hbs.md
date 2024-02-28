# tanzu supplychain init

Initialize supplychain

## Synopsis

Initialize supplychain
		
Initialize configuration options include:
- group name and the description

```console
tanzu supplychain init [flags]
```

## Examples

```console
tanzu supplychain init --group supplychains.tanzu.vmware.com --description DESCRIPTION
```

## Options

```console
  -d, --description string   description of the group
  -g, --group string         group of the supplychains (default "supplychains.tanzu.vmware.com")
  -h, --help                 help for init
```

### Options inherited from parent commands

```console
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
      --no-color          deactivate color, bold, animations, and emoji output
  -v, --verbose int32     number for the log level verbosity (default 1)
```

### SEE ALSO

* [tanzu supplychain](tanzu_supplychain.md)	 - supplychain management

