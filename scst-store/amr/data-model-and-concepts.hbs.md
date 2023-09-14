# Artifact Metadata Repository (AMR) data model and concepts

This topic tells you about data models used in the Artifact Metadata Repository (AMR).

## <a id='overview'></a> Overview

The following diagram shows the data models used in the AMR to store artifact information and the relationship between them.

![Diagram of the AMR Data Models](../images/amr-data-model.jpg)

## <a id='amr-data-models'></a> AMR data models

These are the data models stored in the AMR: 

- `Locations`
- `Containers`
- `Images`
- `Commits`
- `AppAcceleratorRuns`
- `AppAcceleratorFragments`
- `DoraMetrics`
- `DoraMetricsPerCorrelationID`

### <a id='locations'></a> Locations

The `Locations` data model stores data about the locations that `Apps` are deployed on, like clusters.

- `reference`: unique reference to the location. It is automatically set to be the `kube-system` namespace UID by the AMR. This is not configurable by the user.
- `labels`: labels of the location. Users can add them by using tap values YAML file. See [AMR Configuration](configuration.hbs.md).

### <a id='containers'></a> Containers

The `Containers` data model represents the information of a container which is a runtime information about an image. The Observer sends this information to the Cloud Event Handler, so each entry represents the state of the container when an event occurred. See [cloud events](cloudevents.hbs.md).
These entries correspond to events, such as when a container is running or terminated.
This lets users see the history of their containers.

Each `Container` data entry stores information about the associated location in which it was deployed, details about the state, and what image was used. See the diagram above for a list of all fields the data model stores.
You can only associate an `Containers` entry with one `Locations` entry. You can point multiple `Containers` entries to the same `Locations` entry. 

### <a id='images'></a> Images

The `Images` data model represents the information of an image which acts as a template for containers. The Observer sends this information to the Cloud Event Handler to store newly generate image. See [cloud events](cloudevents.hbs.md).

Each `Image` data entry stores information about the associated location in which it was deployed. See the diagram above for a list of all fields the data model stores.
You can only associate an `Images` entry with one `Locations` entry. You can point multiple `Images` entries to the same `Locations` entry. 

### <a id='commits'></a> Commits

The `Commits` data model represents the information of a snapshot of the changes that have been made to a project's files. The Observer sends this information to the Cloud Event Handler to store new commits. See [cloud events](cloudevents.hbs.md).

Each `Commit` data entry stores information about the associated location in which it was deployed, details about the state, and what commit `sha` or `tag` were used. See the diagram above for a list of all fields the data model stores.
You can only associate an `Commits` entry with one `Locations` entry. You can point multiple `Commits` entries to the same `Locations` entry. 

### <a id='appAcceleratorRuns'></a> AppAcceleratorRuns
The `AppAcceleratorRuns` data model represents the information of new projects running from Git repositories. An accelerator.yaml file in the repository declares input options for the accelerator. This file also contains instructions for processing the files when you generate a new project. Observer sends this information to the Cloud Event Handler to store `AppAcceleratorRuns`. See [cloud events](cloudevents.hbs.md).

### <a id='appAcceleratorFragments'></a> AppAcceleratorFragments
The `AppAcceleratorFragments` Accelerator fragments are reusable accelerator components that can provide options, files, or transforms. They can be imported to accelerators using an `import` entry and the transforms from the fragment can be referenced in an `InvokeFragment` transform in the accelerator that is declaring the import. The AppAcceleratorFragments data model represents the information of a fragment in the accelerator app. The Observer sends this information to the Cloud Event Handler to store `AppAcceleratorFragments`. See [cloud events](cloudevents.hbs.md).

`AppAcceleratorRuns` can have zero or many `AppAcceleratorFragments`. 

### <a id='doraMetrics'></a> DoraMetrics
The `DoraMetrics` data model represents the information of DORA Metric. The Observer sends this information to the Cloud Event Handler to store `DoraMetrics`. See [cloud events](cloudevents.hbs.md).

### <a id='doraMetricsPerCorrelationID'></a> DoraMetricsPerCorrelationID
The `DoraMetricsPerCorrelationID` data model represents the information of DORA Metric for Correlation ID. The Correlation ID that groups the all the artifacts together. The Observer sends this information to the Cloud Event Handler to store `DoraMetricsPerCorrelationID`. See [cloud events](cloudevents.hbs.md).
`DoraMetrics` can have zero or many `DoraMetricsPerCorrelationID`. 