# Kubernetes version support for Tanzu Application Platform

The following is a matrix table providing details of Tanzu Application Platform versions 
and their corresponding compatible Kubernetes cluster versions.

| Tanzu Application Platform version | TKGm version | TKG version | Kubernetes version |
|--------|---------|
|[v1.3.x](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-release-notes.html)|v1.6 |N/A |v1.22, v1.23 or v1.24|
|[v1.4.x](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.4/tap/release-notes.html)|v1.6|N/A |v1.23, v1.24 or v1.25|
|[v1.5.x](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.5/tap/release-notes.html)|N/A |v2.1 |v1.24, v1.25 or v1.26|
|[v1.6.x](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.6/tap/release-notes.html)|N/A |N/A |v1.25, v1.26 or v1.27|

|     Tanzu Application Platform version |     TKGm version    |     TKG (TKGm) version   |      EKS version              |     AKS version               |     TKG (TKGs) version   |      OpenShift version    |     GKE version              |      Minikube version        |   |
|----------------------------------------|---------------------|--------------------------|-----------------------|-----------------------|--------------------------|-------------------|-----------------------|-----------------------|---|
|     v1.3.0                             |     v1.6            | -                | v1.22, v1.23 or v1.24 | v1.22, v1.23 or v1.24 |     -            | v4.10             | v1.22, v1.23 or v1.24 | v1.22, v1.23 or v1.24 |   |
|     v1.3.2                             |     v1.6 or v1.5    | -                | v1.22, v1.23 or v1.24 | v1.22, v1.23 or v1.24 |     -            | v4.10             | v1.22, v1.23 or v1.24 | v1.22, v1.23 or v1.24 |   |
|     v1.3.3                             |     v1.6            |     -            | v1.22, v1.23 or v1.24 | v1.22, v1.23 or v1.24 |     -            | v4.10             | v1.22, v1.23 or v1.24 |     -         |   |
|     v1.3.5                             | v1.6                |     -            | v1.22, v1.23 or v1.24 | v1.22, v1.23 or v1.24 |     -            | v4.10             | v1.22, v1.23 or v1.24 |     -         |   |
|     v1.3.6                             | v1.6                |     -            | v1.22, v1.23 or v1.24 | v1.22, v1.23 or v1.24 |     -            | v4.10             | v1.22, v1.23 or v1.24 |     -         |   |
|     v1.3.7                             | v1.6                |     -            | v1.22, v1.23 or v1.24 | v1.22, v1.23 or v1.24 |     -            | v4.10             | v1.22, v1.23 or v1.24 |     -         |   |
|     v1.3.8                             | v1.6                |     -            | v1.22, v1.23 or v1.24 | v1.22, v1.23 or v1.24 |     -            | v4.10             | v1.22, v1.23 or v1.24 |     -         |   |
|     v1.3.9                             | v1.6                |     -            | v1.22, v1.23 or v1.24 | v1.22, v1.23 or v1.24 |     -            | v4.10             | v1.22, v1.23 or v1.24 |     -         |   |
|     v1.3.10                            | v1.6                |     -            | v1.22, v1.23 or v1.24 | v1.22, v1.23 or v1.24 |     -            | v4.10             | v1.22, v1.23 or v1.24 |     -         |   |
|     v1.3.11                            | v1.6                |     -            | v1.22, v1.23 or v1.24 | v1.22, v1.23 or v1.24 |     -            | v4.10             | v1.22, v1.23 or v1.24 |     -         |   |
|     v1.3.12                            | v1.6                |     -            | v1.22, v1.23 or v1.24 | v1.22, v1.23 or v1.24 |     -            | v4.10             | v1.22, v1.23 or v1.24 |     -         |   |
|     v1.4.0                             | v1.6                |     -            | v1.23, v1.24 or v1.25 | v1.23, v1.24 or v1.25 |     -            | v4.10, v4.11      | v1.23, v1.24 or v1.25 | v1.23, v1.24 or v1.25 |   |
|     v1.4.1                             | v1.6                |     -            | v1.23, v1.24 or v1.25 | v1.23, v1.24 or v1.25 |     -            | v4.10, v4.11      | v1.23, v1.24 or v1.25 |     -         |   |
|     v1.4.2                             | v1.6                |     -            | v1.23, v1.24 or v1.25 | v1.23, v1.24 or v1.25 |     -            | v4.10, v4.11      | v1.23, v1.24 or v1.25 |     -         |   |
|     v1.4.4                             | v1.6                |     -            | v1.23, v1.24 or v1.25 | v1.23, v1.24 or v1.25 | -                | v4.10, v4.11      | v1.23, v1.24 or v1.25 |     -         |   |
|     v1.4.5                             | v1.6                |     -            | v1.23, v1.24 or v1.25 | v1.23, v1.24 or v1.25 | -                | v4.10, v4.11      | v1.23, v1.24 or v1.25 |     -         |   |
|     v1.4.6                             | v1.6                |     -            | v1.23, v1.24 or v1.25 | v1.23, v1.24 or v1.25 | -                | v4.10, v4.11      | v1.23, v1.24 or v1.25 | v1.23, v1.24 or v1.25 |   |
|     v1.4.7                             | v1.6                |     -            | v1.23, v1.24 or v1.25 | v1.23, v1.24 or v1.25 | -                | v4.10, v4.11      | v1.23, v1.24 or v1.25 | v1.23, v1.24 or v1.25 |   |
|     v1.4.8                             | v1.6                |     -            | v1.23, v1.24 or v1.25 | v1.23, v1.24 or v1.25 | -                | v4.10, v4.11      | v1.23, v1.24 or v1.25 | v1.23, v1.24 or v1.25 |   |
|     v1.4.9                             | v1.6                |     -            | v1.23, v1.24 or v1.25 | v1.23, v1.24 or v1.25 | -                | v4.10, v4.11      | v1.23, v1.24 or v1.25 | v1.23, v1.24 or v1.25 |   |
|     v1.5.0                             |     -       |     v2.1.x               | v1.24, v1.25 or v1.26 | v1.24, v1.25 or v1.26 |     v2.0.x               | v4.11, v4.12      | v1.24, v1.25 or v1.26 | v1.24, v1.25 or v1.26 |   |
|     v1.5.1                             |     -       |     v2.1.x               | v1.24, v1.25 or v1.26 | v1.24, v1.25 or v1.26 | v2.0.x                   | v4.11, v4.12      | v1.24, v1.25 or v1.26 | v1.24, v1.25 or v1.26 |   |
|     v1.5.2                             |     -       | v2.3.x or v2.1.x         | v1.24, v1.25 or v1.26 | v1.24, v1.25 or v1.26 | v2.0.x                   | v4.11, v4.12      | v1.24, v1.25 or v1.26 | v1.24, v1.25 or v1.26 |   |
|     v1.5.3                             |     -       | v2.3.x or v2.1.x         | v1.24, v1.25 or v1.26 | v1.24, v1.25 or v1.26 | v2.0.x                   | v4.11, v4.12      | v1.24, v1.25 or v1.26 | v1.24, v1.25 or v1.26 |   |
|     v1.5.4                             |     -       | v2.3.x, v2.2.x or v2.1.x | v1.24, v1.25 or v1.26 | v1.24, v1.25 or v1.26 | v2.3.x                   | v4.11, v4.12      | v1.24, v1.25 or v1.26 | v1.24, v1.25 or v1.26 |   |
|     v1.5.5                             |     -       | v2.3.x, v2.2.x or v2.1.x | v1.24, v1.25 or v1.26 | v1.24, v1.25 or v1.26 | v2.3.x                   | v4.11, v4.12      | v1.24, v1.25 or v1.26 | v1.24, v1.25 or v1.26 |   |
|     v1.6.1                             |     -       | v2.3.x                   | v1.25, v1.26 or v1.27 | v1.25, v1.26 or v1.27 |     -            | v4.11, v4.12      | v1.25, v1.26 or v1.27 | v1.25, v1.26 or v1.27 |   |
|     v1.6.2                             |     -       | v2.3.x or v2.2.x         | v1.25, v1.26 or v1.27 | v1.25, v1.26 or v1.27 | v2.3.x                   | v4.11, v4.12      | v1.25, v1.26 or v1.27 | v1.25, v1.26 or v1.27 |   |
|     v1.6.3                             |     -       | v2.3.x or v2.2.x         | v1.25, v1.26 or v1.27 | v1.25, v1.26 or v1.27 | v2.3.x                   | v4.11, v4.12      | v1.25, v1.26 or v1.27 | v1.25, v1.26 or v1.27 |   |
