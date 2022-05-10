# Install Application Live View

This topic describes how to install Application Live View for VMware Tanzu.
You must install a Kubernetes cluster on a cloud platform provider, install command line tools,
configure your cluster, and download Application Live View before installing.
You install Application Live View on a Kubernetes cluster.

Application Live View is a component of Tanzu Application Platform.
For how to install Tanzu Application Platform, see the
[Tanzu Application Platform documentation](https://docs.vmware.com/en/Tanzu-Application-Platform/1.1/tap/GUID-install-intro.html).

The Application Live View UI plug-in is part of Tanzu Application Platform GUI.
To access the Application Live View UI, see
[Application Live View in Tanzu Application Platform GUI](https://docs.vmware.com/en/Tanzu-Application-Platform/1.1/tap/GUID-tap-gui-plugins-app-live-view.html).

## <a id="overview"></a> About installing Application Live View

There are three packages to install:

- **Application Live View Backend package** (`backend.appliveview.tanzu.vmware.com`):
This contains Application Live View Backend component in the `app-live-view` namespace.

- **Application Live View Connector package** (`connector.appliveview.tanzu.vmware.com`):
This contains Application Live View Connector component and is installed as a
DaemonSet in the `app-live-view-connector` namespace.

- **Application Live View Conventions package** (`conventions.appliveview.tanzu.vmware.com`):
This contains Application Live View Convention Service only and is installed in the
`app-live-view-conventions` namespace.

### <a id="profiles"></a> Profiles

- For the `full` , `light` and `iterate` profiles, Application Live View installs three packages:

    - **Application Live View Backend package**
    - **Application Live View Connector package**
    - **Application Live View Conventions package**

- For the `view` profile, Application Live View installs the **Application Live View Backend package**.

- For the `run` profile, Application Live View installs **Application Live View Connector package**.

- For the `build` profile, Application Live View installs **Application Live View Conventions package**.

### <a id="clusters"></a> Single and multi-cluster environments

You can install Application Live View in a single cluster or multi-cluster environment.

* **Single cluster:** All Application Live View Components are deployed in a single cluster.
You can access Application Live View plug-in information for apps across all
namespaces in the Kubernetes cluster. This is the default mode for Application Live View.

* **Multi cluster:** When the user is working in multi cluster environment,
the Application Live View Backend Component is installed only once in a single
cluster, and exposes an RSocket registration for those other clusters using shared ingress.
Each cluster continues to get the connector installed as a DaemonSet.
The connectors are configured to connect to the central instance of the back end.


## <a id="prereqs"></a> Prerequisites

The following prerequisites are required to install Application Live View:

- Kubernetes v1.20 or later
- [secretgen-controller](https://github.com/vmware-tanzu/carvel-secretgen-controller) v0.5.0 or later
- [Cert Manager](https://cert-manager.io/docs/installation/) v1.5.3 installed in cluster
- Tanzu Convention Controller installed in cluster
- Kapp-controller v0.24.0 or later.
  To download kapp-controller, see the [Carvel documentation](https://carvel.dev/kapp-controller/docs/latest/install/).
- Command line tools. The following command line tools are required:
    - [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) (v1.17 or later)
    - [kapp](https://carvel.dev/kapp/) (v0.37.0 or later)
    - [ytt](https://carvel.dev/ytt/) (v0.34.0 or later)
    - [imgpkg](https://carvel.dev/imgpkg/) (v0.14.0 or later)
    - [kbld](https://carvel.dev/kbld/) (v0.30.0 or later)
- Tanzu CLI installed and package plug-in enabled


## <a id="tanzu-network"></a> Visit the VMware Tanzu Network page for Application Live View

1. If you have not done so already, create a [Tanzu Network](https://network.tanzu.vmware.com/)
account to download Tanzu Application Platform packages.

2. Visit our
[Application Live View for VMware Tanzu](https://network.tanzu.vmware.com/products/app-live-view)
product page on VMware Tanzu Network while logged in and confirm that you can see `Release 1.1.0`.

3. If prompted, accept the EULA.

To access the Application Live View UI, see
[Install Tanzu Application Platform GUI](https://docs.vmware.com/en/Tanzu-Application-Platform/1.1/tap/GUID-install-components.html#install-tap-gui).


## <a id="verify-k8s-cluster"></a> Verify the Kubernetes Cluster configuration

Run the following commands to verify the cluster configuration:

```
kubectl config current-context
kubectl cluster-info
```


## <a id="dl-alv-install-bundle"></a> Download the Application Live View installation bundle

Before downloading the Application Live View installation bundle, ensure you have
signed the EULA for the Application Live View release. Log in to [Tanzu Network](https://network.tanzu.vmware.com/products/app-live-view) and go to the product page for Application Live View for VMware Tanzu.
If you have not already signed the EULA, a message is shown on the page for the latest
release asking you to accept the EULA.
If you have already signed it, the EULA message will not be not visible.

To download the Application Live View installation bundle:

1. Provide pull secrets for Tanzu Network by running:

    ```
    kubectl apply -f- << EOF
    ---
    apiVersion: v1
    kind: Secret
    metadata:
      name: reg-creds
    type: kubernetes.io/dockerconfigjson  # needs to be this type
    stringData:
      .dockerconfigjson: |
        {
          "auths": {
            "registry.tanzu.vmware.com": {
              "username": "${TANZUNET_USER?:Required}",
              "password": "${TANZUNET_PASSWORD?:Required}",
              "auth": ""
            }
          }
        }    

    ---
    apiVersion: secretgen.carvel.dev/v1alpha1
    kind: SecretExport
    metadata:
      name: reg-creds        
      namespace: secretgen
    spec:
      toNamespaces:
      - "*"  # star means export is available for all namespaces
    EOF
    ```

1. Run the following command and provide your username and password at the prompts:

    ```
    docker login registry.tanzu.vmware.com
    ```


## <a id="alv-backend-bundle"></a> Install the Application Live View Backend installation bundle

Follow the procedures in this section to install the Application Live View Backend installation bundle.

### <a id="install-alv-backend-bundle"></a> Install the Application Live View Backend installation bundle

To install the Application Live View Backend component, pull the
Application Live View Backend bundle by running:

```
imgpkg pull -b registry.tanzu.vmware.com/app-live-view/application-live-view-install-bundle:1.1.0 \
  -o /tmp/application-live-view-backend-bundle
```

### <a id="deploy-alv-backend"></a> Deploy the Application Live View Backend bundle

To deploy the Application Live View Backend component:

1. Deploy the bundle with default installation settings by running:

    ```
    ytt -f /tmp/application-live-view-backend-bundle/config -f /tmp/application-live-view-backend-bundle/values.yaml \
    | kbld -f /tmp/application-live-view-backend-bundle/.imgpkg/images.yml -f- \
    | kapp deploy -y -a application-live-view -f-
    ```

    > **Note:** You can also install the bundle without entering your credentials in the `values.yaml` file.
    > See [Install without entering credentials in values.yaml](#alternative-ytt) later in this topic.

1. (Optional) To enable multi-cluster support for Application Live View:

    1. Create the `app-live-view-backend-values.yaml` file using the following example,
    replacing all placeholders with your values:

        ```
        #@data/values
        ---
        ingressEnabled: "true"
        ingressDomain: ${INGRESS-DOMAIN}
        ```

        Where `INGRESS-DOMAIN` is the top level domain you point at the external IP
        address for tanzu-shared-ingress service.
        The appliveview subdomain is prepended to the value you provide.

    1. To configure Transport Layer Security (TLS) certificate delegation information for the domain, add the
    following values to your `app-live-view-backend-values.yaml`.

        ```
        tls:
            namespace: "NAMESPACE"
            secretName: "SECRET NAME"
        ```

        Where:

        - `NAMESPACE` is the targeted namespace of TLS secret for the domain.
        - `SECRET NAME` is the name of TLS secret for the domain.

    1. Deploy the bundle by running:

        ```
        ytt -f /tmp/application-live-view-backend-bundle/config -f app-live-view-backend-values.yaml \
        | kbld -f /tmp/application-live-view-backend-bundle/.imgpkg/images.yml -f- \
        | kapp deploy -y -a application-live-view -f-
        ```

The Application Live View Backend component is deployed in the `app-live-view` namespace by default.

### <a id="verify-alv-backend-component"></a> Verify the Application Live View Backend component

To verify your installation of the Application Live View Backend component:

1. List the resources deployed in the `app-live-view` namespace by running:

    ```
    kubectl get -n app-live-view service,deploy,pod
    ```

1. Verify that your output is similar to the following:

    ```
    NAME                                 TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
    service/application-live-view-5112   ClusterIP   10.100.44.226    <none>        80/TCP     15m
    service/application-live-view-7000   ClusterIP   10.100.226.242   <none>        7000/TCP   15m

    NAME                                           READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/application-live-view-server   1/1     1            1           15m

    NAME                                                READY   STATUS    RESTARTS   AGE
    pod/application-live-view-server-654cfbfd68-5srbc   1/1     Running   0          15m
    ```


## <a id="alv-connector-bundle"></a> Install the Application Live View Connector installation bundle

Follow the procedures in this section to install the Application Live View Connector installation bundle.

### <a id="install-alv-connector-bundle"></a> Install the Application Live View Connector installation bundle

To install the Application Live View Connector component, pull the
Application Live View Connector installation bundle by running:

```
imgpkg pull -b registry.tanzu.vmware.com/app-live-view/application-live-view-connector-bundle:1.1.0 \
  -o /tmp/application-live-view-connector
```

### <a id="deploy-alv-connector"></a> Deploy the Application Live View Connector installation bundle

To deploy the Application Live View Connector component:

1. Deploy the bundle with default installation settings by running:

    ```
    ytt -f /tmp/application-live-view-connector/config -f /tmp/application-live-view-connector/values.yaml \
    | kbld -f /tmp/application-live-view-connector/.imgpkg/images.yml -f- \
    | kapp deploy -y -a application-live-view-connector -f-
    ```

    The Application Live View connector connects to the cluster-local back end to register the apps

    > **Note:** You can also install the bundle without entering your credentials in the `values.yaml` file.
    > See [Install without entering credentials in values.yaml](#alternative-ytt) later in this topic.

1. (Optional) To deploy Application Live View Connector in multi-cluster environment:

    1. Create the `app-live-view-connector-values.yaml` file using the following example,
    replacing all placeholders with your values:

        ```
        #@data/values
        ---
        backend:
            sslDisabled: "false"
            host: appliveview.INGRESS-DOMAIN
        ```

        Where `INGRESS-DOMAIN` is the top level domain the Application Live View Backend
        exposes using shared-ingress for connectors in other clusters to reach the back end.
        The appliveview subdomain is prepended to the value you provide.

    1. Edit the value of the `sslDisabled` to activate or deactivate Secure Sockets Layer (SSL).
    The `sslDisabled` Boolean flag is treated as a string in the Kubernetes YAML,
    so you must use double quotation marks for the configuration to be accepted.

        > **Note:** The back end service running on port `7000` is exposed using the
        > HTTP proxy either on `80` or `443` based on the SSL configuration.
        > The connector connects to the back end on port `80` or `443` by default.
        > Therefore, you do not have to configure the `port` field explicitly.

    1. Deploy the bundle by running:

        ```
        ytt -f /tmp/application-live-view-connector/config -f app-live-view-connector-values.yaml \
        | kbld -f /tmp/application-live-view-connector/.imgpkg/images.yml -f- \
        | kapp deploy -y -a application-live-view-connector -f-
        ```

        > **Note:** Each cluster gets the connector installed as a DaemonSet.
        > The connector is configured to connect to the central instance of the back end.

The Application Live View Connector is deployed in `app-live-view-connector` namespace by default.

### <a id="verify-alv-connector-component"></a> Verify the Application Live View Connector component

To verify your installation of the Application Live View Connector component:

1. List the resources deployed in the `app-live-view-connector` namespace by running:

    ```
    kubectl get -n app-live-view-connector deploy,pod
    ```

1. Verify that your output is similar to the following:

    ```
    NAME                                        READY   STATUS    RESTARTS   AGE
    pod/application-live-view-connector-6tb8n   1/1     Running   0          103s
    ```

## <a id="alv-conv-bundle"></a> Install the Application Live View Conventions installation bundle

Follow the procedures in this section to install the Application Live View Conventions installation bundle.


### <a id="install-alv-conv-bundle"></a> Install the Application Live View Conventions installation bundle

To install the Application Live View Conventions component, pull the
Application Live View Conventions installation bundle by running:

```
imgpkg pull -b registry.tanzu.vmware.com/app-live-view/application-live-view-conventions-bundle:1.1.0 \
  -o /tmp/application-live-view-conventions
```


### <a id="deploy-alv"></a> Deploy the Application Live View Conventions installation bundle

Deploy the Application Live View Conventions component by running:

```
ytt -f /tmp/application-live-view-conventions/config -f /tmp/application-live-view-conventions/values.yaml \
| kbld -f /tmp/application-live-view-conventions/.imgpkg/images.yml -f- \
| kapp deploy -y -a application-live-view-conventions -f-
```

> **Note:** You can also install the bundle without entering your credentials in the `values.yaml` file.
> See [Install without entering credentials in values.yaml](#alternative-ytt) later in this topic.

The Application Live View Convention server is deployed in `app-live-view-conventions` namespace by
default.


### <a id="verify-alv-conv-component"></a> Verify the Application Live View Convention component

To verify your installation of the Application Live View Convention component:

1. List the resources deployed in the `app-live-view-conventions` namespace by running:

    ```
    kubectl get -n app-live-view-conventions service,deploy,pod
    ```

1. Verify that your output is similar to the following:

    ```
    NAME                          TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
    service/appliveview-webhook   ClusterIP   10.96.25.27   <none>        443/TCP   11m

    NAME                                  READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/appliveview-webhook   1/1     1            1           11m

    NAME                                       READY   STATUS    RESTARTS   AGE
    pod/appliveview-webhook-5ff9759b6b-9pnkb   1/1     Running   0          11m
    ```


## <a id="alternative-ytt"></a> Install without entering credentials in values.yaml

You can also enter your registry credentials as arguments to the `ytt` command without entering
credentials in `values.yaml`.

Add `registry.username` and `registry.password` arguments with your credentials as follows:

```
ytt -f /tmp/application-live-view-install-bundle/config -f /tmp/application-live-view-install-bundle/values.yaml -v registry.server='registry.tanzu.vmware.com' -v registry.username='your username' -v registry.password='your password' \
| kbld -f /tmp/application-live-view-install-bundle/.imgpkg/images.yml -f- \
| kapp deploy -y -a application-live-view -f-
```
