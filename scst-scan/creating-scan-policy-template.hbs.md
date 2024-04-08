# Enable policy enforcement with Scan 2.0 in a supply chain

This topic tells you how to enable policy enforcement in a supply chain with Supply Chain Security
Tools (SCST) - Scan 2.0.

Policy enforcement is not inbuilt in SCST - Scan 2.0. It can be achieved by creating a
`ClusterImageTemplate` that stamps out a Tekton `TaskRun` that evaluates the vulnerabilities
and enforces the policy set. A sample of the task run and cluster image template
are provided in this topic.

## Prerequisites for the task run

The `TaskRun` queries the metadata store to get the list of vulnerabilities for the image.
To authenticate with the MDS (Metadata Store) API, an accessToken and certificate are needed.
Complete the following steps:

1. Build an image that contains `curl` and `jq`. This image is used by the task run.

1. Get the access token from MDS:

    ```console
    ACCESS-TOKEN=$(kubectl get secrets -n metadata-store  metadata-store-read-write-client -o yaml | yq .data.token | base64 -d)
    ```

1. Create a secret `metadata-store-access-token`.

    ```yaml
    kind: Secret
    apiVersion: v1
    metadata:
      name: metadata-store-access-token
    stringData:
      accessToken: <ACCESS-TOKEN>
    ```

1. Get the CA certificate from MDS:

    ```console
    MDS_CA_CERT=$(kubectl get secret -n metadata-store ingress-cert -o json | jq -r ".data.\"ca.crt\"" | base64 -d)
    ```

1. Create a secret `metadata-store-cert`:

    ```yaml
    kind: Secret
    apiVersion: v1
    metadata:
      name: metadata-store-cert
    stringData:
      caCrt: |
        <MDS_CA_CERT>
    ```

## Task run sample that enforces policy

The sample task run waits until the vulnerability data is available for the image. When the data is
available, the vulnerabilities are aggregated by severity. The task run succeeds or fails based on
the policy `GATE` set.

For example, if the `GATE` is set to `high`, the task run fails if it finds high or critical
vulnerabilities for the image.

If the `GATE` is set to `none`, no policy is enforced.

```yaml
apiVersion: tekton.dev/v1
kind: TaskRun
metadata:
  name: enforce-policy
spec:
  serviceAccountName: scanner
  taskSpec:  
    steps:
    - name: enforce-policy
      image: dev.local:5000/taskrun-image:latest # A task run image that contains curl and jq
      script: |
        if [ ${GATE} -eq "none" ]; then
            exit 0
        fi

        IMAGE_DIGEST=$(echo ${IMAGE} | cut -d "@" -f 2)
        while true; do
          response_code=$(curl -k https://$METADATA_STORE_DOMAIN:$METADATA_STORE_PORT/api/v1/images/${IMAGE_DIGEST} -H "Authorization: Bearer ${ACCESS_TOKEN}" -H 'accept: application/json' --cacert /var/cert/caCrt -o vulnerabilities.json -w "%{http_code}")
          if [ $response_code -eq 200 ]; then
            echo "Vulnerabilities data is available in AMR"
            break
          else
            echo "Vulnerabilities data is not available in AMR, waiting..."
            sleep 10
          fi
        done

        critical=$(cat vulnerabilities.json | jq '[.Packages[].Vulnerabilities[] | select(.Ratings[].Severity | contains("Critical"))] | unique | length')
        high=$(cat vulnerabilities.json | jq '[.Packages[].Vulnerabilities[] | select(.Ratings[].Severity | contains("High"))] | unique | length')
        medium=$(cat vulnerabilities.json | jq '[.Packages[].Vulnerabilities[] | select(.Ratings[].Severity | contains("Medium"))] | unique | length')
        low=$(cat vulnerabilities.json | jq '[.Packages[].Vulnerabilities[] | select(.Ratings[].Severity | contains("Low"))] | unique | length')
        vulnerabilitiesCount=0
        case $GATE in
          low)
            vulnerabilitiesCount=$(($low+$medium+$high+$critical))
            ;;
          medium)
            vulnerabilitiesCount=$(($medium+$high+$critical))
            ;;

          high)
            vulnerabilitiesCount=$(($high+$critical))
            ;;

          critical)
            vulnerabilitiesCount=$(($critical))
            ;;
        esac
        echo "Vulnerabilities: ${vulnerabilitiesCount}"
        if [ ${vulnerabilitiesCount} -gt 0 ];then
          exit 1
        fi
      env:
      - name: GATE
        value: "critical" # Policy enforcement gate
      - name: METADATA_STORE_DOMAIN
        value: "metadata-store-app.metadata-store.svc.cluster.local"
      - name: IMAGE
        value: "image@sha256:digest"
      - name: METADATA_STORE_PORT
        value: "8443"
      - name: ACCESS_TOKEN # Access token from the secret is set as an environment variable
        valueFrom:
          secretKeyRef:
            name: metadata-store-access-token
            key: accessToken
      volumeMounts:
      - name: cert
        mountPath: /var/cert
    volumes:
    - name: cert # Cert from MDS is mounted as a file to the task run
      secret:
        secretName: metadata-store-cert
```

