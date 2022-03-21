# Pinniped compatibility 

This topic covers the compatibility details of [Pinniped](https://github.com/vmware-tanzu/pinniped) in GitHub.

## <a id="oauth"></a> Oauth

Oauth login is compatible only when both `--skip-browser` and `--skip-listen` flags are _not_ set.

## <a id="ldap"></a> LDAP

LDAP authentication is not compatible with VMware Tanzu Developer Tools for Visual Studio Code.
