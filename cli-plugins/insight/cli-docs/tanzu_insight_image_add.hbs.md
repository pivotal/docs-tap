## tanzu insight image add

Add an image report

## <a id='synopsis'></a>Synopsis

Add an image to the metadata store with the image's SBOM or vulnerability scan. By default command will show Standard output and errors together. Output and errors can be redirected to files by using 1>out.txt 2>error.txt

```console
tanzu insight image add --path <filepath> [flags]
```

## <a id='examples'></a>Examples

```console
insight image add --input-format cyclonedx-xml --output-format text --path /path/to/file.xml
  insight image add --input-format spdx-json --output-format api-json --path /path/to/file.json
  insight image add --path /path/to/file.xml
  insight image add --path /path/to/file.xml --artifact-group-uid workload-uid --artifact-group-label name=example --artifact-group-label namespace=example-ns
  insight image add --path /path/to/file.xml --artifact-group-uid workload-uid --artifact-group-label name=example,namespace=example-ns
  insight image add --input-format spdx-json --output-format api-json --path /path/to/file.json 1>out.txt 2>error.txt (* Output will be redirected to out.txt and error will be redirected to error.txt .)
```

## <a id='options'></a>Options

```console
      --artifact-group-label strings   specify artifact group labels, must be in key=value format. This flag can be set multiple times to provide multiple labels in one call, or can be passed a list of labels separated by commas. Note: This flag can only be specified if artifact-group-uid flag is set.
      --artifact-group-uid string      uid of artifact group to add to, or create if it doesn't already exist
  -h, --help                           help for add
  -i, --input-format string            specify the file’s SBOM report format and file type, options=[cyclonedx-xml, cyclonedx-json, spdx-json] (default: cyclonedx-xml)
      --output-format string           specify the response's SBOM report format and file type format, options=[text, api-json] (default: text)
  -p, --path string                    path to file, required
```

## <a id='see-also'></a>See also

* [tanzu insight image](tanzu_insight_image.hbs.md)	 - Image commands

