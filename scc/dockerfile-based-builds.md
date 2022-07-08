# Dockerfile-based builds

For any source-based supply chains, that is supply chains that are not taking a
pre-built image, when you specify the new `dockerfile` parameter in a Workload
the builds switch from using Kpack to using Kaniko. Kaniko is an open-source tool
for building container images from a Dockerfile even without privileged root
access.

<table>
  <tr>
    <th>parameter name</th>
    <th>meaning</th>
    <th>example</th>
  </tr>

  <tr>
    <td><code>dockerfile<code></td>
    <td>relative path to the Dockerfile file in the build context</td>
    <td><pre>./Dockerfile</pre></td>
  </tr>

  <tr>
    <td><code>docker_build_context<code></td>
    <td>relative path to the directory where the build context is</td>
    <td><pre>.</pre></td>
  </tr>

  <tr>
    <td><code>docker_build_extra_args<code></td>
    <td>
      list of flags to pass directly to Kaniko (such as providing arguments,
      and so on to a build)
    </td>
    <td><pre>- --build-arg=FOO=BAR</pre></td>
  </tr>
</table>


For example, assuming that you want to build a container image our of a
repository named `github.com/foo/bar` whose Dockerfile resides in the root of
that repository, you can switch from using Kpack to building from that
dockerfile by passing the `dockerfile` parameter:

```console
$ tanzu apps workload create foo \
  --git-repo https://github.com/foo/bar \
  --git-branch dev \
  --param dockerfile=./Dockerfile

  Create workload:
        1 + |---
        2 + |apiVersion: carto.run/v1alpha1
        3 + |kind: Workload
        4 + |metadata:
        5 + |  name: foo
        6 + |  namespace: default
        7 + |spec:
        8 + |  params:
        9 + |  - name: dockerfile
       10 + |    value: ./Dockerfile
       11 + |  source:
       12 + |    git:
       13 + |      ref:
       14 + |        branch: dev
       15 + |      url: https://github.com/foo/bar
```

Similarly, if the context to be used for the build must be set to a different
directory within the repository, you can make use of the `docker_build_context`
to change that:

```
$ tanzu apps workload create foo \
  --git-repo https://github.com/foo/bar \
  --git-branch dev \
  --param dockerfile=MyDockerfile \
  --param docker_build_context=./src
```

>**Note:** this feature has no platform operator configurations to be passed
through `tap-values.yaml`, but if `ootb-supply-chain-*.registry.ca_cert_data` or
`shared.ca_cert_data` is configured in `tap-values`, the certificates
are considered when pushing the container image.
