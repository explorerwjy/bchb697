#!bin/bash

for FILE in `ls $1`
do
	if [ ${FILE:0-4} == ".xml" ]
	then
		echo "convert" $FILE "to json"
		new_file="${FILE:0:6}.json" 
		./xml2json.py -o $new_file $FILE
	else
		echo "Not a xml file: "${FILE:0-4}
	fi

done

