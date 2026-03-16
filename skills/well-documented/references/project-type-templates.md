# Project-Type Templates

Use a closer template whenever the repository shape is already obvious. The bundled root README templates are available through `init-docs --project-type <type>`.

## Supported project types

| Type | Template | Best for |
| --- | --- | --- |
| `generic` | `assets/templates/README.md.tmpl` | unknown or mixed projects |
| `library` | `assets/templates/README.library.md.tmpl` | reusable packages and SDKs |
| `cli` | `assets/templates/README.cli.md.tmpl` | command-line tools |
| `service` | `assets/templates/README.service.md.tmpl` | APIs, daemons, and back-end services |
| `web-app` | `assets/templates/README.web-app.md.tmpl` | front-end or full-stack web applications |
| `monorepo-package` | `assets/templates/README.monorepo-package.md.tmpl` | one package inside a multi-package repository |
| `data-pipeline` | `assets/templates/README.data-pipeline.md.tmpl` | ETL, analytics, and scheduled processing jobs |

## Selection tips

Choose the template that matches the repository's primary operating surface, not every secondary concern.

Examples:

- a reusable npm package with a small demo app is still a `library`
- a REST API with a tiny admin page is still a `service`
- one package inside `packages/` of a monorepo is a `monorepo-package`
- a batch workflow with ingestion, transform, and publish stages is a `data-pipeline`

## What these templates improve

Compared with the generic template, the project-type templates:

- front-load the sections that readers of that project type actually need
- give better example headings and example commands
- reduce filler sections that do not fit the repository
- produce a stronger first draft before manual refinement

## Directory-level docs

Folder-level `README.md` files still use the directory template. The project-type distinction matters most at the repository root, where expectations differ the most.
