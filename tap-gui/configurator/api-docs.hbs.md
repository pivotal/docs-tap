# API documentation for surfaces

This topic tells you about API references for surfaces in Tanzu Developer Portal.

## Package @tpb/plugin-catalog

### Class EntityPageSurface

Manipulate contents of pages for Backstage catalog entities.

Each catalog entity subtype can specify a dedicated template. This surface standardizes the contents
of those templates and allows for some amount of external configuration.

Here's an example of adding a tab to the template for Backstage Service entities:

```typescript
context.applyWithDependency(
  AppRouteSurface,
  EntityPageSurface,
  (_, surface) => {
       surface.servicePage.addTab(
         <EntityLayout.Route path="/some-subpath" title="Additional content for Services">
           <MyAdditionalContent />
         </EntityLayout.Route>,
       );
     },
  );
```

#### Properties

| Property             | Type             | Description |
|----------------------|------------------|-------------|
| `apiPage`            | `ApiPage`        |             |
| `componentPageCases` | `ReactElement[]` |             |
| `defaultPage`        | `BasicPage`      |             |
| `domainPage`         | `BasicPage`      |             |
| `groupPage`          | `BasicPage`      |             |
| `packagePage`        | `BasicPage`      |             |
| `servicePage`        | `BasicPage`      |             |
| `systemPage`         | `BasicPage`      |             |
| `userPage`           | `BasicPage`      |             |
| `websitePage`        | `BasicPage`      |             |

#### Constructors

##### constructor()

Constructs a new instance of the `EntityPageSurface` class

#### Methods

##### addComponentPageCase(pageCase: ReactElement): void

| Parameter  | Type         | Description |
|------------|--------------|-------------|
| `pageCase` | ReactElement |             |

##### addOverviewContent(content: ReactElement): void

| Parameter | Type         | Description |
|-----------|--------------|-------------|
| `content` | ReactElement |             |

## Package @vmware-tanzu/core-backend

### Types

<a name="vmware-tanzu-core-backend-backend-plugin-interface-type" />`BackendPluginInterface<T = {}> = (config?: T & BackendPluginConfig) => TpbPluginInterface;`

<a name="vmware-tanzu-core-backend-catalog-processor-builder-type" />`CatalogProcessorBuilder = (env: PluginEnvironment) => CatalogProcessor[] | CatalogProcessor;`

<a name="vmware-tanzu-core-backend-entity-provider-builder-type" />`EntityProviderBuilder = (env: PluginEnvironment) => EntityProvider[] | EntityProvider;`

<a name="vmware-tanzu-core-backend-permission-rule-builder-type" />`PermissionRuleBuilder = (env: PluginEnvironment) => CatalogPermissionRule[] | CatalogPermissionRule;`

<a name="vmware-tanzu-core-backend-plugin-fn-type" />`PluginFn = (env: PluginEnvironment) => Promise<Router>;`

<a name="vmware-tanzu-core-backend-router-builder-type" />`RouterBuilder = (env: PluginEnvironment) => Promise<Router>;`

### Class BackendCatalogSurface

Manipulate the catalog backend.

Provides extension points for registering catalog processors, entity providers, routes, and permissions.

#### Constructors

##### constructor()

Constructs a new instance of the `BackendCatalogSurface` class

#### Methods

##### addCatalogProcessorBuilder(builder: CatalogProcessorBuilder): void

Register a Backstage CatalogProcessor that will apply transformations to unprocessed entities

