# Token settings for Application Single Sign-On

This topic tells you how to configure token expiry settings for Application Single 
Sign-On (commonly called AppSSO).

## <a id='token-expiry-settings'></a> Token expiry

AppSSO allows you to optionally configure the token expiry settings in your 
`AuthServer` resource.

The default token expiry settings are as follows:

| Token type     | Lifetime                |
|----------------|-------------------------|
| Access token   | 12 hours                |
| Identity token | 12 hours                |
| Refresh token  | 720 hours or 30 days    |

VMware recommends setting a shorter lifetime for access tokens, typically measured 
in hours, and a longer lifetime for refresh tokens, typically measured in days. 
Refresh tokens acquire new access tokens, so they have a longer lifespan.

To override the token expiry settings, configure the following in your `AuthServer` 
resource:

```yaml
kind: AuthServer
# ...
spec:
  token:
    accessToken:
      expiry: "12h"
    idToken:
      expiry: "12h"
    refreshToken:
      expiry: "720h"
```

`expiry` field examples:

| Type    | Example | Definition |
|---------|---------|------------|
| Seconds | `10s`   | 10 seconds |
| Minutes | `10m`   | 10 minutes |
| Hours   | `10h`   | 10 hours   |

> **Note** The `expiry` field adheres to the duration constraints of the Go standard time library 
> and does not support durations in units beyond hours, such as days or weeks.
> For more information, see the [Go documentation](https://pkg.go.dev/time#Duration).

### <a id='constraints'></a> Constraints

The token expiry constraints are as follows:

- The duration of the `expiry` field cannot be negative or zero.
- The refresh token's expiration time cannot be the same as or shorter than that of the access token.

## <a id='verify'></a> Verify token settings

After you set up an Application Single Sign-On `AuthServer`, you can verify that the token received by  applications looks as expected. 
For this purpose, you can create a simple application consuming your `AuthServer`. The following YAML file creates such an application. When you access its URL, it enables you to log in by using your `AuthServer` and displays the token it receives.

> **Caution**
>
> - The simple application is not intended for production use. It only serves a tool to help you verify your setup.
> - The following YAML file pulls an unvetted public image `bitnami/oauth2-proxy:7.3.0`
> - This section does not apply to an air-gapped environment.

If you stored the following YAML in a file named `token-viewer.yaml`, you can apply it to your cluster by running the following command:

```shell
  ytt -f token-viewer.yaml --data-value ingress_domain=YOUR-INGRESS-DOMAIN --data-value-yaml 'authserver_selector=YOUR-AUTHSERVER-SELECTOR' | kubectl apply -f-
```

Where `YOUR-AUTHSERVER-SELECTOR` is the label name and its value. For example: `{"name": "ci"}`.

A full example is as follows:

```yaml
#!
#! Token viewer
#!
#! usage:
#!
#! ytt -f client.yml --data-value ingress_domain=example.com --data-value-yaml 'authserver_selector={"name": "ci"}'
#!
#! Then navigate to http://token-viewer.<INGRESS_DOMAIN>
#!
#@ load("@ytt:data", "data")
#@ fqdn = "token-viewer." + data.values.ingress_domain
#@ redirect_uri = "http://" + fqdn + "/oauth2/callback"
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: ClientRegistration
metadata:
   name: my-client-registration
   namespace: default
spec:
   authServerSelector:
      matchLabels: #@ data.values.authserver_selector
   redirectURIs:
      - #@ redirect_uri
   requireUserConsent: false
   clientAuthenticationMethod: client_secret_basic
   authorizationGrantTypes:
      - "authorization_code"
   scopes:
      - name: "openid"
      - name: "email"
      - name: "profile"
      - name: "roles"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-application
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      name: test-application
  template:
    metadata:
      labels:
        name: test-application
    spec:
      containers:
        - image: bitnami/oauth2-proxy:7.3.0
          name: proxy
          ports:
            - containerPort: 4180
              name: proxy-port
              protocol: TCP
          env:
            - name: ISSUER_URI
              valueFrom:
                secretKeyRef:
                  name: my-client-registration
                  key: issuer-uri
            - name: CLIENT_ID
              valueFrom:
                secretKeyRef:
                  name: my-client-registration
                  key: client-id
            - name: CLIENT_SECRET
              valueFrom:
                secretKeyRef:
                  name: my-client-registration
                  key: client-secret
          command: [ "oauth2-proxy" ]
          args:
            - --oidc-issuer-url=$(ISSUER_URI)
            - --client-id=$(CLIENT_ID)
            - --insecure-oidc-skip-issuer-verification=true
            - --client-secret=$(CLIENT_SECRET)
            - --cookie-secret=0000000000000000
            - --cookie-secure=false
            - --http-address=http://:4180
            - --provider=oidc
            - --scope=openid email profile roles
            - --email-domain=*
            - --insecure-oidc-allow-unverified-email=true
            - --oidc-groups-claim=roles
            - --upstream=http://127.0.0.1:8000
            - #@ "--redirect-url=" + redirect_uri
            - --ssl-upstream-insecure-skip-verify=true
            - --ssl-insecure-skip-verify=true
            - --skip-provider-button=true
            - --pass-authorization-header=true
            - --prefer-email-to-user=true
        - image: python:3.9
          name: application
          resources:
            limits:
              cpu: 100m
              memory: 100Mi
          command: [ "python" ]
          args:
            - -c
            - |
              from http.server import HTTPServer, BaseHTTPRequestHandler
              import base64
              import json

              class Handler(BaseHTTPRequestHandler):
                  def do_GET(self):
                      if self.path == "/token":
                          self.token()
                          return
                      else:
                          self.greet()
                          return

                  def greet(self):
                      username = self.headers.get("x-forwarded-user")
                      self.send_response(200)
                      self.send_header("Content-type", "text/html")
                      self.end_headers()
                      page = f"""
                      <h1>It Works!</h1>
                      <p>You are logged in as <b>{username}</b></p>
                      <p><a href="/token">Show me my id_token (JSON format)</a></p>
                      """
                      self.wfile.write(page.encode("utf-8"))

                  def token(self):
                      token = self.headers.get("Authorization").split("Bearer ")[-1]
                      payload = token.split(".")[1].replace("-","+").replace("_","/")
                      decoded = base64.b64decode(bytes(payload, "utf-8") + b'==').decode("utf-8")
                      self.send_response(200)
                      self.send_header("Content-type", "application/json")
                      self.end_headers()
                      self.wfile.write(decoded.encode("utf-8"))

              server_address = ('', 8000)
              httpd = HTTPServer(server_address, Handler)
              httpd.serve_forever()

---
apiVersion: v1
kind: Service
metadata:
  name: test-application
  namespace: default
spec:
  ports:
    - port: 80
      targetPort: 4180
  selector:
    name: test-application

---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: test-application
  namespace: default
spec:
  rules:
    - host: #@ fqdn
      http:
        paths:
          - path: "/"
            pathType: Prefix
            backend:
              service:
                name: test-application
                port:
                  number: 80

```
