# Configure the Apps CLI plug-in

This topic tells you how to configure the Apps CLI plug-in.

## <a id='changing-clusters'></a>Changing clusters with --context

The Apps CLI plug-in refers to the default kubeconfig file to access a Kubernetes cluster.
When you run a `tanzu apps` command, the plug-in uses the default context that is defined in that
kubeconfig file (located by default at `HOME/.kube/config`).

There are two ways to change the target cluster:

1. Use `kubectl config use-context CONTEXT-NAME` to change the default context. All subsequent
  `tanzu apps` commands target the cluster defined in the new default kubeconfig context.

2. Include the `--context CONTEXT-NAME` flag when running any `tanzu apps` command.

   >**Note** Any subsequent `tanzu apps` commands that do not include the `--context CONTENT-NAME`
     flag continue to use the default context set in the kubeconfig.

## <a id='override-kubeconfig'></a>Overriding the default kubeconfig

There are two approaches to overriding the default kubeconfig:

1. Set the environment variable `KUBECONFIG=PATH` to change the kubeconfig the Apps CLI plug-in will
   reference. All subsequent `tanzu apps` commands reference the non-default kubeconfig assigned to 
   the environment variable.

2. Include the  `--kubeconfig path` flag when running any `tanzu apps` command.

   >**Note** Any subsequent `tanzu apps` commands that do not include the `--context CONTEXT-NAME` flag
   continue to use the default context set in the kubeconfig.

For more information about kubeconfig, see 
[Kubernetes documentation](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/)
in the Kubernetes documentation.

## Suppressing color with --no-color flag

Most Tanzu Apps Plug-in commands have emojis and colored output. In some cases, color, emojis,
and other characters are not needed, such as for automated scripting, or where the misinterpretation
of these features by a terminal could result in a poor user experience. Use the `--no-color` flag
to suppress color, emojis, and animation.

The following example creates a workload with code from `--local-path`. The `--no-color`
flag suppresses the emojis and animated upload progress bar:

```console
tanzu apps workload apply my-workload --local-path path/to/my/source --type web --no-color
The files and/or directories listed in the .tanzuignore file are being excluded from the uploaded source code.
Publishing source in "path/to/my/source" to "local-source-proxy.tap-local-source-system.svc.cluster.local/source:default-my-workload""...
Published source

Create workload:
      1 + |---
      2 + |apiVersion: carto.run/v1alpha1
      3 + |kind: Workload
      4 + |metadata:
      5 + |  annotations:
      6 + |    local-source-proxy.apps.tanzu.vmware.com: registry.io/project/source:default-my-workload@sha256:447db92e289dbe3a6969521917496ff2b6b0a1d6fbff1beec3af726430ce8493
      7 + |  labels:
      8 + |    apps.tanzu.vmware.com/workload-type: web
      9 + |  name: my-workload
     10 + |  namespace: default
     11 + |spec:
     12 + |  source:
     13 + |    image: registry.io/project/source:default-my-workload@sha256:447db92e289dbe3a6969521917496ff2b6b0a1d6fbff1beec3af726430ce8493
? Do you want to create this workload? [yN]:
```

Persist the suppression of color, emojis, and animation across commands by setting the
`NO_COLOR` environment variable.

```bash
export NO_COLOR=true
```

## .tanzuignore file

Use the optional `.tanzuignore` file at the root of your project directory to indicate which
files or directories in your project are not required to build or run your application (e.g.
README.md, .git, docs, etc...). Including such files in your .`tanzuignore` can provide the following
benefits:

1. Items included in the `.tanzuignore` file are not uploaded when you upload your source code. This
helps to avoid unnecessary consumption of resources.
2. When iterating on code with the `--live-update` flag enabled, changes to directories or files listed
  in the `.tanzuignore` file do not trigger the automatic re-deployment of source code.

The following are some guidelines for the `.tanzuignore` file:

- The `.tanzuignore` file should include a reference to itself, as it provides no value when deployed.
- Directories must not end with the system separator `/`, or `\`.
- Add comments using hashtag `#`.
- If the `.tanzuignore` file contains files or directories that are not found in the source code,
  they are ignored.

### Example of a .tanzuignore file

```console
.tanzuignore # must contain itself in order to be ignored
# This is a comment
this/is/a/folder/to/exclude

this-is-a-file.ext
```

## <a id='registry-flags-env-vars'></a> Registry flags and environment variables

A user can either trust a custom certificate on their system or pass the path to the certificate via
flags (environment variables can also be set to avoid having to pass the flags/values for every
command incantation),

Below is a list of each of the flags with their environment variable equivalent in parenthesis:

- `--registry-ca-cert`: This is the path of the self-signed certificate needed for the custom or 
  private registry (`TANZU_APPS_REGISTRY_CA_CERT`).
- `--registry-password`: Use this when the registry requires credentials to push (`TANZU_APPS_REGISTRY_PASSWORD`).
- `--registry-username`: Use with `--registry-password` to set the registry credentials (`TANZU_APPS_REGISTRY_USERNAME`).
- `--registry-token`: Set when the registry authentication is done through a token (`TANZU_APPS_REGISTRY_TOKEN`).

For example:

```console
tanzu apps workload apply WORKLOAD \
--local-path PATH-TO-REPO --source-image registry.url.nip.io/PACKAGE/IMAGE \
--type web --registry-ca-cert path/to/ca/cert.nip.io.crt \
--registry-username USERNAME \
--registry-password PASSWORD
```

Alternatively, run as:

```bash
export TANZU_APPS_REGISTRY_CA_CERT=path/to/ca/cert.nip.io.crt
export TANZU_APPS_REGISTRY_PASSWORD=USERNAME
export TANZU_APPS_REGISTRY_USERNAME=PASSWORD

tanzu apps workload apply WORKLOAD \
--local-path PATH-TO-REPO \
--source-image registry.url.nip.io/PACKAGE/IMAGE
```

Use the `--type` flag to specify the type of workload. Persist the workload type value
across commands by setting the `TANZU_APPS_TYPE` environment variable. The default 
value of `web` is set automatically if no `--type` flag or `TANZU_APPS_TYPE` value is provided.

```bash
export TANZU_APPS_TYPE=server
```

## <a id='autocompletion'></a>Autocompletion

The Apps CLI plug-in provides auto-completion support for commands,
positional arguments, flags, and flag values.

Add one of the following commands to the shell config file according to your setup:

### <a id='bash'></a>Bash

```bash
tanzu completion bash >  HOME/.tanzu/completion.bash.inc
```

### <a id='zsh'></a>Zsh

```bash
echo "autoload -U compinit; compinit" >> ~/.zshrc
tanzu completion zsh > "${fpath[1]}/_tanzu"
```
