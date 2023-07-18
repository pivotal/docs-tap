# AMR GraphQL Querying

This topic tells you how to connect to the GraphQL playground and how to query each supported data model.
For information about the AMR data models, see [AMR Data Models](data-model-and-concepts.hbs.md).

## <a id='connecting-to-graphql'></a> Connecting to GraphQL playground

Vmware recommends enabling ingress. The Supply Chain Security
Tools for Tanzu – Store and Artifact Metadata Repository (AMR) packages share
the same ingress configuration. Setting `ingress_domain` for the SCST -
Store applies the same value for AMR. To connect to the AMR GraphQL playground
when ingress is enabled, go to
`https://artifact-metadata-repository.<ingress-domain>/play`. You can use this to write and
execute your own GraphQL queries to fetch data from the AMR.

## <a id='query-locations'></a> Querying for locations

This section tells you about GraphQL query arguments, and the list of fields available for `Location`.

### <a id='location-query-args'></a> Locations query arguments

You can specify the following supported arguments when querying for `Location`. They are all optional.

- `query`: expects an object that specifies additional arguments used to query. The following arguments are supported in this query object:
  
  - `alias`: human-readable identifier of the location, as a `String` value. By default, a location's `alias` is set to be the same as the `reference`. It is configurable by the user, see [AMR Configuration](configuration.hbs.md).
    
    For example:
    
    ```
    locations(query:{alias: "test-cluster"})
    ```
    
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

- `alias`: human-readable identifier of the location
- `reference`: string UID representing the location
- `labels`: labels associated with the location, has the following fields
  - `key`: key of the label
  - `value`: value of the label
  
### <a id='sample-locations-query'></a> Sample locations queries

- Query for location with the `alias` `"test-cluster"`. 
  The query results return information about the `reference`, `alias`, and `labels` showing both `key` and `value`.
  
  ```console
  query getLocationByAlias {
    locations(query:{alias: "test-cluster"}) {
      reference
      alias
      labels {
        key
        value
      }
    }
  }
  ```
  
- Query for locations that contain two `labels`, one with `key` `"env"` and one `{key: "region", value: "east1b"}`.
  The query results return information about `alias` and `reference` only.
  
  ```console
  query getLocationByLabel {
    locations(query:{labels:[{key: "env"}, 
                              {key: "region", value: "east1b"} ]
    }) {
      reference
      alias
    }
  }
  ```

## <a id='query-apps'></a> Querying for apps

This section provides details about the GraphQL query arguments, and the list of fields available for `Apps`.

### <a id='apps-query-args'></a> Apps query arguments

You can specify the following supported arguments when querying for `Apps`. They are all optional.

- `latest`: When set to true, it returns the latest result from the given query. When set to false, it returns all results from the given query. 
  By default, it is false when not specified. This field is a `Boolean` value.
  
  For example:
  
  ```console
  apps(latest: true)
  ```

- `query`: expects an object that specifies additional arguments used to query. The following arguments are supported in this query object:
  
  - `name`: the name of the app. `String` value.
    
    For example:
    
    ```
    apps(query: {name: "my-app"})
    ```
    
  - `namespace`: the namespace where the app is deployed. `String` value.
    
    For example:
    
    ```console
    apps(query: {namespace: "dev-namespace"})
    ```
    
  - `location`: the location where the app is deployed. Expects a location query object. See [Location Query Arguments](#location-query-args).

    >**Note** `alias` is the only supported field for `location` when querying for `apps`. The other location fields are available in the schema but have no effect.

    For example:
    
    ```console
    apps(query: {location: {alias: "test-cluster"}})
    ```
    
  - `order`: order results by a specified `field` in a `direction`. Expects a key-value list to specify the `field` and `direction`. 
    >**Note** The only supported `field` is `timestamp`, with directions `ASC` or `DESC`.
    
    For example:
    
    ```console
    apps(query: {order: {
                          field: timestamp,
                          direction: DESC
                        }
    })
    ```
    
  - `timestamp`: return results only in the given time range. Expects a key-value list with the `before` and `after` timestamps that define the time range.
    >**Note** Timestamps must be in ISO_8601 format
    
    For example:
    
    ```console
    apps(query: {timestamp: {
                              before: "2022-11-29T16:21:35-05:00",
                              after: "2022-11-27T16:21:35-05:00"
                            }
    })
    ```

### <a id='apps-fields'></a> Apps fields

Users can choose to return the following felids in the GraphQL query. You must specify at least one field.

- `name`: name of the app
- `namespace`: namespace the app is deployed in
- `imageUrl`: image URL of the app
- `imageDigest`: image digest of the app
- `status`: status of the app, such as `Created`, `Available`, `Deleted`.
- `instances`: number of instances of the app. For example, the number of pods deployed.
- `timestamp`: timestamp of when the event occurred to the app, in ISO_8601 format
- `location`: location of the app, see [Location Fields](#location-fields) for details about attributes to specify here.

### <a id='sample-apps-query'></a> Sample apps queries

- Query for the `latest` information for all apps.
  The query results return information about `name`, `namespace`, `imageUrl`, `imageDigest`, `instances`, `status`, and `timestamp` for each app.
  
  ```console
  query getLatestAppStatus {
    apps(latest: true) {
      name
      namespace
      imageUrl
      imageDigest
      instances
      status
      timestamp
    }
  }
  ```
  
- Query for the `latest` information for app with the `name` `"my-app"` in `namespace` `"dev-ns"`.
  The query results return information about `imageUrl`, `imageDigest`, `instances`, `status`, and `timestamp`. 
  Also return information of the `location` of the app, including the `alias` and `key` `value` of the `labels`.
  
  ```console
  query getLatestAppStatus {
    apps(latest: true, query: { name: "some-app-1",
                                namespace: "dev-ns"
    }) {
    location {
      alias
      labels {
        key
        value
      }
    }
    imageUrl
    imageDigest
    instances
    status
    timestamp
    }
  }
  ```
  
- Query for app history the app named `"my-app"` in the `location` with `alias` `"test-cluster"`, order causes `descending` order.
  The query results return information about `name`, `namespace`, `imageUrl`, `imageDigest`, `instances`, and `status`.
  
  ```console
  query getHistoryOfApp {
    apps(query: { name: "my-app",
                  location: {alias: "test-cluster"},
                  order: {
                    field: timestamp,
                    direction: DESC
                  }
    }) {
    name
    namespace
    imageUrl
    imageDigest
    instances
    status
    }
  }
  ```

- Query for information about the app named `"my-app"` in the `location` with `alias` `"test-cluster"`, in a specific time range.
  The query results return information about `name`, `namespace`, `imageUrl`, `imageDigest`, `instances`, and `status`.
  Also return information of the `location` of the app, including the `alias` and `key` `value` of the `labels`.
  
  ```console
  query getAppWithTimerange {
    apps(query: { name: "my-app",
                  location: {alias: "test-cluster"},
                  timestamp: {
                    before: "2023-06-15T06:47:25Z",
                    after: "2023-05-12T18:30:17Z"
                  }
    }) {
    location {
      alias
      labels {
        key
        value
      }
    }
    name
    namespace
    imageUrl
    imageDigest
    instances
    status
    }
  }
  ```

## <a id='addition-resources'></a> Additional resources

- [AMR Data Models](data-model-and-concepts.hbs.md)
