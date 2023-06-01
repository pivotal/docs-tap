# Unsafe test login

To get started in a non-production environment, `ClusterUnsafeTestLogin` is a
zero-config API which produces an unsafe, ready-to-claim AppSSO service
offering. 

When creating a `ClusterUnsafeTestLogin` you will get a simple `AuthServer` and
a `ClusterWorkloadRegistrationClass` for it. The `AuthServer` has a single
login `user:password` and is configured to "just work".

It takes zero configuration, but a name:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClusterUnsafeTestLogin
metadata:
  name: demo
```

After applying this resource, _application operators_ can discover and claim
credentials for it:

```plain
❯ tanzu services classes list
  NAME  DESCRIPTION
  demo  Login by AppSSO - user:password - UNSAFE FOR PRODUCTION!
```

Keep in mind that this is not safe for production. For production you will want
to use `AuthServer` and `ClusterWorkloadRegistrationClass`.

