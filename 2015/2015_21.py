


#starting vars
smallest_cost = 1000
items_bought = []

largest_cost = 0
items_bought2 = []

shop = dict() #dict inside a dict inside dict ???, dictseption / value of type (weapon, armor, ring)

boss_stats = []

with open('input2015_21.txt', 'r') as myfile: #NOTE: THE INPUT FOR THIS EXCERCISE IS EDITED
	input = myfile.read().split('\n')


class Entity:
	def __init__(self, hp, dmg, arm):
		self.hp = int(hp)
		self.dmg = int(dmg)
		self.arm = int(arm)


class Player(Entity):
	def __init__(self, hp, dmg, arm):
		super().__init__(hp, dmg, arm)
		self.cost = 0
		self.bought = []

	def buy(self, item_name):
		self.bought.append(item_name)
		if (item_name in shop["weapons"]):
			self.cost += shop["weapons"][item_name]["cost"]
			self.dmg += shop["weapons"][item_name]["damage"]
			self.arm += shop["weapons"][item_name]["armor"]
		elif (item_name in shop["armor"]):
			self.cost += shop["armor"][item_name]["cost"]
			self.dmg += shop["armor"][item_name]["damage"]
			self.arm += shop["armor"][item_name]["armor"]
		elif (item_name in shop["rings"]):
			self.cost += shop["rings"][item_name]["cost"]
			self.dmg += shop["rings"][item_name]["damage"]
			self.arm += shop["rings"][item_name]["armor"]
		


def figth(o1, o2): #01 goes first. True if o1 wins, False if 02 wins
	hp1 = o1.hp
	hp2 = o2.hp

	while (hp1>0 and hp2>0):
		hp2 -= max(1, o1.dmg-o2.arm)
		if (hp2 <= 0):
			return (True)

		hp1 -= max(1, o2.dmg-o1.arm)
		if (hp1 <= 0):
			return (False)


def check_cost_low(o): #if cost of item lower than smallest_cost, changes the values and sets the bouth items
	global smallest_cost
	global items_bought

	if (o.cost < smallest_cost):
		smallest_cost = o.cost
		items_bought = o.bought


def check_cost_high(o): #if cost of item greater than largest_cost, changes the values and sets the bouth items2
	global largest_cost
	global items_bought2

	if (o.cost > largest_cost):
		largest_cost = o.cost
		items_bought2 = o.bought
		



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


#we need to check all of those. Probably some clever way, nah, just hardcode it
#1 weapon (out of 5)

#1 armor (out of 5)
	#1 weapon (out of 5)

#1 ring (out of 6)
	#1 weapon (out of 5)

	#1 armor (out of 5)
		#1 weapon (out of 5)

#2 rings (out of 6, no repetition)
	#1 weapon (out of 5)

	#1 armor (out of 5)
		#1 weapon (out of 5)


for i in shop["weapons"].keys(): # 0 rings, 0 armor, 1 weapon
	p = Player(100, 0, 0) #create a player with starting stats
	p.buy(i) #buy all the items
	if (figth(p, boss)): #if player defeats the boss
		check_cost_low(p) #check if cost lower, and repalce if is
	else: #if player looses
		check_cost_high(p) #check if cost higher, and replace if is (for second part)

for j in shop["armor"].keys(): # 0 rings, 1 armor, 1 weapon
	for i in shop["weapons"].keys():
		p = Player(100, 0, 0)
		p.buy(j)
		p.buy(i)
		if (figth(p, boss)):
			check_cost_low(p)
		else:
			check_cost_high(p)


for k in shop["rings"].keys(): # 1 ring, 0 armor, 1 weapon 
	for i in shop["weapons"].keys():
		p = Player(100, 0, 0)
		p.buy(k)
		p.buy(i)
		if (figth(p, boss)):
			check_cost_low(p)
		else:
			check_cost_high(p)

for k in shop["rings"].keys(): # 1 ring, 1 armor, 1 weapon
	for j in shop["armor"].keys():
		for i in shop["weapons"].keys():
			p = Player(100, 0, 0)
			p.buy(k)
			p.buy(j)
			p.buy(i)
			if (figth(p, boss)):
				check_cost_low(p)
			else:
				check_cost_high(p)

for k1 in shop["rings"].keys(): # 2 diff rings, 0 armor, 1 weapon
	for k2 in shop["rings"].keys():
		if (k1 != k2):
			for i in shop["weapons"].keys():
				p = Player(100, 0, 0)
				p.buy(k1)
				p.buy(k2)
				p.buy(i)
				if (figth(p, boss)):
					check_cost_low(p)
				else:
					check_cost_high(p)

for k1 in shop["rings"].keys(): # 2 diff rings, 1 armor, 1 weapon
	for k2 in shop["rings"].keys():
		if (k1 != k2):
			for j in shop["armor"].keys():
				for i in shop["weapons"].keys():
					p = Player(100, 0, 0)
					p.buy(k1)
					p.buy(k2)
					p.buy(j)
					p.buy(i)
					if (figth(p, boss)):
						check_cost_low(p)
					else:
						check_cost_high(p)


print("1. the smallest cost of items allowing us to still defeat the boss: ", smallest_cost)


#second part (most spent, still lose) (we add an new funct for check cost which is exectued only when we lose)

print("1. the largest ammount of money we can spend and still lose to the boss:", largest_cost)
