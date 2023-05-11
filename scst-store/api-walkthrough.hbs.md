# API walkthrough for Supply Chain Security Tools - Store

This topic includes an example API call that you can use with Supply Chain Security Tools - Store. For information about using the SCST - Store API, see [full API documentation](api.md).

## <a id='curltopost'></a>Using CURL to POST an image report

The following procedure explains how to use CURL to POST an image report.

1. Port Forward the metadata-store-app. Run:

    ```console
    kubectl port-forward service/metadata-store-app 8443:8443 -n metadata-store
    ```

2. Retrieve the `metadata-store-read-write-client` access token.
    See [Retrieve access tokens](retrieve-access-tokens.hbs.md). Run:

    ```console
    export METADATA_STORE_ACCESS_TOKEN=$(kubectl get secrets metadata-store-read-write-client -n metadata-store -o jsonpath="{.data.token}" | base64 -d)
    ```

3. Retrieve the CA Certificate and store it locally. Run:

    ```console
    kubectl get secret ingress-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > /tmp/ca.crt
    ```

4. Run the Curl POST Command:

    ```console
    curl https://metadata-store.<ingress-domain>/api/imageReport \
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
