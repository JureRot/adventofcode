import collections


#staring vars

replacements = collections.defaultdict(list)



with open('input2015_19.txt', 'r') as myfile:
	input = myfile.read().split('\n')


input = """H => HO
H => OH
O => HH

HOH""".split('\n')


mol = input.pop(-1)
input.pop(-1) #new line removal

print(mol)

for i in input:
	i_list = i.split(' ')
	replacements[i_list[0]].append(i_list[2])

print(replacements)

"""če prou štekam je št useh kobinacij sam št vnosov krat št možnih zmenjav tega vnosa, za vse vnose, seštet 
(ker nardimo samo eno zamenjavo (samo en input zamenjamo z outputom))

to bo verjetn neki z regexom spet (finditer)
za uak k v replacements najdemov vsa mesta in usako mesto zamenamo za vsemi možnimi
use dajemo v nek set al neki, da se ponovnitve izničjo. tada
"""