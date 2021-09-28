---
title: Install
subtitle: How to install Cartographer in a Kubernetes cluster
weight: 2
---

This topic explains how to install Cartographer in a Kubernetes cluster.

## Prerequisites

To install Cartographer you must have:

- A v1.17 or later Kubernetes cluster connected to the VMware network. <!-- Missing xref -->
Container images are currently hosted under `harbor-repo.vmware.com`.
To try an experimental approach to installing Cartographer that is based on kapp-controller packaging
CRDs, see INSERT-LINK-HERE(). <!-- Missing a link -->
- cert-manager. To install cert-manager, see the [cert-manager documentation](https://cert-manager.io/docs/installation/).

## Install Cartographer in a Kubernetes Cluster

1. Clone the repository by running:

    ```bash
    git clone https://gitlab.eng.vmware.com/cartographer/cartographer
    cd ./cartographer && git checkout v0.0.3
    ```

1. Create the `cartographer-system` namespace by running:

    ```bash
    kubectl create namespace cartographer-system
    ```

1. Submit the Kubernetes objects that extend Kubernetes and run the controller inside the cluster
by running:

    ```shell
    $ kapp deploy -a cartographer -f ./releases/release.yaml
    ```
    <!-- Why is it better to run kapp than kubectl? Why would the reader choose kubectl? -->

    or

    ```bash
    kubectl apply -f ./releases/release.yaml
    ```

    Example output is below:

    ```bash
    Target cluster 'https://127.0.0.1:53218' (nodes: kind-control-plane)

    Changes

    Namespace        Name                                 Kind                      Conds.  Age  Op      Op st.  Wait to    Rs  Ri
    (cluster)        clusterbuildtemplates.carto.run    CustomResourceDefinition  -       -    create  -       reconcile  -   -
    ^                clusterconfigtemplates.carto.run   CustomResourceDefinition  -       -    create  -       reconcile  -   -
    ^                clusteropiniontemplates.carto.run  CustomResourceDefinition  -       -    create  -       reconcile  -   -
    ^                clustersourcetemplates.carto.run   CustomResourceDefinition  -       -    create  -       reconcile  -   -
    ^                clustersupplychains.carto.run      CustomResourceDefinition  -       -    create  -       reconcile  -   -
    ^                deliverables.carto.run             CustomResourceDefinition  -       -    create  -       reconcile  -   -
    ^                cartographer-cluster-admin               ClusterRoleBinding        -       -    create  -       reconcile  -   -
    ^                workloads.carto.run                CustomResourceDefinition  -       -    create  -       reconcile  -   -
    cartographer-system  cartographer-controller                  Deployment                -       -    create  -       reconcile  -   -
    ^                cartographer-controller                  ServiceAccount            -       -    create  -       reconcile  -   -

    Op:      10 create, 0 delete, 0 update, 0 noop
    Wait to: 10 reconcile, 0 delete, 0 noop

    Continue? [yN]: y

    11:01:49AM: ---- applying 9 changes [0/10 done] ----
    ...
    11:01:58AM: ok: reconcile deployment/cartographer-controller (apps/v1) namespace: cartographer-system
    11:01:58AM: ---- applying complete [10/10 done] ----
    11:01:58AM: ---- waiting complete [10/10 done] ----

    Succeeded
    ```
