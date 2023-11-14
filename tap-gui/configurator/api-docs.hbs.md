# API documentation for surfaces

This topic tells you about API references for surfaces in Tanzu Developer Portal.

The following packages are described:

- [@tpb/plugin-catalog](#tpb-plugin-catalog)
- [@vmware-tanzu/core-backend](#tanzu-core-backend)
- [@vmware-tanzu/core-frontend](#tanzu-core-frontend)
- [@@vmware-tanzu/tdp-plugin-auth-backend](#tanzu-tdp-plgn-auth-bcknd)
- [@vmware-tanzu/tdp-plugin-custom-logger](#tanzu-tdp-plgn-cstm-lggr)
- [@vmware-tanzu/tdp-plugin-home](#tanzu-tdp-plugin-home)
- [@vmware-tanzu/tdp-plugin-ldap-backend](#tanzu-tdp-plgn-ldap-bcknd)
- [@vmware-tanzu/tdp-plugin-login](#tanzu-tdp-plugin-login)
- [@vmware-tanzu/tdp-plugin-microsoft-graph-org-reader-processor](#mcrsft-grph-org-rdr-prcss)
- [@vmware-tanzu/tdp-plugin-permission-backend](#tdp-plugin-prmssn-bcknd)

## <a id='tpb-plugin-catalog'></a> Package @tpb/plugin-catalog

The following sections describe the package.

### Class EntityPageSurface

This class can manipulate the contents of pages for Backstage catalog entities.

Each catalog entity subtype can specify a dedicated template. This surface standardizes the contents
of those templates and allows for some amount of external configuration.

This example adds a tab to the template for Backstage Service entities:

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

This table describes the properties.

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

The package has the following constructor.

##### constructor()

This constructor constructs a new instance of the `EntityPageSurface` class.

#### Methods

The package has the following methods.

##### addComponentPageCase(pageCase: ReactElement): void

This table describes the parameters.

| Parameter  | Type         | Description |
|------------|--------------|-------------|
| `pageCase` | ReactElement |             |

##### addOverviewContent(content: ReactElement): void

This table describes the parameters.

| Parameter | Type         | Description |
|-----------|--------------|-------------|
| `content` | ReactElement |             |

## <a id='tanzu-core-backend'></a> Package @vmware-tanzu/core-backend

The following sections describe the package.

### Types

The package has the following types.

<a name="vmware-tanzu-core-backend-backend-plugin-interface-type" />`BackendPluginInterface<T = {}> = (config?: T & BackendPluginConfig) => TpbPluginInterface;`

<a name="vmware-tanzu-core-backend-catalog-processor-builder-type" />`CatalogProcessorBuilder = (env: PluginEnvironment) => CatalogProcessor[] | CatalogProcessor;`

<a name="vmware-tanzu-core-backend-entity-provider-builder-type" />`EntityProviderBuilder = (env: PluginEnvironment) => EntityProvider[] | EntityProvider;`

<a name="vmware-tanzu-core-backend-permission-rule-builder-type" />`PermissionRuleBuilder = (env: PluginEnvironment) => CatalogPermissionRule[] | CatalogPermissionRule;`

<a name="vmware-tanzu-core-backend-plugin-fn-type" />`PluginFn = (env: PluginEnvironment) => Promise<Router>;`

<a name="vmware-tanzu-core-backend-router-builder-type" />`RouterBuilder = (env: PluginEnvironment) => Promise<Router>;`

### Class BackendCatalogSurface

This class can manipulate the catalog backend.

This class provides extension points for registering catalog processors, entity providers, routes,
and permissions.

#### Constructors

The package has the following constructor.

##### constructor()

This constructor constructs a new instance of the `BackendCatalogSurface` class.

#### Methods

The package has the following methods.

##### addCatalogProcessorBuilder(builder: CatalogProcessorBuilder): void

This method registers a Backstage CatalogProcessor that applies transformations to unprocessed
entities.

For more information about processors, see the
[Backstage documentation](https://backstage.io/docs/features/software-catalog/configuration#processors).

For more information about processing, see the
[Backstage documentation](https://backstage.io/docs/features/software-catalog/life-of-an-entity#processing).

| Parameter | Type                                                                                 | Description                                              |
|-----------|--------------------------------------------------------------------------------------|----------------------------------------------------------|
| `builder` | [CatalogProcessorBuilder](#vmware-tanzu-core-backend-catalog-processor-builder-type) | Builds a CatalogProcessor for a given PluginEnvironment. |

##### addEntityProviderBuilder(builder: EntityProviderBuilder): void

This method registers a Backstage EntityProvider to ingest generate catalog entries for further
processing.

For more information about ingestion, see the
[Backstage documentation](https://backstage.io/docs/features/software-catalog/life-of-an-entity#ingestion).

| Parameter | Type                                                                             | Description                                             |
|-----------|----------------------------------------------------------------------------------|---------------------------------------------------------|
| `builder` | [EntityProviderBuilder](#vmware-tanzu-core-backend-entity-provider-builder-type) | Builds an EntityProvider for a given PluginEnvironment. |

##### addPermissionRuleBuilder(builder: PermissionRuleBuilder): void

This method registers Backstage CatalogPermissionRules to limit access to catalog entries.

For more information about custom permission rules, see the
[Backstage documentation](https://backstage.io/docs/permissions/custom-rules).

| Parameter | Type                                                                             | Description                                                  |
|-----------|----------------------------------------------------------------------------------|--------------------------------------------------------------|
| `builder` | [PermissionRuleBuilder](#vmware-tanzu-core-backend-permission-rule-builder-type) | Builds CatalogPermissionRules for a given PluginEnvironment. |

##### addRouterBuilder(routerBuilder: RouterBuilder): void

This method registers an Express Router to handle arbitrary requests made to the Backstage backend.

| Parameter       | Type                                                            | Description                                             |
|-----------------|-----------------------------------------------------------------|---------------------------------------------------------|
| `routerBuilder` | [RouterBuilder](#vmware-tanzu-core-backend-router-builder-type) | Builds an Express Router for a given PluginEnvironment. |

### Class BackendPluginSurface

You can use this class to add plug-ins to the Backstage backend.

#### Constructors

The package has the following constructor.

##### constructor()

This constructor constructs a new instance of the `BackendPluginSurface` class.

#### Methods

The package has the following methods.

##### addPlugin(plugin: Plugin): void

This method registers a named plug-in to handle backend requests at a subpath.
Plug-ins must have unique names. The first plug-in registered with a given name wins.

| Parameter | Type                                                    | Description    |
|-----------|---------------------------------------------------------|----------------|
| `plugin`  | [Plugin](#vmware-tanzu-core-backend-plugin-2-interface) | Plug-in to add |

## <a id='tanzu-core-frontend'></a> Package @vmware-tanzu/core-frontend

The following sections describe the package.

### Types

The package has the following type.

<a name="vmware-tanzu-core-frontend-app-plugin-interface-type" />`AppPluginInterface<T = {}> = (config?: T) => TpbPluginInterface;`

### Class ApiSurface

You can use this class to add Backstage ApiFactories.

#### Methods

The package has the following methods.

##### add(factory: AnyApiFactory): void

This method registers a new Backstage ApiFactory.
Factories must specify an API with a unique ID. The last factory registered with a given ID wins.
Factories that specify APIs with IDs on the ignored list will not be registered.

| Parameter | Type          | Description |
|-----------|---------------|-------------|
| `factory` | AnyApiFactory |             |

### Class AppComponentSurface

You can use this class to replace core components of the Backstage app.

#### Constructors

The package has the following constructor.

##### constructor()

This constructor constructs a new instance of the `AppComponentSurface` class.

#### Methods

The package has the following methods.

##### add&lt;K extends keyof AppComponents&gt;(key: K, component: AppComponents\[K\]): void

This method replaces a given Backstage AppComponent with another.
AppComponents must be unique by key. The last AppComponent registered with a given key wins.

| Parameter   | Type          | Description                                                |
|-------------|---------------|------------------------------------------------------------|
| `key`       |               | Unique key for the AppComponent.                           |
| `component` | AppComponents | Custom AppComponent to substitute for Backstage's default. |

### Class AppPluginSurface

You can use this class to register additional frontend plug-ins with the Backstage app.

[https://backstage.io/docs/plugins/](https://backstage.io/docs/plugins/)

#### Constructors

The package has the following constructor.

##### constructor()

This constructor constructs a new instance of the `AppPluginSurface` class.

#### Methods

The package has the following methods.

##### add(plugin: BackstagePlugin): void

This method registers a frontend BackstagePlugin.

| Parameter | Type            | Description |
|-----------|-----------------|-------------|
| `plugin`  | BackstagePlugin |             |

### Class AppRouteSurface

Manipulate routes in the frontend Backstage app.

[https://backstage.io/docs/plugins/composability/\#routing-system](https://backstage.io/docs/plugins/composability/#routing-system)

#### Constructors

The package has the following constructor.

##### constructor()

Constructs a new instance of the `AppRouteSurface` class

#### Methods

The package has the following methods.

##### add(route: ReactElement): void

This method registers a react-router route.

| Parameter | Type         | Description                                                                  |
|-----------|--------------|------------------------------------------------------------------------------|
| `route`   | ReactElement | Route to register. Intended to be a react-router\#Route or a subclass of it. |

##### addRouteBinder(routeBinder: RouteBinder): void

This method binds external routes. For more information about binding external routes to apps, see the
[Backstage documentation](https://backstage.io/docs/plugins/composability/#binding-external-routes-in-the-app).

| Parameter     | Type        | Description |
|---------------|-------------|-------------|
| `routeBinder` | RouteBinder |             |

### Class BannerSurface

You can use this class to add page-level banners to the Backstage app.

#### Constructors

The package has the following constructor.

##### constructor()

This constructor constructs a new instance of the `BannerSurface` class.

#### Methods

The package has the following methods.

##### add(banner: ReactElement): void

This method adds a new page-level banner.

| Parameter | Type         | Description |
|-----------|--------------|-------------|
| `banner`  | ReactElement |             |

### Class SettingsTabsSurface

You can use this class to add tabs to the Settings page.

#### Constructors

The package has the following constructor.

##### constructor()

This constructor constructs a new instance of the `SettingsTabsSurface` class.

#### Methods

The package has the following methods.

##### add(tab: ReactElement): void

This method adds a new tab to the **Settings** page.

| Parameter | Type         | Description                                                                                             |
|-----------|--------------|---------------------------------------------------------------------------------------------------------|
| `tab`     | ReactElement | Typically an instance of @<!-- -->backstage/<!-- -->@<!-- -->plugin-user-settings\#SettingsLayout.Route |

### Class SidebarItemSurface

You can use this class to manipulate entries in sidebar.

Entries are split into two sections: top items appear above a divider and main items appear below
it. Tabs within each section appear in order of registration.

#### Constructors

The package has the following constructor.

##### constructor()

This constructor constructs a new instance of the `SidebarItemSurface` class.

#### Methods

The package has the following methods.

##### addMainItem(item: ReactElement): void

This method adds an item to the main items section.

| Parameter | Type         | Description |
|-----------|--------------|-------------|
| `item`    | ReactElement |             |

##### addTopItem(item: ReactElement): void

This method adds an item to the top items section.

| Parameter | Type         | Description |
|-----------|--------------|-------------|
| `item`    | ReactElement |             |

### Class ThemeSurface

You can use this class to manipulate themes available to the Backstage application.

#### Constructors

The package has the following constructor.

##### constructor()

This constructor constructs a new instance of the `ThemeSurface` class.

#### Methods

The package has the following methods.

##### addTheme(theme: AppTheme): void

This method registers an additional theme.

| Parameter | Type     | Description |
|-----------|----------|-------------|
| `theme`   | AppTheme |             |

##### setRootBuilder(builder: (children: JSX.Element) =&gt; ReactElement): void

This method registers the factory that renders the application's root element.

| Parameter | Type                    | Description |
|-----------|-------------------------|-------------|
| `builder` | JSX.ElementReactElement |             |

## <a id='tanzu-tdp-plgn-auth-bcknd'></a> Package @vmware-tanzu/tdp-plugin-auth-backend

The following sections describe the package.

### Class SignInProviderSurface

You can use this class to register additional Auth Providers.

[https://backstage.io/docs/auth/add-auth-provider](https://backstage.io/docs/auth/add-auth-provider)

#### Methods

The package has the following methods.

##### add(signInProvider: SignInProvider): void

This method registers an additional Auth Provider. The Auth Provider named last wins.

| Parameter        | Type           | Description                                                                   |
|------------------|----------------|-------------------------------------------------------------------------------|
| `signInProvider` | SignInProvider | Map of @<!-- -->backstage/plugin-auth-backend\#AuthProviderFactory instances. |

### Class SignInResolverSurface

You can use this class to register SignInResolvers and provide utility methods to log in with them.

#### Methods

The package has the following methods.

##### add(authProviderKey: string, resolver: SignInResolver&lt;any&gt;): void

This method registers a new SignInResolver.

| Parameter         | Type           | Description                                                                                                        |
|-------------------|----------------|--------------------------------------------------------------------------------------------------------------------|
| `authProviderKey` |                | Name resolver to add. Uniqueness of name is not enforced but the behavior of duplicate named entries is undefined. |
| `resolver`        | SignInResolver | Resolver to add.                                                                                                   |

##### getResolver&lt;TAuthResult&gt;(authProviderKey: string): SignInResolver&lt;TAuthResult&gt;

This method gets the first named provider, or falls back to the guest resolver.

| Parameter         | Type | Description |
|-------------------|------|-------------|
| `authProviderKey` |      |             |

##### signInAsGuestResolver&lt;TAuthResult&gt;(): SignInResolver&lt;TAuthResult&gt;

This method gets a resolver that creates an ad-hoc guest user.

##### signInWithEmail(email: string, context: AuthResolverContext): Promise&lt;BackstageSignInResult&gt;

This method provides a utility function to sign in as a user by email address.

The method attempts to match the given email address with a catalog user's email address for
sign-in. If that fails, the method signs the user in without associating with a catalog user.

| Parameter | Type                | Description                            |
|-----------|---------------------|----------------------------------------|
| `email`   |                     | Email address to attempt sign-in with. |
| `context` | AuthResolverContext |                                        |

##### signInWithName(name: string, context: AuthResolverContext): Promise&lt;BackstageSignInResult&gt;

This method provides a utility function to sign in as a user by name.

The method attempts to match the name with a catalog user for signing in. If that fails, the method
signs the user in with that name without associating with a catalog user.

| Parameter | Type                | Description                       |
|-----------|---------------------|-----------------------------------|
| `name`    |                     | Username to attempt sign-in with. |
| `context` | AuthResolverContext |                                   |

## <a id='tanzu-tdp-plgn-cstm-lggr'></a> Package @vmware-tanzu/tdp-plugin-custom-logger

The following sections describe the package.

### Class LoggerOptionsSurface

You can use this class to allow for configuration of the Backstage logger.

#### Constructors

The package has the following constructor.

##### constructor()

This constructor constructs a new instance of the `LoggerOptionsSurface` class.

#### Methods

The package has the following methods.

##### setLoggerOptions(loggerOptions: LoggerOptions): void

This method sets options for the Backstage logger. This method can be invoked multiple times. The
last invocation wins.

| Parameter       | Type          | Description |
|-----------------|---------------|-------------|
| `loggerOptions` | LoggerOptions |             |

## <a id='tanzu-tdp-plugin-home'></a> Package @vmware-tanzu/tdp-plugin-home

The following sections describe the package.

### Class HomeSurface

You can use this class to add content to the Backstage Home screen.

#### Constructors

The package has the following constructor.

##### constructor()

This constructor constructs a new instance of the `HomeSurface` class.

#### Methods

The package has the following methods.

##### addContent(item: ReactElement): void

This method adds content to the main section below the widget grid.

| Parameter | Type         | Description  |
|-----------|--------------|--------------|
| `item`    | ReactElement | Item to add. |

##### addWidget(item: ReactElement, config?: LayoutConfiguration): void

This method adds a widget to the Home screen's widget grid.

| Parameter | Type                | Description                                                                                                                                                                                              |
|-----------|---------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `item`    | ReactElement        | Widget to add.                                                                                                                                                                                           |
| `config`  | LayoutConfiguration | (Optional) layout configuration for the widget. The `config.component` field must match the added widget either by name (if provided as string) or by direct reference (if provided as a React element). |

##### addWidgetConfig(config: LayoutConfiguration): void

This method specifies the layout configuration for a widget.

| Parameter | Type                | Description                                                                                                                                                                                              |
|-----------|---------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `config`  | LayoutConfiguration | Optional layout configuration for a widget. The config.component field must match some registered widget either by name (if provided as string) or by direct reference (if provided as a React element). |

## <a id='tanzu-tdp-plgn-ldap-bcknd'></a> Package @vmware-tanzu/tdp-plugin-ldap-backend

The following sections describe the package.

### Class LdapSurface

You can use this class to allow for manipulation of LDAP groups and users during ingestion.

#### Constructors

The package has the following constructor.

##### constructor()

This constructor constructs a new instance of the `LdapSurface` class.

#### Methods

The package has the following methods.

##### setGroupTransformerBuilder(builder: GroupTransformerBuilder): void

This method specifies the transformation of LDAP groups during ingestion.

| Parameter | Type                    | Description |
|-----------|-------------------------|-------------|
| `builder` | GroupTransformerBuilder |             |

##### setUserTransformerBuilder(builder: UserTransformerBuilder): void

This method specifies the transformation of LDAP users during ingestion.

| Parameter | Type                   | Description |
|-----------|------------------------|-------------|
| `builder` | UserTransformerBuilder |             |

## <a id='tanzu-tdp-plugin-login'></a> Package @vmware-tanzu/tdp-plugin-login

The following sections describe the package.

### Class LoginSurface

You can use this class to register new login providers with Backstage's SignIn page.

For more information about sign-in configuration, see the
[Backstage documentation](https://backstage.io/docs/auth/#sign-in-configuration).

#### Methods

The package has the following methods.

##### add(provider: Provider): void

This method registers a login provider.

| Parameter  | Type     | Description |
|------------|----------|-------------|
| `provider` | Provider |             |

## <a id='mcrsft-grph-org-rdr-prcss'></a> Package @vmware-tanzu/tdp-plugin-microsoft-graph-org-reader-processor

The following sections describe the package.

### Class MicrosoftGraphOrgReaderProcessorTransformersSurface

You can use this class to allow for manipulation of Microsoft Graph groups and users during ingestion.

#### Methods

The package has the following methods.

##### setGroupTransformer(groupTransformer: GroupTransformer): void

This method specifies the transformation of Microsoft Graph groups during ingestion.

| Parameter          | Type             | Description |
|--------------------|------------------|-------------|
| `groupTransformer` | GroupTransformer |             |

##### setOrganizationTransformer(organizationTransformer: OrganizationTransformer): void

This method specifies the transformation of Microsoft Graph organizations during ingestion.

| Parameter                 | Type                    | Description |
|---------------------------|-------------------------|-------------|
| `organizationTransformer` | OrganizationTransformer |             |

##### setUserTransformer(userTransformer: UserTransformer): void

This method specifies the transformation of Microsoft Graph users during ingestion.

| Parameter         | Type            | Description |
|-------------------|-----------------|-------------|
| `userTransformer` | UserTransformer |             |

## <a id='tdp-plugin-prmssn-bcknd'></a> Package @vmware-tanzu/tdp-plugin-permission-backend

The following sections describe the package.

### Class CustomPermissionPolicy

<!-- Description missing -->

#### Methods

The package has the following methods.

##### handle(request: PolicyQuery): Promise&lt;PolicyDecision&gt;

| Parameter | Type        | Description |
|-----------|-------------|-------------|
| `request` | PolicyQuery |             |

### Class PermissionPolicySurface

You can use this class to define a PermissionPolicy for the Backstage application.

[https://backstage.io/docs/permissions/writing-a-policy](https://backstage.io/docs/permissions/writing-a-policy)

#### Methods

The package has the following methods.

##### set(permissionPolicy: PermissionPolicy): void

This method defines the PermissionPolicy for the Backstage application.
This method can be invoked only once.

| Parameter          | Type             | Description |
|--------------------|------------------|-------------|
| `permissionPolicy` | PermissionPolicy |             |
