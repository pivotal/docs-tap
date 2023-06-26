# Configure an unsafe test login

This topic for service operators describes how you can get started with Application Single Sign-On for
VMware Tanzu (commonly called AppSSO) in a non-production environment by using `ClusterUnsafeTestLogin`.

`ClusterUnsafeTestLogin` is a zero-config API that produces an unsafe, ready-to-claim AppSSO service offering.
When you create a `ClusterUnsafeTestLogin`, you get a simple `AuthServer` and
a `ClusterWorkloadRegistrationClass` for it.
The `AuthServer` has a single login `user:password` and is configured to work without extra configuration.

> **Caution** `ClusterUnsafeTestLogin` is not safe for production. For production, use `AuthServer`
> and `ClusterWorkloadRegistrationClass`.

## <a id="configure"></a> Configure a `ClusterUnsafeTestLogin`

The `ClusterUnsafeTestLogin` resource takes zero configuration except a `name`.

To configure a `ClusterUnsafeTestLogin` create a YAML file as follows:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClusterUnsafeTestLogin
metadata:
  name: demo
```

## <a id="use"></a> Use the unsafe test login

After applying the `ClusterUnsafeTestLogin` resource, application operators can discover and claim
credentials for it by running:

```console
tanzu services classes list
```

Example output:

```console
NAME  DESCRIPTION
demo  Login by AppSSO - user:password - UNSAFE FOR PRODUCTION!
```

<!-- does the above command both discover and claim resources? -->
