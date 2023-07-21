# tanzu insight package get

Get package by name, version, and package manager

## <a id='synopsis'></a>Synopsis

To get package by name, version, and package manager, run:

```console
tanzu insight package get --name <package name> --version <package version> --pkgmngr Unknown [flags]
```

## <a id='examples'></a>Examples

```console
insight package get --name client --version 1.0.0a --pkgmngr Unknown
  insight package get --name client --version 1.0.0a --pkgmngr Unknown --output-format api-json
```

## <a id='options'></a>Options

```console
  -h, --help                   help for get
  -n, --name string            name of the package
      --output-format string   specify the response's SBOM report format and file type format, options=[text, api-json] (default: text)
  -p, --pkgmngr string         Package manager of the dependency. 'Unknown' is currently the only supported value (default "Unknown")
  -v, --version string         version of the package
```

## <a id='see-also'></a>See also

* [tanzu insight package](tanzu_insight_package.hbs.md)	 - Package commands
