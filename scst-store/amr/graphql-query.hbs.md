# AMR GraphQL Querying

This topic tells you how to connect to the GraphQL playground and how to query each supported data model.
For information about the AMR data models, see [AMR Data Models](data-model-and-concepts.hbs.md).

## <a id='connecting-to-graphql'></a> Connecting to AMR GraphQL

There are two ways you can perform GraphQL queries:

- Using the GraphQL playground
- Using [cURL](https://curl.se/)

VMware recommends enabling ingress. The Supply Chain Security
Tools for Tanzu – Store and Artifact Metadata Repository (AMR) packages share
the same ingress configuration. For more information about enabling ingress, 
see [Ingress support for Supply Chain Security Tools - Store](../ingress.hbs.md)

### <a id='amr-graphql-access-token'></a> Retrieving the AMR GraphQL Access Token

Whichever method you choose to access the AMR GraphQL, you first need to retrieve the
access token.

Use the following command to fetch the token:

```console
kubectl -n metadata-store get secret amr-graphql-view-token -o json | jq -r ".data.token" | base64 -d
```

### <a id='connecting-to-graphql-playground'></a> Connecting to AMR GraphQL playground

To connect to the AMR GraphQL playground when ingress is enabled, go to
`https://amr-graphql.<ingress-domain>/play`. 

Look for the Headers tab at the bottom of the query window and add a JSON block containing the auth header 
in the following format:

```json
{
  "Authorization": "Bearer ACCESS-TOKEN"
}
```

where:

- `ACCESS-TOKEN` is the AMR GraphQL access token

You can use this to write and execute your own GraphQL queries to fetch data from the AMR.

### <a id='connecting-to-graphql-curl'></a> Connecting to AMR GraphQL through cURL

To connect to the AMR GraphQL using cURL when ingress is enabled, you first need the AMR GraphQL
access token as well as its CA certificate.

Use the following command to fetch the AMR GraphQL CA certificate:

```console
kubectl get secret amr-app-tls-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > /tmp/graphql-ca.crt
```

Once the token and certificate are retrieved, you can use cURL to perform GraphQL queries through the 
`https://amr-graphql.<ingress-domain>/query` endpoint.

For example:

```console
curl "https://amr-graphql.<ingress-domain>/query" \
  --cacert /tmp/graphql-ca.crt \
  -H "Authorization: Bearer ACCESS-TOKEN" \
  -H 'accept: application/json' \
  -H 'content-type: application/json' \
  --data-raw '{"query":"query getAppAcceleratorRuns { appAcceleratorRuns(first: 250){ nodes { guid name namespace timestamp } pageInfo{ endCursor hasNextPage } } }"}' | jq .
```

where:

- `ACCESS-TOKEN` is the AMR GraphQL access token
- `/tmp/graphql-ca.crt` is the file location containing the AMR GraphQL CA certificate

You can use this to write and execute your own GraphQL queries to fetch data from the AMR.

Though this section used cURL to query through the AMR GraphQL endpoint, you can use other similar tools to access the endpoint 
and provide them with the AMR GraphQL access token and CA certificate.

## <a id='query-locations'></a> Querying for locations

This section tells you about GraphQL query arguments, and the list of fields available for `Location`.

### <a id='location-query-args'></a> Locations query arguments

You can specify the following supported arguments when querying for `Location`. They are all optional.

- `query`: expects an object that specifies additional arguments used to query. The following arguments are supported in this query object:
    
  - `reference`: string UID representing the location, as a `String` value. A location's `reference` is automatically set to be the `kube-system` namespace UID by the AMR. It is not configurable by the user.
  
    For example:
    
    ```console
    locations(query:{reference: "f4f63c6a10ed7cfb06dfb03c2b2d6a9d5bbe95931c71f8cb346fd2284b1e5d82"})
    ```
    
  - `labels`: specify labels the location must contain. Expects a list of labels. 
    A label has `key` and `value` fields of `String` type, at least one of those fields must be provided when querying with labels. 
  
    >**Note** The result returns locations that have `all` given labels (i.e. this is an `AND` operation).
  
    For example:
    
    ```console
    locations(query:{ labels:[{value: "run"}, 
                              {key: "env"}, 
                              {key: "region", value: "east1b"} ]
    })
    ```

### <a id='location-fields'></a> Locations fields

Users can choose the following felids to return in the GraphQL query. At least one field must be specified.

- `reference`: string UID representing the location
- `labels`: labels associated with the location, has the following fields
  - `key`: key of the label
  - `value`: value of the label
  
### <a id='sample-locations-query'></a> Sample locations queries

- Query for location with the `reference` `"test-cluster"`. 
  The query results return information about the `reference` and `labels` showing both `key` and `value`.
  
  ```console
  query getLocationByReference {
    locations(query:{reference: "test-cluster"}) {
      reference
      labels {
        key
        value
      }
    }
  }
  ```
  
- Query for locations that contain two `labels`, one with `key` `"env"` and one `{key: "region", value: "east1b"}`.
  The query results return information about `reference` only.
  
  ```console
  query getLocationByLabel {
    locations(query:{labels:[{key: "env"}, 
                              {key: "region", value: "east1b"} ]
    }) {
      reference
    }
  }
  ```

## <a id='addition-resources'></a> Additional resources

- [AMR Data Models](data-model-and-concepts.hbs.md)
