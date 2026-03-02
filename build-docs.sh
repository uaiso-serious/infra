#!/bin/bash
mkdir -p ./docs/apps

yq -i '(.nav[] | select(has("Apps")).Apps) = []' mkdocs.yml

find ./apps -mindepth 1 -maxdepth 1 -type d | sort | while read appdir; do
  if [ -d "$appdir" ]; then
    APPNAME=$(basename "$appdir")
    SRC="$appdir/README.md"
    DEST="./docs/apps/${APPNAME}.md"
    if [ -f "$SRC" ]; then
      cp "$SRC" "$DEST"
      echo "apps/${APPNAME}.md"
      APP_TMP=("apps/${APPNAME}.md")
      yq -i '(.nav[] | select(has("Apps")) | .Apps) += ["'"$APP_TMP"'"]' mkdocs.yml
    fi
  fi
done

yq -i '(.nav[] | select(has("Examples")).Examples) = []' mkdocs.yml

find ./examples -mindepth 1 -maxdepth 1 -type d | sort | while read exampledir; do
  if [ -d "$exampledir" ]; then
    EXAMPLENAME=$(basename "$exampledir")
    SRC="$exampledir/README.md"
    DEST="./docs/examples/${EXAMPLENAME}.md"
    if [ -f "$SRC" ]; then
      cp "$SRC" "$DEST"
      echo "examples/${EXAMPLENAME}.md"
      EXAMPLE_TMP=("examples/${EXAMPLENAME}.md")
      yq -i '(.nav[] | select(has("Examples")) | .Examples) += ["'"$EXAMPLE_TMP"'"]' mkdocs.yml
    fi
  fi
done
