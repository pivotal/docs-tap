# Login using Pinniped

As a prerequisite, the administrator needs to provide users access to resources via `rolebindings`. It can be done with the `tanzu rbac` plug-in. See [Bind a user or group to a default role](binding.md).

To login to your cluster by using Pinniped, follow these steps:

1. Install the Pinniped CLI. 

    For more information, see [Pinniped documentation](https://pinniped.dev/docs/howto/install-cli/). 

    >**Important** The latest compatible version of Pinniped CLI is required not only for 
    > the administrator to generate the `kubeconfig`, 
    > but also for the user to log in with the provided configuration. 
    
1. Generate and distribute `kubeconfig` to users.
1. Login with the provided `kubeconfig`.


## <a id="download"></a> Download the Pinniped CLI

You must use a Pinniped CLI version that matches the installed Concierge or Supervisor. 
Use one of the following links to download the Pinniped CLI version `0.22.0`:

- [Mac OS with AMD64](https://get.pinniped.dev/v0.22.0/pinniped-cli-darwin-amd64)
- [Linux with AMD64](https://get.pinniped.dev/v0.22.0/pinniped-cli-linux-amd64)
- [Windows with AMD64](https://get.pinniped.dev/v0.22.0/pinniped-cli-windows-amd64.exe)

You must install the command-line tool on your `$PATH`, such as `/usr/local/bin` on macOS or Linux. 
You must also mark the file as executable.

## <a id="generate"></a> Generate and distribute kubeconfig to users

As an administrator, you can generate the kubeconfig by using the following command:

```console
pinniped get kubeconfig --kubeconfig-context <your-kubeconfig-context>  > /tmp/concierge-kubeconfig
```

Distribute this `kubeconfig` to your users so they can login by using `pinniped`.

## <a id="login"></a> Login with the provided kubeconfig

As a user of the cluster, you need the `kubeconfig` provided by your admin 
and the Pinniped CLI installed on your local machine to log in. 
Logging in is required to request information from the cluster. 
You can execute any resource request with kubectl to enter the authentication flow. 
For example:

```console
kubectl --kubeconfig /tmp/concierge-kubeconfig get pods
```

If you do not want to explicitly use `--kubeconfig` in every command, you can also export an environment variable to set the `kubeconfig` path in your shell session.

```console
export KUBECONFIG="/tmp/concierge-kubeconfig"
kubectl get pods
```

This command enables `pinniped` to print a URL for you to visit in the browser. 
You can then log in, copy the authentication code and paste it back to the terminal.
After the login succeeds, you either see the resources or a message indicating that 
you have no permission to access the resources.

If you use a Windows machine, the command referenced in the generated `kubeconfig` 
might not work. In this case, you must change the path under `user.exec.command` 
in the `kubeconfig` to point to the install path of the Pinniped CLI.
