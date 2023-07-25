# Using web workloads

This topic tells you how to use the `web` workload type in Tanzu Application Platform
(commonly known as TAP).

The `web` workload is a good match for modern web applications that store state in external databases and follow the [12-factor principles](https://12factor.net).

The out of the box (OOTB) supply chains include definitions for the `web` workload type which leverage Cloud Native Runtimes to provide:

* Automatic request-based scaling, including scale-to-zero
* Automatic URL provisioning and optional certificate provisioning
* Automatic health check definitions if not provided by a convention
* Blue-green application rollouts

When creating a workload with `tanzu apps workload create`, you can use the
`--type=web` argument to select the `web` workload type.
You can also use the `apps.tanzu.vmware.com/workload-type:web` label in the
YAML workload description to support this deployment type.
