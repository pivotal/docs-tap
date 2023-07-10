# Set up permission framework for your Tanzu Developer Portal

This topic gives you an overview of the Backstage permission framework and tells you how to enable
it for Tanzu Developer Portal (formerly called Tanzu Application Platform GUI). For more information, see the
[Backstage documentation](https://backstage.io/docs/permissions/overview/).

> **Caution** The permission framework functions are in alpha. It is not recommended for use in
> production environment. For more information, see <!-- Insert xref -->.

## <a id='permission-overview'></a> Overview of the permission framework

The permission framework enables Tanzu Application Platform operators to enforce policies that limit
visibility of certain parts of Tanzu Developer Portal.

The current release features the alpha version of this function and only applies to the
Software Catalog entities. `owner-of` is the only policy available and it is embedded in the GUI.

`owner-of` enables the operator to define which admin groups and users have unrestricted visibility
of the Software Catalog entities. If a user is not listed as an admin or part of the admin group,
that user can see only the Software Catalog entities that are owned by their teams.

> **Important** The permission framework is deactivated by default.

## <a id='enable-permission'></a> Enable the permission framework

To enable the permission framework and limit Software Catalog entities' visibility to owners,
allowlist users, allowlist groups, and catalog admins, add the following parameters to the
`tap_gui.app_config` section:

```yaml
permission:
  enabled: true
  adminRefs:
    - user:NAMESPACE/NAME
    - group:NAMESPACE/NAME
```

Where:

- `NAMESPACE` is usually `default` unless defined otherwise in the definition file
- `NAME` is the name of the group or user

The `adminRefs` section lists all users and groups to grant access to. Each user and group is defined
by the `NAMESPACE` and the `NAME`.

You can view your user entity in the `Settings`/`General` section in your Tanzu Application Platform
GUI, or in the YAML definition file of the user or group.

For example:

```yaml
- user:default/admin
- group:test-namespace/operators
```

After you have updated your configuration file, reinstall your Tanzu Developer Portal package
by following the steps in [Upgrade Tanzu Application Platform](../../upgrading.hbs.md).

After the updated values configuration file is applied in Tanzu Developer Portal, the
permission framework is enabled.

> **Important** After the permission framework is enabled, all Software Catalog entities without
> proper annotations are invisible to all users except admins.

## <a id='enable-visibility'></a> Enable catalog entity visibility

With the permission framework enabled, annotate entities in your Software Catalog to make the
relevant users or groups, who are not the owner of the entity, visible.
To do this, add annotations to the `metadata.annotations` section of the entity's definition file:

```yaml
metadata:
  annotations:
    backstage.tanzu.vmware.com/GROUP-OR-USER.NAMESPACE.NAME: 'COMMA-SEPARATED-PERMISSIONS'
```

Where:

- `GROUP-OR-USER` is either a `group` to describe a group or a `user` to describe an individual user
- `NAMESPACE` is the namespace that the group or user is attributed to. If this value is not
  specified, it is `default`.
- `NAME` is the name of the user or group
- `COMMA-SEPARATED-PERMISSIONS` is the list of comma-delimited permissions for the specified user or
  group. Valid catalog entity permissions include:
  - `catalog.entity.read`
  - `catalog.entity.update`
  - `catalog.entity.delete`

> **Note** `catalog.entity.create` is another permission that is valid for the permission framework,
> but it is not meaningful for the Software Catalog entities that have already been created.

You can add several groups or users by adding new annotations with their respective comma-delimited
permissions, for example:

```yaml
metadata:
  annotations:
    backstage.tanzu.vmware.com/user.default.user-a: 'catalog.entities.read'
    backstage.tanzu.vmware.com/user.default.user-b: 'catalog.entities.read,catalog.entities.update'
```

For example, this annotation enables users that are part of `group-a` to read and delete
`component-a`:

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: component-a
  annotations:
    backstage.tanzu.vmware.com/group.test-namespace.group-a: 'catalog.entity.read, catalog.entity.delete'
```

If a group is granted ownership or access to an entity, all users within that group automatically
inherit the same access. But it does not work for nested group ownerships, when a group is listed as
a member of another group.

> **Caution** When the permission plug-in is turned on with the default permission policy, API Auto
> Registration <!-- link to component description --> no longer works due to the lack of user
> identities.
> Requests against the Catalog API will no longer work as before. For more information, see the
> [known issues in the release notes](../../release-notes.hbs.md#1-6-1-tap-gui-ki).
