# DRAFT Scalability

## Workload configuration


## Application Configuration

Supply chain: Testing_Scanning (Build+Run), Basic & Testing (Iterate)

Workload type: Web, Server+Worker

Kubernetes Distribution: Azure Kubernetes Service

|  | **CPUs** | **Number of workload CRs** |Workload Transactions per second|
|:--- |:--- |:--- |:--- |
|**Small** | 200m /500m - 700m /3-5 GB| 5 |10|
|**Medium** | 300m / 700m - 1000m / 4-6 GB | 6 |20|
|**Large** | 500m / 1000m - 1500m / 6-8 GB | 7 |40 |

## Scale Configuration

Node configuration: 4 vCPUs, 16GB RAM, 120 GB Disk size

|**Cluster Type / Workload Details** |**Shared Iterate Cluster** | **Build Cluster** |**Run Cluster 1** |**Run Cluster 2**| **Run Cluster 3** |
|:--- |:--- |:--- |:--- |:---|:--- |:--- |
|**No. of Namespaces** |300| 333 | 333 | 333 | 333 | 333 |
|**Small** | 300 | 233 | 233 | 233 | 233 | 233 |
|**Medium** | | 83 | 83 | 83 | 83 | 83   |
|**Large** | | 17 | 17 | 17 | 17 | 17 |
|**No. of Nodes** |90 | 60 | 135 | 135 | 135 | 135 |


## Best Practices

|**Controller/Pod**|**No. of applications/deliverables**|**CPU**|**Memory**|**Build** | **Run** | **Iterate** |**Other changes**|**Comments**|**Values set in**|
|:------|:------|:--------|:-------|:------|:------|:-----|:------|:--------|:-------|
 Build Service/kpack controller | Beyond 200 applications | 20m/100m | 1Gi/2Gi | Yes | No | Yes | | | Tap\-values
          
