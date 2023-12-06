# Create a Tanzu Developer Portal plug-in

This topic teaches you how to create a Tanzu Developer Portal plug-in by wrapping an existing
Backstage plug-in. After you have created a Tanzu Developer Portal plug-in, you can
[build a customized Tanzu Developer Portal with Configurator](building.hbs.md).

## <a id="prereqs"></a> Prerequisites

Meet the following prerequisites before creating a Tanzu Developer Portal plug-in.

### <a id="software"></a> Software

Ensure you have the following software installed locally to develop a Tanzu Developer Portal plug-in:

- Node 16: `nvm` is recommended. For how to install `nvm`, see the
  [GitHub repository](https://github.com/nvm-sh/nvm#install--update-script). For installing a specific
  version of `nvm`, see [NodeJS](https://nodejs.org/en/download/package-manager/#nvm).
- [yarn v1](https://classic.yarnpkg.com/lang/en/)
- (Optional) A unix-based OS: If you use Windows, you must find alternatives to some commands in
  this topic.

### <a id="bckstg-plgn"></a> A Backstage plug-in in an accessible NPM registry

Ensure that the Backstage plug-in you want to wrap is in an npm registry. This registry can be your
own private registry or a public registry, such as [NPM JS](https://www.npmjs.com/). The registry is
accessible to your development machine as well as your Tanzu Application Platform cluster.

This topic instructs you to use the Backstage's TechInsights plug-in. This plug-in consists of
backend and frontend components, both of which are available on NPM JS:

- [@backstage/plugin-tech-insights version 0.3.11](https://www.npmjs.com/package/@backstage/plugin-tech-insights/v/0.3.11)
- [@backstage/plugin-tech-insights-backend version 0.5.12](https://www.npmjs.com/package/@backstage/plugin-tech-insights-backend/v/0.5.12)

## <a id="set-up-dev-env"></a> Set up a development environment

You will be creating two Tanzu Developer Portal plug-ins by wrapping the
[`tech-insights`](https://www.npmjs.com/package/@backstage/plugin-tech-insights/v/0.3.11)
and [`tech-insights-backend`](https://www.npmjs.com/package/@backstage/plugin-tech-insights-backend/v/0.5.12)
Backstage plug-ins. While you could create a separate repo for each of these plug-ins, we recommend
doing the work for both in a single monorepo.

### <a id="gen-bckstg-app"></a> Generate a Backstage app for the monorepo

You will be using some backstage tooling in order to manage your monorepo. Namely
`@backstage/create-app` and the `backstage-cli`. The Backstage tooling gives great convenience
functions for managing multiple packages. However, you will not be developing a traditional
backstage app and some portions of generated code will need to be removed.

### <a id="bckstg-plgn"></a> Backstage create app

Start by running the `create-app` script. When prompted, enter a name for your app. In this topic
we are using `plugin-wrappers` as the app name.

```shell
$ npx @backstage/create-app@0.5.2 --skip-install
```

Note the specific version `0.5.2` of `@backstage/create-app`. This is because the version of Tanzu
Developer Portal that ships with Tanzu Application Platform v1.7 uses Backstage version `1.15.0`,
and this version of Backstage uses verison `0.5.2` of `@backstage/create-app` as you can see in the
[Backstage version manifeset](https://github.com/backstage/versions/blob/main/v1/releases/1.15.0/manifest.json).

Making sure you use the correct versions of dependencies based on your Tanzu Application Platform
version is very important. Use the
[Backstage version compatibility reference table](dependency-version-refs.hbs.md#bs-ver-table)
to find what versions of Backstage dependencies will work with your version of Tanzu Application
Platform.

The `--skip-install` flag tells the script to not run a `yarn install`. This is because you will
remove the unnecessary dependencies that would have been needed if you were building a traditional
Backstage app.

The `create-app` command scaffolds a Backstage project structure under a directory matching your
project name: `plugin-wrappers`. When the command finishes running, `cd` into this directory:

```shell
$ cd plugin-wrappers
```

### <a id="rmv-deps"></a> Remove unnecessary dependencies

Before installing your dependencies you should remove the packages directory. This directory
contains a scaffolded Backstage `app` and `backend` which are only necessary for a traditional
Backstage app.

```shell
$ rm -rf packages/
```

And you need to remove the packages directory from the yarn workspaces. Edit the `package.json` file
to delete the `"packages/*"` line within the `workspaces` attribute.

```diff
diff --git a/package.json b/package.json
index 00d64c9..77f38f3 100644
--- a/package.json
+++ b/package.json
@@ -24,7 +24,6 @@
   },
   "workspaces": {
     "packages": [
-      "packages/*",
       "plugins/*"
     ]
   },
```

### <a id="install-deps"></a> Install dependencies

You are now ready to install your dependencies. Run the following:

```shell
$ yarn install --ignore-engines
```

This will install the `backstage-cli` and a few other dependencies. We need in include the
`--ignore-engines` flag here because a transitive dependency is expecting version 18 of Node, but
currently only version 16 is supported by Tanzu Developer Portal.

## <a id="tech-insights-frntnd-plgn"></a> Create the Tech Insights frontend Tanzu Developer Portal plug-in

Now that you have an environment to develop your Tanzu Developer Portal plug-ins, you can now start
the work of wrapping Backstage plug-ins. You will start with the
[Tech Insight frontend](https://www.npmjs.com/package/@backstage/plugin-tech-insights/v/0.3.11).

### <a id="gen-frntnd-plgn"></a> Generate a frontend plug-in

Run the following command replacing `@mycompany` with whatever namespace you would like to use for
your package:

```shell
$ yarn backstage-cli new --select plugin --option id=tech-insights-wrapper --scope @mycompany --no-private
```

You will notice that the `yarn install` step of the script will fail due to a Node version issue.
This is ok, you will address this in a later step.

Here is a breakdown of what the `backstage-cli new` script is doing:

- `--select plugin` creates a frontend plug-in
- `--option id=tech-insights-wrapper` names the plug-in `tech-insights-wrapper`
- `--scope @mycompany` scopes the package under the `@mycompany` namespace
- `--no-private` sets the package to public

Open the `plugins/tech-insights-wrapper/package.json` to see how these options were mapped to the
generated `package.json`.

### <a id="update-deps"></a> Update dependencies

Next update your dependencies for the specific Backstage plug-in you want to wrap.
Replace the `dependencies` in the `package.json` with the following:

```json
  ...
  "dependencies": {
    "@backstage/plugin-tech-insights": "0.3.11",
    "@backstage/plugin-catalog": "1.11.2",
    "@vmware-tanzu/core-common": "1.0.0",
    "@vmware-tanzu/core-frontend": "1.0.0"
  },
  ...
```

The dependency on `@backstage/plugin-tech-insights` is obvious, but the version should be checked for
[compatibility with your version of Tanzu Application Platform](dependency-version-refs.hbs.md#bs-ver-table).
`@backstage/plugin-catalog` is needed for a UI component we will be using.

`@vmware-tanzu/core-common` and `@vmware-tanzu/core-frontend` will be used later for the integration
between the Backstage plug-in and Tanzu Developer Portal. Verify you are using the correct versions
of `@vmware-tanzu/core-common` and `@vmware-tanzu/core-frontend` by cross-referencing the dependency
name against your Tanzu Application Platform version in the
[Tanzu Developer Portal plug-in libraries compatibility table](dependency-version-refs.hbs.md#tdp-libraries).

Now that you have added your necessary dependencies, install them by running the following:

```shell
$ cd plugins/tech-insights-wrapper
$ yarn install --ignore-engines
```

### <a id="rmv-gen-code"></a> Remove unneeded generated code

The `backstage-cli new` command creates a bunch of example code which you won't be using.
Remove this code and start with an empty `src` directory by running:

```shell
$ rm -rf dev/ src/ && mkdir src
```

### <a id="wrap-bckstg-plgn"></a> Wrap the Backstage plug-in

Take a look at the [documentation for @backstage/plugin-tech-insights](https://www.npmjs.com/package/@backstage/plugin-tech-insights/v/0.3.11).
You will see that in order to use this Backstage plug-in, you need to [modify the contents of the `serviceEntityPage` constant](https://www.npmjs.com/package/@backstage/plugin-tech-insights/v/0.3.11#add-boolean-checks-overview-scorecards-page-to-the-entitypage).
Since you do not have access to the Tanzu Developer Portal source code, you will not be able to
change that constant directly. Instead, you will use a [surface](concepts.hbs.md#surfaces-and-wrappers)
to make the equivalent change.

Start by creating the file where you will use a surface to modify the `serviceEntityPage` constant:

```shell
$ touch src/TechInsightsFrontendPlugin.tsx
```

In the `TechInsightsFrontendPlugin.tsx` file add the following content:

```tsx
import { EntityLayout } from '@backstage/plugin-catalog';
import { EntityTechInsightsScorecardContent } from '@backstage/plugin-tech-insights';
import {
  AppPluginInterface,
  SurfaceStoreInterface,
  EntityPageSurface,
} from '@vmware-tanzu/core-frontend';
import React from 'react';

export const TechInsightsFrontendPlugin: AppPluginInterface =
  () => (context: SurfaceStoreInterface) => {
    context.applyTo(
      EntityPageSurface,
      (entityPageSurface) => {
        entityPageSurface.servicePage.addTab(
          <EntityLayout.Route path="/techinsights" title="TechInsights">
            <EntityTechInsightsScorecardContent
              title="TechInsights Scorecard."
              description="TechInsight's default fact-checkers"
            />
          </EntityLayout.Route>,
        );
      },
    );
  };
```

The above code accomplishes the same thing as the
[documentation for @backstage/plugin-tech-insights](https://www.npmjs.com/package/@backstage/plugin-tech-insights/v/0.3.11),
but for an integration with Tanzu Developer Portal instead of a traditional Backstage app.
There are a few items to take note of here:

- `context.applyTo` is a function that takes the class of the surface you want to interact with, and
  a function that is passed the instance of that class
  <!-- TODO: need link to API reference documentation. ESBACK-387 -->
- The `EntityPageSurface` keeps track of tabs that appear on the service page. We add a new tab by
  calling `entityPageSurface.servicePage.addTab` and passing it the UI component we want it to
  render
  <!-- TODO: need link to API reference documentation. ESBACK-387 -->
- The `TechInsightsFrontendPlugin: AppPluginInterface = () => (context: SurfaceStoreInterface) => {}`
  code is boilerplate that allows us to interact with the various frontend surfaces in
  Tanzu Developer Portal

The `EntityPageSurface` used above is one example of the many surfaces available in
Tanzu Developer Portal.

- To explore all the surfaces that are currently available checkout the
  [How to use surfaces guide](how-to-use-surfaces.hbs.md)
- For surface API reference documentation see the [API documentation for surfaces](api-docs.hbs.md)

### <a id="expose-tdp-plgn"></a> Expose the Tanzu Developer Portal plug-in

In order for the Configurator to use your plug-in, you will need to export
`TechInsightsFrontendPlugin` in a specific way.

Start by creating an `index.ts` file under the `plugins/tech-insights-wrapper/src` directory:

```shell
$ touch src/index.ts
```

In the `index.ts` file put the following:

```ts
export { TechInsightsFrontendPlugin as plugin } from './TechInsightsFrontendPlugin';
```

The reason you need to alias `TechInsightsFrontendPlugin` to `plugin` is because the
Tanzu Developer Portal Configurator expects compatible plugins to export a symbol with the name
`plugin`.

### <a id="build-your-plug-in"></a> Build your plug-in

At this point you should be able to build your Tanzu Developer Portal plug-in:

```shell
$ yarn tsc && yarn build
```

From here you could publish this plug-in to your NPM registry. However, the plug-in's functionality
is not usable without the backend portion.

## <a id="tech-insights-bcknd-plgn"></a> Create the Tech Insights backend Tanzu Developer Portal plug-in

Creating the backend plug-in will be very similar to the work you just did for the frontend plug-in.
This section will not describe in detail what is happening at each step except for where it differs
from the prior work. If you want more in-depth explanations of each step, refer back to the
descriptions found above.

### <a id="gen-bcknd-plgn"></a> Generate a backend plug-in

From the root of your project run the following command replacing `@mycompany` with whatever
namespace you would like to use for your package:

```shell
$ yarn backstage-cli new --select backend-plugin --option id=tech-insights-wrapper --scope @mycompany --no-private
```

You will notice that the yarn install step of the script will fail due to a Node version issue.
This is ok, you will address this in a later step.

This time `--select backend-plugin` is specified, this tells the `backstage-cli` to generate a
backend plug-in. Another thing to note is that the id we provide is the same as the frontend plug-in
`--option id=tech-insights-wrapper`.

The `backstage-cli` will automatically append `-backend` to the directory and package name of
backend plugins, so this will not conflict with the frontend plug-in.

### <a id="update-deps"></a> Update dependencies

Update the dependencies in the package.json:

```json
  "dependencies": {
    "@backstage/plugin-tech-insights-backend": "0.5.12",
    "@backstage/plugin-tech-insights-backend-module-jsonfc": "0.1.30",
    "@vmware-tanzu/core-backend": "1.0.0",
    "express": "4.18.2"
  },
```

Install your dependencies by running:

```console
$ cd plugins/tech-insights-wrapper-backend/
$ yarn install --ignore-engines
```

Remove Backstage scaffolded example code:

```console
$ rm -rf src/ && mkdir src
```

Within the `src/` directory create a file called `TechInsightsBackendPlugin.ts`.

```console
$ touch src/TechInsightsBackendPlugin.ts
```

Then in the file `TechInsightsBackendPlugin.ts` add the following content:

```ts
import {
  createRouter,
  buildTechInsightsContext,
  createFactRetrieverRegistration,
  entityOwnershipFactRetriever,
  entityMetadataFactRetriever,
  techdocsFactRetriever,
} from '@backstage/plugin-tech-insights-backend';
import { Router } from 'express';
import {
  JsonRulesEngineFactCheckerFactory,
  JSON_RULE_ENGINE_CHECK_TYPE,
} from '@backstage/plugin-tech-insights-backend-module-jsonfc';
import {
  BackendPluginInterface,
  BackendPluginSurface,
  PluginEnvironment,
} from '@vmware-tanzu/core-backend';

const ttlTwoWeeks = { timeToLive: { weeks: 2 } };

export default async function createPlugin(
        env: PluginEnvironment,
): Promise<Router> {
  const techInsightsContext = await buildTechInsightsContext({
    logger: env.logger,
    config: env.config,
    database: env.database,
    discovery: env.discovery,
    tokenManager: env.tokenManager,
    scheduler: env.scheduler,
    factRetrievers: [
      createFactRetrieverRegistration({
        cadence: '0 */6 * * *', // Run every 6 hours - https://crontab.guru/#0_*/6_*_*_*
        factRetriever: entityOwnershipFactRetriever,
        lifecycle: ttlTwoWeeks,
      }),
      createFactRetrieverRegistration({
        cadence: '0 */6 * * *',
        factRetriever: entityMetadataFactRetriever,
        lifecycle: ttlTwoWeeks,
      }),
      createFactRetrieverRegistration({
        cadence: '0 */6 * * *',
        factRetriever: techdocsFactRetriever,
        lifecycle: ttlTwoWeeks,
      }),
    ],
    factCheckerFactory: new JsonRulesEngineFactCheckerFactory({
      logger: env.logger,
      checks: [
        {
          id: 'groupOwnerCheck',
          type: JSON_RULE_ENGINE_CHECK_TYPE,
          name: 'Group Owner Check',
          description:
                  'Verifies that a Group has been set as the owner for this entity',
          factIds: ['entityOwnershipFactRetriever'],
          rule: {
            conditions: {
              all: [
                {
                  fact: 'hasGroupOwner',
                  operator: 'equal',
                  value: true,
                },
              ],
            },
          },
        },
        {
          id: 'titleCheck',
          type: JSON_RULE_ENGINE_CHECK_TYPE,
          name: 'Title Check',
          description:
                  'Verifies that a Title, used to improve readability, has been set for this entity',
          factIds: ['entityMetadataFactRetriever'],
          rule: {
            conditions: {
              all: [
                {
                  fact: 'hasTitle',
                  operator: 'equal',
                  value: true,
                },
              ],
            },
          },
        },
        {
          id: 'techDocsCheck',
          type: JSON_RULE_ENGINE_CHECK_TYPE,
          name: 'TechDocs Check',
          description:
                  'Verifies that TechDocs has been enabled for this entity',
          factIds: ['techdocsFactRetriever'],
          rule: {
            conditions: {
              all: [
                {
                  fact: 'hasAnnotationBackstageIoTechdocsRef',
                  operator: 'equal',
                  value: true,
                },
              ],
            },
          },
        },
      ],
    }),
  });

  return await createRouter({
    ...techInsightsContext,
    logger: env.logger,
    config: env.config,
  });
}

export const TechInsightsBackendPlugin: BackendPluginInterface =
  () => surfaces =>
    surfaces.applyTo(BackendPluginSurface, backendPluginSurface => {
      backendPluginSurface.addPlugin({
        name: 'tech-insights',
        pluginFn: createPlugin,
      });
    });
```

The majority of the above code is pulled directly from the
[official documentation for @backstage/plugin-tech-insights-backend](https://www.npmjs.com/package/@backstage/plugin-tech-insights-backend/v/0.5.12#backend-example).

The
[Backstage plug-in documentation](https://www.npmjs.com/package/@backstage/plugin-tech-insights-backend/v/0.5.12#adding-the-plugin-to-your-packagesbackend)
also instructs you to create a constant for `techInsightsEnv` then configure the router by doing
`apiRouter.use('/tech-insights', await techInsights(techInsightsEnv))` all in the Backstage source
code. Because you are unable to modify the source code of Tanzu Developer Portal you will instead:

- Get an instance of the `BackendPluginSurface`, this surface keeps track of all the backend plug-ins
  <!-- TODO: link to reference docs ESBACK-387 -->
- Add your plug-in using the `addPlugin` function. The name argument will be used to configure the
  path in the router
  <!-- TODO: link to reference docs ESBACK-387 -->

### <a id="expose-tdp-plgn"></a> Expose the Tanzu Developer Portal plug-in

Start by creating an `index.ts` file:

```console
$ touch src/index.ts
```

In the `index.ts` file write the following:

```ts
export { TechInsightsBackendPlugin as plugin } from './TechInsightsBackendPlugin';
```

Now you can build your plugin

```console
$ yarn tsc && yarn build
```

## Next steps

You can now publish your Tanzu Developer Portal plug-ins to the registry of your choice. If you want
to publish your plug-ins to a private registry, see
[Configure the Configurator with a private registry](private-registries.hbs.md).
After you have published your plug-ins, you can
[build a customized Tanzu Developer Portal with Configurator](building.hbs.md).
