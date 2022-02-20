# TrainingPortal resource

The `TrainingPortal` custom resource triggers the deployment of a set of workshop environments and a set number of workshop instances.

## <a id="specify-workshop-defs"></a> Specifying the workshop definitions

Running multiple workshop instances to perform training to a group of people is done by following the step-wise process of creating the workshop environment and then creating each workshop instance. The `TrainingPortal` workshop resource bundles that up as one step.

Before creating the training environment you still need to load the workshop definitions as a separate step.

To specify the names of the workshops to be used for the training, list them under the `workshops` field of the training portal specification. Each entry needs to define a `name` property, matching the name of the `Workshop` resource which was created.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: sample-workshops
spec:
  portal:
    sessions:
      maximum: 8
  workshops:
  - name: lab-asciidoc-sample
  - name: lab-markdown-sample
```

When the training portal is created, it sets up the underlying workshop environments, creates any workshop instances required to be created initially for each workshop, and deploys a web portal for attendees of the training to access their workshop instances.

## <a id="limit-number-of-sessions"></a> Limiting the number of sessions

When defining the training portal, you can set a limit on the workshop sessions that can be run concurrently. This is done using the `portal.sessions.maximum` property.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: sample-workshops
spec:
  portal:
    sessions:
      maximum: 8
  workshops:
  - name: lab-asciidoc-sample
  - name: lab-markdown-sample
```

When this is specified, the maximum capacity of each workshop is set to the same maximum value for the portal as a whole. This means that any one workshop can have as many sessions as specified by the maximum, but, to achieve that, only instances of that workshops can be created. In other words the maximum applies to the total number of workshop instances created across all workshops.

 If you do not set `portal.sessions.maximum`, you must set the capacity for each individual workshop as detailed below. In only setting the capacities of each workshop and not an overall maximum for sessions, you cannot share the overall capacity of the training portal across multiple workshops.

## <a id="cap-individual-workshops"></a> Capacity of individual workshops

When you have more than one workshop, you may want to limit how many instances of each workshop you can have so that they cannot grow to the maximum number of sessions for the whole training portal, but a lessor maximum. This means you can stop one specific workshop taking over all the capacity of the whole training portal. To do this set the `capacity` field under the entry for the workshop.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: sample-workshops
spec:
  portal:
    sessions:
      maximum: 8
  workshops:
  - name: lab-asciidoc-sample
    capacity: 4
  - name: lab-markdown-sample
    capacity: 6
```

The value of `capacity` caps the number of workshop sessions for the specific workshop at that value. It should always be less than or equal to the maximum number of workshops sessions as the latter always sets the absolute cap.

## <a id="set-reserved-ws-instances"></a> Set reserved workshop instances

By default, one instance of each of the listed workshops is created up front so that, when the initial user requests that workshop, it is available for use immediately.

When such a reserved instance is allocated to a user, provided that the workshop capacity hasn't been reached, a new instance of the workshop is created as a reserve ready for the next user. When a user ends a workshop, if the workshop had been at capacity, then, when the instance is deleted, a new reserve is created. The total of allocated and reserved sessions for a workshop cannot therefore exceed the capacity for that workshop.

If you want to override for a specific workshop how many reserved instances are kept on standby ready for users, you can set the `reserved` setting against the workshop.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: sample-workshops
spec:
  portal:
    sessions:
      maximum: 8
  workshops:
  - name: lab-asciidoc-sample
    capacity: 4
    reserved: 2
  - name: lab-markdown-sample
    capacity: 6
    reserved: 4
```

The value of `reserved` can be set to 0 if you do not ever want any reserved instances for a workshop and you instead only want instances of that workshop created on demand when required for a user. Only creating instances of a workshop on demand can result in a user needing to wait longer to access a workshop session.

In this instance where workshop instances are always created on demand and also in other cases where reserved instances tie up capacity which could be used for a new session of another workshop, the oldest reserved instance is terminated to allow a new session of the desired workshop to be created instead. This occurs as long as any caps for specific workshops are being satisfied.

## <a id="override-init-num-session"></a> Override initial number of sessions

The initial number of workshop instances created for each workshop is specified by `reserved` or 1, if the setting hasn't been provided.

