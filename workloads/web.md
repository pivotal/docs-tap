# Web workloads

The `web` workload type allows you to deploy web applications on Tanzu Application Platform. Using an application workload specification, you can turn source code into a scalable, stateless application that runs in a container with an automatically-assigned URL.

The `web` workload is a good match for modern web applications designed to store state in external databases and which generally follow the [12-factor principles](https://12factor.net). The out of the box supply chains include definitions for the `web` workload type which leverage Cloud Native Runtimes to provide:

* Automatic request-based scaling, including scale-to-zero
* Automatic URL provisioning and optional certificate provisioning
* Automatic health check definitions if not provided by a convention
* Blue-green application rollouts

When creating a workload with `tanzu apps workload create`, you can use the `--type=web` argument to select the `web` workload type. You can also use the `apps.tanzu.vmware.com/workload-type:web` annotation in the YAML workload description to support this deployment type.

