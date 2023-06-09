# Install Tanzu Application Platform through GitOps with External Secrets Operator (ESO)

>**Caution** Tanzu Application Platform (GitOps) is currently in beta and is intended for evaluation and test purposes only. Do not use in a production environment.

<!-- TODO: use markdown-generated anchor values to ease navigating within VS Code (and validating links). -->

This topic tells you how to install Tanzu Application Platform (commonly known as TAP) 
through GitOps with secrets managed externally in AWS Secrets Manager. 

Select a secrets manager for external secret storage:

- [AWS Secrets Manager](eso/aws-secrets-manager.hbs.md)
- [Hashicorp Vault](eso/hashicorp-vault.hbs.md)

Tanzu GitOps Reference Implememtation (RI) does not support changing the secrets management strategy for a cluster.
