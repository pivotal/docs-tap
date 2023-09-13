# Overview of Cloud Native Runtimes

This topic gives you an overview what Cloud Native Runtimes is and how you can use it with Tanzu Application Platform.

## <a id="overview"></a> Overview

Cloud Native Runtimes (CNRs) is enterprise supported Knative, with Carvel tools for deployment and Contour for networking.
CNRs offers everything Knative does and some extras that make it ideal for cloud-native application development.
Cloud Native Runtimes gives developers environmental simplicity and administrators deployment control. It works on any single Kubernetes cluster running Kubernetes v1.26 and later.

The Cloud Native Runtimes component documentation consists of the following sections:

- [How-to Guides](how-to-guides/index.hbs.md) give you steps to solve a specific problem.
- [Reference](reference/index.hbs.md) give you specific information, such as the CNRs Compatibility Matrix.

CNRs uses Knative Serving to provide:

- Automatic pod scaling
- Traffic splitting by code release version

Cloud Native Runtimes simplifies the Developer experience.

| Kubernetes Developers must know: | Cloud Native Runtimes Developers must know: |
|----------------------------------|---------------------------------------------|
| Pods                             | Pods                                        |
| Deployment and Rollout Progress  | Knative Service                             |
| Service (networking model)       |_n/a_                                        |
| Ingress                          |_n/a_                                        |
| Labels and selectors             |_n/a_                                        |

Cloud Native Runtimes increases Administrator control and support.

| Administrators can:                                          |
|--------------------------------------------------------------|
| Manage infrastructure costs with request driven autoscaling  |
| Test deployments with traffic splitting by code version      |
| Use Carvel command tools to simplify deployment              |
| Receive Enterprise Support when they need it                 |

Cloud Native Runtimes works well with these use cases:

- Batch Jobs Processing
- AI/ML
- Application or Network Monitoring
- IOT
- Serverless application architectures

For more information about the software related to Cloud Native Runtimes, see:

- Knative Documentation [Home - Knative](https://knative.dev/docs/)
- Carvel Tools Suite Documentation [Carvel - Home](https://carvel.dev/)
- Contour Networking Documentation [Contour](https://projectcontour.io/)