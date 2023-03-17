# Login using Pinniped

As a prerequisite, the administrator needs to provide users access to resources via `rolebindings`. It can be done with the `tanzu rbac` plug-in. See [Bind a user or group to a default role](binding.md).

To login to your cluster by using Pinniped, follow these steps:

1. Download the correct version of the Pinniped CLI
1. Generate and distribute `kubeconfig` to users
1. Login with provided `kubeconfig`

## Download the Pinniped CLI
You must use Pinniped CLI version `0.12.0` to match the installed Concierge/Supervisor.

- [Mac OS/AMD64](https://get.pinniped.dev/v0.12.0/pinniped-cli-darwin-amd64)
- [Linux/AMD64](https://get.pinniped.dev/v0.12.0/pinniped-cli-linux-amd64)
- [Windows/AMD64](https://get.pinniped.dev/v0.12.0/pinniped-cli-windows-amd64.exe)

You should put the command-line tool somewhere on your $PATH, such as /usr/local/bin on macOS/Linux. You’ll also need to mark the file as executable.

## Generate and distribute kubeconfig to users

As an administrator, you can generate the kubeconfig by using the following command:

```console
pinniped get kubeconfig --kubeconfig-context <your-kubeconfig-context>  > /tmp/concierge-kubeconfig
...
"level"=0 "msg"="validated connection to the cluster"
```

Distribute this `kubeconfig` to your users so they can login by using `pinniped`.

## Login with provided kubeconfig

As a user of the cluster, you will need the `kubeconfig` provided by your administrator to login. Logging in is a part of requesting information from the cluster. You can execute any resource request with `kubectl` to get into the authentication flow. For example:

```console
kubectl --kubeconfig /tmp/concierge-kubeconfig get pods
```

If you do not want to explicitly use `--kubeconfig` in every command, you can also export an environment variable to set the `kubeconfig` path in your shell session.

```console
export KUBECONFIG="/tmp/concierge-kubeconfig"
kubectl get pods
```

This command enables `pinniped` to print a URL for you visit in the browser. You can then log in, copy the auth code and paste it back to the terminal.
After the login succeeds, you will either see the resources or get a message that you have no permission to access the resources.
