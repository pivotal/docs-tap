# tanzu insight package sources

This topic tells you how to use the Tanzu Insight CLI plug-in 
`tanzu insight package sources` to get the sources that contain 
the given package by name.

## <a id='synopsis'></a>Synopsis

Get sources that contain the given package by name.

```console
tanzu insight package sources --name <package name> [flags]
```

## <a id='examples'></a>Examples

```console
tanzu insight package sources --name client
```

## <a id='options'></a>Options

```console
  -f, --format string   output format which can be in 'json' or 'text'. If not present, defaults to text. (default "text")
  -h, --help            help for sources
  -n, --name string     name of the package
```

## <a id='see-also'></a>See also

* [Tanzu insight package](insight-package.md)	 - Package commands
