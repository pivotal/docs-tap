# Configuring Envoy for Contour

This topic tells you how to configure the Envoy for Contour in Tanzu 
Application Platform (commonly known as TAP).

By default, Tanzu Application Platform v1.7 installs Contour's Envoy pods as a 
`Deployment` with 2 replicas instead of a `DaemonSet`. When switching from DaemonSet to Deployment, the Envoy pods must be deleted and recreated. As a result, **there will be downtime during the update**.

Without intervention, this will happen when upgrading to TAP v1.7.

Additionally, when running as a Deployment, Contour includes affinity rules such that no Envoy pod should run on the same node as another Envoy pod. This essentially mimics the DaemonSet behavior, without requiring a pod on every node. This also means that your cluster must have as many nodes as replicas are desired for an Envoy Deployment.

There are a couple options to avoid this downtime.

## <a id="daemonset"></a> Keep Running the Envoy Pods as a `DaemonSet`

The easiest way to avoid downtime is to keep running Envoy as a DaemonSet in TAP v1.7 and beyond.

To do this, you must update your values file by adding `contour.envoy.workload.type` and setting it to `DaemonSet` _before performing the upgrade_:
  
```yaml
contour:
  envoy:
    workload:
      type: DaemonSet
```

## <a id="deployment"></a> Configure the Envoy pods as a `Deployment`

Currently, we do not have a built in way to switch from `DaemonSet` to `Deployment` while avoiding downtime.

However, by using overlays, we can provide a mitigation that forces Kapp Controller to spin up the new Envoy Deployment pods before deleting the DaemonSet pods, resulting in at least 1 Envoy up at all times during the update.

### Assumptions

- You have a cluster with TAP 1.6.x installed
- You cluster currently has Envoy running as a DaemonSet
  -  This guide **does not** cover going from Deployment to DaemonSet
- You can create overlays as secrets
- You can update the values in your tap-values file
- Host ports are disabled for Contour Envoy
  - This is the default for TAP. Unless you’ve manually changed this, you should be okay.
    If you have changed it, please set `contour.envoy.hostPorts.enable: false` in your `tap-values.yaml` file.

### Procedure

1. Create an overlay to remove the affinity settings on the Deployment

   Because we want to create the Deployment pods before we delete the DaemonSet pods, these affinity rules will prevent the Deployment pods from being scheduled, since there is already an Envoy on every node. We must remove them.

   The overlay file should look like:

   ```yaml
   #! filename: remove-affinity.yaml

   #@ load("@ytt:overlay", "overlay")

   #@overlay/match by=overlay.subset({"kind": "Deployment", "metadata": {"name": "envoy"}}), expects=1
   ---
   spec:
     template:
       spec:
         #@overlay/remove missing_ok=True
         affinity:
   ```

   You can create a Secret from the file like this:

   ```
   kubectl create secret generic contour-remove-affinity --from-file=remove-affinity.yaml -n tap-install
   ```

2. Create an overlay to provide custom Kapp config that forces Deployments to be created before DaemonSets get deleted

   The overlay file will look like this:
 
   ```yaml
   #! filename: custom-kapp-config.yaml
   ---
   apiVersion: kapp.k14s.io/v1alpha1
   kind: Config

   changeGroupBindings:
   - name: change-groups.kapp.k14s.io/deployments
      resourceMatchers: &deploymentServiceMatcher
      - apiGroupKindMatcher: {kind: Deployment, apiGroup: apps}

   - name: change-groups.kapp.k14s.io/daemonsets
      resourceMatchers:
      - apiGroupKindMatcher: {kind: DaemonSet, apiGroup: apps}

   changeRuleBindings:
   - rules:
      - "upsert before deleting change-groups.kapp.k14s.io/daemonsets"
      resourceMatchers: *deploymentServiceMatcher
   ```

   You can create a Secret from the file like this:
   
   ```
   kubectl create secret generic contour-kapp-config --from-file=custom-kapp-config.yaml -n tap-install
   ```

3. Update your `tap-values.yaml` file with the new configuration and overlays

   Your `tap-values.yaml` file should contain these snippets:
   
   ```yaml
   ...
   contour:
     envoy:
       workload:
         type: Deployment
         replicas: 2 #! If your cluster has many nodes, consider increasing this number at least initially. You can trim down later as you find out what works best for your environment.
   
   ...
   package_overlays:
   - name: contour
     secrets:
     - name: contour-kapp-config
     - name: contour-remove-affinity
   ```

4. Preform the update to your TAP install

   ```
   tanzu package installed update tap -p tap.tanzu.vmware.com -v $TAP_VERSION  --values-file tap-values.yaml -n tap-install
   ```

5. (Optional) Bring the affinity rules back

   If you wish restore the affinity rules on the Envoy Deployment, simply remove the `contour-remove-affinity` overlay from your `tap-values.yaml` file, and update again.

   This will cause the Deployment to roll out new pods, so be mindful of how many replicas you have. Fewer replicas will increase the likelyhood of a disruption in service as the pods are rolled out.