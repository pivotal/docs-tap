# Artifact Metadata Repository (AMR) data model and concepts

This topic tells you about data models used in the Artifact Metadata Repository (AMR).

## <a id='overview'></a> Overview

The following diagram shows the data models used in the AMR to store artifact information and the relationship between them.

![Diagram of the AMR Data Models](../images/amr-data-model.jpg)

## <a id='amr-data-models'></a> AMR data models

The following data models are stored in the AMR: 

- `Locations`
- `Containers`
- `Images`
- `Commits`
- `AppAcceleratorRuns`
- `AppAcceleratorFragments`
- `DoraMetrics`
- `DoraMetricsPerCorrelationID`

### <a id='locations'></a> Locations

The `Locations` data model stores data about the locations that `Apps` are
deployed on, like clusters. It stores data using:

- `reference`: unique reference to the location. It is automatically set to be
  the `kube-system` namespace UID by the AMR. You can't configure this value.
- `labels`: labels of the location. You can add labels in the `tap-values.yaml`
  file. See [AMR Configuration](configuration.hbs.md).

### <a id='containers'></a> Containers

The `Containers` data model includes information about a container, like runtime
information about an image. The Observer sends this information to the Cloud
Event Handler. Each entry represents the state of the container when an event
occurred. See [CloudEvent JSON specification for Supply Chain Security Tools - Artifact Metadata Repository](cloudevents.hbs.md). These entries correspond to
events, such as when a container is running or terminated. This lets you see the
history of your containers.

Each `Container` data entry stores information about the associated deployment
location, details about the state, and what image was used. You can only
associate a `Containers` entry with one `Locations` entry. You can point
multiple `Containers` entries to the same `Locations` entry.

### <a id='images'></a> Images

The `Images` data model includes information about image which acts as a
template for containers. The Observer sends this information to the Cloud Event
Handler to store newly generated images. See [CloudEvent JSON specification for Supply Chain Security Tools - Artifact Metadata Repository](cloudevents.hbs.md).

Each `Image` data entry stores information about the associated deployment
location. You can only associate an `Images` entry with one `Locations` entry.
You can point multiple `Images` entries to the same `Locations` entry.

### <a id='commits'></a> Commits

The `Commits` data model includes information about a snapshot of the changes
made to a project's files. The Observer sends this information to the Cloud
Event Handler to store new commits. See [CloudEvent JSON specification for
Supply Chain Security Tools - Artifact Metadata Repository](cloudevents.hbs.md).

Each `Commit` data entry stores information about the deployment location,
details about the state, and what commit `sha` or `tag` were used. You can only
associate a `Commits` entry with one `Locations` entry. You can point multiple
`Commits` entries to the same `Locations` entry. 

### <a id='appAcceleratorRuns'></a> AppAcceleratorRuns

The `AppAcceleratorRuns` data model represents new projects running from Git
repositories. An `accelerator.yaml` file in the repository declares input
options for the accelerator. This file contains instructions for processing the
files when you generate a new project. Observer sends this information to the
Cloud Event Handler to store `AppAcceleratorRuns`. See [cloud
events](cloudevents.hbs.md).

### <a id='appAcceleratorFragments'></a> AppAcceleratorFragments

The `AppAcceleratorFragments` Accelerator fragments are reusable accelerator
components that can provide options, files, or transforms. You can import
accelerators using an `import` entry. The transforms from the fragment are
referenced in an `InvokeFragment` transform in the accelerator that declares
the import. The AppAcceleratorFragments data model represents the information of
a fragment in the accelerator app. The Observer sends this information to the
Cloud Event Handler to store `AppAcceleratorFragments`. See [cloud
events](cloudevents.hbs.md).

`AppAcceleratorRuns` can have zero or many `AppAcceleratorFragments`. 

### <a id='doraMetrics'></a> DoraMetrics

The `DoraMetrics` data model represents the information of DORA Metric. The Observer sends this information to the Cloud Event Handler to store `DoraMetrics`. See [CloudEvent JSON specification for Supply Chain Security Tools - Artifact Metadata Repository](cloudevents.hbs.md).

### <a id='metrics-correlation-ID'></a> DoraMetricsPerCorrelationID

The `DoraMetricsPerCorrelationID` data model represents the information of DORA Metric for Correlation ID. The Correlation ID that groups the all the artifacts together. The Observer sends this information to the Cloud Event Handler to store `DoraMetricsPerCorrelationID`. See [CloudEvent JSON specification for Supply Chain Security Tools - Artifact Metadata Repository](cloudevents.hbs.md).
`DoraMetrics` can have zero or many `DoraMetricsPerCorrelationID`. 