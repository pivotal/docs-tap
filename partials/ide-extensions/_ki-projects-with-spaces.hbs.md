### Symptom

Workload actions and Live Update do not work. The console displays an error message similar to:

```console
Error: unknown command "projects/my-app" for "apps workload apply". Process finished with exit code 1
```

### Cause

Improper handling of paths that contain spaces causes the shell to misinterpret some
commands, such as `tanzu workload apply ...`. This causes anything executing these commands to fail
when the name of a project, or any parts of its path on disk, contain spaces.

### Solution

1. Close the code editor.
2. Move or rename your project folder on the disk, ensuring that no part of its path contains any
   spaces.
3. Delete the project settings folder from the project to start with a clean slate.
   The folder is `.idea` if using IntelliJ and `.vscode` if using VS Code.
4. Open the code editor and then open the project in its new location.