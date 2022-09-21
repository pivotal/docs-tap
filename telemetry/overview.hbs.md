# Telemetry for Tanzu Application Platform

Tanzu Application Platform Telemetry is a set of objects that collect data about the usage of Tanzu Application Platform and send it back to VMware for product improvements. A benefit of remaining enrolled in telemetry and identifying your company during Tanzu Application Platform installation is that VMware can provide your 
organization with usage reports about Tanzu Application Platform. See [Tanzu Application Platform usage reports](#usage-reports) for more information about enrolling in telemetry reports.

For more information on how to install the telemetry component, see [Installing Tanzu Application Platform Telemetry](install-telemetry.hbs.md).

## <a id='usage-reports'></a>Tanzu Application Platform usage reports

VMware offers the option to enroll in a usage reporting program that offers a summary of usage of your Tanzu Application Platform. You can enroll in the program by providing the Entitlement Account Number (EAN). An EAN is a unique ID assigned to all VMware customers. VMware uses EAN
to identify data about Tanzu Application Platform. See [Locating the Entitlement Account number for new orders](https://kb.vmware.com/s/article/2148565) for more details.

Once enrolled, make sure to alert your VMware account team that you have configured the EAN field and want telemetry reports. This allows VMware to identify
who the newly added EAN belongs to.

>**Note:** Usage report is only supported for non-airgapped TAP deployments and the Cluster must participate in Tanzu Application Platform telemetry. You are enrolled in telemetry by default. You can opt out of telemetry collection by following the 
instructions in [Opting out of telemetry collection](../opting-out-telemetry.hbs.md).
