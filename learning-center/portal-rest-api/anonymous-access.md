# Anonymous access

The REST API with client authentication provides a means to have the portal create and manage workshop sessions on your behalf but allow a separate system handle user authentication.

If you do not need to authenticate users but still want to provide your own front end from which users select a workshop, such as when integrating workshops into an existing web property, you can enable anonymous mode and redirect users to a URL for workshop session creation.

>**Note:** Anonymous mode is only recommended for temporary deployments and not for a permanent web site providing access to workshops.

## <a id="enabling-anonymous-access"></a>Enabling anonymous access

You can set the registration type to `anonymous` to enable full anonymous access to the training portal.

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

>**Note:** Users can still visit the training portal directly and view the catalog of available workshops, so instead of linking to the main page of the training portal, link from your custom index page to the individual links for creating each workshop.

## <a id="triggering-workshop-creation"></a>Triggering workshop creation

Follow these steps to trigger creation and allocation of a workshop to a user:

1. Direct users browsers to a URL specific to the workshop. The form of the URL is:

    ```
    <training-portal-url>/workshops/environment/<name>/create/?index_url=<index>
    ```

1. Replace the value `<name>` with the name of the workshop environment corresponding to the workshop to be created.

1. Replace the value `<index>` with the URL for your custom index page where you list the workshops available.

    The user is redirected back to this index page when:

    - a user completes the workshop
    - an error occurs

    When a user is redirected back to the index page, a query string parameter is supplied to display a banner or other indication about why the user was returned.

    The name of the query string parameter is `notification` and the possible values are:

    * `session-deleted` - Used when the workshop session is completed or restarted.
    * `workshop-invalid` - Used when the name of the workshop environment created is invalid.
    * `session-unavailable` - Used when capacity is reached and a workshop session cannot be created.
    * `session-invalid` - Used when an attempt is made to access a session that doesn't exist. This can occur when the workshop dashboard is refreshed after the workshop session is expired and deleted.
