# About token signatures

This topic tells you about the concept of token signatures.

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

As a service operator, you have control over which keys are used for certain purposes.
For more information, see [Manage token signature keys for Application Single Sign-On](../how-to-guides/service-operators/configure-token-signature.hbs.md).