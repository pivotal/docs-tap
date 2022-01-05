# Apps CLI plug-in overview

This Tanzu CLI plug-in provides the ability to create, view, update, and delete application workloads on any Kubernetes cluster that has the Tanzu Application Platform components installed.

## <a id='About'></a>About workloads

Tanzu Application Platform enables developers to quickly build and test applications regardless of their familiarity with Kubernetes.
Developers can turn source code into a workload that runs in a container with a URL.

A workload enables developers to choose application specifications, such as repository location, environment variables, service binding, and more.
For more information on workload creation and management, see [Command Reference](command-reference.md).

Tanzu Application Platform can support a range of workloads, including a serverless process that starts on demand, a constellation of microservices that functions as a logical application, or a small hello-world test app.


## <a id='Installation'></a>Installation

Follow the instructions to [Install or update the Tanzu CLI and plug-ins](../../install-general.md#cli-and-plugin).

From the `$HOME/tanzu` directory, run:

```
tanzu plugin install --local ./cli apps
```

To verify that the CLI is installed correctly, run:

```
tanzu apps version
```
A version should be displayed in the output.

If the following error is displayed during installation:
```
Error: could not find plug-in "apps" in any known repositories

✖  could not find plug-in "apps" in any known repositories
```

Verify that there is an `apps` entry in the `cli/manifest.yaml` file. It should look like this:

```
plugins:
...
    - name: apps
      description: Applications on Kubernetes
      versions: []
```
## <a id='command-reference'></a>Command reference

- See [Command Reference](command-reference.md)

## <a id='usage-and-examples'></a>Usage and examples

- See [Usage and Examples](usage.md)

## <a id='known-issues'></a>Known issues

- See [Known Issues](known-issues.md)

## <a id='feedback'></a>Feedback

For questions or feedback, contact us at tanzu-application-platform-beta@vmware.com.
