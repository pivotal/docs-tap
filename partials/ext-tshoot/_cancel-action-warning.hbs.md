### Symptom

When running `Tanzu: Debug Start`, `Tanzu: Live Update Start`, or `Tanzu: Apply`, a quick-pick list
appears when there are multiple options.
If you cancel, by either pressing the ESC key or clicking outside the list, a warning notification
appears that says no workloads or Tiltfiles were found.

### Cause

GKE authentication was extracted into a separate plug-in and is no longer inside the Kubernetes client
or libraries.

### Solution

No action is needed. You can ignore this warning.