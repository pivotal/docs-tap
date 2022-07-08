# Tanzu apps workload apply

This topic helps you apply configurations to a new or existing workload.

### <a id="synopsis"></a> Synopsis

Apply configurations to a new or existing workload. If the resource does not exist, it will be created.

Workload configuration options include:

- Source code to build (if there is a `.tanzuignore` file, filepaths listed there will be ignored in the build)
- runtime resource limits
- environment variables
- services to bind
- Set complex params with `--param-yaml` (use `$` as prefix in value when escape characters `\` within)

```console
tanzu apps workload apply [name] [flags]
```

## <a id="examples"></a> Examples

```console
tanzu apps workload apply --file workload.yaml
tanzu apps workload apply my-workload --param-yaml maven=$"artifactId:hello-world\ntype: jar\nversion: 0.0.1\ngroupId: carto.run"
```

## <a id="options"></a> Options

```console
      --annotation "key=value" pair    annotation is represented as a "key=value" pair ("key-" to remove, flag can be used multiple times)
      --app name                       application name the workload is a part of
      --build-env "key=value" pair     build environment variables represented as a "key=value" pair ("key-" to remove, flag can be used multiple times)
      --debug                          put the workload in debug mode (--debug=false to disable)
      --dry-run                        print kubernetes resources to stdout rather than apply them to the cluster, messages normally on stdout will be sent to stderr
      --env "key=value" pair           environment variables represented as a "key=value" pair ("key-" to remove, flag can be used multiple times)
  -f, --file file path                 file path containing the description of a single workload, other flags are layered on top of this resource. Use value "-" to read from stdin
      --git-branch branch              branch within the git repo to checkout
      --git-commit SHA                 commit SHA within the git repo to checkout
      --git-repo url                   git url to remote source code
      --git-tag tag                    tag within the git repo to checkout
  -h, --help                           help for apply
      --image image                    pre-built image, skips the source resolution and build phases of the supply chain
      --label "key=value" pair         label is represented as a "key=value" pair ("key-" to remove, flag can be used multiple times)
      --limit-cpu cores                the maximum amount of cpu allowed, in CPU cores (500m = .5 cores)
      --limit-memory bytes             the maximum amount of memory allowed, in bytes (500Mi = 500MiB = 500 * 1024 * 1024)
      --live-update                    put the workload in live update mode (--live-update=false to disable)
      --local-path path                path to a directory, .zip, .jar or .war file containing workload source code
  -n, --namespace name                 kubernetes namespace (defaulted from kube config)
      --param "key=value" pair         additional parameters represented as a "key=value" pair ("key-" to remove, flag can be used multiple times)
      --param-yaml "key=value" pair    specify nested parameters using YAML or JSON formatted values represented as a "key=value" pair ("key-" to remove, flag can be used multiple times)
      --request-cpu cores              the minimum amount of cpu required, in CPU cores (500m = .5 cores)
      --request-memory bytes           the minimum amount of memory required, in bytes (500Mi = 500MiB = 500 * 1024 * 1024)
      --service-account string         name of service account permitted to create resources submitted by the supply chain (to unset, pass empty string "")
      --service-ref object reference   object reference for a service to bind to the workload "service-ref-name=apiVersion:kind:service-binding-name" ("service-ref-name-" to remove, flag can be used multiple times)
  -s, --source-image image             destination image repository where source code is staged before being built
      --sub-path path                  relative path inside the repo or image to treat as application root (to unset, pass empty string "")
      --tail                           show logs while waiting for workload to become ready
      --tail-timestamp                 show logs and add timestamp to each log line while waiting for workload to become ready
      --type type                      distinguish workload type
      --wait                           waits for workload to become ready
      --wait-timeout duration          timeout for workload to become ready when waiting (default 10m0s)
  -y, --yes                            accept all prompts
```

## <a id="parent-commands-options"></a> Options inherited from parent commands

```console
      --context name      name of the kubeconfig context to use (default is current-context defined by kubeconfig)
      --kubeconfig file   kubeconfig file (default is $HOME/.kube/config)
      --no-color          disable color output in terminals
  -v, --verbose int32     number for the log level verbosity (default 1)
```

## <a id="see-also"></a> See also

- [Tanzu Apps Workload](tanzu-apps-workload.md) - Workload life cycle management
