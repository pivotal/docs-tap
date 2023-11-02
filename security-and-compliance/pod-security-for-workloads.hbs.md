# Configuring Pod Security for Workloads

This topic describes the various configuration options that are available for applying security 
contexts to pods that are responsible for running supply chain workloads. To apply security contexts
to pods responsible for running supply chain workloads, organizations can leverage various
configuration options. With this approach, security policies can be configured and specific 
security requirements of applications running on a Kubernetes cluster can be met.

## <a id="config-options"></a> Configuration options

There are two methods to provide pod security context for running supply chain workloads. 

- Platform operators can set a default security context for all supply chain workloads via 
TAP values YAML file during TAP installation or upgrade. 

- App operators can set workload security context via the workload parameter name 
"security-context" which overrides the default set by the platform operator. 

## <a id="platform-default"></a> Setting a default security context

A default workload security context can be optionally configured using tap-values.yaml.
The YAML file lists the security context configurable fields. 

```yaml
ootb_templates:
  podintent_secuirty_context:
    runAsGroup: # integer - The GID to run the entrypoint of the container process.
    runAsNonRoot: # boolean - Indicates that the container must run as a non-root user.
    windowsOptions:
      runAsUserName: # string - The UserName in Windows to run the entrypoint of the container process.
      gmsaCredentialSpec: # string - GMSACredentialSpec is where the GMSA admission webhook inlines the contents of the GMSA credential spec named by the GMSACredentialSpecName field.
      gmsaCredentialSpecName: # string - GMSACredentialSpecName is the name of the GMSA credential spec to use.
      hostProcess: # boolean - HostProcess determines if a container should be run as a 'Host Process' container.
    allowPrivilegeEscalation: # boolean - AllowPrivilegeEscalation controls whether a process can gain more privileges than its parent process.
    capabilities:
      add: # string array - Added capabilities
      drop: # string array - Removed capabilities
    readOnlyRootFilesystem: # boolean - Whether this container has a read-only root filesystem.
    seLinuxOptions:
      level: # string - Level is SELinux level label that applies to the container.
      role: # string - Role is a SELinux role label that applies to the container.
      type: # string - Type is a SELinux type label that applies to the container.
      user: # string - User is a SELinux user label that applies to the container.
    seccompProfile:
      localhostProfile: # string - LocalhostProfile indicates a profile defined in a file on the node should be used. The profile must be preconfigured on the node to work. Must be a descending path, relative to the kubelet's configured seccomp profile location. Must only be set if type is "Localhost".
      type: # string - Type indicates which kind of seccomp profile will be applied. Valid options are, Localhost - a profile defined in a file on the node should be used. RuntimeDefault - the container runtime default profile should be used. Unconfined - no profile should be applied.
    privileged: # boolean - Run container in privileged mode. Defaults to false.
    procMount: # string - procMount denotes the type of proc mount to use for the containers.
```

To view the possible configuration setting for the `ootb-templates` package,
please see [Installing out of the box templates](../scc/install-ootb-templates.hbs.md)

## <a id="workload-config"></a> Setting a Workload security context

Suppply chain workload security context can be optionally configured using the workload parameter 
name "security-context". Security context configured via workload *overrides* deafult security 
context defined in the TAP values YAML.

### <a id="workload-config-yaml"></a> Sample workload YAML with security context 

```yaml
apiVersion: carto.run/v1alpha1
kind: Workload
metadata:
  name: tanzu-java-web-app
  labels:
    apps.tanzu.vmware.com/workload-type: web
    app.kubernetes.io/part-of: tanzu-java-web-app
spec:
  params:
  - name: annotations
    value:
      autoscaling.knative.dev/minScale: "1"
  - name: security-context
    value: 
      allowPrivilegeEscalation: false
      runAsNonRoot: true
      runAsUser: 333
      seccompProfile:
        type: RuntimeDefault
      capabilities:
        drop:
        - ALL
  source:
    git:
      url: https://github.com/vmware-tanzu/application-accelerator-samples
      ref:
        tag: tap-1.7.0
    subpath: tanzu-java-web-app
```

Alternatively, suppply chain workload security context can be set when creating workload using the 
Tanzu CLI. For example:

```console
tanzu apps workload create tanzu-java-web-app -n workspace \
  --git-repo https://github.com/vmware-tanzu/application-accelerator-samples \
  --git-tag tap-1.7.0 \
  --type web \
  --label app.kubernetes.io/part-of=tanzu-java-web-app \
  --sub-path tanzu-java-web-app \
  --param-yaml security-context="{"runAsUser":"333"}"
```
