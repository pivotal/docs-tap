# Logs messages and reasons

Log messages follow a JSON format. Each log can contain the following keys:

| Key        | Description |
| ---------- | ----------- |
| level      | Log level |
| ts         | Timestamp |
| logger     | Name of the logger component which provided the log message |
| msg        | Log message |
| object     | Relevant object that triggered the log message |
| error      | A message for the error.<br> Only present with "error" log level |
| stacktrace | A stacktrace for where the error occured.<br> Only present with error level |

The possible log messages the webhook emits and their explanations are summarized in the following table:

<table>
  <thead>
    <th>Log Message</th>
    <th>Explanation</th>
  </thead>
    <tr>
        <td><code>clusterimagepolicies.signing.apps.tanzu.vmware.com "image-policy" not found. Image policy enforcement was not applied.</code></td>
        <td>The Image Policy was not created in the cluster and the webhook did not check any container images for signatures.</td>
    </tr>
    <tr>
        <td><code>&lt;Namespace&gt; is excluded. The ImagePolicy will not be applied.</code></td>
        <td>
          <ul>          
            <li>
              An image policy is present in the cluster.
            </li>
            <li>
              The namespace is present in the <code>verification.exclude.resources.namespaces</code> property of the policy.
            </li>
            <li>
              Any container images trying to get created in this namespace will not be checked for signatures.
            </li>                        
          </ul>        
        </td>
    </tr>
    <tr>
        <td><code>Could not verify against any image policies for container image: &lt;ContainerImage&gt;.</code></td>
        <td>
          <ul>          
            <li>
              An image policy is present in the cluster.
            </li>
            <li>
              The <code>AllowUnMatchedImages</code> flag is set to <code>false</code> or is absent.
            </li>
            <li>
              The namespace is not excluded.
            </li>
            <li>
              Image of the container being installed does not match any pattern present in the policy and was rejected by the webhook.
            </li>                         
          </ul>                
        </td>
    </tr>
    <tr>
        <td><code>&lt;ContainerImage&gt; did not match any image policies. Container will be created as AllowUnmatchedImages flag is true.</code></td>
        <td>
          <ul>          
            <li>
              An image policy is present in the cluster.
            </li>
            <li>
              The <code>AllowUnMatchedImages</code> flag is set to <code>true</code>.
            </li>
            <li>
              The namespace you are installing your resource in is not excluded.
            </li>
            <li>
              Image of the container being installed does not match any pattern present in the policy and was allowed to be created.
            </li>                         
          </ul>           
        </td>
    </tr>
    <tr>
        <td><code>failed to find signature for image.</code></td>
        <td>
          <ul>          
            <li>
              An image policy is present in the cluster.
            </li>
            <li>
              The namespace you are installing your resource in is not excluded.
            </li>
            <li>
              Image of the container being installed matches a pattern in the policy.
            </li>
            <li>
              The webhook was not able to verify the signature.
            </li>                         
          </ul>           
        </td>
    </tr>
    <tr>
        <td><code>The image: &lt;ContainerImage&gt; is not signed.</code></td>
        <td>
          <ul>          
            <li>
              An image policy is present in the cluster.
            </li>
            <li>
              The namespace you are installing your resource in is not excluded.
            </li>
            <li>
              Image of the container being installed matches a pattern in the policy.
            </li>
            <li>
              The image is not signed.
            </li>                         
          </ul>    
        </td>
    </tr>
    <tr>
        <td><code>failed to decode resource</code></td>
        <td>
          <ul>          
            <li>
              The resource type is not supported.
            </li>
            <li>
              Currently supported v1 versions of:
                  <ul>          
                    <li>
                      Pod
                    </li>
                    <li>
                      Deployment
                    </li>
                    <li>
                      StatefulSet
                    </li>
                    <li>
                      DaemonSet
                    </li>
                    <li>
                      ReplicaSet
                    </li>
                    <li>
                      Job
                    </li>
                    <li>
                      CronJob (and v1beta1)
                    </li>
                  </ul>    
            </li>
          </ul>    
        </td>
    </tr>
    <tr>
        <td><code>failed to verify</code></td>
        <td>
          <ul>          
            <li>
              An image policy is present in the cluster.
            </li>
            <li>
              The namespace you are installing your resource in is not excluded.
            </li>
            <li>
              Image of the container being installed matches a pattern.
            </li>
            <li>
              The webhook can not verify the signature.
            </li>                         
          </ul>            
        </td>
    </tr>
    <tr>
        <td>
          <code>
            matching pattern: &lt;Pattern&gt; against image &lt;ContainerImage&gt;<br>
            matching registry patterns: [{<Image NamePattern, Keys, SecretRef>}]
          </code>
        </td>
        <td>
          <ul>          
            <li>
              Provide the pattern that matches the container image.
            </li>
            <li>
              Provide the corresponding <code>Image</code> configuration from the <code>ClusterImagePolicy</code> that matches the container image.
            </li>                       
          </ul>           
        </td>
    </tr>
    <tr>
        <td><code>service account not found</code></td>
        <td>
          <ul>          
            <li>
              The fallback service account, “image-policy-registry-credentials”, was not found in the namespace of which the webhook is installed.
            </li>
            <li>
              The fallback service account is deprecated and was originally purposed to storing <code>imagePullSecrets</code> for container images and their co-located <code>cosign</code> signatures.
            </li>                       
          </ul>           
        </td>
    </tr>
    <tr>
        <td><code>unmatched image policy: &lt;ContainerImage&gt;</code></td>
        <td>Container image does not match any policy image patterns.</td>
    </tr>                    
</table>
