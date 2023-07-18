# Manage token signature keys for Application Single Sign-On

This topic tells you how to manage token signature keys for Application Single Sign-On (commonly called AppSSO).

## Overview

An `AuthServer` must have token signature keys configured to be able to mint tokens.

For more information about token signatures, see [About token signatures](../../concepts/token-signature.hbs.md).

To learn how to manage keys of an `AuthServer`:

- [Creating keys](#creating-keys)
- [Rotating keys](#rotating-keys)
- [Revoking keys](#revoking-keys)

> "Token signature key" or just "key" is AppSSO's wording for a public/private key pair that is tasked with signing and
> verifying JSON Web Tokens (JWTs). For more information, please refer to the following resources:
>
> - [JSON Web Signature (JWS) spec](https://www.rfc-editor.org/rfc/rfc7515)
> - [JSON Web Algorithms (JWA) spec](https://www.rfc-editor.org/rfc/rfc7518)
> - [JSON Web Token (JWT) spec](https://www.rfc-editor.org/rfc/rfc7519)

## Creating keys

You can deploy an `AuthServer` without `spec.tokenSignature` but it won't be able to mint tokens. Therefore, keys must
be configured to make it fully operational. The following describe how to create and apply a keys for an `AuthServer`.

An RSA key can be created multiple ways. Below are two recommended approaches -- choose one.

### Using secretgen-controller

>**Important** This section assumes you have Tanzu Application Platform running on your cluster with `secretgen-controller` installed.

An [RSAKey CR](https://github.com/vmware-tanzu/carvel-secretgen-controller/blob/develop/docs/rsa_key.md) allows for
expedited creation of a Secret resource containing PEM-encoded public and private keys required by an `AuthServer`.

1. Create an `AuthServer` with `RSAKeys` as follows:

   ```yaml
   apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
   kind: AuthServer
   metadata:
     name: authserver-sample
     namespace: default
   spec:
     tokenSignature:
       signAndVerifyKeyRef:
         name: my-token-signing-key
       extraVerifyKeyRefs:
         - name: my-token-verification-key
     # ...
   ---
   apiVersion: secretgen.k14s.io/v1alpha1
   kind: RSAKey
   metadata:
     name: my-token-signing-key
     namespace: default
   spec:
     secretTemplate:
       type: Opaque
       stringData:
         key.pem: $(privateKey)
         pub.pem: $(publicKey)
   ---
   apiVersion: secretgen.k14s.io/v1alpha1
   kind: RSAKey
   metadata:
     name: my-token-verification-key
     namespace: default
   spec:
     secretTemplate:
       type: Opaque
       stringData:
         key.pem: $(privateKey)
         pub.pem: $(publicKey)
   ```

1. Observe the creation of an underlying `Secrets`. The name of the each `Secret` is the same as the `RSAKey` names:

   ```shell
   # Verify Secret exists
   kubectl get secret my-token-signing-key

   # View the base64-encoded keys
   kubectl get secret my-token-signing-key -o jsonpath='{.data}'
   ```

   You should be able to see two fields within the Secret resource: `key.pem` (private key) and `pub.pem` (public key).

1. Verify that the `AuthServer` serves its keys

   ```shell
   curl -s authserver-sample.default/oauth2/jwks | jq
   ```

If you encounter any issues with this approach, see [Carvel Secretgen Controller documentation](https://github.com/vmware-tanzu/carvel-secretgen-controller).

### Using OpenSSL

You can generate an RSA key yourself using OpenSSL. Here are the steps:

1. Generate a PEM-encoded RSA key pair

   This guide
   references [the freely published OpenSSL Cookbook](https://www.feistyduck.com/library/openssl-cookbook/online/ch-openssl.html#openssl-key-generation)
   and the approaches mentioned therein around generating a public and private key pair.

   ```bash
   # Generate an 4096-bit RSA key
   openssl genpkey -out privatekey.pem -algorithm RSA -pkeyopt rsa_keygen_bits:4096
   # -> privatekey.pem
   # The resulting private key output is in the PKCS#8 format

   # Next, extract the public key
   openssl pkey -in privatekey.pem -pubout -out publickey.pem
   # -> publickey.pem
   # The resulting public key output is in the PKCS#8 format

   # To view details of the private key
   openssl pkey -in privatekey.pem -text -noout
   ```

   > More [OpenSSL key generation examples here](https://www.openssl.org/docs/man1.1.1/man1/openssl-genpkey.html).

2. Create a secret resource by using the key generated earlier in this procedure:

   ```shell
   kubectl create secret generic my-key \
    --from-file=key.pem=privatekey.pem \
    --from-file=pub.pem=publickey.pem \
    --namespace default
   ```

3. Apply your `AuthServer`:

   ```yaml
      apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
      kind: AuthServer
      metadata:
        name: authserver-sample
        namespace: default
      spec:
        tokenSignature:
          signAndVerifyKeyRef:
            name: my-key
        # ...
   ```

4. Verify that the `AuthServer` serves its keys

   ```shell
   curl -s authserver-sample.default/oauth2/jwks | jq
   ```

## Rotating keys

This section describes how to "rotate" token signature keys for an `AuthServer`.

The action of "rotating" means moving the active token signing key into the set of token verification keys, generating a
new cryptographic key, and assigning it to be the designated token signing key.

Assuming that you have an `AuthServer` with token signature keys configured, rotate keys as follows:

1. Generate a new token signing key first. See [creating keys](#creating-keys). Verify that the new `Secret` exists
   before proceeding to the next step.

2. Edit `AuthServer.spec.tokenSignature`, append the existing `spec.tokenSignature.signAndVerifyKeyRef`
   to `spec.tokenSignature.extraVerifyKeys` and set your new key as `spec.tokenSignature.signAndVerifyKeyRef`.

   For example:

   ```yaml
   # Before
   ---
   apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
   kind: AuthServer
   metadata:
     name: authserver-sample
     namespace: default
   spec:
     tokenSignature:
       signAndVerifyKeyRef:
         name: old-key
       extraVerifyKeys: []
     # ...
   ```

   ```yaml
   # After
   ---
   apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
   kind: AuthServer
   metadata:
     name: authserver-sample
     namespace: default
   spec:
     tokenSignature:
       signAndVerifyKeyRef:
         name: new-key
       extraVerifyKeys:
         - name: old-key
     # ...
   ```

   Once you apply your changes, key rotation is effective immediately.

Moving the active token signing key to be a token verification key is an _optional_ step -- check out
the [Revoking keys](#revoking-keys) section for more.

## Revoking keys

This section describes how to "revoke" token signature keys for an `AuthServer`.

The action of "revoking" a key means to entirely remove the key from circulation by an `AuthServer`, whether it be a
token
signing key or a token verification key. This action might be needed if your organization requires a complete key
refresh where older keys are never retained. Another scenario might be in the case of an emergency in which a key or a
session has been compromised and a complete revocation is warranted.

To revoke an existing key or keys, you may remove any references to the keys in the `spec.tokenSignature`
resource. By removing the reference to the key, the system shall no longer acknowledge that the key is used for signing
or verifying JWTs.

For example, if you have a token signing key and a few verification keys:

```yaml
---
apiVersion: sso.apps.tanzu.vmware.com/v1alpha1
kind: AuthServer
metadata:
  name: authserver-sample
  namespace: default
spec:
  tokenSignature:
    signAndVerifyKeyRef:
      name: key-3
    extraVerifyKeys:
      - name: key-2
      - name: key-1
  # ...
```

To revoke an existing verification key, remove it from the `extraVerifyKeys` list. In the example above, you
can remove "key-2" and "key-1" from the list; JWTs signed with those keys will no longer be verifiable.

To revoke an existing token signing key, remove it from `signAndVerifyKeyRef` field. However, if you remove an existing
token signing key without a replacement key, the `AuthServer` will not be able to issue access tokens until a valid
token signing
key is provided. In the example above, "key-3" would be removed; the system will not be able to sign or verify JWTs.

## References and further reading

- [JSON Web Signature (JWS) - rfc7515 (ietf.org)](https://www.rfc-editor.org/rfc/rfc7515)
- [JSON Web Algorithms (JWA) spec](https://www.rfc-editor.org/rfc/rfc7518)
- [JSON Web Token (JWT) - rfc7519 (ietf.org)](https://www.rfc-editor.org/rfc/rfc7519)
