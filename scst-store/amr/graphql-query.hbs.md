# Run query with GraphQL

This topic tells you how to connect to the GraphQL playground and how to run some queries.

## <a id='connecting-to-graphql'></a> Connect to AMR GraphQL

There are two ways you can perform GraphQL queries:

- Use the GraphQL playground
- Use [curl](https://curl.se/)

Use the GraphQL playground
: Complete the following steps to perform GraphQL queries:
    1. Enable ingress. VMware recommends enabling ingress. The Supply Chain Security
       Tools for Tanzu – Store and Artifact Metadata Repository (AMR) packages share
       the same ingress configuration. For information about enabling ingress,
       see [Ingress support for Supply Chain Security Tools - Store](../ingress.hbs.md).
    1. Retrieve the access token. Run:

      ```console
      kubectl -n metadata-store get secret amr-graphql-view-token -o json | jq -r ".data.token" | base64 -d
      ```

    2. To connect to the AMR GraphQL playground, after enabling ingress, visit
    `https://amr-graphql.INGRESS-DOMAIN/play`.

        Where `INGRESS-DOMAIN` is the domain of the ingress you want to use.

    3. In the **Headers** tab at the bottom of the query window, add a JSON block containing the following authentication header:

        ```json
        {
          "Authorization": "Bearer ACCESS-TOKEN"
        }
        ```

        Where `ACCESS-TOKEN` is the AMR GraphQL access token.

      You can use this to write and execute your own GraphQL queries to fetch data from the AMR.

Use curl
: Write and execute GraphQL queries to fetch data from the AMR. This procedure uses
curl to query the AMR GraphQL endpoint, but you can use other similar tools to access the endpoint:

     1. Enable ingress. VMware recommends enabling ingress. The Supply Chain Security
    Tools for Tanzu – Store and Artifact Metadata Repository (AMR) packages share
    the same ingress configuration. For information about enabling ingress,
    see [Ingress support for Supply Chain Security Tools - Store](../ingress.hbs.md).
    1. To connect to the AMR GraphQL by using curl after you enable ingress, you first need the AMR GraphQL
    access token and its CA certificate. Run:

        ```console
        kubectl get secret ingress-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > /tmp/graphql-ca.crt
        ```

    1. After the token and certificate are retrieved, use curl to perform GraphQL queries. Run:

        ```console
        curl "https://amr-graphql.INGRESS-DOMAIN/query" \
          --cacert FILE-LOCATION \
          -H "Authorization: Bearer ACCESS-TOKEN" \
          -H 'accept: application/json' \
          -H 'content-type: application/json' \
          --data-raw '{"query":"query getAppAcceleratorRuns { appAcceleratorRuns(first: 250){ nodes { guid name namespace timestamp } pageInfo{ endCursor hasNextPage } } }"}' | jq .
        ```

        Where:
        - `INGRESS-DOMAIN` is the domain of the ingress you want to use.
        - `ACCESS-TOKEN` is the AMR GraphQL access token
        - `FILE-LOCATION` is the file containing the AMR GraphQL CA certificate, for example, `/tmp/graphql-ca.crt`

## <a id='query-app-accel-runs'></a> Query for AppAcceleratorRuns (alpha)

This section tells you about GraphQL query arguments, and lists the fields available for
`AppAcceleratorRuns` and `AppAcceleratorFragments`.

### <a id='app-accel-query-args'></a> (Optional) AppAcceleratorRuns query arguments

You can specify the following supported arguments when querying for `AppAcceleratorRuns`. `query`
expects an object that specifies additional arguments to query. You must specify at least one field.
You can choose the following fields to return in the GraphQL query.

- `guid`: UID identifying the run, as a string value. Each AppAcceleratorRuns is automatically assigned a UID.

  For example:

  ```graphql
  appAcceleratorRuns(query:{guid: "d2934b09-5d4c-45da-8eb1-e464f218454e"})
  ```

- `source`: String representing the client used to run the accelerator. Supported values include `TAP-GUI`, `VSCODE`, and `INTELLIJ`.

  For example:

  ```graphql
  appAcceleratorRuns(query:{source: "TAP-GUI"})
  ```

- `username`: String representing the user name of the person who runs
the accelerator, as captured by the client UI.
  For example:

  ```graphql
  appAcceleratorRuns(query:{username: "test.user"})
  ```

- `namespace` and `name`: Strings representing the accelerator that
was used to create an application.
  For example:

  ```graphql
  appAcceleratorRuns(query:{name: "tanzu-java-web-app"})
  ```

- `appAcceleratorRepoURL`, `appAcceleratorRevision`, and `appAcceleratorSubpath`: Location in VCS (Version Control System) of the accelerator sources used.
  For example:

  ```graphql
  appAcceleratorRuns(query:{
    appAcceleratorRepoURL: "https://github.com/vmware-tanzu/application-accelerator-samples.git",
    appAcceleratorRevision: "v1.6"
  })
  ```

- `timestamp`: String representation of the exact time the accelerator ran. You can query for runs that happened `before` or `after` a particular instant:
  For example:

  ```graphql
  appAcceleratorRuns(query: {timestamp: {after: "2023-10-11T13:40:46.952Z"}})
  ```

### <a id='app-accel-runs-fields'></a> AppAcceleratorRuns fields

You can choose the following fields to return in the GraphQL query.
See the section above for details about those fields.
You must specify at least one field.

- `guid`: UID identifying the run
- `source`: String representing the client used to run the accelerator
- `username`: String representing the user name of the person who ran
  the accelerator
- `namespace` and `name`: Strings representing the accelerator which
  was used to create an application
- `appAcceleratorRepoURL`, `appAcceleratorRevision`, and `appAcceleratorSubpath`: actual location in VCS of the sources of the
  accelerator used
- `appAcceleratorSource`: VCS information of the sources of the accelerator used, but navigable as a
  commit.
- `timestamp`: the exact time the accelerator was run
- `appAcceleratorFragments`: a one-to-many container of nodes representing the fragment versions used in each `AppAcceleratorRuns`. Those fragment nodes share many of the fields with `AppAcceleratorRuns`, with the same semantics but applied to the particular fragment. Those include:
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
