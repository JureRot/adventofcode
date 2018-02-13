import collections


#starting vars
true_sue = {"children": 3, #create the true sue we got from the reading
	"cats": 7,
	"samoyeds": 2,
	"pomeranians": 3,
	"akitas": 0,
	"vizslas": 0,
	"goldfish": 5,
	"trees": 3,
	"cars": 2,
	"perfumes": 1}


sues = collections.defaultdict(dict) #reserve space for all sues



with open('input2015_16.txt', 'r') as myfile:
	input = myfile.read().split('\n')


for i in input:
	i_list = i.replace(',', '').replace(':', '').split(' ') #for every sue we create a dict for her three values we remembered
	sues[int(i_list[1])][i_list[2]] = int(i_list[3])
	sues[int(i_list[1])][i_list[4]] = int(i_list[5])
	sues[int(i_list[1])][i_list[6]] = int(i_list[7])


def check_trueness(v):
	match = True

	if ("children" in v): #for every possible value we check if given sue has it -> if true -> if it doesnt match the true, we return false
		if (v["children"] != true_sue["children"]):
			match = False
			return match
	if ("cats" in v):
		if (v["cats"] != true_sue["cats"]):
			match = False
			return match
	if ("samoyeds" in v):
		if (v["samoyeds"] != true_sue["samoyeds"]):
			match = False
			return match
	if ("pomeranians" in v):
		if (v["pomeranians"] != true_sue["pomeranians"]):
			match = False
			return match
	if ("akitas" in v):
		if (v["akitas"] != true_sue["akitas"]):
			match = False
			return match
	if ("vizslas" in v):
		if (v["vizslas"] != true_sue["vizslas"]):
			match = False
			return match
	if ("goldfish" in v):
		if (v["goldfish"] != true_sue["goldfish"]):
			match = False
			return match
	if ("trees" in v):
		if (v["trees"] != true_sue["trees"]):
			match = False
			return match
	if ("cars" in v):
		if (v["cars"] != true_sue["cars"]):
			match = False
			return match
	if ("perfumes" in v):
		if (v["perfumes"] != true_sue["perfumes"]):
			match = False
			return match

	return match



for k, v in sues.items(): #for every sue
	if (check_trueness(v)): #if what we remember matches the reading
		print("1. the Sue who sent the gift: ", k)
		break #break not needed, because only one correct value (still nice ho have)



#second part (a bad copy)
def check_trueness2(v):
	match = True

	if ("children" in v):
		if (v["children"] != true_sue["children"]):
			match = False
			return match
	if ("cats" in v):
		if (v["cats"] <= true_sue["cats"]): #true_sue is a reading. reading is more than reality -> if less or equal it is wrong (reverse logic)
			match = False
			return match
	if ("samoyeds" in v):
		if (v["samoyeds"] != true_sue["samoyeds"]):
			match = False
			return match
	if ("pomeranians" in v):
		if (v["pomeranians"] >= true_sue["pomeranians"]):
			match = False
			return match
	if ("akitas" in v):
		if (v["akitas"] != true_sue["akitas"]):
			match = False
			return match
	if ("vizslas" in v):
		if (v["vizslas"] != true_sue["vizslas"]):
			match = False
			return match
	if ("goldfish" in v):
		if (v["goldfish"] >= true_sue["goldfish"]):
			match = False
			return match
	if ("trees" in v):
		if (v["trees"] <= true_sue["trees"]):
			match = False
			return match
	if ("cars" in v):
		if (v["cars"] != true_sue["cars"]):
			match = False
			return match
	if ("perfumes" in v):
		if (v["perfumes"] != true_sue["perfumes"]):
			match = False
			return match

	return match



for k, v in sues.items():
	if (check_trueness2(v)):
		print("2. the Sue who sent the gift accounting for the MFCSAM's outdated retroencabulator: ", k)
		break #break not needed, because only one correct value (still nice ho have)