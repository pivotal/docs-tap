# tanzu apps workload list

`tanzu apps workload list` gets the workloads present in the cluster, either in the current namespace, in another namespace or in all namespaces.

## Default view

The default view for workload list is a table with the workloads present in the cluster in the specified namespace. This table has, in each row, the name of the workload, the app it is related to, its status and how long it's been in the cluster.

For example, in the default namespace
```bash
tanzu apps workload list

NAME                APP                READY                   AGE
nginx4              <empty>            Ready                   7d9h
petclinic2          <empty>            Ready                   29h
rmq-sample-app      <empty>            Ready                   164m
rmq-sample-app4     <empty>            WorkloadLabelsMissing   29d
spring-pet-clinic   <empty>            Unknown                 166m
spring-petclinic2   spring-petclinic   Unknown                 29d
spring-petclinic3   spring-petclinic   Ready                   29d
```

## >Workload List flags

### <a id="list-all-namespaces"></a> `--all-namespaces`, `-A`

Shows workloads in all namespaces in cluster.

```bash
tanzu apps workload list -A

NAMESPACE   NAME                APP                READY                         AGE
default     nginx4              <empty>            Ready                         7d9h
default     petclinic2          <empty>            Ready                         30h
default     rmq-sample-app      <empty>            Ready                         179m
default     rmq-sample-app4     <empty>            WorkloadLabelsMissing         29d
default     spring-pet-clinic   <empty>            Unknown                       3h1m
default     spring-petclinic2   spring-petclinic   Unknown                       29d
default     spring-petclinic3   spring-petclinic   Ready                         29d
nginx-ns    nginx2              <empty>            TemplateRejectedByAPIServer   8d
nginx-ns    nginx4              <empty>            TemplateRejectedByAPIServer   8d
```

### <a id="list-app"></a> `--app`

Shows workloads which app is the one specified in the command.

```bash
tanzu apps workload list --app spring-petclinic

NAME                READY     AGE
spring-petclinic2   Unknown   29d
spring-petclinic3   Ready     29d
```

### <a id="list-namespace"></a> `--namespace`, `-n`

Lists all the workloads present in the specified namespace.

```bash
tanzu apps workload list -n my-namespace

NAME     APP       READY                         AGE
app1     <empty>   TemplateRejectedByAPIServer   8d
app2     <empty>   Ready                         8d
app3     <empty>   Unknown                       8d
```

### <a id="list-output"></a> `--output`, `-o`

Allows to list all workloads in the specified namespace in yaml, yml or json format.

- yaml/yml
    ```yaml
    ---
    - apiVersion: carto.run/v1alpha1
    kind: Workload
    metadata:
        creationTimestamp: "2022-05-17T22:06:49Z"
        generation: 1
        labels:
        app.kubernetes.io/part-of: spring-petclinic
        apps.tanzu.vmware.com/workload-type: web
        managedFields:
        ...
        ...
        manager: cartographer
        operation: Update
        time: "2022-05-17T22:06:52Z"
    name: spring-petclinic3
    namespace: default
    resourceVersion: "106252670"
    uid: fcca2d4b-c713-43a5-9a53-9f1ebb214726
    spec:
        source:
            git:
                ref:
                    tag: tap-1.1
                url: https://github.com/sample-accelerators/spring-petclinic
    ...
    ...
    ---
    - apiVersion: carto.run/v1alpha1
    kind: Workload
    metadata:
        creationTimestamp: "2022-05-17T22:06:49Z"
        generation: 1
        labels:
        app.kubernetes.io/part-of: spring-petclinic
        apps.tanzu.vmware.com/workload-type: web
        managedFields:
        ...
        ...
        manager: cartographer
        operation: Update
        time: "2022-05-17T22:06:52Z"
    name: spring-petclinic2
    namespace: default
    resourceVersion: "106252670"
    uid: fcca2d4b-c713-43a5-9a53-9f1ebb214726
    spec:
        source:
            git:
                ref:
                    tag: tap-1.1
                url: https://github.com/sample-accelerators/spring-petclinic
    ...
    ...
    ```

- json
    ```json
    [
        {
            "kind": "Workload",
            "apiVersion": "carto.run/v1alpha1",
            "metadata": {
                "name": "spring-petclinic3",
                "namespace": "default",
                "uid": "fcca2d4b-c713-43a5-9a53-9f1ebb214726",
                "resourceVersion": "106252670",
                "generation": 1,
                "creationTimestamp": "2022-05-17T22:06:49Z",
                "labels": {
                    "app.kubernetes.io/part-of": "spring-petclinic",
                    "apps.tanzu.vmware.com/workload-type": "web"
                },
            ...
            }
        ...
        },
        {
            "kind": "Workload",
            "apiVersion": "carto.run/v1alpha1",
            "metadata": {
                "name": "spring-petclinic2",
                "namespace": "default",
                "uid": "fcca2d4b-c713-43a5-9a53-9f1ebb214726",
                "resourceVersion": "106252670",
                "generation": 1,
                "creationTimestamp": "2022-05-17T22:06:49Z",
                "labels": {
                    "app.kubernetes.io/part-of": "spring-petclinic",
                    "apps.tanzu.vmware.com/workload-type": "web"
                },
            ...
            }
        ...
        },
    ...
    ...
    ]
    ```
