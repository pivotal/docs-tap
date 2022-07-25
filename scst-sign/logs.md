# Logs messages and reasons

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
        <td><code>&lt;namespace&gt; is excluded. The ImagePolicy will not be applied.</code></td>
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
        <td><code>Could not verify against any image policies for container image: &lt;container image&gt;.</code></td>
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
        <td><code>&lt;container image&gt; did not match any image policies. Container will be created as AllowUnmatchedImages flag is true.</code></td>
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
        <td><code>The image: &lt;container image&gt; is not signed.</code></td>
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
</table>