In the case where `reserved` is set in order to keep workshop instances on standby, you can indicate that initially you want more than the reserved number of instances created. This is useful where running a workshop for a set period of time. You might create up-front instances of the workshop corresponding to 75% of the expected number of attendees, but with a smaller reserve number. With this configuration, new reserve instances only start to be created when the total number approaches 75% and all extra instances created up front have been allocated to users. This way you ensure you have enough instances ready for when most people come but can create others if necessary later.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: kubernetes-fundamentals
spec:
  portal:
    sessions:
      maximum: 100
  workshops:
  - name: lab-kubernetes-fundamentals
    initial: 75
    reserved: 5
```

## <a id="set-defaults-for-ws"></a> Setting defaults for all workshops

If you have a list of workshops and they all need to be set with the same values for `capacity`, `reserved` and `initial`, rather than add the settings to each, you can set defaults to apply to each under the `portal` section instead.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: sample-workshops
spec:
  portal:
    sessions:
      maximum: 10
    capacity: 6
    reserved: 2
    initial: 4
  workshops:
  - name: lab-asciidoc-sample
  - name: lab-markdown-sample
```

Note that the location of these defaults in the training portal configuration will most likely change in a future version.

## <a id="set-caps-on-users"></a> Setting caps on individual users

By default a single user can run more than one workshop at a time. You can cap this though if you want to ensure that the workshops can run only one at a time. This avoids the problem of a user wasting resources by starting more than one at the same time but only proceeding with one without shutting down the other first.

The setting to apply a limit on how many concurrent workshop sessions a user can start is `portal.sessions.registered`.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: sample-workshops
spec:
  portal:
    sessions:
      maximum: 8
      registered: 1
  workshops:
  - name: lab-asciidoc-sample
    capacity: 4
    reserved: 2
  - name: lab-markdown-sample
    capacity: 6
    reserved: 4
```

This limit also applies to anonymous users when anonymous access is enabled through the training portal web interface or if sessions are being created via the REST API. If you want to set a distinct limit on anonymous users, you can set `portal.sessions.anonymous` instead.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: sample-workshops
spec:
  portal:
    sessions:
      maximum: 8
      anonymous: 1
  workshops:
  - name: lab-asciidoc-sample
    capacity: 4
    reserved: 2
  - name: lab-markdown-sample
    capacity: 6
    reserved: 4
```

## <a id="expiring-of-ws-sessions"></a> Expiring of workshop sessions

Once you reach the maximum capacity, no more workshops sessions can be created. Once a workshop session has been allocated to a user, it cannot be re-assigned to another user.

If running a supervised workshop you need to ensure that you set the capacity higher than the expected number in case you have extra users unexpectedly which you need to accomodate. You can use the setting for the reserved number of instances so that, although a higher capacity is set, workshop sessions are only created as required rather than all being created up front.

In supervised workshops, when the training is over you delete the whole training environment; all workshop sessions are then deleted.

If you need to host a training portal over an extended period but don't know when users want to do a workshop, you can set up workshop sessions to expire after a set time. When expired, the workshop session is deleted, and a new workshop session can be created in its place.

The maximum capacity is therefore the maximum at any one point in time, with the number being able to grow and shrink over time. In this way, over an extended time you could handle many more sessions than to what the maximum capacity is set. The maximum capacity in this case ensures you don't try and allocate more workshop sessions than you have resources to handle at any one time.

Setting a maximum time allowed for a workshop session can be done using the `expires` setting.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  workshops:
  - name: lab-markdown-sample
    capacity: 8
    reserved: 1
    expires: 60m
```

The value needs to be an integer, followed by a suffix of 's', 'm' or 'h', corresponding to seconds, minutes, or hours.

The time period is calculated from when the workshop session is allocated to a user. When the time period is up, the workshop session is automatically deleted.

When an expiration period is specified or when a user finishes a workshop or restarts the workshop, the workshop is also deleted.

To cope with users who claim a workshop session, but leave and don't use it, you can also set a time period for when a workshop session with no activity is deemed as being orphaned and so deleted. This is done using the `orphaned` setting.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  workshops:
  - name: lab-markdown-sample
    capacity: 8
    reserved: 1
    expires: 60m
    orphaned: 5m
```

