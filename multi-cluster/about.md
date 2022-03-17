# Overview of Multicluster Tanzu Application Platform

The Tanzu Application Platform can be installed in many different topologies that can reflect each customer's existing landscape. The topology represented in this section is one way that we've tested and recommend to customer for production usage. Since flexibility and choice are core to the Tanzu Application Platform's design, none of the implementation recomednations are set in stone. 

The multicluster topology heavily leverages the [profile capabilities](../overview.md#profiles-and-packages) that Tanzu Application Platform supports. Each cluster assumes one of the 3 multicluster-aligned roles:
- **Build:**
  This profile is intended for the transformation of source revisions to workload revisions. Specifically, hosting Workloads and SupplyChains.
 
- **Run:**
  This profile is intended for the transformation of workload revisions to running Pods. Specifically, hosting Deliveries and Deliverables.

- **View:**
  This profile is intended for instances of applications related to centralized developer experiences. Specifically, the Tanzu Application Platform GUI and Metadata Store.
![Multi-cluster Diagram](../images/multi-cluster-diagram.jpg)

## Installation ##
To get started with installing a multicluster topology see the [installation instructions located here](installing-multicluster.md).