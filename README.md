# Research Meeting Presentation

Static HTML slides for a research meeting presentation.

## Files

- `slides.md`: the editable Markdown source.
- `templates/presentation.html`: the Pandoc HTML template.
- `assets/presentation.css`: shared slide styles.
- `index.html`: the generated slide deck for GitHub Pages.

## Build

Edit `slides.md`, then rebuild:

```sh
sh scripts/build.sh
```

The build uses Pandoc. Ordinary slides should be written with Markdown and Pandoc fenced divs. Complex SVG diagrams can stay as raw HTML blocks in `slides.md`.

Useful layout classes:

- `:::: {.section .screen}`: full-height slide.
- `:::: {.section .flow}`: longer scrolling slide.
- `::: kicker`, `::: lead`, `::: note`, `::: {.note .warn}`: common text blocks.
- `::: quote`, `::: case-tags`: separated callout and tag blocks.
- `::: compact-table` and `::: {.compact-table .data-table}`: readable tables.

## GitHub Pages

Publish this repository with GitHub Pages from the `main` branch root.

After creating an empty GitHub repository, add it as `origin` and push:

```sh
git remote add origin git@github.com:<user>/snlp2026kameda.git
git push -u origin main
```
