# SystemProfile resource

Use the `SystemProfile` custom resource to configure the Learning Center Operator.
You can use the default system profile to set defaults for ingress and image pull secrets. You can also select an alternate profile for
specific deployments if required.

>**Note:** Changes made to the `SystemProfile` custom resource, or changes made by means of environment variables,
>don't take effect on already deployed `TrainingPortals`. You must recreate those for the changes
>to be applied.
>You only need to recreate the `TrainingPortal` resources, because this resource takes care of
>recreating the `WorkshopEnvironments` with the new values.

## <a id="op-default-sys-profile"></a> Operator default system profile

The Learning Center Operator, by default, uses an instance of the `SystemProfile` custom resource
if it exists, named `default-system-profile`. You can override the name of the resource used by the
Learning Center Operator as the default by setting the `SYSTEM_PROFILE` environment variable on the
deployment for the Learning Center Operator. For example:

```console
kubectl set env deployment/learningcenter-operator -e SYSTEM_PROFILE=default-system-profile -n learningcenter
```

The Learning Center Operator automatically detects and uses any changes to an instance of the `SystemProfile` custom resource. You do not need to redeploy the operator when changes are made.

## <a id="def-ingress-config"></a> Defining configuration for ingress

The `SystemProfile` custom resource replaces the use of environment variables to configure details
such as the ingress domain, secret, and class.

Instead of setting `INGRESS_DOMAIN`, `INGRESS_SECRET`, and `INGRESS_CLASS` environment variables,
create an instance of the `SystemProfile` custom resource named `default-system-profile`:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: SystemProfile
metadata:
  name: default-system-profile
spec:
  ingress:
    domain: learningcenter.tanzu.vmware.com
    secret: learningcenter.tanzu.vmware.com-tls
    class: nginx
```

If you terminate HTTPS connections by using an external load balancer and not by specifying a
secret for ingresses managed by the Kubernetes ingress controller, then routing traffic into the
Kubernetes cluster as HTTP connections, you can override the ingress protocol without specifying an
ingress secret:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: SystemProfile
metadata:
  name: default-system-profile
spec:
  ingress:
    domain: learningcenter.tanzu.vmware.com
    protocol: https
    class: nginx
```

## <a id="def-img-reg-pull-secrets"></a> Defining container image registry pull secrets

To work with custom workshop images stored in a private image registry, the system profile
can define a list of image pull secrets. Add this to the service accounts used to deploy
and run the workshop images. Set the `environment.secrets.pull` property to the list of secret names:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: SystemProfile
metadata:
  name: default-system-profile
spec:
  environment:
    secrets:
      pull:
      - private-image-registry-pull
```

The secrets containing the image registry credentials must exist within the `learningcenter` namespace
or the namespace where the Learning Center Operator is deployed. The secret resources must be of type
`kubernetes.io/dockerconfigjson`.

The secrets are added to the workshop namespace and are not visible to a user. No secrets are added to the namespace created for each workshop
session.

Some container images are used as part of Learning Center itself, such as the container image for the
training portal web interface and the builtin base workshop images. If you have copied these from the
public image registries and stored them in a local private registry, use the `registry` section
instead of the above setting. For example:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: SystemProfile
metadata:
  name: default-system-profile
spec:
  registry:
    secret: learningcenter-image-registry-pull
```

The `registry.secret` is the name of the secret containing the image registry credentials.
This must be present in the `learningcenter` namespace or the namespace where the
Learning Center Operator is deployed.

## <a id="def-vol-storage-class"></a> Defining storage class for volumes

Deployments of the training portal web interface and the workshop sessions make use of persistent
volumes.
By default the persistent volume claims do not specify a storage class for the volume. Instead, they rely on the Kubernetes cluster to specify a default storage class that works.
If the Kubernetes cluster doesn't define a suitable default storage class or you need to override it,
you can set the `storage.class` property. For example:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: SystemProfile
metadata:
  name: default-system-profile
spec:
  storage:
    class: default
```

This only applies to persistent volume claims setup by the Learning Center Operator.
If a user executes steps in a workshop that include making persistent volume claims, these are
not automatically adjusted.

## <a id="def-vol-storage-group"></a> Defining storage group for volumes

The cluster must apply pod security policies where persistent volumes are used by Learning Center for the training portal web interface and
workshop environments.
These security policies ensure that permissions of persistent volumes are set correctly so they can be accessed by containers mounting the persistent volume.
When the pod security policy admission controller is not enabled, the cluster
institutes a fallback to enable access to volumes by enabling group access using the group ID of `0`.

In situations where the only class of persistent storage available is NFS or similar, you might have to override the group ID applied and set it to an alternate ID dictated by the file system
storage provider. If this is required, you can set the `storage.group` property. For example:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: SystemProfile
metadata:
  name: default-system-profile
spec:
  storage:
    group: 1
```