## Include the policy ClusterImageTemplate in a supply chain

1. Embed the sample task run in a `ClusterImageTemplate`.

    ```yaml
    #@ load("@ytt:data", "data")
    ---
    apiVersion: carto.run/v1alpha1
    kind: ClusterImageTemplate
    metadata:
      name: scan-policy-template
    spec:
      imagePath: .status.compliantArtifact.registry.image
      healthRule:
        multiMatch:
          healthy:
            matchConditions:
              - type: Succeeded
                status: "True"
          unhealthy:
            matchConditions:
              - type: Succeeded
                status: "False"
      ytt: |
        #@ load("@ytt:data", "data")
        #@ load("@ytt:template", "template")
        ---
        apiVersion: tekton.dev/v1
        kind: TaskRun
        metadata:
          name: enforce-policy
        spec:
          serviceAccountName: scanner
          taskSpec:  
            steps:
            - name: enforce-policy
              image: dev.local:5000/taskrun-image:latest
              script: |
              ....
                IMAGE_DIGEST=$(echo ${IMAGE} | cut -d "@" -f 2)
              ....
              env:
              ...
              - name: IMAGE
                value: #@ data.values.image # <------ template the image so that it can flow through the supply chain
              ....
    ```

1. Plug in the created `ClusterImageTemplate` after the scan step in the supply chain.

    ```yaml
    ---
    apiVersion: carto.run/v1alpha1
    kind: ClusterSupplyChain
    metadata:
      name: scanning-image-scan-to-url
    spec:
      selectorMatchExpressions:
        - key: 'apps.tanzu.vmware.com/workload-type'
          operator: In
          values:
          - web
          - server
          - worker
      selectorMatchFields:
        - key: spec.image
          operator: Exists

      params:
        - name: image_scanning_service_account_publisher
          value: scanner
        - name: image_scanning_service_account_scanner
          default: report-publisher
        - name: image_scanning_workspace_size
          default: 4Gi

      resources:
      - name: image-provider
        templateRef:
          kind: ClusterImageTemplate
          name: image-provider-template
        params:
          - name: serviceAccount
            default: scanner

      - name: image-scanner
        templateRef:
          kind: ClusterImageTemplate
          name: image-vulnerability-scan-trivy
        params:
          - name: registry
            default:
              server: dev.registry.tanzu.vmware.com
              repository: tanzu-image-signing/test-policy
        images:
          - resource: image-provider
            name: image

      - name: policy # policy cluster image template
        templateRef:
          kind: ClusterImageTemplate
          name: scan-policy-template
        params:
          - name: serviceAccount
            default: scanner
        images:
        - resource: image-scanner
          name: image
        ... <supply chain continues>
    ```

1. Create a workload to trigger the supply chain.

    ```yaml
    apiVersion: carto.run/v1alpha1
    kind: Workload
    metadata:
      labels:
        app.kubernetes.io/part-of: test-policy
        apps.tanzu.vmware.com/workload-type: web
      name: test-policy
      namespace: app-scanning
    spec:
      image: image@sha256:digest
    ```
