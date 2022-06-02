# OpenRewriteRecipe transform

The `OpenRewriteRecipe` transform allows you to apply any [Open Rewrite](https://docs.openrewrite.org/)
**Recipe** to a set of files and gather the results.

>**Note:** Currently, only [Java related recipes](https://docs.openrewrite.org/reference/recipes/java)
are supported. The engine leverages version `7.21.3` of Open Rewrite and parses
Java files using the grammar for Java 11.

## <a id="syntax-ref"></a>Syntax reference

```
type: OpenRewriteRecipe
recipe: <string>                  # Full qualified classname of the recipe
options:
  <string>: <SpEL expression>      # Keys and values depend on the class of the recipe
  <string>: <SpEL expression>      # Refer to the documentation of said recipe
  ...
```

## <a id="example"></a>Example

The following example applies the [ChangePackage](https://docs.openrewrite.org/reference/recipes/java/changepackage)
Recipe to a set of Java files in the `com.acme` package and moves them to the value
of `#companyPkg`. This is more powerful than using [RewritePath](rewrite-path.md)
and [ReplaceText](replace-text.md), as it reads the syntax of files and
correctly deals with imports, fully vs. non-fully qualified names, and so on.

```
chain:
  - include: ["**/*.java"]
  - type: OpenRewriteRecipe
    recipe: org.openrewrite.java.ChangePackage
    options:
      oldPackageName: "'com.acme'"
      newPackageName: "#companyPkg"
```