Overriding the group ID to match the persistent storage relies on the group having write permission
to the volume. If only the owner of the volume has permission, this does not work.

In this case, change the owner/group and permissions of the persistent volume such
that the owner matches the user ID a container runs at. Alternatively, set the group to a known ID that is
added as a supplemental group for the container and update the persistent volume to be writable to
this group. This must be done by an `init` container running in the pod mounting the persistent
volume.

To trigger this change of ownership and permissions, set the `storage.user` property. For example:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: SystemProfile
metadata:
  name: default-system-profile
spec:
  storage:
    user: 1
    group: 1
```

This results in:

- The `init` container running as the root user.
- The owner of the mount directory of the persistent volume being set to `storage.user`.
- The group being set to `storage.group`.
- The directory made group-writable.

The group is then added as the
supplemental group to containers using the persistent volume. So they can write to the persistent volume, regardless of
what user ID the container runs as. To that end, the specific value of `storage.user` doesn't matter,
but you might need to set it to a specific user ID based on requirements of the storage provider.

Both these variations on the settings only apply to the persistent volumes used by
Learning Center itself. If a workshop asks users to create persistent volumes, those instructions, or
the resource definitions used, might need to be modified to work where the available storage class requires access as a specific user or group ID.

Further, the second method using the `init` container to fix permissions does not work if pod
security policies are enforced. The ability to run a container as the root user is blocked in that
case due to the restricted PSP, which is applied to workshop instances.

## <a id="restrict-network-access"></a> Restricting network access

Any processes running from the workshop container, and any applications deployed to the session namespaces
associated with a workshop instance, can contact any network IP addresses accessible from the cluster.
To restrict access to IP addresses or IP subnets, set
`network.blockCIDRs`. This must be a CIDR block range corresponding to the subnet or a portion of a
subnet you want to block. A Kubernetes `NetworkPolicy` is used to enforce the restriction. So the
Kubernetes cluster must use a network layer supporting network policies, and the necessary Kubernetes
controllers supporting network policies must be enabled when the cluster is installed.

If deploying to AWS, it is important to block access to the AWS endpoint for querying EC2 metadata, because
it can expose sensitive information that workshop users should not haves access to. By default
Learning Center will block the AWS endpoint on the TAP SystemProfile. If you need to replicate this
block to other SystemProfiles, the configuration is as follows:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: SystemProfile
metadata:
  name: default-system-profile
spec:
  network:
    blockCIDRs:
    - 169.254.169.254/32
    - fd00:ec2::254/128
```

## <a id="run-dker-daemon-rootless"></a> Running Docker daemon rootless

If `docker` is enabled for workshops, Docker-in-Docker is run using a sidecar container.
Because of the current state of running Docker-in-Docker and portability across Kubernetes
environments, the `docker` daemon by default runs as `root`. Because a privileged container is also
being used, this represents a security risk. Only run workshops requiring `docker` in disposable
Kubernetes clusters or for users whom you trust.

You can partly mediate the risks of running `docker` in the Kubernetes cluster by running the `docker`
daemon in rootless mode. However, not all Kubernetes clusters can support this due to the Linux
kernel configuration or other incompatibilities.

To enable rootless mode, you can set the `dockerd.rootless` property to `true`:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: SystemProfile
metadata:
  name: default-system-profile
spec:
  dockerd:
    rootless: true
```

Use of `docker` can be made even more secure by avoiding the use of a privileged container for the
`docker` daemon. This requires that you set up a specific configuration for nodes in the Kubernetes
cluster.
With this configuration, you can disable the use of a privileged container by setting
`dockerd.privileged` to `false`:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: SystemProfile
metadata:
  name: default-system-profile
spec:
  dockerd:
    rootless: true
    privileged: false
```

