# Supply Chain Security Tools - Store Database Index Corruption 

This topic contains ways you can troubleshoot and fix the Metadata Store Database index issue after upgrading from version 1.5 to a higher version for Supply Chain Security Tools (SCST) - Store.

The index corruption happened due to a base OS upgrade in our Postgres Database images to address some of the CVE which includes a breaking change in `glibc locale` library.

1. TAP version 1.5 and before: `Postgres-bionic-13:1.22.0` uses `ubuntu:18.04` which includes `ubuntu/glibc 2.27-3ubuntu1.6`. 
2. TAP version 1.6 and later: `Postgres-bionic-13:1.23.0` uses `ubuntu:22.04`, `jammy, jammy-20221101`, latest which includes `ubuntu/glibc 2.35-0ubuntu3.1`. 

In `glibc version 2.28`, released 2018, included a major update to the locale data, which can potentially affect the data of many users. Because of the above reason indexes got corrupted after upgrade. You can read more about this on [wiki](https://wiki.postgresql.org/wiki/Locale_data_changes). Summary of changes are highlighted for quick reference.

## Database Index Corruption issue reported in Metadata Store App Container logs

### Symptom

The Metadata Store is unable to reconcile since the Metadata Store pod complaining about a potential database index corruption issue.

```console
kubectl logs metadata-store-app-pod_name -n metadata-store
```

#### Output:

```console
{“level”:“error”,“ts”:“2023-08-15T16:38:31.528115988Z”,“logger”:“MetadataStore”,“msg”:“unable to check index corruption since user is not a superuser to perform \“CREATE EXTENSION amcheck\“. Please create this extension and check for index corruption using following sql command \“SELECT bt_index_check(oid) FROM pg_class WHERE relname in (SELECT indexrelid::regclass::text FROM (SELECT indexrelid, indrelid, indcollation[i] coll FROM pg_index, generate_subscripts(indcollation, 1) g(i)) s JOIN pg_collation c ON coll=c.oid WHERE collprovider IN (‘d’, ‘c’) AND collname NOT IN (‘C’, ‘POSIX’));\“”,“hostname”:“metadata-store-app-77c9fb59c8-qplxt”}
{“level”:“error”,“ts”:“2023-08-15T16:38:31.528139637Z”,“logger”:“MetadataStore”,“msg”:“Found corrupted database indexes but unable to fix them”,“hostname”:“metadata-store-app-77c9fb59c8-qplxt”,“error”:“unable to check index corruption since user is not a superuser to perform \“CREATE EXTENSION amcheck\“. Please create this extension and check for index corruption using following sql command \“SELECT bt_index_check(oid) FROM pg_class WHERE relname in (SELECT indexrelid::regclass::text FROM (SELECT indexrelid, indrelid, indcollation[i] coll FROM pg_index, generate_subscripts(indcollation, 1) g(i)) s JOIN pg_collation c ON coll=c.oid WHERE collprovider IN (‘d’, ‘c’) AND collname NOT IN (‘C’, ‘POSIX’));\“”}
```

### <a id='db-index-corruption-solution'></a> Solutions

There are several ways to address this issue ranging from upgrading the TAP installation with updated schema values to connecting to the Postgres database directly and fixing the index manually. All the possible approaches are listed to help customers to return to stable.
    
1. Edit `auto_correct_db_indexes` property to true in `tap-values.yaml`
1. Connect to the Metadata Store database with the same account used by the Metadata Store API   
1. Connect to the Metadata Store database with a super user account and manually fix the index

#### 1. Edit `auto_correct_db_indexes` property to true in `tap-values.yaml`

 1. To change `auto_correct_db_indexes`, edit your `tap-values.yaml` and upgrade the Tanzu Application Platform profile. Change property `auto_correct_db_indexes` value to `true`.
 
 2. Upgrade Tanzu Application Platform

 ```console
 tanzu package installed update tap -p tap.tanzu.vmware.com -v {{ vars.tap_version }}  --values-file tap-values.yaml -n tap-install
 ```
 3. Check for Metadata Store API logs, you should not see any errors as highlighted in the symptoms section.

#### 2. Connect to the Metadata Store database with same account used by Metadata Store API 

 1. [Connect to the Postgres Database](./connect-to-database.hbs.md)
 2. Run this SQL to re-index individual tables
     
 ```console
 REINDEX TABLE  "artifact_groups";
 REINDEX TABLE  "artifact_group_images";
 REINDEX TABLE  "images";
 REINDEX TABLE  "sources";
 REINDEX TABLE  "source_images";
 REINDEX TABLE  "packages";
 REINDEX TABLE  "image_packages";
 REINDEX TABLE  "vulnerabilities";
 REINDEX TABLE  "package_vulnerabilities";
 REINDEX TABLE  "source_packages";
 REINDEX TABLE  "artifact_group_sources";
 REINDEX TABLE  "method_types";
 REINDEX TABLE  "ratings";
 REINDEX TABLE  "package_managers";
 REINDEX TABLE  "artifact_group_labels";
 REINDEX TABLE  "analysis_instances";
 REINDEX TABLE  "vulnerability_analyses";
 REINDEX TABLE  "reports";
 REINDEX TABLE  "report_ratings";
 REINDEX TABLE  "report_packages_vulnerabilities";
 REINDEX TABLE  "index_migration_statuses";
 ```

 3. Run following SQL
     
 ```console
 INSERT INTO index_migration_statuses (created_at, updated_at, "version", status) VALUES(now(), now(), version(), true)
 ```
 
 4. Check for Metadata Store API logs, you should not see any errors as highlighted in the symptoms section.

#### 3. Connect to the Metadata Store database with a super user account and manually fix the index

1. [Connect to the Postgres Database](./connect-to-database.hbs.md)
2. Install extension on Postgres Database
  
```console
CREATE EXTENSION amcheck
```

3. Run following SQL
  
```console
SELECT indexrelid::regclass::text FROM (SELECT indexrelid, indrelid, indcollation[i] coll FROM pg_index, generate_subscripts(indcollation, 1) g(i)) s JOIN pg_collation c ON coll=c.oid 
WHERE collprovider IN ('d', 'c') AND collname NOT IN ('C', 'POSIX');
```

4. Run this SQL when you see an error
  
```console
SELECT indexrelid::regclass::text FROM (SELECT indexrelid, indrelid, indcollation[i] coll FROM pg_index, generate_subscripts(indcollation, 1) g(i)) s JOIN pg_collation c ON coll=c.oid 
WHERE collprovider IN ('d', 'c') AND collname NOT IN ('C', 'POSIX');
```

5. Run below mentioned SQL if the above SQL results in an error
  
```console
REINDEX database "metadata-store"
```

6. Run following SQL
  
```console
INSERT INTO index_migration_statuses (created_at, updated_at, "version", status) VALUES(now(), now(), version(), true)
```

7. Check for Metadata Store API logs, you should not see any errors as highlighted in the symptoms section.