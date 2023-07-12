# Dependency Matrix

| TAP Version   | Apps CLI Version | Required Cartographer Version |
| ------------- | -------------    | -------------                 |
| TAP 1.3.x     | 0.9.x            | 0.5.x or higher               |
| TAP 1.4.x     | 0.10.x           | 0.6.x or higher               |
| TAP 1.5.x     | 0.11.x           | 0.7.x or higher               |
| TAP 1.6.x     | 0.12.x           | 0.7.x or higher               |

## Check Cartographer version

To see the Cartographer version installed in the cluster, check it with:

```bash
kubectl get -n tap-install packageinstalls.packaging.carvel.dev cartographer
```
