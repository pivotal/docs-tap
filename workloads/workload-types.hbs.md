# Workload types

This topic provides you with an overview of workload types.

Tanzu Application Platform allows you to quickly build and test applications regardless of your familiarity with Kubernetes.

You can turn source code into a workload that runs in a container with a URL.
You can also use supply chains to build applications that process work from a message queue,
or provide arbitrary network services.

A workload allows you to choose application specifications, such as
repository location, environment variables, service binding, and so on.
For more information about workload creation and management, see
[Command Reference](../cli-plugins/apps/command-reference.md).

Tanzu Application Platform supports a range of workload types,
including scalable web applications (`web`), traditional application
servers (`tcp`), background applications (`queue`), and serverless functions.
You can use a collection of workloads of different types to deploy
microservices that function as a logical application, or deploy your
entire application as a single monolith.
