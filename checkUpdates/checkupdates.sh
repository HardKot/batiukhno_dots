#!/usr/bin/env bash

updates="$(checkupdates)"
count=$(checkupdates | wc -l)

alt="has-updates"

if [ $count -eq 0 ]; then
  alt="updated"
fi

echo "{ \"text\": \"${updates//$'\n'/\\n}\", \"alt\": \"$alt\" }"

