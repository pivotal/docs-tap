# Telemetry for Tanzu

TAP Telemetry is a set of objects that collect and emit data about usage of TAP back to VMware.  
This data is gathered and used to improve the product.  Customers can opt out of telemetry collection by following these 
[instructions](https://docs.vmware.com/en/VMware-Tanzu-Application-Platform/1.3/tap/GUID-opting-out-telemetry.html)
A benefit of remaining enrolled in telemetry and identifying your company during TAP installation is that VMware can provide your 
organization with usage reports about TAP.  Access the component documentation to learn more about enrolling in telemetry reports.

For more information on how to install the telemetry component, see the [guide](install-telemetry.hbs.md).

### Tap Usage Reports

VMware offers the option to enroll in a usage reporting program that can provide them with a summary of usage of their TAP deployments.The mechanism 
to enroll is by the customer providing their Entitlement Account Number (EAN). An EAN is a unique ID assigned to all VMware customers, we will use it
to identify data that belongs to their TAP deployments. You can find it here: https://kb.vmware.com/s/article/2148565

Once enrolled, make sure to alert your VMware account team that you have configured the EAN field and want telemetry reports. This will allow us to know
who the newly added EAN belongs to.

Note that this is only supported for non-airgapped TAP deployments and the Cluster must be participating in TAP telemetry. Customers are enrolled in 
telemetry by default but can opt-out by following instructions [here](../opting-out-telemetry.hbs.md).
