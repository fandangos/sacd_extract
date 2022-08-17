#!/bin/bash

# This script is used to find any iso files (case insensitive) and use sacd_extract tool to extract all the dsf files from it.
# sacd is set to output as DSF and remove the iso file after the extraction is done.
# since sacd_extract outputs to a directory I needed it to move the files to it's parents directory
# later remove the emtpty directory and fix permissions
#
# Very user dependent and I made it for my personal use and might be useful for someone else.
# requires sacd_extract to be available system wide (move it to /usr/bin)

find . -iname "*.iso" -type f -exec bash -c '
   cd "${1%/*}"
     echo "$PWD"
        file="${1##*/}"
          sacd_extract -2 -s -i "$file" && rm "$file"


find . -iname "*.dsf" -type f | \
      while read I
        do
          mv "$I" "${I%/*/*}"
       done

   find . -type d -empty -delete

   chmod -R 777 *

' bash {} \;





