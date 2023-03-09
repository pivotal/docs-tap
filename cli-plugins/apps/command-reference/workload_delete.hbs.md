# tanzu apps workload delete

This command deletes workloads in a cluster. Deleting a workload does not mean the images published
in the registry are deleted with it.

## Default view

A message is displayed in the terminal asking if a workload should be deleted unless the `--yes` flag
is used.
If you indicate "Y", then the workload starts a deletion process inside the cluster.

```console
tanzu apps workload delete spring-pet-clinic
❓ Really delete the workload "spring-pet-clinic"? Yes
👍 Deleted workload "spring-pet-clinic"
```

```console
tanzu apps workload delete spring-pet-clinic --yes
👍 Deleted workload "spring-pet-clinic"
```

## Workload Delete flags

### <a id="delete-all"></a> `--all`

Deletes all workloads in a namespace.

```console
tanzu apps workload delete --all
❓ Really delete all workloads in the namespace "default"? (y/N) Y
👍 Deleted workloads in namespace "default"
```

```console
tanzu apps workload delete --all -n my-namespace
❓ Really delete all workloads in the namespace "my-namespace"? Yes
👍 Deleted workloads in namespace "my-namespace"
```

### <a id="delete-file"></a> `--file`, `-f`

Path to a file that contains the specification of the workload to be deleted.

```console
tanzu apps workload delete -f path/to/file/spring-petclinic.yaml
❓ Really delete the workload "spring-petclinic"? Yes
👍 Deleted workload "spring-petclinic"
```

### <a id="delete-namespace"></a> `--namespace`, `-n`

Specifies the namespace in which the workload is to be deleted.

```console
tanzu apps workload delete spring-petclinic -n spring-petclinic-ns
❓ Really delete the workload "spring-petclinic"? Yes
👍 Deleted workload "spring-petclinic"
```

### <a id="delete-wait"></a> `wait`

Waits until workload is deleted.

```console
tanzu apps workload delete -f path/to/file/spring-petclinic.yaml --wait
❓ Really delete the workload "spring-petclinic"? Yes
👍 Deleted workload "spring-petclinic"
Waiting for workload "spring-petclinic" to be deleted...
Workload "spring-petclinic" was deleted
```

### <a id="delete-wait-timeout"></a> `--wait-timeout`

Sets a timeout to wait for workload to be deleted.

```console
tanzu apps workload delete -f path/to/file/spring-petclinic.yaml --wait --wait-timeout 1m
❓ Really delete the workload "spring-petclinic"? Yes
👍 Deleted workload "spring-petclinic"
Waiting for workload "spring-petclinic" to be deleted...
Workload "spring-petclinic" was deleted
```

```console
tanzu apps workload delete spring-petclinic -n spring-petclinic-ns --wait --wait-timeout 1m
❓ Really delete the workload "spring-petclinic"? Yes
👍 Deleted workload "spring-petclinic"
Waiting for workload "spring-petclinic" to be deleted...
Error: timeout after 1m waiting for "spring-petclinic" to be deleted
To view status run: tanzu apps workload get spring-petclinic --namespace spring-petclinic-ns
Error: exit status 1

✖  exit status 1
```

### <a id="delete-yes"></a> `--yes`, `-f`

Assume yes on all the survey prompts.

```console
tanzu apps workload delete spring-petclinic --yes
👍 Deleted workload "spring-petclinic"
```