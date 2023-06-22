# Namespace parameters

This topic tells you how to customize namespaces in controller mode in Tanzu Application Platform (commonly known as TAP).

When managing multiple developer namespaces in a cluster, it is often necessary to customize each
namespace individually. To customize a namespace in controller mode, add parameters to a namespace
through labels and annotations using either the default prefix or a custom-defined prefix.

In GitOps mode, you can configure these parameters in the GitOps file. For more information, see
[Customize the label and annotation prefixes that controller watches](customize-installation.hbs.md#con-custom-label).

>**Caution** If a parameter is initially created through annotations and later a label with the same
key is used, the annotation is overwritten.

## Parameter key

- The format for specifying the parameter is: `<prefix>/<parameter-key>=<parameter-value>`.
- The parameter key can be a single string or a pseudo JSON-path structure, for example,
`kye1.inner-key1.inner-key3.inner-key4`.  This is translated into a structured format in the values.
- The label value can only be a string.
- If you need to pass a list or another object as the parameter value, annotations should be used
instead. Annotations support using `[]` to define lists and `{}` to define objects
- All parameters created with labels and annotations can be utilized when using templates for
resources in ytt `additional_sources` from `data.values`.

Examples:

1. To define a list of tools used by the namespace

   ```bash
   kubectl annotate ns dev param.nsp.tap/project.tools='["git", "maven"]'
   ```

   The `desired-namespaces` ConfigMap will look like:

   ```yaml
   #@data/values
   ---
   namespaces:
   - name: dev
     project:
       tools:
       - git
       - maven
   ```

2. To add a list of objects:

   ```bash
   kubectl annotate ns dev param.nsp.tap/volume.claims='[{"name": "logs", "mountPath": "/var/logs/app"}, {"name": "truststore", "mountPath": "/opt/app/ssl"}]
   ```

   The `desired-namespaces` ConfigMap will look like:

   ```yaml
   #@data/values
   ---
   namespaces:
   - name: dev
     volume:
       claims:
       - name: logs
       mountPath: /var/logs/app
       - name: truststore
       mountPath: /opt/app/ssl
   ```

3. Simple key-value:

   ```console
   kubectl annotate ns dev param.nsp.tap/scanpolicy=relaxed
   ```

   The `desired-namespaces` ConfigMap will look like:

   ```yaml
   #@data/values
   ---
   namespaces:
   - name: dev
     scanpolicy: relaxed
   ```

4. Object as value:

   ```console
   kubectl annotate ns dev param.nsp.tap/maven.values='{"username":"user", "password":"my-pass","repo":"myrepo","version":"0.1.1-alpha.0"}'
   ```

   The `desired-namespaces` ConfigMap will look like:

   ```yaml
   #@data/values
   ---
   namespaces:
   - name: dev
     maven:
       values:
         username: user
         password: my-pass
         repo: myrepo
         Version: 0.1.1-alpha.0
   ```

## Reserved Namespace Parameters

Namespace Provisioner reserves certain parameters for its use. The following is a list of parameters
used by the Namespace Provisioner, which apply to both the `default_parameters` in TAP values and
the namespace parameters through labels and annotations:

- `limits` (*object*): Use to configure the LimitRange. For more information, see
[Deactivate LimitRange Setup](use-case4.hbs.md#custom-lr).
- `skip_limit_range` (*boolean*): Use to determine if the LimitRange should be created. For more
information, see [Deactivate LimitRange Setup](use-case4.hbs.md#deactivate-lr).
- `skip_grype` (*boolean*): Use to determine if Grype scanner resources are going to be created.
For more information, see [Deactivate Grype install](use-case4.hbs.md#deactivate-grype).
- `supply_chain_service_account` (*object*): Contains the secrets and imagePullSecrets to be added
to the Supply Chain ServiceAccount. For more information, see [Customize service accounts](use-case4.hbs.md#customize-sa).
- `delivery_service_account` (*object*): Contains the secrets and imagePullSecrets to be added to
the delivery ServiceAccount. For more information, see [Customize service accounts](use-case4.hbs.md#customize-sa).
