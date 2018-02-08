import json

"""
idea:
ireracija cez vse objekte v tem json fomratu (ker je dejanko legitimen json format))
uporab map(function, iterable) za rekurzijo
"""
with open('input2015_12.txt', 'r') as myfile:
	input = myfile.read()

jfile = json.loads(input)


def sum_jfile(object):
	if (type(object) == int): #if object is number, return number
		return object
	elif (type(object) == list): #if object is list, return sum of sum_jfile-s of every object in list
		return (sum(map(sum_jfile, object)))
	elif (type(object) == dict): #if object is dict, return sum of sum_jfile-s of every value in dict
		return (sum(map(sum_jfile, object.values())))
	return 0 #just for interprete's sake (could have used else: in the last occation)



print("1. sum of all numbers: ", sum_jfile(jfile))


#second part


def sum_jfile_red(object):
	if (type(object) == int):
		return object
	elif (type(object) == list):
		return (sum(map(sum_jfile_red, object)))
	elif (type(object) == dict):
		if ("red" in object.values()): #ignore if "red" is in values (to je mogoce to kar je blo narobe v prejsnme, da je "red" vedno kot vrednost, nikol kot kljuc)
			return 0
		return (sum(map(sum_jfile_red, object.values())))
	return 0


print("2. sum of all numbers ignoring red: ", sum_jfile_red(jfile))