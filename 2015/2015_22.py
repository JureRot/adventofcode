import sys
import copy


#starting vars
smallest_amount = sys.maxsize #starting size of max int
smallest_amount2 = sys.maxsize

sequence = []
sequence2 = []

spells = ["m", "d", "s", "p", "r"] #m=magicMissile, d=drain, s=shield, p=poison, r=recharge

boss_stats = []


with open('input2015_22.txt', 'r') as myfile:
	input = myfile.read().split('\n')



class Entity:
	def __init__(self, hp, dmg, arm):
		self.hp = int(hp)
		self.dmg = int(dmg)
		self.arm = int(arm)

class Player(Entity):
	def __init__(self, hp, dmg, arm, mana):
		super().__init__(hp, dmg, arm)
		self.mana = mana
		self.spent = 0
		self.magicMissile_t = 0
		self.drain_t = 0
		self.shield_t = 0
		self.poison_t = 0
		self.recharge_t = 0
		self.abilities = []


	def magicMissile(self): #adds 4 dmg for 1 turns
		if (self.mana>=53 and self.magicMissile_t==0):
			self.spent += 53
			self.mana -= 53
			self.magicMissile_t = 1
			self.dmg += 4
			self.abilities.append("m")

	def drain(self): #adds 2 dmg for 1 turns, restores 2 hp
		if (self.mana>=73 and self.drain_t==0):
			self.spent += 73
			self.mana -= 73
			self.drain_t = 1
			self.dmg += 2
			self.hp += 2
			self.abilities.append("d")

	def shield(self): #adds 7 armor for 6 turns
		if (self.mana>=113 and self.shield_t==0):
			self.spent += 113
			self.mana -= 113
			self.shield_t = 6
			self.arm += 7
			self.abilities.append("s")

	def poison(self): #adds 3 dmg for 6 turns (turn is either player or boss playing (one round = 2 turns)(poison ticks on players and boss' turn))
		if (self.mana>=173 and self.poison_t==0):
			self.spent += 173
			self.mana -= 173
			self.poison_t = 6
			#self.dmg += 3
			self.abilities.append("p")

	def recharge(self): #restores 101 mana for 5 turns (turn either players or boss')
		if (self.mana>=229 and self.recharge_t==0):
			self.spent += 229
			self.mana -= 229
			self.recharge_t = 5
			self.abilities.append("r")

	def tick(self):
		if (self.magicMissile_t > 0):
			self.magicMissile_t -= 1
			self.dmg -= 4
		if (self.drain_t > 0):
			self.drain_t -= 1
			self.dmg -= 2
		if (self.shield_t > 0):
			self.shield_t -= 1
			if (self.shield_t == 0):
				self.arm -= 7
		if (self.poison_t > 0):
			self.poison_t -= 1
			#if (self.poison_t == 0):
				#self.dmg -= 3
		if (self.recharge_t > 0):
			self.recharge_t -= 1
			self.mana += 101


"""def play_turn(o1, o2): #tick, 1->2, tick, 2->1 #DONT KNOW IF THIS IS NECESSARY (MAYBE IN TE GAME LOOP/FUNCTION)
	o1.tick() #poison will count in the attack, iguess

	if (o1.dmg > 0):
		o2.hp -= max(1, o1.dmg-o2.arm)

	if (o2.hp <= 0):
		return (True)

	o1.tick()

	if (o2.dmg > 0):
		o1.hp -= max(1, o2.dmg-o1.arm)

	if (o1.hp <= 0):
		return (False)"""


for i in input:
	i_list = i.split()
	boss_stats.append(i_list[-1])

"""b = copy.deepcopy(a)

a.hp = 25

print(a.hp, b.hp)

print(a.mana)
a.recharge()
print(a.mana)
play_turn(a, boss)
print(a.mana)
play_turn(a, boss)
print(a.mana)
play_turn(a, boss)
print(a.mana)
play_turn(a, boss)
print(a.mana)
play_turn(a, boss)
print(a.mana)
play_turn(a, boss)"""



