import collections
import itertools


#starting vars
ingredients = collections.defaultdict(dict)

cookie_score = 0
best_cookie = []

#second part
cookie_score2 = 0
best_cookie2 = []



with open('input2015_15.txt', 'r') as myfile:
	input = myfile.read().split('\n')


for i in input:
	i_list = i.split(' ')
	ingredients[i_list[0][:-1]][i_list[1]] = int(i_list[2][:-1]) #sets the ingredients dict name:{capa:, dura:, flav:, text:, calo:,}
	ingredients[i_list[0][:-1]][i_list[3]] = int(i_list[4][:-1])
	ingredients[i_list[0][:-1]][i_list[5]] = int(i_list[6][:-1])
	ingredients[i_list[0][:-1]][i_list[7]] = int(i_list[8][:-1])
	ingredients[i_list[0][:-1]][i_list[9]] = int(i_list[10]) #not necessarily needed


all_recipes = itertools.combinations_with_replacement(ingredients.keys(), 100) #makes all possible combinations (with repetitions) of 100 elements of ingredients


for i in all_recipes: #for every possible combination
	temp_capa = 0
	temp_dura = 0
	temp_flav = 0
	temp_text = 0
	temp_calo = 0
	for j in i: #goes over all 100 teaspoones of ingredients
		temp_capa += ingredients[j]["capacity"]
		temp_dura += ingredients[j]["durability"]
		temp_flav += ingredients[j]["flavor"]
		temp_text += ingredients[j]["texture"]
		temp_calo += ingredients[j]["calories"] #not necessarily needed

	temp_score = max(0, temp_capa) * max(0, temp_dura) * max(0, temp_flav) * max(0, temp_text) #negative values are replaced with 0
	
	if (temp_score > cookie_score):
		cookie_score = temp_score
		best_cookie = i

	#second part
	if (temp_calo == 500):
		if (temp_score > cookie_score2):
			cookie_score2 = temp_score
			best_cookie2 = i


print("1. the total score of the best cookie: ", cookie_score)

print("2. the total score of the best cookie with 500 calories: ", cookie_score2)