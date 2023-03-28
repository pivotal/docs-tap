### Symptom

Workload actions do not work. The console displays an error message similar to the following:

```console
Error: unknown command "projects/my-app" for "apps workload apply"Process finished with exit code 1
```

### Cause

On Windows, workload actions do not work when in a project with spaces in the name, such as
`my-app project`.

### Solution

1. Close the code editor.
1. Move the project files to a new location on the disk.
1. Delete the project settings folder from the project to start with a clean slate.
   The folder is `.idea` if using IntelliJ and `.vscode` if using VS Code.
1. Open the code editor and then open the project in its new location.