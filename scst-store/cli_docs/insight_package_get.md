# Insight package get

Get package by name, version, and package manager.

## <a id='synopsis'></a>Synopsis

Get package by name, version, and package manager.

```
insight package get --name <package name> --version <package version> --pkgmngr Unknown [--format <format>] [flags]
```

## <a id='examples'></a>Examples

```
insight package get --name client --version 1.0.0a --pkgmngr Unknown
```

## <a id='options'></a>Options

```
  -f, --format string    output format which can be in 'json' or 'text'. If not present, defaults to text. (default "text")
  -h, --help             help for get
  -n, --name string      name of the package
  -p, --pkgmngr string   Package manager of the dependency. 'Unknown' is currently the only supported value (default "Unknown")
  -v, --version string   version of the package
```

## <a id='see-also'></a>See also

* [insight package](insight-package.md)	 - Package commands
