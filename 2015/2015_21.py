


#starting vars
shop = dict() #dict inside a dict inside dict ???, dictseption / value of type (weapon, armor, ring)

boss_stats = []

with open('input2015_21.txt', 'r') as myfile:
	input = myfile.read().split('\n')


class Entity:
	def __init__(self, hp, dmg, arm):
		self.hp = hp
		self.dmg = dmg
		self.arm = arm


class Player(Entity):
	def __init__(self, hp, dmg, arm):
		super().__init__(hp, dmg, arm)
		self.cost = 0

	def buy(self, item):
		self.cost += item["cost"]
		self.dmg += item["damage"]
		self.arm += item["armor"]



counter = 0

for i in input:
	i_list = i.split() #ignores repeating spaces

	if (not i_list): #if i is an empty line
		counter += 1
		continue #skips this iteration, but doest break the loop

	if (counter == 0): #weapons
		if (i_list[0] == "Weapons:"): #first line is udes to make a dict inside a dict
			shop["weapons"] = dict()
		else: #every other line is used to add the item in the shop with the dict of cost and values it provides
			shop["weapons"][i_list[0]] = {"cost":int(i_list[1]), "damage":int(i_list[2]), "armor":int(i_list[3])}

	elif (counter == 1): #armor
		if (i_list[0] == "Armor:"):
			shop["armor"] = dict()
		else:
			shop["armor"][i_list[0]] = {"cost":int(i_list[1]), "damage":int(i_list[2]), "armor":int(i_list[3])}

	elif (counter == 2): #rings
		if (i_list[0] == "Rings:"):
			shop["rings"] = dict()
		else:
			shop["rings"][i_list[0]+" "+i_list[1]] = {"cost":int(i_list[2]), "damage":int(i_list[3]), "armor":int(i_list[4])} #name of rings is made of two words

	elif (counter == 3): #boss
		boss_stats.append(i_list[-1]) #record the boss stats, that can than be used to make an object



boss = Entity(boss_stats[0], boss_stats[1], boss_stats[2]) #make an Entity of boss using the boss_stats read from input

player = Player(100, 0, 0)


for k1, v1 in shop.items(): #ok ,to dela, dej je treba pa prou narest
	for k2, v2 in v1.items():
		player.buy(v2)

print(player.cost)

"""
we have 100 hp
we must buy exactly 1 weapon
we can but up to 1 armor
we can but up to 2 rings (but not two of the same kind)
"""


#idea: class za player pa boss, in pol mamo funkcijo battle ki postopoma obema zbija tocke glede na napad (mau za povadt classe v pythonu)