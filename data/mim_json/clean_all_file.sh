

for file in `ls $1`
do
	if [ ${file:0-5} == ".json" ]
	then
		echo "clean $file"
		./clean_json.py $file
	else
		echo "Not a json file need to be clean: $file"
	fi
done
