#!/bin/bash
./build-docs.sh
export NO_MKDOCS_2_WARNING=1
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
mkdocs serve --livereload
