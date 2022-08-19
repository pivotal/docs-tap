# API Auto Registration

## <a id='overview'></a> Overview

API Autoregistration is a feature that allows API providers a mechanism to automatically register their API documentation with TAP. Once registered you will then be able to view the api documentation in the API Explorer tab.  Currently the following types of api's are supported 
- openapi
- async
- graphql   
- gRPC

By supplying a little bit of inormation in your workload specification you inform TAP that you want your workload to be auto registered. This results in the creation of a CR of type APIDescriptor being added to your cluster. There is a controller that watches for resources of this type and when one is discovered it will retrieve the documentation for your API and send that information to TAP. You will then be able to view the api documentation in the API Explorer tab of TAP GUI.
