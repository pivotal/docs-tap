# Using surfaces

This topic gives you small basic examples of how to use the various surfaces when creating a
Tanzu Developer Portal plug-in.

<!-- ## ApiSurface -->

<!-- TODO -->

<!-- ## AppComponentSurface -->

<!-- TODO -->

<!-- ## AppPluginSurface -->

<!-- TODO -->

<!-- ## AppRouteSurface -->

<!-- TODO -->

<!-- ## BackendCatalogSurface -->

<!-- TODO -->

## <a id="backend-plugin-surface"></a> BackendPluginSurface

Use `BackendPluginSurface` if you must add routes to the `apiRouter` commonly found in
`packages/backend/src/index.ts`.

Example:

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

## <a id="banner-surface"></a> BannerSurface

`BannerSurface` enables you to add to the DOM at the top of the page before the content, which is
commonly used for banners. The only elements that can appear before the banners in the DOM are
`AlertDisplay` and `OAuthRequestDialog`. You can add multiple banners to the surface. The multiple
banners are rendered in order of registration.

Example:

```ts
import React from 'react';
import {
  AppPluginInterface,
  BannerSurface,
} from '@vmware-tanzu/core-frontend';

export const HelloWorldPlugin: AppPluginInterface = () => context => {
  context.applyTo(BannerSurface, banners => {
    banners.add(<div>Hello World Banner</div>);
  });
};
```

## <a id="entity-page-surface"></a> EntityPageSurface

Use `EntityPageSurface` if you must add to the `serviceEntityPage` constant found in
`packages/app/src/components/catalog/EntityPage.tsx`.

Example:

```ts
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

<!-- ## HomeSurface -->

<!-- TODO -->

<!-- ## LdapSurface -->

<!-- TODO -->

<!-- ## LoggerOptionsSurface -->

<!-- TODO -->

<!-- ## LoginSurface -->

<!-- TODO -->

<!-- ## MicrosoftGraphOrgReaderProcessorTransformersSurface -->

<!-- TODO -->

<!-- ## PermissionPolicySurface -->

<!-- TODO -->

## <a id="settings-tabs-surface"></a> SettingsTabsSurface

Use `SettingsTabsSurface` if you want to add child routes to the `/settings` route defined in the
`route` constant of `packages/app/src/App.tsx`. This action also adds a tab to the settings page so
that you can use the UI to access your new route.

Example:

```ts
import React from 'react';
import {
  AppPluginInterface,
  SettingsTabsSurface,
} from '@vmware-tanzu/core-frontend';
import { SettingsLayout } from '@backstage/plugin-user-settings';

export const HelloWorldPlugin: AppPluginInterface = () => context => {
  context.applyTo(SettingsTabsSurface, tabs =>
    tabs.add(
      <SettingsLayout.Route path="/hello-world" title="Hello World Tab">
        <div>Hello World Settings Tab Content</div>
      </SettingsLayout.Route>,
    ),
  );
};

```

## <a id="sidebar-item-surface"></a> SidebarItemSurface

`SidebarItemSurface` enables you to render links in the sidebar to quickly access your
plug-in. `SidebarItemsSurface` enables you to change the content of the `root` constant
in `packages/app/src/components/Root/Root.tsx`. All items you add to the sidebar appear at the
bottom of existing sidebar items, in the order that they were registered.

Example:

```ts
import React from 'react';
import { SidebarItem } from '@backstage/core-components';
import {
  AppPluginInterface,
  SidebarItemSurface,
} from '@vmware-tanzu/core-frontend';
import AlarmIcon from '@material-ui/icons/Alarm';

export const HelloWorldPlugin: AppPluginInterface = () => context => {
  context.applyTo(SidebarItemSurface, sidebar =>
    sidebar.addMainItem(
      <SidebarItem icon={AlarmIcon} to="hello-world" text="Hello" />,
    ),
  );
};
```

<!-- ## SignInProviderSurface -->

<!-- TODO -->

<!-- ## SignInResolverSurface -->

<!-- TODO -->

<!-- ## ThemeSurface -->

<!-- TODO -->