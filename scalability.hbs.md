# Workload configuration

Node configuration: 4 vCPUs, 16GB RAM, 120 GB Disk size
Supply chain: Testing_Scanning (Build+Run), Basic & Testing (Iterate)
Workload type: Web, Server+Worker
Kubernetes Distribution: Azure Kubernetes Service

|  | **CPUs** | **Number of workload CRs** |Workload Transactions per second|
|:--- |:--- |:--- |:--- |
|**Small** | 200m /3 GB| 5 |10|
|**Medium** | 300m / 4 GB | 6 |20|
|**Large** | 500m / 6 GB | 7 |40 |


|Cluster Type / Workload Details |Shared Iterate Cluster |Build Cluster |Run Cluster 1 |Run Cluster 2|Run Cluster 3 |:--- |
|:--- |:--- |:--- |:--- |:---|:--- |:--- |
|No. of Namespaces |300| 333 | 333 | 333 | 333 | 333 |
|Small | 300 | 233 | 233 | 233 | 233 | 233 |
|Medium |:--- | 83 | 83 | 83 | 83 | 83   |
|Large |90 | 60 | 135 | 135 | 135 | 135 |
