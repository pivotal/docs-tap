# API scoring and validation

The APIX solution aims to manage the end-to-end lifecycle of APIs.

This specific feature of APIX focuses on scanning and validating an API specification. The API spec is generated from the API autoregistration feature in TAP. Once that is done, APIX scans, lints, and validates the API spec. Based on the validation, a scoring is provided that tells the dev / devops, the quality and health of their API specification as it related to Documentation, OpenAPI best practices, and Security. There is a card on the API detail page (on the TAP GUI) that displays the summary of the scores. If the user wants to get more details of the scores, they can click on the 'more details' link and can get a detailed view.

The solution helps developers ensure that their APIs are more secure and robust, by providing feedback and recommendations early on in the software development lifecycle. Based on the feedback and recommendations, the dev can modify their API Specs and improve their scores, and hence improve the posture of their APIs. The solution also helps  DevOps / DevSecOps understand how well the APIs have been implemented.

When a workload is applied , an automated workflow using the supply chain leverages the API Auto Registration. The API Auto Registration Controller reconciles the APIx CR and updates the API entity in Tanzu Application Platform GUI to achieve the  automated API Scoring and validation of the API Specification.

![overview_workflow.png](assets/overview_workflow.png)
