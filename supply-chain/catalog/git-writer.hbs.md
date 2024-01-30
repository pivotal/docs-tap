# GIT Writer Component

## Description

The GIT Writer component writes carvel package configuration to a git repository. This enables a supply chain to deliver built packages to a GitOps repository. This component has 2 variants: 
 - `git-writer` - make commits directly to a branch
 - `git-writer-pr` - makes commits to a new branch and open a pull request.


## API

_Component Input_: `package`

_Configuration_: `spec.GitOps` configuration is used configure the GIT writer component.

_Component Output_: `gitops`

_Secrets_: Ensure an appropriate secret is added to the service account to allow for git authentication.

### Configuring the `git-writer` component:
```
spec:
    gitOps:
    url:      # https URL of the git repository
    branch:   # branch to commit to
    subPath:  # subpath within repository to write to
```

### Configuring the `git-writer-pr` component:
```
spec:
    gitOps:
    url:          # https URL of the git repository
    baseBranch:   # branch to base the merge request off
    subPath:      # subpath within repository to write to
```


## Dependencies

* Supply Chain
* Supply Chain Catalog
* Tekton
* Carvel Package Component

## Input Description

The GIT Writer Component takes a `package` input from some earlier component in the supply chain and writes it to a GIT commit. This can be done either as a direct commit to a branch using `git-writer`, or as a pull request using `git-writer-pr`.

The component is agnostic of the packaging format and commits all files in the package input.

## Output Description

The GIT Writer Component produces a `gitops` output which contains the following details of the commit/PR:

- `url` URL to the pull request (`git-writer-pr`), or the repository URL (`git-writer`)
- `digest` SHA of the git commit.