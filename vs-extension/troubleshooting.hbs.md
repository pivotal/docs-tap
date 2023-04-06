# Troubleshoot Tanzu Developer Tools for Visual Studio

## <a id="extension-log"/> Extension log

The extension creates log entries in a file named `tanzu-dev-tools.log`.
This file is in the directory where Visual Studio Installer installed the extension.

To find the log file, run:

```console
C:> dir $Env:LOCALAPPDATA\Microsoft\VisualStudio\*\Extensions\*\tanzu-dev-tools.log

    Directory: C:\Users\...

Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a---           3/31/2023  1:07 PM           1668 tanzu-dev-tools.log
```
