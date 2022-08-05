# API walkthrough

This topic includes an example API call. For information about using the Supply Chain Security Tools - Store API, see [full API documentation](api.md).

## <a id='curltopost'></a>Using CURL to POST an image report

The following procedure explains how to use CURL to POST an image report.

1. Port Forward the metadata-store-app. Run the following:

    ```console
    kubectl port-forward service/metadata-store-app 8443:8443 -n metadata-store
    ```

2. Retrieve the `metadata-store-read-write-client` access token. Ensure the Service Account is [created](create-service-account-access-token.md). Run:

    ```console
    export METADATA_STORE_ACCESS_TOKEN=$(kubectl get secrets -n metadata-store -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='metadata-store-read-write-client')].data.token}" | base64 -d)
    ```

3. Retrieve the CA Certificate and store it locally. Run the following:

    ```console
    kubectl get secret app-tls-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > /tmp/ca.crt
    ```

4. Run the Curl POST Command:

    ```console
    curl https://metadata-store-app:8443/api/imageReport \
        --resolve metadata-store-app:8443:127.0.0.1 \
        --cacert /tmp/ca.crt \
        -H "Authorization: Bearer ${METADATA_STORE_ACCESS_TOKEN}" \
        -H "Content-Type: application/json" \
        -X POST \
        --data "@<ABSOLUTE PATH TO THE POST BODY>"
    ```

5. Replace <ABSOLUTE PATH TO THE POST BODY> with the absolute path of the POST body.

6. The following is a sample POST body of a image report:

    ```text
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
