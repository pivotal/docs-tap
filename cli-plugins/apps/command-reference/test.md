# test

test

<details><summary>Example</summary>

```console
tanzu apps workload apply tanzu-java-web-app --git-repo https://github.com/vmware-tanzu/application-accelerator-samples --sub-path tanzu-java-web-app --git-tag tap-1.5.0 --type web --annotation tag=tap-1.5.0 --annotation name="Tanzu Java Web"
🔎 Create workload:
    1 + |---
    2 + |apiVersion: carto.run/v1alpha1
    3 + |kind: Workload
    4 + |metadata:
    5 + |  labels:
    6 + |    apps.tanzu.vmware.com/workload-type: web
    7 + |  name: tanzu-java-web-app
    8 + |  namespace: default
    9 + |spec:
   10 + |  params:
   11 + |  - name: annotations
   12 + |    value:
   13 + |      name: Tanzu Java Web
   14 + |      tag: tap-1.5.0
   15 + |  source:
   16 + |    git:
   17 + |      ref:
   18 + |        tag: tap-1.5.0
   19 + |      url: https://github.com/vmware-tanzu/application-accelerator-samples
   20 + |    subPath: tanzu-java-web-app
```

</details>
