import sys
import copy


#starting vars
smallest_amount = sys.maxsize #starting size of max int

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


	def magicMissile(self): #adds 4 dmg for 1 turns
		if (self.mana>=53 and self.magicMissile_t==0):
			self.spent += 53
			self.mana -= 53
			self.magicMissile_t = 1
			self.dmg += 4

	def drain(self): #adds 2 dmg for 1 turns, restores 2 hp
		if (self.mana>=73 and self.drain_t==0):
			self.spent += 73
			self.mana -= 73
			self.drain_t = 1
			self.dmg += 2
			self.hp += 2

	def shield(self): #adds 7 armor for 6 turns
		if (self.mana>=113 and self.shield_t==0):
			self.spent += 113
			self.mana -= 113
			self.shield_t = 6
			self.armor += 7

	def poison(self): #adds 3 dmg for 6 turns (turn is either player or boss playing (one round = 2 turns)(poison ticks on players and boss' turn))
		if (self.mana>=173 and self.poison_t==0):
			self.spent += 173
			self.mana -= 173
			self.poison_t = 6
			self.dmg += 3

	def recharge(self): #restores 101 mana for 5 turns (turn either players or boss')
		if (self.mana>=229 and self.recharge_t==0):
			self.spent += 229
			self.mana -= 229
			self.recharge_t = 5

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
			if (self.poison_t == 0):
				self.dmg -= 3
		if (self.recharge_t > 0):
			self.recharge_t -= 1
			self.mana += 101


def play_turn(o1, o2): #tick, 1->2, tick, 2->1 #DONT KNOW IF THIS IS NECESSARY (MAYBE IN TE GAME LOOP/FUNCTION)
	o1.tick() #poison will count in the attack, iguess

	if (o1.dmg > 0):
		o2.hp -= max(1, o1.dmg-o2.arm)

	if (o2.hp <= 0):
		return (True)

	o1.tick()

	if (o2.dmg > 0):
		o1.hp -= max(1, o2.dmg-o1.arm)

	if (o1.hp <= 0):
		return (False)


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



def game(player, boss): #recursive method of the whole game with every possible combiantions (tick, p->b, tick, b->p)
	p = player
	b = boss

	p.tick()

	if (p.mana >= 53): #THINK ABOUT THE SEQUENCE OF EVENTS
		pM = copy.deepcopy(p)
		bM = copy.deepcopy(b)
		##pM.magicMissile()
		game(pM, bM)

	if (p.mana >= 73):
		pD = copy.deepcopy(p)
		bD = copy.deepcopy(b)
		game(pD, bD)

	if (p.mana >= 113):
		pS = copy.deepcopy(p)
		bS = copy.deepcopy(b)
		game(pS, bS)

	if (p.mana >= 173):
		pP = copy.deepcopy(p)
		bP = copy.deepcopy(b)
		game(pP, bP)

	if (p.mana >= 229):
		pR = copy.deepcopy(p)
		bR = copy.deepcopy(b)
		game(pR, bR)


boss = Entity(boss_stats[0], boss_stats[1], 0)

player = Player(50, 0, 0, 500)

game(player, boss)

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