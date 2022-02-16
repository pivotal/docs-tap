# Anonymous access

The REST API with client authentication provides a means to have the portal create and manage workshop sessions on your behalf but allow a separate system handle user authentication.

If you do not need to authenticate users but still want to provide your own front end from which users select a workshop, such as when integrating workshops into an existing web property, you can enable anonymous mode and redirect users to a URL for workshop session creation.

Note that using this is only recommended for temporary deployments and not for a permanent web site providing access to workshops.

## <a id="enabling-anonymous-access"></a>Enabling anonymous access

To enable full anonymous access to the training portal, you need to set the registration type to anonymous.

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
  ...
```

Users are still able to visit the training portal directly and view the catalog of available workshops. So don't link to the main page of the training portal. Instead, link from your custom index page to the individual links for creating each workshop.

## <a id="triggering-workshop-creation"></a>Triggering workshop creation

To trigger creation and allocation of a workshop to a user, you need to direct users browsers to a URL specific to the workshop. The form of this URL should be:

```
<training-portal-url>/workshops/environment/<name>/create/?index_url=<index>
```

Replace the value `<name>` with the name of the workshop environment corresponding to the workshop to be created.

Replace the value `<index>` with the URL for your custom index page where you list the workshops available. When a user completes the workshop, that user is redirected back to this index page. The user is also redirected back to this index page when an error occurs.

When a user is redirected back to the index page, a query string parameter is supplied to notify why the user is being returned. This is used to display a banner or other indication as to why the user was returned.

The name of the query string parameter is `notification` and the possible values are:

* `session-deleted` - Used when the workshop session is completed or restarted.
* `workshop-invalid` - Used when the name of the workshop environment supplied when attempting to create the workshop is invalid.
* `session-unavailable` - Used when capacity is reached and a workshop session cannot be created.
* `session-invalid` - Used when an attempt is made to access a session that doesn't exist. This can occur when the workshop dashboard is refreshed sometime after the workshop session has expired and been deleted.
