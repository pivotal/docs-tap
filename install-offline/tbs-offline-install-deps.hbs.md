# Install the Tanzu Build Service dependencies

This topic tells you how to install the Tanzu Build Service (TBS) full dependencies
on Tanzu Application Platform (commonly known as TAP).

By default, Tanzu Build Service is installed with `lite` dependencies.

When installing Tanzu Build Service on an air-gapped environment, the `lite` dependencies
cannot be used as they require Internet access.
You must install the `full` dependencies.

To install `full` dependencies:

<!-- The below partial is in the docs-tap/partials directory -->

{{> 'partials/full-deps' }}

## <a id='next-steps'></a>Next steps

- [Configure custom CAs for Tanzu Developer Portal](tap-gui-non-standard-certs-offline.hbs.md)
