#!/bin/bash


count=0
for FILE in `ls $1`
do 
	if [ ${FILE:0-5} == ".json" ]
	then
		echo "insert $FILE into MONGODB"
		mongoimport --db mydb --collection gene --file $FILE
		count=$((count+1))
	else
		echo "Not a cleaned json file to insert $FILE"
	fi
done
echo "$count document inserted"