For supervised workshops where the whole event only lasts a certain amount of time, you should avoid this setting so that a user's session is not deleted when the user takes breaks and the computer goes to sleep.

The `expires` and `orphaned` settings can also be set against `portal` instead if you want them to apply to all workshops.

## <a id="updates-to-ws-env"></a> Updates to workshop environments

The list of workshops for an existing training portal can be changed by modifying the training portal definition applied to the Kubernetes cluster.

If you remove a workshop from the list of workshops, the workshop environment is marked as stopping and is deleted when all active workshop sessions have completed.

If you add a workshop to the list of workshops, a new workshop environment for it is created.

Changes to settings, such as the maximum number of sessions for the training portal or capacity settings for individual workshops, are applied to existing workshop environments.

By default a workshop environment is left unchanged if the corresponding workshop definition is changed. In the default configuration, therefore, you need to explicitly delete the workshop from the list of workshops managed by the training portal and then add it back again if the workshop definition changed.

If you prefer that workshop environments automatically be replaced when the workshop definition changes, you can enable it by setting the `portal.updates.workshop` setting.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  portal:
    sessions:
      maximum: 8
    updates:
      workshop: true
  workshops:
  - name: lab-markdown-sample
    reserved: 1
    expires: 60m
    orphaned: 5m
```

When using this option you use the `portal.sessions.maximum` setting to cap the number of workshop sessions that can be run for the training portal as a whole. This is because, when replacing the workshop environment, the old workshop environment is retained so long as there is still an active workshop session being used. If the cap isn't set, then the new workshop environment is still able to grow to its specific capacity and is not limited based on how many workshop sessions are running against old instances of the workshop environment.

Overall it is recommended to use the option to update workshop environments when workshop definitions change only in development environments where working on workshop content, at least until you are quite familiar with the mechanism for how the training portal replaces existing workshop environments and the resource implications of when you have old and new instances of a workshop environment running at the same time.

## <a id="override-ingress-domain"></a> Overriding the ingress domain

In order to be able to access a workshop instance using a public URL, you need to specify an ingress domain. If an ingress domain isn't specified, the default ingress domain that the Learning Center Operator has been configured with will be used.

When setting a custom domain, DNS must have been configured with a wildcard domain to forward all requests for sub-domains of the custom domain to the ingress router of the Kubernetes cluster.

To provide the ingress domain, you can set the `portal.ingress.domain` field.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  portal:
    ingress:
      domain: learningcenter.tanzu.vmware.com
  workshops:
  - name: lab-markdown-sample
    capacity: 3
    reserved: 1
```

If overriding the domain, by default, the workshop session is exposed using a HTTP connection. If you require a secure HTTPS connection, you need to have access to a wildcard SSL certificate for the domain. A secret of type `tls` should be created for the certificate in the `learningcenter` namespace or the namespace where the Learning Center Operator is deployed. The name of that secret should then be set in the `portal.ingress.secret` field.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  portal:
    ingress:
      domain: learningcenter.tanzu.vmware.com
      secret: learningcenter.tanzu.vmware.com-tls
  workshops:
  - name: lab-markdown-sample
    capacity: 3
    reserved: 1
```

If HTTPS connections are being terminated using an external load balancer and not by specifying a secret for ingresses managed by the Kubernetes ingress controller, then routing traffic into the Kubernetes cluster as HTTP connections, you can override the ingress protocol without specifying an ingress secret by setting the `portal.ingress.protocol` field.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  portal:
    ingress:
      domain: learningcenter.tanzu.vmware.com
      protocol: https
  workshops:
  - name: lab-markdown-sample
    capacity: 3
    reserved: 1
```

If you need to override or set the ingress class, which dictates which ingress router is used when more than one option is available, you can add `portal.ingress.class`.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  portal:
    ingress:
      domain: learningcenter.tanzu.vmware.com
      secret: learningcenter.tanzu.vmware.com-tls
      class: nginx
  workshops:
  - name: lab-markdown-sample
    capacity: 3
    reserved: 1
