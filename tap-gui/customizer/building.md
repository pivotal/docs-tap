<h1>Building your Customized Tanzu Developer Portal with the Configurator</h1>

<h2>Prerequisites</h2>

1. Tanzu Developer Portal Configurator requires a running and operating Tanzu Application Platform instance both to build the customized portal, as well as to run the resulting customized image. You can use a `full` profile for everything or you can use a `build` profile for the customization process and a `view` profile for running the customized portal.

2. Your instance of Tanzu Application Platform must have a working supplychain that can build the Tanzu Developer Portal bundle. However, it doesn't need to be able to deliver it as currently we're using an overlay to place the built image on the cluster where the pre-built Tanzu Developer Portal resides.

3. You must have access to an installation registry (where the source Tanzu APplication bundles are located) as well as a build registry (where your built images are staged). If you've got a working Tanzu Application Platform installation and can build a sample application (like Tanzu-Java-Web-App in the Getting Started tutorial), you likely have everything you need.

4. 

<h2> Preparing your Tanzu Developer Portal Configurator configuration file


