# Known Issues for Crossplane

## The crossplane validatingwebhookconfiguration does not get removed when uninstalling the Crossplane Package

The crossplane Package deploys a validatingwebhookconfiguration named `crossplane` during installation. This resource does not get deleted during uninstallation of the Package. It can be deleted manually by running `kubectl delete validatingwebhookconfiguration crossplane`
