# Discover AppSSO service offerings

The recommendation is to consume AppSSO with [Services
Toolkit](../../services-toolkit/about.hbs.md) by claiming credentials for an
AppSSO service. Curation of service offerings is the purview of [service
operators](../service-operators/index.hbs.md).

You can discover the available service offerings with the `tanzu` CLI:

```shell
tanzu services classes list
```

You will be presented list of services you can claim credentials for. The
output may look something like this:

```plain
❯ tanzu services classes list
  NAME                  DESCRIPTION
  mysql-unmanaged       MySQL by Bitnami
  postgresql-unmanaged  PostgreSQL by Bitnami
  rabbitmq-unmanaged    RabbitMQ by Bitnami
  redis-unmanaged       Redis by Bitnami
  sso                   Login by AppSSO - LDAP
  sso-demo              Login by AppSSO - user:password - UNSAFE FOR PRODUCTION!
```

By looking at the `DESCRIPTION` we can identify two of the services as AppSSO;
`sso` and `sso-demo`.

