#!/usr/bin/env bash
find "$1" -follow -iname "*" -print0 | while IFS= read -r -d $'\0' file; do
    #checks if shared file/directory doesn't exists in new release folder
    relativeFile=${file#${1}}
    if ! [ -e $2$relativeFile ]; then
        ln -s "$file" "$2$relativeFile"
    fi
done;