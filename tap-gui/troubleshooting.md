# Troubleshooting Tanzu Application Platform GUI

This topic describes troubleshooting information for problems with installing Tanzu Application Platform GUI.

## <a id='catalog-not-found'></a> Catalog Not Found



### Symptom

When you pull up the Tanzu Application Platform UI and get the error `Catalog Not Found`
 
### Cause

This issue is caused because the catalog plugin can't read the Git location of your catalog definition files. 

### Solution

There are a number of potential causes:

1. Make sure you've either built your own [Backstage Compatible](http://backstage.io) catalog, or that you've downloaded one of the Tanzu Application Platform GUI catalogs from the Tanzu Network (the same place you download Tanzu Application Platform itself from). Make sure that you define the catalog in the values file that you input as part of installation. If you need to update this location, you can change the definition file (Either the TAP profile one if you used the profile method to install or the standalone TAP GUI values file if you're only installing that package on it's own)

```yaml
    namespace: tap-gui
    service_type: <SERVICE-TYPE>
    app-config:
      catalog:
        locations:
          - type: url
            target: https://<GIT-CATALOG-URL>/catalog-info.yaml
```

2. You need to make sure that you provide the proper integration information for the Git location you specified above.

```yaml
    namespace: tap-gui
    service_type: <SERVICE-TYPE>
    app-config:
      app:
        baseUrl: https://<EXTERNAL-IP>:<PORT>
      integrations: 
        gitlab: # Other integrations available
          - host: <GITLAB-HOST>
            apiBaseUrl: https://<GITLAB-URL>/api/v4
            token: <GITLAB-TOKEN>
```
Other integrations can be substituted here as defined in the [Backstage documentation](https://backstage.io/docs/integrations/)
