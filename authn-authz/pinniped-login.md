# Login using Pinniped

As a prerequisite the administrator has provided users access to resources via rolebindings. These can be done with the `tanzu rbac` plugin. See [Bind a user or group to a default role](binding.md).

To login to your cluster using Pinniped follow these steps:

1. Generate and distribute kubeconfig to users
1. Login with provided kubeconfig

## Generate and distribute kubeconfig to users

As an administrator you need to generate the kubeconfig using the following command:

```
pinniped get kubeconfig --kubeconfig-context <your-kubeconfig-context>  > /tmp/concierge-kubeconfig
...
"level"=0 "msg"="validated connection to the cluster"
```

Distribute this kubeconfig to your users to allow them to login using pinniped.

## Login with provided kubeconfig

As a user of the cluster you will need the kubeconfig provided by your administrator to be able to login. Logging in is a part of requesting information from the cluster. You can execute any resource request with kubectl to get into the authentication flow. For example:

```
kubectl --kubeconfig /tmp/concierge-kubeconfig get pods
```

If you would like to not explicitly use `--kubeconfig` in every command you can also export an environment variable to set the kubeconfig path in your shell session.
```
export KUBECONFIG="/tmp/concierge-kubeconfig"
kubectl get pods
```

After this command pinniped prints a URL which you need to visit with your browser, log in, copy the auth code and paste it back to the terminal.
After a successful login you will either see the resources or a message that informs you that your user has no permission to access the resources. 
