# Services Toolkit limitations

This topic tells you about the limitations related to working with services on Tanzu Application Platform
(commonly known as TAP).

## <a id="multi-workloads"></a> Cannot claim and bind to the same service instance from across multiple namespaces

Two or more workloads located in two or more distinct namespaces cannot claim and bind to the same
service instance.
This is due to the mutually exclusive nature of claims. After a claim has claimed a service instance,
no other claim can then claim that same service instance.

This limitation does not exist for two or more workloads located in the same namespace.
In this case, the workloads can all still all bind to one claim.
This is not possible across the namespace divide.
