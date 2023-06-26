# Tanzu Application Platform Telemetry

Tanzu Application Platform Telemetry (commonly known as TAP Telemetry) is a set of 
objects that collect data about the usage of Tanzu Application Platform (commonly known as TAP) 
and send it back to VMware for product improvements. 

A benefit of remaining enrolled in telemetry and identifying your company during 
Tanzu Application Platform installation is that VMware can provide your
organization with usage reports about Tanzu Application Platform. 

For more information about enrolling in telemetry reports, see [Tanzu Application Platform usage reports](#usage-reports).

For more information about how to install the telemetry component, see [Install Tanzu Application Platform Telemetry](install-telemetry.hbs.md).

## <a id='usage-reports'></a>Tanzu Application Platform usage reports

VMware offers the option to enroll in a usage reporting program that offers a summary of usage of your Tanzu Application Platform. These reports are intended to provide an overview of many TAP deployments and how they are being used. Features include number of workloads and supply chains and their health status. And vCPU consumed by each TAP deplyoment. You can enroll in the program by providing the Entitlement Account Number (EAN). An EAN is a unique ID assigned to all VMware customers. VMware uses EAN
to identify data about Tanzu Application Platform. See [Locate the Entitlement Account number for new orders](https://kb.vmware.com/s/article/2148565) for more details.

After locating the EAN, pass the number under the telemetry header in the `tap-values.yaml` file as a value for the `customer_entitlement_account_number` key.

```yaml
tap_telemetry:
  customer_entitlement_account_number: "CUSTOMER-ENTITLEMENT-ACCOUNT-NUMBER"
```

You must repeat the process for each Tanzu Application Platform Cluster included in the telemetry report.
For more information, see [Full profile](../install-online/profile.hbs.md#full-profile).

After enrollment, alert your VMware account team that you have configured the EAN field and want telemetry reports.
This allows VMware to identify who the newly added EAN belongs to.

>**Note** Usage report is only supported for non-airgapped deployments of Tanzu Application Platform
and the Cluster must participate in Tanzu Application Platform telemetry.
You are enrolled in telemetry by default. You can opt out of telemetry collection
by following the instructions in [Opt out of telemetry collection](../opting-out-telemetry.hbs.md).

The following screenshots show the sample telemetry reports.

<img width="1147" alt="Screenshot of the sample telemetry report showing the TAP deployment metrics" src="https://user-images.githubusercontent.com/18624859/223277905-f2a0bec4-94e7-4503-b0ed-e17ecb312590.png">

<img width="1163" alt="Screenshot of the sample telemetry report showing the Supply Chains metrics" src="https://user-images.githubusercontent.com/18624859/223277943-d2ab2058-369b-4bf8-a007-ac62521fba51.png">

<img width="1154" alt="Screenshot of the sample telemetry report showing the Workload metrics" src="https://user-images.githubusercontent.com/18624859/223277970-95c589ac-3b25-400c-bf3d-1f2ad2390257.png">
