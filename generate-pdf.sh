#!/usr/bin/env bash
set -euo pipefail

ENGINE="xelatex"
FONT="DejaVu Sans"
MARGIN="1in"

mkdir -p assets/pdf

pandoc CV_Cecile_Morange_FR.md \
  -o assets/pdf/CV_Cecile_Morange_FR.pdf \
  --pdf-engine="$ENGINE" \
  -V geometry:margin="$MARGIN" \
  -V mainfont="$FONT"

pandoc CV_Cecile_Morange_EN.md \
  -o assets/pdf/CV_Cecile_Morange_EN.pdf \
  --pdf-engine="$ENGINE" \
  -V geometry:margin="$MARGIN" \
  -V mainfont="$FONT"

echo "PDF generation done ✔"