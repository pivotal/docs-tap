# Artifact Metadata Repository (AMR) data model and concepts

This topic tells you about data models used in the Artifact Metadata Repository (AMR).

## <a id='overview'></a> Overview

The following diagram shows the data models used in the AMR to store artifact information and the relationship between them.

![Diagram of the AMR Data Models](../images/amr-data-model.jpg)

## <a id='amr-data-models'></a> AMR data models

There are two types of data models in the AMR: 

- `Apps`
- `Locations`

### <a id='apps'></a> Apps

The `Apps` data model represents the information of an application, such as replicaset, at a point in time.
Cloud events sends this information to the AMR, so each entry represents the status of the app when an event occurred. See [cloud events](cloudevents.hbs.md).
These entries correspond to events, such as when an app is created, scaled up, running, scaled down or deleted.
This lets users see the history of their apps.

Each `Apps` data entry stores information about the associated location it was deployed in, details about the status, and what is deployed. See the diagram above for a list of all fields the data model stores.
You can only associate an `Apps` entry with one `Locations` entry. 
You can point multiple `Apps` entries to the same `Locations` entry. 
All `Apps` entries within a location are guaranteed to be unique, meaning that no two `Apps` entries in the same location can have identical values for all their fields.

### <a id='locations'></a> Locations

The `Locations` data model stores data about the locations that `Apps` are deployed on, like clusters.

- `reference`: unique reference to the location. It is automatically set to be the `kube-system` namespace UID by the AMR. This is not configurable by the user.
- `alias`: unique alias for the location. 
  By default, it is initialized with the value of the `reference`, but users have the option to configure it to a different value. See [AMR Configuration](configuration.hbs.md).
- `labels`: labels of the location. Users can add them by using tap values YAML file. See [AMR Configuration](configuration.hbs.md).