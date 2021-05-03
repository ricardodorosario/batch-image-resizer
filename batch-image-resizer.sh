#!/bin/bash

#Example: ./batch-image-resizer.sh -d /path/to/root/directory -s 1000

helpFunction()
{
   echo ""
   echo "Usage: $0 -d /path/to/root/dir -s maxSize"
   exit 1
}

while getopts "d:s:" opt
do
   case "$opt" in
      d ) directory="$OPTARG" ;;
      s ) max="$OPTARG" ;;
      ? ) helpFunction ;;
   esac
done

if [ -z "$directory" ] || [ -z "$max" ]
then
   echo "Some of the parameters are empty";
   helpFunction
fi

# the extensions
extensions=".*\(jpg\|png\|jpeg\)$"

find "$directory" -regex "$extensions" | 
while read dir
	do
		width=$(identify -format "%w" "$dir")
		height=$(identify -format "%h" "$dir")
		if [ \( $width -gt $max \) -o \( $height -gt $max \) ]
			then
				echo "BIGGER THAN EXPECTED\n$width x $height\n$dir"
				permission=$(find "$dir" -printf "%u:%g")
				mogrify -resize 50% -quality 90 "$dir"
				chown $permission "$dir"
				echo $(identify -format "%w x %h" "$dir")
		fi
done