def game(player, boss, hard): #recursive method of the whole game with every possible combiantions (tick, p->b, tick, b->p)
	global smallest_amount
	global sequence
	global smallest_amount2
	global sequence2

	p = player
	b = boss

	print(p.abilities)

	if (hard):
		p.hp -= 1
	if (p.hp <= 0):
		#print("lose")
		return (False)

	if (p.poison_t > 0):
		b.hp -= 3
	p.tick()

	if (p.mana>=53 and p.magicMissile_t==0): #THINK ABOUT THE SEQUENCE OF EVENTS
		pM = copy.deepcopy(p)
		bM = copy.deepcopy(b)

		pM.magicMissile()

		if (pM.dmg > 0):
			bM.hp -= max(1, pM.dmg-bM.arm)

		if (bM.hp <= 0):
			#print("win", pM.abilities, pM.spent)
			if (hard):
				if (pM.spent < smallest_amount2):
					smallest_amount2 = pM.spent
					sequence2 = pM.abilities
				return (True)
			else:
				if (pM.spent < smallest_amount):
					smallest_amount = pM.spent
					sequence = pM.abilities
				return (True) #just an stop sentence (so it wont go on forever)

		if (pM.poison_t > 0):
			bM.hp -= 3
		pM.tick() #this tick needs to apply the damage to boss
		if (pM.dmg > 0):
			bM.hp -= max(1, pM.dmg-bM.arm)

		if (bM.hp <= 0):
			#print("win", pM.abilities, pM.spent)
			if (hard):
				if (pM.spent < smallest_amount2):
					smallest_amount2 = pM.spent
					sequence2 = pM.abilities
				return (True)
			else:
				if (pM.spent < smallest_amount):
					smallest_amount = pM.spent
					sequence = pM.abilities
				return (True)


		if (bM.dmg > 0):
			pM.hp -= max(1, bM.dmg-pM.arm)

		if (pM.hp <= 0):
			#print("lose", pM.abilities)
			return (False)

		game(pM, bM, hard)

	if (p.mana>=73 and p.drain_t==0):
		pD = copy.deepcopy(p)
		bD = copy.deepcopy(b)

		pD.drain()

		if (pD.dmg > 0):
			bD.hp -= max(1, pD.dmg-bD.arm)

		if (bD.hp <= 0):
			#print("win", pD.abilities, pD.spent)
			if (hard):
				if (pD.spent < smallest_amount2):
					smallest_amount2 = pD.spent
					sequence2 = pD.abilities
				return (True)
			else:
				if (pD.spent < smallest_amount):
					smallest_amount = pD.spent
					sequence = pD.abilities
				return (True)

		if (pD.poison_t > 0):
			bD.hp -= 3
		pD.tick()
		if (pD.dmg > 0):
			bD.hp -= max(1, pD.dmg-bD.arm)

		if (bD.hp <= 0):
			#print("win", pD.abilities, pD.spent)
			if (hard):
				if (pD.spent < smallest_amount2):
					smallest_amount2 = pD.spent
					sequence2 = pD.abilities
				return (True)

			else:
				if (pD.spent < smallest_amount):
					smallest_amount = pD.spent
					sequence = pD.abilities
				return (True)


		if (bD.dmg > 0):
			pD.hp -= max(1, bD.dmg-pD.arm)

		if (pD.hp <= 0):
			#print("lose", pD.abilities)
			return (False)

		game(pD, bD, hard)

	if (p.mana>=113 and p.shield_t==0):
		pS = copy.deepcopy(p)
		bS = copy.deepcopy(b)

		pS.shield()

		if (pS.dmg > 0):
			bS.hp -= max(1, pS.dmg-bS.arm)

		if (bS.hp <= 0):
			#print("win", pS.abilities, pS.spent)
			if (hard):
				if (pS.spent < smallest_amount2):
					smallest_amount2 = pS.spent
					sequence2 = pS.abilities
				return (True)
			else:
				if (pS.spent < smallest_amount):
					smallest_amount = pS.spent
					sequence = pS.abilities
				return (True)

		if (pM.poison_t > 0):
			bM.hp -= 3
		pM.tick()
		if (pS.dmg > 0):
			bS.hp -= max(1, pS.dmg-bS.arm)

		if (bS.hp <= 0):
			#print("win", pS.abilities, pS.spent)
			if (hard):
				if (pS.spent < smallest_amount2):
					smallest_amount2 = pS.spent
					sequence2 = pS.abilities
				return (True)
			else:
				if (pS.spent < smallest_amount):
					smallest_amount = pS.spent
					sequence = pS.abilities
				return (True)


		if (bS.dmg > 0):
			pS.hp -= max(1, bS.dmg-pS.arm)

		if (pS.hp <= 0):
			#print("lose", pS.abilities)
			return (False)

		game(pS, bS, hard)

	if (p.mana>=173 and p.poison_t==0):
		pP = copy.deepcopy(p)
		bP = copy.deepcopy(b)

		pP.poison()

		if (pP.dmg > 0): #poison does damage only at the beginning of the turn
			bP.hp -= max(1, pP.dmg-bP.arm)

		if (bP.hp <= 0):
			#print("win", pP.abilities, pP.spent)
			if (hard):
				if (pP.spent < smallest_amount2):
					smallest_amount2 = pP.spent
					sequence2 = pP.abilities
				return (True)
			else:
				if (pP.spent < smallest_amount):
					smallest_amount = pP.spent
					sequence = pP.abilities
				return (True)

		if (pP.poison_t > 0):
			bP.hp -= 3
		pP.tick()
		if (pP.dmg > 0):
			bP.hp -= max(1, pP.dmg-bP.arm)

		if (bP.hp <= 0):
			#print("win", pP.abilities, pP.spent)
			if (hard):
				if (pP.spent < smallest_amount2):
					smallest_amount2 = pP.spent
					sequence2 = pP.abilities
				return (True)
			else:
				if (pP.spent < smallest_amount):
					smallest_amount = pP.spent
					sequence = pP.abilities
				return (True)


		if (bP.dmg > 0):
			pP.hp -= max(1, bP.dmg-pP.arm)

		if (pP.hp <= 0):
			#print("lose", pP.abilities)
			return (False)

		game(pP, bP, hard)

	if (p.mana>=229 and p.recharge_t==0):
		pR = copy.deepcopy(p)
		bR = copy.deepcopy(b)

		pR.recharge()

		if (pR.dmg > 0):
			bR.hp -= max(1, pR.dmg-bR.arm)

		if (bR.hp <= 0):
			#print("win", pR.abilities, pR.spent)
			if (hard):
				if (pR.spent < smallest_amount2):
					smallest_amount2 = pR.spent
					sequence2 = pR.abilities
				return (True)
			else:
				if (pR.spent < smallest_amount):
					smallest_amount = pR.spent
					sequence = pR.abilities
				return (True)

		if (pR.poison_t > 0):
			bR.hp -= 3
		pR.tick()
		if (pR.dmg > 0):
			bR.hp -= max(1, pR.dmg-bR.arm)

		if (bR.hp <= 0):
			#print("win", pR.abilities, pR.spent)
			if (hard):
				if (pR.spent < smallest_amount2):
					smallest_amount2 = pR.spent
					sequence2 = pR.abilities
				return (True)
			else:
				if (pR.spent < smallest_amount):
					smallest_amount = pR.spent
					sequence = pR.abilities
				return (True)


		if (bR.dmg > 0):
			pR.hp -= max(1, bR.dmg-pR.arm)

		if (pR.hp <= 0):
			#print("lose", pR.abilities)
			return (False)

		game(pR, bR, hard)




