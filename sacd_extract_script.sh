#!/bin/bash

# This script is used to find any iso files (case insensitive) and use sacd_extract tool
# to extract all the dsf files from it.

IFS=$'n\t'
export PATH=$PATH:$(pwd)
chmod +x "sacd_extract"

function ask_delete() {

echo -e "

This script is able to remove the ISO files
after a successful extraction.
this is useful to save space if you don't
need the original files anymore.

Do you want remove the iso files?

#~~~~~~~~~~~~#
| 1.) Yes    |
| 2.) No     |
| 3.) Quit   |
#~~~~~~~~~~~~#\n"

read -e -p "Please select a valid option: " delchoice

if [ "$delchoice" == "1" ]; then
export delchoice=1
echo
echo "OK. I'll remove the ISO files"

elif [ "$delchoice" == "2" ]; then
export delchoice=2
echo
echo "OK. I'll not remove the ISO files"

elif [ "$delchoice" == "3" ]; then
echo
echo "OK. Goodbye"
exit 0

else

  echo "Please select 1,2 or 3." && slep 5
  clear && ask_delete

fi
}

function ask_move() {
clear

echo -e "
When an ISO file is extracted it will be put
in a new folder by default.
This is useful if you have several ISO files
in the same directory.

This script is able to keep the DSF files in a
newly created subdirectory or move the files
to the same directory as the original ISO.

Do you want to move the DSF files?

#~~~~~~~~~~#
| 1.) Yes  |
| 2.) No   |
| 3.) Quit |
#~~~~~~~~~~#\n"

read -e -p "Please select a valid option: " movechoice

if [ "$movechoice" == "1" ]; then
export movechoice=1
echo
echo "Ok, I'll move the DSF files up".

elif [ "$movechoice" == "2" ]; then
export movechoice=2
echo
echo "Ok, I'll keep the files in their subdirectories"

elif [ "$movechoice" == "3" ]; then
echo
echo "Ok. Goodbye"
exit 0

else
  echo "Please select 1,2 or 3." && sleep 5
  clear && ask_move
fi
}

ask_delete

ask_move

if [[ -n $(find . -type f -iname "*.iso") ]]

then
find . -iname "*.iso" -type f -exec bash -c '
IFS=$'n\t'
   cd "${1%/*}"
   echo "$PWD"
     file="${1##*/}"

success=$(sacd_extract -i "$file" 2>&1 | grep -c "read Master TOC")
if [ $success == 0 ];
then
    echo File: "$file" is a valid SACD ISO file
    sacd_extract -2 -s -i "$file"
else
    echo File: "$file" is NOT a valid SACD ISO file
    echo will NOT remove it
fi

if [ $success == 0 ] && [ "$delchoice" == "1" ];
then
    echo removing the ISO file
    rm "$file"
else
    echo keeping the ISO file.
fi

find . -type f -iname "*.dsf" | while read dsffile
    do
    chmod 666 "$dsffile"

if [ "$movechoice" == "1" ]; then
    mv "$dsffile" "${dsffile%/*/*}"
    find . -type d -empty -delete
fi

    echo extracted file: "$dsffile"
done

' bash {} \;

else
echo no iso files found
fi




