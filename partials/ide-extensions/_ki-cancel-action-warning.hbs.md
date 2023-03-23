### Symptom

When running `Tanzu: Debug Start`, `Tanzu: Live Update Start`, or `Tanzu: Apply`, a quick-pick list
appears when there are multiple options.
If you cancel, by either pressing the ESC key or clicking outside the list, a warning notification
appears that says no workloads or Tiltfiles were found.

### Cause

An extension bug is the cause.

### Solution

Upgrade to Tanzu Application Platform v1.3.2.
If you remain on Tanzu Application Platform v1.3.0, you can ignore this warning.
There is no further action to take.
