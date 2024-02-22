# Installing Supply Chains manually (Not Recommended)

{{> 'partials/supply-chain/beta-banner' }} 

There are three additional packages you'll need to install that are bundled with the TAP release, but not part of any profile.

* `supply-chain.apps.tanzu.vmware.com`
* `supply-chain-catalog.apps.tanzu.vmware.com`
* `managed-resource-controller.apps.tanzu.vmware.com`

And the following component packages if you're authoring a supply chain:

* `source.component.apps.tanzu.vmware.com`
* `conventions.component.apps.tanzu.vmware.com`
* `buildpack-build.component.apps.tanzu.vmware.com`
* `alm-catalog.component.apps.tanzu.vmware.com`
* `git-writer.component.apps.tanzu.vmware.com`
* `trivy-scanning.component.apps.tanzu.vmware.com`

To install these, run the following script:

```shell
export SUPPLY_CHAIN_VERSION=$(kubectl get package -n tap-install -o=jsonpath='{.items[?(@.spec.refName=="supply-chain.apps.tanzu.vmware.com")].spec.version}')
echo $SUPPLY_CHAIN_VERSION

tanzu package install supply-chain \
  --package supply-chain.apps.tanzu.vmware.com \
  --version $SUPPLY_CHAIN_VERSION \
  --namespace tap-install

export SUPPLY_CHAIN_CATALOG_VERSION=$(kubectl get package -n tap-install -o=jsonpath='{.items[?(@.spec.refName=="supply-chain-catalog.apps.tanzu.vmware.com")].spec.version}')
echo $SUPPLY_CHAIN_CATALOG_VERSION

tanzu package install supply-chain-catalog \
  --package supply-chain-catalog.apps.tanzu.vmware.com \
  --version $SUPPLY_CHAIN_CATALOG_VERSION \
  --namespace tap-install

export MANAGED_RESOURCE_VERSION=$(kubectl get package -n tap-install -o=jsonpath='{.items[?(@.spec.refName=="managed-resource-controller.apps.tanzu.vmware.com")].spec.version}')
echo $MANAGED_RESOURCE_VERSION

tanzu package install managed-resource-controller \
  --package managed-resource-controller.apps.tanzu.vmware.com \
  --version $MANAGED_RESOURCE_VERSION \
  --namespace tap-install

export SOURCE_COMPONENT_VERSION=$(kubectl get package -n tap-install -o=jsonpath='{.items[?(@.spec.refName=="source.component.apps.tanzu.vmware.com")].spec.version}')
echo $SOURCE_COMPONENT_VERSION

tanzu package install source-component \
  --package source.component.apps.tanzu.vmware.com \
  --version $SOURCE_COMPONENT_VERSION \
  --namespace tap-install 

export CONVENTIONS_COMPONENT_VERSION=$(kubectl get package -n tap-install -o=jsonpath='{.items[?(@.spec.refName=="conventions.component.apps.tanzu.vmware.com")].spec.version}')
echo $CONVENTIONS_COMPONENT_VERSION

tanzu package install conventions-component \
  --package conventions.component.apps.tanzu.vmware.com \
  --version $CONVENTIONS_COMPONENT_VERSION \
  --namespace tap-install  
  
export BUILDPACK_COMPONENT_VERSION=$(kubectl get package -n tap-install -o=jsonpath='{.items[?(@.spec.refName=="buildpack-build.component.apps.tanzu.vmware.com")].spec.version}')
echo $BUILDPACK_COMPONENT_VERSION

tanzu package install buildpack-build-component \
  --package buildpack-build.component.apps.tanzu.vmware.com \
  --version $BUILDPACK_COMPONENT_VERSION \
  --namespace tap-install
  
export ALM_CATALOG_COMPONENT_VERSION=$(kubectl get package -n tap-install -o=jsonpath='{.items[?(@.spec.refName=="alm-catalog.component.apps.tanzu.vmware.com")].spec.version}')
echo $ALM_CATALOG_COMPONENT_VERSION

tanzu package install alm-catalog-component \
  --package alm-catalog.component.apps.tanzu.vmware.com \
  --version $ALM_CATALOG_COMPONENT_VERSION \
  --namespace tap-install 

export GIT_WRITER_COMPONENT_VERSION=$(kubectl get package -n tap-install -o=jsonpath='{.items[?(@.spec.refName=="git-writer.component.apps.tanzu.vmware.com")].spec.version}')
echo $GIT_WRITER_COMPONENT_VERSION

tanzu package install git-writer-component \
  --package git-writer.component.apps.tanzu.vmware.com \
  --version $GIT_WRITER_COMPONENT_VERSION \
  --namespace tap-install 
```
