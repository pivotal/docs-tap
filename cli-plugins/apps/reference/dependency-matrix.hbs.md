# Dependency Matrix

This topic tells you what versions of the Tanzu Apps CLI are supported in Tanzu Application Platform.

| Tanzu Application Platform Version   | Apps CLI Version | Required Cartographer Version |
| ------------- | -------------    | -------------                 |
| v1.3.x     | v0.9.x            | v0.5.x or later               |
| v1.4.x     | v0.10.x           | v0.6.x or later               |
| v1.5.x     | v0.11.x           | v0.7.x or later               |
| v1.6.x     | v0.12.x           | v0.7.x or later               |

## Check Cartographer version

To see the Cartographer version installed in the cluster, run:

```console
kubectl get -n tap-install packageinstalls.packaging.carvel.dev cartographer
```
