# DORA in Tanzu Developer Portal

This topic tells you about how you can view DORA metrics in Tanzu Developer Portal (formerly called Tanzu Application Platform GUI).

## <a id="overview"></a> Overview

DevOps Research and Assessment (DORA) is the largest and longest running research program of its kind, that seeks to understand the capabilities that drive software delivery and operations performance. DORA helps teams apply those capabilities, leading to better organizational performance. DORA metrics refer to a set of key performance indicators (KPIs) that DORA has developed to measure the effectiveness of an organization's DevOps practices. These metrics are designed to help organizations assess their software development and delivery processes and identify areas for improvement.

Collecting DORA metrics can be challenging because it involves gathering data from various sources and tools, ensuring data accuracy and consistency, and dealing with organizational resistance or cultural barriers to measurement and improvement. Tanzu Application Platform is uniquely positioned to provide DORA metrics through its integrated supply chain, offering end-to-end visibility and control over the entire development and deployment process, enabling comprehensive measurement and optimization of DevOps practices.

## <a id="dora metrics"></a> DORA Metrics

**Deployment Frequency**: Measures how often code changes are deployed to an environment. High deployment frequency is often associated with a more mature DevOps culture.

**Lead Time for Changes**: Measures the time it takes to go from code committed to code successfully running in an environment. Shortening this lead time is often a goal of DevOps practices.

**Change Failure Rate**: Assesses the rate at which changes to the production environment result in failures or incidents. Lower failure rates indicate a more reliable software delivery process.

**Mean Time to Recovery (MTTR)**: MTTR measures how quickly an organization can recover from incidents or outages in production. A lower MTTR suggests that an organization is more effective at resolving issues promptly.

## <a id="supported metrics"></a> Supported Metrics

  
| **DORA Metric**     | **TAP 1.7 - DORA Plugin**     |
|------------------------|----------------|
| Deployment Frequency   |      ✓          |
| Lead Time for Changes  |       ✓         |
| Change Failure Rate    |       N/A         |
| Mean Time to Recovery (MTTR) |     N/A           |
  
**Note**: Change Failure Rate and Mean Time to Recovery (MTTR) will be in a future release of the DORA plugin.
