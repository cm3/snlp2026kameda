#!/bin/sh
set -eu

cd "$(dirname "$0")/.."

pandoc slides.md \
  -f markdown+raw_html+native_divs+native_spans \
  -t html5 \
  --standalone \
  --section-divs \
  --strip-comments \
  --wrap=none \
  --template templates/presentation.html \
  -o index.html
