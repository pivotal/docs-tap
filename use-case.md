## TAP Repo Bundle Installation

1. Make sure kubernetes cluster is created and it's configured properly. 
```
vdesikan@vdesikan-a01 ~ % kubectl config get-contexts
CURRENT   NAME                                                                CLUSTER                                                   AUTHINFO                                                  NAMESPACE
*         arn:aws:eks:us-east-2:808682851023:cluster/tae-beta-ecs             arn:aws:eks:us-east-2:808682851023:cluster/tae-beta-ecs   arn:aws:eks:us-east-2:808682851023:cluster/tae-beta-ecs
vdesikan@vdesikan-a01 ~ % kubectl config current-context
arn:aws:eks:us-east-2:808682851023:cluster/tae-beta-ecs
vdesikan@vdesikan-a01 ~ % kubectl cluster-info
Kubernetes control plane is running at https://94A70B79EF7B1D5E718A4E96B2925F91.gr7.us-east-2.eks.amazonaws.com
CoreDNS is running at https://94A70B79EF7B1D5E718A4E96B2925F91.gr7.us-east-2.eks.amazonaws.com/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
 
To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
vdesikan@vdesikan-a01 ~ % kubectl get pods -A
NAMESPACE     NAME                       READY   STATUS    RESTARTS   AGE
kube-system   aws-node-2fzbz             1/1     Running   0          4d
kube-system   aws-node-4s2vw             1/1     Running   0          4d
kube-system   aws-node-jf8vp             1/1     Running   0          4d
kube-system   aws-node-m4rz7             1/1     Running   0          4d
kube-system   coredns-5c778788f4-bl47d   1/1     Running   0          4d
kube-system   coredns-5c778788f4-swf2n   1/1     Running   0          4d
kube-system   kube-proxy-dcbwg           1/1     Running   0          4d
kube-system   kube-proxy-rq6gh           1/1     Running   0          4d
kube-system   kube-proxy-sbsrz           1/1     Running   0          4d
kube-system   kube-proxy-xl2b5           1/1     Running   0          4d
vdesikan@vdesikan-a01 ~ % kubectl get ns
NAME              STATUS   AGE
default           Active   4d
kube-node-lease   Active   4d
kube-public       Active   4d
kube-system       Active   4d
vdesikan@vdesikan-a01 ~ % kubectl get nodes -o wide
NAME                                          STATUS   ROLES    AGE   VERSION              INTERNAL-IP     EXTERNAL-IP      OS-IMAGE         KERNEL-VERSION                CONTAINER-RUNTIME
ip-172-31-18-218.us-east-2.compute.internal   Ready    <none>   4d    v1.20.4-eks-6b7464   172.31.18.218   18.118.114.102   Amazon Linux 2   5.4.129-63.229.amzn2.x86_64   docker://19.3.13
ip-172-31-30-192.us-east-2.compute.internal   Ready    <none>   4d    v1.20.4-eks-6b7464   172.31.30.192   3.143.242.102    Amazon Linux 2   5.4.129-63.229.amzn2.x86_64   docker://19.3.13
ip-172-31-46-226.us-east-2.compute.internal   Ready    <none>   4d    v1.20.4-eks-6b7464   172.31.46.226   18.223.16.117    Amazon Linux 2   5.4.129-63.229.amzn2.x86_64   docker://19.3.13
ip-172-31-6-194.us-east-2.compute.internal    Ready    <none>   4d    v1.20.4-eks-6b7464   172.31.6.194    18.222.111.53    Amazon Linux 2   5.4.129-63.229.amzn2.x86_64   docker://19.3.13
vdesikan@vdesikan-a01 ~ % kubectl get service -A
NAMESPACE     NAME         TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)         AGE
default       kubernetes   ClusterIP   10.100.0.1    <none>        443/TCP         4d
kube-system   kube-dns     ClusterIP   10.100.0.10   <none>        53/UDP,53/TCP   4d
```
2. Deploy kapp-controller.
```
vdesikan@vdesikan-a01 ~ % kapp deploy -a kc -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml
 
Target cluster 'https://94A70B79EF7B1D5E718A4E96B2925F91.gr7.us-east-2.eks.amazonaws.com' (nodes: ip-172-31-46-226.us-east-2.compute.internal, 3+)
 
Changes
 
Namespace        Name                                                    Kind                      Conds.  Age  Op      Op st.  Wait to    Rs  Ri
(cluster)        apps.kappctrl.k14s.io                                   CustomResourceDefinition  -       -    create  -       reconcile  -   -
^                internalpackagemetadatas.internal.packaging.carvel.dev  CustomResourceDefinition  -       -    create  -       reconcile  -   -
^                internalpackages.internal.packaging.carvel.dev          CustomResourceDefinition  -       -    create  -       reconcile  -   -
^                kapp-controller                                         Namespace                 -       -    create  -       reconcile  -   -
^                kapp-controller-cluster-role                            ClusterRole               -       -    create  -       reconcile  -   -
^                kapp-controller-cluster-role-binding                    ClusterRoleBinding        -       -    create  -       reconcile  -   -
^                kapp-controller-packaging-global                        Namespace                 -       -    create  -       reconcile  -   -
^                packageinstalls.packaging.carvel.dev                    CustomResourceDefinition  -       -    create  -       reconcile  -   -
^                packagerepositories.packaging.carvel.dev                CustomResourceDefinition  -       -    create  -       reconcile  -   -
^                pkg-apiserver:system:auth-delegator                     ClusterRoleBinding        -       -    create  -       reconcile  -   -
^                v1alpha1.data.packaging.carvel.dev                      APIService                -       -    create  -       reconcile  -   -
kapp-controller  kapp-controller                                         Deployment                -       -    create  -       reconcile  -   -
^                kapp-controller-sa                                      ServiceAccount            -       -    create  -       reconcile  -   -
^                packaging-api                                           Service                   -       -    create  -       reconcile  -   -
kube-system      pkgserver-auth-reader                                   RoleBinding               -       -    create  -       reconcile  -   -
 
Op:      15 create, 0 delete, 0 update, 0 noop
Wait to: 15 reconcile, 0 delete, 0 noop
 
Continue? [yN]: y
 
4:34:34PM: ---- applying 10 changes [0/15 done] ----
4:34:35PM: create clusterrolebinding/pkg-apiserver:system:auth-delegator (rbac.authorization.k8s.io/v1) cluster
4:34:35PM: create namespace/kapp-controller-packaging-global (v1) cluster
4:34:35PM: create namespace/kapp-controller (v1) cluster
4:34:35PM: create clusterrole/kapp-controller-cluster-role (rbac.authorization.k8s.io/v1) cluster
4:34:36PM: create clusterrolebinding/kapp-controller-cluster-role-binding (rbac.authorization.k8s.io/v1) cluster
4:34:36PM: create customresourcedefinition/packagerepositories.packaging.carvel.dev (apiextensions.k8s.io/v1) cluster
4:34:36PM: create customresourcedefinition/packageinstalls.packaging.carvel.dev (apiextensions.k8s.io/v1) cluster
4:34:36PM: create customresourcedefinition/apps.kappctrl.k14s.io (apiextensions.k8s.io/v1) cluster
4:34:37PM: create customresourcedefinition/internalpackagemetadatas.internal.packaging.carvel.dev (apiextensions.k8s.io/v1) cluster
4:34:38PM: create customresourcedefinition/internalpackages.internal.packaging.carvel.dev (apiextensions.k8s.io/v1) cluster
4:34:38PM: ---- waiting on 10 changes [0/15 done] ----
4:34:38PM: ok: reconcile namespace/kapp-controller-packaging-global (v1) cluster
4:34:38PM: ok: reconcile clusterrolebinding/kapp-controller-cluster-role-binding (rbac.authorization.k8s.io/v1) cluster
4:34:38PM: ok: reconcile clusterrolebinding/pkg-apiserver:system:auth-delegator (rbac.authorization.k8s.io/v1) cluster
4:34:38PM: ok: reconcile customresourcedefinition/internalpackages.internal.packaging.carvel.dev (apiextensions.k8s.io/v1) cluster
4:34:38PM: ok: reconcile namespace/kapp-controller (v1) cluster
4:34:38PM: ok: reconcile customresourcedefinition/packagerepositories.packaging.carvel.dev (apiextensions.k8s.io/v1) cluster
4:34:38PM: ok: reconcile customresourcedefinition/packageinstalls.packaging.carvel.dev (apiextensions.k8s.io/v1) cluster
4:34:38PM: ok: reconcile customresourcedefinition/apps.kappctrl.k14s.io (apiextensions.k8s.io/v1) cluster
4:34:38PM: ok: reconcile clusterrole/kapp-controller-cluster-role (rbac.authorization.k8s.io/v1) cluster
4:34:38PM: ok: reconcile customresourcedefinition/internalpackagemetadatas.internal.packaging.carvel.dev (apiextensions.k8s.io/v1) cluster
4:34:38PM: ---- applying 3 changes [10/15 done] ----
4:34:39PM: create rolebinding/pkgserver-auth-reader (rbac.authorization.k8s.io/v1) namespace: kube-system
4:34:41PM: create serviceaccount/kapp-controller-sa (v1) namespace: kapp-controller
4:34:41PM: create apiservice/v1alpha1.data.packaging.carvel.dev (apiregistration.k8s.io/v1) cluster
4:34:41PM: ---- waiting on 3 changes [10/15 done] ----
4:34:41PM: ok: reconcile serviceaccount/kapp-controller-sa (v1) namespace: kapp-controller
4:34:41PM: ok: reconcile rolebinding/pkgserver-auth-reader (rbac.authorization.k8s.io/v1) namespace: kube-system
4:34:41PM: ongoing: reconcile apiservice/v1alpha1.data.packaging.carvel.dev (apiregistration.k8s.io/v1) cluster
4:34:41PM:  ^ Condition Available is not True (False)
4:34:41PM: ---- applying 2 changes [13/15 done] ----
4:34:41PM: create service/packaging-api (v1) namespace: kapp-controller
4:34:43PM: create deployment/kapp-controller (apps/v1) namespace: kapp-controller
4:34:43PM: ---- waiting on 3 changes [12/15 done] ----
4:34:43PM: ok: reconcile service/packaging-api (v1) namespace: kapp-controller
4:34:45PM: ongoing: reconcile deployment/kapp-controller (apps/v1) namespace: kapp-controller
4:34:45PM:  ^ Waiting for 1 unavailable replicas
4:34:45PM:  L ok: waiting on replicaset/kapp-controller-ff4656bb (apps/v1) namespace: kapp-controller
4:34:45PM:  L ongoing: waiting on pod/kapp-controller-ff4656bb-cjrl7 (v1) namespace: kapp-controller
4:34:45PM:     ^ Pending: ContainerCreating
4:34:45PM: ---- waiting on 2 changes [13/15 done] ----
4:35:01PM: ongoing: reconcile deployment/kapp-controller (apps/v1) namespace: kapp-controller
4:35:01PM:  ^ Waiting for 1 unavailable replicas
4:35:01PM:  L ok: waiting on replicaset/kapp-controller-ff4656bb (apps/v1) namespace: kapp-controller
4:35:01PM:  L ok: waiting on pod/kapp-controller-ff4656bb-cjrl7 (v1) namespace: kapp-controller
4:35:05PM: ok: reconcile deployment/kapp-controller (apps/v1) namespace: kapp-controller
4:35:05PM: ---- waiting on 1 changes [14/15 done] ----
4:35:06PM: ok: reconcile apiservice/v1alpha1.data.packaging.carvel.dev (apiregistration.k8s.io/v1) cluster
4:35:06PM: ---- applying complete [15/15 done] ----
4:35:06PM: ---- waiting complete [15/15 done] ----
 
Succeeded
```
3. Create secret.
```
vdesikan@vdesikan-a01 ~ % kubectl create ns tap-install
 
namespace/tap-install created
vdesikan@vdesikan-a01 ~ % kubectl create secret docker-registry tap-registry -n tap-install --docker-server='registry.pivotal.io' --docker-username=$USRFULL --docker-password=$PASS
 
secret/tap-registry created
```
4. Instal TAP repo bundle.
```
vdesikan@vdesikan-a01 tap-install % more tap-package-repo.yml
apiVersion: packaging.carvel.dev/v1alpha1
kind: PackageRepository
metadata:
  name: tanzu-application-platform-packages
spec:
  fetch:
    imgpkgBundle:
      image: registry.pivotal.io/tanzu-application-platform/tap-packages:0.1.0
      secretRef:
        name: tap-registry
vdesikan@vdesikan-a01 tap-install % kapp deploy -a tap-package-repo -n tap-install -f ./tap-package-repo.yml -y
 
Target cluster 'https://94A70B79EF7B1D5E718A4E96B2925F91.gr7.us-east-2.eks.amazonaws.com' (nodes: ip-172-31-46-226.us-east-2.compute.internal, 3+)
 
Changes
 
Namespace    Name                                 Kind               Conds.  Age  Op      Op st.  Wait to    Rs  Ri
tap-install  tanzu-application-platform-packages  PackageRepository  -       -    create  -       reconcile  -   -
 
Op:      1 create, 0 delete, 0 update, 0 noop
Wait to: 1 reconcile, 0 delete, 0 noop
 
4:40:46PM: ---- applying 1 changes [0/1 done] ----
4:40:48PM: create packagerepository/tanzu-application-platform-packages (packaging.carvel.dev/v1alpha1) namespace: tap-install
4:40:48PM: ---- waiting on 1 changes [0/1 done] ----
4:40:48PM: ok: reconcile packagerepository/tanzu-application-platform-packages (packaging.carvel.dev/v1alpha1) namespace: tap-install
4:40:48PM: ---- applying complete [1/1 done] ----
4:40:48PM: ---- waiting complete [1/1 done] ----
 
Succeeded
vdesikan@vdesikan-a01 tap-install % tanzu package repository list -n tap-install
/ Retrieving repositories...
  NAME                                 REPOSITORY                                                         STATUS               DETAILS
  tanzu-application-platform-packages  registry.pivotal.io/tanzu-application-platform/tap-packages:0.1.0  Reconcile succeeded
vdesikan@vdesikan-a01 tap-install % tanzu package available list -n tap-install
/ Retrieving available packages...
  NAME                               DISPLAY-NAME                              SHORT-DESCRIPTION
  accelerator.apps.tanzu.vmware.com  Application Accelerator for VMware Tanzu  Used to create new projects and configurations.
  appliveview.tanzu.vmware.com       Application Live View for VMware Tanzu    App for monitoring and troubleshooting running apps
  cnrs.tanzu.vmware.com              Cloud Native Runtimes                     Cloud Native Runtimes is a serverless runtime based on Knative
vdesikan@vdesikan-a01 tap-install % tanzu package available list accelerator.apps.tanzu.vmware.com -n tap-install
- Retrieving package versions for accelerator.apps.tanzu.vmware.com...
  NAME                               VERSION  RELEASED-AT
  accelerator.apps.tanzu.vmware.com  0.2.0    2021-09-01T00:00:00Z
vdesikan@vdesikan-a01 tap-install % tanzu package available list appliveview.tanzu.vmware.com -n tap-install
- Retrieving package versions for appliveview.tanzu.vmware.com...
  NAME                          VERSION  RELEASED-AT
  appliveview.tanzu.vmware.com  0.1.0    2021-09-01T00:00:00Z
vdesikan@vdesikan-a01 tap-install % tanzu package available list cnrs.tanzu.vmware.com -n tap-install
/ Retrieving package versions for cnrs.tanzu.vmware.com...
  NAME                   VERSION  RELEASED-AT
  cnrs.tanzu.vmware.com  1.0.1    2021-07-30T15:18:46Z
```
5. Check for schema of the packages and create appropriate values.yml files for the same.
```
vdesikan@vdesikan-a01 tap-install % tanzu package available get cnrs.tanzu.vmware.com/1.0.1 --values-schema -n tap-install
| Retrieving package details for cnrs.tanzu.vmware.com/1.0.1...
  KEY                         DEFAULT  TYPE     DESCRIPTION
  ingress.internal.namespace  <nil>    string   internal namespace
  ingress.reuse_crds          false    boolean  set true to reuse existing Contour instance
  ingress.external.namespace  <nil>    string   external namespace
  local_dns.domain            <nil>    string   domain name
  local_dns.enable            false    boolean  specify true if local DNS needs to be enabled
  pdb.enable                  true     boolean  <nil>
  provider                    <nil>    string   Kubernetes cluster provider
  registry.password           <nil>    string   registry password
  registry.server             <nil>    string   registry server
  registry.username           <nil>    string   registry username
vdesikan@vdesikan-a01 tap-install % tanzu package available get appliveview.tanzu.vmware.com/0.1.0 --values-schema -n tap-install
| Retrieving package details for appliveview.tanzu.vmware.com/0.1.0...
  KEY                DEFAULT  TYPE    DESCRIPTION
  registry.password  <nil>    string  Image Registry Password
  registry.server    <nil>    string  Image Registry URL
  registry.username  <nil>    string  Image Registry Username
vdesikan@vdesikan-a01 tap-install % tanzu package available get accelerator.apps.tanzu.vmware.com/0.2.0 --values-schema -n tap-install
| Retrieving package details for accelerator.apps.tanzu.vmware.com/0.2.0...
  KEY                           DEFAULT                                                             TYPE    DESCRIPTION
  engine.service_type           ClusterIP                                                           string  The service type for the Service of the engine.
  registry.password                                                                                 string  The password to use for authenticating with the registry where the App-Accelerator images are located.
  registry.server               registry.pivotal.io                                                 string  The hostname for the registry where the App-Accelerator images are located.
  registry.username                                                                                 string  The username to use for authenticating with the registry where the App-Accelerator images are located.
  server.watched_namespace      default                                                             string  The namespace that the server watches for accelerator resources.
  server.engine_invocation_url  http://acc-engine.accelerator-system.svc.cluster.local/invocations  string  The URL the server uses for invoking the accelerator engine.
  server.service_type           LoadBalancer
vdesikan@vdesikan-a01 tap-install % more values-cnr.yml
---
registry:
 server: registry.pivotal.io
 username: <username>
 Password: <password>
 
 
provider:
pdb:
 enable: true
 
 
ingress:
 reuse_crds:
 external:
   namespace:
 internal:
   namespace:
 
 
Local_dns:
vdesikan@vdesikan-a01 tap-install % more values-alv.yml
---
registry:
  server: registry.pivotal.io
  username: <username>
  password: <password>
vdesikan@vdesikan-a01 tap-install % more values-acc.yml
registry:
  server: "registry.pivotal.io"
  username: <username>
  password: <password>
server:
  service_type: "LoadBalancer"
  watched_namespace: "default"
  engine_invocation_url: "http://acc-engine.accelerator-system.svc.cluster.local/invocations"
engine:
  service_type: "ClusterIP"
```
6. Install CNR
```
vdesikan@vdesikan-a01 tap-install % tanzu package install cloud-native-runtimes -p cnrs.tanzu.vmware.com -v 1.0.1 -n tap-install
- Installing package 'cnrs.tanzu.vmware.com'
- Getting package metadata for 'cnrs.tanzu.vmware.com'
\ Creating service account 'cloud-native-runtimes-tap-install-sa'
- Creating cluster admin role 'cloud-native-runtimes-tap-install-cluster-role'
\ Creating cluster role binding 'cloud-native-runtimes-tap-install-cluster-rolebinding'
| Creating package resource
- Package install status: Reconciling
 
 Added installed package 'cloud-native-runtimes' in namespace 'tap-install'
vdesikan@vdesikan-a01 tap-install % kubectl get pods -A
NAMESPACE           NAME                                           READY   STATUS    RESTARTS   AGE
contour-external    contour-7c7795856b-8mqlz                       1/1     Running   0          79s
contour-external    contour-7c7795856b-8xh6c                       1/1     Running   0          79s
contour-external    envoy-7fzmk                                    2/2     Running   0          79s
contour-external    envoy-ccrgj                                    2/2     Running   0          79s
contour-external    envoy-fndxp                                    2/2     Running   0          79s
contour-external    envoy-mcbfr                                    2/2     Running   0          79s
contour-internal    contour-5b6b565d-6sbx4                         1/1     Running   0          79s
contour-internal    contour-5b6b565d-lhmvn                         1/1     Running   0          79s
contour-internal    envoy-l2tc6                                    2/2     Running   0          79s
contour-internal    envoy-mv7x2                                    2/2     Running   0          79s
contour-internal    envoy-rnhtf                                    2/2     Running   0          79s
contour-internal    envoy-t2llr                                    2/2     Running   0          79s
kapp-controller     kapp-controller-ff4656bb-cjrl7                 1/1     Running   0          14m
knative-discovery   controller-b59bd9449-8l9f4                     1/1     Running   0          77s
knative-discovery   webhook-54c56fc5b8-8djnb                       1/1     Running   0          77s
knative-eventing    eventing-controller-6c7fbfdb79-7vr4w           1/1     Running   0          79s
knative-eventing    eventing-webhook-5885fcccc9-7b5lh              1/1     Running   0          79s
knative-eventing    eventing-webhook-5885fcccc9-vbgzs              1/1     Running   0          64s
knative-eventing    imc-controller-bdb84c8ff-q67gj                 1/1     Running   0          79s
knative-eventing    imc-dispatcher-586bd55496-6j97d                1/1     Running   0          78s
knative-eventing    mt-broker-controller-785589dd9d-vlx6v          1/1     Running   0          78s
knative-eventing    mt-broker-filter-7dfcf6589-fjhmz               1/1     Running   0          78s
knative-eventing    mt-broker-ingress-688cc7f74-l46p9              1/1     Running   0          78s
knative-eventing    rabbitmq-broker-controller-85d5b56f8-kwz9x     1/1     Running   0          77s
knative-serving     activator-5b59f7c699-4cvts                     1/1     Running   0          65s
knative-serving     activator-5b59f7c699-4mbtl                     1/1     Running   0          81s
knative-serving     activator-5b59f7c699-sk2m5                     1/1     Running   0          65s
knative-serving     autoscaler-8f85d46c-g4tnh                      1/1     Running   0          81s
knative-serving     contour-ingress-controller-8fbc54c-whghl       1/1     Running   0          79s
knative-serving     controller-645bdbc7d9-z5n5v                    1/1     Running   0          81s
knative-serving     net-certmanager-webhook-dcdc76d4-qnxzg         1/1     Running   0          77s
knative-serving     networking-certmanager-7575777f9f-t4tf9        1/1     Running   0          77s
knative-serving     webhook-7cb844897b-sdqrz                       1/1     Running   0          80s
knative-serving     webhook-7cb844897b-tkszw                       1/1     Running   0          65s
knative-sources     rabbitmq-controller-manager-5dcb7c8494-t7c8k   1/1     Running   0          76s
knative-sources     rabbitmq-webhook-bcb77f84f-2d6fw               1/1     Running   0          76s
kube-system         aws-node-2fzbz                                 1/1     Running   0          4d
kube-system         aws-node-4s2vw                                 1/1     Running   0          4d
kube-system         aws-node-jf8vp                                 1/1     Running   0          4d
kube-system         aws-node-m4rz7                                 1/1     Running   0          4d
kube-system         coredns-5c778788f4-bl47d                       1/1     Running   0          4d
kube-system         coredns-5c778788f4-swf2n                       1/1     Running   0          4d
kube-system         kube-proxy-dcbwg                               1/1     Running   0          4d
kube-system         kube-proxy-rq6gh                               1/1     Running   0          4d
kube-system         kube-proxy-sbsrz                               1/1     Running   0          4d
kube-system         kube-proxy-xl2b5                               1/1     Running   0          4d
triggermesh         aws-event-sources-controller-7f9dd6d69-6ldbs   1/1     Running   0          81s
vmware-sources      webhook-c9f67b5cd-tjv4p                        1/1     Running   0          78s
vdesikan@vdesikan-a01 tap-install % kapp list -A
Target cluster 'https://94A70B79EF7B1D5E718A4E96B2925F91.gr7.us-east-2.eks.amazonaws.com' (nodes: ip-172-31-46-226.us-east-2.compute.internal, 3+)
 
Apps in all namespaces
 
Namespace    Name                                      Namespaces                                                  Lcs   Lca
default      kc                                        (cluster),kapp-controller,kube-system                       true  14m
tap-install  cloud-native-runtimes-ctrl                (cluster),contour-external,                                 true  10s
                                                       contour-internal,knative-discovery,knative-eventing,
                                                       knative-serving,knative-sources,triggermesh,vmware-sources
^            tanzu-application-platform-packages-ctrl  tap-install                                                 true  8m
^            tap-package-repo                          tap-install                                                 true  8m
 
Lcs: Last Change Successful
Lca: Last Change Age
 
4 apps
 
Succeeded
vdesikan@vdesikan-a01 tap-install % tanzu package  installed  list -A
/ Retrieving installed packages...
  NAME                   PACKAGE-NAME           PACKAGE-VERSION  STATUS               NAMESPACE
  cloud-native-runtimes  cnrs.tanzu.vmware.com  1.0.1            Reconcile succeeded  tap-install
```
7. Instal flux and after installation delete the network policies.
```
vdesikan@vdesikan-a01 tap-install % kapp deploy -a flux -f https://github.com/fluxcd/flux2/releases/download/v0.15.0/install.yaml
 
Target cluster 'https://94A70B79EF7B1D5E718A4E96B2925F91.gr7.us-east-2.eks.amazonaws.com' (nodes: ip-172-31-46-226.us-east-2.compute.internal, 3+)
 
Changes
 
Namespace    Name                                            Kind                      Conds.  Age  Op      Op st.  Wait to    Rs  Ri
(cluster)    alerts.notification.toolkit.fluxcd.io           CustomResourceDefinition  -       -    create  -       reconcile  -   -
^            buckets.source.toolkit.fluxcd.io                CustomResourceDefinition  -       -    create  -       reconcile  -   -
^            cluster-reconciler                              ClusterRoleBinding        -       -    create  -       reconcile  -   -
^            crd-controller                                  ClusterRole               -       -    create  -       reconcile  -   -
^            crd-controller                                  ClusterRoleBinding        -       -    create  -       reconcile  -   -
^            flux-system                                     Namespace                 -       -    create  -       reconcile  -   -
^            gitrepositories.source.toolkit.fluxcd.io        CustomResourceDefinition  -       -    create  -       reconcile  -   -
^            helmcharts.source.toolkit.fluxcd.io             CustomResourceDefinition  -       -    create  -       reconcile  -   -
^            helmreleases.helm.toolkit.fluxcd.io             CustomResourceDefinition  -       -    create  -       reconcile  -   -
^            helmrepositories.source.toolkit.fluxcd.io       CustomResourceDefinition  -       -    create  -       reconcile  -   -
^            imagepolicies.image.toolkit.fluxcd.io           CustomResourceDefinition  -       -    create  -       reconcile  -   -
^            imagerepositories.image.toolkit.fluxcd.io       CustomResourceDefinition  -       -    create  -       reconcile  -   -
^            imageupdateautomations.image.toolkit.fluxcd.io  CustomResourceDefinition  -       -    create  -       reconcile  -   -
^            kustomizations.kustomize.toolkit.fluxcd.io      CustomResourceDefinition  -       -    create  -       reconcile  -   -
^            providers.notification.toolkit.fluxcd.io        CustomResourceDefinition  -       -    create  -       reconcile  -   -
^            receivers.notification.toolkit.fluxcd.io        CustomResourceDefinition  -       -    create  -       reconcile  -   -
flux-system  allow-egress                                    NetworkPolicy             -       -    create  -       reconcile  -   -
^            allow-scraping                                  NetworkPolicy             -       -    create  -       reconcile  -   -
^            allow-webhooks                                  NetworkPolicy             -       -    create  -       reconcile  -   -
^            helm-controller                                 Deployment                -       -    create  -       reconcile  -   -
^            helm-controller                                 ServiceAccount            -       -    create  -       reconcile  -   -
^            image-automation-controller                     Deployment                -       -    create  -       reconcile  -   -
^            image-automation-controller                     ServiceAccount            -       -    create  -       reconcile  -   -
^            image-reflector-controller                      Deployment                -       -    create  -       reconcile  -   -
^            image-reflector-controller                      ServiceAccount            -       -    create  -       reconcile  -   -
^            kustomize-controller                            Deployment                -       -    create  -       reconcile  -   -
^            kustomize-controller                            ServiceAccount            -       -    create  -       reconcile  -   -
^            notification-controller                         Deployment                -       -    create  -       reconcile  -   -
^            notification-controller                         Service                   -       -    create  -       reconcile  -   -
^            notification-controller                         ServiceAccount            -       -    create  -       reconcile  -   -
^            source-controller                               Deployment                -       -    create  -       reconcile  -   -
^            source-controller                               Service                   -       -    create  -       reconcile  -   -
^            source-controller                               ServiceAccount            -       -    create  -       reconcile  -   -
^            webhook-receiver                                Service                   -       -    create  -       reconcile  -   -
 
Op:      34 create, 0 delete, 0 update, 0 noop
Wait to: 34 reconcile, 0 delete, 0 noop
 
Continue? [yN]: y
 
4:50:45PM: ---- applying 16 changes [0/34 done] ----
4:50:46PM: create clusterrolebinding/crd-controller (rbac.authorization.k8s.io/v1) cluster
4:50:47PM: create customresourcedefinition/providers.notification.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:47PM: create customresourcedefinition/imagepolicies.image.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:47PM: create customresourcedefinition/gitrepositories.source.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:48PM: create customresourcedefinition/helmreleases.helm.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:48PM: create customresourcedefinition/imageupdateautomations.image.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:48PM: create clusterrole/crd-controller (rbac.authorization.k8s.io/v1) cluster
4:50:49PM: create clusterrolebinding/cluster-reconciler (rbac.authorization.k8s.io/v1) cluster
4:50:49PM: create customresourcedefinition/imagerepositories.image.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:50PM: create customresourcedefinition/helmrepositories.source.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:50PM: create customresourcedefinition/kustomizations.kustomize.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:50PM: create namespace/flux-system (v1) cluster
4:50:50PM: create customresourcedefinition/receivers.notification.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:51PM: create customresourcedefinition/alerts.notification.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:52PM: create customresourcedefinition/buckets.source.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:52PM: create customresourcedefinition/helmcharts.source.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:52PM: ---- waiting on 16 changes [0/34 done] ----
4:50:52PM: ok: reconcile clusterrolebinding/cluster-reconciler (rbac.authorization.k8s.io/v1) cluster
4:50:52PM: ok: reconcile customresourcedefinition/gitrepositories.source.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:52PM: ok: reconcile customresourcedefinition/helmcharts.source.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:52PM: ok: reconcile customresourcedefinition/buckets.source.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:52PM: ok: reconcile namespace/flux-system (v1) cluster
4:50:52PM: ok: reconcile customresourcedefinition/providers.notification.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:52PM: ok: reconcile customresourcedefinition/receivers.notification.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:52PM: ok: reconcile clusterrolebinding/crd-controller (rbac.authorization.k8s.io/v1) cluster
4:50:52PM: ok: reconcile customresourcedefinition/alerts.notification.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:52PM: ok: reconcile customresourcedefinition/helmrepositories.source.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:52PM: ok: reconcile clusterrole/crd-controller (rbac.authorization.k8s.io/v1) cluster
4:50:52PM: ok: reconcile customresourcedefinition/imagerepositories.image.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:52PM: ok: reconcile customresourcedefinition/imageupdateautomations.image.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:52PM: ok: reconcile customresourcedefinition/helmreleases.helm.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:53PM: ok: reconcile customresourcedefinition/kustomizations.kustomize.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:53PM: ok: reconcile customresourcedefinition/imagepolicies.image.toolkit.fluxcd.io (apiextensions.k8s.io/v1) cluster
4:50:53PM: ---- applying 9 changes [16/34 done] ----
4:50:53PM: create networkpolicy/allow-webhooks (networking.k8s.io/v1) namespace: flux-system
4:50:54PM: create networkpolicy/allow-egress (networking.k8s.io/v1) namespace: flux-system
4:50:55PM: create serviceaccount/image-reflector-controller (v1) namespace: flux-system
4:50:55PM: create serviceaccount/image-automation-controller (v1) namespace: flux-system
4:50:55PM: create serviceaccount/kustomize-controller (v1) namespace: flux-system
4:50:55PM: create serviceaccount/source-controller (v1) namespace: flux-system
4:50:55PM: create networkpolicy/allow-scraping (networking.k8s.io/v1) namespace: flux-system
4:50:56PM: create serviceaccount/notification-controller (v1) namespace: flux-system
4:50:57PM: create serviceaccount/helm-controller (v1) namespace: flux-system
4:50:57PM: ---- waiting on 9 changes [16/34 done] ----
4:50:57PM: ok: reconcile serviceaccount/source-controller (v1) namespace: flux-system
4:50:57PM: ok: reconcile serviceaccount/image-automation-controller (v1) namespace: flux-system
4:50:57PM: ok: reconcile serviceaccount/helm-controller (v1) namespace: flux-system
4:50:57PM: ok: reconcile serviceaccount/image-reflector-controller (v1) namespace: flux-system
4:50:57PM: ok: reconcile networkpolicy/allow-egress (networking.k8s.io/v1) namespace: flux-system
4:50:58PM: ok: reconcile networkpolicy/allow-scraping (networking.k8s.io/v1) namespace: flux-system
4:50:58PM: ok: reconcile serviceaccount/notification-controller (v1) namespace: flux-system
4:50:58PM: ok: reconcile serviceaccount/kustomize-controller (v1) namespace: flux-system
4:50:58PM: ok: reconcile networkpolicy/allow-webhooks (networking.k8s.io/v1) namespace: flux-system
4:50:58PM: ---- applying 9 changes [25/34 done] ----
4:50:58PM: create service/source-controller (v1) namespace: flux-system
4:50:59PM: create service/webhook-receiver (v1) namespace: flux-system
4:50:59PM: create service/notification-controller (v1) namespace: flux-system
4:51:00PM: create deployment/helm-controller (apps/v1) namespace: flux-system
4:51:00PM: create deployment/image-reflector-controller (apps/v1) namespace: flux-system
4:51:00PM: create deployment/source-controller (apps/v1) namespace: flux-system
4:51:00PM: create deployment/kustomize-controller (apps/v1) namespace: flux-system
4:51:01PM: create deployment/image-automation-controller (apps/v1) namespace: flux-system
4:51:02PM: create deployment/notification-controller (apps/v1) namespace: flux-system
4:51:02PM: ---- waiting on 9 changes [25/34 done] ----
4:51:02PM: ok: reconcile service/source-controller (v1) namespace: flux-system
4:51:02PM: ok: reconcile service/webhook-receiver (v1) namespace: flux-system
4:51:02PM: ok: reconcile service/notification-controller (v1) namespace: flux-system
4:51:03PM: ongoing: reconcile deployment/helm-controller (apps/v1) namespace: flux-system
4:51:03PM:  ^ Waiting for 1 unavailable replicas
4:51:03PM:  L ok: waiting on replicaset/helm-controller-68996c978c (apps/v1) namespace: flux-system
4:51:03PM:  L ongoing: waiting on pod/helm-controller-68996c978c-rlfnb (v1) namespace: flux-system
4:51:03PM:     ^ Condition Ready is not True (False)
4:51:03PM: ongoing: reconcile deployment/notification-controller (apps/v1) namespace: flux-system
4:51:03PM:  ^ Waiting for 1 unavailable replicas
4:51:03PM:  L ok: waiting on replicaset/notification-controller-6fd769cbf4 (apps/v1) namespace: flux-system
4:51:03PM:  L ongoing: waiting on pod/notification-controller-6fd769cbf4-qn2kk (v1) namespace: flux-system
4:51:03PM:     ^ Condition Ready is not True (False)
4:51:03PM: ongoing: reconcile deployment/image-reflector-controller (apps/v1) namespace: flux-system
4:51:03PM:  ^ Waiting for 1 unavailable replicas
4:51:03PM:  L ok: waiting on replicaset/image-reflector-controller-7784457d8f (apps/v1) namespace: flux-system
4:51:03PM:  L ongoing: waiting on pod/image-reflector-controller-7784457d8f-n82r7 (v1) namespace: flux-system
4:51:03PM:     ^ Condition Ready is not True (False)
4:51:04PM: ongoing: reconcile deployment/source-controller (apps/v1) namespace: flux-system
4:51:04PM:  ^ Waiting for 1 unavailable replicas
4:51:04PM:  L ok: waiting on replicaset/source-controller-648d7f445d (apps/v1) namespace: flux-system
4:51:04PM:  L ongoing: waiting on pod/source-controller-648d7f445d-2h2wc (v1) namespace: flux-system
4:51:04PM:     ^ Pending: ContainerCreating
4:51:04PM: ongoing: reconcile deployment/kustomize-controller (apps/v1) namespace: flux-system
4:51:04PM:  ^ Waiting for 1 unavailable replicas
4:51:04PM:  L ok: waiting on replicaset/kustomize-controller-759f994b (apps/v1) namespace: flux-system
4:51:04PM:  L ongoing: waiting on pod/kustomize-controller-759f994b-tpbrf (v1) namespace: flux-system
4:51:04PM:     ^ Pending: ContainerCreating
4:51:05PM: ongoing: reconcile deployment/image-automation-controller (apps/v1) namespace: flux-system
4:51:05PM:  ^ Waiting for 1 unavailable replicas
4:51:05PM:  L ok: waiting on replicaset/image-automation-controller-68d55fccd8 (apps/v1) namespace: flux-system
4:51:05PM:  L ongoing: waiting on pod/image-automation-controller-68d55fccd8-52wwk (v1) namespace: flux-system
4:51:05PM:     ^ Condition Ready is not True (False)
4:51:05PM: ---- waiting on 6 changes [28/34 done] ----
4:51:06PM: ongoing: reconcile deployment/source-controller (apps/v1) namespace: flux-system
4:51:06PM:  ^ Waiting for 1 unavailable replicas
4:51:06PM:  L ok: waiting on replicaset/source-controller-648d7f445d (apps/v1) namespace: flux-system
4:51:06PM:  L ongoing: waiting on pod/source-controller-648d7f445d-2h2wc (v1) namespace: flux-system
4:51:06PM:     ^ Condition Ready is not True (False)
4:51:07PM: ongoing: reconcile deployment/kustomize-controller (apps/v1) namespace: flux-system
4:51:07PM:  ^ Waiting for 1 unavailable replicas
4:51:07PM:  L ok: waiting on replicaset/kustomize-controller-759f994b (apps/v1) namespace: flux-system
4:51:07PM:  L ongoing: waiting on pod/kustomize-controller-759f994b-tpbrf (v1) namespace: flux-system
4:51:07PM:     ^ Condition Ready is not True (False)
4:51:11PM: ok: reconcile deployment/source-controller (apps/v1) namespace: flux-system
4:51:11PM: ---- waiting on 5 changes [29/34 done] ----
4:51:13PM: ok: reconcile deployment/image-reflector-controller (apps/v1) namespace: flux-system
4:51:13PM: ok: reconcile deployment/image-automation-controller (apps/v1) namespace: flux-system
4:51:13PM: ongoing: reconcile deployment/helm-controller (apps/v1) namespace: flux-system
4:51:13PM:  ^ Waiting for 1 unavailable replicas
4:51:13PM:  L ok: waiting on replicaset/helm-controller-68996c978c (apps/v1) namespace: flux-system
4:51:13PM:  L ok: waiting on pod/helm-controller-68996c978c-rlfnb (v1) namespace: flux-system
4:51:13PM: ongoing: reconcile deployment/notification-controller (apps/v1) namespace: flux-system
4:51:13PM:  ^ Waiting for 1 unavailable replicas
4:51:13PM:  L ok: waiting on replicaset/notification-controller-6fd769cbf4 (apps/v1) namespace: flux-system
4:51:13PM:  L ok: waiting on pod/notification-controller-6fd769cbf4-qn2kk (v1) namespace: flux-system
4:51:13PM: ---- waiting on 3 changes [31/34 done] ----
4:51:14PM: ok: reconcile deployment/notification-controller (apps/v1) namespace: flux-system
4:51:14PM: ok: reconcile deployment/helm-controller (apps/v1) namespace: flux-system
4:51:15PM: ongoing: reconcile deployment/kustomize-controller (apps/v1) namespace: flux-system
4:51:15PM:  ^ Waiting for 1 unavailable replicas
4:51:15PM:  L ok: waiting on replicaset/kustomize-controller-759f994b (apps/v1) namespace: flux-system
4:51:15PM:  L ok: waiting on pod/kustomize-controller-759f994b-tpbrf (v1) namespace: flux-system
4:51:15PM: ---- waiting on 1 changes [33/34 done] ----
4:51:16PM: ok: reconcile deployment/kustomize-controller (apps/v1) namespace: flux-system
4:51:16PM: ---- applying complete [34/34 done] ----
4:51:16PM: ---- waiting complete [34/34 done] ----
 
Succeeded
vdesikan@vdesikan-a01 tap-install % kubectl get pods -A
NAMESPACE           NAME                                           READY   STATUS    RESTARTS   AGE
contour-external    contour-7c7795856b-8mqlz                       1/1     Running   0          3m27s
contour-external    contour-7c7795856b-8xh6c                       1/1     Running   0          3m27s
contour-external    envoy-7fzmk                                    2/2     Running   0          3m27s
contour-external    envoy-ccrgj                                    2/2     Running   0          3m27s
contour-external    envoy-fndxp                                    2/2     Running   0          3m27s
contour-external    envoy-mcbfr                                    2/2     Running   0          3m27s
contour-internal    contour-5b6b565d-6sbx4                         1/1     Running   0          3m27s
contour-internal    contour-5b6b565d-lhmvn                         1/1     Running   0          3m27s
contour-internal    envoy-l2tc6                                    2/2     Running   0          3m27s
contour-internal    envoy-mv7x2                                    2/2     Running   0          3m27s
contour-internal    envoy-rnhtf                                    2/2     Running   0          3m27s
contour-internal    envoy-t2llr                                    2/2     Running   0          3m27s
flux-system         helm-controller-68996c978c-rlfnb               1/1     Running   0          29s
flux-system         image-automation-controller-68d55fccd8-52wwk   1/1     Running   0          27s
flux-system         image-reflector-controller-7784457d8f-n82r7    1/1     Running   0          29s
flux-system         kustomize-controller-759f994b-tpbrf            1/1     Running   0          29s
flux-system         notification-controller-6fd769cbf4-qn2kk       1/1     Running   0          27s
flux-system         source-controller-648d7f445d-2h2wc             1/1     Running   0          29s
kapp-controller     kapp-controller-ff4656bb-cjrl7                 1/1     Running   0          16m
knative-discovery   controller-b59bd9449-8l9f4                     1/1     Running   0          3m25s
knative-discovery   webhook-54c56fc5b8-8djnb                       1/1     Running   0          3m25s
knative-eventing    eventing-controller-6c7fbfdb79-7vr4w           1/1     Running   0          3m27s
knative-eventing    eventing-webhook-5885fcccc9-7b5lh              1/1     Running   0          3m27s
knative-eventing    eventing-webhook-5885fcccc9-vbgzs              1/1     Running   0          3m12s
knative-eventing    imc-controller-bdb84c8ff-q67gj                 1/1     Running   0          3m27s
knative-eventing    imc-dispatcher-586bd55496-6j97d                1/1     Running   0          3m26s
knative-eventing    mt-broker-controller-785589dd9d-vlx6v          1/1     Running   0          3m26s
knative-eventing    mt-broker-filter-7dfcf6589-fjhmz               1/1     Running   0          3m26s
knative-eventing    mt-broker-ingress-688cc7f74-l46p9              1/1     Running   0          3m26s
knative-eventing    rabbitmq-broker-controller-85d5b56f8-kwz9x     1/1     Running   0          3m25s
knative-serving     activator-5b59f7c699-4cvts                     1/1     Running   0          3m13s
knative-serving     activator-5b59f7c699-4mbtl                     1/1     Running   0          3m29s
knative-serving     activator-5b59f7c699-sk2m5                     1/1     Running   0          3m13s
knative-serving     autoscaler-8f85d46c-g4tnh                      1/1     Running   0          3m29s
knative-serving     contour-ingress-controller-8fbc54c-whghl       1/1     Running   0          3m27s
knative-serving     controller-645bdbc7d9-z5n5v                    1/1     Running   0          3m29s
knative-serving     net-certmanager-webhook-dcdc76d4-qnxzg         1/1     Running   0          3m25s
knative-serving     networking-certmanager-7575777f9f-t4tf9        1/1     Running   0          3m25s
knative-serving     webhook-7cb844897b-sdqrz                       1/1     Running   0          3m28s
knative-serving     webhook-7cb844897b-tkszw                       1/1     Running   0          3m13s
knative-sources     rabbitmq-controller-manager-5dcb7c8494-t7c8k   1/1     Running   0          3m24s
knative-sources     rabbitmq-webhook-bcb77f84f-2d6fw               1/1     Running   0          3m24s
kube-system         aws-node-2fzbz                                 1/1     Running   0          4d
kube-system         aws-node-4s2vw                                 1/1     Running   0          4d
kube-system         aws-node-jf8vp                                 1/1     Running   0          4d
kube-system         aws-node-m4rz7                                 1/1     Running   0          4d
kube-system         coredns-5c778788f4-bl47d                       1/1     Running   0          4d
kube-system         coredns-5c778788f4-swf2n                       1/1     Running   0          4d
kube-system         kube-proxy-dcbwg                               1/1     Running   0          4d
kube-system         kube-proxy-rq6gh                               1/1     Running   0          4d
kube-system         kube-proxy-sbsrz                               1/1     Running   0          4d
kube-system         kube-proxy-xl2b5                               1/1     Running   0          4d
triggermesh         aws-event-sources-controller-7f9dd6d69-6ldbs   1/1     Running   0          3m29s
vmware-sources      webhook-c9f67b5cd-tjv4p                        1/1     Running   0          3m26s
vdesikan@vdesikan-a01 tap-install % kapp list -A
Target cluster 'https://94A70B79EF7B1D5E718A4E96B2925F91.gr7.us-east-2.eks.amazonaws.com' (nodes: ip-172-31-46-226.us-east-2.compute.internal, 3+)
 
Apps in all namespaces
 
Namespace    Name                                      Namespaces                                                  Lcs   Lca
default      flux                                      (cluster),flux-system                                       true  50s
^            kc                                        (cluster),kapp-controller,kube-system                       true  17m
tap-install  cloud-native-runtimes-ctrl                (cluster),contour-external,                                 true  37s
                                                       contour-internal,knative-discovery,knative-eventing,
                                                       knative-serving,knative-sources,triggermesh,vmware-sources
^            tanzu-application-platform-packages-ctrl  tap-install                                                 true  10m
^            tap-package-repo                          tap-install                                                 true  10m
 
Lcs: Last Change Successful
Lca: Last Change Age
 
5 apps
 
Succeeded
vdesikan@vdesikan-a01 tap-install % kubectl delete -n flux-system networkpolicies --all
 
networkpolicy.networking.k8s.io "allow-egress" deleted
networkpolicy.networking.k8s.io "allow-scraping" deleted
networkpolicy.networking.k8s.io "allow-webhooks" deleted
```
8. Install App Accelerator
```
vdesikan@vdesikan-a01 tap-install % tanzu package install app-accelerator -p accelerator.apps.tanzu.vmware.com -v 0.2.0 -n tap-install -f values-acc.yml
\ Installing package 'accelerator.apps.tanzu.vmware.com'
/ Getting package metadata for 'accelerator.apps.tanzu.vmware.com'
- Creating service account 'app-accelerator-tap-install-sa'
- Creating cluster admin role 'app-accelerator-tap-install-cluster-role'
- Creating cluster role binding 'app-accelerator-tap-install-cluster-rolebinding'
- Creating secret 'app-accelerator-tap-install-values'
\ Creating package resource
| Package install status: Reconciling
 
 
 Added installed package 'app-accelerator' in namespace 'tap-install'
vdesikan@vdesikan-a01 tap-install % tanzu package  installed  list -A
- Retrieving installed packages...
  NAME                   PACKAGE-NAME                       PACKAGE-VERSION  STATUS               NAMESPACE
  app-accelerator        accelerator.apps.tanzu.vmware.com  0.2.0            Reconcile succeeded  tap-install
  cloud-native-runtimes  cnrs.tanzu.vmware.com              1.0.1            Reconcile succeeded  tap-install
vdesikan@vdesikan-a01 tap-install % kubectl get pods -A
NAMESPACE            NAME                                             READY   STATUS    RESTARTS   AGE
accelerator-system   acc-engine-69f7f7b6b8-pstf9                      1/1     Running   0          74s
accelerator-system   acc-ui-server-6df7c597bd-fz5hv                   1/1     Running   0          74s
accelerator-system   accelerator-controller-manager-796f7dff7-pqtvg   1/1     Running   0          74s
contour-external     contour-7c7795856b-8mqlz                         1/1     Running   0          7m8s
contour-external     contour-7c7795856b-8xh6c                         1/1     Running   0          7m8s
contour-external     envoy-7fzmk                                      2/2     Running   0          7m8s
contour-external     envoy-ccrgj                                      2/2     Running   0          7m8s
contour-external     envoy-fndxp                                      2/2     Running   0          7m8s
contour-external     envoy-mcbfr                                      2/2     Running   0          7m8s
contour-internal     contour-5b6b565d-6sbx4                           1/1     Running   0          7m8s
contour-internal     contour-5b6b565d-lhmvn                           1/1     Running   0          7m8s
contour-internal     envoy-l2tc6                                      2/2     Running   0          7m8s
contour-internal     envoy-mv7x2                                      2/2     Running   0          7m8s
contour-internal     envoy-rnhtf                                      2/2     Running   0          7m8s
contour-internal     envoy-t2llr                                      2/2     Running   0          7m8s
flux-system          helm-controller-68996c978c-rlfnb                 1/1     Running   0          4m10s
flux-system          image-automation-controller-68d55fccd8-52wwk     1/1     Running   0          4m8s
flux-system          image-reflector-controller-7784457d8f-n82r7      1/1     Running   0          4m10s
flux-system          kustomize-controller-759f994b-tpbrf              1/1     Running   0          4m10s
flux-system          notification-controller-6fd769cbf4-qn2kk         1/1     Running   0          4m8s
flux-system          source-controller-648d7f445d-2h2wc               1/1     Running   0          4m10s
kapp-controller      kapp-controller-ff4656bb-cjrl7                   1/1     Running   0          20m
knative-discovery    controller-b59bd9449-8l9f4                       1/1     Running   0          7m6s
knative-discovery    webhook-54c56fc5b8-8djnb                         1/1     Running   0          7m6s
knative-eventing     eventing-controller-6c7fbfdb79-7vr4w             1/1     Running   0          7m8s
knative-eventing     eventing-webhook-5885fcccc9-7b5lh                1/1     Running   0          7m8s
knative-eventing     eventing-webhook-5885fcccc9-vbgzs                1/1     Running   0          6m53s
knative-eventing     imc-controller-bdb84c8ff-q67gj                   1/1     Running   0          7m8s
knative-eventing     imc-dispatcher-586bd55496-6j97d                  1/1     Running   0          7m7s
knative-eventing     mt-broker-controller-785589dd9d-vlx6v            1/1     Running   0          7m7s
knative-eventing     mt-broker-filter-7dfcf6589-fjhmz                 1/1     Running   0          7m7s
knative-eventing     mt-broker-ingress-688cc7f74-l46p9                1/1     Running   0          7m7s
knative-eventing     rabbitmq-broker-controller-85d5b56f8-kwz9x       1/1     Running   0          7m6s
knative-serving      activator-5b59f7c699-4cvts                       1/1     Running   0          6m54s
knative-serving      activator-5b59f7c699-4mbtl                       1/1     Running   0          7m10s
knative-serving      activator-5b59f7c699-sk2m5                       1/1     Running   0          6m54s
knative-serving      autoscaler-8f85d46c-g4tnh                        1/1     Running   0          7m10s
knative-serving      contour-ingress-controller-8fbc54c-whghl         1/1     Running   0          7m8s
knative-serving      controller-645bdbc7d9-z5n5v                      1/1     Running   0          7m10s
knative-serving      net-certmanager-webhook-dcdc76d4-qnxzg           1/1     Running   0          7m6s
knative-serving      networking-certmanager-7575777f9f-t4tf9          1/1     Running   0          7m6s
knative-serving      webhook-7cb844897b-sdqrz                         1/1     Running   0          7m9s
knative-serving      webhook-7cb844897b-tkszw                         1/1     Running   0          6m54s
knative-sources      rabbitmq-controller-manager-5dcb7c8494-t7c8k     1/1     Running   0          7m5s
knative-sources      rabbitmq-webhook-bcb77f84f-2d6fw                 1/1     Running   0          7m5s
kube-system          aws-node-2fzbz                                   1/1     Running   0          4d
kube-system          aws-node-4s2vw                                   1/1     Running   0          4d
kube-system          aws-node-jf8vp                                   1/1     Running   0          4d
kube-system          aws-node-m4rz7                                   1/1     Running   0          4d
kube-system          coredns-5c778788f4-bl47d                         1/1     Running   0          4d
kube-system          coredns-5c778788f4-swf2n                         1/1     Running   0          4d
kube-system          kube-proxy-dcbwg                                 1/1     Running   0          4d
kube-system          kube-proxy-rq6gh                                 1/1     Running   0          4d
kube-system          kube-proxy-sbsrz                                 1/1     Running   0          4d
kube-system          kube-proxy-xl2b5                                 1/1     Running   0          4d
triggermesh          aws-event-sources-controller-7f9dd6d69-6ldbs     1/1     Running   0          7m10s
vmware-sources       webhook-c9f67b5cd-tjv4p                          1/1     Running   0          7m7s
vdesikan@vdesikan-a01 tap-install % kapp list -A
Target cluster 'https://94A70B79EF7B1D5E718A4E96B2925F91.gr7.us-east-2.eks.amazonaws.com' (nodes: ip-172-31-46-226.us-east-2.compute.internal, 3+)
 
Apps in all namespaces
 
Namespace    Name                                      Namespaces                                                  Lcs   Lca
default      flux                                      (cluster),flux-system                                       true  4m
^            kc                                        (cluster),kapp-controller,kube-system                       true  20m
tap-install  app-accelerator-ctrl                      (cluster),accelerator-system                                true  1m
^            cloud-native-runtimes-ctrl                (cluster),contour-external,                                 true  15s
                                                       contour-internal,knative-discovery,knative-eventing,
                                                       knative-serving,knative-sources,triggermesh,vmware-sources
^            tanzu-application-platform-packages-ctrl  tap-install                                                 true  14m
^            tap-package-repo                          tap-install                                                 true  14m
 
Lcs: Last Change Successful
Lca: Last Change Age
 
6 apps
 
Succeeded
```
9. Install App Live View.
```
vdesikan@vdesikan-a01 tap-install % tanzu package install app-live-view -p appliveview.tanzu.vmware.com -v 0.1.0 -n tap-install -f values-alv.yml
- Installing package 'appliveview.tanzu.vmware.com'
/ Getting package metadata for 'appliveview.tanzu.vmware.com'
- Creating service account 'app-live-view-tap-install-sa'
- Creating cluster admin role 'app-live-view-tap-install-cluster-role'
- Creating cluster role binding 'app-live-view-tap-install-cluster-rolebinding'
- Creating secret 'app-live-view-tap-install-values'
- Creating package resource
/ Package install status: Reconciling
 
 Added installed package 'app-live-view' in namespace 'tap-install'
vdesikan@vdesikan-a01 tap-install % tanzu package  installed  list -A
/ Retrieving installed packages...
  NAME                   PACKAGE-NAME                       PACKAGE-VERSION  STATUS               NAMESPACE
  app-accelerator        accelerator.apps.tanzu.vmware.com  0.2.0            Reconcile succeeded  tap-install
  app-live-view          appliveview.tanzu.vmware.com       0.1.0            Reconcile succeeded  tap-install
  cloud-native-runtimes  cnrs.tanzu.vmware.com              1.0.1            Reconcile succeeded  tap-install
vdesikan@vdesikan-a01 tap-install % kapp list -A
Target cluster 'https://94A70B79EF7B1D5E718A4E96B2925F91.gr7.us-east-2.eks.amazonaws.com' (nodes: ip-172-31-46-226.us-east-2.compute.internal, 3+)
 
Apps in all namespaces
 
Namespace    Name                                      Namespaces                                                  Lcs   Lca
default      flux                                      (cluster),flux-system                                       true  6m
^            kc                                        (cluster),kapp-controller,kube-system                       true  22m
tap-install  app-accelerator-ctrl                      (cluster),accelerator-system                                true  10s
^            app-live-view-ctrl                        (cluster),tap-install                                       true  36s
^            cloud-native-runtimes-ctrl                (cluster),contour-external,                                 true  11s
                                                       contour-internal,knative-discovery,knative-eventing,
                                                       knative-serving,knative-sources,triggermesh,vmware-sources
^            tanzu-application-platform-packages-ctrl  tap-install                                                 true  15m
^            tap-package-repo                          tap-install                                                 true  16m
 
Lcs: Last Change Successful
Lca: Last Change Age
 
7 apps
 
Succeeded
vdesikan@vdesikan-a01 tap-install % kubectl get pods -A
NAMESPACE            NAME                                                    READY   STATUS    RESTARTS   AGE
accelerator-system   acc-engine-69f7f7b6b8-pstf9                             1/1     Running   0          3m12s
accelerator-system   acc-ui-server-6df7c597bd-fz5hv                          1/1     Running   0          3m12s
accelerator-system   accelerator-controller-manager-796f7dff7-pqtvg          1/1     Running   0          3m12s
contour-external     contour-7c7795856b-8mqlz                                1/1     Running   0          9m6s
contour-external     contour-7c7795856b-8xh6c                                1/1     Running   0          9m6s
contour-external     envoy-7fzmk                                             2/2     Running   0          9m6s
contour-external     envoy-ccrgj                                             2/2     Running   0          9m6s
contour-external     envoy-fndxp                                             2/2     Running   0          9m6s
contour-external     envoy-mcbfr                                             2/2     Running   0          9m6s
contour-internal     contour-5b6b565d-6sbx4                                  1/1     Running   0          9m6s
contour-internal     contour-5b6b565d-lhmvn                                  1/1     Running   0          9m6s
contour-internal     envoy-l2tc6                                             2/2     Running   0          9m6s
contour-internal     envoy-mv7x2                                             2/2     Running   0          9m6s
contour-internal     envoy-rnhtf                                             2/2     Running   0          9m6s
contour-internal     envoy-t2llr                                             2/2     Running   0          9m6s
flux-system          helm-controller-68996c978c-rlfnb                        1/1     Running   0          6m8s
flux-system          image-automation-controller-68d55fccd8-52wwk            1/1     Running   0          6m6s
flux-system          image-reflector-controller-7784457d8f-n82r7             1/1     Running   0          6m8s
flux-system          kustomize-controller-759f994b-tpbrf                     1/1     Running   0          6m8s
flux-system          notification-controller-6fd769cbf4-qn2kk                1/1     Running   0          6m6s
flux-system          source-controller-648d7f445d-2h2wc                      1/1     Running   0          6m8s
kapp-controller      kapp-controller-ff4656bb-cjrl7                          1/1     Running   0          22m
knative-discovery    controller-b59bd9449-8l9f4                              1/1     Running   0          9m4s
knative-discovery    webhook-54c56fc5b8-8djnb                                1/1     Running   0          9m4s
knative-eventing     eventing-controller-6c7fbfdb79-7vr4w                    1/1     Running   0          9m6s
knative-eventing     eventing-webhook-5885fcccc9-7b5lh                       1/1     Running   0          9m6s
knative-eventing     eventing-webhook-5885fcccc9-vbgzs                       1/1     Running   0          8m51s
knative-eventing     imc-controller-bdb84c8ff-q67gj                          1/1     Running   0          9m6s
knative-eventing     imc-dispatcher-586bd55496-6j97d                         1/1     Running   0          9m5s
knative-eventing     mt-broker-controller-785589dd9d-vlx6v                   1/1     Running   0          9m5s
knative-eventing     mt-broker-filter-7dfcf6589-fjhmz                        1/1     Running   0          9m5s
knative-eventing     mt-broker-ingress-688cc7f74-l46p9                       1/1     Running   0          9m5s
knative-eventing     rabbitmq-broker-controller-85d5b56f8-kwz9x              1/1     Running   0          9m4s
knative-serving      activator-5b59f7c699-4cvts                              1/1     Running   0          8m52s
knative-serving      activator-5b59f7c699-4mbtl                              1/1     Running   0          9m8s
knative-serving      activator-5b59f7c699-sk2m5                              1/1     Running   0          8m52s
knative-serving      autoscaler-8f85d46c-g4tnh                               1/1     Running   0          9m8s
knative-serving      contour-ingress-controller-8fbc54c-whghl                1/1     Running   0          9m6s
knative-serving      controller-645bdbc7d9-z5n5v                             1/1     Running   0          9m8s
knative-serving      net-certmanager-webhook-dcdc76d4-qnxzg                  1/1     Running   0          9m4s
knative-serving      networking-certmanager-7575777f9f-t4tf9                 1/1     Running   0          9m4s
knative-serving      webhook-7cb844897b-sdqrz                                1/1     Running   0          9m7s
knative-serving      webhook-7cb844897b-tkszw                                1/1     Running   0          8m52s
knative-sources      rabbitmq-controller-manager-5dcb7c8494-t7c8k            1/1     Running   0          9m3s
knative-sources      rabbitmq-webhook-bcb77f84f-2d6fw                        1/1     Running   0          9m3s
kube-system          aws-node-2fzbz                                          1/1     Running   0          4d
kube-system          aws-node-4s2vw                                          1/1     Running   0          4d
kube-system          aws-node-jf8vp                                          1/1     Running   0          4d
kube-system          aws-node-m4rz7                                          1/1     Running   0          4d
kube-system          coredns-5c778788f4-bl47d                                1/1     Running   0          4d
kube-system          coredns-5c778788f4-swf2n                                1/1     Running   0          4d
kube-system          kube-proxy-dcbwg                                        1/1     Running   0          4d
kube-system          kube-proxy-rq6gh                                        1/1     Running   0          4d
kube-system          kube-proxy-sbsrz                                        1/1     Running   0          4d
kube-system          kube-proxy-xl2b5                                        1/1     Running   0          4d
tap-install          application-live-view-connector-57cd7c6c6-pv8dk         1/1     Running   0          43s
tap-install          application-live-view-crd-controller-5b659f8f57-7zz25   1/1     Running   0          43s
tap-install          application-live-view-server-79bd874566-qtcbc           1/1     Running   0          43s
triggermesh          aws-event-sources-controller-7f9dd6d69-6ldbs            1/1     Running   0          9m8s
vmware-sources       webhook-c9f67b5cd-tjv4p                                 1/1     Running   0          9m5s
```
10. Check if you can Access App Accelerator UI and App Live View UI using the external IP listed.
```
vdesikan@vdesikan-a01 tap-install % kubectl get service -A
NAMESPACE            NAME                         TYPE           CLUSTER-IP       EXTERNAL-IP                                                               PORT(S)                           AGE
accelerator-system   acc-engine                   ClusterIP      10.100.253.164   <none>                                                                    80/TCP                            3m24s
accelerator-system   acc-ui-server                LoadBalancer   10.100.74.90     a3b48dd9f15f746a48b503aee558bd96-309532596.us-east-2.elb.amazonaws.com    80:31689/TCP                      3m24s
contour-external     contour                      ClusterIP      10.100.10.20     <none>                                                                    8001/TCP                          9m19s
contour-external     envoy                        LoadBalancer   10.100.29.235    afc0cc5526ef74617a20f89f27433b6f-609822777.us-east-2.elb.amazonaws.com    80:31346/TCP,443:32120/TCP        9m18s
contour-internal     contour                      ClusterIP      10.100.247.212   <none>                                                                    8001/TCP                          9m18s
contour-internal     envoy                        ClusterIP      10.100.3.195     <none>                                                                    80/TCP,443/TCP                    9m18s
default              kubernetes                   ClusterIP      10.100.0.1       <none>                                                                    443/TCP                           4d
flux-system          notification-controller      ClusterIP      10.100.153.120   <none>                                                                    80/TCP                            6m19s
flux-system          source-controller            ClusterIP      10.100.214.3     <none>                                                                    80/TCP                            6m20s
flux-system          webhook-receiver             ClusterIP      10.100.54.115    <none>                                                                    80/TCP                            6m19s
kapp-controller      packaging-api                ClusterIP      10.100.66.222    <none>                                                                    443/TCP                           22m
knative-discovery    webhook                      ClusterIP      10.100.204.141   <none>                                                                    9090/TCP,8008/TCP,443/TCP         9m18s
knative-eventing     broker-filter                ClusterIP      10.100.200.214   <none>                                                                    80/TCP,9092/TCP                   9m18s
knative-eventing     broker-ingress               ClusterIP      10.100.50.73     <none>                                                                    80/TCP,9092/TCP                   9m18s
knative-eventing     eventing-webhook             ClusterIP      10.100.188.40    <none>                                                                    443/TCP                           9m18s
knative-eventing     imc-dispatcher               ClusterIP      10.100.54.100    <none>                                                                    80/TCP                            9m18s
knative-eventing     inmemorychannel-webhook      ClusterIP      10.100.72.121    <none>                                                                    443/TCP                           9m18s
knative-serving      activator-service            ClusterIP      10.100.114.196   <none>                                                                    9090/TCP,8008/TCP,80/TCP,81/TCP   9m20s
knative-serving      autoscaler                   ClusterIP      10.100.2.22      <none>                                                                    9090/TCP,8008/TCP,8080/TCP        9m20s
knative-serving      autoscaler-bucket-00-of-01   ClusterIP      10.100.3.124     <none>                                                                    8080/TCP                          9m17s
knative-serving      controller                   ClusterIP      10.100.40.142    <none>                                                                    9090/TCP,8008/TCP                 9m20s
knative-serving      net-certmanager-webhook      ClusterIP      10.100.168.189   <none>                                                                    9090/TCP,8008/TCP,443/TCP         9m18s
knative-serving      networking-certmanager       ClusterIP      10.100.168.29    <none>                                                                    9090/TCP,8008/TCP                 9m18s
knative-serving      webhook                      ClusterIP      10.100.228.52    <none>                                                                    9090/TCP,8008/TCP,443/TCP         9m19s
knative-sources      rabbitmq-controller          ClusterIP      10.100.150.219   <none>                                                                    443/TCP                           9m18s
knative-sources      rabbitmq-webhook             ClusterIP      10.100.86.29     <none>                                                                    443/TCP                           9m18s
kube-system          kube-dns                     ClusterIP      10.100.0.10      <none>                                                                    53/UDP,53/TCP                     4d
tap-install          application-live-view-5112   LoadBalancer   10.100.176.238   ac229c2c3af2f48be896688d5f176c16-1335129677.us-east-2.elb.amazonaws.com   5112:32387/TCP                    55s
tap-install          application-live-view-7000   ClusterIP      10.100.29.252    <none>                                                                    7000/TCP                          55s
vmware-sources       webhook                      ClusterIP      10.100.192.82    <none>                                                                    443/TCP                           9m18s
```
## TBS Installation
1. Relocate TBS bundle to another registry and do imgpkg pull to local directory from the relocated registry.
```
vdesikan@vdesikan-a01 tap-install % imgpkg copy -b "registry.pivotal.io/build-service/bundle:1.2.2" --to-repo dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs
copy | exporting 17 images...
copy | will export registry.pivotal.io/build-service/bundle@sha256:e03765dbce254a1266a8bba026a71ec908854681bd12bf69cd7d55d407bbca95
copy | will export registry.pivotal.io/build-service/dependency-updater@sha256:9f71c2fa6f7779924a95d9bcdedc248b4623c4d446ecddf950a21117e1cebd76
copy | will export registry.pivotal.io/build-service/kpack-build-init-windows@sha256:20758ba22ead903aa4aacaa08a3f89dce0586f938a5d091e6c37bf5b13d632f3
copy | will export registry.pivotal.io/build-service/kpack-build-init@sha256:31e95adee6d59ac46f5f2ec48208cbd154db0f4f8e6c1de1b8edf0cd9418bba8
copy | will export registry.pivotal.io/build-service/kpack-completion-windows@sha256:1f8f1d98ea439ba6a25808a29af33259ad926a7054ad8f4b1aea91abf8a8b141
copy | will export registry.pivotal.io/build-service/kpack-completion@sha256:1c63b9c876b11b7bf5f83095136b690fc07860c80b62a167c41b4c3efd1910bd
copy | will export registry.pivotal.io/build-service/kpack-controller@sha256:4b3c825d6fb656f137706738058aab59051d753312e75404fc5cdaf49c352867
copy | will export registry.pivotal.io/build-service/kpack-lifecycle@sha256:c923a81a1c3908122e29a30bae5886646d6ec26429bad4842c67103636041d93
copy | will export registry.pivotal.io/build-service/kpack-rebase@sha256:79ae0f103bb39d7ef498202d950391c6ef656e06f937b4be4ec2abb6a37ad40a
copy | will export registry.pivotal.io/build-service/kpack-webhook@sha256:594fe3525a8bc35f99280e31ebc38a3f1f8e02e0c961c35d27b6397c2ad8fa68
copy | will export registry.pivotal.io/build-service/pod-webhook@sha256:3d8b31e5fba451bb51ccd586b23c439e0cab293007748c546ce79f698968dab8
copy | will export registry.pivotal.io/build-service/secret-syncer@sha256:77aecf06753ddca717f63e0a6c8b8602381fef7699856fa4741617b965098d57
copy | will export registry.pivotal.io/build-service/setup-ca-certs@sha256:3f8342b534e3e308188c3d0683c02c941c407a1ddacb086425499ed9cf0888e9
copy | will export registry.pivotal.io/build-service/sleeper@sha256:0881284ec39f0b0e00c0cfd2551762f14e43580085dce9d0530717c704ade988
copy | will export registry.pivotal.io/build-service/smart-warmer@sha256:4c8627a7f23d84fc25b409b7864930d27acc6454e3cdaa5e3917b5f252ff65ad
copy | will export registry.pivotal.io/build-service/stackify@sha256:a40af2d5d569ea8bee8ec1effc43ba0ddf707959b63e7c85587af31f49c4157f
copy | will export registry.pivotal.io/build-service/stacks-operator@sha256:1daa693bd09a1fcae7a2f82859115dc1688823330464e5b47d8b9b709dee89f1
copy | exported 17 images
copy | importing 17 images...
 
 405.14 MiB / 405.41 MiB [=============================================================================================================================================================================================================]  99.93% 3.27 MiB/scopy | Error: Error uploading images: PUT https://dev.registry.pivotal.io/v2/tanzu-advanced-edition/beta1/tbs/manifests/sha256-20758ba22ead903aa4aacaa08a3f89dce0586f938a5d091e6c37bf5b13d632f3.imgpkg: UNKNOWN: internal server error
 405.41 MiB / 405.41 MiB [=======================================================================================================================================================================================================] 100.00% 2.72 MiB/s 2m29s
 
copy | done uploading images
copy | Warning: Skipped layer due to it being non-distributable. If you would like to include non-distributable layers, use the --include-non-distributable-layers flag
Succeeded
vdesikan@vdesikan-a01 tap-install % imgpkg pull -b "dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs:1.2.2" -o tmp/bundle
Pulling bundle 'dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:e03765dbce254a1266a8bba026a71ec908854681bd12bf69cd7d55d407bbca95'
  Extracting layer 'sha256:fe2f85ecc3c64ff1a1e1bf2ada42b179889f06f375fccb64f2f23ed24a331992' (1/1)
 
Locating image lock file images...
The bundle repo (dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs) is hosting every image specified in the bundle's Images Lock file (.imgpkg/images.yml)
 
Succeeded
```
2. Install TBS
```
vdesikan@vdesikan-a01 tap-install % ytt -f tmp/bundle/values.yaml -f tmp/bundle/config/ -v docker_repository=dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs -v docker_username=$USRFULL -v docker_password=$PASS -v tanzunet_username=$USRFULL -v tanzunet_password=$PASS | kbld -f tmp/bundle/.imgpkg/images.yml -f- | kapp deploy -a tanzu-build-service -f- -y
resolve | final: build-init -> dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:31e95adee6d59ac46f5f2ec48208cbd154db0f4f8e6c1de1b8edf0cd9418bba8
resolve | final: completion -> dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:1c63b9c876b11b7bf5f83095136b690fc07860c80b62a167c41b4c3efd1910bd
resolve | final: dependency-updater -> dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:9f71c2fa6f7779924a95d9bcdedc248b4623c4d446ecddf950a21117e1cebd76
resolve | final: dev.registry.pivotal.io/build-service/pod-webhook@sha256:3d8b31e5fba451bb51ccd586b23c439e0cab293007748c546ce79f698968dab8 -> dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:3d8b31e5fba451bb51ccd586b23c439e0cab293007748c546ce79f698968dab8
resolve | final: dev.registry.pivotal.io/build-service/setup-ca-certs@sha256:3f8342b534e3e308188c3d0683c02c941c407a1ddacb086425499ed9cf0888e9 -> dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:3f8342b534e3e308188c3d0683c02c941c407a1ddacb086425499ed9cf0888e9
resolve | final: dev.registry.pivotal.io/build-service/stackify@sha256:a40af2d5d569ea8bee8ec1effc43ba0ddf707959b63e7c85587af31f49c4157f -> dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:a40af2d5d569ea8bee8ec1effc43ba0ddf707959b63e7c85587af31f49c4157f
resolve | final: dev.registry.pivotal.io/build-service/stacks-operator@sha256:1daa693bd09a1fcae7a2f82859115dc1688823330464e5b47d8b9b709dee89f1 -> dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:1daa693bd09a1fcae7a2f82859115dc1688823330464e5b47d8b9b709dee89f1
resolve | final: gcr.io/cf-build-service-public/kpack/build-init-windows@sha256:20758ba22ead903aa4aacaa08a3f89dce0586f938a5d091e6c37bf5b13d632f3 -> dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:20758ba22ead903aa4aacaa08a3f89dce0586f938a5d091e6c37bf5b13d632f3
resolve | final: gcr.io/cf-build-service-public/kpack/build-init@sha256:31e95adee6d59ac46f5f2ec48208cbd154db0f4f8e6c1de1b8edf0cd9418bba8 -> dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:31e95adee6d59ac46f5f2ec48208cbd154db0f4f8e6c1de1b8edf0cd9418bba8
resolve | final: gcr.io/cf-build-service-public/kpack/completion-windows@sha256:1f8f1d98ea439ba6a25808a29af33259ad926a7054ad8f4b1aea91abf8a8b141 -> dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:1f8f1d98ea439ba6a25808a29af33259ad926a7054ad8f4b1aea91abf8a8b141
resolve | final: gcr.io/cf-build-service-public/kpack/completion@sha256:1c63b9c876b11b7bf5f83095136b690fc07860c80b62a167c41b4c3efd1910bd -> dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:1c63b9c876b11b7bf5f83095136b690fc07860c80b62a167c41b4c3efd1910bd
resolve | final: gcr.io/cf-build-service-public/kpack/controller@sha256:4b3c825d6fb656f137706738058aab59051d753312e75404fc5cdaf49c352867 -> dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:4b3c825d6fb656f137706738058aab59051d753312e75404fc5cdaf49c352867
resolve | final: gcr.io/cf-build-service-public/kpack/lifecycle@sha256:c923a81a1c3908122e29a30bae5886646d6ec26429bad4842c67103636041d93 -> dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:c923a81a1c3908122e29a30bae5886646d6ec26429bad4842c67103636041d93
resolve | final: gcr.io/cf-build-service-public/kpack/rebase@sha256:79ae0f103bb39d7ef498202d950391c6ef656e06f937b4be4ec2abb6a37ad40a -> dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:79ae0f103bb39d7ef498202d950391c6ef656e06f937b4be4ec2abb6a37ad40a
resolve | final: gcr.io/cf-build-service-public/kpack/webhook@sha256:594fe3525a8bc35f99280e31ebc38a3f1f8e02e0c961c35d27b6397c2ad8fa68 -> dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:594fe3525a8bc35f99280e31ebc38a3f1f8e02e0c961c35d27b6397c2ad8fa68
resolve | final: rebase -> dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:79ae0f103bb39d7ef498202d950391c6ef656e06f937b4be4ec2abb6a37ad40a
resolve | final: secret-syncer -> dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:77aecf06753ddca717f63e0a6c8b8602381fef7699856fa4741617b965098d57
resolve | final: setup-ca-certs -> dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:3f8342b534e3e308188c3d0683c02c941c407a1ddacb086425499ed9cf0888e9
resolve | final: sleeper -> dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:0881284ec39f0b0e00c0cfd2551762f14e43580085dce9d0530717c704ade988
resolve | final: stackify -> dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:a40af2d5d569ea8bee8ec1effc43ba0ddf707959b63e7c85587af31f49c4157f
resolve | final: warmer -> dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs@sha256:4c8627a7f23d84fc25b409b7864930d27acc6454e3cdaa5e3917b5f252ff65ad
Target cluster 'https://94A70B79EF7B1D5E718A4E96B2925F91.gr7.us-east-2.eks.amazonaws.com' (nodes: ip-172-31-46-226.us-east-2.compute.internal, 3+)
 
Changes
 
Namespace               Name                                                            Kind                            Conds.  Age  Op      Op st.  Wait to    Rs  Ri
(cluster)               build-service                                                   Namespace                       -       -    create  -       reconcile  -   -
^                       build-service-admin-role                                        ClusterRole                     -       -    create  -       reconcile  -   -
^                       build-service-admin-role-binding                                ClusterRoleBinding              -       -    create  -       reconcile  -   -
^                       build-service-authenticated-role                                ClusterRole                     -       -    create  -       reconcile  -   -
^                       build-service-authenticated-role-binding                        ClusterRoleBinding              -       -    create  -       reconcile  -   -
^                       build-service-dependency-updater-role                           ClusterRole                     -       -    create  -       reconcile  -   -
^                       build-service-dependency-updater-role-binding                   ClusterRoleBinding              -       -    create  -       reconcile  -   -
^                       build-service-secret-syncer-role                                ClusterRole                     -       -    create  -       reconcile  -   -
^                       build-service-secret-syncer-role-binding                        ClusterRoleBinding              -       -    create  -       reconcile  -   -
^                       build-service-user-role                                         ClusterRole                     -       -    create  -       reconcile  -   -
^                       build-service-warmer-role                                       ClusterRole                     -       -    create  -       reconcile  -   -
^                       build-service-warmer-role-binding                               ClusterRoleBinding              -       -    create  -       reconcile  -   -
^                       builders.kpack.io                                               CustomResourceDefinition        -       -    create  -       reconcile  -   -
^                       builds.kpack.io                                                 CustomResourceDefinition        -       -    create  -       reconcile  -   -
^                       cert-injection-webhook-cluster-role                             ClusterRole                     -       -    create  -       reconcile  -   -
^                       cert-injection-webhook-cluster-role-binding                     ClusterRoleBinding              -       -    create  -       reconcile  -   -
^                       clusterbuilders.kpack.io                                        CustomResourceDefinition        -       -    create  -       reconcile  -   -
^                       clusterstacks.kpack.io                                          CustomResourceDefinition        -       -    create  -       reconcile  -   -
^                       clusterstores.kpack.io                                          CustomResourceDefinition        -       -    create  -       reconcile  -   -
^                       custom-stack-editor-role                                        ClusterRole                     -       -    create  -       reconcile  -   -
^                       custom-stack-viewer-role                                        ClusterRole                     -       -    create  -       reconcile  -   -
^                       customstacks.stacks.stacks-operator.tanzu.vmware.com            CustomResourceDefinition        -       -    create  -       reconcile  -   -
^                       defaults.webhook.cert-injection.tanzu.vmware.com                MutatingWebhookConfiguration    -       -    create  -       reconcile  -   -
^                       defaults.webhook.kpack.io                                       MutatingWebhookConfiguration    -       -    create  -       reconcile  -   -
^                       images.kpack.io                                                 CustomResourceDefinition        -       -    create  -       reconcile  -   -
^                       kpack                                                           Namespace                       -       -    create  -       reconcile  -   -
^                       kpack-controller-admin                                          ClusterRole                     -       -    create  -       reconcile  -   -
^                       kpack-controller-admin-binding                                  ClusterRoleBinding              -       -    create  -       reconcile  -   -
^                       kpack-webhook-certs-mutatingwebhookconfiguration-admin-binding  ClusterRoleBinding              -       -    create  -       reconcile  -   -
^                       kpack-webhook-mutatingwebhookconfiguration-admin                ClusterRole                     -       -    create  -       reconcile  -   -
^                       metrics-reader                                                  ClusterRole                     -       -    create  -       reconcile  -   -
^                       proxy-role                                                      ClusterRole                     -       -    create  -       reconcile  -   -
^                       proxy-rolebinding                                               ClusterRoleBinding              -       -    create  -       reconcile  -   -
^                       sourceresolvers.kpack.io                                        CustomResourceDefinition        -       -    create  -       reconcile  -   -
^                       stacks-operator-manager-role                                    ClusterRole                     -       -    create  -       reconcile  -   -
^                       stacks-operator-manager-rolebinding                             ClusterRoleBinding              -       -    create  -       reconcile  -   -
^                       stacks-operator-system                                          Namespace                       -       -    create  -       reconcile  -   -
^                       tanzunetdependencyupdaters.buildservice.tanzu.vmware.com        CustomResourceDefinition        -       -    create  -       reconcile  -   -
^                       validation.webhook.kpack.io                                     ValidatingWebhookConfiguration  -       -    create  -       reconcile  -   -
build-service           build-pod-image-fetcher                                         DaemonSet                       -       -    create  -       reconcile  -   -
^                       build-service-version                                           ConfigMap                       -       -    create  -       reconcile  -   -
^                       build-service-warmer-namespace-role                             Role                            -       -    create  -       reconcile  -   -
^                       build-service-warmer-namespace-role-binding                     RoleBinding                     -       -    create  -       reconcile  -   -
^                       ca-cert                                                         ConfigMap                       -       -    create  -       reconcile  -   -
^                       canonical-registry-secret                                       Secret                          -       -    create  -       reconcile  -   -
^                       cb-service-account                                              ServiceAccount                  -       -    create  -       reconcile  -   -
^                       cert-injection-webhook                                          Deployment                      -       -    create  -       reconcile  -   -
^                       cert-injection-webhook                                          Service                         -       -    create  -       reconcile  -   -
^                       cert-injection-webhook-role                                     Role                            -       -    create  -       reconcile  -   -
^                       cert-injection-webhook-role-binding                             RoleBinding                     -       -    create  -       reconcile  -   -
^                       cert-injection-webhook-sa                                       ServiceAccount                  -       -    create  -       reconcile  -   -
^                       cert-injection-webhook-tls                                      Secret                          -       -    create  -       reconcile  -   -
^                       dependency-updater                                              TanzuNetDependencyUpdater       -       -    create  -       reconcile  -   -
^                       dependency-updater-controller                                   Deployment                      -       -    create  -       reconcile  -   -
^                       dependency-updater-controller-serviceaccount                    ServiceAccount                  -       -    create  -       reconcile  -   -
^                       dependency-updater-secret                                       Secret                          -       -    create  -       reconcile  -   -
^                       dependency-updater-serviceaccount                               ServiceAccount                  -       -    create  -       reconcile  -   -
^                       http-proxy                                                      ConfigMap                       -       -    create  -       reconcile  -   -
^                       https-proxy                                                     ConfigMap                       -       -    create  -       reconcile  -   -
^                       no-proxy                                                        ConfigMap                       -       -    create  -       reconcile  -   -
^                       secret-syncer-controller                                        Deployment                      -       -    create  -       reconcile  -   -
^                       secret-syncer-service-account                                   ServiceAccount                  -       -    create  -       reconcile  -   -
^                       setup-ca-certs-image                                            ConfigMap                       -       -    create  -       reconcile  -   -
^                       sleeper-image                                                   ConfigMap                       -       -    create  -       reconcile  -   -
^                       warmer-controller                                               Deployment                      -       -    create  -       reconcile  -   -
^                       warmer-service-account                                          ServiceAccount                  -       -    create  -       reconcile  -   -
kpack                   build-init-image                                                ConfigMap                       -       -    create  -       reconcile  -   -
^                       build-init-windows-image                                        ConfigMap                       -       -    create  -       reconcile  -   -
^                       build-service-admin-configmap-role                              Role                            -       -    create  -       reconcile  -   -
^                       build-service-admin-configmap-role-binding                      RoleBinding                     -       -    create  -       reconcile  -   -
^                       build-service-dependency-updater-kp-config-role                 Role                            -       -    create  -       reconcile  -   -
^                       build-service-dependency-updater-kp-config-role-binding         RoleBinding                     -       -    create  -       reconcile  -   -
^                       canonical-registry-secret                                       Secret                          -       -    create  -       reconcile  -   -
^                       canonical-registry-serviceaccount                               ServiceAccount                  -       -    create  -       reconcile  -   -
^                       completion-image                                                ConfigMap                       -       -    create  -       reconcile  -   -
^                       completion-windows-image                                        ConfigMap                       -       -    create  -       reconcile  -   -
^                       controller                                                      ServiceAccount                  -       -    create  -       reconcile  -   -
^                       kp-config                                                       ConfigMap                       -       -    create  -       reconcile  -   -
^                       kpack-controller                                                Deployment                      -       -    create  -       reconcile  -   -
^                       kpack-controller-local-config                                   Role                            -       -    create  -       reconcile  -   -
^                       kpack-controller-local-config-binding                           RoleBinding                     -       -    create  -       reconcile  -   -
^                       kpack-webhook                                                   Deployment                      -       -    create  -       reconcile  -   -
^                       kpack-webhook                                                   Service                         -       -    create  -       reconcile  -   -
^                       kpack-webhook-certs-admin                                       Role                            -       -    create  -       reconcile  -   -
^                       kpack-webhook-certs-admin-binding                               RoleBinding                     -       -    create  -       reconcile  -   -
^                       lifecycle-image                                                 ConfigMap                       -       -    create  -       reconcile  -   -
^                       rebase-image                                                    ConfigMap                       -       -    create  -       reconcile  -   -
^                       webhook                                                         ServiceAccount                  -       -    create  -       reconcile  -   -
^                       webhook-certs                                                   Secret                          -       -    create  -       reconcile  -   -
stacks-operator-system  canonical-registry-secret                                       Secret                          -       -    create  -       reconcile  -   -
^                       controller-manager                                              Deployment                      -       -    create  -       reconcile  -   -
^                       controller-manager-metrics-service                              Service                         -       -    create  -       reconcile  -   -
^                       leader-election-role                                            Role                            -       -    create  -       reconcile  -   -
^                       leader-election-rolebinding                                     RoleBinding                     -       -    create  -       reconcile  -   -
^                       stackify-image                                                  ConfigMap                       -       -    create  -       reconcile  -   -
 
Op:      95 create, 0 delete, 0 update, 0 noop
Wait to: 95 reconcile, 0 delete, 0 noop
 
5:30:36PM: ---- applying 39 changes [0/95 done] ----
5:30:37PM: create clusterrolebinding/build-service-dependency-updater-role-binding (rbac.authorization.k8s.io/v1) cluster
5:30:37PM: create clusterrolebinding/build-service-warmer-role-binding (rbac.authorization.k8s.io/v1) cluster
5:30:37PM: create clusterrole/custom-stack-editor-role (rbac.authorization.k8s.io/v1) cluster
5:30:37PM: create clusterrole/stacks-operator-manager-role (rbac.authorization.k8s.io/v1) cluster
5:30:37PM: create clusterrole/custom-stack-viewer-role (rbac.authorization.k8s.io/v1) cluster
5:30:37PM: create clusterrole/metrics-reader (rbac.authorization.k8s.io/v1beta1) cluster
5:30:38PM: create namespace/stacks-operator-system (v1) cluster
5:30:38PM: create clusterrolebinding/stacks-operator-manager-rolebinding (rbac.authorization.k8s.io/v1) cluster
5:30:38PM: create clusterrolebinding/build-service-authenticated-role-binding (rbac.authorization.k8s.io/v1) cluster
5:30:38PM: create clusterrole/build-service-admin-role (rbac.authorization.k8s.io/v1) cluster
5:30:38PM: create customresourcedefinition/clusterstacks.kpack.io (apiextensions.k8s.io/v1) cluster
5:30:38PM: create clusterrolebinding/build-service-admin-role-binding (rbac.authorization.k8s.io/v1) cluster
5:30:38PM: create clusterrole/build-service-authenticated-role (rbac.authorization.k8s.io/v1) cluster
5:30:38PM: create customresourcedefinition/customstacks.stacks.stacks-operator.tanzu.vmware.com (apiextensions.k8s.io/v1beta1) cluster
5:30:39PM: create namespace/kpack (v1) cluster
5:30:39PM: create validatingwebhookconfiguration/validation.webhook.kpack.io (admissionregistration.k8s.io/v1beta1) cluster
5:30:40PM: create mutatingwebhookconfiguration/defaults.webhook.kpack.io (admissionregistration.k8s.io/v1beta1) cluster
5:30:40PM: create customresourcedefinition/clusterstores.kpack.io (apiextensions.k8s.io/v1) cluster
5:30:40PM: create customresourcedefinition/builds.kpack.io (apiextensions.k8s.io/v1) cluster
5:30:40PM: create customresourcedefinition/builders.kpack.io (apiextensions.k8s.io/v1) cluster
5:30:40PM: create customresourcedefinition/clusterbuilders.kpack.io (apiextensions.k8s.io/v1) cluster
5:30:40PM: create clusterrole/kpack-webhook-mutatingwebhookconfiguration-admin (rbac.authorization.k8s.io/v1) cluster
5:30:41PM: create clusterrolebinding/cert-injection-webhook-cluster-role-binding (rbac.authorization.k8s.io/v1) cluster
5:30:41PM: create clusterrole/cert-injection-webhook-cluster-role (rbac.authorization.k8s.io/v1) cluster
5:30:41PM: create clusterrole/build-service-user-role (rbac.authorization.k8s.io/v1) cluster
5:30:41PM: create namespace/build-service (v1) cluster
5:30:41PM: create clusterrolebinding/kpack-webhook-certs-mutatingwebhookconfiguration-admin-binding (rbac.authorization.k8s.io/v1) cluster
5:30:41PM: create clusterrolebinding/kpack-controller-admin-binding (rbac.authorization.k8s.io/v1) cluster
5:30:41PM: create clusterrole/kpack-controller-admin (rbac.authorization.k8s.io/v1) cluster
5:30:41PM: create clusterrole/proxy-role (rbac.authorization.k8s.io/v1) cluster
5:30:41PM: create mutatingwebhookconfiguration/defaults.webhook.cert-injection.tanzu.vmware.com (admissionregistration.k8s.io/v1beta1) cluster
5:30:42PM: create clusterrole/build-service-secret-syncer-role (rbac.authorization.k8s.io/v1) cluster
5:30:42PM: create clusterrolebinding/build-service-secret-syncer-role-binding (rbac.authorization.k8s.io/v1) cluster
5:30:42PM: create clusterrolebinding/proxy-rolebinding (rbac.authorization.k8s.io/v1) cluster
5:30:42PM: create clusterrole/build-service-warmer-role (rbac.authorization.k8s.io/v1) cluster
5:30:43PM: create clusterrole/build-service-dependency-updater-role (rbac.authorization.k8s.io/v1) cluster
5:30:43PM: create customresourcedefinition/sourceresolvers.kpack.io (apiextensions.k8s.io/v1) cluster
5:30:43PM: create customresourcedefinition/images.kpack.io (apiextensions.k8s.io/v1) cluster
5:30:43PM: create customresourcedefinition/tanzunetdependencyupdaters.buildservice.tanzu.vmware.com (apiextensions.k8s.io/v1) cluster
5:30:43PM: ---- waiting on 39 changes [0/95 done] ----
5:30:44PM: ok: reconcile clusterrole/build-service-admin-role (rbac.authorization.k8s.io/v1) cluster
5:30:44PM: ok: reconcile customresourcedefinition/builds.kpack.io (apiextensions.k8s.io/v1) cluster
5:30:44PM: ok: reconcile customresourcedefinition/tanzunetdependencyupdaters.buildservice.tanzu.vmware.com (apiextensions.k8s.io/v1) cluster
5:30:44PM: ok: reconcile customresourcedefinition/clusterstores.kpack.io (apiextensions.k8s.io/v1) cluster
5:30:44PM: ok: reconcile clusterrole/custom-stack-editor-role (rbac.authorization.k8s.io/v1) cluster
5:30:44PM: ok: reconcile clusterrolebinding/stacks-operator-manager-rolebinding (rbac.authorization.k8s.io/v1) cluster
5:30:44PM: ok: reconcile clusterrolebinding/build-service-admin-role-binding (rbac.authorization.k8s.io/v1) cluster
5:30:44PM: ok: reconcile customresourcedefinition/clusterstacks.kpack.io (apiextensions.k8s.io/v1) cluster
5:30:44PM: ok: reconcile customresourcedefinition/customstacks.stacks.stacks-operator.tanzu.vmware.com (apiextensions.k8s.io/v1beta1) cluster
5:30:44PM: ok: reconcile clusterrole/build-service-authenticated-role (rbac.authorization.k8s.io/v1) cluster
5:30:44PM: ok: reconcile namespace/stacks-operator-system (v1) cluster
5:30:44PM: ok: reconcile clusterrolebinding/build-service-authenticated-role-binding (rbac.authorization.k8s.io/v1) cluster
5:30:44PM: ok: reconcile clusterrolebinding/build-service-dependency-updater-role-binding (rbac.authorization.k8s.io/v1) cluster
5:30:44PM: ok: reconcile clusterrole/stacks-operator-manager-role (rbac.authorization.k8s.io/v1) cluster
5:30:44PM: ok: reconcile clusterrole/custom-stack-viewer-role (rbac.authorization.k8s.io/v1) cluster
5:30:44PM: ok: reconcile clusterrolebinding/build-service-warmer-role-binding (rbac.authorization.k8s.io/v1) cluster
5:30:45PM: ok: reconcile validatingwebhookconfiguration/validation.webhook.kpack.io (admissionregistration.k8s.io/v1beta1) cluster
5:30:45PM: ok: reconcile mutatingwebhookconfiguration/defaults.webhook.kpack.io (admissionregistration.k8s.io/v1beta1) cluster
5:30:45PM: ok: reconcile namespace/kpack (v1) cluster
5:30:45PM: ok: reconcile clusterrole/kpack-controller-admin (rbac.authorization.k8s.io/v1) cluster
5:30:45PM: ok: reconcile customresourcedefinition/builders.kpack.io (apiextensions.k8s.io/v1) cluster
5:30:45PM: ok: reconcile clusterrolebinding/cert-injection-webhook-cluster-role-binding (rbac.authorization.k8s.io/v1) cluster
5:30:45PM: ok: reconcile customresourcedefinition/clusterbuilders.kpack.io (apiextensions.k8s.io/v1) cluster
5:30:45PM: ok: reconcile clusterrole/kpack-webhook-mutatingwebhookconfiguration-admin (rbac.authorization.k8s.io/v1) cluster
5:30:45PM: ok: reconcile clusterrole/cert-injection-webhook-cluster-role (rbac.authorization.k8s.io/v1) cluster
5:30:45PM: ok: reconcile clusterrole/metrics-reader (rbac.authorization.k8s.io/v1beta1) cluster
5:30:45PM: ok: reconcile clusterrole/build-service-user-role (rbac.authorization.k8s.io/v1) cluster
5:30:45PM: ok: reconcile namespace/build-service (v1) cluster
5:30:45PM: ok: reconcile clusterrolebinding/kpack-webhook-certs-mutatingwebhookconfiguration-admin-binding (rbac.authorization.k8s.io/v1) cluster
5:30:45PM: ok: reconcile clusterrolebinding/proxy-rolebinding (rbac.authorization.k8s.io/v1) cluster
5:30:45PM: ok: reconcile clusterrole/proxy-role (rbac.authorization.k8s.io/v1) cluster
5:30:45PM: ok: reconcile mutatingwebhookconfiguration/defaults.webhook.cert-injection.tanzu.vmware.com (admissionregistration.k8s.io/v1beta1) cluster
5:30:45PM: ok: reconcile clusterrole/build-service-secret-syncer-role (rbac.authorization.k8s.io/v1) cluster
5:30:45PM: ok: reconcile clusterrolebinding/build-service-secret-syncer-role-binding (rbac.authorization.k8s.io/v1) cluster
5:30:45PM: ok: reconcile clusterrolebinding/kpack-controller-admin-binding (rbac.authorization.k8s.io/v1) cluster
5:30:45PM: ok: reconcile clusterrole/build-service-dependency-updater-role (rbac.authorization.k8s.io/v1) cluster
5:30:45PM: ok: reconcile clusterrole/build-service-warmer-role (rbac.authorization.k8s.io/v1) cluster
5:30:45PM: ok: reconcile customresourcedefinition/images.kpack.io (apiextensions.k8s.io/v1) cluster
5:30:46PM: ok: reconcile customresourcedefinition/sourceresolvers.kpack.io (apiextensions.k8s.io/v1) cluster
5:30:46PM: ---- applying 44 changes [39/95 done] ----
5:30:46PM: create rolebinding/build-service-warmer-namespace-role-binding (rbac.authorization.k8s.io/v1) namespace: build-service
5:30:46PM: create rolebinding/build-service-admin-configmap-role-binding (rbac.authorization.k8s.io/v1) namespace: kpack
5:30:46PM: create configmap/build-service-version (v1) namespace: build-service
5:30:46PM: create configmap/kp-config (v1) namespace: kpack
5:30:46PM: create configmap/ca-cert (v1) namespace: build-service
5:30:46PM: create configmap/http-proxy (v1) namespace: build-service
5:30:46PM: create rolebinding/cert-injection-webhook-role-binding (rbac.authorization.k8s.io/v1) namespace: build-service
5:30:46PM: create configmap/https-proxy (v1) namespace: build-service
5:30:47PM: create configmap/no-proxy (v1) namespace: build-service
5:30:47PM: create configmap/setup-ca-certs-image (v1) namespace: build-service
5:30:47PM: create secret/cert-injection-webhook-tls (v1) namespace: build-service
5:30:47PM: create role/cert-injection-webhook-role (rbac.authorization.k8s.io/v1) namespace: build-service
5:30:47PM: create role/leader-election-role (rbac.authorization.k8s.io/v1) namespace: stacks-operator-system
5:30:47PM: create secret/canonical-registry-secret (v1) namespace: stacks-operator-system
5:30:48PM: create configmap/stackify-image (v1) namespace: stacks-operator-system
5:30:48PM: create role/build-service-admin-configmap-role (rbac.authorization.k8s.io/v1) namespace: kpack
5:30:48PM: create configmap/completion-windows-image (v1) namespace: kpack
5:30:48PM: create secret/canonical-registry-secret (v1) namespace: kpack
5:30:48PM: create serviceaccount/cert-injection-webhook-sa (v1) namespace: build-service
5:30:49PM: create configmap/build-init-image (v1) namespace: kpack
5:30:49PM: create configmap/build-init-windows-image (v1) namespace: kpack
5:30:49PM: create serviceaccount/secret-syncer-service-account (v1) namespace: build-service
5:30:49PM: create configmap/rebase-image (v1) namespace: kpack
5:30:49PM: create configmap/lifecycle-image (v1) namespace: kpack
5:30:49PM: create configmap/completion-image (v1) namespace: kpack
5:30:50PM: create rolebinding/build-service-dependency-updater-kp-config-role-binding (rbac.authorization.k8s.io/v1) namespace: kpack
5:30:50PM: create serviceaccount/canonical-registry-serviceaccount (v1) namespace: kpack
5:30:50PM: create role/build-service-dependency-updater-kp-config-role (rbac.authorization.k8s.io/v1) namespace: kpack
5:30:50PM: create role/build-service-warmer-namespace-role (rbac.authorization.k8s.io/v1) namespace: build-service
5:30:51PM: create rolebinding/leader-election-rolebinding (rbac.authorization.k8s.io/v1) namespace: stacks-operator-system
5:30:51PM: create secret/canonical-registry-secret (v1) namespace: build-service
5:30:51PM: create serviceaccount/warmer-service-account (v1) namespace: build-service
5:30:51PM: create serviceaccount/cb-service-account (v1) namespace: build-service
5:30:51PM: create secret/dependency-updater-secret (v1) namespace: build-service
5:30:51PM: create serviceaccount/dependency-updater-controller-serviceaccount (v1) namespace: build-service
5:30:51PM: create secret/webhook-certs (v1) namespace: kpack
5:30:52PM: create role/kpack-controller-local-config (rbac.authorization.k8s.io/v1) namespace: kpack
5:30:52PM: create rolebinding/kpack-controller-local-config-binding (rbac.authorization.k8s.io/v1) namespace: kpack
5:30:52PM: create role/kpack-webhook-certs-admin (rbac.authorization.k8s.io/v1) namespace: kpack
5:30:52PM: create rolebinding/kpack-webhook-certs-admin-binding (rbac.authorization.k8s.io/v1) namespace: kpack
5:30:52PM: create configmap/sleeper-image (v1) namespace: build-service
5:30:53PM: create serviceaccount/controller (v1) namespace: kpack
5:30:53PM: create serviceaccount/webhook (v1) namespace: kpack
5:30:54PM: create serviceaccount/dependency-updater-serviceaccount (v1) namespace: build-service
5:30:54PM: ---- waiting on 44 changes [39/95 done] ----
5:30:54PM: ok: reconcile serviceaccount/dependency-updater-controller-serviceaccount (v1) namespace: build-service
5:30:54PM: ok: reconcile serviceaccount/canonical-registry-serviceaccount (v1) namespace: kpack
5:30:54PM: ok: reconcile secret/cert-injection-webhook-tls (v1) namespace: build-service
5:30:54PM: ok: reconcile secret/canonical-registry-secret (v1) namespace: build-service
5:30:54PM: ok: reconcile serviceaccount/dependency-updater-serviceaccount (v1) namespace: build-service
5:30:54PM: ok: reconcile rolebinding/build-service-admin-configmap-role-binding (rbac.authorization.k8s.io/v1) namespace: kpack
5:30:54PM: ok: reconcile configmap/ca-cert (v1) namespace: build-service
5:30:54PM: ok: reconcile configmap/build-service-version (v1) namespace: build-service
5:30:54PM: ok: reconcile rolebinding/build-service-warmer-namespace-role-binding (rbac.authorization.k8s.io/v1) namespace: build-service
5:30:54PM: ok: reconcile configmap/kp-config (v1) namespace: kpack
5:30:54PM: ok: reconcile configmap/https-proxy (v1) namespace: build-service
5:30:54PM: ok: reconcile configmap/http-proxy (v1) namespace: build-service
5:30:54PM: ok: reconcile rolebinding/cert-injection-webhook-role-binding (rbac.authorization.k8s.io/v1) namespace: build-service
5:30:54PM: ok: reconcile role/cert-injection-webhook-role (rbac.authorization.k8s.io/v1) namespace: build-service
5:30:54PM: ok: reconcile serviceaccount/cert-injection-webhook-sa (v1) namespace: build-service
5:30:55PM: ok: reconcile role/leader-election-role (rbac.authorization.k8s.io/v1) namespace: stacks-operator-system
5:30:55PM: ok: reconcile secret/canonical-registry-secret (v1) namespace: stacks-operator-system
5:30:55PM: ok: reconcile role/build-service-admin-configmap-role (rbac.authorization.k8s.io/v1) namespace: kpack
5:30:55PM: ok: reconcile configmap/stackify-image (v1) namespace: stacks-operator-system
5:30:55PM: ok: reconcile configmap/completion-windows-image (v1) namespace: kpack
5:30:55PM: ok: reconcile configmap/rebase-image (v1) namespace: kpack
5:30:55PM: ok: reconcile configmap/build-init-image (v1) namespace: kpack
5:30:55PM: ok: reconcile serviceaccount/secret-syncer-service-account (v1) namespace: build-service
5:30:55PM: ok: reconcile configmap/build-init-windows-image (v1) namespace: kpack
5:30:55PM: ok: reconcile role/build-service-warmer-namespace-role (rbac.authorization.k8s.io/v1) namespace: build-service
5:30:55PM: ok: reconcile role/build-service-dependency-updater-kp-config-role (rbac.authorization.k8s.io/v1) namespace: kpack
5:30:55PM: ok: reconcile serviceaccount/warmer-service-account (v1) namespace: build-service
5:30:55PM: ok: reconcile serviceaccount/cb-service-account (v1) namespace: build-service
5:30:55PM: ok: reconcile role/kpack-webhook-certs-admin (rbac.authorization.k8s.io/v1) namespace: kpack
5:30:55PM: ok: reconcile secret/webhook-certs (v1) namespace: kpack
5:30:55PM: ok: reconcile role/kpack-controller-local-config (rbac.authorization.k8s.io/v1) namespace: kpack
5:30:55PM: ok: reconcile configmap/no-proxy (v1) namespace: build-service
5:30:55PM: ok: reconcile configmap/completion-image (v1) namespace: kpack
5:30:55PM: ok: reconcile secret/canonical-registry-secret (v1) namespace: kpack
5:30:55PM: ok: reconcile configmap/lifecycle-image (v1) namespace: kpack
5:30:56PM: ok: reconcile serviceaccount/controller (v1) namespace: kpack
5:30:56PM: ok: reconcile configmap/sleeper-image (v1) namespace: build-service
5:30:56PM: ok: reconcile secret/dependency-updater-secret (v1) namespace: build-service
5:30:56PM: ok: reconcile rolebinding/kpack-webhook-certs-admin-binding (rbac.authorization.k8s.io/v1) namespace: kpack
5:30:56PM: ok: reconcile serviceaccount/webhook (v1) namespace: kpack
5:30:56PM: ok: reconcile rolebinding/kpack-controller-local-config-binding (rbac.authorization.k8s.io/v1) namespace: kpack
5:30:56PM: ok: reconcile rolebinding/leader-election-rolebinding (rbac.authorization.k8s.io/v1) namespace: stacks-operator-system
5:30:56PM: ok: reconcile rolebinding/build-service-dependency-updater-kp-config-role-binding (rbac.authorization.k8s.io/v1) namespace: kpack
5:30:56PM: ok: reconcile configmap/setup-ca-certs-image (v1) namespace: build-service
5:30:56PM: ---- applying 12 changes [83/95 done] ----
5:30:56PM: create service/kpack-webhook (v1) namespace: kpack
5:30:57PM: create service/controller-manager-metrics-service (v1) namespace: stacks-operator-system
5:30:58PM: create deployment/kpack-controller (apps/v1) namespace: kpack
5:30:58PM: create deployment/cert-injection-webhook (apps/v1) namespace: build-service
5:30:58PM: create deployment/warmer-controller (apps/v1) namespace: build-service
5:30:58PM: create deployment/controller-manager (apps/v1) namespace: stacks-operator-system
5:30:59PM: create deployment/dependency-updater-controller (apps/v1) namespace: build-service
5:30:59PM: create service/cert-injection-webhook (v1) namespace: build-service
5:30:59PM: create tanzunetdependencyupdater/dependency-updater (buildservice.tanzu.vmware.com/v1alpha1) namespace: build-service
5:31:00PM: create daemonset/build-pod-image-fetcher (apps/v1) namespace: build-service
5:31:00PM: create deployment/kpack-webhook (apps/v1) namespace: kpack
5:31:01PM: create deployment/secret-syncer-controller (apps/v1) namespace: build-service
5:31:01PM: ---- waiting on 12 changes [83/95 done] ----
5:31:01PM: ok: reconcile service/kpack-webhook (v1) namespace: kpack
5:31:01PM: ok: reconcile service/controller-manager-metrics-service (v1) namespace: stacks-operator-system
5:31:02PM: ongoing: reconcile tanzunetdependencyupdater/dependency-updater (buildservice.tanzu.vmware.com/v1alpha1) namespace: build-service
5:31:02PM:  ^ Waiting for generation 1 to be observed
5:31:03PM: ongoing: reconcile deployment/secret-syncer-controller (apps/v1) namespace: build-service
5:31:03PM:  ^ Waiting for 1 unavailable replicas
5:31:03PM:  L ok: waiting on replicaset/secret-syncer-controller-5ff66644f5 (apps/v1) namespace: build-service
5:31:03PM:  L ongoing: waiting on pod/secret-syncer-controller-5ff66644f5-g5f9b (v1) namespace: build-service
5:31:03PM:     ^ Pending: ContainerCreating
5:31:03PM: ongoing: reconcile deployment/kpack-controller (apps/v1) namespace: kpack
5:31:03PM:  ^ Waiting for 1 unavailable replicas
5:31:03PM:  L ok: waiting on replicaset/kpack-controller-6ffdb5cc6d (apps/v1) namespace: kpack
5:31:03PM:  L ongoing: waiting on pod/kpack-controller-6ffdb5cc6d-wj45x (v1) namespace: kpack
5:31:03PM:     ^ Pending: ContainerCreating
5:31:03PM: ongoing: reconcile deployment/controller-manager (apps/v1) namespace: stacks-operator-system
5:31:03PM:  ^ Waiting for 1 unavailable replicas
5:31:03PM:  L ok: waiting on replicaset/controller-manager-7749db758 (apps/v1) namespace: stacks-operator-system
5:31:03PM:  L ongoing: waiting on pod/controller-manager-7749db758-dwshw (v1) namespace: stacks-operator-system
5:31:03PM:     ^ Pending: ContainerCreating
5:31:03PM: ongoing: reconcile deployment/cert-injection-webhook (apps/v1) namespace: build-service
5:31:03PM:  ^ Waiting for 1 unavailable replicas
5:31:03PM:  L ok: waiting on replicaset/cert-injection-webhook-745c5cbcc8 (apps/v1) namespace: build-service
5:31:03PM:  L ongoing: waiting on pod/cert-injection-webhook-745c5cbcc8-4vnz9 (v1) namespace: build-service
5:31:03PM:     ^ Pending: ContainerCreating
5:31:03PM: ok: reconcile service/cert-injection-webhook (v1) namespace: build-service
5:31:03PM: ongoing: reconcile deployment/dependency-updater-controller (apps/v1) namespace: build-service
5:31:03PM:  ^ Waiting for 1 unavailable replicas
5:31:03PM:  L ok: waiting on replicaset/dependency-updater-controller-884fb6f6d (apps/v1) namespace: build-service
5:31:03PM:  L ongoing: waiting on pod/dependency-updater-controller-884fb6f6d-2skrp (v1) namespace: build-service
5:31:03PM:     ^ Pending: ContainerCreating
5:31:04PM: ongoing: reconcile deployment/warmer-controller (apps/v1) namespace: build-service
5:31:04PM:  ^ Waiting for 1 unavailable replicas
5:31:04PM:  L ok: waiting on replicaset/warmer-controller-68ff5847df (apps/v1) namespace: build-service
5:31:04PM:  L ongoing: waiting on pod/warmer-controller-68ff5847df-m2s2t (v1) namespace: build-service
5:31:04PM:     ^ Pending: ContainerCreating
5:31:04PM: ongoing: reconcile daemonset/build-pod-image-fetcher (apps/v1) namespace: build-service
5:31:04PM:  ^ Waiting for 4 unavailable pods
5:31:04PM:  L ongoing: waiting on pod/build-pod-image-fetcher-wztmz (v1) namespace: build-service
5:31:04PM:     ^ Pending: PodInitializing
5:31:04PM:  L ongoing: waiting on pod/build-pod-image-fetcher-p7f26 (v1) namespace: build-service
5:31:04PM:     ^ Pending: PodInitializing
5:31:04PM:  L ongoing: waiting on pod/build-pod-image-fetcher-dpgx7 (v1) namespace: build-service
5:31:04PM:     ^ Pending: PodInitializing
5:31:04PM:  L ongoing: waiting on pod/build-pod-image-fetcher-2zwlg (v1) namespace: build-service
5:31:04PM:     ^ Pending: PodInitializing
5:31:04PM:  L ok: waiting on controllerrevision/build-pod-image-fetcher-7849548d6f (apps/v1) namespace: build-service
5:31:04PM: ongoing: reconcile deployment/kpack-webhook (apps/v1) namespace: kpack
5:31:04PM:  ^ Waiting for 1 unavailable replicas
5:31:04PM:  L ok: waiting on replicaset/kpack-webhook-77567cd6b9 (apps/v1) namespace: kpack
5:31:04PM:  L ongoing: waiting on pod/kpack-webhook-77567cd6b9-pxzn2 (v1) namespace: kpack
5:31:04PM:     ^ Pending: ContainerCreating
5:31:04PM: ---- waiting on 9 changes [86/95 done] ----
5:31:23PM: ongoing: reconcile deployment/dependency-updater-controller (apps/v1) namespace: build-service
5:31:23PM:  ^ Waiting for 1 unavailable replicas
5:31:23PM:  L ok: waiting on replicaset/dependency-updater-controller-884fb6f6d (apps/v1) namespace: build-service
5:31:23PM:  L ok: waiting on pod/dependency-updater-controller-884fb6f6d-2skrp (v1) namespace: build-service
5:31:24PM: ongoing: reconcile deployment/secret-syncer-controller (apps/v1) namespace: build-service
5:31:24PM:  ^ Waiting for 1 unavailable replicas
5:31:24PM:  L ok: waiting on replicaset/secret-syncer-controller-5ff66644f5 (apps/v1) namespace: build-service
5:31:24PM:  L ok: waiting on pod/secret-syncer-controller-5ff66644f5-g5f9b (v1) namespace: build-service
5:31:27PM: ongoing: reconcile deployment/kpack-webhook (apps/v1) namespace: kpack
5:31:27PM:  ^ Waiting for 1 unavailable replicas
5:31:27PM:  L ok: waiting on replicaset/kpack-webhook-77567cd6b9 (apps/v1) namespace: kpack
5:31:27PM:  L ok: waiting on pod/kpack-webhook-77567cd6b9-pxzn2 (v1) namespace: kpack
5:31:27PM: ongoing: reconcile deployment/controller-manager (apps/v1) namespace: stacks-operator-system
5:31:27PM:  ^ Waiting for 1 unavailable replicas
5:31:27PM:  L ok: waiting on replicaset/controller-manager-7749db758 (apps/v1) namespace: stacks-operator-system
5:31:27PM:  L ok: waiting on pod/controller-manager-7749db758-dwshw (v1) namespace: stacks-operator-system
5:31:27PM: ok: reconcile deployment/kpack-controller (apps/v1) namespace: kpack
5:31:27PM: ok: reconcile deployment/cert-injection-webhook (apps/v1) namespace: build-service
5:31:28PM: ok: reconcile deployment/warmer-controller (apps/v1) namespace: build-service
5:31:28PM: ok: reconcile deployment/dependency-updater-controller (apps/v1) namespace: build-service
5:31:28PM: ok: reconcile deployment/secret-syncer-controller (apps/v1) namespace: build-service
5:31:28PM: ---- waiting on 4 changes [91/95 done] ----
5:31:30PM: ok: reconcile deployment/controller-manager (apps/v1) namespace: stacks-operator-system
5:31:30PM: ok: reconcile deployment/kpack-webhook (apps/v1) namespace: kpack
5:31:30PM: ---- waiting on 2 changes [93/95 done] ----
5:31:43PM: ongoing: reconcile daemonset/build-pod-image-fetcher (apps/v1) namespace: build-service
5:31:43PM:  ^ Waiting for 3 unavailable pods
5:31:43PM:  L ok: waiting on pod/build-pod-image-fetcher-wztmz (v1) namespace: build-service
5:31:43PM:  L ok: waiting on pod/build-pod-image-fetcher-p7f26 (v1) namespace: build-service
5:31:43PM:  L ok: waiting on pod/build-pod-image-fetcher-dpgx7 (v1) namespace: build-service
5:31:43PM:  L ongoing: waiting on pod/build-pod-image-fetcher-2zwlg (v1) namespace: build-service
5:31:43PM:     ^ Pending: PodInitializing
5:31:43PM:  L ok: waiting on controllerrevision/build-pod-image-fetcher-7849548d6f (apps/v1) namespace: build-service
5:31:46PM: ongoing: reconcile daemonset/build-pod-image-fetcher (apps/v1) namespace: build-service
5:31:46PM:  ^ Waiting for 1 unavailable pods
5:31:46PM:  L ok: waiting on pod/build-pod-image-fetcher-wztmz (v1) namespace: build-service
5:31:46PM:  L ok: waiting on pod/build-pod-image-fetcher-p7f26 (v1) namespace: build-service
5:31:46PM:  L ok: waiting on pod/build-pod-image-fetcher-dpgx7 (v1) namespace: build-service
5:31:46PM:  L ok: waiting on pod/build-pod-image-fetcher-2zwlg (v1) namespace: build-service
5:31:46PM:  L ok: waiting on controllerrevision/build-pod-image-fetcher-7849548d6f (apps/v1) namespace: build-service
5:31:48PM: ok: reconcile daemonset/build-pod-image-fetcher (apps/v1) namespace: build-service
5:31:48PM: ---- waiting on 1 changes [94/95 done] ----
5:32:02PM: ongoing: reconcile tanzunetdependencyupdater/dependency-updater (buildservice.tanzu.vmware.com/v1alpha1) namespace: build-service
5:32:02PM:  ^ Waiting for generation 1 to be observed
5:32:49PM: ---- waiting on 1 changes [94/95 done] ----
5:33:02PM: ongoing: reconcile tanzunetdependencyupdater/dependency-updater (buildservice.tanzu.vmware.com/v1alpha1) namespace: build-service
5:33:02PM:  ^ Waiting for generation 1 to be observed
5:33:50PM: ---- waiting on 1 changes [94/95 done] ----
5:34:03PM: ongoing: reconcile tanzunetdependencyupdater/dependency-updater (buildservice.tanzu.vmware.com/v1alpha1) namespace: build-service
5:34:03PM:  ^ Waiting for generation 1 to be observed
5:34:50PM: ---- waiting on 1 changes [94/95 done] ----
5:35:03PM: ongoing: reconcile tanzunetdependencyupdater/dependency-updater (buildservice.tanzu.vmware.com/v1alpha1) namespace: build-service
5:35:03PM:  ^ Waiting for generation 1 to be observed
5:35:51PM: ---- waiting on 1 changes [94/95 done] ----
5:36:04PM: ongoing: reconcile tanzunetdependencyupdater/dependency-updater (buildservice.tanzu.vmware.com/v1alpha1) namespace: build-service
5:36:04PM:  ^ Waiting for generation 1 to be observed
5:36:51PM: ---- waiting on 1 changes [94/95 done] ----
5:37:04PM: ongoing: reconcile tanzunetdependencyupdater/dependency-updater (buildservice.tanzu.vmware.com/v1alpha1) namespace: build-service
5:37:04PM:  ^ Waiting for generation 1 to be observed
5:37:52PM: ---- waiting on 1 changes [94/95 done] ----
5:38:05PM: ongoing: reconcile tanzunetdependencyupdater/dependency-updater (buildservice.tanzu.vmware.com/v1alpha1) namespace: build-service
5:38:05PM:  ^ Waiting for generation 1 to be observed
5:38:52PM: ---- waiting on 1 changes [94/95 done] ----
5:39:05PM: ongoing: reconcile tanzunetdependencyupdater/dependency-updater (buildservice.tanzu.vmware.com/v1alpha1) namespace: build-service
5:39:05PM:  ^ Waiting for generation 1 to be observed
5:39:52PM: ---- waiting on 1 changes [94/95 done] ----
5:40:05PM: ongoing: reconcile tanzunetdependencyupdater/dependency-updater (buildservice.tanzu.vmware.com/v1alpha1) namespace: build-service
5:40:05PM:  ^ Waiting for generation 1 to be observed
5:40:52PM: ---- waiting on 1 changes [94/95 done] ----
5:41:05PM: ongoing: reconcile tanzunetdependencyupdater/dependency-updater (buildservice.tanzu.vmware.com/v1alpha1) namespace: build-service
5:41:05PM:  ^ Waiting for generation 1 to be observed
5:41:53PM: ---- waiting on 1 changes [94/95 done] ----
5:42:06PM: ongoing: reconcile tanzunetdependencyupdater/dependency-updater (buildservice.tanzu.vmware.com/v1alpha1) namespace: build-service
5:42:06PM:  ^ Waiting for generation 1 to be observed
5:42:46PM: ok: reconcile tanzunetdependencyupdater/dependency-updater (buildservice.tanzu.vmware.com/v1alpha1) namespace: build-service
5:42:46PM:  ^ Encountered successful condition Ready == True: LatestImportSuccessful (message: Latest Import of Resources for Version 100.0.150 was successful)
5:42:46PM: ---- applying complete [95/95 done] ----
5:42:46PM: ---- waiting complete [95/95 done] ----
 
Succeeded
vdesikan@vdesikan-a01 tap-install %
 
vdesikan@vdesikan-a01 tap-install % kubectl get pods -A
NAMESPACE                NAME                                                    READY   STATUS    RESTARTS   AGE
accelerator-system       acc-engine-69f7f7b6b8-pstf9                             1/1     Running   0          49m
accelerator-system       acc-ui-server-6df7c597bd-fz5hv                          1/1     Running   0          49m
accelerator-system       accelerator-controller-manager-796f7dff7-pqtvg          1/1     Running   0          49m
build-service            build-pod-image-fetcher-2zwlg                           5/5     Running   0          12m
build-service            build-pod-image-fetcher-dpgx7                           5/5     Running   0          12m
build-service            build-pod-image-fetcher-p7f26                           5/5     Running   0          12m
build-service            build-pod-image-fetcher-wztmz                           5/5     Running   0          12m
build-service            cert-injection-webhook-745c5cbcc8-4vnz9                 1/1     Running   0          12m
build-service            dependency-updater-controller-884fb6f6d-2skrp           1/1     Running   0          12m
build-service            secret-syncer-controller-5ff66644f5-g5f9b               1/1     Running   0          12m
build-service            smart-warmer-image-fetcher-45l95                        4/4     Running   0          59s
build-service            smart-warmer-image-fetcher-lzc9p                        4/4     Running   0          53s
build-service            smart-warmer-image-fetcher-rfbr4                        4/4     Running   0          52s
build-service            smart-warmer-image-fetcher-wnkss                        4/4     Running   0          50s
build-service            warmer-controller-68ff5847df-m2s2t                      1/1     Running   0          12m
contour-external         contour-7c7795856b-8mqlz                                1/1     Running   0          55m
contour-external         contour-7c7795856b-8xh6c                                1/1     Running   0          55m
contour-external         envoy-7fzmk                                             2/2     Running   0          55m
contour-external         envoy-ccrgj                                             2/2     Running   0          55m
contour-external         envoy-fndxp                                             2/2     Running   0          55m
contour-external         envoy-mcbfr                                             2/2     Running   0          55m
contour-internal         contour-5b6b565d-6sbx4                                  1/1     Running   0          55m
contour-internal         contour-5b6b565d-lhmvn                                  1/1     Running   0          55m
contour-internal         envoy-l2tc6                                             2/2     Running   0          55m
contour-internal         envoy-mv7x2                                             2/2     Running   0          55m
contour-internal         envoy-rnhtf                                             2/2     Running   0          55m
contour-internal         envoy-t2llr                                             2/2     Running   0          55m
flux-system              helm-controller-68996c978c-rlfnb                        1/1     Running   0          52m
flux-system              image-automation-controller-68d55fccd8-52wwk            1/1     Running   0          52m
flux-system              image-reflector-controller-7784457d8f-n82r7             1/1     Running   0          52m
flux-system              kustomize-controller-759f994b-tpbrf                     1/1     Running   0          52m
flux-system              notification-controller-6fd769cbf4-qn2kk                1/1     Running   0          52m
flux-system              source-controller-648d7f445d-2h2wc                      1/1     Running   0          52m
kapp-controller          kapp-controller-ff4656bb-cjrl7                          1/1     Running   0          69m
knative-discovery        controller-b59bd9449-8l9f4                              1/1     Running   0          55m
knative-discovery        webhook-54c56fc5b8-8djnb                                1/1     Running   0          55m
knative-eventing         eventing-controller-6c7fbfdb79-7vr4w                    1/1     Running   0          55m
knative-eventing         eventing-webhook-5885fcccc9-7b5lh                       1/1     Running   0          55m
knative-eventing         eventing-webhook-5885fcccc9-vbgzs                       1/1     Running   0          55m
knative-eventing         imc-controller-bdb84c8ff-q67gj                          1/1     Running   0          55m
knative-eventing         imc-dispatcher-586bd55496-6j97d                         1/1     Running   0          55m
knative-eventing         mt-broker-controller-785589dd9d-vlx6v                   1/1     Running   0          55m
knative-eventing         mt-broker-filter-7dfcf6589-fjhmz                        1/1     Running   0          55m
knative-eventing         mt-broker-ingress-688cc7f74-l46p9                       1/1     Running   0          55m
knative-eventing         rabbitmq-broker-controller-85d5b56f8-kwz9x              1/1     Running   0          55m
knative-serving          activator-5b59f7c699-4cvts                              1/1     Running   0          55m
knative-serving          activator-5b59f7c699-4mbtl                              1/1     Running   0          55m
knative-serving          activator-5b59f7c699-sk2m5                              1/1     Running   0          55m
knative-serving          autoscaler-8f85d46c-g4tnh                               1/1     Running   0          55m
knative-serving          contour-ingress-controller-8fbc54c-whghl                1/1     Running   0          55m
knative-serving          controller-645bdbc7d9-z5n5v                             1/1     Running   0          55m
knative-serving          net-certmanager-webhook-dcdc76d4-qnxzg                  1/1     Running   0          55m
knative-serving          networking-certmanager-7575777f9f-t4tf9                 1/1     Running   0          55m
knative-serving          webhook-7cb844897b-sdqrz                                1/1     Running   0          55m
knative-serving          webhook-7cb844897b-tkszw                                1/1     Running   0          55m
knative-sources          rabbitmq-controller-manager-5dcb7c8494-t7c8k            1/1     Running   0          55m
knative-sources          rabbitmq-webhook-bcb77f84f-2d6fw                        1/1     Running   0          55m
kpack                    kpack-controller-6ffdb5cc6d-wj45x                       1/1     Running   0          12m
kpack                    kpack-webhook-77567cd6b9-pxzn2                          1/1     Running   0          12m
kube-system              aws-node-2fzbz                                          1/1     Running   0          4d1h
kube-system              aws-node-4s2vw                                          1/1     Running   0          4d1h
kube-system              aws-node-jf8vp                                          1/1     Running   0          4d1h
kube-system              aws-node-m4rz7                                          1/1     Running   0          4d1h
kube-system              coredns-5c778788f4-bl47d                                1/1     Running   0          4d1h
kube-system              coredns-5c778788f4-swf2n                                1/1     Running   0          4d1h
kube-system              kube-proxy-dcbwg                                        1/1     Running   0          4d1h
kube-system              kube-proxy-rq6gh                                        1/1     Running   0          4d1h
kube-system              kube-proxy-sbsrz                                        1/1     Running   0          4d1h
kube-system              kube-proxy-xl2b5                                        1/1     Running   0          4d1h
stacks-operator-system   controller-manager-7749db758-dwshw                      1/1     Running   0          12m
tap-install              application-live-view-connector-57cd7c6c6-pv8dk         1/1     Running   0          47m
tap-install              application-live-view-crd-controller-5b659f8f57-7zz25   1/1     Running   0          47m
tap-install              application-live-view-server-79bd874566-qtcbc           1/1     Running   0          47m
triggermesh              aws-event-sources-controller-7f9dd6d69-6ldbs            1/1     Running   0          55m
vmware-sources           webhook-c9f67b5cd-tjv4p                                 1/1     Running   0          55m
vdesikan@vdesikan-a01 tap-install % kapp list -A
Target cluster 'https://94A70B79EF7B1D5E718A4E96B2925F91.gr7.us-east-2.eks.amazonaws.com' (nodes: ip-172-31-46-226.us-east-2.compute.internal, 3+)
 
Apps in all namespaces
 
Namespace    Name                                      Namespaces                                                  Lcs   Lca
default      flux                                      (cluster),flux-system                                       true  53m
^            kc                                        (cluster),kapp-controller,kube-system                       true  1h
^            tanzu-build-service                       (cluster),build-service,kpack,                              true  13m
                                                       stacks-operator-system
tap-install  app-accelerator-ctrl                      (cluster),accelerator-system                                true  33s
^            app-live-view-ctrl                        (cluster),tap-install                                       true  47m
^            cloud-native-runtimes-ctrl                (cluster),contour-external,                                 true  18s
                                                       contour-internal,knative-discovery,knative-eventing,
                                                       knative-serving,knative-sources,triggermesh,vmware-sources
^            tanzu-application-platform-packages-ctrl  tap-install                                                 true  1h
^            tap-package-repo                          tap-install                                                 true  1h
 
Lcs: Last Change Successful
Lca: Last Change Age
 
8 apps
 
Succeeded
```

