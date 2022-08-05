# Customizing the Support menu

This topic describes how to customize the support menu.


## <a id="overview"></a> Overview

Many important pages of Tanzu Application Platform GUI have a **Support** button that displays a
pop-out menu.
This menu contains a one-line description of the page the user is looking at, and a list of support
item groupings. For example, the default menu on the Catalog page looks similar to the following image:

![Support menu](../images/support-menu.png)

As standard, there are two support item groupings:

* Contact Support, which is marked with an **email** icon and contains a link to
  VMware Tanzu's support portal.
* Documentation, which is marked with a **docs** icon and contains a link to the
  Tanzu Application Platform documentation that you are currently reading.


## <a id="customizing"></a> Customizing

The set of support item groupings is completely customizable. However, you might
want to offer custom in-house links for your Tanzu Application Platform users rather than simply
sending them to VMware support and documentation. You can provide this
configuration by using your `tap-values.yaml`.
Here is a configuration snippet, which produces the default support menu:

```yaml
tap_gui:
  app_config:
    app:
      support:
        url: https://tanzu.vmware.com/support
        items:
          - title: Contact Support
            icon: email
            links:
              - url: https://tanzu.vmware.com/support
                title: Tanzu Support Page
          - title: Documentation
            icon: docs
            links:
              - url: https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/index.html
                title: Tanzu Application Platform Documentation
```


## <a id="support-config-struct"></a> Structure of the support configuration


### <a id="url"></a> URL

The `url` field under the `support` section, for example,

```yaml
      support:
        url: https://tanzu.vmware.com/support
```

provides the address of the **contact support** link that appears on error
pages such as this one:

![Error Page](../images/error-page.png)


### <a id="items"></a> Items

The `items` field under the `support` section, for example,

provides the set of support item groupings to display when the support menu is expanded.


#### <a id="title"></a> Title

The `title` field on a support item grouping, for example,

```yaml
        items:
          - title: Contact Support
```

provides the label for the grouping.


#### <a id="icon"></a> Icon

The `icon` field on a support item grouping, for example,

```yaml
        items:
          - icon: email
```

provides the icon to use for that grouping. The valid choices are:

* `brokenImage`
* `catalog`
* `chat`
* `dashboard`
* `docs`
* `email`
* `github`
* `group`
* `help`
* `user`
* `warning`


#### <a id="links"></a> Links

The `links` field on a support item grouping, for example,

```yaml
        items:
          - links:
              - url: https://tanzu.vmware.com/support
                title: Tanzu Support Page
```

is a list of YAML objects that render as links.
Each link has the text given by the `title` field and links to the value of the `url` field.
