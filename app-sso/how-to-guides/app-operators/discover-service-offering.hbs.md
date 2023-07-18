# Discover Application Single Sign-On service offerings

This topic describes the recommended method for you to discover Application Single Sign-On service
offerings.

VMware recommends that you consume Application Single Sign-On by claiming credentials for an
Application Single Sign-On service using [Services Toolkit](../../../services-toolkit/about.hbs.md).
[Service operators](../../tutorials/service-operators/index.hbs.md) are responsible for curating
service offerings.

You can discover the available service offerings with the Tanzu Services CLI:

```console
tanzu services classes list
```

The output contains a list of services you can claim credentials for, for example:

```plain
$ tanzu services classes list
  NAME                  DESCRIPTION
  mysql-unmanaged       MySQL by Bitnami
  postgresql-unmanaged  PostgreSQL by Bitnami
  rabbitmq-unmanaged    RabbitMQ by Bitnami
  redis-unmanaged       Redis by Bitnami
  sso                   Login by AppSSO - LDAP
  sso-demo              Login by AppSSO - user:password - UNSAFE FOR PRODUCTION!
```

By looking at the `DESCRIPTION` you can identify two of the services as being for
Application Single Sign-On: `sso` and `sso-demo`.
