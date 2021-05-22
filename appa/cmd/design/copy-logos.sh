#!/bin/bash
# shellcheck source=./../../functions/cmd_start.sh
source "${APPA_FUNCTIONS_HOME}/cmd_start.sh"

current_logos="${APPA_DESIGN}/"
web_logos="${APPA_WEB_PUBLIC}/wp-content/uploads/"

mapfile -t result < <(find "${current_logos}" -mindepth 1 -type f -not -path '*/.private/*' -not -path '*/_*' \( -path '*.png' -or -path '*.svg' \) )

length=${#result[@]}

for ((index=0; index < length; index++)); do

    progressStep=$((index+1))
    progressLength=$((length+1))

    item="${result[index]}"

    if [ "${item}" == "" ] ;
    then
        progressBar "Copy logo:" ${progressStep} ${progressLength}
        continue
    fi    
    
    newpath="${item//$current_logos/$web_logos}"
    filename=$(basename "$newpath")

    copyfile "${item}" "${newpath}"    
    progressBar "${filename}" ${progressStep} ${progressLength}

done
echo
echo
note "Finished copying $length logos!"

git_command="git --git-dir ${APPA_WEB_PUBLIC}/.git --work-tree ${APPA_WEB_PUBLIC}"
if ! $git_command add "${APPA_WEB_PUBLIC}" ; then
    exit 1
fi
if ! $git_command commit -m "Updating logos"  ; then
    exit 1
fi
if ! $git_command push ; then
    exit 1
fi

success 'Updated logos and pushed changes!'