```

## <a id="override-portal-hostname"></a> Overriding the portal hostname

The default hostname given to the training portal will be the name of the resource with `-ui` suffix, followed by the domain specified by the resource or the default inherited from the configuration of the Learning Center Operator.

If you want to override the generated hostname, you can set `portal.ingress.hostname`.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  portal:
    ingress:
      hostname: labs
      domain: learningcenter.tanzu.vmware.com
      secret: learningcenter.tanzu.vmware.com-tls
  workshops:
  - name: lab-markdown-sample
    capacity: 3
    reserved: 1
```

This results in the hostname being `labs.learningcenter.tanzu.vmware.com` rather than the default generated name for this example of `lab-markdown-sample-ui.learningcenter.tanzu.vmware.com`.

## <a id="set-extra-env-variables"></a> Setting extra environment variables

If you want to override any environment variables for workshop instances created for a specific work, you can provide the environment variables in the `env` field of that workshop.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  workshops:
  - name: lab-markdown-sample
    capacity: 3
    reserved: 1
    env:
    - name: REPOSITORY-URL
      value: YOUR-GITHUB-URL-FOR-LAB-MARKDOWN-SAMPLE
```

Where `YOUR-GITHUB-URL-FOR-LAB-MARKDOWN-SAMPLE` is the Git repository URL for `lab-markdown-sample`. For example, `https://github.com/eduk8s/lab-markdown-sample`.

Values of fields in the list of resource objects can reference a number of predefined parameters. The available parameters are:

- `session_id` - A unique ID for the workshop instance within the workshop environment.
- `session_namespace` - The namespace created for and bound to the workshop instance. This is the namespace unique to the session and where a workshop can create its own resources.
- `environment_name` - The name of the workshop environment. For now this is the same as the name of the namespace for the workshop environment. Don't rely on them being the same, and use the most appropriate to cope with any future change.
- `workshop_namespace` - The namespace for the workshop environment. This is the namespace where all deployments of the workshop instances are created and where the service account that the workshop instance runs as exists.
- `service_account` - The name of the service account the workshop instance runs as and which has access to the namespace created for that workshop instance.
- `ingress_domain` - The host domain under which hostnames can be created when creating ingress routes.
- `ingress_protocol` - The protocol (http/https) that is used for ingress routes which are created for workshops.

The syntax for referencing one of the parameters is `$(parameter_name)`.

## <a id="override-portal-creds"></a> Overriding portal credentials

When a training portal is deployed, the username for the admin and robot accounts uses the defaults of `learningcenter` and `robot@learningcenter`. The passwords for each account are randomly set.

For the robot account, the OAuth application client details used with the REST API are also randomly generated.

You can see what the credentials and client details are by running `kubectl describe` against the training portal resource. This will yield output which includes:

```
Status:
  learningcenter:
    Clients:
      Robot:
        Id:      ACZpcaLIT3qr725YWmXu8et9REl4HBg1
        Secret:  t5IfXbGZQThAKR43apoc9usOFVDv2BLE
    Credentials:
      Admin:
        Password:  0kGmMlYw46BZT2vCntyrRuFf1gQq5ohi
        Username:  learningcenter
      Robot:
        Password:  QrnY67ME9yGasNhq2OTbgWA4RzipUvo5
        Username:  robot@learningcenter
```

If you wish to override any of these values in order to be able to set them to a pre-determined value, you can add `credentials` and `clients` sections to the training portal specification.

To overload the credentials for the admin and robot accounts user:

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  portal:
    credentials:
      admin:
        username: admin-user
        password: top-secret
      robot:
        username: robot-user
        password: top-secret
  workshops:
  - name: lab-markdown-sample
    capacity: 3
    reserved: 1
```

To override the application client details for OAuth access by the robot account user:

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  portal:
    clients:
      robot:
        id: application-id
        secret: top-secret
  workshops:
  - name: lab-markdown-sample
    capacity: 3
    reserved: 1
```

## <a id="controlling-reg-type"></a> Controlling registration type

By default the training portal web interface presents a registration page for users to create an account before selecting a workshop. If you only want to allow the administrator to log in, you can disable the registration page. This is done if you are using the REST API to create and allocate workshop sessions from a separate application.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  portal:
    registration:
      type: one-step
      enabled: false
  workshops:
  - name: lab-markdown-sample
    capacity: 3
    reserved: 1
