#!/bin/bash

# Crappy xml parser than only really works for RSS because it breaks on attributes
parse_line(){
  str="${1/<\/*>/}";
  str="${str/<*>/}"
  echo "$str"
}

# Fetches feed
rss=$(curl $(cat ignore/url))

# Removes pointless CDATA tags
rss=${rss//<![CDATA[/}
rss=${rss//]]>/}

# Get ready to loop
title=""
istitle=0
link=""
finished=0
counter=0

# Clear file first tho
echo "" > ignore/batoto.html

# More complicated than it needs to be
while read -r line; do
  
  # Separates into < + tag
  # Ex: <title> -> <title
  # Probably could be done a different cuter way
  parse=$(echo "$line" | cut -d ">" -f 1)
  
  # if it's a title make $title equal it or if it's a link make $link equal it -- nothing complicated
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

  # If there's a title and a link, clear both and format it to html then spit it out
  if [[ $finished -eq 1 ]]; then
    title1=$(echo "$title" | cut -d "-" -f 1)
    title1=${title1%?}:
    title2=$(echo "$title" | cut -d "-" -f 2)
    echo "<li><a target=\"_blank\" href=\"$link\"><span class=\"bold\">$title1</span>$title2</a></li>" >> ignore/batoto.html
    finished=0
    
    # If there's 8 entries now, quit out the program
    if [[ $counter = 8 ]]; then
      exit;
    fi
  fi
# pipes content of $rss to the loop
done <<< "$rss"
