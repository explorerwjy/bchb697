#!/bin/bash


count=0
for FILE in `ls $1`
do 
	if [ ${FILE:0-8} == ".cleaned" ]
	then
		echo "insert $FILE into MONGODB"
		mongoimport --db mydb --collection omim --file $FILE
		count=$((count+1))
	else
		echo "Not a cleaned json file to insert $FILE"
	fi
done
echo "$count document inserted"