```

If rather than requiring users to register, you want to allow anonymous access, you can switch the registration type to anonymous.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  portal:
    registration:
      type: anonymous
  workshops:
  - name: lab-markdown-sample
    capacity: 3
    reserved: 1
```

When a user visits the training portal home page in anonymous mode, an account for that user is
automatically created and the user is logged in.

## <a id="specify-event-access-code"></a> Specifying an event access code

Where deploying the training portal with anonymous access or open registration, anyone who knows the URL can access workshops. If you want to at least prevent access to those who know a common event access code or password, you can set `portal.password`.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  portal:
    password: workshops-2020-07-01
  workshops:
  - name: lab-markdown-sample
    capacity: 3
    reserved: 1
```

When the training portal URL is accessed, users are asked to enter an event access code before they are redirected to the list of workshops (when anonymous access is enabled) or to the login page.

## <a id="make-list-of-ws-public"></a> Making list of workshops public

By default the index page providing the catalog of available workshop images is only available once a user has logged in, either through a registered account or as an anonymous user.

If you want to make the catalog of available workshops public so they can be viewed before logging in, you can set the `portal.catalog.visibility` property.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  portal:
    catalog:
      visibility: public
  workshops:
  - name: lab-markdown-sample
    capacity: 3
    reserved: 1
```

By default the catalog has visibility set to `private`. Use `public` to expose it.

Note that this will also make it possible to access the list of available workshops from the catalog, via the REST API, without authenticating against the REST API.

## <a id="use-external-list-of-ws"></a> Using an external list of workshops

If you are using the training portal with registration disabled and are using the REST API from a separate web site to control creation of sessions, you can specify an alternate URL for providing the list of workshops.

This helps in the situation where, for a session created by the REST API, cookies were deleted or a session URL was shared with a different user, meaning the value for the `index_url` supplied with the REST API request is lost.

The property to set the URL for the external site is `portal.index`.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  portal:
    index: https://www.example.com/
    registration:
      type: one-step
      enabled: false
  workshops:
  - name: lab-markdown-sample
    capacity: 3
    reserved: 1
```

If the property is supplied, passing the `index_url` when creating a workshop session using the REST API is optional, and the value of this property is used. You may still want to supply `index_url` when using the REST API, however, if you want a user to be redirected back to a sub-category for workshops on the site providing the list of workshops. The URL provided here in the training portal definition then acts only as a fallback when the redirect URL becomes unavailable and directs the user back to the top-level page for the external list of workshops.

IF a user has logged into the training portal as the admin user, the user is not redirected to the external site and still sees the training portals own list of workshops.

## <a id="override-prtl-title-logo"></a> Overriding portal title and logo

The web interface for the training portal displays a generic Learning Center logo by default, along with a page title of "Workshops". If you want to override these, you can set `portal.title` and `portal.logo`.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  portal:
    title: Workshops
    logo: data:image/png;base64,....
  workshops:
  - name: lab-markdown-sample
    capacity: 3
    reserved: 1
```

The `logo` field should be a graphical image provided in embedded data URI format which displays the branding you desire. The image is displayed with a fixed height of "40px". The field can also be a URL for an image stored on a remote web server.

## <a id="allow-portal-in-iframe"></a> Allowing the portal in an iframe

By default if you try and display the web interface for the training portal in an iframe of another web site, it will be prohibited due to content security policies applying to the training portal web site.

If you want to enable the ability to iframe the full training portal web interface or even a specific workshop session created using the REST API, you need to provide the hostname of the site which embeds it. Do this by using the `portal.theme.frame.ancestors` property.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  portal:
    theme:
      frame:
        ancestors:
        - https://www.example.com
  workshops:
  - name: lab-markdown-sample
    capacity: 3
    reserved: 1
```

The property is a list of hosts, not a single value. If you need to use a URL for the training portal in an iframe of a page, which, in turn, is embedded in another iframe of a page on a different site again, you need to list the hostnames of all sites.

Because the sites which embed the iframes must be secure and use HTTPS, they cannot use plain HTTP. This is because browser policies prohibit promoting of cookies to an insecure site when embedding using an iframe. If cookies cannot be stored, a user cannot authenticate against the workshop session.

## <a id="collect-analytics-on-ws"></a> Collecting analytics on workshops

To collect analytics data on usage of workshops, you can supply a webhook URL. When this is supplied, events are posted to the webhook URL for events such as workshops being started, pages of a workshop being viewed, expiration of a workshop, completion of a workshop, or termination of a workshop.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  analytics:
    webhook:
      url: https://metrics.learningcenter.tanzu.vmware.com/?client=name&token=password
  workshops:
  - name: lab-markdown-sample
    capacity: 3
    reserved: 1
```

