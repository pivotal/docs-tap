# Accelerator custom resource definition

The `Accelerator` custom resource definition (CRD) defines any accelerator resources to be made available to the Application Accelerator for VMware Tanzu system. It is a namespaced CRD, meaning that any resources created belong to a namespace. For the resource to be available to the Application Accelerator system, it must be created in the namespace that the Application Accelerator UI server is configured to watch.

The `Fragment` custom resource definition (CRD) defines any accelerator fragment resources to be made available to the Application Accelerator for VMware Tanzu system. It is a namespaced CRD, meaning that any resources created belong to a namespace. For the resource to be available to the Application Accelerator system, it must be created in the namespace that the Application Accelerator UI server is configured to watch.

## <a id="api-definitions"></a> API definitions

The `Accelerator` CRD is defined with the following properties:

| Property | Value |
| --- | --- |
| Name | Accelerator |
| Group | accelerator.apps.tanzu.vmware.com |
| Version | v1alpha1 |
| ShortName | acc |

## <a id="accelerator-crd-spec"></a> Accelerator CRD Spec
The `Accelerator` CRD _spec_ defined in the `AcceleratorSpec` type has the following fields:

| Field | Description | Required/Optional |
| --- | --- | --- |
| displayName | A short descriptive name used for an Accelerator. | Optional (*) |
| description | A longer description of an Accelerator. | Optional (*) |
| iconUrl | A URL for an image to represent the Accelerator in a UI. | Optional (*) |
| tags | An array of strings defining attributes of the Accelerator that can be used in a search. | Optional (*) |
| git | Defines the accelerator source Git repository. | Optional (***) |
| git.url | The repository URL, can be a HTTP/S or SSH address. | Optional (***) |
| git.ignore | Overrides the set of excluded patterns in the .sourceignore format (which is the same as .gitignore). If not provided, a default of `.git/` is used. | Optional (**) |
| git.interval | The interval at which to check for repository updates. If not provided it defaults to 10 min. There is an additional refresh interval (currently 10s) involved before accelerators may appear in the UI. There could be a 10s delay before changes are reflected in the UI.*| Optional (**) |
| git.ref | Git reference to checkout and monitor for changes, defaults to master branch. | Optional (**) |
| git.ref.branch | The Git branch to checkout, defaults to master. | Optional (**) |
| git.ref.commit | The Git commit SHA to checkout, if specified tag filters are ignored. | Optional (**) |
| git.ref.semver | The Git tag semver expression, takes precedence over tag. | Optional (**) |
| git.ref.tag | The Git tag to checkout, takes precedence over branch. | Optional (**) |
| git.secretRef | The secret name containing the Git credentials. For HTTPS repositories, the secret must contain user name and password fields. For SSH repositories, the secret must contain identity, identity.pub, and known_hosts fields. | Optional (**) |
| git.subPath | SubPath is the folder inside the git repository to consider as the root of the accelerator or fragment. Defaults at the root of the repository. | Optional |
| source | Defines the source image repository. | Optional (***) |
| source.image | Image is a reference to an image in a remote registry. | Optional (***) |
| source.imagePullSecrets | ImagePullSecrets contains the names of the Kubernetes Secrets containing registry login information to resolve image metadata. | Optional |
| source.interval | The interval at which to check for repository updates. | Optional |
| source.serviceAccountName | ServiceAccountName is the name of the Kubernetes ServiceAccount used to authenticate the image pull if the service account has attached pull secrets. | Optional |

The `Fragment` CRD is defined with the following properties:

| Property | Value |
| --- | --- |
| Name | Fragment |
| Group | accelerator.apps.tanzu.vmware.com |
| Version | v1alpha1 |
| ShortName | frag |

## <a id="fragment-crd-spec"></a> Fragment CRD Spec
The `Fragment` CRD _spec_ defined in the `FragmentSpec` type has the following fields:

| Field | Description | Required/Optional |
| --- | --- | --- |
| displayName | DisplayName is a short descriptive name used for a Fragment. | Optional |
| git | Defines the fragment source Git repository. | Required |
| git.url | The repository URL, can be a HTTP/S or SSH address. | Required |
| git.ignore | Overrides the set of excluded patterns in the .sourceignore format (which is the same as .gitignore). If not provided, a default of `.git/` is used. | Optional (**) |
| git.interval | The interval at which to check for repository updates. If not provided it defaults to 10 min.| Optional (**) |
| git.ref | Git reference to checkout and monitor for changes, defaults to master branch. | Optional (**) |
| git.ref.branch | The Git branch to checkout, defaults to master. | Optional (**) |
| git.ref.commit | The Git commit SHA to checkout, if specified tag filters are ignored. | Optional (**) |
| git.ref.semver | The Git tag semver expression, takes precedence over tag. | Optional (**) |
| git.ref.tag | The Git tag to checkout, takes precedence over branch. | Optional (**) |
| git.secretRef | The secret name containing the Git credentials. For HTTPS repositories, the secret must contain user name and password fields. For SSH repositories, the secret must contain identity, identity.pub, and known_hosts fields. | Optional (**) |
| git.subPath | SubPath is the folder inside the git repository to consider as the root of the accelerator or fragment. Defaults at the root of the repository. | Optional |

\* Any optional fields marked with an asterisk (*) are populated from a field of the same name in the `accelerator` definition in the `accelerator.yaml` file if that is present in the Git repository for the accelerator.

\*\* Any fields marked with a double asterisk (**) are part of the Flux GitRepository CRD that is documented in the Flux Source Controller [Git Repositories](https://fluxcd.io/docs/components/source/gitrepositories/) documentation.

\*\*\* Any fields marked with a triple asterisk (``***``) are optional but either `git` or `source` is required to specify the repository to use. If `git` is specified, the `git.url` is required, and if `source` is specified, `source.image` is required.

## <a id="excluding-files"></a>Excluding files

The `git.ignore` field defaults to `.git/`, which is different from the defaults provided by the Flux Source Controller GitRepository implementation. You can override this, and provide your own exclusions. For more information, see  [fluxcd/source-controller Excluding files](https://fluxcd.io/docs/components/source/gitrepositories/#excluding-files).
