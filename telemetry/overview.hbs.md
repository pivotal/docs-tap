# Telemetry for Tanzu

Telemetry is used to collect information regarding your cluster.

For more information on how to install the telemetry component, see the [guide](install-telemetry.hbs.md).

### Tap Usage Reports

VMware offers the option to enroll in a usage reporting program that can provide them with a summary of usage of their TAP deployments.The mechanism 
to enroll is by the customer providing their Entitlement Account Number (EAN). An EAN is a unique ID assigned to all VMware customers, we will use it
to identify data that belongs to their TAP deployments. You can find it here:  https://kb.vmware.com/s/article/2148565

Note that this is only supported for non-airgapped TAP deployments and the Cluster must be participating in TAP telemetry. Customers are enrolled in 
telemetry by default but can opt-out by following instructions [here](../opting-out-telemetry.hbs.md).
