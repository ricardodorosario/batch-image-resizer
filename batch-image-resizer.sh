#!/bin/sh

# the directory that the script will work
directory="/home/user/Desktop/"
# the extension
extension="*.jpg"
# max size of the file
max=1000
#permission after resize
permission="ricardo:ricardo"

find "$directory" -type f -name "$extension" | 
while read dir
	do
		width=$(identify -format "%w" "$dir")
		height=$(identify -format "%h" "$dir")
		if [ \( $width -gt $max \) -o \( $height -gt $max \) ]
			then
				echo "IS BIG $width x $height $dir"
				mogrify -resize 50% -quality 90 "$dir"
				chown $permission "$dir"
				echo $(identify -format "%w x %h" "$dir")
		fi
done

