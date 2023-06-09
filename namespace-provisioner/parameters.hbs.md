# Namespace Provisioner reference

## <a id='namespace-parameters'></a>Namespace parameters

When managing multiple developer namespaces in a cluster, it is often necessary to customize each namespace individually. The namespace provisioner, in controller mode, offers a feature that enables the addition of parameters through labels and annotations. In GitOps mode, you can easily configure these parameters in the GitOps file. For more detailed information, please refer to the documentation on [customizing label and annotation prefixes ](customize-installation.hbs.md#con-custom-label)for more information..

To add a parameter to a specific namespace, you can label or annotate it using either the default prefix or a custom-defined prefix. The format for specifying the parameter is as follows: `<prefix>/<parameter-key>=<parameter-value>`.

>**Caution** If a parameter is initially created through annotations and later a label with the same key is used, the annotation will be overwritten.

Please note the following

- The parameter key can be a single string or a pseudo JSON-path structure (e.g. `kye1.inner-key1.inner-key3.inner-key4`) which will be translated into a structured format in the values
- The label value can only be a string
- If you need to pass a list or another object as the parameter value, annotations should be used instead. Annotations support using `[]` to define lists and `{}` to define objects
- All parameters created via labels and annotations can be utilized when using templates for resources in ytt `additional_sources` from `data.values`

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

2. To add a list of objects

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

3. Simple key-value

   ```bash
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

4. Object as value

   ```bash
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

The namespace provisioner reserves certain parameters for its use. The following is a list of parameters used by the namespace provisioner, which apply to both the `default_parameters` in TAP values and the namespace parameters through labels and annotations.:

- `limits` (*object*): Limits parameter is used to configure the the LimitRange  (see [Deactivate LimitRange Setup](use-case4.hbs.md#custom-lr))
- `skip_limit_range` (*boolean*): Flag to determine if the LimitRange should be created (see [Deactivate LimitRange Setup](use-case4.hbs.md#deactivate-lr))
- `skip_grype` (*boolean*): Flag to determine if Grype scanner resources are going to be created (see [Deactivate Grype install](use-case4.hbs.md#deactivate-grype))
- `supply_chain_service_account` (*object*): Contain the secrets and imagePullSecrets to be added to the Supply Chain ServiceAccount (see [Customize service accounts](use-case4.hbs.md#customize-sa))
- `delivery_service_account` (*object*): Contain the secrets and imagePullSecrets to be added to the delivery ServiceAccount (see [Customize service accounts](use-case4.hbs.md#customize-sa))
