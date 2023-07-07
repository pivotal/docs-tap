# AMR GraphQL Querying

This page contains information on how to connect to the GraphQL playground, and how to query each supported data model.
See [AMR Data Models](data-model-and-concepts.hbs.md) for more information on the AMR data models.

## <a id='connecting-to-graphql'></a> Connecting to GraphQL Playground

The recommended configuration is to enable ingress. The Supply Chain Security Tools for Tanzu – Store and Artifact Metadata Repository (AMR) packages share the same ingress configuration. 
As such setting `ingress_domain` for the SCST - Store will apply the same value for the AMR.
To connect to the AMR GraphQL playground when ingress is enabled, go to `https://artifact-metadata-repository.<ingress-domain>/play`.
On this page, users can write and execute their own GraphQL queries to fetch data from the AMR.

## <a id='query-locations'></a> Querying for Locations

This section provides details on the GraphQL query arguments, and the list of fields available for `Location`.

### <a id='location-query-args'></a> Locations Query Arguments

Below are the supported arguments that users can specify when querying for `Location`. They are all optional.

- `query`: expects an object that specifies additional arguments used to query, supported arguments in this query object are listed below
  
  - `alias`: human-readable identifier of the location, `String` value. By default, a location's `alias` is set to be the same as the `reference`. It is also configurable by the user, see [AMR Configuration](configuration.hbs.md)
    
    Example:
    ```
    locations(query:{alias: "test-cluster"})
    ```
    
  - `reference`: string UID representing the location, `String` value. A location's `reference` is automatically set to be the `kube-system` namespace UID by the AMR, it is not configurable by the user.
  
    Example:
    ```
    locations(query:{reference: "f4f63c6a10ed7cfb06dfb03c2b2d6a9d5bbe95931c71f8cb346fd2284b1e5d82"})
    ```
    
  - `labels`: specify labels the location must contain, expects a list of labels. 
    A label has `key` and `value` fields of `String` type, at least one of those fields must be provided when querying with labels. 
  
    >**Note** The result will return locations that have `all` given labels (i.e. this is an `AND` operation).
  
    Example:
    ```
    locations(query:{ labels:[{value: "run"}, 
                              {key: "env"}, 
                              {key: "region", value: "east1b"} ]
    })
    ```

### <a id='location-fields'></a> Locations Fields

Below are fields that users can choose to return in the GraphQL query. At least one field needs to be specified.

- `alias`: human-readable identifier of the location
- `reference`: string UID representing the location
- `labels`: labels associated with the location, has the following fields
  - `key`: key of the label
  - `value`: value of the label
  
### <a id='sample-locations-query'></a> Sample Locations Queries

- Query for location with the `alias` `"test-cluster"`. 
  In the query results, return information on the `reference`, `alias`, and `labels` showing both `key` and `value`.
  ```
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
  
- Query for locations that contains two `labels`, one with `key` `"env"` and one `{key: "region", value: "east1b"}`.
  In the query results, return information on `alias` and `reference` only.
  ```
  query getLocationByLabel {
    locations(query:{labels:[{key: "env"}, 
                              {key: "region", value: "east1b"} ]
    }) {
      reference
      alias
    }
  }
  ```

## <a id='query-apps'></a> Querying for Apps

This section provides details on the GraphQL query arguments, and the list of fields available for `Apps`.

### <a id='apps-query-args'></a> Apps Query Arguments

Below are the supported arguments that users can specify when querying for `Apps`. They are all optional.

- `latest`: When set to true, it returns the latest result from the given query. When set to false, it returns all results from the given query. 
  When not specified, it defaults to false. This field is a `Boolean` value.
  
  Example:
  ```
  apps(latest: true)
  ```

- `query`: expects an object that specifies additional arguments used to query, supported arguments in this query object are listed below
  
  - `name`: the name of the app, `String` value
    
    Example:
    ```
    apps(query: {name: "my-app"})
    ```
    
  - `namespace`: the namespace where the app is deployed, `String` value
    
    Example:
    ```
    apps(query: {namespace: "dev-namespace"})
    ```
    
  - `location`: the location where the app is deployed, expects a location query object as described in the section above (see [Location Query Arguments](#location-query-args))

    >**Note** Currently `alias` is the only supported field for `location` when querying for `apps`. The other location fields are available in the schema but have no effect.

    Example:
    ```
    apps(query: {location: {alias: "test-cluster"}})
    ```
    
  - `order`: order results by a specified `field` in a given `direction`, expects a key-value list to specify the `field` and `direction`. 
    >**Note** Currently the only supported `field` is `timestamp`, with directions `ASC` or `DESC`.
    
    Example:
    ```
    apps(query: {order: {
                          field: timestamp,
                          direction: DESC
                        }
    })
    ```
    
  - `timestamp`: return results only in the given time range, expects a key-value list with the `before` and `after` timestamps that define the time range.
    >**Note** Timestamps must be in ISO_8601 format
    
    Example:
    ```
    apps(query: {timestamp: {
                              before: "2022-11-29T16:21:35-05:00",
                              after: "2022-11-27T16:21:35-05:00"
                            }
    })
    ```

### <a id='apps-fields'></a> Apps Fields

Below are fields that users can choose to return in the GraphQL query. At least one field needs to be specified.

- `name`: name of the app
- `namespace`: namespace the app is deployed in
- `imageUrl`: image url of the app
- `imageDigest`: image digest of the app
- `status`: status of the app, such as `Created`, `Available`, `Deleted` etc.
- `instances`: number of instances of the app, i.e. number of pods deployed
- `timestamp`: timestamp of when the event occurred to the app, in ISO_8601 format
- `location`: location of the app, see [Location Fields](#location-fields) for details on attributes to specify here.

### <a id='sample-apps-query'></a> Sample Apps Queries

- Query for the `latest` information for all apps.
  In the query results, return information on `name`, `namespace`, `imageUrl`, `imageDigest`, `instances`, `status`, and `timestamp` for each app.
  ```
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
  In the query results, return information on `imageUrl`, `imageDigest`, `instances`, `status`, and `timestamp`. 
  Also return information of the `location` of the app, including the `alias` and `key` `value` of the `labels`.
  ```
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
  
- Query for app history the app named `"my-app"` in the `location` with `alias` `"test-cluster"`, order results in `descending` order.
  In the query results, return information on `name`, `namespace`, `imageUrl`, `imageDigest`, `instances`, and `status`.
  ```
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

- Query for information on the app named `"my-app"` in the `location` with `alias` `"test-cluster"`, within a specific time range.
  In the query results, return information on `name`, `namespace`, `imageUrl`, `imageDigest`, `instances`, and `status`.
  Also return information of the `location` of the app, including the `alias` and `key` `value` of the `labels`.
  ```
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

## <a id='addition-resources'></a> Additional Resources

- [AMR Data Models](data-model-and-concepts.hbs.md)
