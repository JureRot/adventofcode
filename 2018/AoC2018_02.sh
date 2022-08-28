file="./AoC2018_02_input"
input=$(<AoC2018_02_input)

function part_1 () {
	# idea: go line by line character by character and have counter for each character and at the end see if any occurred twice or three times
	# ides2 (maybe bash): sort string, count character by character and on character change see if segment lenght was 2 or 3
	# idea3 (maybe bash): sort string, add character on character change (sed) and split by that character, see if lenght of segments 2 or 3
	# https://stackoverflow.com/questions/2373874/how-to-sort-characters-in-a-string

	# read file directly line by line instead of reading it all to a variable
	while read -r line; do
		#echo "$line"
		#echo `seq 10`
		#for i in $(seq ${#line}); do
		for i in $(seq 0 $((${#line}-1))); do
		#for ((i=0; i<"${#line}"; i++)); do
			echo "${line:$i:1}"
		done
		echo ""
	done <<< "$input"
	# done < $file #alternative to read direcly from file
}

part_1
