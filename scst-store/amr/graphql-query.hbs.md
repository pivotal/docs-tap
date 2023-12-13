# Run query with GraphQL

This topic tells you how to connect to the GraphQL playground and how to run some queries.

## <a id='connecting-to-graphql'></a> Connect to AMR GraphQL

There are two ways you can perform GraphQL queries:

- Using the GraphQL playground
- Using [curl](https://curl.se/)

VMware recommends enabling ingress. The Supply Chain Security
Tools for Tanzu – Store and Artifact Metadata Repository (AMR) packages share
the same ingress configuration. For information about enabling ingress,
see [Ingress support for Supply Chain Security Tools - Store](../ingress.hbs.md).

### <a id='amr-graphql-access-token'></a> Retrieve the AMR GraphQL Access Token

When you access the AMR GraphQL using the GraphQL playground or curl, you
must retrieve the access token.

To fetch the token, run:

```console
kubectl -n metadata-store get secret amr-graphql-view-token -o json | jq -r ".data.token" | base64 -d
```

### <a id='connect-graphql-pg'></a> Connect to AMR GraphQL playground

To connect to the AMR GraphQL playground when you enabled ingress, visit
`https://amr-graphql.INGRESS-DOMAIN/play`.

Where `INGRESS-DOMAIN` is the domain of the ingress you want to use.

In the **Headers** tab at the bottom of the query window, add a JSON block containing the following authentication header:

```json
{
  "Authorization": "Bearer ACCESS-TOKEN"
}
```

Where `ACCESS-TOKEN` is the AMR GraphQL access token.

You can use this to write and execute your own GraphQL queries to fetch data from the AMR.

### <a id='connect-to-graphql-curl'></a> Connect to AMR GraphQL through curl

To connect to the AMR GraphQL using curl when you enabled ingress, you first need the AMR GraphQL
access token and its CA certificate.

To fetch the AMR GraphQL CA certificate:

```console
kubectl get secret amr-app-tls-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > /tmp/graphql-ca.crt
```

After the token and certificate are retrieved, you can use curl to perform GraphQL queries by using the
`https://amr-graphql.INGRESS-DOMAIN/query` endpoint.

Where `INGRESS-DOMAIN` is the domain of the ingress you want to use.

For example:

```console
curl "https://amr-graphql.<ingress-domain>/query" \
  --cacert /tmp/graphql-ca.crt \
  -H "Authorization: Bearer ACCESS-TOKEN" \
  -H 'accept: application/json' \
  -H 'content-type: application/json' \
  --data-raw '{"query":"query getAppAcceleratorRuns { appAcceleratorRuns(first: 250){ nodes { guid name namespace timestamp } pageInfo{ endCursor hasNextPage } } }"}' | jq .
```

Where:

- `ACCESS-TOKEN` is the AMR GraphQL access token
- `/tmp/graphql-ca.crt` is the file location containing the AMR GraphQL CA certificate

You can use this to write and execute your own GraphQL queries to fetch data from the AMR.

This section uses curl to query the AMR GraphQL endpoint, but you can use other similar tools to access the endpoint
and provide them with the AMR GraphQL access token and CA certificate.

## <a id='query-app-accel-runs'></a> Query for AppAcceleratorRuns (alpha)

This section tells you about GraphQL query arguments, and lists the fields available for `AppAcceleratorRuns` and `AppAcceleratorFragments`.

### <a id='app-accel-query-args'></a> AppAcceleratorRuns query arguments

(Optional) You can specify the following supported arguments when querying for `AppAcceleratorRuns`.

- `query`: expects an object that specifies additional arguments to query. The following arguments are supported in this query object:

- `guid`: UID identifying the run, as a `String` value. Each AppAcceleratorRun is automatically assigned a UID.

  For example:

  ```graphql
  appAcceleratorRuns(query:{guid: "d2934b09-5d4c-45da-8eb1-e464f218454e"})
  ```

- `source`: string representing the client used to run the accelerator. Supported values include `TAP-GUI`, `VSCODE`, and `INTELLIJ`.

  For example:

  ```graphql
  appAcceleratorRuns(query:{source: "TAP-GUI"})
  ```

- `username`: string representing the user name of the person who runs
the accelerator, as captured by the client UI.
  For example:

  ```graphql
  appAcceleratorRuns(query:{username: "homer.simpson"})
  ```

- `namespace` and `name`: strings representing the accelerator that
was used to create an application.
  For example:

  ```graphql
  appAcceleratorRuns(query:{name: "tanzu-java-web-app"})
  ```

- `appAcceleratorRepoURL`, `appAcceleratorRevision`, and `appAcceleratorSubpath`: actual location in VCS (Version Control System) about the accelerator sources used.
  For example:

  ```graphql
  appAcceleratorRuns(query:{
    appAcceleratorRepoURL: "https://github.com/vmware-tanzu/application-accelerator-samples.git",
    appAcceleratorRevision: "v1.6"
  })
  ```

- `timestamp`: string representation of the exact time the accelerator ran. You can query for runs that happened `before` or `after` a particular instant:
  For example:

  ```graphql
  appAcceleratorRuns(query: {timestamp: {after: "2023-10-11T13:40:46.952Z"}})
  ```

### <a id='app-accel-runs-fields'></a> AppAcceleratorRuns fields

You can choose the following fields to return in the GraphQL query.
See the section above for details about those fields.
You must specify at least one field.

- `guid`: UID identifying the run
- `source`: string representing the client used to run the accelerator
- `username`: string representing the user name of the person who ran
  the accelerator
- `namespace` and `name`: strings representing the accelerator which
  was used to create an application
- `appAcceleratorRepoURL`, `appAcceleratorRevision`, and `appAcceleratorSubpath`: actual location in VCS of the sources of the
  accelerator used
- `appAcceleratorSource`: VCS information of the sources of the accelerator used, but navigable as a
  commit.
- `timestamp`: the exact time the accelerator was run
- `appAcceleratorFragments`: a one-to-many container of nodes representing the fragment versions used in each AppAcceleratorRun. Those fragment nodes share many of the fields with AppAcceleratorRun, with the same semantics but applied to the particular fragment. Those include:
  - `namespace` and `name`: strings representing the identity of the fragment
  - `appAcceleratorFragmentSourceRepoURL` , `appAcceleratorFragmentSourceRevision`, and  `appAcceleratorFragmentSourceSubpath`: actual location in VCS of the sources of the fragment used
  - `appAcceleratorFragmentSource`: VCS information of the sources of the fragment, but navigable as a commit.

### <a id='sample-app-accel-query'></a> Sample Application Accelerator queries

- Get the list of all Application Accelerator runs, with the fragments used for each.

  ```graphql
    query getAllAcceleratorRuns {
      appAcceleratorRuns {
        nodes {
          name
          appAcceleratorFragments {
            nodes {
              name
            }
          }
        }
      }
    }
  ```
