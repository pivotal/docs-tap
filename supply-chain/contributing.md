# Contributing

Guide for teams contributing docs to the Supply Chain component section.

## Top section

* Beneath the title, start with an `In this section` paragraph such as:

  ```console
  The section introduces...
  The topics in this section explain...
  ```

* Try to use a product name where practical

This helps with SEO.

## Naming

The base product is called `Tanzu Supply Chain`. It's especially important not to
shorten this to `Supply Chain` as it becomes too easily confused with the resource kind.

Resource Kinds should be referred to by their CamelCase name:

* SupplyChain
* Component
* WorkloadRun

## Words and replacements

| Misused | Prefer | why?                                                                                                                                                       |
|---------|--------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Steps   | Stage  | The term is `stages` in a supply chain, so use "stages" when referring to supply chains. Obviously tekton has steps, and that's a good time to use `steps` |
|         |        |                                                                                                                                                            |
|         |        |                                                                                                                                                            |

## Headings and verbs

Each H1 heading in a topic and TOC heading should, where practical start with a verb.
For example,
`Supply Chain Authoring` should be `Author a supply chain`
`How to create Workload` should be `Create a workload`

## Diagrams

* [Miro Board](https://miro.com/app/board/uXjVNvc1o0E=/)

## Tanzu Supply Chain Doc Automation Description

Why: There is a history of the old supply chain docs being wrong because sections haven't been updated, and information is spread across different places. The source of truth is in too many places. 
Solution: One source of truth. Doc automation that takes descriptions directly from components, generates md, and raises a doc PR.

What topic in the doc contains the automated doc: [Catalog of Tanzu Supply Chain Components](https://docs-staging.vmware.com/en/draft/VMware-Tanzu-Application-Platform/1.8/tap/supply-chain-reference-catalog-about.html)
What does this page describe: Provides descriptions for components provided by the authoring profile
Other pages: [Output Types](https://docs-staging.vmware.com/en/draft/VMware-Tanzu-Application-Platform/1.8/tap/supply-chain-reference-catalog-output-types.html), while the content of this page is manually created, the Catalog of Tanzu
Supply Chain Components page links to this page.

### Platform Engineer User Experience

- PE installs the authoring profile when they want to author supply chains. This provides components that PE can use when authoring supply chains.
- PE uses the CLI to see a catalog of installed components. `tanzu supply-chain component list`
- PE uses the CLI to see detail of the component, including documentation. `tanzu supply-chain <component>  get or describe`
- While PE is authoring supply chains, they can see details about each component.
In the CLI there will be links to the vmware.doc docs page that has the component descriptions.

### Component Description

Each component has the following fields that provide descriptions of the component.

Component Fields:

- **Name**
- **Version**
- **Description** -  (multiline string) (potentially could make this a multiline string that has markdown). Some of the descriptions can be long and might require some templated headings underneath to accommodate the full scope.
- **Inputs** - List of objects, usually just 1
- **Outputs** - List of objects, usually just 1
- **Config**: A yaml sample that shows what inputs this component accepts in terms of configuration from the workload. The yaml has inline documentation and this is based on OpenAPI Spec V3 -  a swagger doc format. What inputs this component accepts in terms of configuration from the workload.

### Automation Description

Custom binary tool created by Rasheed reads the component field descriptions and generates md, the md is then manually added to a markdown file and a doc PR is raised.

Aim is to have as little ‘clean up as possible’ required for the auto generated md.
Future plan is that this markdown will appear at the bottom of the component.

Future plan: When a component is updated, the ‘doc automation tool’ reads the component, generates the md, automatically generates a doc PR.  But at the moment the steps to copy the md and raise the PR are manual.