## User Scenario Flow:
1. Create an App Accelerator Template for a sample application (spring-pet-clinic) from a git repo.
  1. Create New Accelerator.
```
vdesikan@vdesikan-a01 tap-install % more new-accelerator.yaml
apiVersion: accelerator.apps.tanzu.vmware.com/v1alpha1
kind: Accelerator
metadata:
  name: new-accelerator
spec:
  git:
    url: https://github.com/sample-accelerators/new-accelerator
    ref:
      branch: main
      tag: v0.2.x
vdesikan@vdesikan-a01 tap-install % kubectl apply -f new-accelerator.yaml
accelerator.accelerator.apps.tanzu.vmware.com/new-accelerator created
vdesikan@vdesikan-a01 tap-install % kubectl get accelerator                 
NAME              READY   REASON   AGE
new-accelerator   True             5s
```
  2. Create spring-pet-clinic accelerator, Generate the project, create a new accelerator and add accelerator.yaml to git repo. You should see new accelerator in App Accelerator UI.
```
vdesikan@vdesikan-a01 tap-install % cd ../Downloads
vdesikan@vdesikan-a01 Downloads % ls | grep spring
spring-petclinic-acc.zip
vdesikan@vdesikan-a01 Downloads % unzip spring-petclinic-acc.zip
Archive:  spring-petclinic-acc.zip
   creating: spring-petclinic-acc/
  inflating: spring-petclinic-acc/accelerator.yaml 
  inflating: spring-petclinic-acc/k8s-resource.yaml 
  inflating: spring-petclinic-acc/README.md 
  inflating: spring-petclinic-acc/accelerator-log.md 
vdesikan@vdesikan-a01 Downloads % cd spring-petclinic-acc
vdesikan@vdesikan-a01 spring-petclinic-acc % ls
README.md       accelerator-log.md  accelerator.yaml    k8s-resource.yaml
vdesikan@vdesikan-a01 spring-petclinic-acc % kubectl apply -f k8s-resource.yaml
accelerator.accelerator.apps.tanzu.vmware.com/spring-pet-clinic-acc created
vdesikan@vdesikan-a01 spring-petclinic-acc % kubectl get accelerator             
NAME                    READY   REASON   AGE
new-accelerator         True             4m32s
spring-pet-clinic-acc   True             7s
vdesikan@vdesikan-a01 spring-petclinic-acc % more accelerator.yaml  
accelerator:
  displayName: spring-petclinic-acc
  description: spring per clinic accelerator
  iconUrl: https://raw.githubusercontent.com/sample-accelerators/icons/master/icon-tanzu-light.png
  tags: []
  options:
  - name: optionName
    label: Nice Label
    display: true
    defaultValue: ""
engine:
  include:
  - '**'
```
2. Generate the project and add that to a new git repo. Using the new spring-petclinic-demo-acc, create a new project "spring-pet-clinic-eks" and add it to a new git repo spring-pet-clinic-eks.git.
```
vdesikan@vdesikan-a01 spring-petclinic-acc % cd ../
vdesikan@vdesikan-a01 Downloads % ls | grep spring                 
spring-pet-clinic-eks.zip
spring-petclinic-acc
spring-petclinic-acc.zip
vdesikan@vdesikan-a01 Downloads % unzip spring-pet-clinic-eks.zip
Archive:  spring-pet-clinic-eks.zip
   creating: spring-pet-clinic-eks/
  inflating: spring-pet-clinic-eks/mvnw 
   creating: spring-pet-clinic-eks/src/
   creating: spring-pet-clinic-eks/src/main/
   creating: spring-pet-clinic-eks/src/main/java/
   creating: spring-pet-clinic-eks/src/main/java/org/
   creating: spring-pet-clinic-eks/src/main/java/org/springframework/
   creating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/
   creating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/
   creating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/vet/
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/vet/VetController.java 
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/vet/Vet.java 
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/vet/Specialty.java 
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/vet/Vets.java 
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/vet/VetRepository.java 
   creating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/model/
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/model/package-info.java 
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/model/NamedEntity.java 
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/model/Person.java 
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/model/BaseEntity.java 
   creating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/owner/
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/owner/OwnerController.java 
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/owner/Owner.java 
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/owner/OwnerRepository.java 
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/owner/PetType.java 
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/owner/PetValidator.java 
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/owner/PetRepository.java 
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/owner/Pet.java 
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/owner/VisitController.java 
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/owner/PetTypeFormatter.java 
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/owner/PetController.java 
   creating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/system/
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/system/WelcomeController.java 
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/system/CrashController.java 
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/system/CacheConfiguration.java 
   creating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/visit/
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/visit/VisitRepository.java 
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/visit/Visit.java 
  inflating: spring-pet-clinic-eks/src/main/java/org/springframework/samples/petclinic/PetClinicApplication.java 
   creating: spring-pet-clinic-eks/src/main/resources/
   creating: spring-pet-clinic-eks/src/main/resources/templates/
   creating: spring-pet-clinic-eks/src/main/resources/templates/owners/
  inflating: spring-pet-clinic-eks/src/main/resources/templates/owners/ownerDetails.html 
  inflating: spring-pet-clinic-eks/src/main/resources/templates/owners/createOrUpdateOwnerForm.html 
  inflating: spring-pet-clinic-eks/src/main/resources/templates/owners/ownersList.html 
  inflating: spring-pet-clinic-eks/src/main/resources/templates/owners/findOwners.html 
   creating: spring-pet-clinic-eks/src/main/resources/templates/fragments/
  inflating: spring-pet-clinic-eks/src/main/resources/templates/fragments/inputField.html 
  inflating: spring-pet-clinic-eks/src/main/resources/templates/fragments/selectField.html 
  inflating: spring-pet-clinic-eks/src/main/resources/templates/fragments/layout.html 
   creating: spring-pet-clinic-eks/src/main/resources/templates/vets/
  inflating: spring-pet-clinic-eks/src/main/resources/templates/vets/vetList.html 
  inflating: spring-pet-clinic-eks/src/main/resources/templates/error.html 
   creating: spring-pet-clinic-eks/src/main/resources/templates/pets/
  inflating: spring-pet-clinic-eks/src/main/resources/templates/pets/createOrUpdateVisitForm.html 
  inflating: spring-pet-clinic-eks/src/main/resources/templates/pets/createOrUpdatePetForm.html 
  inflating: spring-pet-clinic-eks/src/main/resources/templates/welcome.html 
   creating: spring-pet-clinic-eks/src/main/resources/static/
   creating: spring-pet-clinic-eks/src/main/resources/static/resources/
   creating: spring-pet-clinic-eks/src/main/resources/static/resources/images/
  inflating: spring-pet-clinic-eks/src/main/resources/static/resources/images/pets.png 
  inflating: spring-pet-clinic-eks/src/main/resources/static/resources/images/spring-pivotal-logo.png 
  inflating: spring-pet-clinic-eks/src/main/resources/static/resources/images/spring-logo-dataflow.png 
  inflating: spring-pet-clinic-eks/src/main/resources/static/resources/images/favicon.png 
  inflating: spring-pet-clinic-eks/src/main/resources/static/resources/images/platform-bg.png 
  inflating: spring-pet-clinic-eks/src/main/resources/static/resources/images/spring-logo-dataflow-mobile.png 
   creating: spring-pet-clinic-eks/src/main/resources/static/resources/fonts/
  inflating: spring-pet-clinic-eks/src/main/resources/static/resources/fonts/varela_round-webfont.ttf 
  inflating: spring-pet-clinic-eks/src/main/resources/static/resources/fonts/varela_round-webfont.eot 
  inflating: spring-pet-clinic-eks/src/main/resources/static/resources/fonts/montserrat-webfont.ttf 
  inflating: spring-pet-clinic-eks/src/main/resources/static/resources/fonts/varela_round-webfont.woff 
  inflating: spring-pet-clinic-eks/src/main/resources/static/resources/fonts/varela_round-webfont.svg 
  inflating: spring-pet-clinic-eks/src/main/resources/static/resources/fonts/montserrat-webfont.eot 
  inflating: spring-pet-clinic-eks/src/main/resources/static/resources/fonts/montserrat-webfont.svg 
  inflating: spring-pet-clinic-eks/src/main/resources/static/resources/fonts/montserrat-webfont.woff 
   creating: spring-pet-clinic-eks/src/main/resources/messages/
  inflating: spring-pet-clinic-eks/src/main/resources/messages/messages_de.properties 
  inflating: spring-pet-clinic-eks/src/main/resources/messages/messages_en.properties 
  inflating: spring-pet-clinic-eks/src/main/resources/messages/messages_es.properties 
  inflating: spring-pet-clinic-eks/src/main/resources/messages/messages.properties 
   creating: spring-pet-clinic-eks/src/main/resources/db/
   creating: spring-pet-clinic-eks/src/main/resources/db/h2/
  inflating: spring-pet-clinic-eks/src/main/resources/db/h2/schema.sql 
  inflating: spring-pet-clinic-eks/src/main/resources/db/h2/data.sql 
   creating: spring-pet-clinic-eks/src/main/resources/db/hsqldb/
  inflating: spring-pet-clinic-eks/src/main/resources/db/hsqldb/schema.sql 
  inflating: spring-pet-clinic-eks/src/main/resources/db/hsqldb/data.sql 
   creating: spring-pet-clinic-eks/src/main/resources/db/mysql/
  inflating: spring-pet-clinic-eks/src/main/resources/db/mysql/data.sql 
  inflating: spring-pet-clinic-eks/src/main/resources/db/mysql/user.sql 
  inflating: spring-pet-clinic-eks/src/main/resources/db/mysql/petclinic_db_setup_mysql.txt 
  inflating: spring-pet-clinic-eks/src/main/resources/db/mysql/schema.sql 
  inflating: spring-pet-clinic-eks/src/main/resources/application.properties 
  inflating: spring-pet-clinic-eks/src/main/resources/banner.txt 
  inflating: spring-pet-clinic-eks/src/main/resources/application-mysql.properties 
   creating: spring-pet-clinic-eks/src/main/wro/
  inflating: spring-pet-clinic-eks/src/main/wro/wro.properties 
  inflating: spring-pet-clinic-eks/src/main/wro/wro.xml 
   creating: spring-pet-clinic-eks/src/main/less/
  inflating: spring-pet-clinic-eks/src/main/less/typography.less 
  inflating: spring-pet-clinic-eks/src/main/less/responsive.less 
  inflating: spring-pet-clinic-eks/src/main/less/petclinic.less 
  inflating: spring-pet-clinic-eks/src/main/less/header.less 
   creating: spring-pet-clinic-eks/src/test/
   creating: spring-pet-clinic-eks/src/test/java/
   creating: spring-pet-clinic-eks/src/test/java/org/
   creating: spring-pet-clinic-eks/src/test/java/org/springframework/
   creating: spring-pet-clinic-eks/src/test/java/org/springframework/samples/
   creating: spring-pet-clinic-eks/src/test/java/org/springframework/samples/petclinic/
   creating: spring-pet-clinic-eks/src/test/java/org/springframework/samples/petclinic/owner/
  inflating: spring-pet-clinic-eks/src/test/java/org/springframework/samples/petclinic/owner/PetTypeFormatterTests.java 
  inflating: spring-pet-clinic-eks/src/test/java/org/springframework/samples/petclinic/owner/VisitControllerTests.java 
  inflating: spring-pet-clinic-eks/src/test/java/org/springframework/samples/petclinic/owner/OwnerControllerTests.java 
  inflating: spring-pet-clinic-eks/src/test/java/org/springframework/samples/petclinic/owner/PetControllerTests.java 
   creating: spring-pet-clinic-eks/src/test/java/org/springframework/samples/petclinic/service/
  inflating: spring-pet-clinic-eks/src/test/java/org/springframework/samples/petclinic/service/ClinicServiceTests.java 
  inflating: spring-pet-clinic-eks/src/test/java/org/springframework/samples/petclinic/service/EntityUtils.java 
   creating: spring-pet-clinic-eks/src/test/java/org/springframework/samples/petclinic/vet/
  inflating: spring-pet-clinic-eks/src/test/java/org/springframework/samples/petclinic/vet/VetTests.java 
  inflating: spring-pet-clinic-eks/src/test/java/org/springframework/samples/petclinic/vet/VetControllerTests.java 
   creating: spring-pet-clinic-eks/src/test/java/org/springframework/samples/petclinic/model/
  inflating: spring-pet-clinic-eks/src/test/java/org/springframework/samples/petclinic/model/ValidatorTests.java 
   creating: spring-pet-clinic-eks/src/test/java/org/springframework/samples/petclinic/system/
  inflating: spring-pet-clinic-eks/src/test/java/org/springframework/samples/petclinic/system/CrashControllerTests.java 
  inflating: spring-pet-clinic-eks/src/test/java/org/springframework/samples/petclinic/PetclinicIntegrationTests.java 
   creating: spring-pet-clinic-eks/src/test/jmeter/
  inflating: spring-pet-clinic-eks/src/test/jmeter/petclinic_test_plan.jmx 
   creating: spring-pet-clinic-eks/src/checkstyle/
  inflating: spring-pet-clinic-eks/src/checkstyle/nohttp-checkstyle-suppressions.xml 
  inflating: spring-pet-clinic-eks/src/checkstyle/nohttp-checkstyle.xml 
  inflating: spring-pet-clinic-eks/mvnw.cmd 
   creating: spring-pet-clinic-eks/.mvn/
   creating: spring-pet-clinic-eks/.mvn/wrapper/
  inflating: spring-pet-clinic-eks/.mvn/wrapper/maven-wrapper.properties 
  inflating: spring-pet-clinic-eks/.mvn/wrapper/MavenWrapperDownloader.java 
  inflating: spring-pet-clinic-eks/.mvn/wrapper/maven-wrapper.jar 
  inflating: spring-pet-clinic-eks/docker-compose.yml 
  inflating: spring-pet-clinic-eks/pom.xml 
  inflating: spring-pet-clinic-eks/.travis.yml 
  inflating: spring-pet-clinic-eks/tes1 
   creating: spring-pet-clinic-eks/.tanzu/
  inflating: spring-pet-clinic-eks/.tanzu/tanzu_develop.py 
  inflating: spring-pet-clinic-eks/readme.md 
  inflating: spring-pet-clinic-eks/.editorconfig 
replace spring-pet-clinic-eks/README.md? [y]es, [n]o, [A]ll, [N]one, [r]ename: y
  inflating: spring-pet-clinic-eks/README.md 
   creating: spring-pet-clinic-eks/.vscode/
  inflating: spring-pet-clinic-eks/.vscode/launch.json 
  inflating: spring-pet-clinic-eks/.gitignore 
   creating: spring-pet-clinic-eks/config/
  inflating: spring-pet-clinic-eks/config/workload.yaml 
  inflating: spring-pet-clinic-eks/Tiltfile 
  inflating: spring-pet-clinic-eks/accelerator-log.md 
vdesikan@vdesikan-a01 Downloads % cd spring-pet-clinic-eks
vdesikan@vdesikan-a01 spring-pet-clinic-eks % ls
README.md       Tiltfile        accelerator-log.md  config          docker-compose.yml  mvnw            mvnw.cmd        pom.xml         src         tes1
vdesikan@vdesikan-a01 spring-pet-clinic-eks % git init -b main
Initialized empty Git repository in /Users/vdesikan/Downloads/spring-pet-clinic-eks/.git/
vdesikan@vdesikan-a01 spring-pet-clinic-eks % git add .
vdesikan@vdesikan-a01 spring-pet-clinic-eks % git commit -m "First commit"
[main (root-commit) a3592d4] First commit
 103 files changed, 14853 insertions(+)
 create mode 100644 .editorconfig
 create mode 100644 .gitignore
 create mode 100644 .mvn/wrapper/MavenWrapperDownloader.java
 create mode 100755 .mvn/wrapper/maven-wrapper.jar
 create mode 100755 .mvn/wrapper/maven-wrapper.properties
 create mode 100644 .tanzu/tanzu_develop.py
 create mode 100644 .travis.yml
 create mode 100644 .vscode/launch.json
 create mode 100644 README.md
 create mode 100644 Tiltfile
 create mode 100644 accelerator-log.md
 create mode 100644 config/workload.yaml
 create mode 100644 docker-compose.yml
 create mode 100755 mvnw
 create mode 100644 mvnw.cmd
 create mode 100644 pom.xml
 create mode 100644 src/checkstyle/nohttp-checkstyle-suppressions.xml
 create mode 100644 src/checkstyle/nohttp-checkstyle.xml
 create mode 100644 src/main/java/org/springframework/samples/petclinic/PetClinicApplication.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/model/BaseEntity.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/model/NamedEntity.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/model/Person.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/model/package-info.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/owner/Owner.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/owner/OwnerController.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/owner/OwnerRepository.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/owner/Pet.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/owner/PetController.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/owner/PetRepository.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/owner/PetType.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/owner/PetTypeFormatter.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/owner/PetValidator.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/owner/VisitController.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/system/CacheConfiguration.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/system/CrashController.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/system/WelcomeController.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/vet/Specialty.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/vet/Vet.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/vet/VetController.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/vet/VetRepository.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/vet/Vets.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/visit/Visit.java
 create mode 100644 src/main/java/org/springframework/samples/petclinic/visit/VisitRepository.java
 create mode 100644 src/main/less/header.less
 create mode 100644 src/main/less/petclinic.less
 create mode 100644 src/main/less/responsive.less
 create mode 100644 src/main/less/typography.less
 create mode 100644 src/main/resources/application-mysql.properties
 create mode 100644 src/main/resources/application.properties
 create mode 100644 src/main/resources/banner.txt
 create mode 100644 src/main/resources/db/h2/data.sql
 create mode 100644 src/main/resources/db/h2/schema.sql
 create mode 100644 src/main/resources/db/hsqldb/data.sql
 create mode 100644 src/main/resources/db/hsqldb/schema.sql
 create mode 100644 src/main/resources/db/mysql/data.sql
 create mode 100644 src/main/resources/db/mysql/petclinic_db_setup_mysql.txt
 create mode 100644 src/main/resources/db/mysql/schema.sql
 create mode 100644 src/main/resources/db/mysql/user.sql
 create mode 100644 src/main/resources/messages/messages.properties
 create mode 100644 src/main/resources/messages/messages_de.properties
 create mode 100644 src/main/resources/messages/messages_en.properties
 create mode 100644 src/main/resources/messages/messages_es.properties
 create mode 100644 src/main/resources/static/resources/fonts/montserrat-webfont.eot
 create mode 100644 src/main/resources/static/resources/fonts/montserrat-webfont.svg
 create mode 100644 src/main/resources/static/resources/fonts/montserrat-webfont.ttf
 create mode 100644 src/main/resources/static/resources/fonts/montserrat-webfont.woff
 create mode 100644 src/main/resources/static/resources/fonts/varela_round-webfont.eot
 create mode 100644 src/main/resources/static/resources/fonts/varela_round-webfont.svg
 create mode 100644 src/main/resources/static/resources/fonts/varela_round-webfont.ttf
 create mode 100644 src/main/resources/static/resources/fonts/varela_round-webfont.woff
 create mode 100644 src/main/resources/static/resources/images/favicon.png
 create mode 100644 src/main/resources/static/resources/images/pets.png
 create mode 100644 src/main/resources/static/resources/images/platform-bg.png
 create mode 100644 src/main/resources/static/resources/images/spring-logo-dataflow-mobile.png
 create mode 100644 src/main/resources/static/resources/images/spring-logo-dataflow.png
 create mode 100644 src/main/resources/static/resources/images/spring-pivotal-logo.png
 create mode 100644 src/main/resources/templates/error.html
 create mode 100644 src/main/resources/templates/fragments/inputField.html
 create mode 100644 src/main/resources/templates/fragments/layout.html
 create mode 100644 src/main/resources/templates/fragments/selectField.html
 create mode 100644 src/main/resources/templates/owners/createOrUpdateOwnerForm.html
 create mode 100644 src/main/resources/templates/owners/findOwners.html
 create mode 100644 src/main/resources/templates/owners/ownerDetails.html
 create mode 100644 src/main/resources/templates/owners/ownersList.html
 create mode 100644 src/main/resources/templates/pets/createOrUpdatePetForm.html
 create mode 100644 src/main/resources/templates/pets/createOrUpdateVisitForm.html
 create mode 100644 src/main/resources/templates/vets/vetList.html
 create mode 100644 src/main/resources/templates/welcome.html
 create mode 100644 src/main/wro/wro.properties
 create mode 100644 src/main/wro/wro.xml
 create mode 100644 src/test/java/org/springframework/samples/petclinic/PetclinicIntegrationTests.java
 create mode 100644 src/test/java/org/springframework/samples/petclinic/model/ValidatorTests.java
 create mode 100644 src/test/java/org/springframework/samples/petclinic/owner/OwnerControllerTests.java
 create mode 100644 src/test/java/org/springframework/samples/petclinic/owner/PetControllerTests.java
 create mode 100644 src/test/java/org/springframework/samples/petclinic/owner/PetTypeFormatterTests.java
 create mode 100644 src/test/java/org/springframework/samples/petclinic/owner/VisitControllerTests.java
 create mode 100644 src/test/java/org/springframework/samples/petclinic/service/ClinicServiceTests.java
 create mode 100644 src/test/java/org/springframework/samples/petclinic/service/EntityUtils.java
 create mode 100644 src/test/java/org/springframework/samples/petclinic/system/CrashControllerTests.java
 create mode 100644 src/test/java/org/springframework/samples/petclinic/vet/VetControllerTests.java
 create mode 100644 src/test/java/org/springframework/samples/petclinic/vet/VetTests.java
 create mode 100644 src/test/jmeter/petclinic_test_plan.jmx
 create mode 100644 tes1
vdesikan@vdesikan-a01 spring-pet-clinic-eks % git remote add origin https://github.com/vdesikanvmware/spring-pet-clinic-eks.git
vdesikan@vdesikan-a01 spring-pet-clinic-eks % git branch -M main
vdesikan@vdesikan-a01 spring-pet-clinic-eks % git remote set-url origin ssh://git@github.com/vdesikanvmware/spring-pet-clinic-eks.git
vdesikan@vdesikan-a01 spring-pet-clinic-eks % git push -u origin main                                                               
Warning: Permanently added the RSA host key for IP address '13.234.210.38' to the list of known hosts.
Enumerating objects: 149, done.
Counting objects: 100% (149/149), done.
Delta compression using up to 12 threads
Compressing objects: 100% (133/133), done.
Writing objects: 100% (149/149), 404.15 KiB | 1.99 MiB/s, done.
Total 149 (delta 24), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (24/24), done.
To ssh://github.com/vdesikanvmware/spring-pet-clinic-eks.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```
3. Using TBS create an image for the application from the new git repo added using App Accelerator Template.
  1. Create TAP service account , secret for TBS. Also patch the secret to the service account's Image Pull secret.
