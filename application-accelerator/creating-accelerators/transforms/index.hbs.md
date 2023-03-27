# Transforms reference

## Available transforms

Here is a list of available transforms and a brief description of their uses. You can use:

- [Combo](combo.md) as a shortcut notation for many common operations. It combines the behaviors of many of the other transforms.
- [Include](include.md) to select files to operate on.
- [Exclude](exclude.md) to select files to operate on.
- [Merge](merge.md) to work on subsets of inputs and to gather the results at the end.
- [Chain](chain.md) to apply several transforms in sequence using function composition.
- [Let](let.md) to introduce new scoped variables to the model.
- [InvokeFragment](invoke-fragment.md) allows re-using various fragments across accelerators.
- [ReplaceText](replace-text.md) to perform simple token replacement in text files.
- [RewritePath](rewrite-path.md) to move files around using regular expression (regex) rules.
- [OpenRewriteRecipe](open-rewrite-recipe.md) to apply [Rewrite](https://docs.openrewrite.org/) recipes, such as package rename.
- [YTT](ytt.md) to run the `ytt` tool on its input files and gather the result.
- [UseEncoding](use-encoding.md) to set the encoding to use when handling files as text.
- [UniquePath](unique-path.md) to decide what to do when several files end up on the same path.
- [Loop](loop.md) to iterate over a list and apply a transform for each element.
- [Provenance](provenance.md) to generate a manifest of the accelerator run.

## See also

- [Conflict Resolution](conflict-resolution.md)
