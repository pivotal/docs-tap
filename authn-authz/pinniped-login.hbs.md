# Login using Pinniped

As a prerequisite, the administrator needs to provide users access to resources via `rolebindings`. It can be done with the `tanzu rbac` plug-in. See [Bind a user or group to a default role](binding.md).

To login to your cluster by using Pinniped, follow these steps:

1. Install the pinniped CLI with one of the methods described in the [install guide](https://pinniped.dev/docs/howto/install-cli/). The pinniped CLI is required not only for the administrator generating the `kubeconfig` but also for the user for logging in with the provided configuration. Make sure to always use the latest compatible version possible.
1. Generate and distribute `kubeconfig` to users
1. Login with provided `kubeconfig`


## Download the Pinniped CLI
You must use a Pinniped CLI version that matches the installed Concierge/Supervisor. For `0.22.0`:

- [Mac OS/AMD64](https://get.pinniped.dev/v0.22.0/pinniped-cli-darwin-amd64)
- [Linux/AMD64](https://get.pinniped.dev/v0.22.0/pinniped-cli-linux-amd64)
- [Windows/AMD64](https://get.pinniped.dev/v0.22.0/pinniped-cli-windows-amd64.exe)

You should put the command-line tool somewhere on your $PATH, such as /usr/local/bin on macOS/Linux. You’ll also need to mark the file as executable.

## Generate and distribute kubeconfig to users

As an administrator, you can generate the kubeconfig by using the following command:

```console
pinniped get kubeconfig --kubeconfig-context <your-kubeconfig-context>  > /tmp/concierge-kubeconfig
```

Distribute this `kubeconfig` to your users so they can login by using `pinniped`.

## Login with provided kubeconfig

As a user of the cluster, you will need the `kubeconfig` provided by your administrator and the pinniped cli installed on your machine to login. Logging in is a part of requesting information from the cluster. You can execute any resource request with `kubectl` to get into the authentication flow. For example:

```console
kubectl --kubeconfig /tmp/concierge-kubeconfig get pods
```

If you do not want to explicitly use `--kubeconfig` in every command, you can also export an environment variable to set the `kubeconfig` path in your shell session.

```console
export KUBECONFIG="/tmp/concierge-kubeconfig"
kubectl get pods
```

This command enables `pinniped` to print a URL for you to visit in the browser. You can then log in, copy the auth code and paste it back to the terminal.
After the login succeeds, you will either see the resources or get a message that you have no permission to access the resources.

   >**Note** If you are working on a windows machine, the command referenced in the generated kubeconfig might not work for you. In this case you need to adjust the path under `user.exec.command` in the kubeconfig to point to your install apth of the Pinniped CLI.