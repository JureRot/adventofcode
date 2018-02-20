import sys
import copy


#starting vars
smallest_amount = sys.maxsize
sequence = []


boss_stats = []



with open('input2015_22.txt', 'r') as myfile:
	input = myfile.read().split('\n')


for i in input:
	i_list = i.split()
	boss_stats.append(i_list[-1])


class Entity:
	def __init__(self, hp, dmg, arm):
		self.hp = int(hp)
		self.dmg = int(dmg)
		self.arm = int(arm)

	def attack(self, opp):
		opp.hp -= max(1, self.dmg - opp.arm)


class Player(Entity):
	def __init__(self, hp, dmg, arm, mana):
		super().__init__(hp, dmg, arm)
		self.mana = mana
		self.spent = 0
		self.mt = False #attack at cast, once (4dmg)
		self.dt = False	#attack (2dmg, +2hp)
		self.st = 0 #tick at the beginning of the turn, for mutliple turns (7arm, 6turns)
		self.pt = 0 #tick (3dmg, 6turns)
		self.rt = 0 #tick (+101mana, 5turns)
		self.abilities = []

	def magicMissile(self):
		if (self.mana >= 53):
			self.mana -= 53
			self.spent += 53
			self.abilities.append('m')
			self.mt = True

	def drain(self):
		if (self.mana >= 73):
			self.mana -= 73
			self.spent += 73
			self.abilities.append('d')
			self.dt = True

	def shield(self):
		if (self.mana >= 113):
			self.mana -= 113
			self.spent += 113
			self.abilities.append('s')
			self.st = 6

	def poison(self):
		if (self.mana >= 173):
			self.mana -= 173
			self.spent += 173
			self.abilities.append('p')
			self.pt = 6

	def recharge(self):
		if (self.mana >= 229):
			self.mana -= 229
			self.spent += 229
			self.abilities.append('r')
			self.rt = 5

	def tick(self, opp):
		if (st): #we have Shield active
			self.arm = 7
			self.st -= 1
		else : #shield becomes inactive
			self.arm = 0
		if (pt): #we have Poison active
			opp.hp -= 3
			self.pt -= 1
		if (rt): #we have Recharge active
			self.mana += 101
			self.rt -= 1

	def attack(self, opp):
		if (mt): #we used Magic Missile
			opp.hp -= 4
		if (dt): #we used Drain
			opp.hp -= 2
			self.hp += 2



boss = Entity(boss_stats[0], boss_stats[1], 0)
player = Player(50, 0, 0, 500)


def game(player, boss):
	p = player
	b = boss

	p.tick(b)

	if (p.mana >= 53):
		pass

	if (p.mana >= 73):
		pass

	if (p.mana >= 113 and not p.st):
		pass

	if (p.mana >= 173 and not p.pt):
		pass

	if (p.mana >= 229 and not p.rt):
		pass



"""
p:
tick
ability
attack
chekc

b:
tick
attack
check
"""