[https://backstage.io/docs/features/software-catalog/configuration/\#processors](https://backstage.io/docs/features/software-catalog/configuration/#processors)

[https://backstage.io/docs/features/software-catalog/life-of-an-entity\#processing](https://backstage.io/docs/features/software-catalog/life-of-an-entity#processing)

| Parameter | Type                                                                                 | Description                                              |
|-----------|--------------------------------------------------------------------------------------|----------------------------------------------------------|
| `builder` | [CatalogProcessorBuilder](#vmware-tanzu-core-backend-catalog-processor-builder-type) | Builds a CatalogProcessor for a given PluginEnvironment. |

##### addEntityProviderBuilder(builder: EntityProviderBuilder): void

Register a Backstage EntityProvider to ingest generate catalog entries for further processing.

[https://backstage.io/docs/features/software-catalog/life-of-an-entity\#ingestion](https://backstage.io/docs/features/software-catalog/life-of-an-entity#ingestion)

| Parameter | Type                                                                             | Description                                             |
|-----------|----------------------------------------------------------------------------------|---------------------------------------------------------|
| `builder` | [EntityProviderBuilder](#vmware-tanzu-core-backend-entity-provider-builder-type) | Builds an EntityProvider for a given PluginEnvironment. |

##### addPermissionRuleBuilder(builder: PermissionRuleBuilder): void

Register Backstage CatalogPermissionRules to limit access to catalog entries.

[https://backstage.io/docs/permissions/custom-rules](https://backstage.io/docs/permissions/custom-rules)

| Parameter | Type                                                                             | Description                                                  |
|-----------|----------------------------------------------------------------------------------|--------------------------------------------------------------|
| `builder` | [PermissionRuleBuilder](#vmware-tanzu-core-backend-permission-rule-builder-type) | Builds CatalogPermissionRules for a given PluginEnvironment. |

##### addRouterBuilder(routerBuilder: RouterBuilder): void

Register an Express Router to handle arbitrary requests made to the Backstage backend.

| Parameter       | Type                                                            | Description                                             |
|-----------------|-----------------------------------------------------------------|---------------------------------------------------------|
| `routerBuilder` | [RouterBuilder](#vmware-tanzu-core-backend-router-builder-type) | Builds an Express Router for a given PluginEnvironment. |

### Class BackendPluginSurface

Add plugins to the Backstage backend.

#### Constructors

##### constructor()

Constructs a new instance of the `BackendPluginSurface` class

#### Methods

##### addPlugin(plugin: Plugin): void

Register a named plugin to handle backend requests at some subpath.

Plugins must have unique names. The first plugin registered with a given name wins.

| Parameter | Type                                                    | Description   |
|-----------|---------------------------------------------------------|---------------|
| `plugin`  | [Plugin](#vmware-tanzu-core-backend-plugin-2-interface) | Plugin to add |

## Package @vmware-tanzu/core-frontend

### Types

<a name="vmware-tanzu-core-frontend-app-plugin-interface-type" />`AppPluginInterface<T = {}> = (config?: T) => TpbPluginInterface;`

### Class ApiSurface

Add Backstage ApiFactories.

#### Methods

##### add(factory: AnyApiFactory): void

Register a new Backstage ApiFactory.

Factories must specify an API with a unique ID. The last factory registered with a given ID wins.

Factories that specify APIs with IDs on the ignored list will not be registered.

| Parameter | Type          | Description |
|-----------|---------------|-------------|
| `factory` | AnyApiFactory |             |

### Class AppComponentSurface

Substitute replaceable core components of the Backstage app.

#### Constructors

##### constructor()

Constructs a new instance of the `AppComponentSurface` class

#### Methods

##### add&lt;K extends keyof AppComponents&gt;(key: K, component: AppComponents\[K\]): void

Substitute a given Backstage AppComponent.

AppComponents must be unique by key. The last AppComponent registered with a given key wins.

| Parameter   | Type          | Description                                                |
|-------------|---------------|------------------------------------------------------------|
| `key`       |               | Unique key for the AppComponent.                           |
| `component` | AppComponents | Custom AppComponent to substitute for Backstage's default. |

### Class AppPluginSurface

Register additional frontend plugins with the Backstage app.

[https://backstage.io/docs/plugins/](https://backstage.io/docs/plugins/)

#### Constructors

##### constructor()

Constructs a new instance of the `AppPluginSurface` class

#### Methods

##### add(plugin: BackstagePlugin): void

Register a frontend BackstagePlugin.

| Parameter | Type            | Description |
|-----------|-----------------|-------------|
| `plugin`  | BackstagePlugin |             |

### Class AppRouteSurface

Manipulate routes in the frontend Backstage app.

[https://backstage.io/docs/plugins/composability/\#routing-system](https://backstage.io/docs/plugins/composability/#routing-system)

#### Constructors

##### constructor()

Constructs a new instance of the `AppRouteSurface` class

#### Methods

##### add(route: ReactElement): void

Register a react-router Route.

| Parameter | Type         | Description                                                                  |
|-----------|--------------|------------------------------------------------------------------------------|
| `route`   | ReactElement | Route to register. Intended to be a react-router\#Route or a subclass of it. |

##### addRouteBinder(routeBinder: RouteBinder): void

Bind external routes.

[https://backstage.io/docs/plugins/composability/\#binding-external-routes-in-the-app](https://backstage.io/docs/plugins/composability/#binding-external-routes-in-the-app)

| Parameter     | Type        | Description |
|---------------|-------------|-------------|
| `routeBinder` | RouteBinder |             |

### Class BannerSurface

Add page-level banners to the Backstage app.

#### Constructors

##### constructor()

Constructs a new instance of the `BannerSurface` class

#### Methods

##### add(banner: ReactElement): void

Add a new page-level banner.

| Parameter | Type         | Description |
|-----------|--------------|-------------|
| `banner`  | ReactElement |             |

### Class SettingsTabsSurface

Add tabs to the Settings page.

#### Constructors

##### constructor()

Constructs a new instance of the `SettingsTabsSurface` class

#### Methods

##### add(tab: ReactElement): void

Add a new tab to the Settings page.

| Parameter | Type         | Description                                                                                             |
|-----------|--------------|---------------------------------------------------------------------------------------------------------|
| `tab`     | ReactElement | Typically an instance of @<!-- -->backstage/<!-- -->@<!-- -->plugin-user-settings\#SettingsLayout.Route |

### Class SidebarItemSurface

Manipulate entries in sidebar.

Entries are split into two sections: "top items" appear above a divider and "main items" appear
below it. Tabs within each section are rendered in order of registration.

#### Constructors

##### constructor()

Constructs a new instance of the `SidebarItemSurface` class

#### Methods

##### addMainItem(item: ReactElement): void

Add an item to the "main items" section.

| Parameter | Type         | Description |
|-----------|--------------|-------------|
| `item`    | ReactElement |             |

##### addTopItem(item: ReactElement): void

Add an item to the "top items" section.

| Parameter | Type         | Description |
|-----------|--------------|-------------|
| `item`    | ReactElement |             |

### Class ThemeSurface

Manipulate themes available to the Backstage application.

#### Constructors

##### constructor()

Constructs a new instance of the `ThemeSurface` class

#### Methods

##### addTheme(theme: AppTheme): void

Register an additional theme.

| Parameter | Type     | Description |
|-----------|----------|-------------|
| `theme`   | AppTheme |             |

##### setRootBuilder(builder: (children: JSX.Element) =&gt; ReactElement): void

Register the factory that renders the application's root element.

| Parameter | Type                    | Description |
|-----------|-------------------------|-------------|
| `builder` | JSX.ElementReactElement |             |

## Package @vmware-tanzu/tdp-plugin-auth-backend

### Class SignInProviderSurface

Register additional Auth Providers.

[https://backstage.io/docs/auth/add-auth-provider](https://backstage.io/docs/auth/add-auth-provider)

#### Methods

##### add(signInProvider: SignInProvider): void

Register an additional Auth Provider.

Last named Auth Provider wins.

| Parameter        | Type           | Description                                                                   |
|------------------|----------------|-------------------------------------------------------------------------------|
| `signInProvider` | SignInProvider | Map of @<!-- -->backstage/plugin-auth-backend\#AuthProviderFactory instances. |

### Class SignInResolverSurface

Register SignInResolvers and provide utility methods to log in with them.

#### Methods

##### add(authProviderKey: string, resolver: SignInResolver&lt;any&gt;): void

Register a new SignInResolver.

| Parameter         | Type           | Description                                                                                                        |
|-------------------|----------------|--------------------------------------------------------------------------------------------------------------------|
| `authProviderKey` |                | Name resolver to add. Uniqueness of name is not enforced but the behavior of duplicate named entries is undefined. |
| `resolver`        | SignInResolver | Resolver to add.                                                                                                   |

##### getResolver&lt;TAuthResult&gt;(authProviderKey: string): SignInResolver&lt;TAuthResult&gt;

Get the first named provider, or fall back to the guest resolver.

| Parameter         | Type | Description |
|-------------------|------|-------------|
| `authProviderKey` |      |             |

##### signInAsGuestResolver&lt;TAuthResult&gt;(): SignInResolver&lt;TAuthResult&gt;

Get a resolver that creates an ad-hoc guest user.

##### signInWithEmail(email: string, context: AuthResolverContext): Promise&lt;BackstageSignInResult&gt;

Utility function to sign in as a user by email address.

Attempt to match given email with a catalog user's email for sign-in. If that fails, sign in the
user without associating with a catalog user.

| Parameter | Type                | Description                            |
|-----------|---------------------|----------------------------------------|
| `email`   |                     | Email address to attempt sign-in with. |
| `context` | AuthResolverContext |                                        |

##### signInWithName(name: string, context: AuthResolverContext): Promise&lt;BackstageSignInResult&gt;

Utility function to sign in as a user by name.

Attempt to match the name with a catalog user for sign in. If that fails, sign in the user with that
name without associating with a catalog user.

| Parameter | Type                | Description                       |
|-----------|---------------------|-----------------------------------|
| `name`    |                     | Username to attempt sign-in with. |
| `context` | AuthResolverContext |                                   |

## Package @vmware-tanzu/tdp-plugin-custom-logger

### Class LoggerOptionsSurface

Allow for configuration of the Backstage logger.

#### Constructors

##### constructor()

Constructs a new instance of the `LoggerOptionsSurface` class

#### Methods

##### setLoggerOptions(loggerOptions: LoggerOptions): void

Set options for the Backstage logger.

Can be invoked multiple times. Last invocation wins.

| Parameter       | Type          | Description |
|-----------------|---------------|-------------|
| `loggerOptions` | LoggerOptions |             |

## Package @vmware-tanzu/tdp-plugin-home

### Class HomeSurface

Add content to the Backstage Home screen.

#### Constructors

##### constructor()

Constructs a new instance of the `HomeSurface` class

#### Methods

##### addContent(item: ReactElement): void

Add content to the main section below the widget grid.

| Parameter | Type         | Description  |
|-----------|--------------|--------------|
| `item`    | ReactElement | Item to add. |

##### addWidget(item: ReactElement, config?: LayoutConfiguration): void

Add a widget to the Home screen's widget grid.

| Parameter | Type                | Description                                                                                                                                                                                              |
|-----------|---------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `item`    | ReactElement        | Widget to add.                                                                                                                                                                                           |
| `config`  | LayoutConfiguration | (Optional) layout configuration for the widget. The `config.component` field must match the added widget either by name (if provided as string) or by direct reference (if provided as a React element). |

##### addWidgetConfig(config: LayoutConfiguration): void

Specify layout configuration for a widget.

| Parameter | Type                | Description                                                                                                                                                                                              |
|-----------|---------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `config`  | LayoutConfiguration | Optional layout configuration for a widget. The config.component field must match some registered widget either by name (if provided as string) or by direct reference (if provided as a React element). |

## Package @vmware-tanzu/tdp-plugin-ldap-backend

### Class LdapSurface

Allow for manipulation of LDAP groups and users during ingestion.

#### Constructors

##### constructor()

Constructs a new instance of the `LdapSurface` class

#### Methods

##### setGroupTransformerBuilder(builder: GroupTransformerBuilder): void

Specify transformation of LDAP groups during ingestion.

| Parameter | Type                    | Description |
|-----------|-------------------------|-------------|
| `builder` | GroupTransformerBuilder |             |

##### setUserTransformerBuilder(builder: UserTransformerBuilder): void

Specify transformation of LDAP users during ingestion.

| Parameter | Type                   | Description |
|-----------|------------------------|-------------|
| `builder` | UserTransformerBuilder |             |

## Package @vmware-tanzu/tdp-plugin-login

### Class LoginSurface

Register new login providers with Backstage's SignIn page.

[https://backstage.io/docs/auth/\#sign-in-configuration](https://backstage.io/docs/auth/#sign-in-configuration)

#### Methods

##### add(provider: Provider): void

Register a login provider.

| Parameter  | Type     | Description |
|------------|----------|-------------|
| `provider` | Provider |             |

## Package @vmware-tanzu/tdp-plugin-microsoft-graph-org-reader-processor

### Class MicrosoftGraphOrgReaderProcessorTransformersSurface

Allow for manipulation of Microsoft Graph groups and users during ingestion.

#### Methods

##### setGroupTransformer(groupTransformer: GroupTransformer): void

Specify transformation of Microsoft Graph groups during ingestion.

| Parameter          | Type             | Description |
|--------------------|------------------|-------------|
| `groupTransformer` | GroupTransformer |             |

##### setOrganizationTransformer(organizationTransformer: OrganizationTransformer): void

Specify transformation of Microsoft Graph organizations during ingestion.

| Parameter                 | Type                    | Description |
|---------------------------|-------------------------|-------------|
| `organizationTransformer` | OrganizationTransformer |             |

##### setUserTransformer(userTransformer: UserTransformer): void

Specify transformation of Microsoft Graph users during ingestion.

| Parameter         | Type            | Description |
|-------------------|-----------------|-------------|
| `userTransformer` | UserTransformer |             |

## Package @vmware-tanzu/tdp-plugin-permission-backend

### Class CustomPermissionPolicy

#### Methods

##### handle(request: PolicyQuery): Promise&lt;PolicyDecision&gt;

| Parameter | Type        | Description |
|-----------|-------------|-------------|
| `request` | PolicyQuery |             |

### Class PermissionPolicySurface

Define a PermissionPolicy for the Backstage application.

[https://backstage.io/docs/permissions/writing-a-policy](https://backstage.io/docs/permissions/writing-a-policy)

#### Methods

##### set(permissionPolicy: PermissionPolicy): void

Define the PermissionPolicy for the Backstage application.

Can only be invoked a single time.

| Parameter          | Type             | Description |
|--------------------|------------------|-------------|
| `permissionPolicy` | PermissionPolicy |             |
