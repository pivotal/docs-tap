# Create your customized developer portal using Tanzu Portal Builder

This topic tells you how to customize your developer portal.

## <a id="create-custom-policy"></a> Create a custom policy

In your custom Tanzu Portal Builder plug-in, create a custom permission policy.
For how to do so, see the [Backstage documentation](https://backstage.io/docs/permissions/writing-a-policy/).

The following example permission policy allows access to view all catalog entities, but denies all
delete requests:

```typescript
export class CustomPermissionPolicy implements PermissionPolicy {
  async handle(request: PolicyQuery): Promise<PolicyDecision> {
    if (request.permission.name === 'catalog.entity.delete') {
      return {
        result: AuthorizeResult.DENY,
      };
    }
    return { result: AuthorizeResult.ALLOW };
  }
}
```

## <a id="set-custom-policy-on-pps"></a> Set your custom policy on the permission policy surface

After creating your custom permission policy, you can set it on the `PermissionPolicySurface`.
You can apply only one permission policy. Attempting to apply more than one policy causes an error at
build time.
For example:

```typescript
export const CustomPermissionPolicyPlugin: BackendPluginInterface =
  () => surfaces => {
    surfaces.applyTo(PermissionPolicySurface, surface => {
      surface.set(new CustomPermissionPolicy());
    });
  };
```

## <a id="add-custom-prmssn-policy"></a> Add a custom permission policy to your portal

<!-- Insert content -->