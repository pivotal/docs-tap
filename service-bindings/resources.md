# Resources

## <a id="sb-resources"></a> ServiceBinding (servicebinding.io/v1alpha3)

The `ServiceBinding` resource shape and behavior is defined by the following specification:

```yaml
apiVersion: servicebinding.io/v1alpha3
kind: ServiceBinding
metadata:
  name: account-db
spec:
  service:
    apiVersion: mysql.example/v1alpha1
    kind: MySQL
    name: account-db
  workload:
    apiVersion: apps/v1
    kind: Deployment
    name: account-service
```
