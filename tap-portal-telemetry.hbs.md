# How do I join or leave the Customer Experience Improvement Programs for Tanzu Application Platform 

Tanzu Application Platform participates in VMware's original Customer Experience Improvement Program (CEIP) and also the Pendo Customer Experience Program (Pendo CEIP) for supported services.

You can separately join or leave the VMware original Customer Experience Improvement Program (CEIP) and the Pendo Customer Experience Program (Pendo CEIP). Each program collects somewhat different types of customer interaction data, as described below.

* Pendo CEIP

    Pendo is an integrated third-party tool that collects user activities and provides analytics to Tanzu Application Platform product development. The Pendo CEIP collects workflow data based on your interaction with the user interface. This information helps VMware designers and engineers develop data-driven improvements to the usability of products and services.

## Join or leave the Pendo CEIP

You can join or leave the Pendo Customer Experience Improvement Program (Pendo CEIP) by using the following procedures.

### Enable or disable the Pendo CEIP for the organization

To enable the program for the organization, add the following parameters to your tap-values.yaml file:

```yaml
tap_gui:  
  app_config:    
    pendoAnalytics:      
      enabled: true 
```
>**Note** After enabling the program for the organization, each individual user shall be prompted to opt-in the Pendo CEIP according to VMware's policy.

To disable the program for the entire organization, add the following parameters to your tap-values.yaml file:

```yaml
tap_gui:  
  app_config:    
    pendoAnalytics:      
      enabled: false
```

### Opt-in or opt-out of the Pendo CEIP from the Tanzu Application Platform GUI

Once the Pendo CEIP is enabled for the organization, each user shall be prompted to Accept or Decline participation in the program.

  ![Screenshot of a Tanzu Application Platform GUI telemetry prompt.](tap-gui/images/tap-gui-telemetry-prompt.png)

Each individual's preference shall be stored in Tanzu Application Platform GUI and can be modified at any time. To change your preferences, go to `SETTINGS` and press on the `Preferences` tab.

  ![Screenshot of a Tanzu Application Platform GUI Settings Preferences.](tap-gui/images/tap-gui-telemetry-preferences.png)


### Request to delete your anonymized data

If you no longer want to participate in the program and require VMware to delete all your anonymized data, please send an email to tap-pendo@vmware.com with your Hashed User ID that would enable VMware to identify your anonymized data and proceed with its deletion according to the applicable regulations.

To find your hashed User ID, go to the `SETTINGS` and press on the `Preferences` tab.

Your privacy is the top priority for VMware.
