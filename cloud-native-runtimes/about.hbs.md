# Overview of Cloud Native Runtimes

## Overview
Cloud Native Runtimes (CNRs) is enterprise supported Knative, with the Carvel tools suite for deployment and Contour for networking.
CNRs offers everything Knative does and some extras that make it ideal for cloud native application development.
Cloud Native Runtimes gives developers environmental simplicity and administrators deployment control and it works on any single Kubernetes cluster running Kubernetes v1.25 and later.

CNR utilizes Knative Serving's main features to provide:

* Automatic pod scaling.
* Traffic splitting by code release version.

Cloud Native Runtimes simplifies the Developer experience.

| Kubernetes Developers need to know: | Cloud Native Runtimes Developers need to know: |
|-------------------------------------|------------------------------------------------|
| Pods                                | Pods                                           |
| Deployment & Rollout Progress       | Knative Service                                |
| Service (networking model)          |                                                |
| Ingress                             |                                                |
| Labels and selectors                |                                                |

Cloud Native Runtimes increases Administrator control and support.

| Administrators can:                                          |
|--------------------------------------------------------------|
| Manage infrastructure costs with request driven autoscaling  |
| Test deployments with traffic splitting by code version      |
| Use Carvel command tools to simplify deployment              |
| Receive Enterprise Support when they need it                 |

Cloud Native Runtimes works well with these use cases:

* Batch Jobs Processing
* AI/ML
* Application or Network Monitoring
* IOT
* Serverless application architectures

For more information on the software that makes Cloud Native Runtimes see:

* Knative Documentation [Home - Knative](https://knative.dev/docs/)
* Carvel Tools Suite Documentation [Carvel - Home](https://carvel.dev/)
* Contour Networking Documentation [Contour](https://projectcontour.io/)
