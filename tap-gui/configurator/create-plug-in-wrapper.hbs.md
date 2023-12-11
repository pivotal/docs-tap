# Create a Tanzu Developer Portal plug-in

This topic teaches you how to create a Tanzu Developer Portal plug-in by wrapping an existing
Backstage plug-in. After you create a Tanzu Developer Portal plug-in, you can
[build a customized Tanzu Developer Portal with Configurator](building.hbs.md).

## <a id="prereqs"></a> Prerequisites

Meet the following prerequisites before creating a Tanzu Developer Portal plug-in.

### <a id="software"></a> Software

Ensure that you have the following software installed locally to develop a Tanzu Developer Portal
plug-in:

- Node 16: `nvm` is recommended. For how to install `nvm`, see the `nvm`
  [GitHub repository](https://github.com/nvm-sh/nvm#install--update-script). For how to install a
  specific version of `nvm`, see the
  [NodeJS documentation](https://nodejs.org/en/download/package-manager/#nvm).
- [yarn v1](https://classic.yarnpkg.com/lang/en/)
- (Optional) A UNIX-based OS: If you use Windows, you must find alternatives to some commands in
  this topic.

### <a id="bckstg-plgn-npm"></a> A Backstage plug-in in an accessible npm registry

Ensure that the Backstage plug-in you want to wrap is in an npm registry. You can use your own
private registry or a public registry, such as [npm JS](https://www.npmjs.com/). Both your
development machine and your Tanzu Application Platform cluster must have access to the registry.

This topic instructs you to use the Backstage TechInsights plug-in. This plug-in consists of
back-end and front-end components, both of which are available on npm JS:

- [@backstage/plugin-tech-insights v0.3.11](https://www.npmjs.com/package/@backstage/plugin-tech-insights/v/0.3.11)
- [@backstage/plugin-tech-insights-backend v0.5.12](https://www.npmjs.com/package/@backstage/plugin-tech-insights-backend/v/0.5.12)

## <a id="set-up-dev-env"></a> Set up a development environment

This topic tells you how to create two Tanzu Developer Portal plug-ins by wrapping the
`tech-insights` and `tech-insights-backend` Backstage plug-ins. You can create a separate
repository for each of these plug-ins, but it's easier to do the work for both in a single monorepo.

## <a id="gen-bckstg-app"></a> Generate a Backstage app for the monorepo

This section describes how to use the Backstage tools `@backstage/create-app` and `backstage-cli` to
manage your monorepo. The Backstage tools make managing multiple packages easier. However, you will
not develop a traditional Backstage app, and you will remove some portions of generated code later.

1. Run the `create-app` script and, when prompted, enter a name for your app:

   ```console
   npx @backstage/create-app@0.5.2 --skip-install
   ```

   `@backstage/create-app` v0.5.2 is used because the Tanzu Developer Portal version that ships
   with Tanzu Application Platform v1.7 uses Backstage v1.15.0. Backstage v1.15.0 uses
   `@backstage/create-app` v0.5.2. For more information, see the
   [Backstage version manifest](https://github.com/backstage/versions/blob/main/v1/releases/1.15.0/manifest.json).

   > **Important** Ensure that you use the correct versions of dependencies for your
   > Tanzu Application Platform version. Use the
   > [Backstage version compatibility reference table](dependency-version-refs.hbs.md#bs-ver-table)
   > to find which versions of Backstage dependencies work with your version of Tanzu Application Platform.

   The `--skip-install` flag tells the script to not run `yarn install`, and therefore skip
   dependencies that are tied to building a traditional Backstage app.

   The `create-app` command scaffolds a Backstage project structure under a directory matching your
   project name.

1. Run:

   ```console
   cd APP-NAME
   ```

   Where `APP-NAME` is your application name. For example, `plugin-wrappers`.

### <a id="manage-deps"></a> Remove some dependencies and install others

To remove unnecessary dependencies and then install the ones you need:

1. Remove the packages directory by running:

   ```console
   rm -rf packages/
   ```

   The packages directory contains a scaffolded Backstage `app` and `backend`, which are only
   necessary for a traditional Backstage app.

1. Remove the packages directory from the `yarn` workspaces by deleting the `"packages/*"` line
   within the `workspaces` attribute in `package.json`. For example:

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

1. Install the dependencies by running:

   ```console
   yarn install --ignore-engines
   ```

   This command installs `backstage-cli` and a few other dependencies. The `--ignore-engines` flag
   is needed because a transitive dependency is expecting Node v18, but this Tanzu Developer Portal
   version currently only supports Node v16.

## <a id="tech-insights-frntnd-plgn"></a> Create the Tech Insights front-end Tanzu Developer Portal plug-in

Now that you have an environment to develop your Tanzu Developer Portal plug-ins, you can begin
wrapping Backstage plug-ins. You will start with the
[Tech Insight front-end plug-in](https://www.npmjs.com/package/@backstage/plugin-tech-insights/v/0.3.11).

### <a id="gen-frntnd-plgn"></a> Generate a front-end plug-in

This section describes how to generate a front-end plug-in.

> **Important** The `yarn install` step of the script will fail because of a Node version issue.
> This is handled in a later step.

1. Generate a front-end plug-in by running:

   ```console
   yarn backstage-cli new --select plugin --option id=tech-insights-wrapper --scope PACKAGE-NAMESPACE --no-private
   ```

   Where `PACKAGE-NAMESPACE` is the namespace for your package. For example, `@mycompany`.

   Here is a summary of what the `backstage-cli new` script does:

   - `--select plugin` creates a front-end plug-in
   - `--option id=tech-insights-wrapper` names the plug-in `tech-insights-wrapper`
   - `--scope PACKAGE-NAMESPACE` scopes the package under the `PACKAGE-NAMESPACE` namespace
   - `--no-private` sets the package to public

1. Open the `plugins/tech-insights-wrapper/package.json` to see how these options were mapped to the
   generated `package.json`.

### <a id="update-deps-frntnd"></a> Update dependencies for the front-end plug-in

To update your dependencies for the specific Backstage plug-in you want to wrap:

1. Replace the `dependencies` in the `package.json` with:

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

1. The dependency on `@backstage/plugin-tech-insights` is obvious, but verify the version is
   compatible with your Tanzu Application Platform version by reading the relevant
   [Dependency version reference](dependency-version-refs.hbs.md#bs-ver-table) table.

   `@backstage/plugin-catalog` is needed for a UI component you will use later.

1. Verify that you are using the correct versions of `@vmware-tanzu/core-common` and
   `@vmware-tanzu/core-frontend` by cross-referencing the dependency name with your
   Tanzu Application Platform version in the
   [Tanzu Developer Portal plug-in libraries compatibility table](dependency-version-refs.hbs.md#tdp-libraries).
   You will use `@vmware-tanzu/core-common` and `@vmware-tanzu/core-frontend` later for integrating
   the Backstage plug-in with Tanzu Developer Portal.

1. Install the dependencies you added by running:

   ```console
   cd plugins/tech-insights-wrapper
   yarn install --ignore-engines
   ```

### <a id="remove-code"></a> Remove unnecessary code for the front-end plug-in

The `backstage-cli new` command created example code that you don't need. Remove this code and start
with an empty `src` directory by running:

   ```console
   rm -rf dev/ src/ && mkdir src
   ```

### <a id="wrap-bs-frntnd-plgn"></a> Wrap the Backstage front-end plug-in

To wrap the Backstage plug-in:

1. Edit the contents of the `serviceEntityPage` constant to use `@backstage/plugin-tech-insights`.
   Because you do not have access to the Tanzu Developer Portal source code, you cannot change that
   constant directly. Instead, you must use a [surface](concepts.hbs.md#surfaces-and-wrappers) to make
   the equivalent change.
   For more information, see the [npm JS documentation](https://www.npmjs.com/package/@backstage/plugin-tech-insights/v/0.3.11#add-boolean-checks-overview-scorecards-page-to-the-entitypage).

1. Create the file where you will use a surface to edit the `serviceEntityPage` constant by running:

   ```console
   touch src/TechInsightsFrontendPlugin.tsx
   ```

1. In the `TechInsightsFrontendPlugin.tsx` file, add the following code:

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

   Where:

   - `context.applyTo` is a function that takes the class of the surface you want to interact with,
     and a function that is passed the instance of that class.

     <!-- TODO: need link to API reference documentation. ESBACK-387 -->

   - The `EntityPageSurface` keeps track of tabs that appear on the service page. You add a new tab by
     calling `entityPageSurface.servicePage.addTab` and passing it the UI component you want it to
     render.

     <!-- TODO: need link to API reference documentation. ESBACK-387 -->

   - `TechInsightsFrontendPlugin: AppPluginInterface = () => (context: SurfaceStoreInterface) => {}`
     is boilerplate code that enables you to interact with the various front-end surfaces in
     Tanzu Developer Portal.

   - `EntityPageSurface` is one example of the many surfaces available in Tanzu Developer Portal. To
     discover all the surfaces currently available, see [How to use surfaces](how-to-use-surfaces.hbs.md).
     For surface API reference information, see [API documentation for surfaces](api-docs.hbs.md).

   This code accomplishes the same thing as the
   [@backstage/plugin-tech-insights](https://www.npmjs.com/package/@backstage/plugin-tech-insights/v/0.3.11),
   but for an integration with Tanzu Developer Portal instead of a traditional Backstage app.

### <a id="expse-and-bld-frntnd-plgn"></a> Expose and build the Tanzu Developer Portal front-end plug-in

To expose and then build the front-end plug-in:

1. Create an `index.ts` file under the `plugins/tech-insights-wrapper/src` directory:

   ```console
   touch src/index.ts
   ```

1. In the `index.ts` file write:

   ```ts
   export { TechInsightsFrontendPlugin as plugin } from './TechInsightsFrontendPlugin';
   ```

   This exports `TechInsightsFrontendPlugin` in a way that enables Configurator to use your plug-in.
   You need to alias `TechInsightsFrontendPlugin` to `plugin` because the Tanzu Developer Portal
   Configurator expects compatible plug-ins to export a symbol with the name `plugin`.

1. Build your Tanzu Developer Portal plug-in by running:

   ```console
   yarn tsc && yarn build
   ```

You can now publish this plug-in to your npm registry. However, you cannot use the plug-in functions
without the back-end portion.

## <a id="tech-insights-bcknd-plgn"></a> Create the Tech Insights back-end Tanzu Developer Portal plug-in

Creating the back-end plug-in is very similar to the work you did for the front-end plug-in.
This section does not describe in detail what is happening at each step except for where it differs
from the previous work.

### <a id="gen-bcknd-plgn"></a> Generate a back-end plug-in

This describes how to generate a back-end plug-in.

> **Important** The `yarn install` step of the script fails because of a Node version issue.
> This is handled in a later step.

From the root of your project, generate a back-end plug-in by running:

```console
yarn backstage-cli new --select backend-plugin --option id=tech-insights-wrapper --scope PACKAGE-NAMESPACE --no-private
```

Where:

- `PACKAGE-NAMESPACE` is the namespace for your package. For example, `@mycompany`.
- `--select backend-plugin` tells the `backstage-cli` to generate a back-end plug-in. The ID you
  provide is the same as the front-end plug-in, `--option id=tech-insights-wrapper`.

`backstage-cli` automatically appends `-backend` to the directory and package-name of back-end
plug-ins to prevent conflict with the front-end plug-in.

### <a id="update-deps-bcknd"></a> Update dependencies for the back-end plug-in

To update your dependencies for the specific Backstage plug-in you want to wrap:

1. Update the dependencies in `package.json` as follows:

   ```json
   "dependencies": {
     "@backstage/plugin-tech-insights-backend": "0.5.12",
     "@backstage/plugin-tech-insights-backend-module-jsonfc": "0.1.30",
     "@vmware-tanzu/core-backend": "1.0.0",
     "express": "4.18.2"
   },
   ```

1. Install your dependencies by running:

   ```console
   cd plugins/tech-insights-wrapper-backend/
   yarn install --ignore-engines
   ```

1. Remove the Backstage scaffolded example code by running:

   ```console
   rm -rf src/ && mkdir src
   ```

1. Within the `src/` directory, create a file called `TechInsightsBackendPlugin.ts` by running:

   ```console
   touch src/TechInsightsBackendPlugin.ts
   ```

1. In `TechInsightsBackendPlugin.ts`, add the following code:

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

   > **Note** The majority of this code comes from the [npm JS documentation](https://www.npmjs.com/package/@backstage/plugin-tech-insights-backend/v/0.5.12#backend-example).
   > The [Backstage plug-in documentation](https://www.npmjs.com/package/@backstage/plugin-tech-insights-backend/v/0.5.12#adding-the-plugin-to-your-packagesbackend)
   > instructs you to create a constant for `techInsightsEnv` and then configure the router by using
   > `apiRouter.use('/tech-insights', await techInsights(techInsightsEnv))` all in the Backstage
   > source code. Because you are unable to edit the source code of Tanzu Developer Portal, the
   > next steps use a workaround.

1. Get an instance of the `BackendPluginSurface` instead. This surface keeps track of all the
   back-end plug-ins.

   <!-- TODO: link to reference docs ESBACK-387 -->

1. Add your plug-in by using the `addPlugin` function. The `name` argument is used to configure the
   path in the router.

   <!-- TODO: link to reference docs ESBACK-387 -->

### <a id="expse-and-bld-bcknd-plgn"></a> Expose and build the Tanzu Developer Portal back-end plug-in

To expose and then build the back-end plug-in:

1. Create an `index.ts` file by running:

   ```console
   touch src/index.ts
   ```

1. In the `index.ts` file, write:

   ```ts
   export { TechInsightsBackendPlugin as plugin } from './TechInsightsBackendPlugin';
   ```

   This exposes the Tanzu Developer Portal plug-in.

1. Build your plug-in by running:

   ```console
   yarn tsc && yarn build
   ```

## Next steps

You can now publish your Tanzu Developer Portal plug-ins to your registry of choice. If you want
to publish your plug-ins to a private registry, see
[Configure the Configurator with a private registry](private-registries.hbs.md).

After publishing your plug-ins, you can
[build a customized Tanzu Developer Portal with Configurator](building.hbs.md).
