### Symptom

Tiltfile snippet does not work on files named `Tiltfile` when Tilt extension is installed.

### Cause

When the Tilt extension is installed, Tiltfiles named `Tiltfile` are not compatible with our code snippets.

### Solution

To use Tiltfile snippets with the Tilt extension installed, create an empty file with a name other than `Tiltfile`, use the Tiltfile snippet, then rename the file to `Tiltfile`. Without the Tilt extension installed, Tiltfile snippets work as expected. 