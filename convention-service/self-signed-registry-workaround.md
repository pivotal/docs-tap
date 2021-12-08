# Convention Service self-signed registry workaround

## Problem

When you create a workload where the workload container image resides in a private registry that has
a self-signed certificate, **conventions apply** fails.

## Cause

Convention controller fails to pull image metadata from the private registry with the self-signed
certificate.

## Workaround 1

Configure your harbor registry to support http instead of https.

## Workaround 2

Copy the RootCA file from the private registry to convention controller container's file system in
this path: `/etc/ssl/certs`. Here are the steps:

1. Export the deployment for convention controller manager:

    ```
    kubectl get deployment conventions-controller-manager -n conventions-system -o yaml > ccm.yml
    ```

1. The patch strategy replaces args in the container specification.
You have to paste the entire arg block into a patch file.
For more information, see
[the contents of args from the ccm.yml](https://github.com/kubernetes/api/blob/b7adf12040d3399c31cde19c6ba59354d5075cb3/core/v1/types.go#L2311).

1. Create a patch file:

    ```
    touch ccm.patch.yml
    ```

1. Populate `ccm.patch.yml` by first copying the contents of args from the `ccm.yml` into the patch
file:

    ```
    spec:
    template:
        spec:
        containers:
        - args:
            - --enable-leader-election
            env:
            - name: SYSTEM_NAMESPACE
            valueFrom:
                fieldRef:
                apiVersion: v1
                fieldPath: metadata.namespace
            image: registry.tanzu.vmware.com/tanzu-application-platform/tap-packages@sha256:0e1b1fc6fcdd9db7268b1d28198561e34d7cdd055e218b35305f7d3e745c8765
            imagePullPolicy: IfNotPresent
            livenessProbe:
            failureThreshold: 3
            httpGet:
                path: /healthz
                port: 8081
                scheme: HTTP
            periodSeconds: 10
            successThreshold: 1
            timeoutSeconds: 1
            name: manager
            ports:
            - containerPort: 443
            name: webhook-server
            protocol: TCP
            readinessProbe:
            failureThreshold: 3
            httpGet:
                path: /readyz
                port: 8081
                scheme: HTTP
            periodSeconds: 10
            successThreshold: 1
            timeoutSeconds: 1
            resources:
            limits:
                cpu: 100m
                memory: 256Mi
            requests:
                cpu: 100m
                memory: 20Mi
            terminationMessagePath: /dev/termination-log
            terminationMessagePolicy: File
            volumeMounts:
            - mountPath: /tmp/k8s-webhook-server/serving-certs
            name: cert
            readOnly: true
            - mountPath: /var/cache/ggcr
            name: cache-volume
    ```

1. Append the following mount settings:

    ```
            - mountPath: /etc/ssl/certs
            name: harbor-private-cert
            readOnly: false
        volumes:
        - name: harbor-private-cert
            configMap:
            name: harbor-private-cert
    ```

1. Confirm the entire file looks like this:

        ```
        spec:
        template:
            spec:
            containers:
            - args:
                - --enable-leader-election
                env:
                - name: SYSTEM_NAMESPACE
                valueFrom:
                    fieldRef:
                    apiVersion: v1
                    fieldPath: metadata.namespace
                image: registry.tanzu.vmware.com/tanzu-application-platform/tap-packages@sha256:0e1b1fc6fcdd9db7268b1d28198561e34d7cdd055e218b35305f7d3e745c8765
                imagePullPolicy: IfNotPresent
                livenessProbe:
                failureThreshold: 3
                httpGet:
                    path: /healthz
                    port: 8081
                    scheme: HTTP
                periodSeconds: 10
                successThreshold: 1
                timeoutSeconds: 1
                name: manager
                ports:
                - containerPort: 443
                name: webhook-server
                protocol: TCP
                readinessProbe:
                failureThreshold: 3
                httpGet:
                    path: /readyz
                    port: 8081
                    scheme: HTTP
                periodSeconds: 10
                successThreshold: 1
                timeoutSeconds: 1
                resources:
                limits:
                    cpu: 100m
                    memory: 256Mi
                requests:
                    cpu: 100m
                    memory: 20Mi
                terminationMessagePath: /dev/termination-log
                terminationMessagePolicy: File
                volumeMounts:
                - mountPath: /tmp/k8s-webhook-server/serving-certs
                name: cert
                readOnly: true
                - mountPath: /var/cache/ggcr
                name: cache-volume
        ```

1. Create the configmap that includes the certificates you want to trust:

    ```
    cat <<EOF | kubectl apply -f -
    ---
    apiVersion: v1
    data:
    ca-certificates.crt: |
        -----BEGIN CERTIFICATE-----
        MIIDEzCCAfugAwIBAgIQL/LZl89VUFcD8v1qB62h8DANBgkqhkiG9w0BAQsFADAU
        MRIwEAYDVQQDEwloYXJib3ItY2EwHhcNMjExMTE2MTUyMDMxWhcNMjIxMTE2MTUy
        MDMxWjAUMRIwEAYDVQQDEwloYXJib3ItY2EwggEiMA0GCSqGSIb3DQEBAQUAA4IB
        DwAwggEKAoIBAQCarfM1hrCdx3W2QeH76od+clcgMn1yX/xr3h5oC/XnQ0ZBGY9w
        TZ/Ijw2rWpHlwJi+AZIMDHp6Gui04GM2mLFwiup/cYHwufOS1culJSFb+AzHDJbR
        wwbOlEka5/n5EQYd3hE8AaqfYFRgRH8LCKD26sao57mFTw95Vh4UcImO8iCGDmBR
        JRBDqRuMj7fnJnPukzgJbg4Hx4ajc0gRocYn1WWsb8vq3KAszriEvENrVer8dky4
        uqG/PCWOYFwccWNhUmkwI9ggmuMb0ivp0y/yCK9AZGUy48C6VNm7YUzQYCaWcTi/
        ZjhBLe09FOrSECkkGijKU5EDdrWHegEWEEojAgMBAAGjYTBfMA4GA1UdDwEB/wQE
        AwICpDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwDwYDVR0TAQH/BAUw
        AwEB/zAdBgNVHQ4EFgQUNYplP3Nxwv6i5w0Kmu/iz+R3q6AwDQYJKoZIhvcNAQEL
        BQADggEBAFdrHkX8eO9ESwmRQ1YQOnFgUDje9R/xOF2en9Y8RR5dmJYVkMvweyu5
        Pevsjf5t3CHBb1DhT4O0aJZ+EujcxnlD5T9dUg2L1zkLQEtYrfUoCcy3m4Ai6gzg
        TumWRIswL0olxK8I1QUf6PS6LXxqicVFQDCCGRguTIDtIBHoTyfmIMjTvCkPCR75
        g8Nav4FHsOcN6G4/xhlYDoOCUrpQlbw7vpiGOYguSkvjxfNBkb6ILr3B+QPNssCZ
        yc5QbGchXRwObIcWMpySaMlTnx00TsHhCPSfxYw7MOhTWymBGC5/tT2tgmI/bJgy
        A2j+Ryi5o4Ms0rLjTMyy9P+QW3pKJUo=
        -----END CERTIFICATE-----
    kind: ConfigMap
    metadata:
    name: harbor-private-cert
    namespace: conventions-system
    EOF
    ```

1. Apply the patch by running:

    ```
    kubectl patch deployment conventions-controller-manager  -n conventions-system --patch "$(cat ccm.patch.yml)"
    ```

The conventions controller manager Pod should now be recreated and support your local harbor
instance.

>**Note:** In **Workaround 2**, after mounting the cert data to `/etc/ssl/certs`, it overrides the
>base image provided `ca-certificates.crt` file. This results in a "x509: certificate" error from
>other known public & private registries. However, for this specific use case, these workarounds are
>the two best available options until we deliver the fix in the next release of convention
>controller.
