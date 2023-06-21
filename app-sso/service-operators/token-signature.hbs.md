# Token signatures for AppSSO

This topic tells you how to configure token signatures keys for Application Single 
Sign-On (commonly called AppSSO).

## Overview

An `AuthServer` must have token signature keys configured to be able to mint tokens.

Learn about token signatures and how to manage keys of an `AuthServer`:

- [Token signature 101](#token-signature-101)
- [Token signature in AppSSO](#token-signature-of-an-authserver)
- [Creating keys](#creating-keys)
- [Rotating keys](#rotating-keys)
- [Revoking keys](#revoking-keys)

> "Token signature key" or just "key" is AppSSO's wording for a public/private key pair that is tasked with signing and
> verifying JSON Web Tokens (JWTs). For more information, please refer to the following resources:
>
> - [JSON Web Signature (JWS) spec](https://www.rfc-editor.org/rfc/rfc7515)
> - [JSON Web Algorithms (JWA) spec](https://www.rfc-editor.org/rfc/rfc7518)
> - [JSON Web Token (JWT) spec](https://www.rfc-editor.org/rfc/rfc7519)

## Token signature 101

Token signature keys are used by an `AuthServer` to sign JSON Web Tokens (JWTs), produce
a [JWS Signature](https://www.rfc-editor.org/rfc/rfc7515) and attach it to
the [JOSE Header](https://www.rfc-editor.org/rfc/rfc7515#section-4) of a JWT. The client application can then verify the JWT signature.

A private key signs a JWT. A public key verifies the signature of a signed JWT.

The sign-and-verify mechanism serves multiple security purposes:

- **Authenticity**: signature verification ensures that the issuer of the JWT is from a source that is advertised.
- **Integrity**: signature verification ensures that the JWT has not been altered in transit or during its issued
  lifetime. [Integrity is a foundational pillar of the CIA triad concept in Information Security.](https://www.nccoe.nist.gov/publication/1800-25/VolA/index.html)
- **Non-repudiation**: signature verification ensures that the authorization server that signed the JWT cannot deny that
  they have signed it after its issuance (granted that the signing key that signed the JWT is available).

AppSSO only supports the `RS256` algorithm for signing tokens. For more information, see [JSON Web Algorithms (JWA) documentation](https://www.rfc-editor.org/rfc/rfc7518#section-3).

## Token signature of an `AuthServer`

You must configure token signatures for `AuthServer`. An `AuthServer` receives its keys under `spec.tokenSignature`. For example:

```yaml
spec:
  tokenSignature:
    signAndVerifyKeyRef:
      name: sample-token-signing-key
    extraVerifyKeyRefs:
      - name: sample-token-verification-key-1
      - name: sample-token-verification-key-2
```

There can only be **one** token signing key `spec.tokenSignature.signAngVerifyKeyRef` at any given time, and arbitrarily
many token verification keys `spec.tokenSignature.extraVerifyKeyRefs`. The token signing key is used to sign and verify
actively issued JWTs in circulation, whereas token verification keys are used to verify issued JWTs signatures. Token
verification keys are thought to be previous token signing keys but have been rotated into verify only mode as a
rotation mechanism measure, and can potentially be slated for eviction at a predetermined time.

The `AuthServer` serves its public keys at `{spec.issuerURI}/oauth2/jwks`. For example:

```shell
❯ curl -s authserver-sample.default/oauth2/jwks | jq
{
  "keys": [
    {
      "kty": "RSA",
      "e": "AQAB",
      "kid": "sample-token-signing-key",
      "n": "0iCinir7sWKZE_3QXq4eTub_GU-lvdAKFI9dzDlwX7XZwwSERuzzQQ_Fs7i9djMl5bpv2ma_3ZB-j2W9pR9ZIa3nqBI29AHqx2zmVQ8w-GxPDGRMkBdMOWNwyDQGIRlQnJFpXRoSQ5_viM9gYA56WthkDghrupGUiB_zqGFYlgnz7sd4lC-thgEkDi9vY68DLIFdsXOQIXFqakyEIo43n_0vg6JRGQW1LU_32Ok6OgA3r6bYcE8VQhJW3sE1qOSFcP0JrPA3YgmTNuDV6GoCLZeMxDdMDKdDcH5UgERLQe1qMMKwlMCeKamOWgo9eBvcFnWNR0I_MJV6F14U1WbIcQ"
    },
    {
      "kty": "RSA",
      "e": "AQAB",
      "kid": "sample-token-verification-key-1",
      "n": "wc7uOACU62Yu_zKT9YrI4v-_X3L47nbVlcByi4UTVhg8o001OkiYAPAEoDCEHnDg_54gTWxe3hDRcOJrd72PkTAaxH8aFdikoyakRVG9NvAPbcfzvI8R8plepUbs1U7TPPDEDARm_fZX6QdVyz0CTSafrz-yktTADxJhYPgvFLeHq7g7RouB1szTWDCM1haoxKa4960_x9meghNn87z0uF3cAd7TM_k3capYnxNOUT5g1vjJ05Vk14JUl4R294OpMXPCGcFuvu9auXeBqXyKxxTAnLkDdNrgtT0FJHwnh4RGnrNqjYZOwlRvGbzwQ7du97aU2-qgbKkJrWYZWcw2bQ"
    },
    {
      "kty": "RSA",
      "e": "AQAB",
      "kid": "sample-token-verification-key-2",
      "n": "qELrLiaD-IVp_nthVn2EsLuShtU9ovyVIPkLVf47AqKogPV2frE_6Sv8k7Zim-SgDXfjLEg-UGlQrb4KFm_WkaK2Uf6PCapiBnMi1Q5P8qC0WC5LT6XyPY1exCQbMrEsyd89oS0sKxgoc3Qv0XV24jGYiWQyJ7I0Rub_QEldGM_dSlfbI-1Qt_U6Ll22OEc1D6P1A3MdDrgbur6N7ZemxlKI26-OAdlbNi0u-lFNj3Ss-pfTVi_fD2hAajRRmc4tmHejQjH36M4F1NSW_gTbb6VX5EerVuDwSCCK0EuGvhcb1hg6kYEoO-qws54AQ0PywBXT5qksCMBmmzjP6qO4Ow"
    }
  ]
}
```

>**Caution** Changes to `spec.tokenSignature.signAngVerifyKeyRef` have immediate effects.

As a _service operator_, you have control over which keys are used for certain purposes. Navigate to the next few
sections for more information.

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

2. Create a Secret resource by using the key generated earlier in this procedure:

   ```shell
   # Create Secret resource
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
