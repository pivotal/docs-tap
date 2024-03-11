# API walkthrough for Supply Chain Security Tools - Store

This topic tells you how to make an API call that you can use with Supply Chain Security Tools (SCST) - Store.
For information about using the SCST - Store API, see
[API reference for Supply Chain Security Tools - Store](api.hbs.md).

## <a id='curltopost'></a>Use curl to post an image report

This procedure uses Ingress, if Tanzu Application Platform is deployed without Ingress, see
[Use your NodePort with Supply Chain Security Tools - Store](use-node-port.hbs.md) and
[Use your LoadBalancer with Supply Chain Security Tools - Store](use-load-balancer.hbs.md). Complete the following steps:

1. Switch to the kubectl context or kubeconfig to target the View cluster.

2. Retrieve the CA certificate and store it locally. Run:

    ```console
    kubectl get secret ingress-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > /tmp/ca.crt
    ```

3. Using the `health` endpoint as an example, run:

   ```console
   curl -i https://metadata-store.INGRESS-DOMAIN/api/HEALTH \
       --cacert /tmp/ca.crt
   ```

   For example:

   ```console
   $ curl -i https://metadata-store.example.com/api/health \
      --cacert /tmp/ca.crt
   
   HTTP/2 200
   content-length: 0
   date: Tue, 23 Jan 2024 22:50:57 GMT
   x-envoy-upstream-service-time: 0
   server: envoy
   ```

4. To make a request to an authenticated endpoint an access token is required. To retrieve the `metadata-store-read-write-client` access token, run:

    ```console
    export METADATA_STORE_ACCESS_TOKEN=$(kubectl get secrets metadata-store-read-write-client -n metadata-store -o jsonpath="{.data.token}" | base64 -d)
    ```

    For more information, see [Retrieve access tokens for Supply Chain Security Tools - Store](retrieve-access-tokens.hbs.md).

5. Using the `api/imageReport` endpoint as an example, create a post request:

    ```console
    curl https://metadata-store.INGRESS-DOMAIN/API/IMAGE-REPORT \
        --cacert /tmp/ca.crt \
        -H "Authorization: Bearer ${METADATA_STORE_ACCESS_TOKEN}" \
        -H "Content-Type: application/json" \
        -X POST \
        --data "@ABSOLUTE-PATH-TO-THE-POST-BODY"
    ```

    Where `ABSOLUTE-PATH-TO-THE-POST-BODY` is the absolute filepath of the API JSON for an image report.

    For example, the following is a sample post body of an image report API JSON:

    ```json
    {
      "Name" : "burger-image-2",
      "Registry" : "test-registry",
      "Digest" : "test-digest@45asd61asasssdfsdfddssghjkdfsdfasdfasdsdasdassdfghjddasfddfsadfadfgfshdasdfsdfsdfsdasdsdfsdfadsdassdfdasdfaasdsdfsddfsdasgsasddffdgfdasddfgdfssdfakasdasdasdsdasddasdsd23",
      "Sources" : [
        {
          "Repository" : "aaaaoslfdfggo",
          "Organization" : "pivotal",
          "Sha" : "1235assdfssadfacfddxdf41",
          "Host" : "http://oslo.io",
          "Packages" : [
            {
              "Name" : "Source package5",
              "Version" : "v2sfsfdd34",
              "PackageManager" : "test-manager",
              "Vulnerabilities" : [
                {
                  "CVEID" : "0011",
                  "PrimaryURL" : "http://www.mynamejeff.comm",
                  "Description" : "Bye",
                  "CNA" : "NVD",
                  "Ratings": [{
                    "Vector" : "AV:L/AC:L/Au:N/C:P/I:P/A:P",
                    "Score" : 0,
                    "MethodTypeID" : 1,
                    "Severity":   "High"
                  }],
                  "References" : [""]
                }
              ]
            }
          ]
        }
      ],
      "Packages" : [
        {
          "Name" : "bob-dependency-35daasds56j",
          "Version" : "v2",
          "PackageManager" : "test-manager",
          "Vulnerabilities" : [
            {
              "CVEID" : "002",
              "PrimaryURL" : "http://www.mynamejeff.comm",
              "Description" : "Bye",
              "CNA" : "NVD",
              "Ratings": [{
                "Vector" : "AV:L/AC:L/Au:N/C:P/I:P/A:P",
                "Score" : 0,
                "MethodTypeID" : 1,
                "Severity":   "High"
              }],
              "References" : [""]
            }
          ]
        }
      ]
    }
    ```
