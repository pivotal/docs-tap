# Overview of workloads

This topic provides you with an overview of workload types in Tanzu Application Platform
(commonly known as TAP).

## Workload features

Tanzu Application Platform allows you to quickly build and test applications regardless of your
familiarity with Kubernetes.

You can turn source code into a workload that runs in a container with a URL.
You can also use supply chains to build applications that process work from a message queue,
or provide arbitrary network services.

A workload allows you to choose application specifications, such as
repository location, environment variables, service binding, and so on.
For more information about workload creation and management, see
[Commands Details](../cli-plugins/apps/command-reference/commands-details.hbs.md).

The Out of the Box Supply Chains support a range of workload types, including scalable web
applications (`web`), traditional application servers (`server`), background applications
(`worker`), and serverless functions. You can use a collection of workloads of different types to
deploy microservices that function as a logical application, or deploy your entire application as a
single monolith.

If you build your own supply chains, you can define additional deployment methods beyond those
included in the Out of the Box Supply Chain templates.

## <a id="types"></a> Available Workload types

When using the Out of the Box Supply Chain, the `apps.tanzu.vmware.com/workload-type` annotation
selects which style of deployment is suitable for your application. The valid values are:

<table>
<thead>
<tr>
  <th>Type</th>
  <th>Description</th>
  <th>Indicators</th>
</tr>
</thead>
<tbody>
<tr>
  <td><code>web<code></td>
  <td>Scalable Web Applications</td>
  <td>
    <ul>
      <li>Scales based on request load</li>
      <li>Automatically exposed by means of HTTP Ingress</li>
      <li>Does not perform background work</li>
      <li>Works with Service Bindings</li>
      <li>Stateless</li>
      <li>Quick startup time</li>
    </ul>
  </td>
</tr>
<tr>
  <td><code>server<code></td>
  <td>Traditional Applications</td>
  <td>
    <ul>
      <li>Provides HTTP or TCP services on the network</li>
      <li>Exposed by means of external Ingress or LoadBalancer settings</li>
      <li>Might perform background work from a queue</li>
      <li>Works with Service Bindings</li>
      <li>Fixed scaling, no disk persistence</li>
      <li>Startup time not an issue</li>
    </ul>
  </td>
</tr>
<tr>
  <td><code>worker<code></td>
  <td>Background Applications</td>
  <td>
    <ul>
      <li>Does not provide network services</li>
      <li>Not exposed externally as a network service</li>
      <li>Performs background work from a queue</li>
      <li>Works with Service Bindings</li>
      <li>Fixed scaling, no disk persistence</li>
      <li>Startup time not an issue</li>
    </ul>
  </td>
</tr>
</tbody>
</table>