For further details about the requirements for running rootless Docker-in-Docker and using a
non-privileged container, see the [Docker documentation](https://docs.docker.com/engine/security/rootless/).


## <a id="override-nwk-packet-size"></a> Overriding network packet size

When you enable support for building container images using `docker` for workshops, because of
network layering that occurs when doing `docker build` or `docker run`, you must adjust the network
packet size (MTU) used for containers run from `dockerd` hosted inside the workshop container.

The default MTU size for networks is 1500, but, when containers are run in Kubernetes, the size
available to containers is often reduced. To deal with this possibility, the MTU size used when
`dockerd` is run for a workshop is set as 1400 instead of 1500.

You might need to override this value to an even lower value if you experience problems building or running images with `docker` support. These problems could include errors or timeouts in pulling images or when pulling software packages such as PyPi, npm, and so on.

To lower the value, set the `dockerd.mtu` property:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: SystemProfile
metadata:
  name: default-system-profile
spec:
  dockerd:
    mtu: 1400
```

To discover the maximum viable size, access the `docker` container run with a
workshop and run `ifconfig eth0`. This yields something similar to:

```console
eth0      Link encap:Ethernet  HWaddr 02:42:AC:11:00:07
          inet addr:172.17.0.7  Bcast:172.17.255.255  Mask:255.255.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1350  Metric:1
          RX packets:270018 errors:0 dropped:0 overruns:0 frame:0
          TX packets:283882 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:86363656 (82.3 MiB)  TX bytes:65183730 (62.1 MiB)
```

If the `MTU` size is less than 1400, use the value given, or a smaller value, for the
`dockerd.mtu` setting.

## <a id="img-registry-pull"></a> Image registry pull through cache

When running or building container images with `docker`, if the container image is hosted on
Docker Hub, it is pulled down directly from the Docker Hub for each separate workshop session
of that workshop.

Because the image is pulled from Docker Hub, this can be slow for all users, especially for large
images. With Docker Hub introducing limits on how many images can be pulled anonymously from an IP
address within a set period, this also can result in the cap on image pulls being reached. This prevents the workshop from being used until the period expires.

Docker Hub has a higher limit when pulling images as an authenticated user, but with the limit
applied to the user rather than by IP address. For authenticated users with a paid plan on Docker Hub,
there is no limit.

To attempt to avoid the impact of the limit, the first thing you can do is enable an image registry
mirror with image pull-through. This is enabled globally and results in an instance of an image
registry mirror being created in the workshop environment of workshops that enable `docker` support.
This mirror is used for all workshops sessions created against that workshop environment.
When the first user attempts to pull an image, it is pulled down from Docker Hub and cached in
the mirror. Subsequent users are served up from the image registry mirror, avoiding the need to
pull the image from Docker Hub again. Subsequent users also see a speed up in pulling the
image, because the mirror is deployed to the same cluster.

To enable the use of an image registry mirror against Docker Hub, use:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: SystemProfile
metadata:
  name: default-system-profile
spec:
  dockerd:
    mirror:
      remote: https://registry-1.docker.io
```

For authenticated access to Docker Hub, create an access token under your Docker Hub account.
Then set the `username` and `password` using the access token as the `password`.
Do not use the password for the account itself. Using an access token makes it easier to revoke the
token if necessary.

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: SystemProfile
metadata:
  name: default-system-profile
spec:
  dockerd:
    mirror:
      remote: https://registry-1.docker.io
      username: username
      password: access-token
```

An access token provides write access to Docker Hub. It is therefore also recommended you use a
separate robot account in Docker Hub that is not used to host images and doesn't have write access
to any other organizations. In other words, use it purely for reading images from Docker Hub.

If this is a free account, the higher limit on image pulls then applies. If the account is paid,
there might be higher limits or no limit all all.

The image registry mirror is only used when running or building images using
support for running `docker`. The mirror does not come into play when creating deployments in
Kubernetes, which make use of images hosted on Docker Hub. Use of images from Docker Hub in
deployments is still subject to the limit for anonymous access, unless you supply image registry
credentials for the deployment so an authenticated user is used.

## <a id="set-default-access-creds"></a>Setting default access credentials

When deploying a training portal using the `TrainingPortal` custom resource, the credentials for
accessing the portal are unique for each instance. Find the details of the credentials by viewing
status information added to the custom resources by using `kubectl describe`.

To override the credentials for the portals so the same set of credentials are used for each, add the desired values to the system profile.

To override the user name and password for the admin and robot accounts, use `portal.credentials`:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: SystemProfile
metadata:
  name: default-system-profile
spec:
  portal:
    credentials:
      admin:
        username: learningcenter
        password: admin-password
      robot:
        username: robot@learningcenter
        password: robot-password
```

To override the client ID and secret used for OAuth access by the robot account, use `portal.clients`:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: SystemProfile
metadata:
  name: default-system-profile
spec:
  portal:
    clients:
      robot:
        id: robot-id
        secret: robot-secret
```

If the `TrainingPortal` has specified credentials or client information, they still take
precedence over the values specified in the system profile.

## <a id="override-ws-images"></a>Overriding the workshop images

When a workshop does not define a workshop image to use and instead downloads workshop content from
GitHub or a web server, it uses the `base-environment` workshop image. The workshop content is then
added to the container, overlaid on this image.

The version of the `base-environment` workshop image used is the most up-to-date, compatible
version of the image available for that version of the Learning Center Operator when it was released.

If necessary you can override the version of the `base-environment` workshop image used by
defining a mapping under `workshop.images`. For workshop images supplied as part of the
Learning Center project, you can override the short names used to refer to them.

The short versions of the recognized names are:

* `base-environment:*` is a tagged version of the `base-environment` workshop image
matched with the current version of the Learning Center Operator.

To override the version of the `base-environment` workshop image mapped to by the `*`
tag, use:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: SystemProfile
metadata:
  name: default-system-profile
spec:
  workshop:
    images:
      "base-environment:*": "registry.tanzu.vmware.com/learning-center/base-environment:latest"
```

It is also possible to override where images are pulled from for any arbitrary image.
This could be used where you want to cache the images for a workshop in a local image registry and
avoid going outside of your network, or the cluster, to get them.
This means you wouldn't need to override the workshop definitions for a specific workshop to change it. For example:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: SystemProfile
metadata:
  name: default-system-profile
spec:
  workshop:
    images:
      "{YOUR-REGISTRY-URL}/lab-k8s-fundamentals:master": "registry.test/lab-k8s-fundamentals:master"
```

## <a id="track-w-google-analytics"></a>Tracking using Google Analytics

If you want to record analytics data on usage of workshops using Google Analytics, you can enable
tracking by supplying a tracking ID for Google Analytics. For example:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: SystemProfile
metadata:
  name: default-system-profile
spec:
  analytics:
    google:
      trackingId: UA-XXXXXXX-1
```

Custom dimensions are used in Google Analytics to record details about the workshop a user is taking
and through which training portal and cluster it was accessed. You can therefore use the same
Google Analytics tracking ID with Learning Center running on multiple clusters.

To support use of custom dimensions in Google Analytics, you must configure the Google Analytics
property with the following custom dimensions. They must be added in the order shown, because
Google Analytics doesn't allow you to specify the index position for a custom dimension and
allocates them for you. You can't already have defined custom dimensions for the property, because the new
custom dimensions must start at index of 1.

| Custom Dimension Name | Index |
|-----------------------|-------|
| workshop_name         | 1     |
| session_namespace     | 2     |
| workshop_namespace    | 3     |
| training_portal       | 4     |
| ingress_domain        | 5     |
| ingress_protocol      | 6     |

In addition to custom dimensions against page accesses, events are also generated. These include:

* Workshop/Start
* Workshop/Finish
* Workshop/Expired

However, Google Analytics is not a reliable way to collect data.
This is because individuals or corporate firewalls can block the reporting of Google Analytics data.
For more precise statistics, use the webhook URL for collecting analytics with a custom
data collection platform. Configuration of a webhook URL for analytics can only be specified on the
`TrainingPortal` definition and cannot be specified globally on the `SystemProfile` configuration.

## <a id="override-ws-styling"></a>Overriding styling of the workshop

If using the REST API to create/manage workshop sessions, and the workshop dashboard is then embedded
into an iframe of a separate site, you can perform minor styling changes of the dashboard,
workshop content, and portal to match the separate site. To do this, provide CSS styles under
`theme.dashboard.style`, `theme.workshop.style` and `theme.portal.style`. For dynamic styling or for
adding hooks to report on progress through a workshop to a separate service, supply
JavaScript as part of the theme under `theme.dashboard.script`, `theme.workshop.script`, and
`theme.portal.script`. For example:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: SystemProfile
metadata:
  name: default-system-profile
spec:
  theme:
    dashboard:
      script: |
        console.log("Dashboard theme overrides.");
      style: |
        body {
          font-family: "Comic Sans MS", cursive, sans-serif;
        }
    workshop:
      script: |
        console.log("Workshop theme overrides.");
      style: |
        body {
          font-family: "Comic Sans MS", cursive, sans-serif;
        }
    portal:
      script: |
        console.log("Portal theme overrides.");
      style: |
        body {
          font-family: "Comic Sans MS", cursive, sans-serif;
        }
```

## <a id="extra-custom-sys-profiles"></a> Additional custom system profiles

If the default system profile is specified, it is used by all deployments managed by the
Learning Center Operator, unless it was overridden by the system profile to use for a specific
deployment. You can set the name of the system profile for deployments by setting the `system.profile`
property of `TrainingPortal`, `WorkshopEnvironment`, and `WorkshopSession` custom resources. For example:

```yaml
apiVersion: learningcenter.tanzu.vmware.com/v1beta1
kind: TrainingPortal
metadata:
  name: lab-markdown-sample
spec:
  system:
    profile: learningcenter-tanzu-vmware-com-profile
  workshops:
  - name: lab-markdown-sample
    capacity: 1
```
