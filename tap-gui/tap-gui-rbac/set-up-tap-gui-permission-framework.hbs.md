
# Set up permission framework for your Tanzu Application Platform GUI 

This section provides an overview of Backstage's permission framework and guidance on how to enable it for your Tanzu Application Platform GUI. For more information, please visit [Permission framework](https://backstage.io/docs/permissions/overview/).

**Disclaimer** Permission framework is currently introduced as `alpha` functionality. Though it provides a robust capability that controls visibility of the Software Catalog's entities, it is not recommended for use in production environment. For more information, please refer to (*link to release notes, known issues*).

## <a id='permission-overview'></a> Overview of the permission framework

Permission framework allows Tanzu Application Platform operators to enforce policies that would limit visibility of certain parts of the Tanzu Application Platform GUI. 

The current release features the `alpha` version of this functionality and only applies to the Software Catalog entities. Only one policy is available and it is embedded in the GUI.

The policy is called `owner-of`. As it is enabled, the operator, can define admin groups and users that would have unrestricted visibility of the Software Catalog entities. If a user is not listed as an admin or part of the admin group, they would be able to see onle the Software Catalog entities that are owned by teams they belong to.

**Note** Permission framework is disabled by default.

## <a id='enable-permission'></a> Enable the permission framework

To enable the permission framework and limit Software Catalog entities' visibility to owners, allow-listed users/groups, and catalog admins, please add the following parameters to the `tap_gui.app_config` stanza:

```yaml
permission:
  enabled: true
  adminRefs:
    - user:<namespace>/<name>
    - group:<namespace>/<name>
```
Where `adminRefs` section lists all users and groups that should be granted access. Each user and group should be defined by the
* `<namespace>`, which usually equals to `default` unless defined otherwise in the definition file, and
* `<name>` is the name of the group or user.

You can view your User Entity in the `Settings`/`General` section in your Tanzu Application Platform GUI, or in the yaml definition file of the User or Group.

For example:
```yaml
- user:default/admin
- group:test-namespace/operators
```

Once you have updated your configuration file, reinstall your Tanzu Application Platform GUI package by following the steps in
   [Upgrade Tanzu Application Platform](../../upgrading.hbs.md).

After the updated values configuration file is applied in Tanzu Application Platform GUI, the permission framework shall become enabled.

**Note** Once the permission framework is enabled, all Software Catalog entities without proper annotations shall become invisible to all users except admins.

## <a id='enable-visibility'></a> Enable catalog entity visibility

With the permission framework enabled, it is required to annotate entities in your Software Catalog to give visibility to the desired Users or Groups who are not owner of the entity. To do that, you will need to add annotations to the `metadata.annotations` stanza of the entity's definition file.

```yaml
metadata:
  annotations:
    backstage.tanzu.vmware.com/<group|user>.<namespace>.<name>: 'COMMA-SEPARATED-PERMISSIONS'
```
Where:
- `<group|user>` is either `group` to describe a Group or a `user` to describe an individual User
- `<namespace>` is the namespace that the Group or User is attributed to. If this value is not specified, it equals to `default`
- `<name>` is the name of the User or Group
- `COMMA-SEPARATED-PERMISSIONS` is the list of comma delimited permissions for the specified User or Group. Here is a list of valid catalog entity permissions:
  - catalog.entity.read
  - catalog.entity.update
  - catalog.entity.delete
**Note** There is another permission that is valid for permission framework - `catalog.entity.create` - yet it is not meaningful for the Software Catalog entities that have already been created.
**Note** You can add several Groups or Users by adding new annotations with their respective comma delimited permissions

For example, this annotation would let users that are part of `group-a` to read and/or delete `component-a`: 
```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: component-a
  annotations:
    backstage.tanzu.vmware.com/group.test-namespace.group-a: 'catalog.entity.read, catalog.entity.delete'
```

**Note** If a group is granted ownership/access to an entity, all users within that group will
automatically inherit the same access. But it does not work for nested group ownerships, when a group is listed as a member of another group.

**Disclaimer** When permission plugin is turned on with the default permission policy, API Auto
Registration (*link to component description*) will no longer work due to lack of user identities. Requests against the Catalog API
will no longer work as before. For more information, please read (*link to release notes, known issues*)

### <a id='use-custom-permission-policy'></a> Use custom permission policy

The current release of the permission framework does not allow the permission policy to be modified in the Tanzu Application Platform GUI. However, you may replace the built-in permission policy with your custom one when creating a new portal using the Tanzu Portal Builder tool. For more information, please refer to [Add custom permission policy to your portal](link-to-tpb-docs).

<!-- The following section should go into the TPB docs -->

#### Create custom policy

In your custom TPB plugin, create a [custom permission policy](https://backstage.io/docs/permissions/writing-a-policy).
For example:

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

This example permission policy would allow access to view all catalog entities, but will deny all
delete requests.

#### Set custom policy on the permission policy surface

Once you have your custom permission policy created, you may set it on the `PermissionPolicySurface`.
Please note that there can only be one permission policy applied, otherwise you will see an error at
build time.

```typescript
export const CustomPermissionPolicyPlugin: BackendPluginInterface =
  () => surfaces => {
    surfaces.applyTo(PermissionPolicySurface, surface => {
      surface.set(new CustomPermissionPolicy());
    });
  };
```
