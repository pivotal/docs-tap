# cert-manager, Contour, and FluxCD Source Controller

cert-manager adds certificates and certificate issuers as resource types in Kubernetes clusters. It also helps you to obtain, renew, and use those certificates. For more information about cert-manager, see the [cert-manager documentation](https://cert-manager.io/next-docs/).

Contour is an ingress controller for Kubernetes that supports dynamic configuration updates and multi-team ingress delegation. It provides the control plane for the Envoy edge and service proxy.​ For more information about Contour, see the [Contour documentation](https://projectcontour.io/docs/v1.20.0/).

FluxCD Source Controller is a Kubernetes operator that helps you acquire artifacts from external sources such as Git, Helm repositories, and S3 buckets. For more information about FluxCD Source Controller, see the [fluxcd/source-controller](https://github.com/fluxcd/source-controller) project on GitHub.