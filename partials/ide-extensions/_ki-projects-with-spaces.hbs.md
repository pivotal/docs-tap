### Symptom

Workload actions and live update do not work. The console displays an error message similar to the following:

```console
Error: unknown command "projects/my-app" for "apps workload apply". Process finished with exit code 1
```

### Cause

Improper handling of paths that contain spaces in them causes commands such as `tanzu workload apply ...`
to be interpreted incorrectly by the shell. This causes anything executing those commands to fail
when either the name of a project or any parts of its path on disk contains spaces.

### Solution

1. Close the code editor.
2. Move or rename your project folder on the disk, ensuring that no part of its path contains any
   spaces.
3. Delete the project settings folder from the project to start with a clean slate.
   The folder is `.idea` if using IntelliJ and `.vscode` if using VS Code.
4. Open the code editor and then open the project in its new location.