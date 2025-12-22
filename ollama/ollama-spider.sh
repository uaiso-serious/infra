#!/bin/bash

mkdir -p models

curl "https://ollama.com/search?o=newest" > models/001_search.html
grep "href=\"/library/" models/001_search.html | grep -oP 'href="\K[^"]+' > models/002_search_links.html

while read -r link; do
  curl "https://ollama.com${link}/tags" > models/$(basename "${link}")-tags.html
done < models/002_search_links.html

echo "model,name,size,context" > models/tmp.csv

for file in models/*-tags.html; do
  xmllint --html --xpath "//div[contains(@class,'group')]/div[@class='hidden md:flex flex-col space-y-[6px]']/div[@class='grid grid-cols-12 items-center']" "$file" 2>/dev/null \
  | xmllint --html --xpath "//a/text() | //p[@class='col-span-2 text-neutral-500 text-[13px]']/text()" - 2>/dev/null \
  | awk 'ORS=NR%3?",":"\n"' \
  | awk -v fname="$(basename "$file" -tags.html)" '{print fname","$1","$2","$3}' >> models/tmp.csv
done

awk -F, '{
  size=$3;
  if(size ~ /TB/) val=substr(size,1,length(size)-2)*1024*1024*1024*1024;
  else if(size ~ /GB/) val=substr(size,1,length(size)-2)*1024*1024*1024;
  else if(size ~ /MB/) val=substr(size,1,length(size)-2)*1024*1024;
  else val=size;
  $3=val;

  ctx=$4;
  else if(ctx ~ /M/) ctxval=substr(ctx,1,length(ctx)-1)*1000*1000;
  else if(ctx ~ /K/) ctxval=substr(ctx,1,length(ctx)-1)*1000;
  else ctxval=ctx;
  $4=ctxval;

  OFS=","; print $0
}' models/tmp.csv > models.csv
