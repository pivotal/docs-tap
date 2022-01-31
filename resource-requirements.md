# Resource requirements

* To deploy all Tanzu Application Platform packages, your cluster must have at least:
    * 8 GB of RAM across all nodes available to Tanzu Application Platform
    * 8 CPUs for i9 (or equivalent) available to Tanzu Application Platform components
    * 12 CPUs for i7 (or equivalent) available to Tanzu Application Platform components
    * 12 GB of RAM is available to build and deploy applications, including Minikube. VMware recommends 16 GB of RAM for an optimal experience.
    * 70 GB of disk space available per node

* For the [`full` profile](install.html#full-profile), or
    use of Security Chain Security Tools - Store, your cluster must have a configured default StorageClass.

* [Pod Security Policies](https://kubernetes.io/docs/concepts/policy/pod-security-policy/)
must be configured so that Tanzu Application Platform controller pods can run as root.
