#!/bin/bash
OLDIFS=$IFS
IFS=","
idx=0
rm *.yml
while read tag en pt es; do
  if [[ "$idx" -gt 0 ]]; then
    echo -e "$(echo -e "$tag" | sed -e 's/[- ]/_/g'): $en" >> en.yml
    echo -e "$(echo -e "$tag" | sed -e 's/[- ]/_/g'): $pt" >> pt-BR.yml
    echo -e "$(echo -e "$tag" | sed -e 's/[- ]/_/g'): $es" >> es.yml
  fi
  idx=$((idx+1))
done < $1
IFS=$OLDIFS
