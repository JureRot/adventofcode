import json

"""
idea:
ireracija cez vse objekte v tem json fomratu (ker je dejanko legitimen json format))
uporab map(function, iterable) za rekurzijo
"""
with open('input2015_12.txt', 'r') as myfile:
	input = myfile.read()

jfile = json.loads(input)

print(type(jfile) == dict)