At present there is no metrics collection service compatible with the portal webhook reporting mechanism, so you will need to create a custom service or integrate it with any existing web front end for the portal REST API service.

If the collection service needs to be provided with a client ID or access token, it must accept using query string parameters which would be set in the webhook URL.

The details of the event are subsequently included as HTTP POST data using the `application/json` content type.

```
{
  "portal": {
    "name": "lab-markdown-sample",
    "uid": "91dfa283-fb60-403b-8e50-fb30943ae87d",
    "generation": 3,
    "url": "https://lab-markdown-sample-ui.learningcenter.tanzu.vmware.com"
  },
  "event": {
    "name": "Session/Started",
    "timestamp": "2021-03-18T02:50:40.861392+00:00",
    "user": "c66db34e-3158-442b-91b7-25391042f037",
    "session": "lab-markdown-sample-w01-s001",
    "environment": "lab-markdown-sample-w01",
    "workshop": "lab-markdown-sample",
    "data": {}
  }
}
```

Where an event has associated data, it is included in the `data` dictionary.

```
{
  "portal": {
    "name": "lab-markdown-sample",
    "uid": "91dfa283-fb60-403b-8e50-fb30943ae87d",
    "generation": 3,
    "url": "https://lab-markdown-sample-ui.learningcenter.tanzu.vmware.com"
  },
  "event": {
    "name": "Workshop/View",
    "timestamp": "2021-03-18T02:50:44.590918+00:00",
    "user": "c66db34e-3158-442b-91b7-25391042f037",
    "session": "lab-markdown-sample-w01-s001",
    "environment": "lab-markdown-sample-w01",
    "workshop": "lab-markdown-sample",
    "data": {
      "current": "workshop-overview",
      "next": "setup-environment",
      "step": 1,
      "total": 4
    }
  }
}
```

The `user` field is the same portal user identity that is returned by the REST API when creating workshop sessions.

The event stream only produces events for things as they happen. If you need a snapshot of all current workshop sessions, you should use the REST API to request the catalog of available workshop environments, enabling the inclusion of current workshop sessions.

## <a id="using-google-analytics"></a> Tracking using Google Analytics

If you want to record analytics data on usage of workshops using Google Analytics, you can enable tracking by supplying a tracking ID for Google Analytics.

```
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  analytics:
    google:
      trackingId: UA-XXXXXXX-1
  workshops:
  - name: lab-markdown-sample
    capacity: 3
    reserved: 1
```

Custom dimensions are used in Google Analytics to record details about the workshop a user is doing and through which training portal and cluster it was accessed. You can therefore use the same Google Analytics tracking ID for multiple training portal instances running on different Kubernetes clusters if desired.

To support use of custom dimensions in Google Analytics you must configure the Google Analytics property with the following custom dimensions. They must be added in the order shown as Google Analytics doesn't allow you to specify the index position for a custom dimension and allocates them for you. You can't already have custom dimensions defined for the property, as the new custom dimensions must start at index of 1.

```
| Custom Dimension Name | Index |
|-----------------------|-------|
| workshop_name         | 1     |
| session_namespace     | 2     |
| workshop_namespace    | 3     |
| training_portal       | 4     |
| ingress_domain        | 5     |
| ingress_protocol      | 6     |
```

In addition to custom dimensions against page accesses, events are also generated. These include:

* Workshop/Start
* Workshop/Finish
* Workshop/Expired

If a Google Analytics tracking ID is provided with the `TrainingPortal` resource definition, it takes precedence over one set by the `SystemProfile` resource definition.

Note that Google Analytics is not a reliable way to collect data. This is because individuals or corporate firewalls can block the reporting of Google Analytics data. For more precise statistics, you use the webhook URL for collecting analytics with a custom data collection platform.
