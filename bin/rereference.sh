#!/bin/bash
# Attempt to "rename" a project and associated files

if [ "$#" -lt 3 ]; then
    echo "Usage: $0 <directory> <orig> <new>"
    exit 0
fi

DIR="$1"
ORIG="$2"
NEW="$3"

if [[ "$ORIG" =~ "/" || "$NEW" =~ "/" ]]; then
    echo "References cannot contain the / character"
    exit 1
fi

shopt -s globstar nullglob

for FILE in "$DIR"/**/**.{v,sv,do,qpf,qsf,sdc}; do
    if grep -q "$ORIG" "$FILE"; then
        echo "Modifying $FILE"
        sed --follow-symlinks -i "s/$ORIG/$NEW/g" "$FILE"
    fi

    if [[ "$FILE" =~ "$ORIG" ]]; then
        mv -v "$FILE" "${FILE//$ORIG/$NEW}"
    fi
done
