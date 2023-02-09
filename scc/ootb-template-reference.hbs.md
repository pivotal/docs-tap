# Template Reference

- [Out of the Box Supply Chain Basic](ootb-supply-chain-basic.hbs.md)
- [Out of the Box Supply Chain Testing](ootb-supply-chain-testing.hbs.md)
- [Out of the Box Supply Chain Testing Scanning](ootb-supply-chain-testing-scanning.hbs.md)

## source-template

### Purpose
Creates an object to fetch source code and make that code available
to other objects in the supply chain. More details can be read in [Building from
Source](building-from-source.hbs.md).

### Supply Chain Use

[Out of the Box Supply Chain Basic](ootb-supply-chain-basic.hbs.md)
[Out of the Box Supply Chain Testing](ootb-supply-chain-testing.hbs.md)
[Out of the Box Supply Chain Testing Scanning](ootb-supply-chain-testing-scanning.hbs.md)

### Creates

The source-template creates one of three objects, either:
- GitRepository. Created if the workload has `.spec.source.git` defined.
- MavenArtifact. Created if the template is provided a value for the param `maven`
- ImageRepository. Created if the workload has `.spec.source.image` defined.

#### GitRepository

`GitRepository` makes source code from a particular commit available as a tarball in the
cluster. Other resources in the supply chain can then access that code. 

Parameters:

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>gitImplementation<code></td>
    <td>
      The library used to fetch source code.
      If not provided, TAP's default implementation will use <code>go-git</code>,
      which works with the providers currently supported by TAP: Github and Gitlab.
      An alternate value that may be used with other git providers is <code>libggit2</code>.
    </td>
    <td>
      <pre>
      - name: gitImplementation
        value: libggit2
      </pre>
    </td>
  </tr>

  <tr>
    <td><code>gitops_ssh_secret<code></td>
    <td>
      Name of the secret used to provide credentials for the Git repository.
      The secret with this name must exist in the same namespace as the <code>Workload</code>.
      The credentials must be sufficient to read the repository.
      If not provided, TAP will default to look for a secret named <code>git-ssh</code>.
      See <a href="git-auth.html">Git authentication</a>.
    </td>
    <td>
      <pre>
      - name: gitops_ssh_secret
        value: git-credentials
      </pre>
    </td>
  </tr>
</table>

> **Note** Some git providers, notably Azure DevOps, require you to use
> `libgit2` due to the server-side implementation providing support
> only for [git's v2 protocol](https://git-scm.com/docs/protocol-v2).
> For information about the features supported by each implementation, see
> [git implementation](https://fluxcd.io/flux/components/source/gitrepositories/#git-implementation)
> in the flux documentation.

For an example using the Tanzu CLI to create a Workload using GitHub as the provider of source code,
see [Create a workload from GitHub
repository](../cli-plugins/apps/create-workload.hbs.md#-create-a-workload-from-github-repository).

For information about GitRepository objects, see
[GitRepository](https://fluxcd.io/flux/components/source/gitrepositories/).

#### ImageRepository

`ImageRepository` makes the contents of a container image available as a tarball on the cluster.

Parameters:

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>serviceAccount<code></td>
    <td>
      Name of the service account, providing credentials to `ImageRepository` for fetching container images.
      The service account must exist in the same namespace as the Workload.
    </td>
    <td>
      <pre>
      - name: serviceAccount
        value: default
      </pre>
    </td>
  </tr>

</table>

For information about the ImageRepository resource, see [ImageRepository reference
docs](../source-controller/reference.hbs.md#imagerepository).

For information about how to use the Tanzu CLI to create a workload leveraging ImageRepository refer to
[Create a workload from local source
code](../cli-plugins/apps/create-workload.hbs.md#-create-a-workload-from-local-source-code).

> **Note** When using the Tanzu CLI to configure this `serviceAccount` parameter, use `--param serviceAccount=...`.
> (The similarly named `--service-account` flag sets a different value:
> the `spec.serviceAccountName` key in the Workload object.)

#### MavenArtifact

`MavenArtifact` makes a pre-built Java artifact available to as a tarball on the cluster.

While the `source-template` leverages the workload's `.spec.source` field when creating a
`GitRepository` or `ImageRepository` object, the creation of the `MavenArtifact` relies only on
parameters in the Workload.

Parameters:

<table>
  <tr>
    <th>Parameter name</th>
    <th>Meaning</th>
    <th>Example</th>
  </tr>

  <tr>
    <td><code>maven<code></td>
    <td>
      Points to the Maven artifact to fetch and the polling interval.
    </td>
    <td>
      <pre>
      - name: maven
        value:
          artifactId: springboot-initial
          groupId: com.example
          version: RELEASE
          classifier: sources         # optional
          type: jar                   # optional
          artifactRetryTimeout: 1m0s  # optional
      </pre>
    </td>
    <td><code>maven_repository_url<code></td>
    <td>
      Specifies the maven repository from which to fetch
    </td>
    <td>
      <pre>
      - name: maven_repository_url
        value: https://repo1.maven.org/maven2/
      </pre>
    </td>
    <td><code>maven_repository_secret_name<code></td>
    <td>
      Specifies the secret containing credentials necessary to fetch from the maven repository.
      The secret named must exist in the same workspace as the workload.
    </td>
    <td>
      <pre>
      - name: maven_repository_secret_name
        value: auth-secret
      </pre>
    </td>
  </tr>
</table>

For information about the custom resource, see [MavenArtifact reference
docs](../source-controller/reference.hbs.md#mavenartifact).

For information about how to use the custom resource with the `tanzu apps workload` CLI plug-in [Create a Workload from Maven repository
artifact](../cli-plugins/apps/create-workload.hbs.md#workload-maven).
