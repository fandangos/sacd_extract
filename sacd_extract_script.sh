#!/bin/bash

# This script is used to find any iso files (case insensitive) and use sacd_extract tool
# to extract all the dsf files from it.
# sacd is set to output as DSF and remove the iso file after the extraction is done.
# since sacd_extract outputs to a directory I needed it to move the files to it's parents directory
# later remove the emtpty directory and fix permissions
#
# It exports the current directory as a path so sacd_extract is available whenever it moves folders
# searching for the iso files.
# It also sets sacd_extract binary as executable.
#
# This script requires root.

IFS=$'n\t'
export PATH=$PATH:$(pwd)
chmod +x "sacd_extract"

find . -iname "*.iso" -type f -exec bash -c '
IFS=$'n\t'
   cd "${1%/*}"
     echo "$PWD"
        file="${1##*/}"
          sacd_extract -2 -s -i "$file" && rm "$file"


find . -iname "*.dsf" -type f | \
      while read I
       do
          echo extracted file: "$I"
          chmod 666 "$I"
          mv "$I" "${I%/*/*}"
       done

   find . -type d -empty -delete

' bash {} \;




