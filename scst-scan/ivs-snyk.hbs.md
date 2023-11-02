
# Configure an ImageVulnerabilityScan for Snyk

This topic tells you how to configure an ImageVulnerabilityScan for Snyk. 

Use the following ImageVulnerabilityScan and secret configuration:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: snyk-token
stringData:
  snyk: |
    {"api": "SNYK-API-TOKEN"}
---
apiVersion: app-scanning.apps.tanzu.vmware.com/v1alpha1
kind: ImageVulnerabilityScan
metadata:
  name: snyk-ivs
spec:
  image: nginx@sha256:... # The image to be scanned. Digest must be specified.
  scanResults:
    location: registry/project/scan-results
  serviceAccountNames:
    publisher: publisher
    scanner: scanner
  workspace:
    bindings:
    - name: snyk
      secret:
        secretName: snyk-token
        items:
          - key: snyk
            path: configstore/snyk.json
  steps:
  - name: snyk
    image: SNYK-SCANNER-IMAGE
    env:
    - name: XDG_CONFIG_HOME
      value: /snyk
    command: ["snyk","container","test",$(params.image),"--json-file-output=$(params.scan-results-path)/scan.json"]
    onError: continue
  - name: snyk2spdx # You will need to create your own image. See explanation below.
    image: SNYK2SPDX-IMAGE
    command: ["/bin/bash"]
    args:
      - "-c"
      - |
        set -e
        cat $(params.scan-results-path)/scan.json | /app/bin/snyk2spdx --output=$(params.scan-results-path)/scan.spdx.json
```

Where:

- `TARGET-IMAGE` is the image to be scanned. You must specify the digest.
- `SNYK-SCANNER-IMAGE` is the image containing the Snyk CLI. For example, `snyk/snyk:golang`.
  For information about publicly available Snyk images, see [DockerHub](https://hub.docker.com/r/snyk/snyk).
  For more information about using the Snyk CLI, see the [Snyk documentation](https://docs.snyk.io/snyk-cli).
- `XDG_CONFIG_HOME` is the directory that contains your Snyk CLI config file, `configstore/snyk.json`,
  which is populated using the snyk-token `Secret` you created.
  For more information, see the [Snyk Config documentation](https://docs.snyk.io/snyk-cli/commands/config).
- `SNYK2SPDX-IMAGE` is the image used to convert the Snyk CLI output `scan.json` in the `snyk` step
  to SPDX format and have its missing `DOCUMENT DESCRIBES` relation inserted.
  See the Snyk [snyk2spdx repository](https://github.com/snyk-tech-services/snyk2spdx) in GitHub. Here is one way to do it:
    1. Clone the [snyk2spdx repository](https://github.com/snyk-tech-services/snyk2spdx)
    2. Add the following Dockerfile to the root of the repository:
        ```
        FROM node AS build

        RUN npm install -g typescript
        RUN npm install -g ts-node

        WORKDIR /build-dir
        ADD . .

        RUN npm install --legacy-peer-deps
        RUN npm run build && npm prune --json --omit=dev --legacy-peer-deps
        RUN npx nexe@3.3.7 dist/index.js  -r './dist/**/*.js' -t linux-x64-12.16.2 -o snyk2spdx-linux

        FROM paketobuildpacks/builder-jammy-base AS run

        COPY --from=build /build-dir/dist/ /app/dist/
        COPY --from=build /build-dir/node_modules /app/node_modules
        COPY --from=build /build-dir/snyk2spdx-linux /app/bin/snyk2spdx

        ENTRYPOINT ["/app/bin/snyk2spdx"]
        CMD ["/app/bin/snyk2spdx"]
        ```
    3. Build and push the image to a registry. Replace `SNYK2SPDX-IMAGE` with
      the new image you just built.
    > **Note** The `snyk2spdx` output is not conformant to the [verification process](./verify-app-scanning-supply-chain.hbs.md) although the results may be ingested to the Tanzu Application Platform metadata store, VMware does not guarantee the accuracy of the results.

> **Note** After detecting vulnerabilities, the Snyk image exits with Exit Code 1 and causes a failed scan task. You can ignore the step error by setting [onError](https://tekton.dev/docs/pipelines/tasks/#specifying-onerror-for-a-step) and handling the error in a subsequent step.

For information about setting up scanner credentials, see the [Snyk CLI documentation](https://docs.snyk.io/snyk-cli/commands/config).