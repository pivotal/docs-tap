# Troubleshoot Tanzu Developer Tools for Visual Studio

## <a id="extension-log"/>Extension log

The extension logs to a file named `tanzu-dev-tools.log` within the directory where the extension was installed by Visual Studio Installer.

To find the log file; run:
```console
C:> dir $Env:LOCALAPPDATA\Microsoft\VisualStudio\*\Extensions\*\tanzu-dev-tools.log

    Directory: C:\Users\...

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           3/31/2023  1:07 PM           1668 tanzu-dev-tools.log
```