boss = Entity(boss_stats[0], boss_stats[1], 0)

player = Player(50, 0, 0, 500)

game(player, boss, False)

print("1. the smallest amount of mana spent for defeating the boss:", smallest_amount)


#second part
boss = Entity(boss_stats[0], boss_stats[1], 0)

player = Player(50, 0, 0, 500)

game(player, boss, True)

print("2. the smallest amount of mana spent for defeating the boss on hard difficulty:", smallest_amount2)

"""
every round we need to make a copy of player and boss for every possible spell.
and we we go in depht for every copy (recursion???, that sounds fine)
"""


"""
idea: Classes again. Player (subclass of Entity) has methods for all the spells (and timers for them)
the combinations are the sequences of attacs (there are quite a few possible) (HOW WILL THEY BE PASSED TO THE CLASS, OR ARE THERE MORE INSTANCES OF SAME CLASS???)
(calling a objects method by its name???)
the best combination is the one which spends the least ammount of mana (rechargins is not counted as negative spending)

probably depth-first-search (at each branching we go till we win or lose, than we backtract till the point which still has an unvisitited branching)
We will still have to go over all of the branching to be sure we found the one with the smallest spending
"""

#DONT KNOW WHY BUT THIS DOESNT WORK PROPERLY. ITS ALL A MESS. TRY A NEW, CLEAN AND SIMPLE