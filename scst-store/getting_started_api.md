# Getting Started with the API

This topic includes an example API call. For information about using the Supply Chain Security Tools - Store API, see [full API documentation](api.md).

## Using CURL to POST an image report

Port Forward the metadata-store-app

`kubectl port-forward service/metadata-store-app 8443:8443 -n metadata-store`:

Retrieve the metadata-store-read-write-client access token. Ensure the Service Account is [created](create_service_account_access_token.md) first:

`export METADATA_STORE_ACCESS_TOKEN=$(kubectl get secrets -n metadata-store -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='metadata-store-read-write-client')].data.token}" | base64 -d)`

Retrieve the CA Certificate and store it locally:

`kubectl get secret app-tls-cert -n metadata-store -o json | jq -r '.data."ca.crt"' | base64 -d > /tmp/ca.crt`

Run the Curl POST Command:

`curl https://metadata-store-app:8443/api/imageReport --resolve metadata-store-app:8443:127.0.0.1 --cacert /tmp/ca.crt -H "Authorization: Bearer ${METADATA_STORE_ACCESS_TOKEN}" -H "Content-Type: application/json" -X POST --data "@<ABSOLUTE PATH TO THE POST BODY>"`

Replace <ABSOLUTE PATH TO THE POST BODY> with the absolute path of the POST body.

Sample POST body of a image report:
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
