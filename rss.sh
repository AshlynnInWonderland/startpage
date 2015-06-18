#!/bin/bash

parse_line(){
  str="${1/<\/*>/}";
  str="${str/<*>/}"
  echo "$str"
}

rss=$(curl $(cat ignore/url))
rss=${rss//<![CDATA[/}
rss=${rss//]]>/}
title=""
istitle=0
link=""
finished=0
counter=0
echo "" > ignore/batoto.html
while read -r line; do
  parse=$(echo "$line" | cut -d ">" -f 1)
  if [[ $parse == "<title" ]] && [[ "$line" == *"English"* ]]; then
    title=$(parse_line "$line")
    title=${title/- English -/-}
    istitle=1
    counter=$[counter+1]
  elif [[ $parse == "<link" ]] && [[ $istitle -eq 1 ]]; then
    link=$(parse_line "$line")
    istitle=0
    finished=1
  fi
  if [[ $finished -eq 1 ]]; then
    title1=$(echo "$title" | cut -d "-" -f 1)
    title1=${title1%?}:
    title2=$(echo "$title" | cut -d "-" -f 2)
    echo "<li><a href=\"$link\"><span class=\"bold\">$title1</span>$title2</a></li>" >> ignore/batoto.html
    finished=0
    if [[ $counter = 8 ]]; then
      exit;
    fi
  fi
done <<< "$rss"

