### Symptom

When connecting to Google's GKE clusters, an error appears with the text
`WARNING: the gcp auth plugin is deprecated in v1.22+, unavailable in v1.25+; use gcloud instead.`

### Cause

GKE authentication was extracted into a separate plug-in and is no longer inside the Kubernetes
client or libraries.

### Solution

Download and configure the GKE authentication plug-in. For instructions, see the
[Google documentation](https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke).