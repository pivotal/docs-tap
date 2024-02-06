# GIT Writer Component

This topic describes the GIT Writer component.

## Description

The GIT Writer component writes Carvel package configuration to a Git repository. This enables
a supply chain to deliver built packages to a GitOps repository. This component has 2 variants:

- `git-writer`:  Makes commits directly to a branch.
- `git-writer-pr` Makes commits to a new branch and opens a pull request.

## API

Component Input: `package`

Configuration: `spec.GitOps` configuration is used to configure the GIT writer component.

Component Output: `gitops`

Secrets: Ensure an appropriate secret is added to the service account to allow for Git authentication.

### Configure the `git-writer` component

```console
spec:
    gitOps:
    url:      # https URL of the git repository
    branch:   # branch to commit to
    subPath:  # subpath within the repository to write to
```

### Configure the `git-writer-pr` component:

```console
spec:
    gitOps:
    url:          # https URL of the git repository
    baseBranch:   # branch to base the merge request off
    subPath:      # subpath within repository to write to
```

## Dependencies

- Supply Chain
- Supply Chain Catalog
- Tekton
- Carvel Package Component

## Input Description

The GIT Writer component takes a `package` input from some earlier component in the supply chain
and writes it to a `Git commit`. This can be done either as a direct commit to a branch using
`git-writer`, or as a pull request using `git-writer-pr`.

The component is agnostic of the packaging format and commits all files in the package input.

## Output Description

The GIT Writer component produces a `gitops` output which contains the following details of the
commit or PR:

- `url` URL to the pull request (`git-writer-pr`), or the repository URL (`git-writer`)
- `digest` SHA of the git commit.