```
vdesikan@vdesikan-a01 tap-install % more tap-sa.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tap-service-account
  namespace: tap-install
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: cluster-admin-cluster-role
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["*"]
---
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: cluster-admin-cluster-role-binding
subjects:
- kind: ServiceAccount
  name: tap-service-account
  namespace: tap-install
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin-cluster-role
vdesikan@vdesikan-a01 tap-install % kubectl apply -f tap-sa.yaml
serviceaccount/tap-service-account created
clusterrole.rbac.authorization.k8s.io/cluster-admin-cluster-role unchanged
clusterrolebinding.rbac.authorization.k8s.io/cluster-admin-cluster-role-binding configured
vdesikan@vdesikan-a01 tap-install % kubectl create secret docker-registry tbs-secret -n tap-install --docker-server='dev.registry.pivotal.io' --docker-username=$USRFULL --docker-password=$PASS
secret/tbs-secret created
vdesikan@vdesikan-a01 tap-install % kubectl patch serviceaccount default -p "{\"imagePullSecrets\": [{\"name\": \"tbs-secret\"}]}" -n tap-install
serviceaccount/default patched
```
  2. Using TBS create an image for the git-repo created using App-Accelerator. Make sure you specify a container registry where this image can be pushed.
```
vdesikan@vdesikan-a01 tap-install % more image.yaml
apiVersion: kpack.io/v1alpha1
kind: Image
metadata:
  name: spring-petclinic-image
spec:
  tag: dev.registry.pivotal.io/tanzu-advanced-edition/vdesikan/spring-petclinic-eks
  serviceAccount: tap-service-account
  builder:
    kind: ClusterBuilder
    name: default
  source:
    git:
      url: https://github.com/vdesikanvmware/spring-pet-clinic-eks
      revision: main
vdesikan@vdesikan-a01 tap-install % kubectl apply -f image.yaml -n tap-install  
image.kpack.io/spring-petclinic-image created
vdesikan@vdesikan-a01 tap-install % kp image list
Error: no images found
vdesikan@vdesikan-a01 tap-install % kp image list -n tap-install
NAME                      READY      LATEST REASON    LATEST IMAGE    NAMESPACE
spring-petclinic-image    Unknown    CONFIG                           tap-install
 
 
vdesikan@vdesikan-a01 tap-install % kp build list -n tap-install
BUILD    STATUS      IMAGE    REASON
1        BUILDING             CONFIG
 
 
vdesikan@vdesikan-a01 tap-install % kp image list -n tap-install
NAME                      READY      LATEST REASON    LATEST IMAGE    NAMESPACE
spring-petclinic-image    Unknown    CONFIG                           tap-install
 
 
vdesikan@vdesikan-a01 tap-install % kp build list -n tap-install
BUILD    STATUS      IMAGE    REASON
1        BUILDING             CONFIG
 
 
vdesikan@vdesikan-a01 tap-install % kp build status spring-petclinic-image -n tap-install
Image:            --
Status:           BUILDING
Reason:           CONFIG
                  resources: {}
                  - source: {}
                  + source:
                  +   git:
                  +     revision: a3592d4d1a47ae3e6f6e0143d0369a9476da7620
                  +     url: https://github.com/vdesikanvmware/spring-pet-clinic-eks
Status Reason:    PodInitializing
 
 
Started:     2021-08-24 10:09:27
Finished:    --
 
 
Pod Name:    spring-petclinic-image-build-1-vl7j5-build-pod
 
 
Builder:      dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs/default@sha256:c3acd9780a055d9657f702426460d2fbd0b9dcdac3facbaec894646a580d6f6d
Run Image:    --
 
 
Source:      GitUrl
Url:         https://github.com/vdesikanvmware/spring-pet-clinic-eks
Revision:    a3592d4d1a47ae3e6f6e0143d0369a9476da7620
 
 
BUILDPACK ID    BUILDPACK VERSION    HOMEPAGE
 
 
vdesikan@vdesikan-a01 tap-install % kp image list -n tap-install                        
NAME                      READY      LATEST REASON    LATEST IMAGE    NAMESPACE
spring-petclinic-image    Unknown    CONFIG                           tap-install
 
 
vdesikan@vdesikan-a01 tap-install % kp build list -n tap-install                        
BUILD    STATUS      IMAGE    REASON
1        BUILDING             CONFIG
 
 
vdesikan@vdesikan-a01 tap-install % kp image list -n tap-install
NAME                      READY    LATEST REASON    LATEST IMAGE                                                                                                                                            NAMESPACE
spring-petclinic-image    True     CONFIG           dev.registry.pivotal.io/tanzu-advanced-edition/vdesikan/spring-petclinic-eks@sha256:be889cf313016eb4fc168556493c2b1672c8e2af725e33696bf461b8212f9872    tap-install
 
 
vdesikan@vdesikan-a01 tap-install % kp build list -n tap-install
BUILD    STATUS     IMAGE                                                                                                                                                   REASON
1        SUCCESS    dev.registry.pivotal.io/tanzu-advanced-edition/vdesikan/spring-petclinic-eks@sha256:be889cf313016eb4fc168556493c2b1672c8e2af725e33696bf461b8212f9872    CONFIG
 
 
vdesikan@vdesikan-a01 tap-install % kp build status spring-petclinic-image -n tap-install
Image:     dev.registry.pivotal.io/tanzu-advanced-edition/vdesikan/spring-petclinic-eks@sha256:be889cf313016eb4fc168556493c2b1672c8e2af725e33696bf461b8212f9872
Status:    SUCCESS
Reason:    CONFIG
           resources: {}
           - source: {}
           + source:
           +   git:
           +     revision: a3592d4d1a47ae3e6f6e0143d0369a9476da7620
           +     url: https://github.com/vdesikanvmware/spring-pet-clinic-eks
 
 
Started:     2021-08-24 10:09:27
Finished:    2021-08-24 10:10:58
 
 
Pod Name:    spring-petclinic-image-build-1-vl7j5-build-pod
 
 
Builder:      dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs/default@sha256:c3acd9780a055d9657f702426460d2fbd0b9dcdac3facbaec894646a580d6f6d
Run Image:    dev.registry.pivotal.io/tanzu-advanced-edition/beta1/tbs/run@sha256:ae65c51e7fb215fa3ed3ffddf9e438a3f9c571e591db71dec7d903ce5bc9bf92
 
 
Source:      GitUrl
Url:         https://github.com/vdesikanvmware/spring-pet-clinic-eks
Revision:    a3592d4d1a47ae3e6f6e0143d0369a9476da7620
 
 
BUILDPACK ID                           BUILDPACK VERSION    HOMEPAGE
paketo-buildpacks/ca-certificates      2.3.2                https://github.com/paketo-buildpacks/ca-certificates
paketo-buildpacks/bellsoft-liberica    8.2.0                https://github.com/paketo-buildpacks/bellsoft-liberica
paketo-buildpacks/maven                5.3.3                https://github.com/paketo-buildpacks/maven
paketo-buildpacks/executable-jar       5.1.2                https://github.com/paketo-buildpacks/executable-jar
paketo-buildpacks/apache-tomcat        6.0.0                https://github.com/paketo-buildpacks/apache-tomcat
paketo-buildpacks/dist-zip             4.1.2                https://github.com/paketo-buildpacks/dist-zip
paketo-buildpacks/spring-boot          4.4.2                https://github.com/paketo-buildpacks/spring-boot
```
4. Use the image generated and deploy it as a service using CNR in the name-space where App Live View is running with the labels (tanzu.app.live.view=true, tanzu.app.live.view.application.name=<app_name>). Make sure you add appropriate DNS entries (in this case using /etc/hosts).
```
vdesikan@vdesikan-a01 tap-install % more kapp-deploy-spring-petclinic.yaml
    apiVersion: kappctrl.k14s.io/v1alpha1
    kind: App
    metadata:
      name: spring-petclinic
    spec:
      serviceAccountName: tap-service-account
      fetch:
        - inline:
            paths:
              manifest.yml: |
                ---
                apiVersion: kapp.k14s.io/v1alpha1
                kind: Config
                rebaseRules:
                  - path: [metadata, annotations, serving.knative.dev/creator]
                    type: copy
                    sources: [new, existing]
                    resourceMatchers: &matchers
                      - apiVersionKindMatcher: {apiVersion: serving.knative.dev/v1, kind: Service}
                  - path: [metadata, annotations, serving.knative.dev/lastModifier]
                    type: copy
                    sources: [new, existing]
                    resourceMatchers: *matchers
                ---
                apiVersion: serving.knative.dev/v1
                kind: Service
                metadata:
                  name: petclinic
                spec:
                  template:
                    metadata:
                      annotations:
                        client.knative.dev/user-image: ""
                      labels:
                        tanzu.app.live.view: "true"
                        tanzu.app.live.view.application.name: "spring-petclinic"
                    spec:
                      containers:
                      - image: dev.registry.pivotal.io/tanzu-advanced-edition/vdesikan/spring-petclinic-eks@sha256:be889cf313016eb4fc168556493c2b1672c8e2af725e33696bf461b8212f9872
                        securityContext:
                          runAsUser: 1000
      template:
        - ytt: {}
      deploy:
        - kapp: {}
vdesikan@vdesikan-a01 tap-install % kubectl apply -f kapp-deploy-spring-petclinic.yaml -n tap-install
app.kappctrl.k14s.io/spring-petclinic created
vdesikan@vdesikan-a01 tap-install % kubectl get pods -n tap-install
NAME                                                    READY   STATUS              RESTARTS   AGE
application-live-view-connector-57cd7c6c6-pv8dk         1/1     Running             0          17h
application-live-view-crd-controller-5b659f8f57-7zz25   1/1     Running             0          17h
application-live-view-server-79bd874566-qtcbc           1/1     Running             0          17h
petclinic-00001-deployment-5f7b86665f-lqhfs             0/2     ContainerCreating   0          10s
spring-petclinic-image-build-1-vl7j5-build-pod          0/1     Completed           0          7m56s
vdesikan@vdesikan-a01 tap-install % kubectl get pods -n tap-install
NAME                                                    READY   STATUS      RESTARTS   AGE
application-live-view-connector-57cd7c6c6-pv8dk         1/1     Running     0          17h
application-live-view-crd-controller-5b659f8f57-7zz25   1/1     Running     0          17h
application-live-view-server-79bd874566-qtcbc           1/1     Running     0          17h
petclinic-00001-deployment-5f7b86665f-lqhfs             2/2     Running     0          23s
spring-petclinic-image-build-1-vl7j5-build-pod          0/1     Completed   0          8m9s
vdesikan@vdesikan-a01 tap-install % kubectl get service -n tap-install
NAME                         TYPE           CLUSTER-IP       EXTERNAL-IP                                                               PORT(S)                                      AGE
application-live-view-5112   LoadBalancer   10.100.176.238   ac229c2c3af2f48be896688d5f176c16-1335129677.us-east-2.elb.amazonaws.com   5112:32387/TCP                               17h
application-live-view-7000   ClusterIP      10.100.29.252    <none>                                                                    7000/TCP                                     17h
petclinic                    ExternalName   <none>           envoy.contour-internal.svc.cluster.local                                  80/TCP                                       19s
petclinic-00001              ClusterIP      10.100.254.12    <none>                                                                    80/TCP                                       37s
petclinic-00001-private      ClusterIP      10.100.219.255   <none>                                                                    80/TCP,9090/TCP,9091/TCP,8022/TCP,8012/TCP   37s
vdesikan@vdesikan-a01 tap-install % kubectl get service -A           
NAMESPACE                NAME                                 TYPE           CLUSTER-IP       EXTERNAL-IP                                                               PORT(S)                                      AGE
accelerator-system       acc-engine                           ClusterIP      10.100.253.164   <none>                                                                    80/TCP                                       17h
accelerator-system       acc-ui-server                        LoadBalancer   10.100.74.90     a3b48dd9f15f746a48b503aee558bd96-309532596.us-east-2.elb.amazonaws.com    80:31689/TCP                                 17h
build-service            cert-injection-webhook               ClusterIP      10.100.98.116    <none>                                                                    443/TCP                                      16h
contour-external         contour                              ClusterIP      10.100.10.20     <none>                                                                    8001/TCP                                     17h
contour-external         envoy                                LoadBalancer   10.100.29.235    afc0cc5526ef74617a20f89f27433b6f-609822777.us-east-2.elb.amazonaws.com    80:31346/TCP,443:32120/TCP                   17h
contour-internal         contour                              ClusterIP      10.100.247.212   <none>                                                                    8001/TCP                                     17h
contour-internal         envoy                                ClusterIP      10.100.3.195     <none>                                                                    80/TCP,443/TCP                               17h
default                  kubernetes                           ClusterIP      10.100.0.1       <none>                                                                    443/TCP                                      4d18h
flux-system              notification-controller              ClusterIP      10.100.153.120   <none>                                                                    80/TCP                                       17h
flux-system              source-controller                    ClusterIP      10.100.214.3     <none>                                                                    80/TCP                                       17h
flux-system              webhook-receiver                     ClusterIP      10.100.54.115    <none>                                                                    80/TCP                                       17h
kapp-controller          packaging-api                        ClusterIP      10.100.66.222    <none>                                                                    443/TCP                                      17h
knative-discovery        webhook                              ClusterIP      10.100.204.141   <none>                                                                    9090/TCP,8008/TCP,443/TCP                    17h
knative-eventing         broker-filter                        ClusterIP      10.100.200.214   <none>                                                                    80/TCP,9092/TCP                              17h
knative-eventing         broker-ingress                       ClusterIP      10.100.50.73     <none>                                                                    80/TCP,9092/TCP                              17h
knative-eventing         eventing-webhook                     ClusterIP      10.100.188.40    <none>                                                                    443/TCP                                      17h
knative-eventing         imc-dispatcher                       ClusterIP      10.100.54.100    <none>                                                                    80/TCP                                       17h
knative-eventing         inmemorychannel-webhook              ClusterIP      10.100.72.121    <none>                                                                    443/TCP                                      17h
knative-serving          activator-service                    ClusterIP      10.100.114.196   <none>                                                                    9090/TCP,8008/TCP,80/TCP,81/TCP              17h
knative-serving          autoscaler                           ClusterIP      10.100.2.22      <none>                                                                    9090/TCP,8008/TCP,8080/TCP                   17h
knative-serving          autoscaler-bucket-00-of-01           ClusterIP      10.100.3.124     <none>                                                                    8080/TCP                                     17h
knative-serving          controller                           ClusterIP      10.100.40.142    <none>                                                                    9090/TCP,8008/TCP                            17h
knative-serving          net-certmanager-webhook              ClusterIP      10.100.168.189   <none>                                                                    9090/TCP,8008/TCP,443/TCP                    17h
knative-serving          networking-certmanager               ClusterIP      10.100.168.29    <none>                                                                    9090/TCP,8008/TCP                            17h
knative-serving          webhook                              ClusterIP      10.100.228.52    <none>                                                                    9090/TCP,8008/TCP,443/TCP                    17h
knative-sources          rabbitmq-controller                  ClusterIP      10.100.150.219   <none>                                                                    443/TCP                                      17h
knative-sources          rabbitmq-webhook                     ClusterIP      10.100.86.29     <none>                                                                    443/TCP                                      17h
kpack                    kpack-webhook                        ClusterIP      10.100.67.127    <none>                                                                    443/TCP                                      16h
kube-system              kube-dns                             ClusterIP      10.100.0.10      <none>                                                                    53/UDP,53/TCP                                4d18h
stacks-operator-system   controller-manager-metrics-service   ClusterIP      10.100.118.226   <none>                                                                    8443/TCP                                     16h
tap-install              application-live-view-5112           LoadBalancer   10.100.176.238   ac229c2c3af2f48be896688d5f176c16-1335129677.us-east-2.elb.amazonaws.com   5112:32387/TCP                               17h
tap-install              application-live-view-7000           ClusterIP      10.100.29.252    <none>                                                                    7000/TCP                                     17h
tap-install              petclinic                            ExternalName   <none>           envoy.contour-internal.svc.cluster.local                                  80/TCP                                       35s
tap-install              petclinic-00001                      ClusterIP      10.100.254.12    <none>                                                                    80/TCP                                       53s
tap-install              petclinic-00001-private              ClusterIP      10.100.219.255   <none>                                                                    80/TCP,9090/TCP,9091/TCP,8022/TCP,8012/TCP   53s
vmware-sources           webhook                              ClusterIP      10.100.192.82    <none>                                                                    443/TCP                                      17h
vdesikan@vdesikan-a01 tap-install % kubectl get ksvc -n tap-install
NAME        URL                                        LATESTCREATED     LATESTREADY       READY   REASON
petclinic   http://petclinic.tap-install.example.com   petclinic-00001   petclinic-00001   True   
vdesikan@vdesikan-a01 tap-install % ping afc0cc5526ef74617a20f89f27433b6f-609822777.us-east-2.elb.amazonaws.com 
PING afc0cc5526ef74617a20f89f27433b6f-609822777.us-east-2.elb.amazonaws.com (3.19.166.204): 56 data bytes
Request timeout for icmp_seq 0
Request timeout for icmp_seq 1
^C
--- afc0cc5526ef74617a20f89f27433b6f-609822777.us-east-2.elb.amazonaws.com ping statistics ---
3 packets transmitted, 0 packets received, 100.0% packet loss
vdesikan@vdesikan-a01 tap-install % sudo vi /etc/hosts                                                        
vdesikan@vdesikan-a01 tap-install % more /etc/hosts
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1       localhost
255.255.255.255 broadcasthost
::1             localhost
# Added by Docker Desktop
# To allow the same kube context to work on the host and the container:
127.0.0.1 kubernetes.docker.internal
3.19.166.204 petclinic.tap-install.example.com
# End of section
vdesikan@vdesikan-a01 tap-install %
```
5. Check that the spring pet clinic app can be accessed. Check that the App Live View is also displaying the stats for this app.
6. Make some code changes in the git repo and commit the change. Check that new build is created automatically and new image is generated.
```
vdesikan@vdesikan-a01 spring-pet-clinic-eks % ls
README.md       Tiltfile        accelerator-log.md  config          docker-compose.yml  mvnw            mvnw.cmd        pom.xml         src         tes1
vdesikan@vdesikan-a01 spring-pet-clinic-eks % cd src
vdesikan@vdesikan-a01 src % ls
checkstyle  main        test
vdesikan@vdesikan-a01 src % cd main
vdesikan@vdesikan-a01 main % ls
java        less        resources   wro
vdesikan@vdesikan-a01 main % cd resources
vdesikan@vdesikan-a01 resources % ls
application-mysql.properties    application.properties      banner.txt          db              messages            static              templates
vdesikan@vdesikan-a01 resources % cd templates
vdesikan@vdesikan-a01 templates % ls
error.html  fragments   owners      pets        vets        welcome.html
vdesikan@vdesikan-a01 templates % cd vets
vdesikan@vdesikan-a01 vets % ls
vetList.html
vdesikan@vdesikan-a01 vets % vi vetList.html
vdesikan@vdesikan-a01 vets % more vetList.html
<!DOCTYPE html>
 
 
<html xmlns:th="https://www.thymeleaf.org"
  th:replace="~{fragments/layout :: layout (~{::body},'vets')}">
 
 
<body>
 
 
  <h2>Veterinarians at VMware</h2>
 
 
  <table id="vets" class="table table-striped">
    <thead>
      <tr>
        <th>Name</th>
        <th>Specialties</th>
      </tr>
    </thead>
    <tbody>
      <tr th:each="vet : ${vets.vetList}">
        <td th:text="${vet.firstName + ' ' + vet.lastName}"></td>
        <td><span th:each="specialty : ${vet.specialties}"
          th:text="${specialty.name + ' '}" /> <span
          th:if="${vet.nrOfSpecialties == 0}">none</span></td>
      </tr>
    </tbody>
  </table>
</body>
</html>
vdesikan@vdesikan-a01 vets % vi vetList.html
vdesikan@vdesikan-a01 vets % more vetList.html
<!DOCTYPE html>
 
 
<html xmlns:th="https://www.thymeleaf.org"
  th:replace="~{fragments/layout :: layout (~{::body},'vets')}">
 
 
<body>
 
 
  <h2>Veterinarians at VMware - Updated by MAPBU DAP Delivery Team</h2>
 
 
  <table id="vets" class="table table-striped">
    <thead>
      <tr>
        <th>Name</th>
        <th>Specialties</th>
      </tr>
    </thead>
    <tbody>
      <tr th:each="vet : ${vets.vetList}">
        <td th:text="${vet.firstName + ' ' + vet.lastName}"></td>
        <td><span th:each="specialty : ${vet.specialties}"
          th:text="${specialty.name + ' '}" /> <span
          th:if="${vet.nrOfSpecialties == 0}">none</span></td>
      </tr>
    </tbody>
  </table>
</body>
</html>
vdesikan@vdesikan-a01 vets % cd ../../../
vdesikan@vdesikan-a01 main % cd ../../
vdesikan@vdesikan-a01 spring-pet-clinic-eks % git add .
vdesikan@vdesikan-a01 spring-pet-clinic-eks %  git commit -m "Updated Veterinarians Page"
[main e672afd] Updated Veterinarians Page
 1 file changed, 1 insertion(+), 1 deletion(-)
vdesikan@vdesikan-a01 spring-pet-clinic-eks % git push -u origin main
Enumerating objects: 15, done.
Counting objects: 100% (15/15), done.
Delta compression using up to 12 threads
Compressing objects: 100% (7/7), done.
Writing objects: 100% (8/8), 777 bytes | 777.00 KiB/s, done.
Total 8 (delta 4), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (4/4), completed with 4 local objects.
To ssh://github.com/vdesikanvmware/spring-pet-clinic-eks.git
   a3592d4..e672afd  main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
vdesikan@vdesikan-a01 spring-pet-clinic-eks % kp build list -n tap-install
BUILD    STATUS      IMAGE                                                                                                                                                   REASON
1        SUCCESS     dev.registry.pivotal.io/tanzu-advanced-edition/vdesikan/spring-petclinic-eks@sha256:be889cf313016eb4fc168556493c2b1672c8e2af725e33696bf461b8212f9872    CONFIG
2        BUILDING                                                                                                                                                            COMMIT
 
vdesikan@vdesikan-a01 spring-pet-clinic-eks % kp image list -n tap-install
NAME                      READY      LATEST REASON    LATEST IMAGE                                                                                                                                            NAMESPACE
spring-petclinic-image    Unknown    COMMIT           dev.registry.pivotal.io/tanzu-advanced-edition/vdesikan/spring-petclinic-eks@sha256:be889cf313016eb4fc168556493c2b1672c8e2af725e33696bf461b8212f9872    tap-install
 
 
vdesikan@vdesikan-a01 spring-pet-clinic-eks % kp build list -n tap-install
BUILD    STATUS      IMAGE                                                                                                                                                   REASON
1        SUCCESS     dev.registry.pivotal.io/tanzu-advanced-edition/vdesikan/spring-petclinic-eks@sha256:be889cf313016eb4fc168556493c2b1672c8e2af725e33696bf461b8212f9872    CONFIG
2        BUILDING                                                                                                                                                            COMMIT
 
 
vdesikan@vdesikan-a01 spring-pet-clinic-eks % kp image list -n tap-install
NAME                      READY    LATEST REASON    LATEST IMAGE                                                                                                                                            NAMESPACE
spring-petclinic-image    True     COMMIT           dev.registry.pivotal.io/tanzu-advanced-edition/vdesikan/spring-petclinic-eks@sha256:0b627060147d7d80d8aae5a650a70ebca67bbb73001420580b2effa77c4b90cd    tap-install
 
 
vdesikan@vdesikan-a01 spring-pet-clinic-eks % kp build list -n tap-install
BUILD    STATUS     IMAGE                                                                                                                                                   REASON
1        SUCCESS    dev.registry.pivotal.io/tanzu-advanced-edition/vdesikan/spring-petclinic-eks@sha256:be889cf313016eb4fc168556493c2b1672c8e2af725e33696bf461b8212f9872    CONFIG
2        SUCCESS    dev.registry.pivotal.io/tanzu-advanced-edition/vdesikan/spring-petclinic-eks@sha256:0b627060147d7d80d8aae5a650a70ebca67bbb73001420580b2effa77c4b90cd    COMMIT
```
7. Update the CNR service with the new image.
```
vdesikan@vdesikan-a01 tap-install % more kapp-deploy-spring-petclinic.yaml
    apiVersion: kappctrl.k14s.io/v1alpha1
    kind: App
    metadata:
      name: spring-petclinic
    spec:
      serviceAccountName: tap-service-account
      fetch:
        - inline:
            paths:
              manifest.yml: |
                ---
                apiVersion: kapp.k14s.io/v1alpha1
                kind: Config
                rebaseRules:
                  - path: [metadata, annotations, serving.knative.dev/creator]
                    type: copy
                    sources: [new, existing]
                    resourceMatchers: &matchers
                      - apiVersionKindMatcher: {apiVersion: serving.knative.dev/v1, kind: Service}
                  - path: [metadata, annotations, serving.knative.dev/lastModifier]
                    type: copy
                    sources: [new, existing]
                    resourceMatchers: *matchers
                ---
                apiVersion: serving.knative.dev/v1
                kind: Service
                metadata:
                  name: petclinic
                spec:
                  template:
                    metadata:
                      annotations:
                        client.knative.dev/user-image: ""
                      labels:
                        tanzu.app.live.view: "true"
                        tanzu.app.live.view.application.name: "spring-petclinic"
                    spec:
                      containers:
                      - image: dev.registry.pivotal.io/tanzu-advanced-edition/vdesikan/spring-petclinic-eks@sha256:0b627060147d7d80d8aae5a650a70ebca67bbb73001420580b2effa77c4b90cd
                        securityContext:
                          runAsUser: 1000
      template:
        - ytt: {}
      deploy:
        - kapp: {}
vdesikan@vdesikan-a01 tap-install % kubectl apply -f kapp-deploy-spring-petclinic.yaml -n tap-install
app.kappctrl.k14s.io/spring-petclinic configured
vdesikan@vdesikan-a01 tap-install % kubectl get pods -n tap-install
NAME                                                    READY   STATUS      RESTARTS   AGE
application-live-view-crd-controller-5b659f8f57-7zz25   1/1     Running     0          23h
application-live-view-server-79bd874566-qtcbc           1/1     Running     0          23h
petclinic-00002-deployment-9bcf8bdc9-mrvf7              1/2     Running     0          15s
spring-petclinic-image-build-1-vl7j5-build-pod          0/1     Completed   0          5h54m
spring-petclinic-image-build-2-gthhl-build-pod          0/1     Completed   0          11m
```
8. Check that the new code changes are reflected in the application.
