# Artifact Metadata Repository

This topic gives you an overview of Artifact Metadata Repository (AMR).

## <a id='observer'></a> AMR Observer

AMR Observer is a set of managed controllers that watches for relevant updates
on resources of interest. When relevant events are observed, a CloudEvent is
generated and sent to AMR CloudEvent Handler. This component is expected to be
deployed on "full", "build" and "run" profile clusters.

## <a id='handler'></a> AMR CloudEvent Handler

AMR CloudEvent Handler receives CloudEvents and stores relevant information into 
the Artifact Metadata Repository or Metadata Store. This component is expected
to be deployed on "full" and "view" profile clusters.

## <a id='ki'></a> Known Issues


## Additional Resources

- [AMR Architecture](./architecture.hbs.md)
- [AMR Configuration](./configuration.hbs.md)
- [AMR Data Models](./data-model-and-concepts.hbs.md)
- [AMR GraphQL Query](./graphql-query.hbs.md)
